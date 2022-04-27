Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E02C5112CE
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 09:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242273AbiD0Htt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 03:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359027AbiD0Htr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 03:49:47 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 712ED6374
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 00:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1651045595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=E5nXWyhmolZZoZ0qy+TdIOZYQ/Hs5bHK+HT6Q0hn8lg=;
        b=Uo6/shPxCwjIXV4XIc95ktN8RqQJ3/CfJHVWkqg6Hx3eib+Yln9cHRM8q8zczRNsvKaEL8
        4NsGRBfqTJEIBjfaIvpQSC5p4iApcwuijmx6Ekndt+CciowHyfOS/ao8ow7oCKz8nqaPIX
        uYKrwiw3lpDNVFAAa9vHU+RlSyCqXo0=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2057.outbound.protection.outlook.com [104.47.13.57]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-41-KDr1RDroMLOgeQppYjRWYA-1; Wed, 27 Apr 2022 09:46:32 +0200
X-MC-Unique: KDr1RDroMLOgeQppYjRWYA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BK7ocjOisJ/kcD3OtxfuRgUiuX6YdXUBuatuWBu0A7CrPhzUBtD2cCdQ4ifZ7U4pal06hfDh2nqIa22EXqNJ4bZ8ZIO0FwyCgE/iTHx0cm2umjl6pM/1v7tZnAthI73pFkvvZCU/65ZBECoMp1Cib0YGgucmxuj6hCUgTN+5ihDZsCAZDLXGVrYS4zWtT71zKYJk4OWbCYzK7a0CyS8WKBYQS+5Lyrr3e0snpnbrWsk1/jJVWblXgg9RDiGPM3KVucLjZzFtD8fgUfdA//9oiwNTvqfTzf9geeKsQyDvLzQckdKQ9zZtTzSJN/z611knzJwlA2w3zuA7wv4fcYpbeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kvLA7eClwHG2f4taYFNmkiB+ITbPG04rOYih4zF5vic=;
 b=k4WUCZerFsskCg5ddosRBhPqSr7Cmj4jAGjPXb1OhRM9yLtEW00sZUNZbH027JLCWFM83kk43ZnV3ejvKV7fV67ZKzhDJ5BgMS8EALWaL/h4J6oT1Ebngw363//yz3xJmvf2SlUZx2qH8cieLQ3x/GE8wlZVkHRTSXwmoakkkvbWO/yxi2FKm044dP0CdYm+RiNutOjImJyhyrjvuiHwGFIYzexs/EF+OpGM91UCpP7z2jrw310El5env++5jzUgddsYboYsjaznzegUPoxYMeHAkHA1d3b20pMUi7mEDFBn6UEK5HA3fGpbTcAj2LYEuvx0lD7o0dsAptYZ5sRXkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16) by VI1PR0402MB2893.eurprd04.prod.outlook.com
 (2603:10a6:800:ba::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Wed, 27 Apr
 2022 07:46:27 +0000
Received: from VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::8c82:19c5:ce96:491b]) by VI1PR0401MB2526.eurprd04.prod.outlook.com
 ([fe80::8c82:19c5:ce96:491b%4]) with mapi id 15.20.5186.021; Wed, 27 Apr 2022
 07:46:27 +0000
Message-ID: <a7add266-3e23-01a8-9880-b5dd008edba7@suse.com>
Date:   Wed, 27 Apr 2022 09:46:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH net-next 7/7] net: phy: smsc: Cope with hot-removal in
 interrupt handler
Content-Language: en-US
To:     Lukas Wunner <lukas@wunner.de>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Andre Edich <andre.edich@microchip.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Martyn Welch <martyn.welch@collabora.com>,
        Gabriel Hojda <ghojda@yo2urs.ro>,
        Christoph Fritz <chf.fritz@googlemail.com>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>,
        Philipp Rosenberger <p.rosenberger@kunbus.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>
References: <cover.1651037513.git.lukas@wunner.de>
 <62b8375ae008035bcaa85c348ea4aa80c519bb07.1651037513.git.lukas@wunner.de>
