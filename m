Return-Path: <netdev+bounces-8419-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B045723FAE
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 12:35:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 45919280C83
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 10:35:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FFDD125B6;
	Tue,  6 Jun 2023 10:35:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 149EB290E6
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 10:35:10 +0000 (UTC)
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 403A7E8;
	Tue,  6 Jun 2023 03:35:05 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
	by mailout.nyi.internal (Postfix) with ESMTP id A4ADA5C0195;
	Tue,  6 Jun 2023 06:35:04 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Tue, 06 Jun 2023 06:35:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to; s=fm1; t=
	1686047704; x=1686134104; bh=IJQmq65vo/TbxYcHIKSUTBkPubJ2sYVBmz1
	OpSutP+s=; b=tCzQEzAjGZmWxxg0Ys+hL5Ofm4CPVdUeLjDckZFymKghC6s96mw
	gMZl3xgVf8H37np+jaeqlCqbYevDJiRbGY2Y/QQ3IWuFNAlXeGCZdi08Vcfcc0Ig
	diYEzw+rSM+Dzk3BSpaMiv5GE0Fdz8jHigsmr2UdmhCzl01x59DJi5TjtiytNiF3
	UmOcaqRaB/zgz8hccLy+dYgfs9m6tLz0fEqLkFzvZBkzQhcG0X2aUR4HFOcN7nKA
	zoPHmevhyLm+ezVo8xuA7PC1C+GcKT3KKVImStNZyAK6BwbbCg9o0lkHOmE54UP5
	wHIx6YkhU6aW08qloWot58nqZUIXbHvKWpg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:sender:subject:subject:to:to:x-me-proxy
	:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1686047704; x=1686134104; bh=IJQmq65vo/TbxYcHIKSUTBkPubJ2sYVBmz1
	OpSutP+s=; b=E+EsLFO/5IILXucgn/rmLn2SynkIfpG6UlhSY0K+d6ngVmYtFVs
	Z93C/0xl1wEd9cJuq/V7RM1yR871b8XT72xa8VF5BfojzjVwVY9SI3T6z56OzxcX
	UmlQD5SeAHvx+UVVQtlDHz9DSferigh6Cd3G8ySCrXy/vq/+MHIlBcOXrgplqddG
	T8v5++J4OnGDCHmBw9BALl2hV0SAJ89NvPz84hYO5OhJIFHy3AfNkeCIc04HqDTL
	FeCp5OAAqigWhxJ15dRDmgGU7/ABUqyW+WRY4MG5+0HcnE+W6ib6GXrjkuRc+W7e
	GKi0U8F0krbMsqOy99KcTeyEHnTYONae/dw==
X-ME-Sender: <xms:2At_ZFQXGlpaLXRb-FKKTAqrc0pulFP8udxzt88XqjyQ8K0UFsM3jQ>
    <xme:2At_ZOyCd28aXyALQC3PVPO6o0PaGmP23JkWndPkNur32dASExOlo_ffc07G7id5B
    hmtzMPp-va_RxleymQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrgedtuddgfedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtgfesthhqredtreerjeenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrg
    htthgvrhhnpeegfeejhedvledvffeijeeijeeivddvhfeliedvleevheejleetgedukedt
    gfejveenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:2At_ZK0ecybGQW_MNqaqlU7GoWujfE7ptyRpbrOeIJ0DHP3iTunStA>
    <xmx:2At_ZNDp8l6mOdR2eQLeedsNGAnqjJSZUE06SxrIINLmHvtQiG-hsw>
    <xmx:2At_ZOgxgtPbSIXKXmeDmjXO9ttv-P5WyjQ83itGHa1fyUDSDJl8Vw>
    <xmx:2At_ZJWZ6PzikjwmYUrIDoA3aSGEwuKMI9vaMequyXHCoawrETVi-Q>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id 675B9B60086; Tue,  6 Jun 2023 06:35:04 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-447-ge2460e13b3-fm-20230525.001-ge2460e13
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-Id: <34b7bbab-a301-42ad-a2cc-3b68ee1475b7@app.fastmail.com>
In-Reply-To: 
 <CAMuHMdWKL3UHzkEq3qOChMsgOsr+9uj215x55xLzbOUJWwQVzg@mail.gmail.com>
References: 
 <CA+G9fYv0a-XxXfG6bNuPZGT=fzjtEfRGEYwk3n6M1WhEHUPo9g@mail.gmail.com>
 <CA+G9fYueN0xti1SDtYVZstPt104sUj06GfOzyqDNrd3s3xXBkA@mail.gmail.com>
 <CAMuHMdX7hqipiMCF9uxpU+_RbLmzyHeo-D0tCE_Hx8eTqQ7Pig@mail.gmail.com>
 <11bd37e9-c62e-46ba-9456-8e3b353df28f@app.fastmail.com>
 <CAMuHMdUH2Grrv6842YWXHDmd+O3iHdwqTVjYf8f1nbVRzGA+6w@mail.gmail.com>
 <8db9886f-e24f-44ee-8f8a-880dc3e4bf75@app.fastmail.com>
 <CAMuHMdWKL3UHzkEq3qOChMsgOsr+9uj215x55xLzbOUJWwQVzg@mail.gmail.com>
Date: Tue, 06 Jun 2023 12:34:43 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Geert Uytterhoeven" <geert@linux-m68k.org>
Cc: "Naresh Kamboju" <naresh.kamboju@linaro.org>,
 "open list" <linux-kernel@vger.kernel.org>,
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

On Tue, Jun 6, 2023, at 12:31, Geert Uytterhoeven wrote:
> On Tue, Jun 6, 2023 at 12:21=E2=80=AFPM Arnd Bergmann <arnd@arndb.de> =
wrote:
>> On Tue, Jun 6, 2023, at 11:28, Geert Uytterhoeven wrote:
>> > On Tue, Jun 6, 2023 at 11:16=E2=80=AFAM Arnd Bergmann <arnd@arndb.d=
e> wrote:
>> >> On Tue, Jun 6, 2023, at 11:01, Geert Uytterhoeven wrote:
>> >>
>> >> This won't work when PCS_LYNX is a loadable module and
>> >> STMMAC is built-in. I think we should just select PCS_LYNX
>> >
>> > Oops, you're right, forgot about that case.
>> > What about using IS_REACHABLE() instead?
>> > No, that won't work either, as DWMAC_SOCFPGA can be modular,
>> > with STMMAC builtin.
>>
>> It would work because of the 'select PCS_LYNX' below DWMAC_SOCFPGA,
>
> That was my first thought, but it won't work, as DWMAC_SOCFPGA=3Dm
> causes PCS_LYNX=3Dm, while main STMMAC can still be builtin.

Right, got it now.

     Arnd

