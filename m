Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5423F6349A8
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 22:53:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234916AbiKVVx2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 16:53:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234767AbiKVVx1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 16:53:27 -0500
X-Greylist: delayed 530 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 22 Nov 2022 13:53:26 PST
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [IPv6:2001:67c:2050:0:465::103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E0AF1B9E0;
        Tue, 22 Nov 2022 13:53:25 -0800 (PST)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:b231:465::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4NGyTD0c6Vz9sQf;
        Tue, 22 Nov 2022 22:44:32 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1669153472;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=39N5ene9tAmFEvVg6TgCHu1wGZWNbFPFY6utdvj6ZFc=;
        b=pkksKF6Hl0OaoStHbY4IMDxKIlgwnaHVitMWu8fr4cOBf0iuI/QOK/w2sAerREfWDIgAvo
        PLOs1NIUQno76DNsK5oC5UC6X1eWnvl6EYSR8K3RcxTjZ69vSF75c7qVd7ce8SBkO3g/6J
        saX++n23n7stkfIQ5+5aDEFgbCWGfGAeygjlQfT9dr3aG0tZ9JPJ4dGRyMkyn0gd72hGbZ
        GOYC7YyrnQsg2G/dEkbMz/CQfDDduAaGDy7MBXTfSxmPDW7mcIJxQDuZL2xRhz0/Z6ZQAs
        TmVaNzTK0C2U8ZGnYyktIkn1f4OlXIwKj1bLVU6YthAii2bISnSETXyIkV+sTA==
From:   Alexander Lobakin <alobakin@mailbox.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1669153470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=39N5ene9tAmFEvVg6TgCHu1wGZWNbFPFY6utdvj6ZFc=;
        b=mh5jFPTkTqQOQ5KWablFFSe2AaO0Ix0KEBRg7fBJRaZrUbZFQf1bf2HtNKu3ltol3iGTAW
        UCUDP1H75wqHoAVPypVfhXWhjfKBM0YPSuVqipNsT3ePmzz9qaOKGwkAh4galOSKio02zP
        hFfHnVik+v5S7UETL8aye3in+rsK3BBBWMSDOT9LZGX+brCHWINU/5Cw/Xv6sDa1JUUFuQ
        5I1l80JhWkP8+H2Gt9aFjRHZDPeSUymqLseVS8qac1ou2YQSvKIWWXkCtLVWIgVXdp4GSa
        rWX8q/N4oeW6w0CCh4gezBFywnoAN6QWhA47Cmm5VSoe5qbqkaVkgaqgAtcjdA==
To:     Mark Brown <broonie@kernel.org>
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
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Daniel Scally <djrscally@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        NXP Linux Team <linux-imx@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/18] treewide: fix object files shared between several modules
Date:   Tue, 22 Nov 2022 22:37:54 +0100
Message-Id: <20221122213754.45474-1-alobakin@mailbox.org>
In-Reply-To: <Y3oWYhw9VZOANneu@sirena.org.uk>
References: <20221119225650.1044591-1-alobakin@pm.me> <Y3oWYhw9VZOANneu@sirena.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-RS-META: aa1jm95dg46x8drm3w7tkogdgi51quqe
X-MBO-RS-ID: 2cae87ace713e522bfe
X-Rspamd-Queue-Id: 4NGyTD0c6Vz9sQf
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Brown <broonie@kernel.org>
Date: Sun, 20 Nov 2022 11:58:26 +0000

> On Sat, Nov 19, 2022 at 11:03:57PM +0000, Alexander Lobakin wrote:
> 
> Your mails appear to be encrypted which isn't helping with
> review...

Oh I'm sorry. I gave ProtonMail one more chance. I had the same
issue with them at spring, they told me then that it's a super-pro
builtin feature that I can't disable :clownface: They promised to
"think on it" tho, so I thought maybe after half a year...
Nope. Ok, whatever. My workaround will be the same as Conor's, just
to change the provider lol.
Should be better now?

Thanks,
Olek
