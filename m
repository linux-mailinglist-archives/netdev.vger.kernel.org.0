Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5F4050B9FB
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 16:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1448564AbiDVOYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 10:24:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1448333AbiDVOYO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 10:24:14 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC991CFCE
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 07:21:19 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id w4so11247972wrg.12
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 07:21:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=timebeat-app.20210112.gappssmtp.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Wxg8wAvTVjJFfin5zoWS3aVg9XeTLHhrTUk9id2daTE=;
        b=AkZJeH0DvaQjb7x9pECpuTrcz6mU9kAaz5QBQdUx5qG9fmQwzNHoBJ9jr2WEVi48bN
         Vziob9nmYbS3usZhOxTy7MuINB59REN7/E5aYaa4dlDG/+q4P3G0Es+ByyEMf3Jbq0eD
         9rWDmo2v7FlNjP+PQKmPxc3NZ9C1ijP9WZ1mIYB0srhWG0qr82UTkK7KjssTtuOqeQaL
         uhtSbdOKtdDRYjaDB6fxjv9N8zj/iitV448PoXZfhEGR9BLSdbNKJLGhunbmqObzykc4
         oXLer3BSfzFK1I41gbM5Foq/0exxX+1tGCd6+6bLMGGPE+dfisCPylVEbvnC8NdZVMqe
         ykdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=Wxg8wAvTVjJFfin5zoWS3aVg9XeTLHhrTUk9id2daTE=;
        b=51fBk2ESWPuuPk69HDYsAv5qOO6P2uzaQDLBxwn2WCAK6MLsULE/jXXojd3Pe/4fE/
         kXFjwdwVsj3VnlOZ6Mi6ubtIutk2ik0LWxhT7xf88IV48IuwbVORInoG7oiTQ8QrPAyh
         sXVzddJaOpU7LoJAyrAI8ZDN3XJIGIKcygCfq9ESYTUlggIH7vWAnBKr5duH9NpA4yvr
         7e1wBH2sITl7ly3IaltWSauCVcLgM1TMLOx6qhs7tQKObj7JAhZkX/xOAr0MrcMp2uxT
         m2vJl470CrQQowAsyNFFrjQ7HcB1vD2ZCGW1ReNXr5CwTvRujZn06dwBwJEfYHu5m2/S
         6nRw==
X-Gm-Message-State: AOAM532dkC1Rr7oNTxAj0iOL80bb159KXkZ1wfVP/a5nKuPh8Jvi7vsk
        cYQ/SZUVooWniBut55Xpyw6MSg==
X-Google-Smtp-Source: ABdhPJxGE9bFJ8DvuRhnFJUZS3fnfoXmZtLGfX6qjEThpEJb0idTTKBosys0G2NeGb3PdBneuoW3SQ==
X-Received: by 2002:a5d:444f:0:b0:20a:cd55:8c32 with SMTP id x15-20020a5d444f000000b0020acd558c32mr1457415wrr.586.1650637277472;
        Fri, 22 Apr 2022 07:21:17 -0700 (PDT)
Received: from smtpclient.apple ([95.175.197.5])
        by smtp.gmail.com with ESMTPSA id i6-20020a0560001ac600b0020a93f75030sm1867672wry.48.2022.04.22.07.21.16
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Apr 2022 07:21:17 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.80.82.1.1\))
Subject: [PATCH net-next] 1588 support on bcm54210pe
From:   Lasse Johnsen <lasse@timebeat.app>
In-Reply-To: <YmBc2E2eCPHMA7lR@lunn.ch>
Date:   Fri, 22 Apr 2022 15:21:16 +0100
Cc:     netdev@vger.kernel.org, richardcochran@gmail.com,
        Gordon Hollingworth <gordon@raspberrypi.com>,
        Ahmad Byagowi <clk@fb.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com,
        Florian Fainelli <f.fainelli@gmail.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <C6DCE6EC-926D-4EDF-AFE9-F949C0F55B7F@timebeat.app>
References: <928593CA-9CE9-4A54-B84A-9973126E026D@timebeat.app>
 <YmBc2E2eCPHMA7lR@lunn.ch>
To:     Andrew Lunn <andrew@lunn.ch>
X-Mailer: Apple Mail (2.3696.80.82.1.1)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NEUTRAL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

