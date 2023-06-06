Return-Path: <netdev+bounces-8359-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EBEE723CC9
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:16:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6FDA31C20E0F
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:16:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 775DE290FE;
	Tue,  6 Jun 2023 09:16:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CBD7290EA
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:16:09 +0000 (UTC)
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1383BE55;
	Tue,  6 Jun 2023 02:16:03 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
	by mailout.nyi.internal (Postfix) with ESMTP id 2EA875C00D6;
	Tue,  6 Jun 2023 05:16:03 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Tue, 06 Jun 2023 05:16:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to; s=fm1; t=
	1686042963; x=1686129363; bh=jUtfdkZ/azepFvSYCIZ/2GxgimiuSucyPTh
	w7nBP7F4=; b=LCmLbZWfkuLfRl1mPHTB2HMg4Zk5tS4Hc2oGueG6TXIuQaYzuxj
	zBDWqMRe8e7wXjjyatIF/7u6NioHOS24/EACjLdE6VMGYmybgAlz8rKql6ZF+AL4
	9oLlKIi/fsMWbTqduw0CXeXAapOEguGzt5Ac4eczmiGbBsXkkuJYmIS+bqfeUU5g
	A9qWh5kapCDkvRa+hVn4hVnif676moVzUT2DJTw1qhLNeT5qxzLcriqX9jIzS5Ja
	ZMEEmwZEM9hKXuVGduS9L7BlTQVKgnh7ZPhu5bdRuCSb0TJokWG1+bLwkPGg+aiz
	i+ND/ce1G/GHiUh0XPqIZXucI6wdPwjqRZw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to:x-me-proxy
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1686042963; x=1686129363; bh=jUtfdkZ/azepFvSYCIZ/2GxgimiuSucyPTh
	w7nBP7F4=; b=OVvU1rB/IUV1V+Tir3aGFvlYRfACHozlpZBVLOvWe+gwqDjzcLF
	VG3tFZ3Fu9+yjP2GsLZotGkDzeUy4VkD5plA4HjFECn3HuLP9yY7rB2kvtEOP0YP
	jzrghR32c00umejZjSHcLbrIAHlLKtH0lKewuVG7MJjCZ3ASAeCJyfCzksbaRU6J
	/xhwzSr3UlPMiRbiRZgtoPu1jqFLqn9JWyFAKUIQLVdVifHn+h0ajt3WCQFxEaf1
	pDE0Gw/eUKDhJP8oGWCUUP1S/xEsrZVQ6qGbQPtwWCQIL1GfsVDYSf2tC2Ncka/8
	orubpGGHHVF2kPusJpJgXzO0XbZjeh9deng==
X-ME-Sender: <xms:Uvl-ZAoExjB4Tw5ycehQJoFfp5DYQ0suSSA434qzcD6j8J5M0BiYVw>
    <xme:Uvl-ZGrQHlmQFaa7PjhvB4jBdLATrgN31FX8PaVAiyBMHgQrprmOs81VQnGB46WqM
    P5AXRfdqCYhCDr6nNM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgedtuddgudegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtgfesthhqredtreerjeenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrg
    htthgvrhhnpefgkeeuleegieeghfduudeltdekfeffjeeuleehleefudettddtgfevueef
    feeigeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:Uvl-ZFNRdqYjvHzma7kszNb8noYVzTvB6WsvhG9Se2ZmV5PZLQ6SAw>
    <xmx:Uvl-ZH6e2GQwKUg-3XFd7uF48imD6xAt4HVJKXyhGPfYClTXvYf8Ow>
    <xmx:Uvl-ZP5zDCsoBN3_bkFjtIoDKGugKaMWKlQj-Znm6gkqQPR_DgjgsQ>
    <xmx:U_l-ZIPtCu9ftgUOo6o8pir-Uft3tWJcQSibYy1Gci7O3ra0Q5OBag>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id B690AB60086; Tue,  6 Jun 2023 05:16:02 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-447-ge2460e13b3-fm-20230525.001-ge2460e13
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-Id: <11bd37e9-c62e-46ba-9456-8e3b353df28f@app.fastmail.com>
In-Reply-To: 
 <CAMuHMdX7hqipiMCF9uxpU+_RbLmzyHeo-D0tCE_Hx8eTqQ7Pig@mail.gmail.com>
