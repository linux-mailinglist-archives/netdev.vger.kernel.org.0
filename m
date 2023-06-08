Return-Path: <netdev+bounces-9127-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6D76727647
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 06:44:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 488591C20F8B
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 04:44:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 231331C38;
	Thu,  8 Jun 2023 04:44:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B631C35
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 04:44:23 +0000 (UTC)
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D682A26AC
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 21:44:21 -0700 (PDT)
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 364123F15D
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 04:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1686199459;
	bh=wYrNbzP3u0/ddCTZC/LgLn3cT6YuB3YaOJsBasQtr90=;
	h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
	 Content-Type:Date:Message-ID;
	b=CVAsvgGrmg95a4MOXd/OyS1JF4SpsAul9jswF5n2TpkLohRHF5v3rm9ANi5imU9Aq
	 R+RgCREJZuKekxs0z8CII+DwA9UfRr/Nr9cEE7M2+KGPX8k4fAca3ATbwCHEH36ghl
	 CH1xEi2Temt5+9cn/TqlE9/OVKeqAsBGMlazxmILDVK0OkmQU9AKSEHjmO1pBawRP+
	 uXIHB9pQh/9dbgH+uIMib/JpKsmTrmwEw0DwVeIEt80BIOqgi6GBCU5cFYm/JGu2nB
	 mq/fXM9laW7DuAtA9pXdJ7tu5T2/hS9sA20YCBgHHDcjXo3dslz/sczYFJgUTSUqu8
	 jWQvyRsrd7apw==
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-3922d2460afso267848b6e.3
        for <netdev@vger.kernel.org>; Wed, 07 Jun 2023 21:44:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686199457; x=1688791457;
        h=message-id:date:content-transfer-encoding:content-id:mime-version
         :comments:references:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wYrNbzP3u0/ddCTZC/LgLn3cT6YuB3YaOJsBasQtr90=;
        b=RBaI9YuOmRAiKjatAqQYIBt7CIVXfQ3oE5PY0q8hQjeXQtOM6e8mUXhQrYnwDehifA
         YDylnh5gdz5CDewBeiV4h78TblqL2hMbMuJtPuoFUcVuDdoBHuGa+a9U0XYGKR00za5M
         CtPFXc1pW+YQ30UcxABB7gvh9NeGFvMOw8/7MCb/GpR/Lmf9Zn328RHCYggv6B01OJeM
         7J6EiE5lKks/e9kthAouJyzBFn2X+98TOkkafVJbnZ9jJe67QZDp22gW61yYQgaA20AQ
         ubr0QTnp3nq6Vd7LHW8oa14BCBC7tkalyz96mPsF631k5LntN7LyVva2h9i2NR1/O18S
         eehw==
X-Gm-Message-State: AC+VfDzt34pC56TeGU1IrFjZ1z45MZxNVvp+MEVo1dlxZSPNwq0Gr9Eq
	D983WZ7+EFJzr+O/krkh+FV1VZ2p0rauRMf7fA3Wi3hktz5APSIhCOz25DIilJwe4LRCTbzxVkX
	lhWqTWFqBeH6fqCE+CwpU/ntyudKjPCia6ytDyFtCfA==
X-Received: by 2002:a05:6808:10:b0:398:2345:1242 with SMTP id u16-20020a056808001000b0039823451242mr6806957oic.29.1686199457066;
        Wed, 07 Jun 2023 21:44:17 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5rZMsVwHo/hD+8hv7blK4GgoknnOXkwl5G8MTRWMKcXWQCd87EdEvm7u+UyPx+C/xjQcZCLw==
X-Received: by 2002:a05:6808:10:b0:398:2345:1242 with SMTP id u16-20020a056808001000b0039823451242mr6806950oic.29.1686199456710;
        Wed, 07 Jun 2023 21:44:16 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.253])
        by smtp.gmail.com with ESMTPSA id g11-20020a17090a128b00b00250334d97dasm2109504pja.31.2023.06.07.21.44.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Jun 2023 21:44:16 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
	id 9F21161C84; Wed,  7 Jun 2023 21:44:15 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
	by famine.localdomain (Postfix) with ESMTP id 99E90A02D2;
	Wed,  7 Jun 2023 21:44:15 -0700 (PDT)
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
Content-ID: <25354.1686199455.1@famine>
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Jun 2023 21:44:15 -0700
Message-ID: <25355.1686199455@famine>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hangbin Liu <liuhangbin@gmail.com> wrote:

>Hi Jay, any thoughts?

	Only that the more I look into this the more confused I get.  I
haven't had a chance to set it up to test and poke at it, but did look
through the code and some of the history.

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
>> with macvlan's IP and bond's mac.

	There was a report similar to yours in 2017,

https://lore.kernel.org/netdev/CAJN_NGada81u96VSRz=3Dpuy3DOXjqJ6H9vNkMjgGF=
Bea3vgrPPQ@mail.gmail.com/

	with no responses, so I presume this hasn't worked for at least
that long (suggesting that macvlan over balance-alb is not a popular
deployment choice).  That leads me to wonder if the 14af9963ba1e patch
ever worked entirely correctly.  Perhaps whatever Vlad did to test it
missed the condition that you and the above reporter are seeing, or it
works in only a subset of macvlan modes, or maybe it did work correctly
when 14af9963ba1e was applied.

>> [...] The author expect RLB will replace all
>> inner packets to correct mac address if target is macvlan, but RLB only
>> handle ARP packets. This make all none arp packets macvlan received hav=
e
>> incorrect mac address, and dropped directly.

	Reading the 14af9963ba1e commit message, I think you're
referring to:

    To make RLB work, all we have to do is accept ARP packets
    for addresses added to the bond dev->uc list.  Since RLB
    mode will take care to update the peers directly with
    correct mac addresses, learning packets for these addresses
    do not have be send to switch.

	I don't think that means he expects RLB to fix up the MACs in
every incoming packet.  I'm reading this as that the macvlan peers will
be issued ARPs that match the IP address to the macvlan MAC address, and
that those packets should be accepted because the macvlan MAC address is
in the bond interface's unicast MAC address list (dev->uc).

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

	I don't yet understand what's going on well enough have an
informed opinion; in particular, if this did work correctly when
14af9963ba1e was originally applied, then it's not clear what broke it.
I should have some time to test this in the next day or two.

	-J


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

