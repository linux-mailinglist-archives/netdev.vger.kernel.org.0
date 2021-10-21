Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A8AF435C30
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 09:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231567AbhJUHoN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 03:44:13 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:5466 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231573AbhJUHnW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 03:43:22 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19L7eAQj028540;
        Thu, 21 Oct 2021 00:41:01 -0700
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by mx0b-0016f401.pphosted.com with ESMTP id 3btjwdmt7j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Oct 2021 00:41:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ah+72+cYenmQfl/eQ/Ppt74LYEjl6AppBcKK0h4iELhG8NW51FNt+A2oNXF2xDNyaNFlMH/Wohel8dQfJbORgBELNP1yWmq+huqvFSEMDY1+vjlVrRg4ZLmljxk0r6At4BeSTZPkvHW/jm4UmkG+GuvzN79KI85Ea45WcZNBKg6WHzOiEn+7UBAmhc0TWKMTfUJ/azUQqXTrWBhNX4AYUsYqNKtgNekqqtOe4sbuzQfusgvxDnXP8Qr3A95HVr24WNDZg0UcE7IY44OoGAYimB6RsBD22n8ol3FpKpgdbEcu8EzYLChxvsVPIN3bYgovS6wlDPAy/CXQlsAAIisJLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TTeUidz5CA0xsB4A3jPcUbi35MYPVEJLKnrzLaCX7eY=;
 b=Ig3DaStPaYNGQ9iPy2avQB8+AEpr3WgCyqsr5GYXcYH7z48DHbC5QYFSp/MSZSu1vDauXc6WDvfCSSNVBPje1VL9HmduHemy7Jru3CP59J8LnPI+L84gIaj372VLYTr7pwz/rfkeD5uUqhsW8XcIB/ihngIFkT0cZ33AaQmUJHSYeqzklDrHhCtuMg8IpDKEoOfdckoyfDzMluNLyDYrostIYvF1RPaMnyd0MW+IgQEL0fRQYnQo4rXPjuC18AadAcI2lS3JCTRpNlV3+efBkmXToYD7HhriqizHq7af3Kdi/JN2f01zd8DdhloaZZZdOwGJ58G+1YhtSeZpy08AYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TTeUidz5CA0xsB4A3jPcUbi35MYPVEJLKnrzLaCX7eY=;
 b=hccMGIz7TvOCbB4RoPROwB9j4cLgyn0fC6DlWy7Ehx4CQVkk0nEZIzR6v+gG3hD6jQQPAdCFjct/S/6VPMUUdd3F6qKiiQWEXFArh5pwwNhSV34FRlzZ/vsK96H4yT2pYi/4E5zZzr5DvQPqZJY9aEirE4F17kQrMLb6D5pY6Ic=
Received: from SJ0PR18MB4009.namprd18.prod.outlook.com (2603:10b6:a03:2eb::24)
 by BYAPR18MB2583.namprd18.prod.outlook.com (2603:10b6:a03:135::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.15; Thu, 21 Oct
 2021 07:40:59 +0000
Received: from SJ0PR18MB4009.namprd18.prod.outlook.com
 ([fe80::919c:1891:e266:2502]) by SJ0PR18MB4009.namprd18.prod.outlook.com
 ([fe80::919c:1891:e266:2502%9]) with mapi id 15.20.4608.018; Thu, 21 Oct 2021
 07:40:59 +0000
From:   "Volodymyr Mytnyk [C]" <vmytnyk@marvell.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        "Vadym Kochan [C]" <vkochan@marvell.com>,
        Yevhen Orlov <yevhen.orlov@plvision.eu>,
        "Taras Chornyi [C]" <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v3] net: marvell: prestera: add firmware v4.0
 support
Thread-Topic: [PATCH net-next v3] net: marvell: prestera: add firmware v4.0
 support
Thread-Index: AQHXxk79iqTIw1mkTkyXMt8fIF9KfA==
Date:   Thu, 21 Oct 2021 07:40:59 +0000
Message-ID: <SJ0PR18MB4009D5BA67AF1FFED9C9F79BB2BF9@SJ0PR18MB4009.namprd18.prod.outlook.com>
References: <1634722349-23693-1-git-send-email-volodymyr.mytnyk@plvision.eu>
 <YXAP/sZhSnvUUYNk@lunn.ch>
