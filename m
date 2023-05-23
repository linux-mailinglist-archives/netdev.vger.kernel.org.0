Return-Path: <netdev+bounces-4826-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EC5C870E954
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 01:01:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7D57D2810C9
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 23:01:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84DD117746;
	Tue, 23 May 2023 23:01:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 725284A3B
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 23:01:46 +0000 (UTC)
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC432C2
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 16:01:43 -0700 (PDT)
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id EBB993F47C
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 23:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1684882901;
	bh=8eh5/RZ1N4hnvYM9TSbF70KmmaCoxIxAy/wgcy8i48I=;
	h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
	 Content-Type:Date:Message-ID;
	b=tN5WgQ0WwtNgVBWTOafp9f3j08G6J2D4hOe7y5gD3BzLri5w/Fs53AjCzHC5ZR0bC
	 88np+bVWP+laPu5TfCdRouYS8wqc/kFk74DVMW0p6jjeiTSLNJ98sgrE4/VvXuZhnT
	 trMdVwV24qkPc8W5GeIddhwYJ+dObaUPctSutkUweAY52lKZ/COdUAEV7kVwnYPMH4
	 NMBcw2CIWLL5eO4MWS/uHlt6g0ByDaWn4x6vgne1KHtd6OU9SoFJjtNVsU0w3ipK9A
	 aohQF9D/98htFrvmOCgkfprAyd7956ckD7GmweI4x6SEz27J7iBd4US9wxGUOT1ayN
	 PYJQ+Jr/w2Z9g==
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-53b9eb7bda0so87400a12.0
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 16:01:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684882900; x=1687474900;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8eh5/RZ1N4hnvYM9TSbF70KmmaCoxIxAy/wgcy8i48I=;
        b=A4ptR6OwOWSBS8OBgMPtkzNzQ0u7Pk9Pl43HoHodNwI85hcGtHDu4W1ws6GIboitui
         Bl/8Mv5dVwhBF6HCUeBxVwS++cxQvbwgNRdKyuvC3ytt6Ki/+dh5vA7ybp0ZEFQ0bkIb
         1gnPxTuHkrKx4p4V2teDetSFBe567Yu9u6VA5B+xavRu07MHMAEU4p5MxlalEfAn7zI9
         lNcT1+Q72A8L3n72R3+ey4igdMDxIskTp9yWaIg/dt94mhnBxNvqtcUXS1bTh1TeCogS
         vHBLEObNAhinzDoHhs8yskA4BtCp4Qsw/P0jrxaTxUjUUXiISfHcIewMJ4ohy1lFcXZD
         sS4g==
X-Gm-Message-State: AC+VfDw1OtWhBBtEOPTmcKw1VB1tr3Eut5ty317tzGLcivb33GQwIzYa
	qWJlWCXYoH4EeKc0OO5sgZoFwg+YtnOBoWaLSXWWF3g54Ut6CAwBljAhKRZ6dwxicROmBWyiuwb
	nwbnbakVLNCGK+FT8YsyT1shH76HKiJlis6sY2AAd0g==
X-Received: by 2002:a17:902:bf06:b0:1a6:bd5c:649d with SMTP id bi6-20020a170902bf0600b001a6bd5c649dmr13486620plb.56.1684882900194;
        Tue, 23 May 2023 16:01:40 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4wVD6c70MMUNYLcSLil+HTKwdONPE9r3CgomiB3YnVizq6HebbE5Byb61dKX4i8L+Jym8AYQ==
X-Received: by 2002:a17:902:bf06:b0:1a6:bd5c:649d with SMTP id bi6-20020a170902bf0600b001a6bd5c649dmr13486607plb.56.1684882899833;
        Tue, 23 May 2023 16:01:39 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.253])
        by smtp.gmail.com with ESMTPSA id iw10-20020a170903044a00b001ac2f98e953sm7271508plb.216.2023.05.23.16.01.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 May 2023 16:01:39 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
	id DD4C660451; Tue, 23 May 2023 16:01:38 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
	by famine.localdomain (Postfix) with ESMTP id D6570A02D2;
	Tue, 23 May 2023 16:01:38 -0700 (PDT)
From: Jay Vosburgh <jay.vosburgh@canonical.com>
To: Moviuro <moviuro@gmail.com>
cc: netdev@vger.kernel.org
Subject: Re: Secondary bond slave receiving packets when preferred is up
In-reply-to: <ZGzGngNhahy6kGBG@toxoplasmosis>
References: <ZGzGngNhahy6kGBG@toxoplasmosis>
Comments: In-reply-to Moviuro <moviuro@gmail.com>
   message dated "Tue, 23 May 2023 15:58:54 +0200."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <17784.1684882898.1@famine>
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 May 2023 16:01:38 -0700
Message-ID: <17785.1684882898@famine>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Moviuro <moviuro@gmail.com> wrote:

