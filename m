Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34718665D34
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 14:59:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236002AbjAKN7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 08:59:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232478AbjAKN7D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 08:59:03 -0500
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141BEFAD6
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 05:59:01 -0800 (PST)
Received: by mail-lf1-x132.google.com with SMTP id j17so23653210lfr.3
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 05:59:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=80IvPUZGgnxdQ5vyxchk9/UkehkHEp+xn1SQmlNKmPw=;
        b=UmBRLbBewTKwSpwZynb6tovxserM7649X+fkSRxKDJFULB1AhLrvWkQazbZLBVzrrf
         bajZ+7olC+zoh2t3tTTSRBAXdPKxjwa34Yu/QFlv11EWdRhGcJAgbQnduHfU0JFScR4m
         sJxrp0XcXV4oE8xYFAqMvUz0YzKMqFHm57UQdWg/mng/OKzQAvfo3gO2Ww5Vo2LGlIAF
         eeGaccHqxGmCxYnacvdCWqSrq5/JOkRJqeb2lXvsY0xB30cs281qrWmAafnhdiLbU/1F
         B5ilpDNKAgpqVLZ3gZgBZG5WeTIUNhQyp/NVVI5nUDNAzyjf5F0VNyl8iQzwrMrFlEbe
         z95g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=80IvPUZGgnxdQ5vyxchk9/UkehkHEp+xn1SQmlNKmPw=;
        b=J1qedrdeKT24mVopcjdEuypyPPW+luHAT16vxmkq8lK0xocRLiIy8mPj+bJG81BDKu
         /MBlG15cuwrleZGQCQ0Yq9nc2frOJy0YizwUTXow2yDSvVOIaQ5yg8lI7EqWK7p3dQyk
         qgf+z9HxNORWWdWvHcBfaZ19BOlUa0wkBTUwx/ndLXQ48pjBNNe7HenZ14EiERfVlS0d
         YlOL+mDLU5YzjquedWvn5C8CExcyND2JaB9zmOwJdkRGmwwONtN0EciDzUOX6wD5iHcd
         05kw+Z8HlYZSDVJFJNjJGF7D0OWPT9i7LE5H7RwSwtHhrDUQQUJftAfrLljHivGfuNMu
         1QtA==
X-Gm-Message-State: AFqh2koP6brTFjqlJ1LUhJwXPbtfIgOPjwU32rt8PwGhc4hlsmz/6RU/
        rMHvVa4W5lHvCczOQ5fbN7guNNKCgVx2jmplJkaKJTsc69+wcw==
X-Google-Smtp-Source: AMrXdXvbSfD+90cISa77jCd+cxLYf6fmn2lli1ewvrugTXi++WtDbM72cVrabXz5gOQOn5I/KkUXeKB4S0vRFE+MiV0=
X-Received: by 2002:a19:6551:0:b0:4b6:eb4d:4b7f with SMTP id
 c17-20020a196551000000b004b6eb4d4b7fmr6168977lfj.530.1673445540206; Wed, 11
 Jan 2023 05:59:00 -0800 (PST)
MIME-Version: 1.0
References: <20230105214631.3939268-1-willy@infradead.org> <20230105214631.3939268-16-willy@infradead.org>
 <Y700Jp6rWBzNYRdf@hera> <Y73gDakyrPx+C0H9@casper.infradead.org>
In-Reply-To: <Y73gDakyrPx+C0H9@casper.infradead.org>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Wed, 11 Jan 2023 15:58:24 +0200
Message-ID: <CAC_iWjLEzybFgcBUxFw-ZfjkLdsEiwcj1TvNuG45j0X0stXNPA@mail.gmail.com>
Subject: Re: [PATCH v2 15/24] page_pool: Remove page_pool_defrag_page()
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>, netdev@vger.kernel.org,
        linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Jan 2023 at 00:00, Matthew Wilcox <willy@infradead.org> wrote:
>
> On Tue, Jan 10, 2023 at 11:47:18AM +0200, Ilias Apalodimas wrote:
> > On Thu, Jan 05, 2023 at 09:46:22PM +0000, Matthew Wilcox (Oracle) wrote:
> > > -__page_pool_put_page(struct page_pool *pool, struct page *page,
> > > -                unsigned int dma_sync_size, bool allow_direct)
>
> Wow, neither of you noticed that the subject line mentioned the wrong
> function ;-)  I'm taking your R-b and A-b tags anyway ;-)

Well, the patches add temporary placeholders of functions to ensure
that none of the patches break the build.  So when I was reviewing, I
was immediately jumping to the equivalent patch that was removing the
function later on and missed the commit log ...:)

Cheers
/Ilias
