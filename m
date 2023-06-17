Return-Path: <netdev+bounces-11663-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 95453733D75
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 03:46:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 62C5B1C210BE
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 01:46:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48EA07FF;
	Sat, 17 Jun 2023 01:46:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355B67FA
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 01:46:00 +0000 (UTC)
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 384243AB4
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 18:45:59 -0700 (PDT)
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 9ED6E3F215
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 01:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1686966356;
	bh=Tt/zN87g9bXMW+1NAucl6kUM5qTXCsEiMDwkwoDScFw=;
	h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
	 Content-Type:Date:Message-ID;
	b=Ox5UdjmJGNisfw5iRxzp8xGbsmwZxW+AdcpJrzUopaf/EE/lsoPCB4pQPe20qedx8
	 UDSYoe5JXYxtrXSMWJOXb40Z7WrBoFbDzjvQPsBPZ173oYZHBkETQUj1XRTSRI2seC
	 s1GDRamTGYcd8sAbqhilIMuBzqb1WasBGfDVD+8P6jhB+1vCgF6w0OWhZ6i8QPeGIf
	 gzWxGgpaQGfvGGimx9qJSfUpHbzf++HOkMtw6S0roRnGAOMSgC/lA543YUPSBD+Sz0
	 f1YRZaY/7UFKxw4Cy5QM0PpbZHdmjLAySsdLjDD5YCowFjSMeRwef8Gm5z3J5KNRyj
	 lReu8xbeVwFrg==
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-1b4fffd6a20so10380395ad.2
        for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 18:45:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686966355; x=1689558355;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Tt/zN87g9bXMW+1NAucl6kUM5qTXCsEiMDwkwoDScFw=;
        b=Ob1O8dqcFxRzeBpUK+PYnyVY8KpAWpxGwP7+vHogVtR6nEvvorcTI3YxfZGIsPPKyo
         227ShuLIajlEIdWGs7juZPv2a7iaH0VGNlv2uRIBDvz/L1+TAAi5M3tqXU2niMfwHpRH
         qBVl//JBAK3dD1OOX9620Yfz2eIVrz9gncoQe8tkHe94u4T79oh+WZSuWq9oRokAW3LO
         32T88m8FMw8kdRemw6ldpQxXBQx14Bjx/Rx9pDeEJ82rK2pgM8ipg9bTAV57+d650eO9
         UaD4NE2wVomL2lbxa8ggc9POGt642uEpbmkbJU0/ritFD4ATkBiS7lOM/NYYdBgco2YE
         OrCw==
X-Gm-Message-State: AC+VfDzW8ghJZQZcl/sl1+Km0mJ6Rn2Ro1RoJ+Rsm5wtOdAii23AHjbl
	RyFBBCJjLnHpomxVTTubCyYulyhiUUMVsQmy1PUtCobmhSOQTODHFs7+bBLEu6fAaNvWsivdwKi
	NKYGlQnrzZ8UCWtTq0y36cl62/bGuJ8EE7w==
X-Received: by 2002:a17:902:e54b:b0:1b5:368b:36ad with SMTP id n11-20020a170902e54b00b001b5368b36admr3157134plf.32.1686966354904;
        Fri, 16 Jun 2023 18:45:54 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ50MwI3FNDPKwGTXj/YlMRyL8oTnJS3xzoNmXMiELgyauRbvF02Xyat5yqO/t8B8e+plGsKlg==
X-Received: by 2002:a17:902:e54b:b0:1b5:368b:36ad with SMTP id n11-20020a170902e54b00b001b5368b36admr3157116plf.32.1686966354569;
        Fri, 16 Jun 2023 18:45:54 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.253])
        by smtp.gmail.com with ESMTPSA id n3-20020a170902968300b001b0266579ebsm16274005plp.194.2023.06.16.18.45.53
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 16 Jun 2023 18:45:54 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
	id 8FE2060451; Fri, 16 Jun 2023 18:45:53 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
	by famine.localdomain (Postfix) with ESMTP id 878A09FB99;
	Fri, 16 Jun 2023 18:45:53 -0700 (PDT)