> On 20 Apr 2022, at 20:19, Andrew Lunn <andrew@lunn.ch> wrote:
>=20
> On Wed, Apr 20, 2022 at 03:03:26PM +0100, Lasse Johnsen wrote:
>> Hello,
>>=20
>>=20
>> The attached set of patches adds support for the IEEE1588 =
functionality on the BCM54210PE PHY using the Linux Kernel =
mii_timestamper interface. The BCM54210PE PHY can be found in the =
Raspberry PI Compute Module 4 and the work has been undertaken by =
Timebeat.app on behalf of Raspberry PI with help and support from the =
nice engineers at Broadcom.
>=20
> Hi Lasse
>=20
> There are a few process issues you should address.
>=20
> Please wrap your email at about 80 characters.
>=20
> Please take a read of
>=20
> https://www.kernel.org/doc/html/latest/process/submitting-patches.html
>=20
> and
>=20
> =
https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html#netd=
ev-faq
>=20
> It is a bit of a learning curve getting patches accepted, and you have
> to follow the processes defined in these documents.

I have read the documents, I understand about 10% of them and I am =
considering jumping off a tall building :-)

I=E2=80=99ve changed the subject of the email. How did I do?

>=20
>> arch/arm/configs/bcm2711_defconfig            |    1 +
>> arch/arm64/configs/bcm2711_defconfig          |    1 +
>=20
> You will need to split these changes up. defconfg changes go via the
> Broadcom maintainers. PHY driver changes go via netdev. You can
> initially post them as a series, but in the end you might need to send
> them to different people/lists.
>=20

Ok. I was asked by Florian to put the Broadcom maintainers in Cc so I =
will do this to begin with.

>> +obj-$(CONFIG_BCM54120PE_PHY)	+=3D bcm54210pe_ptp.o
>=20
> How specific is this code to the bcm54210pe? Should it work for any
> bcm54xxx PHY? You might want to name this file broadcom_ptp.c if it
> will work with any PHY supported by broadcom.c.

I am confident that this code is relevant exclusively to the BCM54210PE. =
It will not even work with the BCM54210, BCM54210S and BCM54210SE PHYs.

>=20
>> +static bool bcm54210pe_fetch_timestamp(u8 txrx, u8 message_type, u16 =
seq_id, struct bcm54210pe_private *private, u64 *timestamp)
>> +{
>> +	struct bcm54210pe_circular_buffer_item *item;=20
>> +	struct list_head *this, *next;
>> +
>> +	u8 index =3D (txrx * 4) + message_type;
>> +
>> +	if(index >=3D CIRCULAR_BUFFER_COUNT)
>> +	{
>> +		return false;
>> +	}
>=20
> Please run your code through ./scripts/checkpatch.pl. You will find
> the code has a number of code style issues which need cleaning up.

I am about to respond to Richard's mail with an amended set of patches =
which is much cleaner. checkpatch now complains only about a Signed-off =
line and asks if Maintainers needs updating because I=E2=80=99ve added a =
file (I guess it probably does).=20

>=20
>> +#if IS_ENABLED (CONFIG_BCM54120PE_PHY)
>> +{
>> +	.phy_id		=3D PHY_ID_BCM54213PE,
>> +	.phy_id_mask	=3D 0xffffffff,
>> +        .name           =3D "Broadcom BCM54210PE",
>> +        /* PHY_GBIT_FEATURES */
>> +        .config_init    =3D bcm54xx_config_init,
>> +        .ack_interrupt  =3D bcm_phy_ack_intr,
>> +        .config_intr    =3D bcm_phy_config_intr,
>> +	.probe		=3D bcm54210pe_probe,
>> +#elif
>> +{=20
>> 	.phy_id		=3D PHY_ID_BCM54213PE,
>> 	.phy_id_mask	=3D 0xffffffff,
>> 	.name		=3D "Broadcom BCM54213PE",
>> @@ -786,6 +804,7 @@ static struct phy_driver broadcom_drivers[] =3D {
>> 	.config_init	=3D bcm54xx_config_init,
>> 	.ack_interrupt	=3D bcm_phy_ack_intr,
>> 	.config_intr	=3D bcm_phy_config_intr,
>> +#endif
>=20
> Don't replace the existing entry, extend it with your new
> functionality.

Is what you propose possible? Isn=E2=80=99t the issue here that the two =
PHYs (54213PE and 54210PE) present themselves with the same phy ID? If =
there is a way to seperate them then I will need your instruction on how =
to do it.=20

>=20
> 	Andrew

All the best,

Lasse=
