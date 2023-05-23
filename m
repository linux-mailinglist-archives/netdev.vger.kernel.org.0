Return-Path: <netdev+bounces-4688-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D21A70DE56
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 15:59:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 450C21C20C10
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 13:59:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A95A1F163;
	Tue, 23 May 2023 13:59:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45E7A6FC7
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 13:59:23 +0000 (UTC)
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDA16188
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 06:58:57 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id ffacd0b85a97d-3093a7b71fbso7151030f8f.2
        for <netdev@vger.kernel.org>; Tue, 23 May 2023 06:58:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684850336; x=1687442336;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eTG4I00OdncI2kO0+vNFZ+PMlNcgn2Bgm1t3CtdI79Q=;
        b=FY/5hp8ttXqdjlq76LG/8o4j7v3V5OUE5Uwh+RpTBGZLI//3ovWTM/Q42N1uPebLMx
         iU6Uo5Nll7bQuKbECIyikf7IKarmPFz29TlUynyHjcnxPaVA19XjzrM91ANEUpYE2KoS
         7YRCxy7Lw3vW94LBfN+88jMkd3CJDv2adWE9MnhpyRAIDGERGEB4OQE5JVpEjXBV9bWt
         JZjEmpxIGEdS/6fC36Pain5vZaklMx8zKMuMQPtGwfKV80jIch/Vxxwk3D0TQ4KPbD+Q
         HG93SPlGiKwljpY4C+1SHOsqk8BjkRK4ru7Lu1Ga7PfYFf77romlZrOoHiPPmZgJZlSU
         S2IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684850336; x=1687442336;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eTG4I00OdncI2kO0+vNFZ+PMlNcgn2Bgm1t3CtdI79Q=;
        b=VsxlCOcgcuLXNQqTNy8eeX9pjiz9laRTpt/UVMfTR8NKEWFiCJhwiADZEqojTpZS+U
         O7BfpcbUAuvFrLJ9WnAg+OtwsH8/GG/1frRDC7aysCyCFA40v3geaJ+aPyy4hEpSD4Qe
         F3yOnaRz3A27LyibESEiepQ99JB/CXSI+16sGEFnXOdhywXtiLB/0OlnVHtMvDpKuM5b
         vaKGvy4TwIEZ/eU+whnbmh/b9A+OIgCd7sbMch8kDMhXNbIiBhSfFgN0U6pl/mzFqGub
         0WulQ57yzY67dh55E3ecsTGyzVu9cMPqnF55Nu5XiFd+vKfdDv4jrQDW2bHPNgzTqb41
         W85w==
X-Gm-Message-State: AC+VfDy7arlXBz5xoljrm2/jwKANUug7slL/jhJAW0z7yxf6ihpwfdsl
	144RiMFtWMW7Ej9u1E9xE2xuB7/y9IQ=
X-Google-Smtp-Source: ACHHUZ6I2xk+pFTxHpVm+QAytNVg/Xvn+uuJ3VfHJfZKB2i+fNAo0NpyilG+nKE+W0ViSpYeHv1qpQ==
X-Received: by 2002:a5d:564a:0:b0:306:2fd3:2edb with SMTP id j10-20020a5d564a000000b003062fd32edbmr9209716wrw.61.1684850335733;
        Tue, 23 May 2023 06:58:55 -0700 (PDT)
Received: from localhost (2a01cb008a61c2011e062e3ebf80f2e8.ipv6.abo.wanadoo.fr. [2a01:cb00:8a61:c201:1e06:2e3e:bf80:f2e8])
        by smtp.gmail.com with ESMTPSA id x2-20020adfdcc2000000b003077f3dfcc8sm11084792wrm.32.2023.05.23.06.58.55
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 06:58:55 -0700 (PDT)
Date: Tue, 23 May 2023 15:58:54 +0200
From: Moviuro <moviuro@gmail.com>
To: netdev@vger.kernel.org
Subject: Secondary bond slave receiving packets when preferred is up
Message-ID: <ZGzGngNhahy6kGBG@toxoplasmosis>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi there,

