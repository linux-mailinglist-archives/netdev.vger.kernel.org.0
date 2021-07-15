Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 103E43CA0EC
	for <lists+netdev@lfdr.de>; Thu, 15 Jul 2021 16:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237741AbhGOOsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 10:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237715AbhGOOsm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 10:48:42 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD23C061760
        for <netdev@vger.kernel.org>; Thu, 15 Jul 2021 07:45:47 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id ec55so8534135edb.1
        for <netdev@vger.kernel.org>; Thu, 15 Jul 2021 07:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7uqDZzHKVpsINWHrg5JOJTdJvh6PSIO/q3/0nSNsYII=;
        b=wphbDc7+rLxFhMs3a2acJoIwxbDAMRsUtFVZEj58rxiSfdbeuDshwMt79HHJ23/g3G
         5Qw65nVbjEra99I3wVw26Hiwz4GYv3Dr0foBGti1e/kupVmcqKtH+dwwm+OND3eZ3i/G
         KPXwkQ9ORGeAyhdXdX2/aOV94neCkKybOgbe5X36ENPLB5vXbDbSPk6Pb7QLbboL3Ezn
         RTCPwd1/FzQW8Cuf8XPQFRiqZ2Yy1JUDNJuxo8DiRwRTZhwaZuelnhb3XSEr/Q1XnU2p
         1ZvAN0YZ+8PVPOVjCyatVKpFdqAhTgWqI2ISOAt17axncq+xH5GsHAa7gqaCINpoa5Mu
         a23w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7uqDZzHKVpsINWHrg5JOJTdJvh6PSIO/q3/0nSNsYII=;
        b=Nz2Qf+MiggJMGjcO8szJ+WrJ3jhkZUIym6kWL7d8LvFEK0Z+ddsgOYpMWQeXtaNESn
         FpqwMiN6n9QRl8r54lTRz/+KjfJdWThT1wQh1XWVpsw3BpikFnaZjiuXAAMm4aQFShQX
         /pGBv93mBBrPDrSRT4ax6W0Js5X94O6s/ledt8vFzkCKdZDORZF4pfqAvYuDyVCS/Dpb
         gNody9ktZ5u1cvKbBCnfleLR8eslqTWFS8GqT0Qrx9blsokfAKSQBXpKmAmf9OeA499w
         xDuUAQg324L7BDVRwBTBbCEDeTBTY72Jos2HQYucCrcbKAFVk5PP1t7/e21tzCbMMJtg
         6sRA==
X-Gm-Message-State: AOAM530DKB+qAa4mEQJFcf5mnx3j6po/r+SGfchRPiQwGAPas3wj85na
        RBIlNdlPQhjJRbxvBq1hXNSrRw==
X-Google-Smtp-Source: ABdhPJx7QpTydQ7DmTb1eoicKoERov8gYCGMOTruJKutI8Y9z3nmdc68jbxUJf3CdUq9F11UiGUxIA==
X-Received: by 2002:a05:6402:31bb:: with SMTP id dj27mr7266889edb.375.1626360346401;
        Thu, 15 Jul 2021 07:45:46 -0700 (PDT)
Received: from Iliass-MBP (ppp-94-66-243-35.home.otenet.gr. [94.66.243.35])
        by smtp.gmail.com with ESMTPSA id l20sm2472131edb.47.2021.07.15.07.45.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jul 2021 07:45:46 -0700 (PDT)
Date:   Thu, 15 Jul 2021 17:45:41 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        Netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Matteo Croce <mcroce@microsoft.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1 v2] skbuff: Fix a potential race while recycling
 page_pool packets
Message-ID: <YPBKFXWdDytvPmoN@Iliass-MBP>
References: <20210709062943.101532-1-ilias.apalodimas@linaro.org>
 <bf326953-495f-db01-e554-42f4421d237a@huawei.com>
 <CAKgT0UemhFPHo9krmQfm=yNTSjwpBwVkoFtLEEQ-qLVh=-BeHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0UemhFPHo9krmQfm=yNTSjwpBwVkoFtLEEQ-qLVh=-BeHg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > >           atomic_sub_return(skb->nohdr ? (1 << SKB_DATAREF_SHIFT) + 1 : 1,

[...]

> > >                             &shinfo->dataref))
> > > -             return;
> > > +             goto exit;
> >
> > Is it possible this patch may break the head frag page for the original skb,
> > supposing it's head frag page is from the page pool and below change clears
> > the pp_recycle for original skb, causing a page leaking for the page pool?
> 
> I don't see how. The assumption here is that when atomic_sub_return
> gets down to 0 we will still have an skb with skb->pp_recycle set and
> it will flow down and encounter skb_free_head below. All we are doing
> is skipping those steps and clearing skb->pp_recycle for all but the
> last buffer and the last one to free it will trigger the recycling.

I think the assumption here is that 
1. We clone an skb
2. The original skb goes into pskb_expand_head()
3. skb_release_data() will be called for the original skb

But with the dataref bumped, we'll skip the recycling for it but we'll also
skip recycling or unmapping the current head (which is a page_pool mapped
buffer)

> 
> > >
> > >       skb_zcopy_clear(skb, true);
> > >
> > > @@ -674,6 +674,8 @@ static void skb_release_data(struct sk_buff *skb)
> > >               kfree_skb_list(shinfo->frag_list);
> > >
> > >       skb_free_head(skb);
> > > +exit:
> > > +     skb->pp_recycle = 0;
> 
> Note the path here. We don't clear skb->pp_recycle for the last buffer
> where "dataref == 0" until *AFTER* the head has been freed, and all
> clones will have skb->pp_recycle = 1 as long as they are a clone of
> the original skb that had it set.
