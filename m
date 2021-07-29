Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFE933DA966
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 18:50:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230040AbhG2Que (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 12:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbhG2Que (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 12:50:34 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD6FC061765;
        Thu, 29 Jul 2021 09:50:30 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id f13so9035236edq.13;
        Thu, 29 Jul 2021 09:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ge2c2dD+EBmDmaGN5nupteoqdj28OTIbcgEuzsesBTw=;
        b=qL2Rj3JukTZAxtcWyetmk0LTL3hs8/mi9vn+JdDmSkmyeRjbMqR9jXg8gFWsv6kGdz
         O0mVq9BBHW+9GVS+YDVrhRf0mXLlO5vCDryASFucgvyh0dkAlvrfzd/ieoXEO75YfthV
         P3NThxNT4ZFkznm+Tkruy0vS3BJakX4rGnzOqjRuyu1qC9V8Ydx9GUQnjJbXIy+Y6DOo
         Jwx+w1uqo7G9P/fIIdEpYI81sGJQaMfU4fn1MlNIs6Uh8wlE1YenINqJN6SFKeF6cmN6
         l1l0o1orLp4On4m4sET2NN461fgFveISmPlIFkRWIAH9vXEz16WarCNbpNHwG+kNT+SC
         a2oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ge2c2dD+EBmDmaGN5nupteoqdj28OTIbcgEuzsesBTw=;
        b=NApSNNceX5ZCGj1961NQBOXyuM1Ed7PDhy5k3bBD+2XFrFaVt2xhLU/AdnHhvfF57e
         1TgXm+FpqdeL6so4uLtxSUu2XWiznLVSXQUZST+EJgjCtVKyFkQNSR9rNQVSe1CVeI6Y
         9qU9iCuzG0gwHWrLRZgBotWKl0s0y3h33DrsSUOt1JYxi8LUoz5WKElkKq3TIikGwUCs
         bozuLZZTQmKuyrUxDKKq0JlNy7c6/8YkxwGI1T8NnZCGEUvVzjFULrhjpmBJikki7cAn
         dK6+pLuLyiBL0+OqOTVngmh5DU26UNiDaL46o7Q0ghVTU9sI8lnkgjn8xLayEo7VVF0i
         bt9g==
X-Gm-Message-State: AOAM532QB+iAD6vgd0fydb39DOrRw01p5AmuTdxpu8dO6Tr0kCnsfQSl
        1qCXuLglKeDxJJTx6sNJj7M=
X-Google-Smtp-Source: ABdhPJw3QV3+/J7tiE+JZbeIL/dUyVkeZkd4O2CYoDmctiP9takCqIOmAAt5RBeHoxF+m8qK2doyCw==
X-Received: by 2002:a05:6402:d63:: with SMTP id ec35mr7069658edb.347.1627577429163;
        Thu, 29 Jul 2021 09:50:29 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id la23sm1155008ejc.63.2021.07.29.09.50.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 09:50:28 -0700 (PDT)
Date:   Thu, 29 Jul 2021 19:50:27 +0300
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
Message-ID: <20210729165027.okmfa3ulpd3e6gte@skbuf>
References: <20210728175327.1150120-1-dqfext@gmail.com>
 <20210728175327.1150120-3-dqfext@gmail.com>
 <20210729152805.o2pur7pp2kpxvvnq@skbuf>
 <CALW65jbHwRhekX=7xoFvts2m7xTRM4ti9zpTiah8ed0n0fCrRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALW65jbHwRhekX=7xoFvts2m7xTRM4ti9zpTiah8ed0n0fCrRg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 30, 2021 at 12:11:45AM +0800, DENG Qingfang wrote:
> On Thu, Jul 29, 2021 at 11:28 PM Vladimir Oltean <olteanv@gmail.com> wrote:
> > Actually, on second thought...
> > If MT7530 supports 8 FIDs and it has 7 ports, then you can assign one
> > FID to each standalone port or VLAN-unaware bridge it is a member of.
> 
> The problem is, there is no way to do that..
> 
> According to the reference manual:
> Filter ID is learned automatically from VLAN Table. 0 is the default value if
> VLAN Table is not applicable.
> 
> So it is always 0 in VLAN-unaware mode.

I have the MT7621 GSW, and sadly this reference manual isn't the best in
explaining what is and what is not possible. For example, I am still not
clear what is meant by "VID1" and "VID0". Is "VID1" the inner (customer)
VLAN tag, and "VID0" the outer (service) VLAN tag, or "VID1" means the
actual VLAN ID 1?

And the bits 3:1 of VAWD1 (VLAN table access register) indicate a FID
field per VLAN. I cannot find the piece that you quoted in this manual.
But what I expect to happen for a Transparent Port is that the packets
are always classified to that port's PVID, and the VLAN Table is looked
up with that PVID. There, it will find the FID, which this driver
currently always configures as zero. In my manual's description, in the
"Transparent Port" chapter, it does explicitly say:

	VID0 and VID1 will store PVID as the default VID which is used
	to look up the VLAN table.

So I get the impression that the phrase "the VLAN table is not applicable"
is not quite correct, but I might be wrong...
