Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81857636C1E
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 22:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236590AbiKWVLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 16:11:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235790AbiKWVK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 16:10:59 -0500
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [IPv6:2001:67c:2050:0:465::101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 265E63135A;
        Wed, 23 Nov 2022 13:10:57 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [10.196.197.2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4NHYh00BbQz9sTW;
        Wed, 23 Nov 2022 22:10:56 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1669237856;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zoV8IJSR/yXiIad/qZ2dgaCeQ40WFYfIodxU3rEorVo=;
        b=aemjlTZG77DfvThyM1Nb6NUrP0AxAY8Sssv/1HupJ0dH76iwrtE4DzGBkime2jQWaKOlUa
        7mnlBMjDgJ/2gKCqk9KzvIA2f1BODuLssxnw/QYNdBv9i46TjGlD4mwfh3GA4MFhzqeASH
        MUM2zcaFWGiGox/JAZVMAw7dntslc6QmDpWMAu2JZEgsJF+zwo+DNSDghV0jOIHq1pa38t
        jQxAG2zXdP0xFpdivWnxaqlJ7SnljtvNfZ6pzD6modG8v4ytbC4Q4yeHeHAVg1LzPbkQkl
        8vrB+cllthObd4ydHMrhfcgrIwCyB/aA6DK4uCVxH2BGBEvYsjWKDLSqV7XU7w==
From:   Alexander Lobakin <alobakin@mailbox.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1669237853;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zoV8IJSR/yXiIad/qZ2dgaCeQ40WFYfIodxU3rEorVo=;
        b=TTw8+0Q5t+kKgVe/DZNsnjYtvvQYOy0vwi9qoaI14AS7AU1RzbNMo855JEwhuyRaem/sGE
        J25JjAWLWH0gumWXyjBBlr3FqTD6+V1HCFE0q/BhsQ2aMTVCrc5ysmq1Cy9ZPvW2uo5tAF
        8gGLXEUia/5r0ORqtyUQBR6jHkAa51Zw/78ifAsJTm9Q0Hht56dNMxlJBrdCUnYIbsWb8k
        B1Ufh+W+9coRJeBBqfylBiqi+2PTdajJ3OrlwDcO0CHN7Mm3Bfc06RjLfU1maA0mcctoRk
        bTMyU7Q095P8Bwy5GzLie9V13fh7qeG1Vge90T62GGT08zLlr1SY0NEghZUl5w==
To:     Hans de Goede <hdegoede@redhat.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Cc:     Alexander Lobakin <alobakin@mailbox.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Alexander Lobakin <alobakin@pm.me>,
        linux-kbuild@vger.kernel.org, Nicolas Schier <nicolas@fjasle.eu>,
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
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Daniel Scally <djrscally@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        NXP Linux Team <linux-imx@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/18] platform/x86: int3472: fix object shared between several modules
Date:   Wed, 23 Nov 2022 22:10:35 +0100
Message-Id: <20221123211035.54439-1-alobakin@mailbox.org>
In-Reply-To: <87852fc9-0757-7e58-35a2-90cccf970f5c@redhat.com>
References: <20221119225650.1044591-1-alobakin@pm.me> <20221119225650.1044591-12-alobakin@pm.me> <Y3oxyUx0UkWVjGvn@smile.fi.intel.com> <961a7d7e-c917-86a8-097b-5961428e9ddc@redhat.com> <CAK7LNASxxzA1OEGuJR=BU=6G8XaatGx+gDCMe2s9Y3MRcwptYw@mail.gmail.com> <87852fc9-0757-7e58-35a2-90cccf970f5c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-MBO-RS-META: apd7tkcpfh8hp33ekzxo6ntqtp9t5hsn
X-MBO-RS-ID: cc117617e3320a4af12
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>
Date: Mon, 21 Nov 2022 09:12:41 +0100

> Hi,
> 
> On 11/21/22 00:45, Masahiro Yamada wrote:
> > On Mon, Nov 21, 2022 at 5:55 AM Hans de Goede <hdegoede@redhat.com> wrote:

[...]

> >> So nack from me for this patch, since I really don't see
> >> it adding any value.
> > 
> > 
> > 
> > 
> > This does have a value.
> > 
> > This clarifies the ownership of the common.o,
> > in other words, makes KBUILD_MODNAME deterministic.
> > 
> > 
> > If an object belongs to a module,
> > KBUILD_MODNAME is defined as the module name.
> > 
> > If an object is always built-in,
> > KBUILD_MODNAME is defined as the basename of the object.
> > 
> > 
> > 
> > Here is a question:
> > if common.o is shared by two modules intel_skl_int3472_discrete
> > and intel_skl_int3472_tps68470, what should KBUILD_MODNAME be?
> > 
> > 
> > I see some patch submissions relying on the assumption that
> > KBUILD_MODNAME is unique.
> > We cannot determine KBUILD_MODNAME correctly if an object is shared
> > by multiple modules.

+1

> > 
> > 
> > 
> > 
> > 
> > 
> > BTW, this patch is not the way I suggested.
> > The Suggested-by should not have been there
> > (or at least Reported-by)

(to Masahiro)

Ah, you're right, sorry. Will replace all the tags to Reported-by,
that would look more correct.

> > 
> > 
> > You argued "common.o is tiny", so I would vote for
> > making them inline functions, like
> > 
> > 
> > https://lore.kernel.org/linux-kbuild/20221119225650.1044591-2-alobakin@pm.me/T/#u
> 
> Yes just moving the contents of common.c to static inline helpers in common.h
> would be much better.

Sure, why not. There probably are more of shared object files which
would feel better being static inlines in the series, will see.

> 
> If someone creates such a patch, please do not forget to Cc
> platform-driver-x86@vger.kernel.org

Got it, sure. get_maintainer.pl dropped a wall on me, so I was
picking stuff manually from it and missed that one.

> 
> Regards,
> 
> Hans

[...]

> >>> Ditto. And the same to all your patches.

Thanks,
Olek