On 2 similar machines, some (random?) packets are received on a wireless
bond slave when the preferred eth interface is connected: this causes
local packet loss and at worst, disconnects (e.g. SSH and KDEConnect).

My setup looks fine, inspired by the Arch wiki[0], see
/proc/net/bonding/bond0 below. The archlinux community has not been able
to help so far[1].

     +-----------+                
     |Router .1  |                
     +-----+-----+                
           |                      
     +-----+-----+                
     |Switch .30 +---------------+
     +--+--------+-------------+ |
        |                      | |
        |                      | |
 +------+--+    +-----------+  | |
 | WAP .21 +~~~~+Client .111+--+ |
 +------+--+    +-----------+    |
        |                        |
        |       +-----------+    |
        +~~~~~~~+Client .149-----+
                +-----------+     

Running ping(8) for a few hours, there's nothing much going on, packet
loss is really because ICMP packets end up on the WiFi interface:

* .1 -> .149: 56436 sent, 56405 replies
* .1 -> .111: 20643 sent, 20640 replies
* .111 -> .149: 7682/7702 packets
* .149 -> .111: 14791/14792 packets

Sure enough, there's some noise on the WiFi interface:

root@149 # tcpdump -ttttnei wlp3s0 host 192.168.1.149 and not arp
2023-05-23 09:29:46.771535 11:11:11:11:11:74 > BB:BB:BB:BB:BB:33, ethertype IPv4 (0x0800), length 98: 192.168.1.1 > 192.168.1.149: ICMP echo request , id 64306, seq 53425, length 64
2023-05-23 09:36:04.710859 bb:bb:bb:bb:bb:32 > BB:BB:BB:BB:BB:33, ethertype IPv4 (0x0800), length 98: 192.168.1.111 > 192.168.1.149: ICMP echo reque st, id 1, seq 2390, length 64

root@111 # tcpdump -ttttnei wlp5s0 not arp and host 192.168.1.111
2023-05-23 09:28:33.367805 pp:pp:pp:pp:pp:af > bb:bb:bb:bb:bb:32, ethertype IPv4 (0x0800), length 457: 192.168.1.173 > 192.168.1.111: ip-proto-17
2023-05-23 09:32:29.727948 21:21:21:21:21:ec > bb:bb:bb:bb:bb:32, ethertype IPv4 (0x0800), length 74: 192.168.1.21.45194 > 192.168.1.111.8080: Flags [S], seq 519821669, win 29200, options [mss 1460,sackOK,TS val 490237620 ecr 0,nop,wscale 5], length 0
[...]
2023-05-23 10:02:36.431322 11:11:11:11:11:74 > bb:bb:bb:bb:bb:32, ethertype IPv4 (0x0800), length 758: 192.168.1.1.22 > 192.168.1.111.44028: Flags [P.], seq 2394290223:2394290915, ack 741416096, win 271, options [nop,nop,TS val 1797716987 ecr 1795972790], length 692

I have also checked that there are not ARP messages from .111 or .149 on
their WiFi interfaces:

root@111 # tcpdump -ttttnei wlp5s0 arp
2023-05-23 11:29:16.487822 00:00:00:00:00:54 > ff:ff:ff:ff:ff:ff, ethertype ARP (0x0806), length 60: Request who-has 192.168.1.26 tell 192.168.1.100, length 46
2023-05-23 11:29:17.300904 00:00:00:00:00:54 > ff:ff:ff:ff:ff:ff, ethertype ARP (0x0806), length 60: Request who-has 192.168.1.26 tell 192.168.1.100, length 46
2023-05-23 11:29:18.904718 00:00:00:00:00:54 > ff:ff:ff:ff:ff:ff, ethertype ARP (0x0806), length 60: Request who-has 192.168.1.26 tell 192.168.1.100, length 46
2023-05-23 11:29:20.945890 30:30:30:30:30:d4 > ff:ff:ff:ff:ff:ff, ethertype ARP (0x0806), length 60: Request who-has 192.168.1.1 (ff:ff:ff:ff:ff:ff) tell 192.168.1.30, length 46
2023-05-23 11:29:26.986234 30:30:30:30:30:d4 > ff:ff:ff:ff:ff:ff, ethertype ARP (0x0806), length 60: Request who-has 192.168.1.1 (ff:ff:ff:ff:ff:ff) tell 192.168.1.30, length 46