In-Reply-To: <YXAP/sZhSnvUUYNk@lunn.ch>
Accept-Language: en-GB, uk-UA, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: 763e5493-cc04-c907-e316-29ddd5692bdb
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 82ee7a15-a961-4d72-5299-08d994661ff6
x-ms-traffictypediagnostic: BYAPR18MB2583:
x-ld-processed: 70e1fb47-1155-421d-87fc-2e58f638b6e0,ExtAddr
x-microsoft-antispam-prvs: <BYAPR18MB25834C9865ED25DF5534226EB2BF9@BYAPR18MB2583.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yUbj6EZuYPntreFF+vxP4HKCt3aePqjjgRtyQnaoFMALOLul5xYfgqxo/Xt7Hzs+15ZPtVqPNzzCCMYEZFiMiWc+yaHEB2xIUbYM35cBnaC4+9PYkkg4u88BUzGVbyns2puKRt9SqRTC5Zcjuk9qOyDMdy9He7vtMYrRUAzmILA55jER80y7mUing0EKHPO6tLgF8icHhLZyRAM/s/CQUiufEV5zfxKxsdej0mEXNKG5dl/jETNRecUhpfJ9Da8lxjSfdStIsQmLRWn8m1BdY8PmLRlT1YeKVpt0opLoMG2QZn//9dtH+B4TdYWLDzQGHjxpEjc7jeGc2mcC9qHzIGzFrKSKW1rM60ud0O91UoAliiHjuIJ1xrUK2ab2T2p9Jc6UFAI5lmFyFLtT+jrD9eYRsktamC2wUbCqhvT25yF7IusRB0SmM10r90C21aKvkZakCSBFhlLnGBE9t4NTLly2ZKAcx83steGOgVyM5sBGQ0cp9aoM1FsZgiBjP8jnUjNzveGPqKRL+Rfhy3UDNvS6zCTgtxoSIUkltosFbuaUM+RSabcJGqDKcix7FOs/NzdT+YQKP2P+FlXEeLKPqOSIjDGM6ON5gTVv2au42YG4YFgRk199x6ICFvKtg2srFPoPa0/3OIJAh7UaOwIkhBwBRU/VTV41NsaMyQYV3nKIK3QpJ9TMb9+0Eh9fQie/QvlR+EKGHi/tCknTk+XAKg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR18MB4009.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(38100700002)(66446008)(122000001)(83380400001)(33656002)(86362001)(71200400001)(66946007)(66476007)(66556008)(76116006)(64756008)(8936002)(6916009)(4326008)(9686003)(316002)(7696005)(186003)(6506007)(26005)(55236004)(52536014)(5660300002)(38070700005)(54906003)(508600001)(55016002)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?jrOqQuHKCi7s4ctRc+tRncDgmO9lmyXuDKD3drQqIRSqIg/UHW0zGX6cet?=
 =?iso-8859-1?Q?2fq9Z2JQZlyu06QlaTfs6rZZPrsPB6IddScYz1GQ3kq3IsN9COpS5YTMKk?=
 =?iso-8859-1?Q?STukdKwU9KyENyhYxglv098ktkh2ZtX3NoBVNbKWzeCmhAzy8MRx6i67PG?=
 =?iso-8859-1?Q?1oj5UnpQ6HqeBppk36V+AtT2W4gXnUMvSJQnvDfhPTWViWIinUqrskR4SU?=
 =?iso-8859-1?Q?DchzAnEyZSjpdvMWG3nLsygxqJbdx8CB6MfqwnmeBrG4sbleYwW6Hw1yeK?=
 =?iso-8859-1?Q?q5dREEPutngGRhIanyCqq1iEFqx7H5F53GyRklH+EWC4MUAn7mC+dBxR3d?=
 =?iso-8859-1?Q?qJys9/Rf+vNqc0vGSkpxoty8TQAJDoLTkD9OWYr0nyXpeF3zSIixk127fD?=
 =?iso-8859-1?Q?vJD4T7ZBGOZ42tvqV5fHFDmAk3bpuhJmT0Fxo31P8rEMS5SgGrGaULkhcW?=
 =?iso-8859-1?Q?QabIcd6Elw/0ELczTbziOLWp3aJiscO+c2yVyehJT4Te2hJxozH9m3Mhn1?=
 =?iso-8859-1?Q?5prNGluw0K31huML7jimhPaGUjTrABDu+sr2x1Z9p0aPvW7fxPM0yt4XvA?=
 =?iso-8859-1?Q?lB7nQ3XH6Snxyepre0WvTx3/AZ1s41NbzDBsERQZfDNJLpzUzy+xffBEcK?=
 =?iso-8859-1?Q?ouEyCgWGVM1Tdmh4ZXOewyqga64KQpecUXN+SA9GZ9pQKPu4QR4kQk++dw?=
 =?iso-8859-1?Q?TM+xWtniziPf9vvBiHdTEqBk0x35MmQf1qgzh7ZhiVbdi+8aJ6Lb570+E8?=
 =?iso-8859-1?Q?d58vny9ielpISmMse1ngFSF8k2OSuIxxAiCR/dSMmD6ZcdMIFM28XAAde2?=
 =?iso-8859-1?Q?fJvnKl2mNpqqvFm7KDF/yBYr/rFQZ5RBCoj+n8M+ylPeDsaWmgYrhzemBv?=
 =?iso-8859-1?Q?Y8/rdecFbfopPapWxRjzVoEsVcntNNAI+Ej1mA/7hC4ZnTcd/taK/+sYI7?=
 =?iso-8859-1?Q?8jVTLYDxpKJGYmFV1kJOS7REFTel/t8DPpbgd+DUTP2EbTn4hiE8fV+eOi?=
 =?iso-8859-1?Q?9RicrhCUZXwrct18xCuYxXZq0tQoCDIrx1Q04VUE0P4eY/Erkiyw0/5BC9?=
 =?iso-8859-1?Q?NZis0+KAJ1mym0FNcDkv1e41KkBUe7h2sLEdW2mJ8JxNfYvlpDziepynf8?=
 =?iso-8859-1?Q?UusXIXnq7O2bRSUtDypnC/jn/eVr+yMeLgzwnYJEpVfgU1klToZ0UDPlxt?=
 =?iso-8859-1?Q?Z0ZFYLkavJ6EsEJzlJK2JMKKS96Me6kNkZxIZfTlzwZxddv/Ww5wKZ+DK6?=
 =?iso-8859-1?Q?Zrd54FA73YPhkXXEtDnnib2UhlwQ0HJZ/TCZ0w8mBmzFZxqCGT9fouGyte?=
 =?iso-8859-1?Q?g04VJHCgLi8szqbEQq0Mi1lJmTtxKepqBXXDMuUrtnDjvIiS5ubYIDm28Q?=
 =?iso-8859-1?Q?ixE2PyR6kPaiKcWI+c53zL6eDJKgWra5sDkIS53/QVUf9YQ41bQgoH/++9?=
 =?iso-8859-1?Q?BtPoRChPdWEitybdc8+4sZNYtTk9Wpe3ZtGCTA=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR18MB4009.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82ee7a15-a961-4d72-5299-08d994661ff6
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2021 07:40:59.1028
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vmytnyk@marvell.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR18MB2583
X-Proofpoint-GUID: T7fr2QVYtPHFuWe4O0u5qTG2Au6w5cWd
X-Proofpoint-ORIG-GUID: T7fr2QVYtPHFuWe4O0u5qTG2Au6w5cWd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-21_02,2021-10-20_02,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew=0A=
=0A=
> On Wed, Oct 20, 2021 at 12:32:28PM +0300, Volodymyr Mytnyk wrote:=0A=
> > From: Volodymyr Mytnyk <vmytnyk@marvell.com>=0A=
> > =0A=
> > Add firmware (FW) version 4.0 support for Marvell Prestera driver.=0A=
> > =0A=
> > Major changes have been made to new v4.0 FW ABI to add support of new =
=0A=
> > features, introduce the stability of the FW ABI and ensure better =0A=
> > forward compatibility for the future driver vesrions.=0A=
> > =0A=
> > Current v4.0 FW feature set support does not expect any changes to =0A=
> > ABI, as it was defined and tested through long period of time.=0A=
> > The ABI may be extended in case of new features, but it will not break =
=0A=
> > the backward compatibility.=0A=
> =0A=
> So if we decide to merge this, we will hold you to this statement. You ca=
n never again break the ABI. The driver will always support v4.0 firmware.=
=0A=
> =0A=
> Are you really sure you have it correct this time?=0A=
> =0A=
>     Andrew=0A=
> =0A=
=0A=
So, the v4.0 FW supports stable ABI for the following set of features:=0A=
=0A=
  - L1 port management=0A=
  - lag, vlans=0A=
  - routing, ecmp=0A=
  - tc templates, chains, conntrack, policer=0A=
  - bridge port insolation=0A=
  - HW counters=0A=
  - storm control=0A=
=0A=
Some of those features are not fully supported yet by the driver. So, while=
 we support these in the driver, the ABI is not expected to be changed.=0A=
Of course, with new features to come, the FW will be extended, while the ba=
ckward compatibility will remain stable with the previous FW version. =0A=
Bottom line, for this set of features, the ABI is expected to remain as is.=
=0A=
=0A=
  Volodymyr=
