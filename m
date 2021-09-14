Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B990840A6B8
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 08:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240119AbhINGbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 02:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239936AbhINGa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 02:30:59 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA140C061574
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 23:29:42 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id f3-20020a17090a638300b00199097ddf1aso1375065pjj.0
        for <netdev@vger.kernel.org>; Mon, 13 Sep 2021 23:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=cDJ7OHMdKXwhE4r32w5GZdWPw759tISdRDVL/qUaM6U=;
        b=ndsK3d3LlKEM5kyPFDGHPOgOvF6g7/rVgCat1Q6Z6+VypIL6TlWOrf7f+m19r7/q/2
         1jL6CtTGCpdXcLtZxCT5fZf+AMCMu6jsVc5fy2zcee469Pue1Fa5GjRLMZOoMgDjVOZB
         HCgqrPNmFDayXFzPj9UJkXqU6jNC4TkK/z/xvZLWAR9mPCAEOScP8AsVa9XK1A4+BmNk
         pRZittUuGFP6fpjTLTJ3kmhvgKktpvb3zi3fjm+I5JRTEA1F7ovRcjG0Hyq0wNBNax4v
         Lo7KhE1Zoi8nhHARyg7OH2kMKC0MYb/S0o1Lp4FiwxbrQFvScLyp0JvqThSX/VL0m1Wx
         dRqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=cDJ7OHMdKXwhE4r32w5GZdWPw759tISdRDVL/qUaM6U=;
        b=slaA39l1MSGn5qd1BrJAnIJM4wEr/BYYFusWklAfMTzwDFxb5Eiq/kAaMBzR5jsnrV
         e+N+lqw//szZDFEVKVwt7+rzXlEMJJdED7LBxiGPhFO/PEcx+d3GswDurJuIbZxHgp0m
         OttZzMX9k/LZMm0pLmJYtFQhxvwHYMeZ40wiaof7mhzwngJyBjWtHz7kMF0b0QS+nDyG
         yAs0QwdFHFfGOXSY+42qg2fW8i0qk9+EWPrU+YCDBEKgkXOJcSNf4uTpPIINBkcx6Qcf
         7nUYu+xvugtuEke7sR0oy/Zky2sb4HREMpRGSn07HAX6hbsSqfwNOWv91Sm00tBxYOaf
         bdeg==
X-Gm-Message-State: AOAM5327sVOxugZbEptQUu/1/j37pIyHYJHK3gGeNaMqEaV0PbKit9kA
        Ht8CgT4SbpyDm6+ZILUOoVI=
X-Google-Smtp-Source: ABdhPJzsfK/zMroDuXXCh80ljZ/09qRZp5eVda5iLQphsAp8e5Re9q3SRZAT+lf1uIYdFrb142q+4A==
X-Received: by 2002:a17:90b:1bcf:: with SMTP id oa15mr213750pjb.58.1631600982448;
        Mon, 13 Sep 2021 23:29:42 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id d6sm9350156pfa.135.2021.09.13.23.29.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Sep 2021 23:29:41 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Mauri Sandberg <sandberg@mailfence.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: Re: [PATCH net-next 5/8] net: dsa: rtl8366: Disable "4K" VLANs
Date:   Tue, 14 Sep 2021 14:29:33 +0800
Message-Id: <20210914062933.1087740-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <CACRpkdYUp2m8LXfngi05O=ro5-8vicpkNJa=PUGzc4KDBsuMyA@mail.gmail.com>
References: <20210913144300.1265143-1-linus.walleij@linaro.org> <20210913144300.1265143-6-linus.walleij@linaro.org> <20210913153425.pgm2zs4vgtnzzyps@skbuf> <CACRpkdYUp2m8LXfngi05O=ro5-8vicpkNJa=PUGzc4KDBsuMyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Linus,

On Tue, Sep 14, 2021 at 01:20:14AM +0200, Linus Walleij wrote:
> Hi Vladimir,
> 
> first, thanks for your help and patience. I learned a lot the recent
> weeks, much thanks to your questions and explanations!
> 
> On Mon, Sep 13, 2021 at 5:34 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> 
> > > This was discovered when testing with OpenWrt that join
> > > the LAN ports lan0 ... lan3 into a bridge and then assign
> > > each of them into VLAN 1 with PVID set on each port: without
> > > this patch this will not work and the bridge goes numb.
> >
> > It is important to explain _why_ the switch will go "numb" and not pass
> > packets if the Linux bridge assigns all ports to VLAN ID 1 as pvid. It
> > is certainly not expected for that to happen.
> 
> Yeah it is pretty weird. What happens now is that this is a regression
> when using OpenWrt userspace as it sets up the VLANs like this,

Were you running net-next kernel?

There have been major changes to DSA since 5.10, so you'd better test your
driver on net-next.

> but if I boot a clean system and just manually do e.g.
> ifconfig lan0 169.254.1.2 netmask 255.255.255.0 up
> it works fine because the default VLANs that were set up by the
> driver (removed by patch 2/8) will tag all packets using PVID and
> send packets on 5 ingress and 1 egress VLANs.
> 
> > The purpose of the PVID feature is specifically to classify untagged
> > packets to a port-based VLAN ID. So "everything is a VLAN" even for
> > Linux user space, not sure what you're talking about.
> 
> I think what happens is that OpenWrts userspace sets VLAN 1
> for all ingress ports with PVID, so all packets from ingress ports
> get tagged nicely with VID 1.
> 
> But as the CPU port is hidden inside the bridge
> it can't join the CPU port into that VLAN (userspace does not
> know it exist I think?) and thus no packets
> can go into or out of the CPU port. But you can still pass packets
> between the lan ports.
> 
> > When the Linux bridge has the vlan_filtering attribute set to 1, the
> > hardware should follow suit by making untagged packets get classified to
> > the VLAN ID that the software bridge wants to see, on the ports that are
> > members of that bridge.
> 
> This is what it does, I think.
> 
> But the "4K" VLAN feature is so strict that it will restrict also the CPU
> port from this (in hardware) with no way to turn it off.
> 
> It seems the "4K" mode is a "VLAN with filtering only mode" so no
> matter whether we turned on filtering or not, the CPU port
> will not see any packets from any other ports unless we add also
> that port (port 5) into the VLAN.
> 
> One solution I could try would be to just add the CPU port to all
> VLANs by default, but .. is that right?

The DSA core already adds the CPU port to VLAN members for you.
In file net/dsa/slave.c, function dsa_slave_vlan_add:
...
	err = dsa_port_vlan_add(dp, &vlan, extack);
	if (err)
		return err;

	/* We need the dedicated CPU port to be a member of the VLAN as well.
	 * Even though drivers often handle CPU membership in special ways,
	 * it doesn't make sense to program a PVID, so clear this flag.
	 */
	vlan.flags &= ~BRIDGE_VLAN_INFO_PVID;

	err = dsa_port_vlan_add(dp->cpu_dp, &vlan, extack);
	if (err)
		return err;
...

If it does not work, you may have done something wrong.
