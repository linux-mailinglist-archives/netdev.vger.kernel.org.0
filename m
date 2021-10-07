Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 538EC424F44
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 10:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240717AbhJGI3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 04:29:08 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:10004 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240564AbhJGI3H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 04:29:07 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1633595234; h=Content-Transfer-Encoding: Content-Type:
 MIME-Version: Message-ID: In-Reply-To: Date: References: Subject: Cc:
 To: From: Sender; bh=wI2s0bxPh2CPs/CNjvuA/9UBNxI8aMeMmsFnsc6CPxc=; b=jHwbVdOCtHKoX7jc6/kYpi3Qt6sNP4wgE5IuIemBpUtAAyl443j7TTNnYkNyxEX0DVIzZteL
 t27wwD3yHrPC9LfSVlMoW6iNFb/HKNh56Xn4i0ezfIo+7wzaFbP1bVM/qnwIs4rGYB02eq6c
 NEo6a7CZHpx/aaHiYpd9CtNlemE=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-east-1.postgun.com with SMTP id
 615eaf4ab8ab9916b3e9179f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Thu, 07 Oct 2021 08:26:50
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 471BEC4360D; Thu,  7 Oct 2021 08:26:49 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL
        autolearn=no autolearn_force=no version=3.4.0
Received: from tykki (tynnyri.adurom.net [51.15.11.48])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id DF4CAC4338F;
        Thu,  7 Oct 2021 08:26:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.codeaurora.org DF4CAC4338F
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     =?utf-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Pali =?utf-8?Q?Roh=C3=A1r?= <pali@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        DTML <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-mmc <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH v7 08/24] wfx: add bus_sdio.c
References: <20210920161136.2398632-1-Jerome.Pouiller@silabs.com>
        <149139701.nbvtKH4F0p@pc-42>
        <CAPDyKFr62Kykg3=9WiXAV8UToqjw8gj4t6bbM7pGQ+iGGQRLmg@mail.gmail.com>
        <4117481.h6P39bWmWk@pc-42>
