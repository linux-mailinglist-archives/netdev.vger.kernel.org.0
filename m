Return-Path: <netdev+bounces-8863-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B540A7261DF
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 15:59:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7921E281354
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 13:59:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88CA835B50;
	Wed,  7 Jun 2023 13:59:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F5235B47
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 13:59:55 +0000 (UTC)
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87BD71BE3;
	Wed,  7 Jun 2023 06:59:50 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
	by mailout.west.internal (Postfix) with ESMTP id 9B9BB32009C9;
	Wed,  7 Jun 2023 09:59:48 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Wed, 07 Jun 2023 09:59:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to; s=fm1; t=
	1686146388; x=1686232788; bh=C1/PPFK76RYGN0Wi/Mwnqwy5EnGsNMVyC1f
	q6wl4Lgo=; b=N94sjlEDw+7eqMe0VE7UWgX6y2gBrWUPTfP9XnttaDn4JUN5gU+
	wB2IVm1sXRGLX7ZI5+MWMYSyAwhNr5+6iqMTM25v+o34cBarfa5nBDy1LaGA7kdR
	SxXJ3GVDQo7uYkuoZmbxm8riLW9NO10z8mOkRoIJdkAFehkVrTVX2Yj8BLJulwCm
	poD+eeOKbeCMIXeutz/FdF6SYpu2MoVPN8aKjNi3LS3o6w150/sNAerdHcGYbjZg
	4kgogM+M25GTi5mF6bXIoARTqCRoTP9HBznHL8IJXv1dcZ6IOeXDbR1R8RI8eGBx
	CH5hul4n9H0UoL6/BgBSjGTCif+D9Mxbmlw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to:x-me-proxy
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1686146388; x=1686232788; bh=C1/PPFK76RYGN0Wi/Mwnqwy5EnGsNMVyC1f
	q6wl4Lgo=; b=WcpaErCCdgjRsQYuwLSeM0Ybs/fyKw3OWAv0AJQ8PdU2tq884fS
	S6B/QMDkDQRvLBaE50sYPnj940IgDstyZtqXOF8RPaQY4v2n820zvafPRFzoFC9L
	2EH+KYT9PmkuEqZKPYF03oVjDHg0tvEgFYqObd9r25yGcmpNo9LLUGGRRDegaOZc
	pJhi5J24P4rEO81gKwi+zCRSJ7FemB2XA4YE/n/FSz+n5mM+KIwQQNL702eDZQhg
	DZeTJsPucyuJrAr8M/JIa92srDfoLWbcP9KC9DK+GlO6+jXKQIuBWR5SeoXJrAdn
	cMXxw4X4mSCmBM5kkECUT+4/r+zX35kt7Hg==
X-ME-Sender: <xms:U42AZE4iEDNlUWTOZ5jsGR-oi32y02IHC0pnsfn2_lRfSXiCgrLMrw>
    <xme:U42AZF7LjsjQMA_VpEUFUePKlqEd-xMDxZ_Cw4Q9OcxY--SG9kbtMZ7hCbicmpTg2
    QJNEVlJa2S2sgy4-_E>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgedtgedgjedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtgfesthhqredtreerjeenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrg
    htthgvrhhnpefgkeeuleegieeghfduudeltdekfeffjeeuleehleefudettddtgfevueef
    feeigeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:U42AZDdji6XqQbaFt4jdZj3pJdGlIrjRg3lK-9EpUEunajW9Gwc65A>
    <xmx:U42AZJIUFCWpWxOWaWbV9hJT_IkOKGK5syDCiR-s_yXbxbzJ0gVasQ>
    <xmx:U42AZIKy46IcXeT3DUSgdLDR2BqkdbweBcNzGaecP1TJxsrrxIBPCQ>
    <xmx:VI2AZNC0Pt6LaYrJRBjsTzc71nM9Q0XiVI8K_wMrnRx0_YrO8Zxc1w>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id 3F1A4B60086; Wed,  7 Jun 2023 09:59:47 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-447-ge2460e13b3-fm-20230525.001-ge2460e13
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-Id: <e5c92642-02cd-4020-ac1c-7562b1e03f7d@app.fastmail.com>
In-Reply-To: <9fc1d064-7b97-9c1a-f76a-7be467994693@amd.com>
References: 
 <CA+G9fYv0a-XxXfG6bNuPZGT=fzjtEfRGEYwk3n6M1WhEHUPo9g@mail.gmail.com>
 <CA+G9fYueN0xti1SDtYVZstPt104sUj06GfOzyqDNrd3s3xXBkA@mail.gmail.com>
 <CAMuHMdX7hqipiMCF9uxpU+_RbLmzyHeo-D0tCE_Hx8eTqQ7Pig@mail.gmail.com>
 <9fc1d064-7b97-9c1a-f76a-7be467994693@amd.com>
Date: Wed, 07 Jun 2023 15:59:26 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Aithal, Srikanth" <sraithal@amd.com>,
 "Geert Uytterhoeven" <geert@linux-m68k.org>,
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
 "Maxime Coquelin" <mcoquelin.stm32@gmail.com>,
 "Maxime Chevallier" <maxime.chevallier@bootlin.com>, joyce.ooi@intel.com
Subject: Re: arm: shmobile_defconfig: ld.lld: error: undefined symbol: lynx_pcs_destroy
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 7, 2023, at 15:27, Aithal, Srikanth wrote:
> On 6/6/2023 2:31 PM, Geert Uytterhoeven wrote:
>> On Tue, Jun 6, 2023 at 10:53=E2=80=AFAM Naresh Kamboju
>> <naresh.kamboju@linaro.org> wrote:
>>> On Tue, 6 Jun 2023 at 14:17, Naresh Kamboju <naresh.kamboju@linaro.o=
rg> wrote:
>>>> Following build regressions found while building arm shmobile_defco=
nfig on
>>>> Linux next-20230606.
>>>>
>>>> Regressions found on arm:
>>>>
>>>>   - build/clang-16-shmobile_defconfig
>>>>   - build/gcc-8-shmobile_defconfig
>>>>   - build/gcc-12-shmobile_defconfig
>>>>   - build/clang-nightly-shmobile_defconfig
>>>
>>> And mips defconfig builds failed.
>>> Regressions found on mips:
>>>
>>>    - build/clang-16-defconfig
>>>    - build/gcc-12-defconfig
>>>    - build/gcc-8-defconfig
>>>    - build/clang-nightly-defconfig
>>=20
>> Please give my fix a try:
>> https://lore.kernel.org/linux-renesas-soc/7b36ac43778b41831debd5c30b5=
b37d268512195.1686039915.git.geert+renesas@glider.be
> On x86 as well seeing couple of issues related to same, not on defconf=
ig=20
> though..
>
> ERROR: modpost: "lynx_pcs_destroy"=20
> [drivers/net/ethernet/stmicro/stmmac/stmmac.ko] undefined!
> ERROR: modpost: "lynx_pcs_destroy"=20
> [drivers/net/ethernet/altera/altera_tse.ko] undefined!
> make[1]: *** [scripts/Makefile.modpost:136: Module.symvers] Error 1
> make: *** [Makefile:1984: modpost] Error 2
>
> Among above issues stmmac issue would be resolved with above mentioned=
 fix.

I sent out my version of the build fixups for altera and stmmac now.

     Arnd