From: Jay Vosburgh <jay.vosburgh@canonical.com>
To: Hangbin Liu <liuhangbin@gmail.com>
cc: netdev@vger.kernel.org
Subject: Re: [Discuss] IPv4 packets lost with macvlan over bond alb
In-reply-to: <ZIFOY02zi9FZ+aNh@Laptop-X1>
References: <ZHmjlzbRi0nHUuTU@Laptop-X1> <ZIFOY02zi9FZ+aNh@Laptop-X1>
Comments: In-reply-to Hangbin Liu <liuhangbin@gmail.com>
   message dated "Thu, 08 Jun 2023 11:43:31 +0800."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1815.1686966353.1@famine>
Content-Transfer-Encoding: quoted-printable
Date: Fri, 16 Jun 2023 18:45:53 -0700
Message-ID: <1816.1686966353@famine>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hangbin Liu <liuhangbin@gmail.com> wrote:

>Hi Jay, any thoughts?

	Just an update that I've done some poking with your reproducer;
as described, the ARP reply for the IP address associated with the
macvlan interface is coming back with the bond's MAC, not the MAC of the
macvlan.  If I manually create a neighbour entry on the client with the
corrent IP and MAC for the macvlan, then connectivity works as expected.

	I'll have to look a bit further into the ARP MAC selection logic
here (i.e., where does that MAC come from when the ARP reply is
generated).  It also makes me wonder what's special about macvlan, e.g.,
why doesn't regular VLAN (or other stacked devices) fail in the same way
(or maybe it does and nobody has noticed).

	-J

>Thanks
>Hangbin
>On Fri, Jun 02, 2023 at 04:09:00PM +0800, Hangbin Liu wrote:
>> Hi Jay,
>> =

>> It looks there is an regression for commit 14af9963ba1e ("bonding: Supp=
ort
>> macvlans on top of tlb/rlb mode bonds"). The author export modified ARP=
 to
>> remote when there is macvlan over bond, which make remote add neighbor
>> with macvlan's IP and bond's mac. The author expect RLB will replace al=
l
>> inner packets to correct mac address if target is macvlan, but RLB only
>> handle ARP packets. This make all none arp packets macvlan received hav=
e
>> incorrect mac address, and dropped directly.
>> =

>> In short, remote client learned macvlan's ip with bond's mac. So the ma=
cvlan
>> will receive packets with incorrect macs and dropped.
>> =

>> To fix this, one way is to revert the patch and only send learning pack=
ets for
>> both tlb and alb mode for macvlan. This would make all macvlan rx packe=
ts go
>> through bond's active slave.
>> =

>> Another way is to replace the bond's mac address to correct macvlan's a=
ddress
>> based on the rx_hashtbl . But this may has impact to the receive perfor=
mance
>> since we need to check all the upper devices and deal the mac address f=
or
>> each packets in bond_handle_frame().
>> =

>> So which way do you prefer?
>> =

>> Reproducer:
>> ```
>> #!/bin/bash
>> =

>> # Source the topo in bond selftest
>> source bond_topo_3d1c.sh
>> =

>> trap cleanup EXIT
>> =

>> setup_prepare
>> bond_reset "mode balance-alb"
>> ip -n ${s_ns} addr flush dev bond0
>> =

>> ip -n ${s_ns} link add link bond0 name macv0 type macvlan mode bridge
>> ip -n ${s_ns} link set macv0 up
>> =

>> # I just add macvlan on the server netns, you can also move it to anoth=
er netns for testing
>> ip -n ${s_ns} addr add ${s_ip4}/24 dev macv0
>> ip -n ${s_ns} addr add ${s_ip6}/24 dev macv0
>> ip netns exec ${c_ns} ping ${s_ip4} -c 4
>> sleep 5
>> ip netns exec ${c_ns} ping ${s_ip4} -c 4
>> ```
>> =

>> Thanks
>> Hangbin

---
	-Jay Vosburgh, jay.vosburgh@canonical.com

