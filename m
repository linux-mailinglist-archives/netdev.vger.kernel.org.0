Return-Path: <netdev+bounces-334-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C70B06F7201
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 20:39:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 08CBF1C21248
	for <lists+netdev@lfdr.de>; Thu,  4 May 2023 18:39:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F522BE63;
	Thu,  4 May 2023 18:39:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA104C69
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 18:39:31 +0000 (UTC)
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 493194EC4
	for <netdev@vger.kernel.org>; Thu,  4 May 2023 11:39:30 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1ab0b1ee76eso1217175ad.1
        for <netdev@vger.kernel.org>; Thu, 04 May 2023 11:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683225569; x=1685817569;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ehZuAmw3GYhEksIe47PtL2Ib/nyhsk2V69Qn2+qX3EQ=;
        b=ncw8qvhgeFeMJe1JQlTle2wN21mPOrW5nweJNBoa9Y2ugT++vTNKo7pwytQBE2FowA
         mstwMEsGCnP+P0lCDjV1j5/+//T3xhDkzFYSw+Skvi6skEVLquUK0eGTXXl9WINPd1RB
         Gjkru245H0Nb9fKcbMVhioACbTXnwxkcanzj+sRQ32cGNIjmff7f5wOZ7NMPckcW0C/7
         y78AAWXhAheroiMXX7f4gkPXRRH4rQdcLSUeSoc4Sicm8Fjc5KNg8Q2TDwcT0LK8xk/+
         5fzUWKmW+IFI2F/hNFi+74QGe66E+pFRIrTWpPuUNseLsnc5qZNDt6rjLEBoLSUHBAIJ
         qNyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683225569; x=1685817569;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ehZuAmw3GYhEksIe47PtL2Ib/nyhsk2V69Qn2+qX3EQ=;
        b=SnSmdx1MA188IHd/I5YGoaxCpD62i+q8Zfl7aOKIyv0xdatFqMTK0tddQQtZIRhGn4
         pEJ2ioWpSyGnCdMsLo1IF+Ih2ZeyydCtoalDyIq3a787U7ZEIaUNmp8x5aPQfSYsMSJH
         KdYw8ZpON+m2GRJfEAWHs8CPa23eq1CO3mzQgUYdAdexJrz3NmBMLlnPVCDDCAhm2VEp
         oHNIGTG+mDdW+kWO6dRZ7Y1u6eLCuPN8bMB8JYRGcaueiP/FNeoGWbK4MBJkLA2KWvJo
         I9/+qRZo7avKvAXZQTFyx1VVKigxfrXL5NY6I7P7yVskaAKTO8i0jv4GAKa0gbLONGEH
         8R3w==
X-Gm-Message-State: AC+VfDztaCiLfpM5QkfuBvpHrFNGtb5SSPMdAYdjdHhyipfQDzTyv13P
	/HjM84oMvEKfYJqoxr055hxcHjQe7MVegjPzqlnSXlP6kD8=
X-Google-Smtp-Source: ACHHUZ47NJKGKF69G/qJ23lWrvBdVYCC8wL1JEZ5KpqGO52zk8BwG2piINqWRnRdWljbcc9tOerTnrAI0y9n/ZQF2Do=
X-Received: by 2002:a17:902:ecc7:b0:1a0:53ba:ff1f with SMTP id
 a7-20020a170902ecc700b001a053baff1fmr12677409plh.0.1683225568723; Thu, 04 May
 2023 11:39:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Fabio Estevam <festevam@gmail.com>
Date: Thu, 4 May 2023 15:39:17 -0300
Message-ID: <CAOMZO5AMOVAZe+w3FiRO-9U98Foba5Oy4f_C0K7bGNxHA1qz_w@mail.gmail.com>
Subject: mv88e6320: Failed to forward PTP multicast
To: Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>, 
	Florian Fainelli <f.fainelli@gmail.com>, =?UTF-8?Q?Steffen_B=C3=A4tz?= <steffen@innosonix.de>
Cc: netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

We are running kernel 6.1.26 on an imx8mn-based board with a Marvell
mv88e6320 switch.

eth1 and eth2 are the mv88e6320 ports. We connect a PTP sync source to eth1
and we notice that after setting up vlan_filtering on a bridge, the PTP
packets are no longer forwarded by the switch.

Below is the networking setup.

It does not matter if we assign an IP and sniff on the br0 or on the veth2,
PTP multicast is not appearing. Some multicast like ARP does come through.
Flags on br0: multicast_snooping = 1, mcast_flood  =1, mcast_router = 1

Any ideas as to how we can get the PTP packets to be forwarded?

Thanks,

Fabio Estevam

# Add bridge
ip link add name br0 type bridge
sleep 1

# Activate VLAN filtering
ip link set dev br0 type bridge vlan_filtering 1

# Add veth pairs
 ip link add veth1 type veth peer name veth2

sleep 1
# Set Interfaces to be part of the bridge
ip link set eth1 master br0
ip link set eth2 master br0
ip link set veth1 master br0

sleep 1
# Bring down interfaces
ip link set eth1 down
ip link set eth2 down

sleep 1
# Bring up interfaces
ip link set br0 up
ip link set veth1 up
ip link set veth2 up
ip link set eth1 up
ip link set eth2 up

sleep 1
ip addr add 192.168.0.1/24 dev veth2

tcpdump -i veth2 dst port 319 or dst port 320

