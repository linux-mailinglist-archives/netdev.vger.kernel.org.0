Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF6D634B7F
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 01:09:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235088AbiKWAIz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 19:08:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233239AbiKWAIy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 19:08:54 -0500
X-Greylist: delayed 8654 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 22 Nov 2022 16:08:52 PST
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE35D32A4;
        Tue, 22 Nov 2022 16:08:52 -0800 (PST)
Received: from smtp102.mailbox.org (smtp102.mailbox.org [10.196.197.102])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4NH1gj3rZZz9sTQ;
        Wed, 23 Nov 2022 01:08:49 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1669162129;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cpqvGJ6KHdgLHFmpNmxmrXgmC1bx/Ijm3WunVFRnkw8=;
        b=NVUYey2k2K8/IrYW3JGEDZESFL6/uhPXoiCIN8SzxBE7jhaaj8sieiF6qlGgllfmUJbbLk
        xDaoOIRoRtJQmPLi5H3E29F7KatUV8IaZrKIbMXkjnRnH8wKVLx9YvcsQe+NDGVo4NHtUC
        O/ArolaHMB7GmaJ0Uw686jKXBBrWwV3UeFEGBtmTovhKHxWT8p3/1sG7zInM/e5PjKxaDJ
        T69o2tdnpewUcxioIL0lxfwyMzEwZirPdjxpJqWEcX+Z0sD3h6Gnv/DmypFZPjPAYJBQLB
        WmxmO0c+2N48vREjxSYKeUVdKmXBqVwLbWVmeqJJ03SRemLZfZywA54GURowNA==
From:   Alexander Lobakin <alobakin@mailbox.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1669162127;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cpqvGJ6KHdgLHFmpNmxmrXgmC1bx/Ijm3WunVFRnkw8=;
        b=WkehU/oV9+TML/PIcxU1BvQiDNn9y2L5Xnh9BkbreCCPYxkL0Nk0U/O+0LNm5r8aDmNpbN
        HB42nmlAyGfJLZTcxWrcOO4NlAI3UVQ7G+icweKve6RntZnLmJYGb178H+Lgg2lIEKABro
        +v8pEtdYqQil7x8/hHheEw+rO4OwM/GAFfgGkKg1oiHACXi5kt29fAVO70KzPcbbaKW5Jx
        OKA17Eq02YcT5ukmzXqMILvdhsQtW9QWviqT5v1ktYokNOKfX5a9PPA+DYR5zhIFBhNDd/
        xQGK+qT7O/3pLZIQHr2xzwQI8WAnU/TeOkBUFJWrS2JScwOt95cDxCNDFEUiiQ==
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Alexander Lobakin <alobakin@mailbox.org>,
        Alexander Lobakin <alobakin@pm.me>,
        linux-kbuild@vger.kernel.org,
        Masahiro Yamada <masahiroy@kernel.org>,
        Nicolas Schier <nicolas@fjasle.eu>,
        Jens Axboe <axboe@kernel.dk>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Borislav Petkov <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Derek Chickles <dchickles@marvell.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Daniel Scally <djrscally@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        NXP Linux Team <linux-imx@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/18] platform/x86: int3472: fix object shared between several modules
Date:   Wed, 23 Nov 2022 01:01:51 +0100
Message-Id: <20221123000151.64567-1-alobakin@mailbox.org>
In-Reply-To: <Y3oxyUx0UkWVjGvn@smile.fi.intel.com>
References: <20221119225650.1044591-1-alobakin@pm.me> <20221119225650.1044591-12-alobakin@pm.me> <Y3oxyUx0UkWVjGvn@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8bit
X-MBO-RS-ID: 128ac0f89d98468d511
X-MBO-RS-META: 48m5g8ybbkypsfb8mrejc38cmasgeyh5
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Sun, 20 Nov 2022 15:55:21 +0200

> On Sat, Nov 19, 2022 at 11:08:17PM +0000, Alexander Lobakin wrote:
> > common.o is linked to both intel_skl_int3472_{discrete,tps68470}:
> > 
> > > scripts/Makefile.build:252: ./drivers/platform/x86/intel/int3472/Makefile:
> > > common.o is added to multiple modules: intel_skl_int3472_discrete
> > > intel_skl_int3472_tps68470
> > 
> > Although both drivers share one Kconfig option
> > (CONFIG_INTEL_SKL_INT3472), it's better to not link one object file
> > into several modules (and/or vmlinux).
> > Under certain circumstances, such can lead to the situation fixed by
> > commit 637a642f5ca5 ("zstd: Fixing mixed module-builtin objects").
> > 
> > Introduce the new module, intel_skl_int3472_common, to provide the
> > functions from common.o to both discrete and tps68470 drivers. This
> > adds only 3 exports and doesn't provide any changes to the actual
> > code.
> 
> ...
> 
> > +MODULE_IMPORT_NS(INTEL_SKL_INT3472);
> > +
> 
> Redundant blank line. You may put it to be last MODULE_*() in the file, if you
> think it would be more visible.

My intention was that it's not "standard" module info like license
or description, rather something like exports or initcalls, that's
why I did separate them.
But I haven't been using module namespaces a lot previously, so if
it should be in one block with the rest MODULE_*(), sure, I'll fix.

> 
> >  MODULE_DESCRIPTION("Intel SkyLake INT3472 ACPI Discrete Device Driver");
> >  MODULE_AUTHOR("Daniel Scally <djrscally@gmail.com>");
> >  MODULE_LICENSE("GPL v2");
> 
> ...
> 
> > +MODULE_IMPORT_NS(INTEL_SKL_INT3472);
> > +
> >  MODULE_DESCRIPTION("Intel SkyLake INT3472 ACPI TPS68470 Device Driver");
> >  MODULE_AUTHOR("Daniel Scally <djrscally@gmail.com>");
> >  MODULE_LICENSE("GPL v2");
> 
> Ditto. And the same to all your patches.
> 
> -- 
> With Best Regards,
> Andy Shevchenko

Thanks,
Olek
