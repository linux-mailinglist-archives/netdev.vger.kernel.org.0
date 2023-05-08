Return-Path: <netdev+bounces-824-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id E69CD6FA29A
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 10:52:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DFB69280EBB
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 08:52:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5B1413AD4;
	Mon,  8 May 2023 08:52:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D41AA210C
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 08:52:38 +0000 (UTC)
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C4D4234;
	Mon,  8 May 2023 01:52:37 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
	by mailout.west.internal (Postfix) with ESMTP id D7A3D32002E2;
	Mon,  8 May 2023 04:52:32 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Mon, 08 May 2023 04:52:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:sender
	:subject:subject:to:to; s=fm3; t=1683535952; x=1683622352; bh=iJ
	dvc4SRQrLz+3W/Ez8+i72AurjuOlLDf24cELwYcVE=; b=pnJ0mn5Pa/QzV8ZIaM
	SRbHsFrI9iqt/gq2ptRf7jKyTxVwaTK69qoRXP1rgps2xX3U0RXmYPC1IZ2LHTgW
	pu9bi28FR+JI3j/Urvw75XRPf8JXoeXE44CVskN1L8laOSSJRefqZdEC522Irwc9
	W/plnnBQKyozVG/bMVRIPbkkziSP56XzjGwiXkSWge++GOrHcNxjUm2nf6J4Dg01
	Hsuh4pXa66FhryZxOycnQJ5OrMm119+yiCe4hpaF1Bnhm1cZGMPspXxofSxdX5Si
	/29C8NsP9yQrn+mXinIr0qLXuQlcXzJrx5jqO7k9EZzc1cLhGSWxYPi6rlz2aizS
	fNvg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm3; t=1683535952; x=1683622352; bh=iJdvc4SRQrLz+
	3W/Ez8+i72AurjuOlLDf24cELwYcVE=; b=SgDJPcdzZzknasipJlIz/AHKCTPE+
	4PdbFI+yda23wf8OKl5GJPIwLycT6p1dYp0C/zcOky7Hxim6GZEcgdeciW/YLBHf
	slHORB546oVXtKGUXQQ8sLiFec1eBfkr466qoagbjPxHAfJbU+2LQxeRYMLn4jbr
	9pxlabN50OOq/PoGByfDegIKI9mlrTbHQ+IrjMISALEOz07BQIXMJ4SPiZ5ayJlL
	93dw8oZyw3R0lkOISE64Gr4iZgaCrPbGlcSUha8JYvRgKFdsilDGs6/aHikT32P4
	8kJ8Mik45kP4NhbRzGl4tf0mxvmHHnYYdJixq6xLlKpwMTYP04ku6FqgQ==
X-ME-Sender: <xms:ULhYZPJFmqn4J9UETLTJLNH8DtkPV_V_YoCQTCfBFDaim3kOcrqt6w>
    <xme:ULhYZDJQlXAdYjy9W4se8h-D_UIVvF4Efk3Ps0o5qq8PuViTDzrZM0INfUATDH5go
    ANZh3tGcIdn95uScFw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeefkedgtdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepffehueegteeihfegtefhjefgtdeugfegjeelheejueethfefgeeghfektdek
    teffnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomheprg
    hrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:ULhYZHtpGFdF_240rDsYEjyS1GGrw_MlViAB2BwQtKnuI3-0hEfnHA>
    <xmx:ULhYZIbXcDDXy_Eu-P90z1fN-2OlNNPPK57dR2UdEC8iamrVqmUbhw>
    <xmx:ULhYZGbseSHMBtETCdUBuKStSE6RJtB3OwcjRYDVkZcuIH-RQMaNgg>
    <xmx:ULhYZOqO-DWRySw_E1PrXJiso16T58m0yr7AqYfJxU784pQZkXD33A>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id 0DCB5B60086; Mon,  8 May 2023 04:52:31 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-386-g2404815117-fm-20230425.001-g24048151
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-Id: <504c5a7d-0bfd-4b1e-a7f0-65d072657e0a@app.fastmail.com>
In-Reply-To: <87ttwnnrer.fsf@kernel.org>
References: <20230417205447.1800912-1-arnd@kernel.org>
 <87ttwnnrer.fsf@kernel.org>
Date: Mon, 08 May 2023 10:52:11 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Kalle Valo" <kvalo@kernel.org>, "Arnd Bergmann" <arnd@kernel.org>
Cc: "David S . Miller" <davem@davemloft.net>,
 "Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>,
 "Paolo Abeni" <pabeni@redhat.com>, "Johannes Berg" <johannes.berg@intel.com>,
 "Manikanta Pubbisetty" <quic_mpubbise@quicinc.com>,
 "Wen Gong" <quic_wgong@quicinc.com>,
 "Baochen Qiang" <quic_bqiang@quicinc.com>,
 "Sowmiya Sree Elavalagan" <quic_ssreeela@quicinc.com>,
 ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
 Netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
 ath12k@lists.infradead.org
Subject: Re: [PATCH] wireless: ath: work around false-positive stringop-overread
 warning
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 8, 2023, at 10:44, Kalle Valo wrote:
> Arnd Bergmann <arnd@kernel.org> writes:
>
>> From: Arnd Bergmann <arnd@arndb.de>
>>
>> In a rare arm64 randconfig build, I got multiple warnings for ath11k
>> and ath12k:
>>
>> In function 'ath11k_peer_assoc_h_ht',
>>     inlined from 'ath11k_peer_assoc_prepare' at drivers/net/wireless/ath/ath11k/mac.c:2665:2:
>> drivers/net/wireless/ath/ath11k/mac.c:1709:13: error: 'ath11k_peer_assoc_h_ht_masked' reading 10 bytes from a region of size 0 [-Werror=stringop-overread]
>>  1709 |         if (ath11k_peer_assoc_h_ht_masked(ht_mcs_mask))
>>       |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>
>> This happens whenever gcc-13 fails to inline one of the functions
>> that take a fixed-length array argument but gets passed a pointer.
>>
>> Change these functions to all take a regular pointer argument
>> instead.
>>
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> s/wireless:/wifi:/ but I can fix that.

Ok, thanks!

> In a awat it's a shame to lose the explicit length but I guess there's
> no other way to fix this?

There might be, but I couldn't figure out a way that works.

> Also I hope you find the time to add GCC 13 to crosstool :) Related to
> this

I uploaded gcc-13.1.0 binaries last week, but still need to
update the html page, so it's not yet linked. You can navigate
the directories from the gcc-12 builds.

     Arnd