After removing the .111 ARP entry from the router, no ARP reply on WiFi:
(it does show up when tcpdump(8)ing on the ethernet iface)

2023-05-23 11:31:28.986766 11:11:11:11:11:74 > ff:ff:ff:ff:ff:ff, ethertype ARP (0x0806), length 60: Request who-has 192.168.1.111 tell 192.168.1.1, length 46
# no reply! it happened on the eth iface
2023-05-23 11:31:33.925495 30:30:30:30:30:d4 > ff:ff:ff:ff:ff:ff, ethertype ARP (0x0806), length 60: Request who-has 192.168.1.1 (ff:ff:ff:ff:ff:ff) tell 192.168.1.30, length 46

I connect to the WiFi network using wpa_supplicant(8). Launching
wpa_supplicant in debug mode (-dd) yields some additional messages but
they never coincide with packets getting received on the WiFi interface.

So I'm at a loss here. The bonding documentation doesn't say anything
about needing special networking hardware (on the clients or on the
network).

[0] https://wiki.archlinux.org/title/systemd-networkd#Bonding_a_wired_and_wireless_interface
[1] https://bbs.archlinux.org/viewtopic.php?id=285633

user@111 % cat /proc/net/bonding/bond0 
Ethernet Channel Bonding Driver: v6.3.2-1-clear

Bonding Mode: fault-tolerance (active-backup)
Primary Slave: enp4s0 (primary_reselect always)
Currently Active Slave: enp4s0
MII Status: up
MII Polling Interval (ms): 1000
Up Delay (ms): 0
Down Delay (ms): 0
Peer Notification Delay (ms): 0

Slave Interface: wlp5s0
MII Status: up
Speed: Unknown
Duplex: Unknown
Link Failure Count: 0
Permanent HW addr: ww:ww:ww:ww:ww:c8
Slave queue ID: 0

Slave Interface: enp4s0
MII Status: up
Speed: 1000 Mbps
Duplex: full
Link Failure Count: 0
Permanent HW addr: ee:ee:ee:ee:ee:ac
Slave queue ID: 0

user@149 % cat /proc/net/bonding/bond0
Ethernet Channel Bonding Driver: v6.3.2-zen1-1.1-zen

Bonding Mode: fault-tolerance (active-backup)
Primary Slave: enp0s31f6 (primary_reselect always)
Currently Active Slave: enp0s31f6
MII Status: up
MII Polling Interval (ms): 1000
Up Delay (ms): 0
Down Delay (ms): 0
Peer Notification Delay (ms): 0

Slave Interface: wlp3s0
MII Status: up
Speed: Unknown
Duplex: Unknown
Link Failure Count: 0
Permanent HW addr: WW:WW:WW:WW:WW:70
Slave queue ID: 0

Slave Interface: enp0s31f6
MII Status: up
Speed: 1000 Mbps
Duplex: full
Link Failure Count: 1
Permanent HW addr: EE:EE:EE:EE:EE:4f
Slave queue ID: 0

Networking hardware list:

* Switch https://eu.store.ui.com/eu/en/collections/unifi-switching-standard-power-over-ethernet/products/usw-24-poe
* WAP https://eu.store.ui.com/eu/en/collections/unifi-wifi-flagship-compact/products/u6-lite

Client hardware:

* 111: AsRock B550 Phantom Gaming-ITX/ax: https://pg.asrock.com/mb/AMD/B550%20Phantom%20Gaming-ITXax/index.asp#Specification
* 149: MSI Z170A SLI Plus: https://www.msi.com/Motherboard/Z170A-SLI-PLUS/Specification
* 149: Intel Corporation Dual Band Wireless-AC 7260 [Wilkins Peak 2]: https://ark.intel.com/content/www/us/en/ark/products/75439/intel-dual-band-wirelessac-7260.html