From:   Oliver Neukum <oneukum@suse.com>
In-Reply-To: <62b8375ae008035bcaa85c348ea4aa80c519bb07.1651037513.git.lukas@wunner.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: AM6P194CA0082.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:209:8f::23) To VI1PR0401MB2526.eurprd04.prod.outlook.com
 (2603:10a6:800:58::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ddd68d0d-da15-430b-4efb-08da28220951
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2893:EE_
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2893231739530F3937762D17C7FA9@VI1PR0402MB2893.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Qd9t3fvfHJUfDPrNOxWVSxNYS9Y5Etpj/t0XiD+FsEclsMLdORxkzOSXUtI3l5KXzo6LBewT2mWXFi/AEONXSGIGd5Trs4zxYVBTXd0YitMwm3P24sz8qbQYM0CGxjQ1/r+kpcL5OHYPkGHHsHUPiyi9c6sVCU1jKIHav29PoBvaWkI5YDfrtUdWlFR0KHVmlNb5lrO5+e13DIIAMQolGOkFfH4SEaZBDoqnSqkDlPBF4yve2CW/Zeqi/5pgSk+FLILe/Kkm+KzANatqiKTjme7dk276XHLG4dLaWm0ejpokf7VsOvYVZFiwRUfXWq+0eDe6U7FqCU8xHo7t1XXAx1Y2ngWDaPMjP/LHC5NvTk9qFFISw2b05JJVM+oScVQnfNpseHWhBnGYZPsAkoqi/5nhNNP0E0S2RbVLDkRFrYObNpPUXR74Dv8v8+xa+vNoHgIZDpxUG5EbCilU7+Oge/f1nW8ocGCKkCMedkv1Mlt1cgb+rna8DB7MMqbvbr2keQXDmV4H6LR/43JwR+KWBAi5NLQrxk0BpGwNM9K+1XTSGEKTfm8TYkoE7qaSoVFsUpMo/RmO4zjyak7TxswDyI5CvigaIzFbNRKh/22dl+Jj5MV/qGO/54mlIlfd1lTVyWnRpG2fVk+J6O1Fh65VIOtebeBuc7n/0RX+jU3iB/gfLsdFQmK/IwfyC4SF2GLAaEgFbnpxx3/H1l66GV8KrgxQMhOWBs/TB0Fu98hAv2o0G61sIunIaUxHRPMaVL2Y
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0401MB2526.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(31696002)(83380400001)(86362001)(6506007)(2906002)(53546011)(6512007)(8936002)(5660300002)(66946007)(4326008)(66556008)(66476007)(2616005)(7416002)(8676002)(186003)(36756003)(31686004)(508600001)(54906003)(6486002)(110136005)(38100700002)(6666004)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 2
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lJL2KPkCjxBFXyl0Fgpqr9T8/pZVPbe+sivoch5cDk/argUvTYQ/LbuxWPrk?=
 =?us-ascii?Q?NfUCqykFEYcRHliiosLCgvjNsTOe5lJaOwymnoKbpx662yiK1GaN3WnW+zkZ?=
 =?us-ascii?Q?71Xg076sVYhEkFlp/EEKAHKwFl53bj6oLR5kh8TOoeW99d1dA4C29bFiYcsu?=
 =?us-ascii?Q?K5G533SpeODxcbPo/yn6RRY3YaCjVzTxcABlQYuWXMLgB+urFkjW7EwmIaex?=
 =?us-ascii?Q?ibuZb8/EzdeDTHqj5V9CM9Gz7gDHNLPD3Dy8e3KTbzNorjTR3mLagpuKIhNC?=
 =?us-ascii?Q?fKzpShBWemIVaaR9XA2nYxraEJWsMj4ysEGujh2Ispu/xXrIoQVPkTcVHCyy?=
 =?us-ascii?Q?GdcAwt56D/I5i7TJ0IaPJGgkUHE8+iqgQmq3AF9cDG1l8QuC+ATcOdnTdMZX?=
 =?us-ascii?Q?1ujAn77MO13X6XOGcbz8Lb5dNMlNZiXbq8IhyTK81labM2XYK5956tXqCdra?=
 =?us-ascii?Q?Wv90bbi+13POv5/wqeCKyxcYRmpJTnK40PzN2orgYiF/ZknJ2ZCL0CGuoLRK?=
 =?us-ascii?Q?KUpTUOB5xIBHvVxJg2LNYOdQxDGDcCcg2KuiDSLPdzlELfLM3dqrt1kIhMu7?=
 =?us-ascii?Q?bkI0+bAfEyK+Gw86HN5OmqkXZ5BhF3AAld1GaVAn/X/b3oSlS8qk2fibGMcP?=
 =?us-ascii?Q?4s+IlEnTqzXNrQkXl3kLGZUoQNH/P+ZF6/BvArxlmVO+dM3q35KKElAuoAPm?=
 =?us-ascii?Q?9+aJdg9LXAqMYp+UVtIeI2P1vw1wZ3uNVFkM01wp87TDgBBJWIZURRs/xUhk?=
 =?us-ascii?Q?OX/yW8mIiC+VpUmWHQL3M/FTDAouRtEfi1c5fevBgWhR1oiA3g3rAUvnE6RH?=
 =?us-ascii?Q?5enK95dF9fL8EQ18aRy7sbPC4rERo7cOFRf7+gRNNn2L1wRwb1KnXpIVUB7N?=
 =?us-ascii?Q?/L/MVvgNdRklWrfApAFp0v3IiRj6/Odm3thvoZOl5aKbExERKlEzWeFyGRQj?=
 =?us-ascii?Q?wHb3bt74NEYJw0eoj/ZagbksmQkm4tDUfa+6OgpjHC+qdNMOzlCFgNCilf/q?=
 =?us-ascii?Q?L9dV95xl2ezuK5C2NK/PXCINuF2atK8ER0kr7eRmW2dMckf9pSHz5bDENTz4?=
 =?us-ascii?Q?4NMb3i3NejaJUyCDfSbsdVZEcamx50aG9lZoh0kRqFyGkai5EsVYOY6sqBbM?=
 =?us-ascii?Q?R5j9YZdpifnKP64aXZrdaohK3EIt8WY2oyilpCtay8T1uoTmN1oUoxxgbV5x?=
 =?us-ascii?Q?Ibe86g+5JO8k6yUo1v0hr27SsIUOtBCHv35JaoB8QDseEt6e6GEf2QHeCW9v?=
 =?us-ascii?Q?eUMBHzdAf3/pUrrVbTWD+vV0QkBN2/e/kMpESj9vn/2zDtZu48egtGbsuUdg?=
 =?us-ascii?Q?yfS7aY0Iy37XcY+0zCBRfmtD8O6TqH4hGPvDbdV+5leb1YQY0Kdnf+ovjUQH?=
 =?us-ascii?Q?bAiOGrxxcBtaghBD0OHPJq3e0bKVZIHyHezjMNdEQhMSoJDFQUoNSo4Uq3aj?=
 =?us-ascii?Q?4Zsepj568R/lXuRdrghCDctldhrLY6AjP9tXp7kRyzU6wvhlSk9RLTyaOEF5?=
 =?us-ascii?Q?zmvr3ZEFE/SkLxR3JAf5ahIGjJOLuedFQJ12mpawzyebR/pwfwe9UD7JWtmc?=
 =?us-ascii?Q?Xz7ryYME8dgLf9/c3nURu6eMzKHa3R7aZFyblPl02TBhHiezDPM4cr/YJ+dj?=
 =?us-ascii?Q?yJOj2lIt37QF637Cw2yN/iEz1VuV5gW9MI8IN0ayxUd+ASo7F4XJoOPmJFv/?=
 =?us-ascii?Q?KkElYDao6JWhCK93Zm2PJo8N1psVVciS66cwCCy10Q5DkkQGnAeAePWH4sq9?=
 =?us-ascii?Q?dI+k2MalHbNdw6eEqk9ybprRLY9QAAYqhAEsyjkqbqpAvg8TTAGRyEikUENp?=
X-MS-Exchange-AntiSpam-MessageData-1: MN7RQSLpsrY6Kg==
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ddd68d0d-da15-430b-4efb-08da28220951
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0401MB2526.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Apr 2022 07:46:27.8075
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hevSdfXPaqqUsO4u4CUwdtKcf8zO3uDKSnZ/vtnmifNEIGldh5JefDHZgTpHibq5y+cvVcevPIu3XxEz5XFj3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2893
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 27.04.22 07:48, Lukas Wunner wrote:
> If reading the Interrupt Source Flag register fails with -ENODEV, then
> the PHY has been hot-removed and the correct response is to bail out
> instead of throwing a WARN splat and attempting to suspend the PHY.
> The PHY should be stopped in due course anyway as the kernel
> asynchronously tears down the device.
>
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> ---
>  drivers/net/phy/smsc.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
> index a521d48b22a7..35bff7fd234c 100644
> --- a/drivers/net/phy/smsc.c
> +++ b/drivers/net/phy/smsc.c
> @@ -91,7 +91,9 @@ static irqreturn_t smsc_phy_handle_interrupt(struct phy=
_device *phydev)
> =20
>  	irq_status =3D phy_read(phydev, MII_LAN83C185_ISF);
>  	if (irq_status < 0) {
> -		phy_error(phydev);
> +		if (irq_status !=3D -ENODEV)
> +			phy_error(phydev);
> +
>  		return IRQ_NONE;
>  	}
> =20
Hi,

picking a small nit, if you get ENODEV, you have no idea whether the irq
was caused
by the phy. Strictly speaking you should return IRQ_HANDLED in that case.

=C2=A0=C2=A0=C2=A0 Regards
=C2=A0=C2=A0=C2=A0 =C2=A0=C2=A0=C2=A0 Oliver

