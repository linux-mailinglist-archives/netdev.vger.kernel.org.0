Return-Path: <netdev+bounces-9128-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84C1F727649
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 06:45:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 137F1281651
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 04:45:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55DFA1FDB;
	Thu,  8 Jun 2023 04:45:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457DD111A
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 04:45:11 +0000 (UTC)
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD9A26AC;
	Wed,  7 Jun 2023 21:45:08 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
	by mailout.nyi.internal (Postfix) with ESMTP id C97115C0136;
	Thu,  8 Jun 2023 00:45:05 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 08 Jun 2023 00:45:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=flygoat.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to; s=fm2; t=
	1686199505; x=1686285905; bh=gQIQx8lQOYu3qYgDEC6M5OM36uKEefHh+gb
	jE9FYpZo=; b=iD4thFF/VTRkOoZsW95bVWE1g3Jr5qJcj3/qhUStKeHvibaZ+gW
	bW881L3kc19ErawMIU1L7JI9bnJCT0iL3wrlDlX8cUCCFEjIt2A0KGoioYrEPHtO
	5SGi7n/aI7uTgI7d82aYdZuB86zhSWTNlVhwdpEEoLxpolffbx23LDz3j0UAmcvh
	E0YYmfjKZ1WUSsyQ9SCX/PbZJMZvn4A2Vvnd25KksKsl1j4PJQ+DbK+W7tT2lJWe
	Ot8m2CqlaMag+IviEfFUlVHDpLIblhhDiyCe7JYnsxPwu6fZwJtYSBKEtGP3eot8
	kVJtu+B9ni97vPnvcYgAyAuSpSpvIRbhYig==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to:x-me-proxy
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1686199505; x=1686285905; bh=gQIQx8lQOYu3qYgDEC6M5OM36uKEefHh+gb
	jE9FYpZo=; b=pJnbrRnM69K5tkCjaONBPga3xiwiIb+m3Dw3qbnOPq9jnOC6I0e
	7sqPVuzdNqm/blbWj38TjdDPYPXP6X4tYV+QogiINYVkgBNc7Q1mtfv/Hf0gXMP7
	uEfQNAh0tw5HBfZJTlG6EGogrBWnFK+ybVcdKy1hwgSDip4qHeuADcT9+SPd0l27
	5rnQXO93JyM+15TxFG5/jTc3F1Xf/b2WiO81/rQ8Y+sA0Z8zZMFHYNzR9BqUOSNu
	7Xnqq5gwMU+M5b9xsGhZa0kuSdZ+FCdYoBianG/oYkE1ert9m+D/gz4ckyYA3J+2
	plKLrSbEGMC+4/f+a9zVoaJBohzzGeXYjDg==
X-ME-Sender: <xms:0VyBZDVV1lMCVz7hXbSr_H2dTJ5jZDwjMoXF1U5Tnid-ZjUbk0e3bw>
    <xme:0VyBZLkBog3GNeUd7nixTFwNJjcP6rxQVj9bz49OBADGCsJA4Uej6us6x5b3cqHYU
    8Vs_gnMufp0baogtEE>
X-ME-Received: <xmr:0VyBZPZJc1f39JINI1fGH59aV_qyGnJPWb2TnrwfBlNRNqepGhiZEgkxUxN6q_MykFGT>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgedthedgkeehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurheptggguffhjgffvefgkfhfvffosehtqhhmtdhhtdejnecuhfhrohhmpeflihgr
    gihunhcujggrnhhguceojhhirgiguhhnrdihrghnghesfhhlhihgohgrthdrtghomheqne
    cuggftrfgrthhtvghrnhepuddtjeffteetfeekjeeiheefueeigeeutdevieejveeihfff
    ledvgfduiefhvddtnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepjhhirgiguhhnrdihrghnghesfhhlhihgohgrthdrtghomh
X-ME-Proxy: <xmx:0VyBZOXtNJgCupGGmIbwZo4H1Wsebf-_tbT9uRF4FW9_drL2SM9l3Q>
    <xmx:0VyBZNnMpH1dmiBW3-7dK9BUNx-a4KWb9BgB2L3XKRamNr3eIcggJw>
    <xmx:0VyBZLfKKBbCJP7XFhPd5KFaeB0QvRud0eJ-SFeem7HCPCcATQldZA>
    <xmx:0VyBZGB3-z6kSZ7HJh8BWIsYWPDuxCzWuRB9bOSVgXRXazSKJgpGtA>
Feedback-ID: ifd894703:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 8 Jun 2023 00:45:01 -0400 (EDT)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.600.7\))
Subject: Re: [PATCH net v2] net: pch_gbe: Allow build on MIPS_GENERIC kernel
From: Jiaxun Yang <jiaxun.yang@flygoat.com>
In-Reply-To: <20230607134158.5438d28c@kernel.org>
Date: Thu, 8 Jun 2023 12:44:47 +0800
Cc: netdev@vger.kernel.org,
 "David S . Miller" <davem@davemloft.net>,
 edumazet@google.com,
 pabeni@redhat.com,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <47F7B312-5143-4BA1-96A4-917C88AF5914@flygoat.com>
References: <20230607055953.34110-1-jiaxun.yang@flygoat.com>
 <20230607134158.5438d28c@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
X-Mailer: Apple Mail (2.3731.600.7)
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



> 2023=E5=B9=B46=E6=9C=888=E6=97=A5 04:41=EF=BC=8CJakub Kicinski =
<kuba@kernel.org> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Wed,  7 Jun 2023 13:59:53 +0800 Jiaxun Yang wrote:
>> v2: Add PTP_1588_CLOCK_PCH dependency.
>>=20
>> Netdev maintainers, is it possible to squeeze this tiny patch into
>> fixes tree?
>=20
> Hm.. probably a little late for that. The first version didn't build,
> feels too risky. We don't want to break the build of Linus's tree at
> rc6/rc7. The merge window is two weeks out, is that really too long
> of a wait?

Ah if that=E2=80=99s the case waiting until next merge window is fine =
for me.

Thanks
Jiaxun