Date:   Thu, 07 Oct 2021 11:26:42 +0300
In-Reply-To: <4117481.h6P39bWmWk@pc-42> (=?utf-8?B?IkrDqXLDtG1l?=
 Pouiller"'s message of "Wed,
        06 Oct 2021 17:42:23 +0200")
Message-ID: <87czohckal.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com> writes:

> On Wednesday 6 October 2021 17:02:07 CEST Ulf Hansson wrote:
>> On Tue, 5 Oct 2021 at 10:14, J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@=
silabs.com> wrote:
>> > On Friday 1 October 2021 17:23:16 CEST Ulf Hansson wrote:
>> > > On Thu, 30 Sept 2021 at 19:06, Pali Roh=C3=A1r <pali@kernel.org> wro=
te:
>> > > > On Thursday 30 September 2021 18:51:09 J=C3=A9r=C3=B4me Pouiller w=
rote:
>> > > > > On Thursday 30 September 2021 12:07:55 CEST Ulf Hansson wrote:
>> > > > > > On Mon, 20 Sept 2021 at 18:12, Jerome Pouiller
>> > > > > > <Jerome.Pouiller@silabs.com> wrote:
>> > > > > > >
>> > > > > > > From: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@silabs.com>
>> > > > > > >
>> > > > > > > Signed-off-by: J=C3=A9r=C3=B4me Pouiller <jerome.pouiller@si=
labs.com>
>> > > > > > > ---
>> > > > > > >  drivers/net/wireless/silabs/wfx/bus_sdio.c | 261 ++++++++++=
+++++++++++
>> > > > > > >  1 file changed, 261 insertions(+)
>> > > > > > >  create mode 100644 drivers/net/wireless/silabs/wfx/bus_sdio=
.c
>> > > > > > >
>> > > > > > > diff --git a/drivers/net/wireless/silabs/wfx/bus_sdio.c
>> > > > > > > b/drivers/net/wireless/silabs/wfx/bus_sdio.c
>> > > > > >
>> > > > > > [...]
>> > > > > >
>> > > > > > > +
>> > > > > > > +static int wfx_sdio_probe(struct sdio_func *func,
>> > > > > > > +                         const struct sdio_device_id *id)
>> > > > > > > +{
>> > > > > > > +       struct device_node *np =3D func->dev.of_node;
>> > > > > > > +       struct wfx_sdio_priv *bus;
>> > > > > > > +       int ret;
>> > > > > > > +
>> > > > > > > +       if (func->num !=3D 1) {
>> > > > > > > + dev_err(&func->dev, "SDIO function number is %d while
>> > > > > > > it should always be 1 (unsupported chip?)\n",
>> > > > > > > +                       func->num);
>> > > > > > > +               return -ENODEV;
>> > > > > > > +       }
>> > > > > > > +
>> > > > > > > +       bus =3D devm_kzalloc(&func->dev, sizeof(*bus), GFP_K=
ERNEL);
>> > > > > > > +       if (!bus)
>> > > > > > > +               return -ENOMEM;
>> > > > > > > +
>> > > > > > > +       if (!np || !of_match_node(wfx_sdio_of_match, np)) {
>> > > > > > > + dev_warn(&func->dev, "no compatible device found in
>> > > > > > > DT\n");
>> > > > > > > +               return -ENODEV;
>> > > > > > > +       }
>> > > > > > > +
>> > > > > > > +       bus->func =3D func;
>> > > > > > > +       bus->of_irq =3D irq_of_parse_and_map(np, 0);
>> > > > > > > +       sdio_set_drvdata(func, bus);
>> > > > > > > +       func->card->quirks |=3D MMC_QUIRK_LENIENT_FN0 |
>> > > > > > > +                             MMC_QUIRK_BLKSZ_FOR_BYTE_MODE |
>> > > > > > > +                             MMC_QUIRK_BROKEN_BYTE_MODE_512;
>> > > > > >
>> > > > > > I would rather see that you add an SDIO_FIXUP for the SDIO car=
d, to
>> > > > > > the sdio_fixup_methods[], in drivers/mmc/core/quirks.h, instea=
d of
>> > > > > > this.
>> > > > >
>> > > > > In the current patch, these quirks are applied only if the devic=
e appears
>> > > > > in the device tree (see the condition above). If I implement the=
m in
>> > > > > drivers/mmc/core/quirks.h they will be applied as soon as the de=
vice is
>> > > > > detected. Is it what we want?
>> > > > >
>> > > > > Note: we already have had a discussion about the strange VID/PID=
 declared
>> > > > > by this device:
>> > > > >   https://www.spinics.net/lists/netdev/msg692577.html
>> > > >
>> > > > Yes, vendor id 0x0000 is invalid per SDIO spec. So based on this v=
endor
>> > > > id, it is not possible to write any quirk in mmc/sdio generic code.
>> > > >
>> > > > Ulf, but maybe it could be possible to write quirk based on OF
>> > > > compatible string?
>> > >
>> > > Yes, that would be better in my opinion.
>> > >
>> > > We already have DT bindings to describe embedded SDIO cards (a subno=
de
>> > > to the mmc controller node), so we should be able to extend that I
>> > > think.
>> >
>> > So, this feature does not yet exist? Do you consider it is a blocker f=
or
>> > the current patch?
>>=20
>> Yes, sorry. I think we should avoid unnecessary hacks in SDIO func
>> drivers, especially those that deserve to be fixed in the mmc core.
>>=20
>> Moreover, we already support the similar thing for eMMC cards, plus
>> that most parts are already done for SDIO too.
>>=20
>> >
>> > To be honest, I don't really want to take over this change in mmc/core.
>>=20
>> I understand. Allow me a couple of days, then I can post a patch to
>> help you out.
>
> Great! Thank you. I apologize for the extra work due to this invalid
> vendor id.

BTW please escalate in your company how HORRIBLE it is that you
manufacture SDIO devices without proper device ids, and make sure that
all your future devices have officially assigned ids. I cannot stress
enough how important that is for the Linux community!

--=20
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatc=
hes
