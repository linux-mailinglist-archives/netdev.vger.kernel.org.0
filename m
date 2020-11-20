Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9279F2B9F31
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 01:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726417AbgKTAWh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 19:22:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726386AbgKTAWg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 19:22:36 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F53BC0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 16:22:36 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id o21so10481077ejb.3
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 16:22:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Be2G1fisf4mK6OfZ/nfF8LkKq3zFsAn2lggX8uGijEM=;
        b=MhKfRAPH6U6NSED5DEkszu0jWrQ5VK8FwC7x+qZLwfPwZ53wq5pcyN1Tm6zMjIZzVo
         rhJPvcuWUhCfRGUe758lksmBy2cBuvWMyhu18bMtwwng+kvyFgVPJOibDr6KvNjX0B8R
         X7RRhoP4nT0ZCpc4KFLz/IZskgGefkFaCltgBmeyRrD/mm/OxXhXztgPsuP2XYZ7bWXW
         L4Xjz1lo3AQV7ZYdQy3rtEfxQ6kST7Z9GZCMvGcv+daNMPkoNnix0Jc7B4us7AoyIuqD
         FE2hV7TuCIJe7/SzyaD9MmB5NMB52ujd06ceqqX0dFTqppFao8c4ZYC1aqLVzoNqjRfv
         1sng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Be2G1fisf4mK6OfZ/nfF8LkKq3zFsAn2lggX8uGijEM=;
        b=fpWOyhpJCqiQDT3LXD9Vzu6KUvmTJEReXjq2HLiphE+NkfY89OmCr1lIiMFzjJYG6O
         9K0vH1WnxMYmmAv+NKBpLQNjM1RWlAMAQoZvu95+fSuYSzXz45HYQFaGTzNci6Jqx+sg
         Wwia7zPdZGgKRr0ZlwSx8TQHktKQEPjnqhnPd+rOeMB5TSZNR5rqSgtPDLCUswHLLPzL
         j+tlHKtyUhTsHNhG1R1fkm79nZdPqJjRlRVCNaFSwjhkXmXy5HdWFjWHp1zCjDlz788M
         KXbEQOJSGhO3rlh45XLRqFzlkrXggDUl2aViyXnvovDf9gy/8Z4mLYEJYqZm8IE95RMH
         Yd9A==
X-Gm-Message-State: AOAM531i79siefRM0QOU3mTFu8/FfGxZDoE8QrCuVOLCMm99kvgfyV4P
        nXab3Sj3Cv+6PZxPt/FGpCCuP6BBK13GBmb4btad9A==
X-Google-Smtp-Source: ABdhPJw7Ps80KVyQp73pwUZCaZodthvMPD5MyG+0Vw+kF3DoV6XXgjRKcISkuAha0cUDlsxDTKs72bvnAWn9mFi5PPs=
X-Received: by 2002:a17:906:6896:: with SMTP id n22mr32216510ejr.56.1605831754938;
 Thu, 19 Nov 2020 16:22:34 -0800 (PST)
MIME-Version: 1.0
References: <20201118232014.2910642-1-awogbemila@google.com>
 <20201118232014.2910642-2-awogbemila@google.com> <9b38c47593d2dedd5cad2c425b778a60cc7eeedf.camel@kernel.org>
In-Reply-To: <9b38c47593d2dedd5cad2c425b778a60cc7eeedf.camel@kernel.org>
From:   David Awogbemila <awogbemila@google.com>
Date:   Thu, 19 Nov 2020 16:22:24 -0800
Message-ID: <CAL9ddJf1bPH2na9x6G7q22Jk-e_R7gP=yEVTe9y6vzrmnuRm6Q@mail.gmail.com>
Subject: Re: [PATCH net-next v7 1/4] gve: Add support for raw addressing
 device option
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Netdev <netdev@vger.kernel.org>,
        Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 19, 2020 at 12:21 PM Saeed Mahameed <saeed@kernel.org> wrote:
>
> On Wed, 2020-11-18 at 15:20 -0800, David Awogbemila wrote:
> > From: Catherine Sullivan <csully@google.com>
> >
> > Add support to describe device for parsing device options. As
> > the first device option, add raw addressing.
> >
> > "Raw Addressing" mode (as opposed to the current "qpl" mode) is an
> > operational mode which allows the driver avoid bounce buffer copies
> > which it currently performs using pre-allocated qpls
> > (queue_page_lists)
> > when sending and receiving packets.
> > For egress packets, the provided skb data addresses will be
> > dma_map'ed and
> > passed to the device, allowing the NIC can perform DMA directly - the
> > driver will not have to copy the buffer content into pre-allocated
> > buffers/qpls (as in qpl mode).
> > For ingress packets, copies are also eliminated as buffers are handed
> > to
> > the networking stack and then recycled or re-allocated as
> > necessary, avoiding the use of skb_copy_to_linear_data().
> >
> > This patch only introduces the option to the driver.
> > Subsequent patches will add the ingress and egress functionality.
> >
> > Reviewed-by: Yangchun Fu <yangchun@google.com>
> > Signed-off-by: Catherine Sullivan <csully@google.com>
> > Signed-off-by: David Awogbemila <awogbemila@google.com>
> > ---
> >
> ...
> > diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c
> > b/drivers/net/ethernet/google/gve/gve_adminq.c
> > index 24ae6a28a806..1e2d407cb9d2 100644
> > --- a/drivers/net/ethernet/google/gve/gve_adminq.c
> > +++ b/drivers/net/ethernet/google/gve/gve_adminq.c
> > @@ -14,6 +14,57 @@
> >  #define GVE_ADMINQ_SLEEP_LEN         20
> >  #define GVE_MAX_ADMINQ_EVENT_COUNTER_CHECK   100
> >
> > +#define GVE_DEVICE_OPTION_ERROR_FMT "%s option error:\n" \
> > +"Expected: length=%d, feature_mask=%x.\n" \
> > +"Actual: length=%d, feature_mask=%x.\n"
> > +
> > +static inline
> > +struct gve_device_option *gve_get_next_option(struct
> >
>
> Following Dave's policy, no static inline functions in C files.
> This is control path so you don't really need the inline here.

Okay, I'll move it to a header file.

>
>
>
