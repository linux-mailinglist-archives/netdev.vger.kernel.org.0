Return-Path: <netdev+bounces-2627-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8289C702C42
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 14:06:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3ED0A281239
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 12:06:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8313AC2FC;
	Mon, 15 May 2023 12:06:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7C8C139
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 12:06:23 +0000 (UTC)
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D97E135
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 05:05:59 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailout.nyi.internal (Postfix) with ESMTP id 5095D5C019F;
	Mon, 15 May 2023 08:05:58 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Mon, 15 May 2023 08:05:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1684152358; x=1684238758; bh=qS9xjjVpj0/Cs
	kPrJYe6vKsaajfRUIDhsESYwCUQWeU=; b=jz944zDE26VfY127PSssmn3Elkhf8
	P/TNI1HQSkXoXN2AA6uf4PKK0K3y8TL8zdJM9Usv1Z16s/wu5aVtaiTskbc715ci
	xaWpNrGndNuVcXrBWrSStoY3l/p1CUkAPmeBXCq7KF9Bw9GLWOLsZ06aUmLux38R
	dvK2ngM1j6o79dAHyjoFr2jhzAduHfFwHtiK1B/um7FnuxmC35F9BxuvxghmKCYm
	RAKxEPTYVEDRryu4sJmVUfvRRXiEJNsy7FDI056nB1zN2vJzA7m/5LrQQw8aK7RW
	ZuSQuC8ewLZiSGRTTqk6aqOO2UteO4IGclNFXKiMqBJlYRKdDYn4+k+qQ==
X-ME-Sender: <xms:JSBiZNdJ5-JfbG2Uo5BZmtXChO3eY0ZULU1Vu43E3NkbtkftFPMbNg>
    <xme:JSBiZLO2-zRjIg0eWOHRDN_nbD7Lyu3hHLqrDHi5UFbQpBYDMRghrU-9g3laGMuVl
    0bRpt_eX1G72zA>
X-ME-Received: <xmr:JSBiZGj0tVOHFrU-aVzZV9hgg1lT71_XRte09Sn0v78ZKxyaic8d5CeLvhtH>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeehjedggeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepgeffteeftdejvdffteekueeivdetkeejteegudeffeeihefhffetgfduffeu
    hfejnecuffhomhgrihhnpehinhhithdrnhgvthenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:JSBiZG_s0eI87OP0u62ysXJOYsgJSEClruh_sp-t6KVs5tDprI-bYA>
    <xmx:JSBiZJspZaIkIzp45S282R3431Kgcq0U0Kdu1PbRJXkAefyi0zvM8A>
    <xmx:JSBiZFGVPk7azS_kb-sHU0wohowCPy6l-LLvt34uoY0UzUDH-NQK8w>
    <xmx:JiBiZK9T3EbAg92HKKA_qXnHaHm4JYc8X10zgfbEpVePFYSjm7ycpw>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 15 May 2023 08:05:56 -0400 (EDT)
Date: Mon, 15 May 2023 15:05:54 +0300
From: Ido Schimmel <idosch@idosch.org>
To: Jiri Pirko <jiri@resnulli.us>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, netdev@vger.kernel.org,
	kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net,
	edumazet@google.com, jacob.e.keller@intel.com, saeedm@nvidia.com,
	moshe@nvidia.com
Subject: Re: [patch net] devlink: change per-devlink netdev notifier to
 static one
Message-ID: <ZGIgIglwmOTX3IbS@shredder>
References: <20230510144621.932017-1-jiri@resnulli.us>
 <CGME20230515090912eucas1p2489efdc97f9cf1fddf2aad0449e8a2c7@eucas1p2.samsung.com>
 <600ddf9e-589a-2aa0-7b69-a438f833ca10@samsung.com>
 <ZGIY9jOHkHxbnTjq@nanopsycho>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZGIY9jOHkHxbnTjq@nanopsycho>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 15, 2023 at 01:35:18PM +0200, Jiri Pirko wrote:
> Thanks for the report. From the first sight, don't have a clue what may
> be wrong. Debugging.

I guess he has CONFIG_NET_NS disabled which turns "__net_initdata" to
"__initdata" and frees the notifier block after init. "__net_initdata"
is a NOP when CONFIG_NET_NS is enabled.

Maybe this will help:

diff --git a/net/devlink/core.c b/net/devlink/core.c
index 0e58eee44bdb..c23ebabadc52 100644
--- a/net/devlink/core.c
+++ b/net/devlink/core.c
@@ -294,7 +294,7 @@ static struct pernet_operations devlink_pernet_ops __net_initdata = {
        .pre_exit = devlink_pernet_pre_exit,
 };
 
-static struct notifier_block devlink_port_netdevice_nb __net_initdata = {
+static struct notifier_block devlink_port_netdevice_nb = {
        .notifier_call = devlink_port_netdevice_event,
 };

