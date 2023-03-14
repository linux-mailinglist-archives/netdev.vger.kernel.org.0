Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD6E6B973F
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 15:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232159AbjCNOGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 10:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231473AbjCNOGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 10:06:14 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 170D9A569F;
        Tue, 14 Mar 2023 07:06:13 -0700 (PDT)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 66EE23200915;
        Tue, 14 Mar 2023 10:06:11 -0400 (EDT)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Tue, 14 Mar 2023 10:06:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-transfer-encoding:content-type:content-type:date
        :date:from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to; s=fm1; t=
        1678802771; x=1678889171; bh=PdfK+KgXqfYYyNRjIkKag7bPoiI2QGHeotH
        fnMzy5uI=; b=lRjz8gAgTrnap6Tbsvg1QVgqc6mc+U8iR/rghiWBlGt/3PSldo2
        3ql0zJOXGWB2/0ZN0eEx1f4AP/dNiI3z3A++CfYn8kwNS4ymO+mr8aV6DeVLUpTS
        445AvFcrlT+6uy86y1LzK3YOI8xWXRuAkZ4V0UB8KNbBgkpTl7ETQ+uX8ar0AKHJ
        fwcVOMblHvKo1Htob+9okttczpE2sU94IbGqQ7kmN4rRK+ulGKtmrAull99iGETA
        PJcAbnygwCwMjm2836O3HtmBhTpVkesIARFkuCPRpX57fBCSxIcSWdrSuEv+MMBC
        HiYsOJ9svTIaYKvh7EuJLN0KAmjfP+Fcl9g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:content-type:date:date:feedback-id:feedback-id
        :from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
        1678802771; x=1678889171; bh=PdfK+KgXqfYYyNRjIkKag7bPoiI2QGHeotH
        fnMzy5uI=; b=teK+0BSFRYPnnWLZwAeeKsUTiOEAx1eqXoC0ysADEH9WTuH2KBf
        GiYQN6UJLPyxoeMlKYLyEucj3rDazxlXMV4bBmPoQBfj7pyLJuxz7g08lwcIafIA
        tZyk1ACiXmaCEXgUDpKsNtkT4lU1isMv4WP69/BrK7VNHqUHWPaYzzNaLxcAKbuZ
        2koPei5dWjJ79aOL7rCUhBvbqYVmzDEkVyxnh2EzwZp7xjZwoGdRMzXAhyRXfEqE
        ZL8u74wvvq6lujkAMU9U1nY4kM8IDBnizVwZECeIEZBO4P8Dlyv1NmkR+7MkRgO4
        a72UqmHTz2q/jN36pvUp05p4V882tH0rilw==
X-ME-Sender: <xms:Un8QZIkjSHHLJpVH5Zp66upFpggui2u4cvFIloxFbiduiQD_1zOHSA>
    <xme:Un8QZH1T5uPhAVcwLGNXS7kzuaX_pxK4AqoAdZyf4ZkFrdEMldlosU60fF24IVnej
    Fu2dwI4pheeUy7FaSA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvddviedgieduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepofgfggfkjghffffhvfevufgtgfesthhqredtreerjeenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrg
    htthgvrhhnpefgkeeuleegieeghfduudeltdekfeffjeeuleehleefudettddtgfevueef
    feeigeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivg
    eptdenucfrrghrrghmpehmrghilhhfrhhomheprghrnhgusegrrhhnuggsrdguvg
X-ME-Proxy: <xmx:Un8QZGoysEz2YYLAuFxIn3qw_uL8BE9ISoqiu09qN1ur0bDRTVU96g>
    <xmx:Un8QZEkf7J6Kga513TZD4j7g_Sxp-UpTacfl_UZun_wygq3wqGByHQ>
    <xmx:Un8QZG2sNDBg_IUTM2oRGjnHoBZHMPRWbE14qlI8f6uIHoCx2nGpwQ>
    <xmx:U38QZAM8V-fIt2la_6MojocqWRthSshF5NQ8bZQTAyvWB3JfEIKVRg>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 2464CB60086; Tue, 14 Mar 2023 10:06:10 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-221-gec32977366-fm-20230306.001-gec329773
Mime-Version: 1.0
Message-Id: <7ec48487-8565-4a1d-963b-5092eb5f4d15@app.fastmail.com>
In-Reply-To: <20230314121216.413434-1-schnelle@linux.ibm.com>
References: <20230314121216.413434-1-schnelle@linux.ibm.com>
Date:   Tue, 14 Mar 2023 15:05:49 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Niklas Schnelle" <schnelle@linux.ibm.com>,
        "Richard Cochran" <richardcochran@gmail.com>,
        "Paul Walmsley" <paul.walmsley@sifive.com>,
        "Palmer Dabbelt" <palmer@dabbelt.com>,
        "Albert Ou" <aou@eecs.berkeley.edu>
Cc:     "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Bjorn Helgaas" <bhelgaas@google.com>,
        =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
        "Mauro Carvalho Chehab" <mchehab@kernel.org>,
        "Alan Stern" <stern@rowland.harvard.edu>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        "Geert Uytterhoeven" <geert@linux-m68k.org>,
        linux-kernel@vger.kernel.org,
        Linux-Arch <linux-arch@vger.kernel.org>,
        linux-pci@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
        linux-riscv@lists.infradead.org
Subject: Re: [PATCH v3 00/38] Kconfig: Introduce HAS_IOPORT config option
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023, at 13:11, Niklas Schnelle wrote:
> Hello Kernel Hackers,
>
> Some platforms such as s390 do not support PCI I/O spaces. On such pla=
tforms
> I/O space accessors like inb()/outb() are stubs that can never actuall=
y work.
> The way these stubs are implemented in asm-generic/io.h leads to compi=
ler
> warnings because any use will be a NULL pointer access on these platfo=
rms. In
> a previous patch we tried handling this with a run-time warning on acc=
ess. This
> approach however was rejected by Linus[0] with the argument that this =
really
> should be a compile-time check and, though a much more invasive change=
, we
> believe that is indeed the right approach.
>
> This patch series aims to do exactly that by introducing a HAS_IOPORT =
config
> option akin to the existing HAS_IOMEM. When this is unset inb()/outb()=
 and
> friends may not be defined. This is also the same approach originally =
planned by
> Uwe Kleine-K=C3=B6nig as mentioned in commit ce816fa88cca ("Kconfig: r=
ename
> HAS_IOPORT to HAS_IOPORT_MAP").
>
> This series builds heavily on an original patch for demonstating the c=
oncept by
> Arnd Bergmann[1] and incoporates feedback of previous RFC versions [2]=
 and [3].
>
> This version is based on v6.3-rc1 and is also available on my kernel.o=
rg tree
> in the has_ioport_v3 branch with the PGP signed tag has_ioport_v3_sign=
ed:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/niks/linux.git

Thanks a lot for the rebase, hopefully we can finally get this merged.
I'll go through all patches and note everything I spot that should
be improved. I'd like to make sure that at least the first patch
can get merged quickly so we can continue on the rest.

Since this is all related to asm-generic/io.h and cross-architecture
work, I can pick up anything that has nobody else maintaining it
through the asm-generic tree.

   Arnd
