Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF9EE692476
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 18:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232625AbjBJRcP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 12:32:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232400AbjBJRcO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 12:32:14 -0500
Received: from mout-p-201.mailbox.org (mout-p-201.mailbox.org [IPv6:2001:67c:2050:0:465::201])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC846749A4;
        Fri, 10 Feb 2023 09:32:11 -0800 (PST)
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-201.mailbox.org (Postfix) with ESMTPS id 4PD1532jVGz9sPx;
        Fri, 10 Feb 2023 18:32:07 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1676050327;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e1q9Bn/tVizaq5T7XksKPZ7pP+RRQCiC2aELxFyz/os=;
        b=aFqWh5jc9N8JQaOeAgyOMr+kWxxekmVF6I7sVAQo+eGFV0TSAyA+DtPcGC2n8gZG7JfGEm
        Dh3atXIkF7IQHIAi1zAc8I9Q4Mst5vELA4++at2mb5j9EBV3lrvhMGe3dXKXbursKqraTV
        Z7IATjXLVUxGte9UsKx0WmsBWCA7CXhaqHDdS9hgiWHU3HwGxiB1HtZo3Aac+AZBuM/h4q
        uubBn8vOLlznrMZv+C8Q4UCfc9iTtj6AFRpTyN5pIjbt0fg4YXF0fz08dhMExxftjCbsRf
        ijB5iNz8JJfJmFV73rTl4BW3uGsMMMKbgox1V+RGcjrWDYQ8gRviteS6mXz9rg==
From:   Alexander Lobakin <alobakin@mailbox.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1676050325;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=e1q9Bn/tVizaq5T7XksKPZ7pP+RRQCiC2aELxFyz/os=;
        b=FqcMaLHTwgzgr9LWI0L7hp0jlaCC9xYnzyrGFDsm2SGGed8ywbza02rfjnMgo3fNNCm+GA
        WbVK44sTlfpVzSk5IqNXfYnhFV8WWWlv8iOpeMzUWtC0zo55DFMHeoB04X62YRSY+JVrAy
        /SPuHudUhQGgTKpK0/2bLHUhzKgGIlaFAhFbYkVZxik5ajrAKm+Xgd6XDG//XQaZS2qTRY
        4xKuRzeFHmGVg2Jb5BXBDTq160g0esYRcuKCvxSLhGLqExpcCTCkLpl2Gl9B2MRMGZHP+7
        w/48stpD2DDXAHwlO8jA1cbnf8XpnEqRsHQaLXwSdEi+5bRDUWRETNzwGyDx8Q==
To:     linux-kbuild@vger.kernel.org
Cc:     Alexander Lobakin <alobakin@mailbox.org>,
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
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Daniel Scally <djrscally@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Brown <broonie@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        NXP Linux Team <linux-imx@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/18] treewide: fix object files shared between several modules
Date:   Fri, 10 Feb 2023 18:31:30 +0100
Message-Id: <20230210173130.74784-1-alobakin@mailbox.org>
In-Reply-To: <20221119225650.1044591-1-alobakin@pm.me>
References: <20221119225650.1044591-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-MBO-RS-ID: 02b5228def68ed81dbf
X-MBO-RS-META: x3et75jnzudh7uzzz7nrsioidnkeh96i
X-Rspamd-Queue-Id: 4PD1532jVGz9sPx
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexander Lobakin <alobakin@pm.me>
Date: Sat, 19 Nov 2022 23:03:57 +0000

> This is a follow-up to the series[0] that adds Kbuild warning if an
> object is linked into several modules (including vmlinux) in order
> to prevent hidden side effects from appearing.
> The original series, as well as this one, was inspired by the recent
> issue[1] with the ZSTD modules on a platform which has such sets of
> vmlinux cflags and module cflags so that objects built with those
> two even refuse to link with each other.
> The final goal is to forbid linking one object several times
> entirely.

Oh well,

Sorry for quite abandoning the series. A bit busy RN to work on the kernel
outside work. If someone wants to pick patches related to his driver and
send them separately, just how the Ocelot folks did, feel free to.
I'll get back to this one in approx 2-4 weeks.

>
> Patches 1-7 and 10-11 was runtime-tested by me. Pathes 8-9 and 12-18
> are compile-time tested only (compile, link, modpost), so I
> encourage the maintainers to review them carefully. At least the
> last one, for cpsw, most likely has issues :D
> Masahiro's patches are taken from his WIP tree[2], with the two last
> finished by me.

[...]

> --
> 2.38.1

Thanks,
Olek
