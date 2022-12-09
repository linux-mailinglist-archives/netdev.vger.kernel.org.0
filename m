Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59C06648820
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 19:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbiLISAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 13:00:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbiLISAx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 13:00:53 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E321A387F;
        Fri,  9 Dec 2022 10:00:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1670608851; x=1702144851;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FYIIjPPaT+opi3t9Wt73K/Go8ykk8lCqNsyxFpoAk8Q=;
  b=omMrKsiu/6/K8RAcrD1B24Zln7XkkJv2jaqRgnvC0vK+eYdB78kVgC8L
   zKVY7aoJLRKkzA1W/QqUwSltaZQsBxe1yng7uVYBeoJHsqRkCoh5spRc2
   qZx5uZDKymLHWgb2S3+ICY+7M2ClV/yJ4sX3CoGOGMRBIb3/NpG7wqTHV
   58Nsr7gbqpVspL7bLYmB286A5L40fC4GSWsQ5wFqWGV+iFHh+gYh1ORMY
   JcucK4EDfvRbrBO4Br3TAI6rWCwYRgA+1Ft3JL8rqddMDJXldtXRRWGBQ
   GykARM5AxnpFvaHNcBqQkxsVl/OvlKxgZDZ3RKIVUOj1uZSQcHRKVcVlV
   w==;
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="203343545"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Dec 2022 11:00:50 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 9 Dec 2022 11:00:50 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Fri, 9 Dec 2022 11:00:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qsue9EYbgi9hlgGDU3EkzA49YxJbxm8tIvYbqBGiE5ZXyatAUnUVS6oNg4SQvzdNDvYwhClBdljG9S1EwNjmRC6cBkuQmCXwQ5ToecKFfpLVkzfocnR3cAuNkRfSGnPceSgPqKj+1p2Y521YlzN3FkCNKrixDrZSCGfqk12yLlwMSTFw2HQo+L1qlSBdFFqb2XLrNLyTimbaDdD/Qjrz+P2QzS63whrl93EqsO7TqTS/jDyxSBr/yFLfQ9xFScigH4Ss9JDIgZ/p+d/kebWgLVnXogrEH7iHRyn4RpcehbWIY8mqOi8WvbkEoAbbuWb72/iFw5tPBIDMgIkmAaH5bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TqrAp8uwaopLDYPCgkSfZMIuNJoZhaJvDK5A456uZ5Y=;
 b=KcwiNi4IQ8Q56L/WARXfaWfHgMG1HVInN0L3G0I6HWeApp0Cs/Dg9r9hs+Gab6dhaKEX8cGbVL6NBEr5FI9FNo6r24Kpa+4LFSTeuI/EGqKh4y5KMRkt1q2vBlgclqXVSjPRexEsCHeiERpy1xfYysupVB08M3VBjkFtOE7/vye67M+5CfFH0E04eKwU52P46th0Kb5FMMLCyqmnLTb9acvUhtmKUs+0QfykGTZEmHdKjq446fXLPtkdfLYtkOzr6kHK2z6QjqysjqVtFb2KFrnvCV/DUimT6nX4aTzK2wf7d7VtS7/UvMXa56Jzbj77IgVbI2jM9BXHmF20yAjYmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TqrAp8uwaopLDYPCgkSfZMIuNJoZhaJvDK5A456uZ5Y=;
 b=iDnd1GBArg2oci48IDR2P8nBt4+Dgbs+4F7eULtmZxZKkJfENnaxW/v+1F90jro1vp126KOvvid6y6zmjCw4lQ5qZk05gC6SsZ6ts59nzwlpxhNSXyJE/gppFdxlTJEb6/ZqBVVDFlC4X5osZkPEFdn/NEv6l/e6AQyliliKujU=
