Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 834DBEA273
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 18:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727324AbfJ3RZA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 13:25:00 -0400
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.81]:20940 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbfJ3RZA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 13:25:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1572456294;
        s=strato-dkim-0002; d=goldelico.com;
        h=To:References:Message-Id:Cc:Date:In-Reply-To:From:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=HxQ8LImbajVfHnvi6HR4za1A89vyuEJ5woLuz6S6thE=;
        b=gYaUiUSt8IILSOrV92GEBt6jbFcW0ZGIZoq/GfwNowX2XiDmxuQf1sL+e1636Druyt
        ZV8DEnogRIAb4S15M6u97keyiJq0GXXSzEaBgsROvaTrFcfMT2tmo/xD2ad4/nXARhYC
        QBEgwXvzXlUV4rISnRJbnaq6E38VERWJBJlhNVFx4eNCt7WqEq/LluEFJzh//Uc1n9hd
        4YHgqYEW7aNB5DbglAf8kgBoMKFQ3FnMcbbuDgNlGfXjsi8xLrEC4REbHtZKcMpHww0q
        VK/7egLMbf0ufKPBnoiYG1VbkUpoZ3t2A6T5uaizyBxKf2qQqfbXMbwnEhzUzSMPDkxN
        F6XQ==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMgPgp8VKxflSZ1P34KBj7wpz8NMGHPrpwDvG"
X-RZG-CLASS-ID: mo00
Received: from mbp-13-nikolaus.fritz.box
        by smtp.strato.de (RZmta 44.29.0 DYNA|AUTH)
        with ESMTPSA id L09db3v9UHOT5oz
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (curve secp521r1 with 521 ECDH bits, eq. 15360 bits RSA))
        (Client did not present a certificate);
        Wed, 30 Oct 2019 18:24:29 +0100 (CET)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: [PATCH v2 04/11] mmc: host: omap_hsmmc: add code for special init of wl1251 to get rid of pandora_wl1251_init_card
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <CAPDyKFp3EjTuCTj+HXhxf+Ssti0hW8eMDR-NrGYWDWSDmQz6Lw@mail.gmail.com>
Date:   Wed, 30 Oct 2019 18:24:28 +0100
Cc:     =?utf-8?Q?Beno=C3=AEt_Cousson?= <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@armlinux.org.uk>,
        Kalle Valo <kvalo@codeaurora.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        David Sterba <dsterba@suse.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Petr Mladek <pmladek@suse.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Yangtao Li <tiny.windzz@gmail.com>,
        Alexios Zavras <alexios.zavras@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Allison Randal <allison@lohutok.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-omap <linux-omap@vger.kernel.org>,
        DTML <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Discussions about the Letux Kernel 
        <letux-kernel@openphoenux.org>, kernel@pyra-handheld.com,
        "# 4.0+" <stable@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <607E3AE4-65BF-4003-86BE-C70646D53D09@goldelico.com>
References: <cover.1571510481.git.hns@goldelico.com> <0887d84402f796d1e7361261b88ec6057fbb0065.1571510481.git.hns@goldelico.com> <CAPDyKFp3EjTuCTj+HXhxf+Ssti0hW8eMDR-NrGYWDWSDmQz6Lw@mail.gmail.com>
To:     Ulf Hansson <ulf.hansson@linaro.org>
X-Mailer: Apple Mail (2.3124)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ulf,

> Am 30.10.2019 um 16:51 schrieb Ulf Hansson <ulf.hansson@linaro.org>:
>=20
>> +
>> +               np =3D of_get_compatible_child(np, "ti,wl1251");
>> +               if (np) {
>> +                       /*
>> +                        * We have TI wl1251 attached to MMC3. Pass =
this information to
>> +                        * SDIO core because it can't be probed by =
normal methods.
>> +                        */
>> +
>> +                       dev_info(host->dev, "found wl1251\n");
>> +                       card->quirks |=3D MMC_QUIRK_NONSTD_SDIO;
>> +                       card->cccr.wide_bus =3D 1;
>> +                       card->cis.vendor =3D 0x104c;
>> +                       card->cis.device =3D 0x9066;
>> +                       card->cis.blksize =3D 512;
>> +                       card->cis.max_dtr =3D 24000000;
>> +                       card->ocr =3D 0x80;
>=20
> These things should really be figured out by the mmc core during SDIO
> card initialization itself, not via the host ops ->init_card()
> callback. That is just poor hack, which in the long run should go
> away.

Yes, I agree.

But I am just the poor guy who is trying to fix really broken code with
as low effort as possible.

I don't even have a significant clue what this code is exactly doing and =
what
the magic values mean. They were setup by pandora_wl1251_init_card() in =
the
same way so that I have just moved the code here and make it called in =
(almost)
the same situation.

> Moreover, I think we should add a subnode to the host node in the DT,
> to describe the embedded SDIO card, rather than parsing the subnode
> for the SDIO func - as that seems wrong to me.

You mean a second subnode?

The wl1251 is the child node of the mmc node and describes the SDIO =
card.
We just check if it is a wl1251 or e.g. wl1837 or something else or even
no child.

> To add a subnode for the SDIO card, we already have a binding that I
> think we should extend. Please have a look at
> Documentation/devicetree/bindings/mmc/mmc-card.txt.
>=20
> If you want an example of how to implement this for your case, do a
> git grep "broken-hpi" in the driver/mmc/core/, I think it will tell
> you more of what I have in mind.

So while I agree that it should be improved in the long run, we should
IMHO fix the hack first (broken since v4.9!), even if it remains a hack
for now. Improving this part seems to be quite independent and focussed
on the mmc subsystem, while the other patches involve other subsystems.

Maybe should we make a REVISIT note in the code? Or add something to
the commit message about the idea how it should be done right?

>=20
>> +                       of_node_put(np);
>> +               }
>> +       }
>> }
>>=20
>> static void omap_hsmmc_enable_sdio_irq(struct mmc_host *mmc, int =
enable)
>> --
>> 2.19.1
>>=20
>=20
> Kind regards
> Uffe


BR and thanks,
Nikolaus

