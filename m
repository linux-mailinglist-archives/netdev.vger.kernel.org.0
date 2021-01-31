Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3888E309CF9
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 15:36:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232390AbhAaOdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 09:33:17 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:32998 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S232403AbhAaOYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 09:24:18 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10VEKwgT021470;
        Sun, 31 Jan 2021 06:23:25 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=f2qiuY4CT7py95M8FcBFSSwQZMHqgnKCkvFor/zslpQ=;
 b=ieMqbQTxNA3bOJJGj/IHREvD9kUk/Fn14klBNT1CQNYwQVhAo7sa4h2NcwCvPW/bHd9s
 qARUSdTizaQ9QMpsKtDgChzR+Jm2xN+gr9K/Y1sxM4e/2caL0h93HMLlpdyHcNK0tNmt
 N2HU494hjnmcgc9tzUUo86BMN6rVRiaK6Z6JaWByfIyufI3UrOfvqTYLLDgorEX12DjO
 7RyfwWw3a6Z5cp5jG2ng6OuUI8EPCSv9Zrn9oxTIqLenqb0Pk0lV4VnK0HBLLS/jXOyc
 9jimUKftHRbdUVTYjfMKZoFUcTeIrqRRwedT7gNicRIoznaz0AAbDDiImOsThLrZg+Jl 8g== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 36d5pssvab-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 31 Jan 2021 06:23:25 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 31 Jan
 2021 06:23:23 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 31 Jan
 2021 06:23:23 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.175)
 by DC5-EXCH01.marvell.com (10.69.176.38) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sun, 31 Jan 2021 06:23:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FJAQUhwI4HMHrjILGXVDktJ2duUlDKTXJuYTxAyrXrjCSxdnVVRXLer6ctxkMTZTVBp+1RZdujEwfW0oKsU7KtbBgJzRIJVU0Pqs6wXl3cc9EMAXLm52N0XTYv2bXrKEIO57GFuBEKZ6beyFUm7KhXEq0Z3Lxo4xXwioxmNbOnpQR4ywFbdWwLYd/CxlHxxuCugN4a9V4N1UzNwSDC2/rTSDonbDmb0wMugVzRGEH068SHeQGd64X5k6IGBgMVJ4pNHCfXXNSdrU5D21Hy4qjNGFpBDYBSzEFvgK4iCMci15PldwTJ/vWfqysInjXhiarQvIEqamPlMZT/SacKhB1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f2qiuY4CT7py95M8FcBFSSwQZMHqgnKCkvFor/zslpQ=;
 b=OF37IMW5qp3xPaF00ely1OmGN4SW8+gJEWrH5xcYA1NQLBc5Am6qra/IfVyEPR4MPPJa0jy4Uwz0viwGcz2MAvV45l79HkVdc6KaNakfq2F3FLrqToGrChF0h5ZIBVI1QEXUrFOC4FnVUVWGRLV68dyjTjYqhaboeeGVskOiFLVtoXTsbjahDxWpaOhOy76XKSnfBh/MhPwkhGHOYtx/HIOUr6IZz9ty9OVOMcmIzGFgHWHQ6jy9X3oTlifJPJi2PB3NMIx52Mkcsp8eeHf4NJnX+rXC/h18UTUSB9LKgEmreXBn05CYqF84DJAEf9abtzP0SDsqK2u9bYKASg0LvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f2qiuY4CT7py95M8FcBFSSwQZMHqgnKCkvFor/zslpQ=;
 b=TYnRYXrm8mqwXs9vgMtyc8rZUbbADK0JhNz/S918U5MZ/gUWSfReKm7vBV26tvm9LOaAXY0ryR6iocZRRa+9HAUN+uYELoRMyb8Vmy8eZRVNiCkI/grm88eXv5TkMmrEwbr1jvbgM6W+VJLWWJoDIWadKF6tLdjhbQ4JGyFbcOU=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by MWHPR18MB0960.namprd18.prod.outlook.com (2603:10b6:300:9e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Sun, 31 Jan
 2021 14:23:20 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a%3]) with mapi id 15.20.3805.024; Sun, 31 Jan 2021
 14:23:20 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "rmk+kernel@armlinux.org.uk" <rmk+kernel@armlinux.org.uk>,
        "atenart@kernel.org" <atenart@kernel.org>
