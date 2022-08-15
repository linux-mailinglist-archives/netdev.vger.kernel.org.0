Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E641A5930D9
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 16:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232742AbiHOOf0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 10:35:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbiHOOfW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 10:35:22 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F317B26EC;
        Mon, 15 Aug 2022 07:35:20 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 4325D5C00AD;
        Mon, 15 Aug 2022 10:35:17 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 15 Aug 2022 10:35:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1660574117; x=1660660517; bh=psq3UPz+5DdIdOmztd5OKOTJ4erP
        Qsdb9+3N6tWZSE8=; b=QMC8rpEY6QNcODaiqXdoHjlpr1DivBuVJTU08mSpsQrD
        Gnp7brnAJ8afjnsFJyRs+O+c1lDwtlpCxjty6EP+0C0fsZupN6hUbVrOf5C7VZVp
        ovB6CqAp5tw70dR8R08vKJDNB+ZmAPk2joUqgRoydVWYAlxiT8SRzbH9MStlkL1g
        u83gSCTlJoznBXWPPI5+N9M/YB2zK+ZrlINkgODsxBmbhqLi8PDKVFUksi1dE1lF
        EafK3QYPgPspX69LfY92Tk/7jm0RYhbMfq/MejfkuSQwlbPVBrsBfLfY7sfGd3/k
        f5MBjClxBIiSKYsqLjI6gZLo+GOyqXXgGk0tS0Haow==
X-ME-Sender: <xms:o1n6YvDqmSpaINP2qYzPApDHDZ7Cd8Qi7XpK9iFj7eQp-RaLgH3_yw>
    <xme:o1n6YljE0mm9FKAbOyzg80Yt9zEBmMoo8G8InlBQE4vb2ikuIxr-cDZsyXTic1EXe
    6bms1nMRF8W2V8>
X-ME-Received: <xmr:o1n6YqkBpbMq63JXAIMEV8_FoVHLqQD62qJ_HcuGdx28kY_npqZhKptA4Gb->
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdehvddgjeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    goufhushhpvggtthffohhmrghinhculdegledmnecujfgurhepfffhvfevuffkfhggtggu
    jgesthdtredttddtvdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstg
    hhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvghrnheptdetgffhffettdetgeek
    gffghfegledugefgfffhgfejvdelieegjeefudeltdffnecuffhomhgrihhnpehhohhpth
    hordhorhhgpdhkvghrnhgvlhdrohhrghdpfhgvughorhgrphhrohhjvggtthdrohhrghen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:o1n6Yhz3bhejUDLsLnfWiTsgEQP55hf9r5SEKkElrXPcqYZJylrMHQ>
    <xmx:o1n6YkQjVv74qjaAHUfGSKP5CcTD1fs5c7GbnEyrYCibOoQ2Jhxg_g>
    <xmx:o1n6Yka48qkOPc1mXHNLBB_4nM_0l6k8R_tynBe3TUtYlsYE5gWClQ>
    <xmx:pVn6Ygo7hIVvobPkxvMp60YKzfHSjFUoPIKy-WpheJK-YxSd-TTpKA>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 15 Aug 2022 10:35:14 -0400 (EDT)
Date:   Mon, 15 Aug 2022 17:35:12 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Terry Bowman <terry.bowman@amd.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Wolfram Sang <wsa@kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        UNGLinuxDriver@microchip.com,
        Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        katie.morris@in-advantage.com,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Lee Jones <lee@kernel.org>
Subject: Re: [PATCH v16 mfd 8/8] mfd: ocelot: add support for the vsc7512
 chip via spi
Message-ID: <YvpZoIN+5htY9Z1o@shredder>
References: <20220815005553.1450359-1-colin.foster@in-advantage.com>
 <20220815005553.1450359-9-colin.foster@in-advantage.com>
 <YvpV4cvwE0IQOax7@euler>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvpV4cvwE0IQOax7@euler>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 15, 2022 at 07:19:13AM -0700, Colin Foster wrote:
> Something is going on that I don't fully understand with <asm/byteorder.h>.
> I don't quite see how ocelot-core is throwing all sorts of errors in x86
> builds now:
> 
> https://patchwork.hopto.org/static/nipa/667471/12942993/build_allmodconfig_warn/stderr
> 
> Snippet from there:
> 
> /home/nipa/nipa/tests/patch/build_32bit/build_32bit.sh: line 21: ccache gcc: command not found
> ../drivers/mfd/ocelot-spi.c: note: in included file (through ../include/linux/bitops.h, ../include/linux/kernel.h, ../arch/x86/include/asm/percpu.h, ../arch/x86/include/asm/current.h, ../include/linux/sched.h, ...):
> ../arch/x86/include/asm/bitops.h:66:1: warning: unreplaced symbol 'return'
> ../drivers/mfd/ocelot-spi.c: note: in included file (through ../include/linux/bitops.h, ../include/linux/kernel.h, ../arch/x86/include/asm/percpu.h, ../arch/x86/include/asm/current.h, ../include/linux/sched.h, ...):
> ../include/asm-generic/bitops/generic-non-atomic.h:29:9: warning: unreplaced symbol 'mask'
> ../include/asm-generic/bitops/generic-non-atomic.h:30:9: warning: unreplaced symbol 'p'
> ../include/asm-generic/bitops/generic-non-atomic.h:32:10: warning: unreplaced symbol 'p'
> ../include/asm-generic/bitops/generic-non-atomic.h:32:16: warning: unreplaced symbol 'mask'
> ../include/asm-generic/bitops/generic-non-atomic.h:27:1: warning: unreplaced symbol 'return'
> ../drivers/mfd/ocelot-spi.c: note: in included file (through ../arch/x86/include/asm/bitops.h, ../include/linux/bitops.h, ../include/linux/kernel.h, ../arch/x86/include/asm/percpu.h, ../arch/x86/include/asm/current.h, ...):
> ../include/asm-generic/bitops/instrumented-non-atomic.h:26:1: warning: unreplaced symbol 'return'
> 
> 
> <asm/byteorder.h> was included in both drivers/mfd/ocelot-spi.c and
> drivers/mfd/ocelot.h previously, though Andy pointed out there didn't
> seem to be any users... and I didn't either. I'm sure there's something
> I must be missing.

I got similar errors in our internal CI yesterday. Fixed by compiling
sparse from git:
https://git.kernel.org/pub/scm/devel/sparse/sparse.git/commit/?id=0e1aae55e49cad7ea43848af5b58ff0f57e7af99

The update is also available in the "testing" repo in case you are
running Fedora 35 / 36:
https://bodhi.fedoraproject.org/updates/FEDORA-2022-c58b53730f
https://bodhi.fedoraproject.org/updates/FEDORA-2022-2bc333ccac
