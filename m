Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A33D822D794
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 14:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726870AbgGYMta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 08:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726728AbgGYMt3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 08:49:29 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69BDBC0619D3
        for <netdev@vger.kernel.org>; Sat, 25 Jul 2020 05:49:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=LMOE/qlz5HT4t+wRZemGaaTpMEHo2jTlAXfkLQuMOJw=; b=lzBoNKkuriA37d2G7FE/Q06po
        yBDd64aYwH5Pm6ZQtt2W5jtcvdanHSpt6sy/v6KaaJiAJySlXRyPoYA2r+SzGOv0kZNK5S9ogwnaX
        S/2uj/Dxg2U9jTnoQXT0qxuU2GzKw+Obf0WwpJyqv1AK2ddN2Xc7a2TrWQXwGjVIKK2SuY+p4lQoO
        tAaHUfY1kAVS1kpFcXzFuvAcCZy4r4gjilVXELRM6EyJZSGV2YhDAUwt3lynd3nP2H34XTgUwF8Fi
        qNDxpZDuxWjakNUNrwzbMc0EXkCNPIj6gHWO+mmk9khm2Fku6bI8w613R3b0hkGo5j2KGykGxbR5t
        nQ7pIchmQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:43980)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jzJcG-0000xZ-2t; Sat, 25 Jul 2020 13:49:28 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jzJcF-0001fM-MW; Sat, 25 Jul 2020 13:49:27 +0100
Date:   Sat, 25 Jul 2020 13:49:27 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: phc2sys - does it work?
Message-ID: <20200725124927.GE1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I've been writing another PTP clock driver, and I'm wondering whether
phc2sys is actually working correctly.

I'm running it with: phc2sys -c /dev/ptp1 -s CLOCK_REALTIME -q -m -O 0
and I have additional pr_info() to debug in the clock driver.

What I see is the "sys offset" that phc2sys comes out with doesn't
seem to make much sense:

kt: 000000005f1c273ds 371ce3f5ns t: 00005f1c273ds 374c6cf5.2ae8ac76ns
kt: 000000005f1c273ds 377bf04cns t: 00005f1c273ds 37ab792b.4ef91e82ns
kt: 000000005f1c273ds 37daf7ccns t: 00005f1c273ds 380a80c3.5d12653ans
kt: 000000005f1c273ds 383a143cns t: 00005f1c273ds 38699d5c.cf1319f2ns
kt: 000000005f1c273ds 38992094ns t: 00005f1c273ds 38c8a9c8.f4247162ns
kt: 000000005f1c273ds 38f82d13ns t: 00005f1c273ds 3927b640.196edf5ans
kt: 000000005f1c273ds 3957323bns t: 00005f1c273ds 3986bb74.1c28a8fans
kt: 000000005f1c273ds 39b643e3ns t: 00005f1c273ds 39e5cd56.5b34c14ens
kt: 000000005f1c273ds 3a155d5ans t: 00005f1c273ds 3a44e6bf.be0b79e6ns
kt: 000000005f1c273ds 3a746fcans t: 00005f1c273ds 3aa3f943.001a4266ns
phc2sys[127.224]: /dev/ptp1 sys offset      5788 s2 freq  -69793 delay 6229046

Here, ktime_real (kt) is behind the ptp timestamp (t), and we have a
positive "sys offset".  This continues for a while:

kt: 000000005f1c2743s 0e1c25bdns t: 00005f1c2743s 0e4ba86d.91ebf06ans
kt: 000000005f1c2743s 0e7b3801ns t: 00005f1c2743s 0eaaba44.601c1f30ns
kt: 000000005f1c2743s 0eda4225ns t: 00005f1c2743s 0f09c4c3.0fa0d134ns
kt: 000000005f1c2743s 0f395a82ns t: 00005f1c2743s 0f68dd0a.f8abbf48ns
kt: 000000005f1c2743s 0f986abens t: 00005f1c2743s 0fc7ed41.c00f543cns
kt: 000000005f1c2743s 0ff773cans t: 00005f1c2743s 1026f675.6a32920cns
kt: 000000005f1c2743s 1056784ens t: 00005f1c2743s 1085fad9.003b24aans
kt: 000000005f1c2743s 10b57fcans t: 00005f1c2743s 10e50267.a378bd3cns
kt: 000000005f1c2743s 111481f6ns t: 00005f1c2743s 1144047b.2fde6accns
kt: 000000005f1c2743s 117387b9ns t: 00005f1c2743s 11a30a5c.cc1d52b4ns
phc2sys[132.536]: /dev/ptp1 sys offset      4882 s2 freq  -62617 delay 6227425

kt is still behind t, and we still have a positive "sys offset".

