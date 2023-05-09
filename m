Return-Path: <netdev+bounces-1112-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C94426FC3BD
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 12:20:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 029E51C20B28
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 10:20:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22A9BDDD1;
	Tue,  9 May 2023 10:20:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15647DDC0
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 10:20:28 +0000 (UTC)
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D219D07E
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 03:20:28 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
	by mailout.nyi.internal (Postfix) with ESMTP id E1FC45C0184;
	Tue,  9 May 2023 06:20:24 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 09 May 2023 06:20:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm3; t=1683627624; x=1683714024; bh=aYe0YMTzKqtEg
	OF3hi5Y3tgk5Vm06mMgTpHg2h2Ryx0=; b=febVnkkSWi097gZQz9nNAxSD8ZsfK
	UqPnxt5KBMpuM4C70rOH/kxjHMuKdJXlqfCy9zrgXW+/5kUl1CDUpN+sIf4Qqby0
	aYPYyiYE9qayxLMgLABgnQs95WKzlgiZURZDqL+X6BZmaBZu+logIdluXuGMLjNg
	HBwYWdPoBVNclOiCPztEydkW819/PdWd78u62Uy2Mmc+/Kig7f/l+gw5Bj2GKFqI
	1ewyzIHeUfFPDBcErQT2p8JyHHJ7hh1dupXeEC44q3AkaBBQ54sbi10tft5cUiPP
	ATnNa+W7N1ljRr0FAxIW/N4/fVxBJ5hSuZAWcUkVkdGRQiCtbQHeMtTFA==
X-ME-Sender: <xms:aB5aZDvP8rzc5xYgT2vW0ttbGJY7mFFlpQLHem2dNK6oWq1C0TQ1qQ>
    <xme:aB5aZEda6xVDQt70Ri9O2fE2UAcNC_jB8vDOyaRo3kH6x2R_0uPK9wk2HxVXGGJ3V
    uIXYnxBzrPo-Jk>
X-ME-Received: <xmr:aB5aZGySJYsv-yC_0O07Cn8J0-jDdmQu_CmlIKZ4aHGKlICgv9Suswir2VnDKmgd7MoqxZ-MQpjKKlsDIdd1iH1ExOo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeegtddgvdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtrodttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepfeefueegheehleelgeehjefgieeltdeuteekkeefheejudffleefgfeludeh
    hfejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:aB5aZCPM_-hQuI8CKwycgkw9VZrICjnSiWPDE8o2vyHTVVWz6X13nA>
    <xmx:aB5aZD8h2cyma6jUzYHfRmxjmgBoUbvbxUWFt6rReVhjVnwWlVDvpg>
    <xmx:aB5aZCVeTBULBj2vcfzzrdTEUrgjF2QdeLiky1G-WkZe1KOhZqi-HA>
    <xmx:aB5aZAERsqt79r0xjJzOfg7cvRSzJk3F5eGbsqw4kFuk-W6vJgeOyQ>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 9 May 2023 06:20:24 -0400 (EDT)
Date: Tue, 9 May 2023 13:20:20 +0300
From: Ido Schimmel <idosch@idosch.org>
To: Martin Zaharinov <micron10@gmail.com>
Cc: Eric Dumazet <edumazet@google.com>, netdev <netdev@vger.kernel.org>
Subject: Re: Very slow remove interface from kernel
Message-ID: <ZFoeZLOZbNZPUfcg@shredder>
References: <371A6638-8D92-4891-8DF5-C0EA4FBC1977@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <371A6638-8D92-4891-8DF5-C0EA4FBC1977@gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 09, 2023 at 11:22:13AM +0300, Martin Zaharinov wrote:
> add vlans : 
> for i in $(seq 2 4094); do ip link add link eth1 name vlan$i type vlan id $i; done
> for i in $(seq 2 4094); do ip link set dev vlan$i up; done
> 
> 
> and after that run : 
> 
> for i in $(seq 2 4094); do ip link del link eth1 name vlan$i type vlan id $i; done
> 
> 
> time for remove for this 4093 vlans is 5-10 min .
> 
> Is there options to make fast this ?

If you know you are going to delete all of them together, then you can
add them to the same group during creation:

for i in $(seq 2 4094); do ip link add link eth1 name vlan$i up group 10 type vlan id $i; done

Then delete the group:

ip link del group 10

IIRC, in the past there was a patchset to allow passing a list of
ifindexes instead of a group number, but it never made its way upstream.

