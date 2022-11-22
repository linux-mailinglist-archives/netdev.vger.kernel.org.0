Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4332D633501
	for <lists+netdev@lfdr.de>; Tue, 22 Nov 2022 07:00:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiKVGAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Nov 2022 01:00:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiKVGA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Nov 2022 01:00:29 -0500
Received: from conssluserg-03.nifty.com (conssluserg-03.nifty.com [210.131.2.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66DE31E8;
        Mon, 21 Nov 2022 22:00:27 -0800 (PST)
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171]) (authenticated)
        by conssluserg-03.nifty.com with ESMTP id 2AM605e4031335;
        Tue, 22 Nov 2022 15:00:06 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conssluserg-03.nifty.com 2AM605e4031335
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1669096806;
        bh=PyZIW+rJXpJC9QFi7cRxeAWYBzbIAT6tmqqq7AILiPo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=Ih4tke9QNgKCzXLdo2rmvAun8YSAQsePR7nVPxV+9M8W24yBZ2MHEjhslYv0pSRGI
         VC/KD8AbYCjwfIO7oDnrDEhXrIy039LPJHiWrljq7xAlX2CSVj0+ZMqs3dcv4oiW4Q
         aL5RIrwp/9qm4kLjsC3wGTyjUHLBtzjzs3B0Pv3AVDGnqQ2L77TMHGsVAxEGhNRS5E
         IqeJA496c7H0RdmmM831RkLUBGa6OMGNiNfnUFdb8WbvqdzNU/NhDELQDacW03qWse
         7EDQmayxda/K/MDmzjTY/K/WxD/1XTGTM6rX2QMrtA1/VkRjcpV9Rj9P8vC5bS6OFl
         3jMcvsQLYC7PQ==
X-Nifty-SrcIP: [209.85.167.171]
Received: by mail-oi1-f171.google.com with SMTP id n205so14867143oib.1;
        Mon, 21 Nov 2022 22:00:06 -0800 (PST)
X-Gm-Message-State: ANoB5pmnVolBjRNtpxFV3L8yZHq/ucFkROPFlUzxVdmHm7D865sd6jS5
        wtgGMvXp4ejBYJ6EMe67rz89AeYMsN0IGKYZjVU=
X-Google-Smtp-Source: AA0mqf6TVoNvonbiM6Z1RvZ7iYSva9PFEYE9Wl4nqoqyVuMX+kPOUqc129NrBwTfVwmkJ1W558O3KhZkv0A9L795iAI=
X-Received: by 2002:a05:6808:3009:b0:354:94a6:a721 with SMTP id
 ay9-20020a056808300900b0035494a6a721mr2132007oib.194.1669096804938; Mon, 21
 Nov 2022 22:00:04 -0800 (PST)
MIME-Version: 1.0
References: <20221119225650.1044591-1-alobakin@pm.me> <20221119225650.1044591-2-alobakin@pm.me>
 <68ceddec-7af9-983d-c8be-7e0dc109df88@ti.com>
In-Reply-To: <68ceddec-7af9-983d-c8be-7e0dc109df88@ti.com>
From:   Masahiro Yamada <masahiroy@kernel.org>
Date:   Tue, 22 Nov 2022 14:59:28 +0900
X-Gmail-Original-Message-ID: <CAK7LNAT_PuL0vuYaPxKZ3AfrojBC2tEXUA7Gqs2VuVuoTVoXmQ@mail.gmail.com>
Message-ID: <CAK7LNAT_PuL0vuYaPxKZ3AfrojBC2tEXUA7Gqs2VuVuoTVoXmQ@mail.gmail.com>
Subject: Re: [PATCH 01/18] block/rnbd: fix mixed module-builtin object
To:     Andrew Davis <afd@ti.com>
Cc:     Alexander Lobakin <alobakin@pm.me>, linux-kbuild@vger.kernel.org,
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
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_SOFTFAIL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 22, 2022 at 6:18 AM Andrew Davis <afd@ti.com> wrote:
>
> On 11/19/22 5:04 PM, Alexander Lobakin wrote:
> > From: Masahiro Yamada <masahiroy@kernel.org>
> >
> > With CONFIG_BLK_DEV_RNBD_CLIENT=m and CONFIG_BLK_DEV_RNBD_SERVER=y
> > (or vice versa), rnbd-common.o is linked to a module and also to
> > vmlinux even though CFLAGS are different between builtins and modules.
> >
> > This is the same situation as fixed by commit 637a642f5ca5 ("zstd:
> > Fixing mixed module-builtin objects").
> >
> > Turn rnbd_access_mode_str() into an inline function.
> >
>
> Why inline? All you should need is "static" to keep these internal to
> each compilation unit. Inline also bloats the object files when the
> function is called from multiple places. Let the compiler decide when
> to inline.
>
> Andrew


Since it is a header file.


In header files, "static inline" should be always used.
Never "static".


If a header is included from a C file and there is a function
that is not used from that C file,
"static" would emit -Wunused-function warning
(-Wunused-function is enabled by -Wall, which is the case
for the kernel build).





-- 
Best Regards
Masahiro Yamada