kt: 000000005f1c2744s 11d56067ns t: 00005f1c2744s 120473bd.c6a08dbfns
kt: 000000005f1c2744s 12346f54ns t: 00005f1c2744s 1263806f.d008fce3ns
kt: 000000005f1c2744s 12937d7ans t: 00005f1c2744s 12c28c2b.d57fe555ns
kt: 000000005f1c2744s 12f29f00ns t: 00005f1c2744s 1321ab52.2aa69e70ns
kt: 000000005f1c2744s 1351aedens t: 00005f1c2744s 1380b903.38258359ns
kt: 000000005f1c2744s 13b0c614ns t: 00005f1c2744s 13dfcdef.635079dbns
kt: 000000005f1c2744s 140fd641ns t: 00005f1c2744s 143edba0.70cf5ec4ns
kt: 000000005f1c2744s 146ee8c7ns t: 00005f1c2744s 149debf2.8913fe8dns
kt: 000000005f1c2744s 14cdf64dns t: 00005f1c2744s 14fcf6d6.8b147d37ns
kt: 000000005f1c2744s 152d1233ns t: 00005f1c2744s 155c10cf.caf99eb8ns
phc2sys[133.599]: /dev/ptp1 sys offset    -25014 s2 freq  -91049 delay 6229170

kt is still behind t, but now we have a negative "sys offset" ?

kt: 000000005f1c2745s 158f0f04ns t: 00005f1c2745s 15bd0ce3.e88dec93ns
kt: 000000005f1c2745s 15ee1e79ns t: 00005f1c2745s 161c1aa9.0c161488ns
kt: 000000005f1c2745s 16503ebcns t: 00005f1c2745s 167e3973.7b6c4843ns
kt: 000000005f1c2745s 16b0ebb1ns t: 00005f1c2745s 16dee4f2.436c858dns
kt: 000000005f1c2745s 1711806dns t: 00005f1c2745s 173f7822.7a65ccddns
kt: 000000005f1c2745s 177215f1ns t: 00005f1c2745s 17a00c04.b57f3ef8ns
kt: 000000005f1c2745s 17d15448ns t: 00005f1c2745s 17ff48bd.f1275cb3ns
kt: 000000005f1c2745s 1830735dns t: 00005f1c2745s 185e6670.73b72a47ns
kt: 000000005f1c2745s 188f95bbns t: 00005f1c2745s 18bd8724.082da8dbns
kt: 000000005f1c2745s 18ee9e77ns t: 00005f1c2745s 191c8e4e.044592dcns
phc2sys[134.662]: /dev/ptp1 sys offset    -98237 s2 freq -171776 delay 6227754

... and an even bigger negative "sys offset" but kt is still behind t.

kt: 000000005f1c2746s 16ad1681ns t: 00005f1c2746s 16db503d.5a2783d6ns
kt: 000000005f1c2746s 170f8b80ns t: 00005f1c2746s 173dc5a6.91660baans
kt: 000000005f1c2746s 176ed88fns t: 00005f1c2746s 179d1366.45f7dc3ans
kt: 000000005f1c2746s 17cdebcdns t: 00005f1c2746s 17fc2725.6da454bbns
kt: 000000005f1c2746s 182cfb23ns t: 00005f1c2746s 185b371b.6ab43403ns
kt: 000000005f1c2746s 188c0208ns t: 00005f1c2746s 18ba3e8f.07fd0ee9ns
kt: 000000005f1c2746s 18eb07fdns t: 00005f1c2746s 1919451f.9b3f2f2bns
kt: 000000005f1c2746s 194a13e3ns t: 00005f1c2746s 19785178.6fad0c97ns
kt: 000000005f1c2746s 19a915c8ns t: 00005f1c2746s 19d753fa.d549cdabns
phc2sys[135.674]: /dev/ptp1 sys offset    -77622 s2 freq -180632 delay 6226562

... same story.

I added the debug (which dramatically increased delay) because I notice
that phc2sys exhibits random sudden jumps in the "sys offset" value.
I've noticed it with this driver (which, without the debug, reports a
delay of around 5000) and also with the Marvell PHY PTP driver.  I had
put the Marvell PHY PTP driver instability down to other MDIO bus
activity, as the delay would increase, but that is not the case here.

There _is_ something odd going on with the adjfine adjustment, but I
can't fathom that (which is another reason for adding the above debug.)

If I undo some of the debug, this is the kind of thing I see:

phc2sys[20.697]: /dev/ptp1 sys offset         2 s2 freq  -25586 delay 5244
phc2sys[21.698]: /dev/ptp1 sys offset        17 s2 freq  -25570 delay 5262
phc2sys[22.698]: /dev/ptp1 sys offset       -11 s2 freq  -25593 delay 5250
phc2sys[23.698]: /dev/ptp1 sys offset       -14 s2 freq  -25600 delay 5265
phc2sys[24.698]: /dev/ptp1 sys offset       -17 s2 freq  -25607 delay 5250
phc2sys[25.698]: /dev/ptp1 sys offset        64 s2 freq  -25531 delay 5244
phc2sys[26.698]: /dev/ptp1 sys offset        -9 s2 freq  -25585 delay 5251
phc2sys[27.699]: /dev/ptp1 sys offset       -44 s2 freq  -25622 delay 5250
phc2sys[28.699]: /dev/ptp1 sys offset        35 s2 freq  -25557 delay 5262
phc2sys[29.699]: /dev/ptp1 sys offset   -433522 s2 freq -459103 delay 5256
phc2sys[30.699]: /dev/ptp1 sys offset   -500029 s2 freq -655667 delay 5228
phc2sys[31.700]: /dev/ptp1 sys offset   -369958 s2 freq -675604 delay 5259

Notice the sudden massive jump in sys offset.

Any ideas?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
