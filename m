Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DACC1346868
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 20:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232836AbhCWTDc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Mar 2021 15:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232792AbhCWTDG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Mar 2021 15:03:06 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E0C9C061574
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 12:03:05 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id hq27so28884377ejc.9
        for <netdev@vger.kernel.org>; Tue, 23 Mar 2021 12:03:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Q1gH5uTd+e3JNiYZaxTzRpgAiN4+aMrxs68UbB+GghA=;
        b=n1UlnEfAUA9WotWEVLvWiPU4DboUcx0+JhULeEtv3kiSipgi8f1zaqGB6Qm89F951i
         Stp89C7wkZVy6EZRC42HkCpP9ZNQ4ircQIg+luY1moglc9GRUJc1oshTqDs/PBaIg1ng
         ngs/a7AydCc3dgsr3tExvnazR6rPlv4fIDvGnMsUeQ66YKWnR025+VM7KzPj+ofPSlA6
         i/ifT09LY8j8qAfuUWkqdLC5xwbAVofT3zqVyywggTmyqyoiYsMh/iHWvbhT7mvrde7S
         eihgyafI9644kziDGn4FSGvfZNDoO1k90StPQIQfAKG9VRyKHk+TB1rY5yKxEHalrRM0
         itJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Q1gH5uTd+e3JNiYZaxTzRpgAiN4+aMrxs68UbB+GghA=;
        b=BRDc6HWSuf49NBRVh+E28BF8/x1OiFLqwcy4BijJGmfdcRnqK8NyF0yhcaP/YiyEv4
         hfcxvAAgYIzVRkmJNWVWPErTapF7rL9CwWiVV4dCP6OPKsDTd94pD+dhFkX47k9w5CDC
         MHUEmNGQ4TndGPkZOVEWsUY/xkDuHZT0ADvMy2pisWF8QECmyBTKoqzS6T7Q3348M1Nm
         p0bI0xeFctnxTLOjpqGW5KzA8sa7PYK+3mt2oh+jCLzHNML1a1LQ3p8nKxtmPk+7Xjvz
         48ztbOSm7b8wWb1suCmuhrtrWY6eE1CUuQuO3wo6/D2oFmNPOCK5saWF6OME9WP3JlFP
         6m2Q==
X-Gm-Message-State: AOAM531moNOUE7A8YxVPg3hMTYjLALgfzALwvucjmx+wpIbgBQLg3DYg
        CdOBL0UIkRjQEUJJepjD/M3nc5B7+ac=
X-Google-Smtp-Source: ABdhPJwXwtZp58g4al3pvvSrv3mdnSbFN8LPXfBRFSt+fTD6XBYpc/0V9hCUYBkNZ9V/enypT92BcA==
X-Received: by 2002:a17:906:ad4:: with SMTP id z20mr6201454ejf.496.1616526183926;
        Tue, 23 Mar 2021 12:03:03 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id a22sm11741168ejr.89.2021.03.23.12.03.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Mar 2021 12:03:03 -0700 (PDT)
Date:   Tue, 23 Mar 2021 21:03:02 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Allow dynamic
 reconfiguration of tag protocol
Message-ID: <20210323190302.2v7ianeuwylxdqjl@skbuf>
References: <20210323102326.3677940-1-tobias@waldekranz.com>
 <20210323113522.coidmitlt6e44jjq@skbuf>
 <87blbalycs.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87blbalycs.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 23, 2021 at 03:48:51PM +0100, Tobias Waldekranz wrote:
> On Tue, Mar 23, 2021 at 13:35, Vladimir Oltean <olteanv@gmail.com> wrote:
> > The netdev_uses_dsa thing is a bit trashy, I think that a more polished
> > version should rather set NETIF_F_RXALL for the DSA master, and have the
> > dpaa driver act upon that. But first I'm curious if it works.
> 
> It does work. Thank you!

Happy to hear that.

> Does setting RXALL mean that the master would accept frames with a bad
> FCS as well?

Do you mean from the perspective of the network stack, or of the hardware?

As far as the hardware is concerned, here is what the manual has to say:

Frame reception from the network may encounter certain error conditions.
Such errors are reported by the Ethernet MAC when the frame is transferred
to the Buffer Manager Interface (BMI). The action taken per error case
is described below. Besides the interrupts, the BMI is capable of
recognizing several conditions and setting a corresponding flag in FD
status field for Host usage. These conditions are as follows:

* Physical Error. One of the following events were detected by the
  Ethernet MAC: Rx FIFO overflow, FCS error, code error, running
  disparity error (in applicable modes), FIFO parity error, PHY Sequence
  error, PHY error control character detected, CRC error. The BMI
  discards the frame, or enqueue directly to EFQID if FMBM_RCFG[FDOVR]
  is set [ editor's note: this is what my patch does ]. FPE bit is set
  in the FD status.
* Frame size error. The Ethernet MAC detected a frame that its length
  exceeds the maximum allowed as configured in the MAC registers. The
  frame is truncated by the MAC to the maximum allowed, and it is marked
  as truncated. The BMI sets FSE in the FD status and forwards the frame
  to next module in the FMan as usual.
* Some other network error may result in the frame being discarded by
  the MAC and not shown to the BMI. However, the MAC is responsible for
  counting such errors in its own statistics counters.

So yes, packets with bad FCS are accepted with FMBM_RCFG[FDOVR] set.
But it would be interesting to see what is the value of "fd_status" in
rx_default_dqrr() for bad packets. You know, in the DPAA world, the
correct approach to solve this problem would be to create a
configuration to describe a "soft examination sequence" for the
programmable hardware "soft parser", which identifies the DSA tag and
skips over a programmable number of octets. This allows you to be able
to continue to do things such as flow steering based on IP headers
located after the DSA tag, etc. This is not supported in the upstream
FMan driver however, neither the soft parser itself nor an abstraction
for making DSA masters DSA-aware. I think it would also require more
work than it took me to hack up this patch. But at least, if I
understand correctly, with a soft parser in place, the MAC error
counters should at least stop incrementing, if that is of any importance
to you.

> If so, would that mean that we would have to verify it in software?

I don't see any place in the network stack that recalculates the FCS if
NETIF_F_RXALL is set. Additionally, without NETIF_F_RXFCS, I don't even
know how could the stack even tell a packet with bad FCS apart from one
with good FCS. If NETIF_F_RXALL is set, then once a packet is received,
it's taken for granted as good.

There is a separate hardware bit to include the FCS in the RX buffer, I
don't think this is what you want/need.

> >> 
> >> As a workaround, switching to EDSA (thereby always having a proper
> >> EtherType in the frame) solves the issue.
> >
> > So basically every user needs to change the tag protocol manually to be
> > able to receive from port 8? Not sure if that's too friendly.
> 
> No it is not friendly at all. My goal was to add it as a device-tree
> property, but for reasons I will detail in my answer to Andrew, I did
> not manage to figure out a good way to do that. Happy to take
> suggestions.

My two cents here are that you should think for the long term. If you
need it due to a limitation which you have today but might no longer
have tomorrow, don't put it in the device tree unless you want to
support it even when you don't need it anymore.
