Return-Path: <netdev+bounces-1250-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 145016FCF12
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 22:08:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 49ED3280D0E
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 20:08:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4148118C0C;
	Tue,  9 May 2023 20:08:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36D8D18C01
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 20:08:26 +0000 (UTC)
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C177CF
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 13:08:25 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
	by mailout.west.internal (Postfix) with ESMTP id 930EC32009AD;
	Tue,  9 May 2023 16:08:24 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Tue, 09 May 2023 16:08:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to:x-me-proxy
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1683662904; x=1683749304; bh=qP39Bxm2l4EJNUV4Xrovj8has81SewzqVD7
	gvPpJmRg=; b=aY/7Smmys0GfkQEGJAXv4Ur75VoTqX29PZ4QZvLWHAgo4keTTc2
	vojHJ0Mpf44NSsVc5Go9d2uYZIpibTrR3mTSF9qmhpbY42lwh3JOhZdDYru681bN
	8lxz40amshLl2A6z763ri38JHdCfpzbVy89ZyUoYoH40tYFahgJFoEQ5YJOF06fa
	W3hB3U3+QTxEJ9kvkkp/vvOVH6AcX8HiGFJirp6MdhzaMH/uVfdUzqrxJ/Enc0lM
	Ef3USD/f7L690S1oOjmSctJiDM0xJ0skhOqPVFpea7Ls2bArvQpdRmA8ODojOn0h
	iNQr0Ko8x7oQPdotszOTBPr5ZtcUGwHdeqw==
X-ME-Sender: <xms:OKhaZP9l6SnOLzp_q8xvzPy15XTIR574zHzskDuCf8LdhXaBJb1GLg>
    <xme:OKhaZLujDftqMFkpDVLBsSB2d0s3vxTN4vAzoEhs8AarclS0NNC-KrVdUKEh14IrJ
    Pn4Ntfr4HLHy70>
X-ME-Received: <xmr:OKhaZNAQrTcv1cWZPjkl8x5P8nXby4dr4KIet-oB5mkpA6mkzbD6YFA06dMiH7aWop3EX3e3jYivl4E1LRtjoY4ljJA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeeguddgjeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggugfgjsehtkeortddttdejnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrg
    htthgvrhhnpeelleeiieejgeehtdejleffveevveekleeffedtkeeluefggeetfeevfeeu
    udekveenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:OKhaZLd0blb_8MFWkSE3p1HGSTn5xQXRiXAoAY4btOAnIyvHS8jOAg>
    <xmx:OKhaZEPg25Bn9Gc4U-PDYPM4-0uNOx5hEIIGdMWpHfU_SfZWp3wiNA>
    <xmx:OKhaZNlKxZH0dK_t_ogrTgauYvFBGJ-2hc0DLpO0eDbPY3lEnTe1DA>
    <xmx:OKhaZOV3HXE2dDSzzD0rqFKLZ5InIlGR_5_iWwZMgLLcU5uD2FwsmA>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 9 May 2023 16:08:23 -0400 (EDT)
Date: Tue, 9 May 2023 23:08:20 +0300
From: Ido Schimmel <idosch@idosch.org>
To: Martin Zaharinov <micron10@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>, netdev <netdev@vger.kernel.org>
Subject: Re: Very slow remove interface from kernel
Message-ID: <ZFqoNJqwLjaVFGaa@shredder>
References: <371A6638-8D92-4891-8DF5-C0EA4FBC1977@gmail.com>
 <ZFoeZLOZbNZPUfcg@shredder>
 <CANn89i+=gWwebCHk2qwu12qC+yXTFUqOxWTfnqbJOAFjidcYeg@mail.gmail.com>
 <A4F00E57-AB0E-4211-B9E4-225093EB101F@gmail.com>
 <CANn89iKOm2WPoemiqCsWaMXMyGf9C5xXH=NaSidPSNCpKxf_jQ@mail.gmail.com>
 <FE7CE62C-DBEB-4FE1-8ACB-C8B7DAF15710@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <FE7CE62C-DBEB-4FE1-8ACB-C8B7DAF15710@gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 09, 2023 at 09:50:18PM +0300, Martin Zaharinov wrote:
> i try on kernel 6.3.1 
> 
> 
> time for i in $(seq 2 4094); do ip link del link eth1 name vlan$i type vlan id $i; done
> 
> real	4m51.633s  —— here i stop with Ctrl + C  -  and rerun  and second part finish after 3 min
> user	0m7.479s
> sys	0m0.367s

You are off-CPU most of the time, the question is what is blocking. I'm
getting the following results with net-next:

# time -p for i in $(seq 2 4094); do ip link del dev eth0.$i; done
real 177.09
user 3.85
sys 31.26

When using a batch file to perform the deletion:

# time -p ip -b vlan_del.batch 
real 35.25
user 0.02
sys 3.61

And to check where we are blocked most of the time while using the batch
file:

# ../bcc/libbpf-tools/offcputime -p `pgrep -nx ip`
[...]
    __schedule
    schedule
    schedule_timeout
    wait_for_completion
    rcu_barrier
    netdev_run_todo
    rtnetlink_rcv_msg
    netlink_rcv_skb
    netlink_unicast
    netlink_sendmsg
    ____sys_sendmsg
    ___sys_sendmsg
    __sys_sendmsg
    do_syscall_64
    entry_SYSCALL_64_after_hwframe
    -                ip (3660)
        25089479
[...]

We are blocked for around 70% of the time on the rcu_barrier() in
netdev_run_todo().

Note that one big difference between my setup and yours is that in my
case eth0 is a dummy device and in your case it's probably a physical
device that actually implements netdev_ops::ndo_vlan_rx_kill_vid(). If
so, it's possible that a non-negligible amount of time is spent talking
to hardware/firmware to delete the 4K VIDs from the device's VLAN
filter.

> 
> 
> Config is very clean i remove big part of CONFIG options .
> 
> is there options to debug what is happen.
> 
> m

