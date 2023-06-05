Return-Path: <netdev+bounces-8091-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AD2F2722AA8
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 17:15:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 24E671C2090D
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 15:15:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2107A1F948;
	Mon,  5 Jun 2023 15:15:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1629D1F19C
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 15:15:35 +0000 (UTC)
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E00B1986
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 08:15:10 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
	by mailout.nyi.internal (Postfix) with ESMTP id 80E925C02AC;
	Mon,  5 Jun 2023 11:14:51 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 05 Jun 2023 11:14:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1685978091; x=1686064491; bh=G5oi8RnRRZuA7
	sPiLg+PojULxzvCbW1KpWAgTGDjjU4=; b=w53fczJSkcIKwffQ03DRhkk0J8KrO
	ACEvEA7t2i569qmRKJazbcPakTsjfR/1Zt73jms/BUEzGogkzN8nkdvtnzkKWiEA
	uxth+p6ALy/M+E/fSjm1KvjbYkz+kwLOnPCvRmdR5JJxJy4DfH1bdDX0FAHsORAa
	mzGW9DO6HwvAhVY2sjFj8BsF1EahKtXzL4eV+T5aBdmD3e3qbBlBLaJBGaPOVGoP
	AXhOwqS60gt/4Z/gfKgFP9g47JYGawSCShPrt+4L5GkmVh+KpAXb6Eo5KbdfopIA
	Pkd5AbuSmrVxNLCOLjKAnfhL6Iq2DlrQ9cAeMVogYWN9j8cQef0ERCN7w==
X-ME-Sender: <xms:6vt9ZOsV7EJn6soN9NjrHO3W7t5eBfhUycDPJqBwCp_jHidMk9y2JQ>
    <xme:6vt9ZDeT0OBnPzCjAMUlKhdTMHM9eo--Z3Gd0NduTfwxNchLVtvdFlkTQYZf4MO6K
    soh4LR3OLJhwV4>
X-ME-Received: <xmr:6vt9ZJxwJn15LOsbjvrcrZVI-uiE-NXnCnEUO8e1UvQ2jN31dX3etXqYnklr>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeelledgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepvddufeevkeehueegfedtvdevfefgudeifeduieefgfelkeehgeelgeejjeeg
    gefhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:6vt9ZJOGPS9UldKCZdye6CDBar3r-1aedDirhDK2h7I-DPYAvV1B8A>
    <xmx:6vt9ZO8i4iku5egYvmgA6aQLPSSbWJbVsp52H5mbqAuQXfttkMAFHA>
    <xmx:6vt9ZBU25vfuihIleFE96K2b0Eyi-cKLHQZTOkaCnrcH_jsBOGI1Ig>
    <xmx:6_t9ZJUCeGrR9cvdyOL_370Po6g4eVECZugHnVPwafk_XpNBnYKrWg>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 5 Jun 2023 11:14:50 -0400 (EDT)
Date: Mon, 5 Jun 2023 18:14:48 +0300
From: Ido Schimmel <idosch@idosch.org>
To: Stephen Hemminger <stephen@networkplumber.org>, dsahern@gmail.com
Cc: Vladimir Nikishkin <vladimir@nikishkin.pw>, netdev@vger.kernel.org,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, eng.alaamohamedsoliman.am@gmail.com,
	gnault@redhat.com, razor@blackwall.org, idosch@nvidia.com,
	liuhangbin@gmail.com, eyal.birger@gmail.com, jtoppins@redhat.com
Subject: Re: [PATCH iproute2-next v7] ip-link: add support for nolocalbypass
 in vxlan
Message-ID: <ZH376DK12JtBxlig@shredder>
References: <20230604140051.4523-1-vladimir@nikishkin.pw>
 <ZH2CeAWH7uMLkFcj@shredder>
 <87sfb6pfqh.fsf@laptop.lockywolf.net>
 <ZH2cUO7pFnU/tcXL@shredder>
 <20230605080217.441e1973@hermes.local>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230605080217.441e1973@hermes.local>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 08:02:17AM -0700, Stephen Hemminger wrote:
> David will to a merge from main to next if asked.

I see he is not even copied. Let me add him.

David, can you please merge main into next? We need commit 1215e9d38623
("vxlan: make option printing more consistent") to make progress with
the "localbypass" patch.

Thanks