Received: from MWHPR11MB1693.namprd11.prod.outlook.com (2603:10b6:300:2b::21)
 by DS0PR11MB7263.namprd11.prod.outlook.com (2603:10b6:8:13f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Fri, 9 Dec
 2022 18:00:48 +0000
Received: from MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::5928:21d9:268f:3481]) by MWHPR11MB1693.namprd11.prod.outlook.com
 ([fe80::5928:21d9:268f:3481%11]) with mapi id 15.20.5880.014; Fri, 9 Dec 2022
 18:00:48 +0000
From:   <Jerry.Ray@microchip.com>
To:     <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux@armlinux.org.uk>
Subject: RE: [PATCH net-next v4 2/2] dsa: lan9303: Migrate to PHYLINK
Thread-Topic: [PATCH net-next v4 2/2] dsa: lan9303: Migrate to PHYLINK
Thread-Index: AQHZCpOqSqz8vuOHP0ORvZVZ/YYyxq5kPdN1gAGdDQA=
Date:   Fri, 9 Dec 2022 18:00:47 +0000
Message-ID: <MWHPR11MB169364EFBC8FE61E0772A25BEF1C9@MWHPR11MB1693.namprd11.prod.outlook.com>
References: <20221207232828.7367-1-jerry.ray@microchip.com>
 <20221207232828.7367-1-jerry.ray@microchip.com>
 <20221207232828.7367-3-jerry.ray@microchip.com>
 <20221207232828.7367-3-jerry.ray@microchip.com>
 <20221208172105.4736qmzfckottfvm@skbuf>