Subject: RE: [EXT] Re: [PATCH v5 net-next 00/18] net: mvpp2: Add TX Flow
 Control support
Thread-Topic: [EXT] Re: [PATCH v5 net-next 00/18] net: mvpp2: Add TX Flow
 Control support
Thread-Index: AQHW9aPOiPqZIMA/y0u3Xuo4/7naLqo932+AgAOi7iCAAEspQA==
Date:   Sun, 31 Jan 2021 14:23:20 +0000
Message-ID: <CO6PR18MB3873FF66600BCD9E7E5A4FEDB0B79@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1611858682-9845-1-git-send-email-stefanc@marvell.com>
 <20210128182049.19123063@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CO6PR18MB38736602343EEDFB934ACE3EB0B79@CO6PR18MB3873.namprd18.prod.outlook.com>
In-Reply-To: <CO6PR18MB38736602343EEDFB934ACE3EB0B79@CO6PR18MB3873.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [62.67.24.210]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1187b13f-7e13-4912-56c0-08d8c5f3c29a
x-ms-traffictypediagnostic: MWHPR18MB0960:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR18MB0960E6B9BCBB2BF35C4D9031B0B79@MWHPR18MB0960.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:327;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: P/nEqZQanuCHTPgQeZ5Y+AJ5g03mPAEvhtJ151Run+pp3ZrGdMehzw5rwNHTpHD1C2ymBgELb9HoNW92h8mzY/LFJRF74K6VeITD+jFItpqipTRf8FtRpyFawC/ARVYyWsGmqM6CDyxmVcdM1oMWwBfvY8qzdEM9eyT4OTATND7KShF2BrD5mV4/6WGXkQbrC/Xt81rd0cvmE9qtni9HE2O01/FYaJJqkqB1VE2BDG0rj6bgHCZkRf60qwMaUaiLbAG6gAz/wa2muAsZO+KcEm4P67KNC+Uehs5QP+ajLyWhmdCrgM6bP+I4Fn2hfZWFdB9uaRkH//nTnLIDpl7FBS6ajtdNON8LRv/2xMy3oDdQ4GoZQ2rJGzaLmil5VY8hkxxOGMeGOdWTQYRtvjaAe53yE/NOaGZSFSlbrRAl7BKYFCh8al6Rk6tEKyW9b0RbKkf3syvXcbd2oGv+U8W4HZYBgypNWOUco9Xs4so4lnHjg7f6B077R64WHZcyeEof+sIq1xakFFJZMSLI1lX2IRVpgvPAEPBrlM3EsGA2EYScRzI9mTRehDT/ywBXkE0wiRgUdtvdLGvbwwnKtmo0VzM7N6PkRzdDCVyhRvx6fL4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(39850400004)(346002)(136003)(366004)(2906002)(86362001)(6506007)(966005)(478600001)(26005)(6916009)(186003)(4326008)(76116006)(5660300002)(64756008)(66556008)(66446008)(8676002)(66476007)(66946007)(52536014)(9686003)(8936002)(316002)(7416002)(71200400001)(2940100002)(54906003)(7696005)(55016002)(33656002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Yv42tw2r0dsPQOWYMfeXaXp+Szy0SUafDsJbQXoo4UuDoKcxfSlOrSDo2g+P?=
 =?us-ascii?Q?343dhMICgJAhqd75csWvy2jeQtZnCzEDuXKZWfOyXQLQCIRza7a+Tz2LvDDm?=
 =?us-ascii?Q?fHTJ+mKyyHJbQE0jGET7N/7Ahyl/Kp7QSAZYvf1Tih23zTd2ACZdJw4A5QXn?=
 =?us-ascii?Q?96egxSGow1Bwfq8TjJLgvavIcD1kDKdhsHV6UxukxZ/tuyF57ZzW4tVQ+ZnF?=
 =?us-ascii?Q?kh2Dw7i8pxv6Roin6Ee0XQehdwCF6J3fkyIQUEHyZAreb6grLY59AghYvqtv?=
 =?us-ascii?Q?fWs186hll80SWFMMPxk+jO+U5+3kbO17z9zNPselkbOhZmAKrNIYPjpSkYT7?=
 =?us-ascii?Q?YGwL0TYxAukqF8gp4UMqxE3yOalUv+mykWHS0uQpEkd7BYkWZ0RVWy4vgVMU?=
 =?us-ascii?Q?i+Ij0LAOiHTsaynIcvnVoKKREKNcoiZjk0A7oGbITGI4ThjyNE1ma3VOu4jR?=
 =?us-ascii?Q?PfebQzoCLHAKckLqhqnI/jCc6q1KmAVymOKn64heA+AZYLIFT4Zv+BXY2e30?=
 =?us-ascii?Q?bWAzSUNVqMvoj4y1UMZWRyp5FuzRPbr7svBETQftNzxi64NENp7OGYPx2V3P?=
 =?us-ascii?Q?mEO74b47jNtpyryQaOAXCDOex2Pox+kgm5TScyamAg5VSGz3ehldYRmwT27/?=
 =?us-ascii?Q?T6Zb3l0UCHpCc5AkFmSPfTvV4K/sHQ4JJS1RWG6WaPb6wfcE3MXVzDgqwciW?=
 =?us-ascii?Q?JwrQWYcsI9PhuFmz/70tc22hiM7ZAjuOLFOxxwUvu9cu7njJZuABRPB/BZxd?=
 =?us-ascii?Q?1EAHLO/bAczbflKh1Xv4e8kaMVs8VVm+8SrCPIBQAGVo8ndHmJy915YYwQbB?=
 =?us-ascii?Q?ouVNKFmNsYPsgsiPXHFdErKuL75FkmzDR3WqzwzZJ9+66Z4V6uqzo5cpQJZh?=
 =?us-ascii?Q?/fhFsPOPm3Sg7hFB8eaAKo+GinTNiMTpnEFidVGnn6BqQXI9K5Rz7flHpHQH?=
 =?us-ascii?Q?IFqdstyLkH8guF6PWNn48Yf6Mp6Mrvkh3tZsS2Jb5cHi58mkwy5fA5GfwefX?=
 =?us-ascii?Q?kxbnJuFyh1A40+v6+iHJkvQeNs4VvlLGPZq8mT+gvJ2ihtd7M2iGlJLikPt8?=
 =?us-ascii?Q?Jluge27H?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1187b13f-7e13-4912-56c0-08d8c5f3c29a
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2021 14:23:20.4469
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lyHNzvw8vDqo2k/YW9J05qj8Nt9yxlFWgSFN2/PFb7/dso5K5+OI5SIh74WgXwiWTUmGpBoJPdg8LlBA/0KdPw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR18MB0960
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-01-31_04:2021-01-29,2021-01-31 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >
> > Hi Stefan, looks like patchwork and lore didn't get all the emails:
> >
> > https://urldefense.proofpoint.com/v2/url?u=3Dhttps-
> > 3A__lore.kernel.org_r_1611858682-2D9845-2D1-2Dgit-2Dsend-2Demail-
> > 2Dstefanc-
> >
> 40marvell.com&d=3DDwICAg&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=3DDDQ3dKwkTIx
> >
> KAl6_Bs7GMx4zhJArrXKN2mDMOXGh7lg&m=3DAFp2yfjV7t2l3c7dCM9lllj7Mz1V
> > -
> >
> 57354rTjjMB9_o&s=3DTK5AoswsdBLZNKNMI_rMiQQFtoLZf9UqEGQ40u7OHGI&
> > e=3D
> > https://urldefense.proofpoint.com/v2/url?u=3Dhttps-
> > 3A__patchwork.kernel.org_project_netdevbpf_list_-3Fseries-
> >
> 3D423983&d=3DDwICAg&c=3DnKjWec2b6R0mOyPaz7xtfQ&r=3DDDQ3dKwkTIxKAl6_
> > Bs7GMx4zhJArrXKN2mDMOXGh7lg&m=3DAFp2yfjV7t2l3c7dCM9lllj7Mz1V-
> > 57354rTjjMB9_o&s=3DBC2VcCRP0O0r4wywUHOgkqvleArWUsCGaT3Ue1-
> > O6VE&e=3D
> >
> > Unless it fixes itself soon - please repost.
>=20
> Reposted.
>=20
> Best Regards,
> Stefan.

I still don't see all patches in https://patchwork.kernel.org/project/netde=
vbpf/list/?series=3D424949
I would reduce patch series to 15 patches and repost again.

Regards,
Stefan.
