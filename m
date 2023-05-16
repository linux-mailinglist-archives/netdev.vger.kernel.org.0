Return-Path: <netdev+bounces-3072-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C1ECD70554C
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 19:47:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BF3FB1C20DA9
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 17:47:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9FC2156F6;
	Tue, 16 May 2023 17:45:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC46F101D7
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 17:45:41 +0000 (UTC)
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DC307DA9;
	Tue, 16 May 2023 10:45:39 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
	by mailout.nyi.internal (Postfix) with ESMTP id CD2DB5C01A6;
	Tue, 16 May 2023 13:45:36 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Tue, 16 May 2023 13:45:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to; s=fm3; t=
	1684259136; x=1684345536; bh=wBYZT0OYkMw2TLM13VW/L10+YF3tRMc4JyR
	//pK6kKY=; b=tf1fA1FFYUbqAZixRp8n3F6FYjwLml0yhRx02Mc+jQx1fXN3meF
	BOchr8HHmmt8N3tVVX5/REOIq4MqC96in9Gssin1m/pgpMma1vHzyKmNyNd046ud
	/kaCW9N485Z8n2jm4ABp2v64TEyTtgvADgwkzPXss96AcVTE03BU8TD3ViZqsMiZ
	b9n9NeMCzKQPGl/XFG0WkVa3PH8SOa7iM3+0FJUYMMkWBVm6BAKovQdF/STR5ZtM
	viCu6pc+oMJk94JleK6TW54nvY+99ZZu0lJfRBKdvBIVjzd9QWPN2/tYjFMONVbR
	6hZU0k5Q57S5ftGCGR5fDDmPMTMdU9JHttA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to:x-me-proxy
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1684259136; x=1684345536; bh=wBYZT0OYkMw2TLM13VW/L10+YF3tRMc4JyR
	//pK6kKY=; b=HJT5rvzrsM8s9tPzR6nci6ldrk5LDTxA9hdX+pqi9vE41/Fu2AD
	Gx2d0ih/RJPuU4BVqp7Y8z3uLn+yebQ5yujB+lPaZj7S27YX81E7Bshh/mevR0RF
	7CtBx8O2ZT8GKs1Js6s+mBJ5Eqa0SLNYd0WguZJ55efojjjbntGhDfAIH5e8GuE5
	Ss7egnenBo1YK34RNxNUGUPcxBw9zL08P0b6KSbKFBaqGSBEU70vK8qjW6TFiizQ
	dQlmK0DbScTWTQaT9CpZAfJGgshN6KfiR7BeJthEPuRuRTeFdAXaERbAvpi2QVXp
	ektRqGCslWB7Cw72p3wU5O/zLSmd5b3AwMQ==
X-ME-Sender: <xms:QMFjZMoAK2OPNcQm_1u0VC3EvO7oghx7gHlmPm8Cewapqx6EmNMnVw>
    <xme:QMFjZCruMgoq74UzUanNSr42TBdBQkRsqec395hH2h93kSSKHr-Wg2Pqk74VIT3LR
    ujrqb2DiAAmNf9CMCY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeehledgudduhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgfgsehtqhertderreejnecuhfhrohhmpedf
    tehrnhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrf
    grthhtvghrnhepgfekueelgeeigefhudduledtkeefffejueelheelfedutedttdfgveeu
    feefieegnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:QMFjZBN8wQu2db93aF2AsslCg4m3O6XSlktv_KnD_80zcmxh4JNAsA>
    <xmx:QMFjZD5SQvdlsWY4df01KrZ4kUD-ZjCgKnloS6dgqGYXPP0K_KVe3Q>
    <xmx:QMFjZL58jK6CwjPRQ3srZpxvMjPKm9mY98DHfQjssPpD-YYDN5voxQ>
    <xmx:QMFjZDy2N_zTcpTAXLo6ta_tuOQ82FHVnQWlKuMnaHU1boX7gVR-BA>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id 848A2B60089; Tue, 16 May 2023 13:45:36 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-431-g1d6a3ebb56-fm-20230511.001-g1d6a3ebb
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-Id: <b53f3673-f6b1-4071-9bcf-9ae5815593eb@app.fastmail.com>
In-Reply-To: <20230516191245.4149c51a@barney>
References: <20230516074554.1674536-1-arnd@kernel.org>
 <20230516191245.4149c51a@barney>
Date: Tue, 16 May 2023 19:45:16 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>,
 "Arnd Bergmann" <arnd@kernel.org>
Cc: "Kalle Valo" <kvalo@kernel.org>, "David S . Miller" <davem@davemloft.net>,
 "Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>,
 "Paolo Abeni" <pabeni@redhat.com>, "Nathan Chancellor" <nathan@kernel.org>,
 "Nick Desaulniers" <ndesaulniers@google.com>, "Tom Rix" <trix@redhat.com>,
 linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
 Netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
 llvm@lists.linux.dev
Subject: Re: [PATCH] wifi: b43: fix incorrect __packed annotation
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023, at 19:12, Michael B=C3=BCsch wrote:
> On Tue, 16 May 2023 09:45:42 +0200
> Arnd Bergmann <arnd@kernel.org> wrote:
>
>> b43_iv { union {
>>  		__be16 d16;
>>  		__be32 d32;
>> -	} data __packed;
>> +	} __packed data;
>>  } __packed;
>> =20
>> =20
>
> Oh, interesting. This has probably been there forever.
> Did you check if the b43legacy driver has the same issue?

I had not checked, but I see that it does have the same bug.

I only sent this one because the build bot (incorrectly)
blamed one of my recent patches for a regression here.
Which reminds me that I was missing:

Reported-by: kernel test robot <lkp@intel.com>
Link: https://lore.kernel.org/oe-kbuild-all/202305160749.ay1HAoyP-lkp@in=
tel.com/

Should I resend this as a combined patch for both drivers?

   Arnd

