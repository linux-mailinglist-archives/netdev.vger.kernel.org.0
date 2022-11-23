Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5276E636C82
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 22:41:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238131AbiKWVku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 16:40:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235322AbiKWVkp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 16:40:45 -0500
Received: from mout-p-101.mailbox.org (mout-p-101.mailbox.org [80.241.56.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E6189735E;
        Wed, 23 Nov 2022 13:40:44 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:b231:465::2])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-101.mailbox.org (Postfix) with ESMTPS id 4NHZLL5G3sz9sQr;
        Wed, 23 Nov 2022 22:40:42 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1669239642;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YvMbGVM8UsyxK4KwU0Sqfc4qSF4qFQ8ljJfXM0tvfss=;
        b=swjOGxjftULfsQq4diAhywSZWwadmoZsuSv0ef7JUDDIEaIYbMLJShktvMwHETZRpBDaLH
        L9Vm2HWubHAA2jmT6ypvFGZP9nP85OZRLBxmlmk/qz77UhEV7K/0nwIwf4dGjFtY/5F63w
        sx/Ye2pP8Mi3Q2G7NZT+QGRSrChpVqo65XjmaDzXaUBEMQb8CT4hFrmLVCKCcgo0EfwCoz
        zYmxJEIrVZvYf6WT5mdQYGImQIuKmmfXOsdapivP6uEv28Juwq2X4UqLXAdzWFckLZ7Fv+
        ZIGGmFbud8T/Al53gtr5/BrL5StzFOswQ8DJWEMdyyJbRsYSo2bLJZImCWMatw==
From:   Alexander Lobakin <alobakin@mailbox.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
        t=1669239640;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YvMbGVM8UsyxK4KwU0Sqfc4qSF4qFQ8ljJfXM0tvfss=;
        b=XtyxAUo0pKZz077FlCWd00N2bemX6W34yvDlxhhtfN7Ju1y620jT6nwYwpu7K+iR+zYtup
        It8hMemceFaV1cl1DCLdQmR++8KP+48sUtgLlz31ZPAnx2haW32JiQODXBVzGWyYFUsQbs
        X0mOaH+2kfmoGCVsY5+i0ilkOZmeXy51r6lrt/9LEwp5n64RK59ePn/nwqeoea+XbCjzWB
        mgajiIZIoQYMmacIbhF64CrFgx1a/eM1XoJOSnATadvNC0IqNDStuOQXWSbs7BExWzPYFd
        /AXpJOyy4sz1rseaRwvimcphHPAGP/N+UXsMGOsIbFchgvzyOZ4oDdjy/FANzg==
To:     Jakub Kicinski <kuba@kernel.org>
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
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        NXP Linux Team <linux-imx@nxp.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/18] treewide: fix object files shared between several modules
Date:   Wed, 23 Nov 2022 22:40:12 +0100
Message-Id: <20221123214012.60864-1-alobakin@mailbox.org>
In-Reply-To: <20221121115034.03fe007e@kernel.org>
References: <20221119225650.1044591-1-alobakin@pm.me> <20221121115034.03fe007e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
X-MBO-RS-ID: f34190de56c61cf8c1c
X-MBO-RS-META: ukkdci8ubhsqn3hfhfwb93cqix8fe97x
X-Rspamd-Queue-Id: 4NHZLL5G3sz9sQr
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Mon, 21 Nov 2022 11:50:34 -0800

> On Sat, 19 Nov 2022 23:03:57 +0000 Alexander Lobakin wrote:
> > Subject: [PATCH 00/18] treewide: fix object files shared between several modules
> 
> Could you repost the networking changes separately in v2?
> I'm not seeing any reason why this would have to be a treewide
> series when merging.

Yes, it will be split on a per-subsys basis. So this mostly is an
RFC, must've prefixed it <.<

> 
> > monotonic
> 
> monotonous, unless you mean steady progress ;)

Oh thanks, it was "monotonous" actually :D

Olek
