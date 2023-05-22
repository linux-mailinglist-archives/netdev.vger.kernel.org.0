Return-Path: <netdev+bounces-4219-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 42BAB70BBD1
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 13:30:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ECD97280F22
	for <lists+netdev@lfdr.de>; Mon, 22 May 2023 11:30:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C89ABE6D;
	Mon, 22 May 2023 11:30:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38B7BE59
	for <netdev@vger.kernel.org>; Mon, 22 May 2023 11:30:05 +0000 (UTC)
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9E61BF;
	Mon, 22 May 2023 04:30:02 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
	by mailout.west.internal (Postfix) with ESMTP id E43463200893;
	Mon, 22 May 2023 07:30:00 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Mon, 22 May 2023 07:30:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:sender
	:subject:subject:to:to; s=fm3; t=1684755000; x=1684841400; bh=I0
	ZUnK8Op8CDDPBL/yAYTQUqi/o9g4TW10EzMTLXfoE=; b=JrfcKAS3g1/MlJ/TTG
	p1TlzSJzmscQRtD492EcrEi4L2I357wGZhHjkk4lcdB5RF82tv1BXWNPtCyeWAs6
	uWxJEwWThmebIidKlPkuzV3ZIxaPKlUoapZ62RULygBOk3VfOCifYuXyNgID1CrP
	0WmKtVMdlmDcsKxQYF2VfrJvqVKwn2LroEmcubIMYPNiR9RwT1fQkq8JhTKlaqsT
	o28vY8fpAkzM2/jclDwgclzSsk40FVTudetkG/ACb/ARaMAJidON7CBin8/xtawd
	smEHnv/g2P8Ad6OvTrGhs49Hf7ph12Q02uTrMd9l8qHlhjNMbmvSw6yqckqd4NhY
	3i2g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:sender:subject
	:subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
	:x-sasl-enc; s=fm1; t=1684755000; x=1684841400; bh=I0ZUnK8Op8CDD
	PBL/yAYTQUqi/o9g4TW10EzMTLXfoE=; b=pbbdIOoJCIJmUbj0noPpve1ynfD7M
	3tkh/4PFf6bnVetmhnINEiBY+kE5G9WcBOB9/m6403vpVg8+F+14KXnhZ0P9PSWC
	8ATNjuWqyCPFjShDkPQbTm2daCxV9QQyEaBlnhHPM3dBDAGw+4aww452hnfjrKfD
	LZ5XKLHZ1oI8VBQyqkmhJAQ7hVOnl2anNl2cRcWZa+ZEcZK4ELgUiDM4U0Dp1YfB
	HYhn0cqWGnKzRPRe8cb8gDtPIshiVl9o53WGM4RAEJ0VkpNq3MLEEUeVSHbZKg8G
	OsAQuBDiQopcbP9Ou04y4oAf8NRoY6x0qAtMlmIfP7X6I3jiFZk/SNbsg==
X-ME-Sender: <xms:N1JrZPD-xQcG3Qk-fMmqY-uElwqU8b8nwl1pnONzdbtBQ7QwerD7Ww>
    <xme:N1JrZFhIj5_AY1N-m-hPsfiQWwOqHhcd_9QcpA3kU6zzY3TWFJwPLoJ4oxi8J1hmb
    prqOKjtiMmNjv3rx-U>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrfeejuddgfeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtsehttdertderredtnecuhfhrohhmpedftehr
    nhguuceuvghrghhmrghnnhdfuceorghrnhgusegrrhhnuggsrdguvgeqnecuggftrfgrth
    htvghrnhepvefhffeltdegheeffffhtdegvdehjedtgfekueevgfduffettedtkeekueef
    hedunecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpe
    dtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegrrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:N1JrZKk1gaOfBgUq-41z42gjF28SibhfhCAn3GcHCT98XWnE2CkHlw>
    <xmx:N1JrZBwb6f4BF97gPVu2JpfgdT_2_g96CQU7pN_RqMCOiVVOZQkbnA>
    <xmx:N1JrZER3r3k5WK6Oz2U9NMwi6cbPc_k6HBTai-8jjcB1Zrpmds6-hg>
    <xmx:OFJrZGBf4TQHGnLaaXI0u0JMCZUrL0qhyM45i4Tlqr6ss-FU5eI6Hw>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
	id 9559DB60086; Mon, 22 May 2023 07:29:59 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-431-g1d6a3ebb56-fm-20230511.001-g1d6a3ebb
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-Id: <7b5c40f3-d25b-4082-807d-4d75dc38886d@app.fastmail.com>
In-Reply-To: <20230522105049.1467313-1-schnelle@linux.ibm.com>
References: <20230522105049.1467313-1-schnelle@linux.ibm.com>
Date: Mon, 22 May 2023 13:29:39 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Niklas Schnelle" <schnelle@linux.ibm.com>,
 "Richard Cochran" <richardcochran@gmail.com>
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 "Bjorn Helgaas" <bhelgaas@google.com>,
 =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
 "Mauro Carvalho Chehab" <mchehab@kernel.org>,
 "Alan Stern" <stern@rowland.harvard.edu>,
 "Rafael J . Wysocki" <rafael@kernel.org>,
 "Geert Uytterhoeven" <geert@linux-m68k.org>,
 "Paul Walmsley" <paul.walmsley@sifive.com>,
 "Palmer Dabbelt" <palmer@dabbelt.com>, "Albert Ou" <aou@eecs.berkeley.edu>,
 linux-kernel@vger.kernel.org, Linux-Arch <linux-arch@vger.kernel.org>,
 linux-pci@vger.kernel.org, Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v5 00/44] treewide: Remove I/O port accessors for HAS_IOPORT=n
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 22, 2023, at 12:50, Niklas Schnelle wrote:

> A few patches have already been applied but I've kept those which are not yet
> in v6.4-rc3.
>
> This version is based on v6.4-rc3 and is also available on my kernel.org tree
> in the has_ioport_v5:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/niks/linux.git

I think it would be best if as many patches as possible get merged
into v6.5 through the individidual subsystems, though I can take
whatever is left through the asm-generic tree.

Since the goal is to have maintainers pick up part of this, I would
recommend splitting the series per subsystem, having either a
separate patch or a small series for each maintainer that should
pick them up.

More importantly, I think you should rebase the series against
linux-next in order to find and drop the patches that are queued
up for 6.5 already. The patches will be applied into branches
that are based on 6.4-rc of course, but basing on linux-next
is usually the easiest when targeting multiple maintainer
trees.

Maybe let's give it another week to have more maintainers pick
up stuff from v5, and then send out a v6 as separate submissions.

    Arnd

