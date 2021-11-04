Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08EE9445150
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 10:46:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbhKDJsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 05:48:42 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:42484 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230057AbhKDJsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 05:48:41 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1A40atdc015136;
        Thu, 4 Nov 2021 02:45:55 -0700
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3c45461vt1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 04 Nov 2021 02:45:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PB4wNTo9viuPZHwmTYBRyHtT1Cue9HjbEPTNt1dBbvpON9oY6lb9KhCX5HN0/akfukxXOebX9mlCPtsGznT6MA0c2rXQXEMdTyeDfARjqmQXOuRtjFcCWvWJrOT8NbLOUyvUCfEWUA31PgzGw+3KWgS9iR4OuxLssueqcTKYFqysnRP7hktPD/ZFlCEE1nZSCe1iK+Sdz9BysTmQLN47yFgbxZPZx8K9hLbaE+ACH70pVcrETPwhcst9cOtaMiLhPZIXpnjFu9wdTwnWLhochZ/fSovnWUOGz0vlkn0OZ9OGS5ZOk4Crmm5Rfdnz121sn9oOT8l+9kB7e5LUT5RoYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MfU5707TIg4fI+QUQj9wi5IeUaa22ifQFI9kPzpXHhI=;
 b=HIi5XyZ82g30El1p053LfDMuPLqLfb9YzRifKKlmNuNTaurp8YGnbiCUvlAtS8RAox9i7JTZs03dDPRSImaFC8Y5FU/QxVNS6mQ0zt8EFDAbfd1yFzCcEOzsrPCvGtd/2rI4crta+CfrPJcD9eatoe3cL3bgUnZyCEXhQT3C4vWO9gd1nVdU10Orik1RuLTcBYqInBwvjtB4k5/dpvXD7OJR5fJAtIG4YYRXKVYH4Wxzo9Vtik0rNtAa0lwtPPd22Wwt+E4Gyx7h9i4FsOiMwOzGGHuT1LTID2O5HwF82hlNn527JNwlahVBj615tz7HP1vXA+A7DzIRIdHMsSq5Fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MfU5707TIg4fI+QUQj9wi5IeUaa22ifQFI9kPzpXHhI=;
 b=iWhBvwnfCSIUfR/6OE1XqCe3EVxHsHbKAs4S7jOsUefE4Y53LGtTkZahRsw2kcMIbAZTvJSYArN8/3MIQ3NhisKWUNzUdscMYqu/HFPhIJs5kTaL4zZSpJ7H3FeKXwDpklUrwmU/wG1u0PkN+HE4LuYzBcfmLH5Cj9nWFSMf8Ag=
