Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EDB42A82AA
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 16:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731527AbgKEPv5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 10:51:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731254AbgKEPvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 10:51:54 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FDD6C0613CF;
        Thu,  5 Nov 2020 07:51:53 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id o18so2060403edq.4;
        Thu, 05 Nov 2020 07:51:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Vy5rFK98WwOkpMK5FH/Egy9kTlIr6DuFpGSYvsmCTR4=;
        b=Jxn+FOlfvtBgm1ld11HkFPNfeEHmzI34QY4D0Xmc+IUO938AQ7jQwjRjFe9qeXwrZg
         0dhJjhFhPHEU5Ec/WFMKNf4sZvX4GaJ31nOEoPv5xhPFmZTGSQrE8fZgScMtKhGteQGg
         lxDP1vP878fV9U1+yuYBvDy1IJf058dLvP4jLOh0J2iPWEzQyeWSFfHuZ7Kur6WohyKK
         LxxZe90nBrGLbqUQA1JDbvq7kKJfyKDtLfAPPn30qdPZq+KVqg3jUtbYU4mxiwOrDhUz
         vrnjDd6RzatsuvYmO/xuLkJiifVehm0Chguhqx6/YHeBujRqQl/4IRKoC4EXU24U/yG/
         9Xqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Vy5rFK98WwOkpMK5FH/Egy9kTlIr6DuFpGSYvsmCTR4=;
        b=sXMc5MptqycMif0bru7kfp21RLUfvibFdRRHNZQnaFAbSVJikVRUTT6sSrOiO96x9B
         fGb1MFkDvHLWpNKy8+XzH4gXviI7WkzBqESaaJaG04krP1Cfpe2Ou+DLvNdQ9exK4GBF
         8QxVwiUtHzSsaxjtfWBAAXM0JGW+kfhtI9zISkbgj5vIrFYaygTVmdDSVg5QtBD+h77L
         10+H71V2eCeQVAK6jKfRoyOO2+PtCyNyG9r0Bu5+FLSxQP7fO14NtZuha9fgCZz1lce/
         +TVD/rY5WsqbkaUcjl/Had5cuyfTp2MKdUdQButE+ivfgKe6FOJvxs6g/P8H6SZQwbpY
         EK2Q==
X-Gm-Message-State: AOAM532GVgPox2UDaxOjiU4UjKZrRCVy1jiWW5icSEVbTniOo5fAiQxW
        LacBbpxwL7m0p5LKbjmIPxs=
X-Google-Smtp-Source: ABdhPJyUxDmfZ9jFLqR0PwFchzcKt/gEbaF97KUR93ifuKdTBL31RQ1sFflD0xi0g9OVWk2JNCyQfw==
X-Received: by 2002:a50:d784:: with SMTP id w4mr3290628edi.201.1604591512301;
        Thu, 05 Nov 2020 07:51:52 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id n1sm1147358edt.66.2020.11.05.07.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 07:51:51 -0800 (PST)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
X-Google-Original-From: Ioana Ciornei <ciornei.ioana@gmail.com>
Date:   Thu, 5 Nov 2020 17:51:50 +0200
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ioana Ciornei <ciorneiioana@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [RFC 6/9] staging: dpaa2-switch: add .ndo_start_xmit() callback
Message-ID: <20201105155150.qc44olbqyxihislh@skbuf>
References: <20201104165720.2566399-1-ciorneiioana@gmail.com>
 <20201104165720.2566399-7-ciorneiioana@gmail.com>
 <20201105010439.GH933237@lunn.ch>
 <20201105082557.c43odnzis35y7khj@skbuf>
 <20201105134512.GJ933237@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201105134512.GJ933237@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 05, 2020 at 02:45:12PM +0100, Andrew Lunn wrote:
> > > Where is the TX confirm which uses this stored pointer. I don't see it
> > > in this file.
> > > 
> > 
> > The Tx confirm - dpaa2_switch_tx_conf() - is added in patch 5/9.
> 
> Not so obvious. Could it be moved here?
> 

Sure, I'll move it here so that we have both Tx and Tx confirmation in
the same patch.

> > > It can be expensive to store pointer like this in buffers used for
> > > DMA.
> > 
> > Yes, it is. But the hardware does not give us any other indication that
> > a packet was actually sent so that we can move ahead with consuming the
> > initial skb.
> > 
> > > It has to be flushed out of the cache here as part of the
> > > send. Then the TX complete needs to invalidate and then read it back
> > > into the cache. Or you use coherent memory which is just slow.
> > > 
> > > It can be cheaper to keep a parallel ring in cacheable memory which
> > > never gets flushed.
> > 
> > I'm afraid I don't really understand your suggestion. In this parallel
> > ring I would keep the skb pointers of all frames which are in-flight?
> > Then, when a packet is received on the Tx confirmation queue I would
> > have to loop over the parallel ring and determine somehow which skb was
> > this packet initially associated to. Isn't this even more expensive?
> 
> I don't know this particular hardware, so i will talk in general
> terms. Generally, you have a transmit ring. You add new frames to be
> sent to the beginning of the ring, and you take off completed frames
> from the end of the ring. This is kept in 'expensive' memory, in that
> either it is coherent, or you need to do flushed/invalidates.
> 
> It is expected that the hardware keeps to ring order. It does not pick
> and choose which frames it sends, it does them in order. That means
> completion also happens in ring order. So the driver can keep a simple
> linear array the size of the ring, in cachable memory, with pointers
> to the skbuf. And it just needs a counting index to know which one
> just completed.

I agree with all of the above in a general sense.

> 
> Now, your hardware is more complex. You have one queue feeding
> multiple switch ports.

Not really. I have one Tx queue for each switch port and just one Tx
confirmation queue for all of them.

> Maybe it does not keep to ring order?

If the driver enqueues frames #1, #2, #3 in this exact order on a switch
port then the frames will arrive in the same order on the Tx
confirmation queue irrespective of any other traffic sent on other
switch ports.

> If you
> have one port running at 10M/Half, and another at 10G/Full, does it
> leave frames for the 10/Half port in the ring when its egress queue it
> full? That is probably a bad idea, since the 10G/Full port could then
> starve for lack of free slots in the ring? So my guess would be, the
> frames get dropped. And so ring order is maintained.
> 
> If you are paranoid it could get out of sync, keep an array of tuples,
> address of the frame descriptor and the skbuf. If the fd address does
> not match what you expect, then do the linear search of the fd
> address, and increment a counter that something odd has happened.
> 

The problem with this would be, I think, with two TX softirqs on two
different cores which want to send a frame on the same switch port. In
order to update the shadow ring, there should be some kind of locking
mechanism on the access to the shadow ring which would might invalidate
any attempt to make this more efficient.

This might not be a problem for the dpaa2-switch since it does not
enable NETIF_F_LLTX but it might be for dpaa2-eth.

Also, as the architecture is defined now, the driver does not really see
the Tx queues as being fixed-size so that it can infer the size for the
shadow copy.

I will have to dig a little bit more in this area to understand exactly
why the decision to use skb backpointers was made in the first place (I
am not really talking about the dpaa2-switch here, dpaa2-eth has the
same exact behavior and has been around for some time now).

Ioana