In-Reply-To: <20221208172105.4736qmzfckottfvm@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MWHPR11MB1693:EE_|DS0PR11MB7263:EE_
x-ms-office365-filtering-correlation-id: fb19b9f5-0ae4-4527-ffd7-08dada0f4d2a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pJ33O3055wLgch4HweuWLnmW/ybFGfgwpp7GdPFBZXFT7dZuEPeHbe5iITuxaIhtvKkBw9x/mM4K5fHN7/LzOZgAmKskLhLXZdSt//G/H6GhiKsmp4AaqsCD+f5SDYAp53dtA6OC/UzadR2yCZIWQ/o3FqQE/LksjO0TCCxbY7kXJ2g5CNOAJEVAiCkzM4ZP/1uHeL67YxeH98AvuEb+VnsF2qwjw570540cdVAo7Eis0qz8EkEnRqHjb4llX3M6vGu/6RTQfFhMG6FPV9uOkP3rowIideHPC5rGm+D4dD47qcQmGmXVErBE31dn9q7EAsE7t4TKjUVEIa8LDfT/pno4jTOIcRbUErT/LkDQtWVDca97wLcQfvIC67Pz37T6y1t8u0r9r0Yxpwy/ajhAV5MPhW693lN0nZy0kF3kjLD2nNDN5Rw8dJpcGMJEoB4nGfkkFmlq4ik+SuLPg5hh1CNsIeexNnV73qE+vzGLQ2kjQPOlA5crGroGchVYM0CGr4ThcGBgvZgZrh986Tj4z4+DI7jFND2ZV9s4M/0XtpZ/X8g7YerllL7q3fBKWzE9yJ96oTu0H0AkMVVkTvLGRGQos25Y6go6fN4sIg/PRbp6XtUHE5hXWT6qVcPktf7CU5ooBSol7gVyqpUcYGeyHAznhYME8bkxMiDSQzK/ENevxm9Y2TIhUI2ieEksoNfY0AIXuGIlBifCLTfl/8UczQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1693.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(396003)(366004)(376002)(136003)(451199015)(316002)(54906003)(6916009)(66899015)(52536014)(8676002)(71200400001)(86362001)(478600001)(66946007)(41300700001)(83380400001)(38100700002)(76116006)(4326008)(66446008)(64756008)(7416002)(66556008)(33656002)(5660300002)(8936002)(2906002)(66476007)(122000001)(53546011)(9686003)(6506007)(7696005)(38070700005)(186003)(55016003)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2e1G6U0um8Q7p4NyeRrLmQJ8EX5VT2QVEZE35R5moDEXq8w57lnnSm8WBJbE?=
 =?us-ascii?Q?PBz9DMm2ghJDJUP8h8DHoSO1r8a2lbZ8rU/RgcQIWMbZEFuwJx1nstIgJkA3?=
 =?us-ascii?Q?mV0uUIoutsRAgzf8OduALqdiYytzpSiB7IWhSmdYKQM13bBDKjbiKtKF8/XX?=
 =?us-ascii?Q?MbyuAu7hHmU1Koh9RoCaGvswj5AwnrTak3MXVFf8EqgDWzddWApHabmy+xav?=
 =?us-ascii?Q?wVy8FQlTGspkW73XxgZnbPLgXbdXF6xetO9Kog0/tb+8gnDlO08VNpYh38DY?=
 =?us-ascii?Q?358A07H+TNlZXeytVpwcW9Ztt2/qyBHPeaCE7P4BgfLLITxmn7d4sdrTfM7l?=
 =?us-ascii?Q?MJaBIg0c5fb+sXCN6bh228VPXx/op2T+BE5e+/57tjnUq6CdFppaW1oLSeM+?=
 =?us-ascii?Q?eiLX82kf/BAMF1OQc5Q3itKFC2+5/rGVdtjO+D318bVFWDkt8AaEgpEZfiYT?=
 =?us-ascii?Q?LvX6/sZ/Bfs8YkEU89f4DrdE9yDA+DB3YJOWdgftuZfolAWVV+ZX4d/ogLko?=
 =?us-ascii?Q?Mr4xQmWQgkHTvOMpMWUEcL9gB4YKMTQ8HDWGKNR6u7lngyluJoomfQgA0Krf?=
 =?us-ascii?Q?UvCafQwF9aAAKaSLTnUIeZZsM4LFOyzAPos9259T5QaodIEatC7h0N9aiANe?=
 =?us-ascii?Q?sUYqpA7arXl47QZsmfhxjTdx2rS+nZrhA4BrcXO0bkmlqKSBD2ZwkQaTku4M?=
 =?us-ascii?Q?Mrx4PWlUCtFQj6u7vhUJ3yvW6uVuywSRv9Lv40VciDF1s/WexvCv9XafYq2h?=
 =?us-ascii?Q?XvV9KqwAWBYkBAyx4URMIfZKu4XN9xn8T9De+X9jVcNO3mQsVjs5XaIJelF+?=
 =?us-ascii?Q?jusaXrWdUJOFZiCHO/Q1X1j97ifbDx+Q7uGXH4TgXjYKNKRc7KwnKtt6xT4L?=
 =?us-ascii?Q?XpM1EBNQm8UyDtKanrG9uFfDEOCJCUVdoHNJ4rdMiRdmLxX8ijcZV5mOzloM?=
 =?us-ascii?Q?W6TQv6MFxtfO0b6sSNHrPlC82XFeuuIqmEaL8ufJ596x4VUspET2k52NW4/A?=
 =?us-ascii?Q?1uK8/D5Nzg2J0YjksVOMWiPbJ9USS/QxXs42Xvd131Um4/iqmGTt9pqc+oHR?=
 =?us-ascii?Q?5jDs140rlp3AqaheF8ArlWZy/47gViCCuNGWUqFiEQV3laqZ+JItgGXbXtBy?=
 =?us-ascii?Q?E7OfzogGu9CZi7/EO7MwI+s3DEbavahloktPF2jrbiL6cYQgh3nZ3U/LB4Xs?=
 =?us-ascii?Q?a1SrIeOXymo4zdczLAyWuK5eYE2JndFLnH3LkhOp8Ub1GrDn9rN4mj2MXoEk?=
 =?us-ascii?Q?SFYvyTFlx5Mf0n0gErRD3HK3NLeM3CtItBMGEwzv+LsiOJBoQiMfJy94oFkM?=
 =?us-ascii?Q?ILrKh+XA0YLbQANW9cx1kuC7YrPh6KYQzt0dLk2rZ12WbxzjLZBnT85PZtUG?=
 =?us-ascii?Q?AIhriS5hRaZo0clgvgJXGXr3TpasgEoYUTZ8c5SY9oN4ppfsQUx81F2HZg70?=
 =?us-ascii?Q?nePP9JfDL6hH4CnC/8hpnKvZSxR49OutuU3B0UGPKYaTZyWBF48dEv7H94bb?=
 =?us-ascii?Q?Z4jM/GAJ6+nwJrcdHO0irKSAjUkNsMux9s1e+6ea1uxIxfFHyb2EuVi5Mr+W?=
 =?us-ascii?Q?OhMh41S0PMSDIEI1YfuKYPWGmt4ocjwV/KK4B3qK?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1693.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb19b9f5-0ae4-4527-ffd7-08dada0f4d2a
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2022 18:00:47.9749
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HWDt4PJvz7TWabr+feLDXIBK2SagLdO8jR7htGsakkV8HrD59HxRNHc6XDhU+Loi7oPreuHAuPlTv7vs6VCShg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB7263
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir,