References: 
 <CA+G9fYv0a-XxXfG6bNuPZGT=fzjtEfRGEYwk3n6M1WhEHUPo9g@mail.gmail.com>
 <CA+G9fYueN0xti1SDtYVZstPt104sUj06GfOzyqDNrd3s3xXBkA@mail.gmail.com>
 <CAMuHMdX7hqipiMCF9uxpU+_RbLmzyHeo-D0tCE_Hx8eTqQ7Pig@mail.gmail.com>
Date: Tue, 06 Jun 2023 11:15:42 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Geert Uytterhoeven" <geert@linux-m68k.org>,
 "Naresh Kamboju" <naresh.kamboju@linaro.org>
Cc: "open list" <linux-kernel@vger.kernel.org>,
 linux-next <linux-next@vger.kernel.org>, lkft-triage@lists.linaro.org,
 clang-built-linux <llvm@lists.linux.dev>,
 Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
 "Linux ARM" <linux-arm-kernel@lists.infradead.org>,
 Netdev <netdev@vger.kernel.org>, "Nathan Chancellor" <nathan@kernel.org>,
 "Nick Desaulniers" <ndesaulniers@google.com>,
 "Anders Roxell" <anders.roxell@linaro.org>,
 "Geert Uytterhoeven" <geert+renesas@glider.be>,
 "David S . Miller" <davem@davemloft.net>,
 "Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>,
 "Paolo Abeni" <pabeni@redhat.com>,
 "Maxime Coquelin" <mcoquelin.stm32@gmail.com>, maxime.chevallier@bootlin.com,
 "Simon Horman" <simon.horman@corigine.com>
Subject: Re: arm: shmobile_defconfig: ld.lld: error: undefined symbol: lynx_pcs_destroy
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 6, 2023, at 11:01, Geert Uytterhoeven wrote:
> Hi Naresh,
>
> On Tue, Jun 6, 2023 at 10:53=E2=80=AFAM Naresh Kamboju
> <naresh.kamboju@linaro.org> wrote:
>> On Tue, 6 Jun 2023 at 14:17, Naresh Kamboju <naresh.kamboju@linaro.or=
g> wrote:
>> > Following build regressions found while building arm shmobile_defco=
nfig on
>> > Linux next-20230606.
>> >
>> > Regressions found on arm:
>> >
>> >  - build/clang-16-shmobile_defconfig
>> >  - build/gcc-8-shmobile_defconfig
>> >  - build/gcc-12-shmobile_defconfig
>> >  - build/clang-nightly-shmobile_defconfig
>>
>> And mips defconfig builds failed.
>> Regressions found on mips:
>>
>>   - build/clang-16-defconfig
>>   - build/gcc-12-defconfig
>>   - build/gcc-8-defconfig
>>   - build/clang-nightly-defconfig
>
> Please give my fix a try:
> https://lore.kernel.org/linux-renesas-soc/7b36ac43778b41831debd5c30b5b=
37d268512195.1686039915.git.geert+renesas@glider.be
>

This won't work when PCS_LYNX is a loadable module and
STMMAC is built-in. I think we should just select PCS_LYNX
unconditionally from stmmac even if no front-end driver
using it is enabled.

I tried to come up with a way to move the dependency into
the altera specific front-end, but couldn't find an obvious
or simple way to do this.

Having a proper abstraction for PCS drivers instead of
directly calling into exported driver symbols might help
here, but that would add complexity elsewhere.

     Arnd