Received: from SJ0PR18MB4009.namprd18.prod.outlook.com (2603:10b6:a03:2eb::24)
 by BYAPR18MB2536.namprd18.prod.outlook.com (2603:10b6:a03:136::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.13; Thu, 4 Nov
 2021 09:45:53 +0000
Received: from SJ0PR18MB4009.namprd18.prod.outlook.com
 ([fe80::919c:1891:e266:2502]) by SJ0PR18MB4009.namprd18.prod.outlook.com
 ([fe80::919c:1891:e266:2502%9]) with mapi id 15.20.4649.022; Thu, 4 Nov 2021
 09:45:53 +0000
From:   "Volodymyr Mytnyk [C]" <vmytnyk@marvell.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
CC:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        "Taras Chornyi [C]" <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Vadym Kochan [C]" <vkochan@marvell.com>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net v2] net: marvell: prestera: fix hw structure laid out
Thread-Topic: [PATCH net v2] net: marvell: prestera: fix hw structure laid out
Thread-Index: AQHX0WDCeRJs9Ntq20Ox8jGuZZna3Q==
Date:   Thu, 4 Nov 2021 09:45:53 +0000
Message-ID: <SJ0PR18MB4009205EFD48348D95BDDB65B28D9@SJ0PR18MB4009.namprd18.prod.outlook.com>
References: <1635933244-6553-1-git-send-email-volodymyr.mytnyk@plvision.eu>
 <CAMuHMdU9jRtsQhHHVDrJ8ZBLO1bSOuEo-haJ2PwMcYmMfnOXgA@mail.gmail.com>
In-Reply-To: <CAMuHMdU9jRtsQhHHVDrJ8ZBLO1bSOuEo-haJ2PwMcYmMfnOXgA@mail.gmail.com>
Accept-Language: en-GB, uk-UA, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 66230d7a-e5c9-9174-0ec7-0e12d913ce77
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 70f9ce46-0a4d-4d97-9fc8-08d99f77e4a6
x-ms-traffictypediagnostic: BYAPR18MB2536:
x-ld-processed: 70e1fb47-1155-421d-87fc-2e58f638b6e0,ExtAddr
x-microsoft-antispam-prvs: <BYAPR18MB25366FA8BFC3874E8D9F0781B28D9@BYAPR18MB2536.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:194;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h2EWDxlaCJIlduwIotV28hxxejBCs2GLr/wcbemU/mda+X5M0Y1TOL5rejIoSObZfx+mnZDBzA3SxG2O/87Q9W5bmfNW+nUz5cKx0lEw3ks6C0NsSh+tDXY/lOoTSncj5X9d6PUHKAhMDewVAG0gsXu3Q25LflbEBaiPBIPgEc5+0IvNVjYGrcgMbbXF2/9J5F1tHGmuXSmRBLP3VyKd8IEGJkwh7/CmOQ58daC4DbudFDzSLAiGIWQIKUjrYh9d88KxRcxujP1VJDsmqp1hVSYM1vGX8x4L0Te69Js0ZqQ87Ln9JKvBlWPFAw6uF6pgncJyCfbCsbO4sPVRBr0hMRCq3c92irQExEyK1GRglAUeaCDn+sEmwFeg+4ng2npSPLVj9MpgER8dLzMq/z5PBLMkNb0dMU2WMm0TFnrvN/PweiA7TZ1Q2NtYB4Vb3ivGMbvq3zpTogsL9VpCHUHJub3OZsiQpSHw+mWDVzXy4ax7K5tKJgP6OIXSLasx/IEfcIhVxYpejY+6Pr5++TrWZ3U4bXaKDZGPAcRT93mzESQReI5Phot5S61/JFkbZgm5qQPKdrgFPf1nmvcZ41tBCPZvh9q9KuGJQDDp0FNMaOMyy2DinZK/STt8QuYy7HmO4F0HPoW6cYav3gU5t8J9KAURyj9RgVHYXxlXwmUUGhH3RG3PyCROYGxgIIiq5TY+BBXYL9Caiu+YbIgxkU5tRWrKx3MqvLbFYjhmUDkIdkh9iYpTzJVKOnWgzKHYcU245P5dCOt9r62wXzTsRaZAlAaLvBp6+of0Ucap7mqrAyg=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB4009.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(9686003)(55016002)(66556008)(7696005)(64756008)(66946007)(122000001)(66446008)(86362001)(38100700002)(2906002)(6506007)(316002)(6916009)(53546011)(966005)(5660300002)(508600001)(54906003)(4326008)(38070700005)(8676002)(8936002)(71200400001)(66476007)(76116006)(26005)(52536014)(186003)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?gO9L9cyU3p87PfWit5oUpxqIpKiW/k0hCI8MdGE+ovF2Me7k107MM6sAxn?=
 =?iso-8859-1?Q?oSxPZZSP6sBgsMnMkjNOtT2UL1NBFciCg9LMWChHU07cwIioQQYQpCYriL?=
 =?iso-8859-1?Q?4eJG4igICndK1rDFjn0beu9Jt2zVkGf1T7MzNWsFFmQhB/zlnI1DAUUsrF?=
 =?iso-8859-1?Q?MSytkLkkBwoXGepu7DkJRCQr/vc6hvLtkjE4LoE3DRFNc0Y7cHzO6fIUoD?=
 =?iso-8859-1?Q?c5hq4plxu0mjqoR0FwXmLrmjPnYGNSntDKBNrqIB/MMjCQ1MJsj+p3f9qy?=
 =?iso-8859-1?Q?INfyPsvNSzjP9rZEpaSX8d3rK6aqFCZrlqkuQUSx9RC5x12ntbwUNLjtzv?=
 =?iso-8859-1?Q?/0Cn69oat1j+Un4/ebWYToFmYnTZVH9KH+qM3PQIB2gQZseoDuvC71wde+?=
 =?iso-8859-1?Q?nVLMWuggvRJH57S/0bFuMUUd2tpTvq1htVlm90sNtZsiyV/S3yp4ssaqR8?=
 =?iso-8859-1?Q?oD8fVm7vNQFPcrEQj9U6aQDmCZddGyjZTak1y/ewQbvJNYd/ZgO1raR6fk?=
 =?iso-8859-1?Q?ORsbx9YI0wy3VhgCVo3mjSlF++/H+fgdsahyKjr1q/u1GnP61tHSnW4m3i?=
 =?iso-8859-1?Q?RXKv/BUe0YJLnWrH+yvTnGHjblnB9FDBRYNUz+OQDcd3kj+yDWEX+CGozK?=
 =?iso-8859-1?Q?7mOvlxVMRWzgLOEzJhSBSM6r2gGMXEo1bKUyO4jrcDbKh8hDHrwtYzLwUE?=
 =?iso-8859-1?Q?PuuciuIhYrtGP5c0iIOcpXzVqZPocnGYM7mnSIiLVRLaUavYsZqfqdkx/9?=
 =?iso-8859-1?Q?nDnzbrLl1TJtY1UYQXoixnXkMITjRyk8RnRQmt+9gOBveR3ccXY+2Qhw2x?=
 =?iso-8859-1?Q?iXzGdBAdaq9xIE1+VQ/awe+FEMpA57pZXmrkwnFaguxmKB20tTMZJKz3BF?=
 =?iso-8859-1?Q?Vnvret8ID5nplj+bDLwEseGegE2tNFvi1h3Ni5TPk2KBPN9bLzeFIqro1Y?=
 =?iso-8859-1?Q?lB17cRMmbGVoJkX4Flp3MHHOVpxa8BByZer7tGVRhhx7jotWeDuOK6ECTj?=
 =?iso-8859-1?Q?CEBU1CVBKVPIlgX98t9JS7wyejNFNB1Nb5eX94R4XrEIEkIH5sJexaobrY?=
 =?iso-8859-1?Q?p0vlVY0DNdkVqDzlC4+CjSfb9SYeJ2cKD6kxNVJqX8/9BqTRWsYBFXAuMc?=
 =?iso-8859-1?Q?iQtzg+kCFeWyepXt3aBjeLkG81/2dQooA31e7/T7kPZQRq3K3m2o1YDyXV?=
 =?iso-8859-1?Q?Q9RrOnvVUys56TuRiFsQwL3WwXAMGi6yrmhLZscbz0AzSpnjrYKjXSA3ll?=
 =?iso-8859-1?Q?9CEXgKaztL8Wz+HToi+PcrSTVtSiBLhav0v7y/TvTn9JmkFqZK2NzZiOOl?=
 =?iso-8859-1?Q?Vbfolt3Y66Ny4m69oeO9VJXCqXQR24dZSJXtVzjcQ/HPeiBVoRc1y4d77F?=
 =?iso-8859-1?Q?hzxnJ4ppVQ+FsF246OLpGPMgQFAiGvtJ+6iyNEHPkETmt6EQgrsmWEF+nx?=
 =?iso-8859-1?Q?WaJzgcoZhT8nBBjQ6q8rsSIiSm45LIMQtww94SsKMJMMXokrDtbm9RD75Q?=
 =?iso-8859-1?Q?iBBiximfnCV4LLW9QQmWKamtGv/k4tIEiSx1WbKf1ejC1HgxQJA18Ni+bD?=
 =?iso-8859-1?Q?IoYpgQbPkGxe7UEWxXv6snChTRw+2fHh7FgT3GHxx7W4Zj0oSG9TnZZB+F?=
 =?iso-8859-1?Q?w1tQ/Yikj14jppp3ux0miP59wIy5v8ypeoWVpV613kjW33Oshm3CGSFA?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB4009.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70f9ce46-0a4d-4d97-9fc8-08d99f77e4a6
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2021 09:45:53.3624
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xuw29tg9b/olJK+7NOhV4VGzUipdDspFmXINnlNNOq4MIkqDBIOCaCrMyKI7B7WJK4XKijer8/OfEDA6bqbApw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2536
X-Proofpoint-ORIG-GUID: Ji2zy2Z8DSFD0U9FWmpqatotYhoxYRMU
X-Proofpoint-GUID: Ji2zy2Z8DSFD0U9FWmpqatotYhoxYRMU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-04_03,2021-11-03_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Wed, Nov 3, 2021 at 10:56 AM Volodymyr Mytnyk=0A=
> <volodymyr.mytnyk@plvision.eu> wrote:=0A=
> > From: Volodymyr Mytnyk <vmytnyk@marvell.com>=0A=
> >=0A=
> > - fix structure laid out discussed in:=0A=
> >=A0=A0=A0=A0 [PATCH net-next v4] net: marvell: prestera: add firmware v4=
.0 support=0A=
> >=A0=A0=A0=A0 https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.=
spinics.net_lists_kernel_msg4127689.html&d=3DDwIBaQ&c=3DnKjWec2b6R0mOyPaz7x=
tfQ&r=3DY41pILcavAE6E85lMlyXdQBpY03LUi5-euLmDcLBBRw&m=3DMggFlhvEsV0dikgTUWW=
hK5i05HFJvv2BF0EdMIAghqSI92og-BAfZXe2Wm82FjG7&s=3DKkA8BuuYlG-6UWpaKKvGkvVRb=
hyoKnSNnftLBCYELDE&e=3D =0A=
> >=0A=
> > - fix review comments discussed in:=0A=
> >=A0=A0=A0=A0 [PATCH] [-next] net: marvell: prestera: Add explicit paddin=
g=0A=
> >=A0=A0=A0=A0 https://urldefense.proofpoint.com/v2/url?u=3Dhttps-3A__www.=
spinics.net_lists_kernel_msg4130293.html&d=3DDwIBaQ&c=3DnKjWec2b6R0mOyPaz7x=
tfQ&r=3DY41pILcavAE6E85lMlyXdQBpY03LUi5-euLmDcLBBRw&m=3DMggFlhvEsV0dikgTUWW=
hK5i05HFJvv2BF0EdMIAghqSI92og-BAfZXe2Wm82FjG7&s=3DHs1u5qLhVlePG9KiNdOJiDpLT=
F200_9hn0gL9WLRJUA&e=3D =0A=
> >=0A=
> > - fix patchwork issues=0A=
> > - rebase on net master=0A=
> >=0A=
> > Reported-by: kernel test robot <lkp@intel.com>=0A=
> > Fixes: bb5dbf2cc64d ("net: marvell: prestera: add firmware v4.0 support=
")=0A=
> > Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>=0A=
> =0A=
> Thanks for your patch!=0A=
> =0A=
> > --- a/drivers/net/ethernet/marvell/prestera/prestera_hw.c=0A=
> > +++ b/drivers/net/ethernet/marvell/prestera/prestera_hw.c=0A=
> =0A=
> >=A0 struct prestera_msg_port_flood_param {=0A=
> >=A0=A0=A0=A0=A0=A0=A0=A0 u8 type;=0A=
> >=A0=A0=A0=A0=A0=A0=A0=A0 u8 enable;=0A=
> > -};=0A=
> > +=A0=A0=A0=A0=A0=A0 u8 __pad[2];=0A=
> > +} __packed;=0A=
> =0A=
> What's the point of having __packed on a struct of bytes?=0A=
=0A=
This one can be removed probaby. Thanks. Will fix it in follow up patch set=
.=0A=
=0A=
> =0A=
> Gr{oetje,eeting}s,=0A=
> =0A=
> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Gee=
rt=0A=
> =0A=
=0A=
              Volodymyr=0A=