> We discourage code movement which also changes the code in question.
> Code movement should be just that, movement. If you don't like this
> check and want to replace it with dsa_port_is_cpu(), do so in a
> preparatory patch.
>=20

Understood.  Will do.


> As a reader, I find my intelligence insulted by self-evident comments suc=
h as this.
>=20
> Especially in contrast with the writes below to the MII_BMCR of the
> Virtual PHY, which would certainly deserve a bit more of an explanation,
> yet there is none there.
>=20

I struggle with the lack of comments I see in the kernel codebase. While
experts can look at the source code and understand it, I find I spend a
good deal of time chasing down macros - following data structures - and
reverse engineering an understanding of the purpose of something that could
have been explained in the maintained source.  In-line comments target the
unfamiliar reader as there are a lot of us out here and far too few experts=
.
But I do see your point and I'll try to do a better job on this.


> You actually had something good going in the previous patch. The action
> of disabling Turbo MII mode seems invariant of the negotiated link
> settings. So it would be better to do it just once, during switch setup.
> It would be good if you could add one more preparatory patch which does
> just that. Assuming, of course, that the reordering in register writes
> between LAN9303_VIRT_SPECIAL_CTRL and MII_BMCR will not cause a problem,
> and that the link still works.

I'll rework the patch series to break this change out.

Regards,
Jerry.

-----Original Message-----
From: Vladimir Oltean <olteanv@gmail.com>=20
Sent: Thursday, December 8, 2022 11:21 AM
To: Jerry Ray - C33025 <Jerry.Ray@microchip.com>
Cc: Andrew Lunn <andrew@lunn.ch>; Florian Fainelli <f.fainelli@gmail.com>; =
David S. Miller <davem@davemloft.net>; Eric Dumazet <edumazet@google.com>; =
Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; netdev@v=
ger.kernel.org; linux-kernel@vger.kernel.org; linux@armlinux.org.uk
Subject: Re: [PATCH net-next v4 2/2] dsa: lan9303: Migrate to PHYLINK

EXTERNAL EMAIL: Do not click links or open attachments unless you know the =
content is safe

