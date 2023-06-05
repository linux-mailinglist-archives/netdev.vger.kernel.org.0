Return-Path: <netdev+bounces-7872-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A1F7721E7B
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 08:48:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A010D1C20948
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 06:47:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 474E9539D;
	Mon,  5 Jun 2023 06:48:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C09D138C
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 06:48:00 +0000 (UTC)
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 820909F
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 23:47:58 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailout.nyi.internal (Postfix) with ESMTP id 843995C01C8;
	Mon,  5 Jun 2023 02:47:57 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Mon, 05 Jun 2023 02:47:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nikishkin.pw; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:sender
	:subject:subject:to:to; s=fm1; t=1685947677; x=1686034077; bh=ny
	Xefh6YCPEkuradwY2NjKAgOI9fNPFPOY9qhI4tlh0=; b=KMRS0Tl8JhiIk9Zpe7
	+sTuIVb3qN6wxurt6AVdpkUwQ5pLXFeHPMLyNnF36DusRdFy/QeAUdiiUoc5ek+I
	flhe+mmdcMQfVw2OOSj/Ti/zhEwoAtILm4nkPcbcaJo2PUzeUDW8hoRvq29ZYiYC
	zHp3lP+R0XOcrDc/ZIsIwH88DMRKxk+XD5pwBpDX2JRLnHGowy0J+beXXF7DcU4o
	7gNDjccG0obqEs8006VFjCBTKacXlbuKH2AM1hlUVze26x+LfWzDamNcnCPZRNx2
	xvbxAIuvqn2PhdrH8eLW3Ycw56ernNjWty4SYCbVjHZosdI/A5pT6pBF3N7NRaWH
	2zXA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1685947677; x=1686034077; bh=nyXefh6YCPEku
	radwY2NjKAgOI9fNPFPOY9qhI4tlh0=; b=sS4NZ8Ihwne/CTR10+A3+77ew/LYG
	W8I0RPLxXECmxfvzIJgk/E9Mxz6r5VCpseVd4zaxMmXhgv8QqgWajCAxtWcJHHZX
	mmXE+nodQyb0J66oWLj4rahR4WeoFsGZoP4ONw5xqFACO0+YHbif7ZCI8uMwLOXP
	gKTAzfvsgm1B93qKcg9CjKp34Vhfen8LUIJWUWs9UibUi0zjR/+v2X3XKIPhNu+/
	jOThaIPP3a+r/84mUaI72Mgr0alx6IWjnGuFRo1PH6mz7NGxtVxPvROOXNXWiwsm
	WrxSzRz2RR0VMjkO/mKBHP6tNpzhqgt48/mPbQbYN3fzIH6/d0WIvGmVA==
X-ME-Sender: <xms:HYV9ZFq8uJioDqP7sQR4ly0tos82WdVwmqBmZE0DYVHYVese7ePNaA>
    <xme:HYV9ZHoqz_aGickZN4qB5DCzBerYQigAKbL5ALEqYz-A5fCoHcn6wMZsfm666bMlk
    mmcffwZnPvzFVdzXyk>
X-ME-Received: <xmr:HYV9ZCMKNyLGy-0StfgQgqCmAeqRmdpVWda5jpkDYhSASInETDEFYsFQdzC3JmDwKVhwweiuzAo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeelkedgudduudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enfghrlhcuvffnffculddutddmnecujfgurhepfhgfhffvvefuffgjkfggtgesthdtredt
    tdertdenucfhrhhomhepgghlrgguihhmihhrucfpihhkihhshhhkihhnuceovhhlrgguih
    hmihhrsehnihhkihhshhhkihhnrdhpfieqnecuggftrfgrthhtvghrnhepieehheegheet
    udejlefgtdehjefftefhhfffueegueeuveefffeiudekvdehjefhnecuffhomhgrihhnpe
    hkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehvlhgrughimhhirhesnhhikhhishhhkhhinhdrphif
X-ME-Proxy: <xmx:HYV9ZA4vsvtfgls9O_HuspKJHT7OwI0-7JLCSyuUelp1nEkJ3ShmKA>
    <xmx:HYV9ZE5hUAKr0ISTmC7wYRT9gugtkyuR1gno1qq2ILt8MPxcWjJI6Q>
    <xmx:HYV9ZIgedAzPHp_MszgG4taDwOVIcRM5yLP-V4JBWEZ52M-7Kve_Ww>
    <xmx:HYV9ZEjj7iXZ9keymOBExvPRM2xhLZtwOm3BrFEfXrrY_NiIF7O19w>
Feedback-ID: id3b446c5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 5 Jun 2023 02:47:53 -0400 (EDT)
References: <20230604140051.4523-1-vladimir@nikishkin.pw>
 <ZH2CeAWH7uMLkFcj@shredder>
User-agent: mu4e 1.8.14; emacs 30.0.50
From: Vladimir Nikishkin <vladimir@nikishkin.pw>
To: Ido Schimmel <idosch@idosch.org>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, eng.alaamohamedsoliman.am@gmail.com,
 gnault@redhat.com, razor@blackwall.org, idosch@nvidia.com,
 liuhangbin@gmail.com, eyal.birger@gmail.com, jtoppins@redhat.com
Subject: Re: [PATCH iproute2-next v7] ip-link: add support for nolocalbypass
 in vxlan
Date: Mon, 05 Jun 2023 14:47:12 +0800
In-reply-to: <ZH2CeAWH7uMLkFcj@shredder>
Message-ID: <87sfb6pfqh.fsf@laptop.lockywolf.net>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


Ido Schimmel <idosch@idosch.org> writes:

> On Sun, Jun 04, 2023 at 10:00:51PM +0800, Vladimir Nikishkin wrote:
>> Add userspace support for the [no]localbypass vxlan netlink
>> attribute. With localbypass on (default), the vxlan driver processes
>> the packets destined to the local machine by itself, bypassing the
>> userspace nework stack. With nolocalbypass the packets are always
>> forwarded to the userspace network stack, so userspace programs,
>> such as tcpdump have a chance to process them.
>> 
>> Signed-off-by: Vladimir Nikishkin <vladimir@nikishkin.pw>
>> ---
>> v6=>v7:
>> Use the new vxlan_opts data structure. Rely on the printing loop
>> in vxlan_print_opt when printing the value of [no] localbypass.
>
> Stephen's changes are still not present in the next branch so this patch
> does not apply

Sorry for the confusion, I thought that the tree to develop against is
git://git.kernel.org/pub/scm/linux/kernel/git/shemminger/iproute2.git

Apologies.

-- 
Your sincerely,
Vladimir Nikishkin (MiEr, lockywolf)
(Laptop)
--
Fastmail.


