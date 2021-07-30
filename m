Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1893DBCF6
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 18:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbhG3QTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 12:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbhG3QTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Jul 2021 12:19:02 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04F09C06175F;
        Fri, 30 Jul 2021 09:18:57 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id h9so2276899ejs.4;
        Fri, 30 Jul 2021 09:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rnL+DT6WaAAlihW1AoN/tB2D11HIMglWHsy5YB9xalA=;
        b=nJ4C4oqp2So/xg0u8hYcnVzRvBDxqLZqv6TA/A8fsa6hAV5GzDIuCa35v34njdPiPe
         tE1+DKt0K8T7UR3996CwY0zfCmcdH5+IGRlBGVMMarDKISnRnXRLoBLs1kvfMllVvQ7v
         XAhKFDdzCK8/fltQmiwOVcURqavpdHwNh8g1CLOSpqKxhOHSjsEnXvM0MPjbt+MFgYuF
         A61MXrgKQ9Qrhya/x4AJ3Bd1IMTY3P2eklRwYXHcsxYFkbZ2jutMGCb3BBNEkRNvJ/Ub
         buCsYVzYXpDiTRJQUtnkt+F9K/u1IieZYdmmFoqEzb4igfwrU80eYNZJ9XpiKWhp7yra
         4tOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rnL+DT6WaAAlihW1AoN/tB2D11HIMglWHsy5YB9xalA=;
        b=TCD79YL9tT5EhQ+vAcvkedkjCYXdc0O06Pl48PKpnLulcZfNS4yadO5/+PuZcAjzLm
         VNGUnO4752lCgQmS6AV4EwNh119g71KsHEI2fKzam8Z1I7TLQKjSC3Aq5NMEk7ir4Cgs
         H9bLyw3/6t0A9xVtUETSBifFSExpj2uwkL8nzmBq0X3DhbJtaXKVaANFqNk4uVfuGNas
         oKrUwNYfnJizyRhM3pd8Qst+3yB6zz2ELFEg3KPv9auha2AmhLFi9G3lOFOjBPw1AYqk
         Q1V+APgrJat6H38Sp+vVVQSYwnvTql/CLnUEJqVvwPSoudoacayrbe2cHFLCQ2mhzrwR
         amOQ==
X-Gm-Message-State: AOAM531Cu+IfXFNCKRtWVBi2awGjx3PRT0w3WhNpyNu/JeLfCo3upiT7
        hpaCwrJjpyyfAP7eYxeUovk=
X-Google-Smtp-Source: ABdhPJzzuPrv2SqvZYSlUSsr3w1X7odtfbVxsd3yG7NU5OJbhDUx0qQgpnj5n0ROyUD9H8ZfXs+9rQ==
X-Received: by 2002:a17:906:24d3:: with SMTP id f19mr3326764ejb.391.1627661935282;
        Fri, 30 Jul 2021 09:18:55 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id cf16sm874035edb.92.2021.07.30.09.18.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jul 2021 09:18:54 -0700 (PDT)
Date:   Fri, 30 Jul 2021 19:18:52 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC net-next 2/2] net: dsa: mt7530: trap packets from
 standalone ports to the CPU
Message-ID: <20210730161852.4weylgdkcyacxhci@skbuf>
References: <20210728175327.1150120-1-dqfext@gmail.com>
 <20210728175327.1150120-3-dqfext@gmail.com>
 <20210729152805.o2pur7pp2kpxvvnq@skbuf>
 <CALW65jbHwRhekX=7xoFvts2m7xTRM4ti9zpTiah8ed0n0fCrRg@mail.gmail.com>
 <20210729165027.okmfa3ulpd3e6gte@skbuf>
 <CALW65jYYmpnDou0dC3=1AjL9tmo_9jqLSWmusJkeqRb4mSwCGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALW65jYYmpnDou0dC3=1AjL9tmo_9jqLSWmusJkeqRb4mSwCGQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 30, 2021 at 11:45:41PM +0800, DENG Qingfang wrote:
> On Fri, Jul 30, 2021 at 12:50 AM Vladimir Oltean <olteanv@gmail.com> wrote:
> > I have the MT7621 GSW, and sadly this reference manual isn't the best in
> > explaining what is and what is not possible. For example, I am still not
> > clear what is meant by "VID1" and "VID0". Is "VID1" the inner (customer)
> > VLAN tag, and "VID0" the outer (service) VLAN tag, or "VID1" means the
> > actual VLAN ID 1?
> >
> > And the bits 3:1 of VAWD1 (VLAN table access register) indicate a FID
> > field per VLAN. I cannot find the piece that you quoted in this manual.
> > But what I expect to happen for a Transparent Port is that the packets
> > are always classified to that port's PVID, and the VLAN Table is looked
> > up with that PVID. There, it will find the FID, which this driver
> > currently always configures as zero. In my manual's description, in the
> > "Transparent Port" chapter, it does explicitly say:
> >
> >         VID0 and VID1 will store PVID as the default VID which is used
> >         to look up the VLAN table.
> >
> > So I get the impression that the phrase "the VLAN table is not applicable"
> > is not quite correct, but I might be wrong...
> 
> Alright, I think I've made some progress.
> In the current code, we only use two combinations to toggle user
> ports' VLAN awareness: one is PCR.PORT_VLAN set to port matrix mode
> with PVC.VLAN_ATTR set to transparent port, the other is PCR.PORT_VLAN
> set to security mode with PVC.VLAN_ATTR set to user port.
> 
> It turns out that only PVC.VLAN_ATTR contributes to VLAN awareness.
> Port matrix mode just skips the VLAN table lookup. The reference
> manual is somehow misleading when describing PORT_VLAN modes (See Page
> 17 of MT7531 Reference Manual, available at
> http://wiki.banana-pi.org/Banana_Pi_BPI-R64#Resources). It states that
> PORT_MEM (VLAN port member) is used for destination if the VLAN table
> lookup hits, but actually it uses **PORT_MEM & PORT_MATRIX** (bitwise
> AND of VLAN port member and port matrix) instead, which means we can
> have two or more separate VLAN-aware bridges with the same PVID and
> traffic won't leak between them.

Ah, but it's not completely misleading. It does say:

	2'b01: Fallback mode

	Enable 802.1Q function for all the received frames.
	Do not discard received frames due to ingress membership violation.
	**Frames whose VID is missed on the VLAN table will be filtered
	by the Port Matrix Member**.

(emphasis mine on the last paragraph)

> So I came up with a solution: Set PORT_VLAN to fallback mode when in
> VLAN-unaware mode, this way, even VLAN-unaware bridges will use
> independent VLAN filtering.

If you did indeed test that the Port Matrix is still used to enforce
separation between ports if the VLAN table _does_ match and we're in
fallback mode, then we should be okay.

> Then assign all standalone ports to a reserved VLAN.

You mean all standalone ports to the same VLAN ID, like 4095, or each
standalone port to a separate reserved VLAN ID? As long as address
learning is disabled on the standalone ports, I guess using a single
VLAN ID like 4095 for all of them is just fine, the Port Matrix will
take care of the rest.