On Wed, Dec 07, 2022 at 05:28:28PM -0600, Jerry Ray wrote:
> This patch replaces the adjust_link api with the phylink apis to provide
> equivalent functionality.
>
> The functionality from the adjust_link is moved to the phylink_mac_link_u=
p
> api.  The code being removed only affected the cpu port.
>
> Removes:
> .adjust_link
> Adds:
> .phylink_get_caps
> .phylink_mac_link_up
>
> Signed-off-by: Jerry Ray <jerry.ray@microchip.com>
> ---
> v3-> v4:
>   - Reworked the implementation to preserve the adjust_link functionality
>     by including it in the phylink_mac_link_up api.
> v2-> v3:
>   Added back in disabling Turbo Mode on the CPU MII interface.
>   Removed the unnecessary clearing of the phy supported interfaces.
> ---
>  drivers/net/dsa/lan9303-core.c | 123 +++++++++++++++++++++++----------
>  1 file changed, 86 insertions(+), 37 deletions(-)
>
> diff --git a/drivers/net/dsa/lan9303-core.c b/drivers/net/dsa/lan9303-cor=
e.c
> index d9f7b554a423..a800448c9433 100644
> --- a/drivers/net/dsa/lan9303-core.c
> +++ b/drivers/net/dsa/lan9303-core.c
> @@ -1047,42 +1047,6 @@ static int lan9303_phy_write(struct dsa_switch *ds=
, int phy, int regnum,
>       return chip->ops->phy_write(chip, phy, regnum, val);
>  }
>
> -static void lan9303_adjust_link(struct dsa_switch *ds, int port,
> -                             struct phy_device *phydev)
> -{
> -     struct lan9303 *chip =3D ds->priv;
> -     int ctl;
> -
> -     if (!phy_is_pseudo_fixed_link(phydev))
> -             return;

We discourage code movement which also changes the code in question.
Code movement should be just that, movement. If you don't like this
check and want to replace it with dsa_port_is_cpu(), do so in a
preparatory patch.

> -
> -     ctl =3D lan9303_phy_read(ds, port, MII_BMCR);
> -
> -     ctl &=3D ~BMCR_ANENABLE;
> -
> -     if (phydev->speed =3D=3D SPEED_100)
> -             ctl |=3D BMCR_SPEED100;
> -     else if (phydev->speed =3D=3D SPEED_10)
> -             ctl &=3D ~BMCR_SPEED100;
> -     else
> -             dev_err(ds->dev, "unsupported speed: %d\n", phydev->speed);
> -
> -     if (phydev->duplex =3D=3D DUPLEX_FULL)
> -             ctl |=3D BMCR_FULLDPLX;
> -     else
> -             ctl &=3D ~BMCR_FULLDPLX;
> -
> -     lan9303_phy_write(ds, port, MII_BMCR, ctl);
> -
> -     if (port =3D=3D chip->phy_addr_base) {
> -             /* Virtual Phy: Remove Turbo 200Mbit mode */
> -             lan9303_read(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, &ctl)=
;
> -
> -             ctl &=3D ~LAN9303_VIRT_SPECIAL_TURBO;
> -             regmap_write(chip->regmap, LAN9303_VIRT_SPECIAL_CTRL, ctl);
> -     }
> -}
> -
>  static int lan9303_port_enable(struct dsa_switch *ds, int port,
>                              struct phy_device *phy)
>  {
> @@ -1279,13 +1243,98 @@ static int lan9303_port_mdb_del(struct dsa_switch=
 *ds, int port,
>       return 0;
>  }
>
> +static void lan9303_phylink_get_caps(struct dsa_switch *ds, int port,
> +                                  struct phylink_config *config)
> +{
> +     struct lan9303 *chip =3D ds->priv;
> +
> +     dev_dbg(chip->dev, "%s(%d) entered.", __func__, port);
> +
> +     config->mac_capabilities =3D MAC_10 | MAC_100 | MAC_ASYM_PAUSE |
> +                                MAC_SYM_PAUSE;
> +
> +     if (dsa_is_cpu_port(ds, port)) {
> +             __set_bit(PHY_INTERFACE_MODE_RMII,
> +                       config->supported_interfaces);
> +             __set_bit(PHY_INTERFACE_MODE_MII,
> +                       config->supported_interfaces);
> +     } else {
> +             __set_bit(PHY_INTERFACE_MODE_INTERNAL,
> +                       config->supported_interfaces);
> +             /* Compatibility for phylib's default interface type when t=
he
> +              * phy-mode property is absent
> +              */
> +             __set_bit(PHY_INTERFACE_MODE_GMII,
> +                       config->supported_interfaces);
> +     }
> +
> +     /* This driver does not make use of the speed, duplex, pause or the
> +      * advertisement in its mac_config, so it is safe to mark this driv=
er
> +      * as non-legacy.
> +      */
> +     config->legacy_pre_march2020 =3D false;
> +}
> +
> +static void lan9303_phylink_mac_link_up(struct dsa_switch *ds, int port,
> +                                     unsigned int mode,
> +                                     phy_interface_t interface,
> +                                     struct phy_device *phydev, int spee=
d,
> +                                     int duplex, bool tx_pause,
> +                                     bool rx_pause)
> +{
> +     struct lan9303 *chip =3D ds->priv;
> +     u32 ctl;
> +     int ret;
> +
> +     dev_dbg(chip->dev, "%s(%d) entered - %s.", __func__, port,
> +             phy_modes(interface));
> +
> +     /* if this is not the cpu port, then simply return. */

As a reader, I find my intelligence insulted by self-evident comments such =
as this.

Especially in contrast with the writes below to the MII_BMCR of the
Virtual PHY, which would certainly deserve a bit more of an explanation,
yet there is none there.

> +     if (!dsa_port_is_cpu(dsa_to_port(ds, port)))
> +             return;
> +
> +     ctl =3D lan9303_phy_read(ds, port, MII_BMCR);
> +
> +     ctl &=3D ~BMCR_ANENABLE;
> +
> +     if (speed =3D=3D SPEED_100)
> +             ctl |=3D BMCR_SPEED100;
> +     else if (speed =3D=3D SPEED_10)
> +             ctl &=3D ~BMCR_SPEED100;
> +     else
> +             dev_err(ds->dev, "unsupported speed: %d\n", speed);
> +
> +     if (duplex =3D=3D DUPLEX_FULL)
> +             ctl |=3D BMCR_FULLDPLX;
> +     else
> +             ctl &=3D ~BMCR_FULLDPLX;
> +
> +     lan9303_phy_write(ds, port, MII_BMCR, ctl);
> +
> +     if (port =3D=3D chip->phy_addr_base) {
> +             /* Virtual Phy: Remove Turbo 200Mbit mode */
> +             ret =3D lan9303_read(chip->regmap, LAN9303_VIRT_SPECIAL_CTR=
L,
> +                                &ctl);
> +             if (ret)
> +                     return;
> +
> +             /* Clear the TURBO Mode bit if it was set. */
> +             if (ctl & LAN9303_VIRT_SPECIAL_TURBO) {
> +                     ctl &=3D ~LAN9303_VIRT_SPECIAL_TURBO;
> +                     regmap_write(chip->regmap, LAN9303_VIRT_SPECIAL_CTR=
L,
> +                                  ctl);
> +             }
> +     }

You actually had something good going in the previous patch. The action
of disabling Turbo MII mode seems invariant of the negotiated link
settings. So it would be better to do it just once, during switch setup.
It would be good if you could add one more preparatory patch which does
just that. Assuming, of course, that the reordering in register writes
between LAN9303_VIRT_SPECIAL_CTRL and MII_BMCR will not cause a problem,
and that the link still works.

> +}
> +
>  static const struct dsa_switch_ops lan9303_switch_ops =3D {
>       .get_tag_protocol       =3D lan9303_get_tag_protocol,
>       .setup                  =3D lan9303_setup,
>       .get_strings            =3D lan9303_get_strings,
>       .phy_read               =3D lan9303_phy_read,
>       .phy_write              =3D lan9303_phy_write,
> -     .adjust_link            =3D lan9303_adjust_link,
> +     .phylink_get_caps       =3D lan9303_phylink_get_caps,
> +     .phylink_mac_link_up    =3D lan9303_phylink_mac_link_up,
>       .get_ethtool_stats      =3D lan9303_get_ethtool_stats,
>       .get_sset_count         =3D lan9303_get_sset_count,
>       .port_enable            =3D lan9303_port_enable,
> --
> 2.17.1
>

