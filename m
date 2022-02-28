Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8731E4C63CD
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 08:30:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233445AbiB1Haj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 02:30:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233630AbiB1Haj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 02:30:39 -0500
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8BE4220F7
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 23:30:00 -0800 (PST)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-2db2add4516so64687327b3.1
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 23:30:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kYhSzd+uwH6bz9duj0jBfMDgO55qboO42hJkDgbzwSE=;
        b=ZkCz6LKImSzbAehzdzQiYvlbaKgZCEV7Uyr22DkyK0FunGxnQHSaMf7HyqBulBCjLI
         lnEUxLBEqtG2bo9MlISvCHDdQGh4vF7N0iY05iXB5Vaf4MHxkUuD4cF5Bcg5nHJ7R54R
         19X5VcaUaO+cv+ZKP/1/tXGB6Evcrvi0vpj1vERt3ErONQ4jojeVXZCwCKKsh2L8t9zr
         wGkrLHweGYHYIolrF9pUA4TtGDmZgBj+fgIhLJiBVh1URZICg/k9Mek8n9q0mAx0pveO
         U2hoiYS9jqdVIn6mXtWtl7x5gmJSEQeW76RYAt62Arbcoa0Nlqzqkf50yygRNK6TKJpx
         JF1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kYhSzd+uwH6bz9duj0jBfMDgO55qboO42hJkDgbzwSE=;
        b=10+NlVsB1gi96jbYRqIqt098vpiKWoT7MiFU9GF39OgJJASUMLYouh9SV1vrRoYvuq
         HT+Uz4mneS41kDVQLqRoOFRH7j6HqE3Ff+o9HzAhAVrJNCTwHpGGPUNCXnJq1PtRlCtw
         BlIEy1ZwRDhf/G2PkCYzJ9sFVIb8Neh5xtXhghY49PlP6MRtiGtzEKy+AShVyGTtT9TH
         x5wCDJ0Qe2eIJhHxie01SSjcnKcnfzpVKFCoJImWoLOdI4Xsy0uJDysiZ/36sHqVX9/g
         fPmQ12BfvRu0h6eXDtC1LKV6LLGZiQ0AXDQdTPa27iXq/WIyCSpoeR6oQxUiSexMi+3S
         QYQg==
X-Gm-Message-State: AOAM530yxM7Df6TuJoRtv/yxWrA/k1MQ65z6D6OP81yg+Eha6/WKMiEx
        DuWY09bUJoOUIzJC1RJzquR2XMSf8HWFPyu0nCjtIw==
X-Google-Smtp-Source: ABdhPJxz2CmX5W8S8mTdcSZeTF6i7NWoyi0OatXpsXUcuhagkXut8Drc8WDZQ7zsvtVW99myJxpyJrVEPjyTezPwQbg=
X-Received: by 2002:a81:ff05:0:b0:2d6:8e83:e723 with SMTP id
 k5-20020a81ff05000000b002d68e83e723mr19284756ywn.382.1646033399981; Sun, 27
 Feb 2022 23:29:59 -0800 (PST)
MIME-Version: 1.0
References: <1645810914-35485-1-git-send-email-jdamato@fastly.com>
 <1645810914-35485-4-git-send-email-jdamato@fastly.com> <d36cf804-66a5-0010-2d3c-57dae1e4028d@redhat.com>
In-Reply-To: <d36cf804-66a5-0010-2d3c-57dae1e4028d@redhat.com>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Mon, 28 Feb 2022 09:29:22 +0200
Message-ID: <CAC_iWjJa7gHpHwSziN7AjMRfautXVD23Emi8gSowb3yteYZwbA@mail.gmail.com>
Subject: Re: [net-next v7 3/4] page_pool: Add function to batch and return stats
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

On Mon, 28 Feb 2022 at 09:22, Jesper Dangaard Brouer <jbrouer@redhat.com> wrote:
>
>
> On 25/02/2022 18.41, Joe Damato wrote:
> > Adds a function page_pool_get_stats which can be used by drivers to obtain
> > stats for a specified page_pool.
> >
> > Signed-off-by: Joe Damato<jdamato@fastly.com>
> > ---
> >   include/net/page_pool.h | 17 +++++++++++++++++
> >   net/core/page_pool.c    | 25 +++++++++++++++++++++++++
> >   2 files changed, 42 insertions(+)
>
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
>
Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
