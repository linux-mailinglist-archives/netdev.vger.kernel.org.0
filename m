Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 664DA4C63CB
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 08:29:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233629AbiB1HaF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 02:30:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233445AbiB1HaF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 02:30:05 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BF5322BD7
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 23:29:27 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id bt13so18712839ybb.2
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 23:29:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hVtQXb6j5qgMke1oJJiQu1eB89wJNXtFaOHIWxcmQ30=;
        b=q/Qt/vRmXjrp+97J2egPu7hOGZXDX0o83/3/dXrvkEJuJyJhtD6Svf4EWLMc3D18Lu
         2OFFpP+cYVhsPrr+T1hMuGj7z+p7nwbUc5BNwZNO3sYW9E83AdquaO/aYgvtgUf5LcSL
         Ndu2IWqmdob0TGivqpAr4b4kA1FSecnrS2De71wBNqMA7wbLJjgSrJM89mIPqjS2uD/f
         KpvfAbaVjFd7TkjSgw+E+TGH48l84LE7Pl092hFqmyEg5By4g5WPSEafRv0KnukKTkJ3
         Y/4BHCdEqkc0Cx0SXEs8gGVH74lvD/94lGRdANmFI94atReCzY3YfYA+I5B/xH+PBw2T
         yJlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hVtQXb6j5qgMke1oJJiQu1eB89wJNXtFaOHIWxcmQ30=;
        b=Pxnv9cz5SEQ9A65gc8z6q5q4mczXy7z7oWBmLxXVmm/g8l0WJCRPClccqmK3KftF0l
         mHrktNvnHnfH/Dd57yZ2wZDxpGq6eP+gBocR0Sb8yJbZfSY5vNT5xyaF1MkS/jeknWkS
         8Uhx6bnmAAJeeDC7x6zZbdkpCN4Fc3y5xhdRymG8d1mTY8b8JVfmThwDDNr0O/bpwsaE
         gLQ5MBvjB/b8ufUmydRNis+0zT6ROGYk9qWb+iDLQKTnXsG6KSy8kfR450I9cEtt9hzO
         S3sEMmVe9SDLSyFjqmKOOf0+gLcoIACywvllS9JJyRWmWjAaT8y89PVyED9vsF3KzRND
         jMZw==
X-Gm-Message-State: AOAM531wSEJ/C5BdbhR29nE1PAdbNaQR7CJvwLs44B21YPg3DAryDP2V
        VZggaDit3WIrnjJeQOaLWZ18UGf5ZdT6gc9roiB+Pg==
X-Google-Smtp-Source: ABdhPJzmXVIWHLKuIGMh/5xNZp9yuTGtrnUJv+J/uDAhVqGnhAmaGDgGvr6W47Qdze02fDySmADcJp/vfS3eWQfNSQM=
X-Received: by 2002:a25:90e:0:b0:624:43ec:ec9f with SMTP id
 14-20020a25090e000000b0062443ecec9fmr17089827ybj.579.1646033366388; Sun, 27
 Feb 2022 23:29:26 -0800 (PST)
MIME-Version: 1.0
References: <1645810914-35485-1-git-send-email-jdamato@fastly.com>
 <1645810914-35485-3-git-send-email-jdamato@fastly.com> <9b688d6a-851f-0e14-bdc8-8581a3dd31b5@redhat.com>
In-Reply-To: <9b688d6a-851f-0e14-bdc8-8581a3dd31b5@redhat.com>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Mon, 28 Feb 2022 09:28:50 +0200
Message-ID: <CAC_iWj+LQA_1Q4JdR3ZYSZtCeUOjrgF2EEqisQ1j8S9uKnr+aw@mail.gmail.com>
Subject: Re: [net-next v7 2/4] page_pool: Add recycle stats
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     Joe Damato <jdamato@fastly.com>, netdev@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net, hawk@kernel.org,
        saeed@kernel.org, ttoukan.linux@gmail.com, brouer@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Feb 2022 at 09:20, Jesper Dangaard Brouer <jbrouer@redhat.com> wrote:
>
>
> On 25/02/2022 18.41, Joe Damato wrote:
> > Add per-cpu stats tracking page pool recycling events:
> >       - cached: recycling placed page in the page pool cache
> >       - cache_full: page pool cache was full
> >       - ring: page placed into the ptr ring
> >       - ring_full: page released from page pool because the ptr ring was full
> >       - released_refcnt: page released (and not recycled) because refcnt > 1
> >
> > Signed-off-by: Joe Damato <jdamato@fastly.com>
> > ---
> >   include/net/page_pool.h | 16 ++++++++++++++++
> >   net/core/page_pool.c    | 28 +++++++++++++++++++++++++++-
> >   2 files changed, 43 insertions(+), 1 deletion(-)
>
> LGTM - thanks for working on this
>
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
>
Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
