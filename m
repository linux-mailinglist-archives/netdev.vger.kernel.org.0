Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B495E636C48
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 22:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237693AbiKWVUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 16:20:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237461AbiKWVUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 16:20:14 -0500
Received: from mout-p-202.mailbox.org (mout-p-202.mailbox.org [80.241.56.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 587C05E9F4;
        Wed, 23 Nov 2022 13:20:13 -0800 (PST)
Received: from smtp102.mailbox.org (smtp102.mailbox.org [10.196.197.102])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-202.mailbox.org (Postfix) with ESMTPS id 4NHYtg3P73z9sTD;
        Wed, 23 Nov 2022 22:20:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1669238411;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=txOGkrEA2n8kD8rEb+sAuk9hGQgHmqWBcmtclgoTBow=;
        b=xp3P1yXiwkHyvCRR3nMU8w8Q0Xg1m5xyYuoXjPjkacNskP3q+cf0FGW5kcuZ9G4KJaJH3I
        QauiysLTZ6bPazxXb4dA7phTs9q4cbp1++pupbvpQpRPgqED4NvDLQkPbyv6t2TgPSQX5S
        oT5Ja49ownGekLV5AhGYO3C10cToqURFT9VdXsmHr6zYxJhqhaC6g0PvoK0I/QpKuxuQ/r
        cpkRcLEZisIpU3eCkHbNyXsxD7eHjmvx4tVySwuHdL8VSvFyBTSU3ajSMQNj+5rMMTIWWF
        WdSYf4yuzux7V+IOaiTrAgh7jIfMgT3DyC582f1NPJLQ/4r3EcIqARfFHNAuLw==
From:   Alexander Lobakin <alobakin@mailbox.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1669238409;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=txOGkrEA2n8kD8rEb+sAuk9hGQgHmqWBcmtclgoTBow=;
        b=MVuobNhkS/3qacNzrNQJBCjQo0VS+KDBfqurTDLaIB/nGqdtDdlgDUFx6X5y/UYLgdjaWb
        hVxOzqmiFVXKrrWBWbMGbjO1HUdE8mrwInYdoXJ0WZNLosxzUr0FCH3L7kt8alcbtXF/UH
        ysUXTl1WqJMioRJVdsiOCcWBpt+FKcA2/uYEfgVqLrmEugVLN47LmeWpu5HH5bWqPj6E/7
        7qZqUjyN8/4DBAQ2KMyPdgjlbKoyTfBdPsiX0g3S4QZjURvbzCnJaNLKKBQsk0YUPACPS7
        Jo3OTcmTOkXB331YwbTLCGmrB+feFH4PkAuirqKjQro/c1f5BnBISCG7Ci292g==
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
        Daniel Scally <djrscally@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        NXP Linux Team <linux-imx@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/18] platform/x86: int3472: fix object shared between several modules
Date:   Wed, 23 Nov 2022 22:19:38 +0100
Message-Id: <20221123211938.56830-1-alobakin@mailbox.org>
In-Reply-To: <a1f611fd-28ad-83ef-5d17-94fe2c4a6a7f@redhat.com>
References: <20221119225650.1044591-1-alobakin@pm.me> <20221119225650.1044591-12-alobakin@pm.me> <Y3oxyUx0UkWVjGvn@smile.fi.intel.com> <961a7d7e-c917-86a8-097b-5961428e9ddc@redhat.com> <CAK7LNASxxzA1OEGuJR=BU=6G8XaatGx+gDCMe2s9Y3MRcwptYw@mail.gmail.com> <87852fc9-0757-7e58-35a2-90cccf970f5c@redhat.com> <CAK7LNAROUV6Z6L6yn4WiigfPRJTGU4+j0ujLt6nsxVp9+aCUzw@mail.gmail.com> <a1f611fd-28ad-83ef-5d17-94fe2c4a6a7f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-MBO-RS-META: 91q874awb8ra8xgpfair6nbfiyk3i8ke
X-MBO-RS-ID: 2715b19c8ed0829371d
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>
Date: Mon, 21 Nov 2022 10:34:11 +0100

> Hi,
> 
> On 11/21/22 10:06, Masahiro Yamada wrote:
> > On Mon, Nov 21, 2022 at 5:12 PM Hans de Goede <hdegoede@redhat.com> wrote:

[...]

> > I think this patch series should be split
> > and sent to each sub-system instead of kbuild.
> 
> Yes definitely, the changes are big enough that not merging
> this through the subsystem trees is going to cause conflicts.

Makes sense! I'll collect the feedback here and then will be sending
stuff to the corresponding MLs with the reference to the original
commits which introduce Kbuild warnings.

> 
> Regards,
> 
> Hans

[...]

Thanks!
Olek