>Hi there,
>
>On 2 similar machines, some (random?) packets are received on a wireless
>bond slave when the preferred eth interface is connected: this causes
>local packet loss and at worst, disconnects (e.g. SSH and KDEConnect).
>
>My setup looks fine, inspired by the Arch wiki[0], see
>/proc/net/bonding/bond0 below. The archlinux community has not been able
>to help so far[1].
>
>     +-----------+                =

>     |Router .1  |                =

>     +-----+-----+                =

>           |                      =

>     +-----+-----+                =

>     |Switch .30 +---------------+
>     +--+--------+-------------+ |
>        |                      | |
>        |                      | |
> +------+--+    +-----------+  | |
> | WAP .21 +~~~~+Client .111+--+ |
> +------+--+    +-----------+    |
>        |                        |
>        |       +-----------+    |
>        +~~~~~~~+Client .149-----+
>                +-----------+     =

>
>Running ping(8) for a few hours, there's nothing much going on, packet
>loss is really because ICMP packets end up on the WiFi interface:
>
>* .1 -> .149: 56436 sent, 56405 replies
>* .1 -> .111: 20643 sent, 20640 replies
>* .111 -> .149: 7682/7702 packets
>* .149 -> .111: 14791/14792 packets
>
>Sure enough, there's some noise on the WiFi interface:
>
>root@149 # tcpdump -ttttnei wlp3s0 host 192.168.1.149 and not arp
>2023-05-23 09:29:46.771535 11:11:11:11:11:74 > BB:BB:BB:BB:BB:33, etherty=
pe IPv4 (0x0800), length 98: 192.168.1.1 > 192.168.1.149: ICMP echo reques=
t , id 64306, seq 53425, length 64
>2023-05-23 09:36:04.710859 bb:bb:bb:bb:bb:32 > BB:BB:BB:BB:BB:33, etherty=
pe IPv4 (0x0800), length 98: 192.168.1.111 > 192.168.1.149: ICMP echo requ=
e st, id 1, seq 2390, length 64

	Some amount of random traffic arriving on the inactive interface
of an active-backup bond is expected; switches send traffic to such
places for various reasons.  My initial guess would be that the switch's
forwarding entry for whatever BB:BB:BB:BB:BB:33 is expired, and the
switch flooded traffic for that destination to all ports.  As an aside,
what is that MAC address?  The last octet (33) doesn't appear in any of
the bond info dumps you list later for the .149 host.

	In any event, an inactive bond interface will pass incoming
traffic in two cases:

	1) its destination MAC address is in the link local reserved
range, 01:80:c2:00:00:0?, which is used for things like Spanning Tree or
LACP; the complete list can be found at

https://standards.ieee.org/products-programs/regauth/grpmac/public/

	These should not be ARP or IP, and this is unlikely to be your
situation.

	2) Something is bound directly to the bond interface itself via
a raw socket or the like; an example of this is LLDP, which needs to
exchange protocol frames at the interface level.

	Even if the bond accepted some IP traffic on the inactive
interface and sent it up the stack, any reply should go back out the
active interface.  This is based on the lack of failovers in the bond
status stuff, and presuming that the routing table on .111 and .149 is
what I'd expect (basically, a default route and subnet route for
192.168.1.0/24 that go through the bond only).

	Some suggestions that might help:

	1) Check rp_filter; if it's not enabled, then turn it on in
strict mode.  This means insuring that the sysctls for .all, the bond
and its interfaces are all set to 1, e.g.,

net.ipv4.conf.all.rp_filter =3D 1
net.ipv4.conf.bond0.rp_filter =3D 1
net.ipv4.conf.wlp5s0.rp_filter =3D 1
[... and so on ...]

	Setting any of them to 2 will enable loose mode (the maximum
value between .all and the interface is what counts).  Loose mode, or
rp_filter being off entirely, might be your problem if your routing is
not simple (e.g., you've got other IP networks that you didn't
describe).  The docs for this can be found at

https://docs.kernel.org/networking/ip-sysctl.html

	2) Enable the bonding option fail_over_mac =3D follow, this will
cause the MAC of the bond interfaces to not be all set to the same MAC.
If somehow the switch is getting confused by seeing the same MAC from
multiple ports, this may help.

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com

