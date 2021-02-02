Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D89F730B436
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 01:38:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbhBBAiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 19:38:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbhBBAiN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 19:38:13 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1FD6C061573
        for <netdev@vger.kernel.org>; Mon,  1 Feb 2021 16:37:32 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id s3so7298977edi.7
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 16:37:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jbYe5W7KGj+nAdDQNB6u8Akoy51s4bVc1vI8xnhdOX4=;
        b=KkYldV8r9iACcYXCFL3rienD/lhfcAODv6bMNa2hawvvXad2LrwmeIO01Zo9or16Dj
         cbOsxSzEpmjVY+EkwecIfcugKrhH6S0jqiSilPzvXEx6kTHW3TjPKq39LuDVB1A4xFxW
         8pbxs/qbDCOAnl/wG2Mua9WUimF07niZjb9n0FAKt6UDEhtUOoShj+YZ+BWKwGzBdokC
         Qh4sUCM21V0u+DRqV2cCSeyka4hW3Z4ZfN4ejrsvR9nl2d+vDZx4uU4oKYc0dg4A9GiA
         Fumi9DcNr+NJAJURIou6XduXFtxezzxGQ2hwdgU3b6TXxWmE0TxAhJkJwBU8AYWH1wds
         U32Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jbYe5W7KGj+nAdDQNB6u8Akoy51s4bVc1vI8xnhdOX4=;
        b=pRhNTwwIlf9rw3yef2hNNaJF6hF2Ptbwgh31cpVDTGoCrFXJ/TCNw/4U+nCsmtLBrd
         jmSNmKJYv9s+latB6hZ7o6xGy/zz8mCFWHVlXtHRPtVL/a6uaFGIoLmaztM3qmkVyMTz
         L6GcKvxHWrdYhr0lKYw1Zn4vq/qlpNx1AXZfbH/fkXJjm1ktdNSTjXeenmc8ZBSTK07F
         /vi8mZm95KvKAyQjd2mjwjaHWgWVAgEjOuC767ldm8WKox7a2eFGUK4zHVLrvZGeiV17
         O07dcf3FV2cVfiK2T2woyCiFbqthMormEL+i4/7tSBZpws5Nea81VBdeJ6TzdNSjabOC
         6Fzg==
X-Gm-Message-State: AOAM530iyAjyV8iQnIRyMkxGiKI8XUCxmmdNSyc7Ymu4fb0O1oNMIb/n
        pFpJr11JEf4GQyZONwUS+14=
X-Google-Smtp-Source: ABdhPJxIaxzn6KEW2UMFW/2zTTqiXnP1my/aQ+0NtFa8xvlVCmjsrYjT1ct0/UoBlwQRODJphZPbiw==
X-Received: by 2002:a50:9fae:: with SMTP id c43mr7617494edf.269.1612226251421;
        Mon, 01 Feb 2021 16:37:31 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id u5sm1518956edc.29.2021.02.01.16.37.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 16:37:30 -0800 (PST)
Date:   Tue, 2 Feb 2021 02:37:29 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org
Subject: Re: [RESEND PATCH net-next 1/4] net: hsr: generate supervision frame
 without HSR tag
Message-ID: <20210202003729.oh224wtpqm6bcse3@skbuf>
References: <20210201140503.130625-1-george.mccollister@gmail.com>
 <20210201140503.130625-2-george.mccollister@gmail.com>
 <20210201145943.ajxecwnhsjslr2uf@skbuf>
 <CAFSKS=OR6dXWXdRTmYToH7NAnf6EiXsVbV_CpNkVr-z69vUz-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFSKS=OR6dXWXdRTmYToH7NAnf6EiXsVbV_CpNkVr-z69vUz-g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 01, 2021 at 01:43:43PM -0600, George McCollister wrote:
> > > diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
> > > index ab953a1a0d6c..161b8da6a21d 100644
> > > --- a/net/hsr/hsr_device.c
> > > +++ b/net/hsr/hsr_device.c
> > > @@ -242,8 +242,7 @@ static struct sk_buff *hsr_init_skb(struct hsr_port *master, u16 proto)
> > >        * being, for PRP it is a trailer and for HSR it is a
> > >        * header
> > >        */
> > > -     skb = dev_alloc_skb(sizeof(struct hsr_tag) +
> > > -                         sizeof(struct hsr_sup_tag) +
> > > +     skb = dev_alloc_skb(sizeof(struct hsr_sup_tag) +
> > >                           sizeof(struct hsr_sup_payload) + hlen + tlen);
> >
> > Question 1: why are you no longer allocating struct hsr_tag (or struct prp_rct,
> > which has the same size)?
> 
> Because the tag is no longer being included in the supervisory frame
> here. If I understand correctly hsr_create_tagged_frame and
> prp_create_tagged_frame will create a new skb with HSR_HLEN added
> later.

I'm mostly doing static analysis of the code, which makes everything
more difficult and also my review more inaccurate. I'll try to give your
patches more testing when reviewing further, but I just got stuck into
trying to understand them first.

So your change makes fill_frame_info classify supervision frames as
skb_std instead of skb_hsr or skb_prp. The tag is added only in
hsr_create_tagged_frame right before dispatch to the egress port.

But that means that there are places like for example
hsr_handle_sup_frame which clearly don't like that: it checks whether
there's a tagged skb in either frame->skb_hsr or frame->skb_prp, but not
in frame->skb_std, so it now does basically nothing.

Don't we need hsr_handle_sup_frame?

> > In hsr->proto_ops->fill_frame_info in the call path above, the skb is
> > still put either into frame->skb_hsr or into frame->skb_prp, but not
> > into frame->skb_std, even if it does not contain a struct hsr_tag.
> 
> Are you sure? My patch changes hsr_fill_frame_info and
> prp_fill_frame_info not to do that if port->type is HSR_PT_MASTER
> which I'm pretty certain it always is when sending supervisory frames
> like this. If I've overlooked something let me know.

You're right, I had figured it out myself in the comment below where I
called it a kludge.

> >
> > Also, which code exactly will insert the hsr_tag later? I assume
> > hsr_fill_tag via hsr->proto_ops->create_tagged_frame?
> 
> Correct.

I think it's too late, see above.

> > > -     if (!hsr->prot_version)
> > > -             proto = ETH_P_PRP;
> > > -     else
> > > -             proto = ETH_P_HSR;
> > > -
> > > -     skb = hsr_init_skb(master, proto);
> > > +     skb = hsr_init_skb(master, ETH_P_PRP);
> >
> > Question 2: why is this correct, setting skb->protocol to ETH_P_PRP
> > (HSR v0) regardless of prot_version? Also, why is the change necessary?
> 
> This part is not intuitive and I don't have a copy of the documents
> where v0 was defined. It's unfortunate this code even supports v0
> because AFAIK no one else uses it; but it's in here so we have to keep
> supporting it I guess.
> In v1 the tag has an eth type of 0x892f and the encapsulated
> supervisory frame has a type of 0x88fb. In v0 0x88fb is used for the
> eth type and there is no encapsulation type. So... this is correct
> however I compared supervisory frame generation before and after this
> patch for v0 and I found a problem. My changes make it add 0x88fb
> again later for v0 which it's not supposed to do. I'll have to fix
> that part somehow.

Step 1: Sign up for HSR maintainership, it's currently orphan
Step 2: Delete HSRv0 support
Step 3: See if anyone shouts, probably not
Step 4: Profit.

> >
> > Why is it such a big deal if supervision frames have HSR/PRP tag or not?
> 
> Because if the switch does automatic HSR/PRP tag insertion it will end
> up in there twice. You simply can't send anything with an HSR/PRP tag
> if this is offloaded.

When exactly will your hardware push a second HSR tag when the incoming
packet already contains one? Obviously for tagged packets coming from
the ring it should not do that. It must be treating the CPU port special
somehow, but I don't understand how.
