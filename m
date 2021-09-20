Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 326254117F3
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 17:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241129AbhITPOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 11:14:47 -0400
Received: from mail-eopbgr1410111.outbound.protection.outlook.com ([40.107.141.111]:59568
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234585AbhITPOp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Sep 2021 11:14:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lbEvJiqz+ogQLLqhHhiQ4DUNRg3gNcEk3Je0LDdUKB+qrWT5kzpvDqh5GHQy/R4tiiSi0/5krabx0tIZrlk62n212OwqRU+ZqCqnIgEO/D2Q0vzRRRhZcoC+SUXrb/SGJ6u2JTiwkv3Txvz4SY5amv4aj7BFAtNvNlSeYKi1ByBaZFzSHdX0aUudzHZ9pInv0FWoXLTdDg5HzGR5Ckb4K7kGjpjpgU8iEi2x9av82wDU8YM9NmTw1rqCa0AO5jCmKhHsRGI7ZVn2RX/eqe+eCyhRFS/uRW7f1sqmrC43pNvYJ5vb7XX7nX48dPhpU0L5cEtrPOMVEUClZYJcKMGzRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=9L0InUEMu8PtBVG/DAWGB6EhijLv3j+3mkHWkSb10aY=;
 b=jJ5yxtkGEvvmrlSrOx3qNmxbz+S+H1u7A94qo9f8NIvAxPo88M3d8CpaRiZWFGsc5ZPltuU/HkFZQtVo8e570foxFXUbM3W47uNhKBBq8INMS2ctEIwyxVM1VNqTa480hIXCWJKL+MBQndAyMMv6GQ8opQqzii5f/8hV/cJjO8WSuea8Byi9i7uB7lLpIfchMXeNenk+lP1c/uai4vixMBywwHjkWGUE9OHfLi+dWY5SVj7hp6axbq0MAgCeNL2rMPfeTVMPUkfphoaFyW4iYedDY2Y/7reb10n1YlWav/8dKtbg5JgnRGUDb+LZL4RbESwJp3GkAln+g6rb7+d7dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9L0InUEMu8PtBVG/DAWGB6EhijLv3j+3mkHWkSb10aY=;
 b=LYuf0/YqWLjfP/JsXhnkK61O3moSubtktAKLwc4ZhVTSEf2rynx0ZH6Ug6Q1ltTg96VPhzcEzdVtL15qeGEUQ3yTbhUHHIZU1quwaa/kyhQMEX0mpHAfMNBoYZgi1tcdkmWRPf4d0oWVfhfDQPCn/EQsHNCfIv8QLoqcKDrL6os=
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com (2603:1096:604:101::7)
 by OSBPR01MB5239.jpnprd01.prod.outlook.com (2603:1096:604:75::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.15; Mon, 20 Sep
 2021 15:13:15 +0000
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::84ad:ad49:6f8:1312]) by OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::84ad:ad49:6f8:1312%6]) with mapi id 15.20.4523.018; Mon, 20 Sep 2021
 15:13:15 +0000
From:   Min Li <min.li.xe@renesas.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: RE: [PATCH net v2 2/2] ptp: idt82p33: implement double dco time
 correction
Thread-Topic: [PATCH net v2 2/2] ptp: idt82p33: implement double dco time
 correction
Thread-Index: AQHXq9Hw5KOUR0ss3UKvyfLSiPV3fKuoo+GAgAAE1HCAAA9tgIAET8JQ
Date:   Mon, 20 Sep 2021 15:13:14 +0000
Message-ID: <OS3PR01MB65936F7C178EC44467285F2BBAA09@OS3PR01MB6593.jpnprd01.prod.outlook.com>
References: <1631889589-26941-1-git-send-email-min.li.xe@renesas.com>
        <1631889589-26941-2-git-send-email-min.li.xe@renesas.com>
        <20210917125401.6e22ae13@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <OS3PR01MB65936ADCEF63D966B44C5FEFBADD9@OS3PR01MB6593.jpnprd01.prod.outlook.com>
 <20210917140631.696aadc9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210917140631.696aadc9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: de9e03b5-c4be-4676-35d6-08d97c492b59
x-ms-traffictypediagnostic: OSBPR01MB5239:
x-microsoft-antispam-prvs: <OSBPR01MB5239F06D36913E7BDF8C9092BAA09@OSBPR01MB5239.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YBNpLdphbpLSHQViW5ig20OT4UlnvcUoFW6H3S91LPMSVSpWOiAGiNo2/ByBQwga5HAqJzd4FLvHX/5K8ybOEtP//mbY64cvcG4FjfF4SS38XS89PTZoN3CH+c1BCaXQspSIp8x5J1N3g8nKOMeLO3CiEHoG+i9hMlFstXF+0OFQcRb9PvbNVS0Ri7e33iSKlEG6olsJygu1x56b2ywBM62XlnC3svgmJQfMBvegVzNpPQjswF/1Jb5gg8LKlOurxNTKl/VVFVUQwTDKMyK9TsNILghA/x/Y6rB2e1AF3ptus1uIE0FnsqHsJRWzenGHQli03qWd4mztuyQDicSY6yeMv522rL3kV6fabMUPNiEb2iSRQCITZbjbn1dcUPj01q1OKXWQlRdXzupplFxGCELZ06rp5c9w0yE0wBFBs9lo0R00Q7EPBlcy0RZjdndSM6p5R10V+p5rQEZaMNqJ3ilQ178XRK2UrksngBUUTuTaw7oOfqvttb36oIWkBupaOxEye17dJssv0wiX+y31d7VVC7Cvf7maeXz1NJPeSi8WPme1oWTN+V/+sHKtXUj5lEMQLPV+fPc62ofa/aWOdzcS6XBgyKsQ3j9XCu5L/ZVA4+rVz8j+nHhuT445z5xFLWNVmGHNJ01p3WBoJL67HMdl4l1TgglbOR4HHHrkUOLlpSpxqMNJ2vtCNrhxsNu5PjR5m/V/gzv8JodftHEVjA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB6593.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(39860400002)(366004)(396003)(26005)(122000001)(5660300002)(6916009)(38100700002)(55016002)(186003)(76116006)(38070700005)(86362001)(66446008)(478600001)(66476007)(6506007)(71200400001)(4326008)(8676002)(54906003)(316002)(33656002)(52536014)(9686003)(4744005)(2906002)(7696005)(64756008)(8936002)(66946007)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?94y7kBrB5Wo6FpIrTseuReDpvyFY6ehuQHuEVX9+ikxVj6AKcR3cXV9/BO4W?=
 =?us-ascii?Q?picKwIsof3kBUw8nEcZxQCl+z30ZT/jMpSpfKW+r4p7K6WqS8kqK6agyLeWR?=
 =?us-ascii?Q?coaRi2b+XsGhNRT9NCD7tviUcUsIHZq9opZs/2qiUUU6zANh6dHBZJsibMWN?=
 =?us-ascii?Q?zrCrpqxumpWNez+2IQinEkko4nWI/f87zo4HUOZahzGOCeTTfZ9Xc7WPdVvM?=
 =?us-ascii?Q?5c2BGELGV7xo52rXQGV/9KW+m5VIrrzDg4I9mN2AA4JETaR6WS7tnYZ/afNF?=
 =?us-ascii?Q?HsR0Vq5vll4xTF/JTs8mszp0LASR0uGgvcsPM0eLBayS+jeL07AHtD5ZaVwG?=
 =?us-ascii?Q?7K9icD/vWZLRGrKuqpTGL8u7ugMOaUgv5+z0qfkhbbr5yAinekzth7SWVAsJ?=
 =?us-ascii?Q?HPg7Jiri7tlyHb3l5n1TKfjWYliYtt06AwjiL6EEiAAoovNIuNc6EOIQkVbK?=
 =?us-ascii?Q?V8eiEw++nzsek1qls5AMHmommM9+GjjNipY1WoSPiYxe4X2du+DWfE3qcZpG?=
 =?us-ascii?Q?II+Mv9FP3mDQ/UGyKdDD7XcY4a8RJ8w9sLFzwcLNBHhmiTzkKHbtYG3oNKYo?=
 =?us-ascii?Q?PV5uyRlX6TSoEaxCpKXyR/QJV3sjAqGQ7x3JWf3d/OWqDKVL2bX+XZS45R/D?=
 =?us-ascii?Q?P8OgJGGp6Mp6UppkqW6xSWcpnBViRbj3hQw4VkOhktUPgW4goorzGwoUO/0t?=
 =?us-ascii?Q?pt3EC9HpTgeQ/PcdvZp4W/ACpeqiZah3xfhXz2Blh1loko/mRaptAdlJGxVh?=
 =?us-ascii?Q?dXi52P3p6p0O1y/j7WCME49I/STXFleDsRRKGxVisRPji+P8I38LGou90DLO?=
 =?us-ascii?Q?rGoM5CZFS2kIhJD1TGk+87UabZ9bu0DQrXrS4wRdfasz7mloumVmtropc0G3?=
 =?us-ascii?Q?C1/5Ig9lBcJTl5DrUS98+IomvYB/uzGPmEgKoyxKJF+WB0qdPVo8ygxsBuPN?=
 =?us-ascii?Q?VJHR2fmI8A+ttHjjB3TquayjEpd1wKhUK4Udv7ElMMd83pCAundfIxg1Ky6c?=
 =?us-ascii?Q?gCDjGwNj51k1HtdHQoJKeHL0AbGaCf4U8cv6mVxlK2ZYSTF1+dPYTp/rF7QF?=
 =?us-ascii?Q?d3GzK2xpkllg4sPi9rJTZG0nv2JoP5m3DTVUkKg1p/OLoLqcXvLe2D7TMx5D?=
 =?us-ascii?Q?YPIWbcoKL6tcvPyUpUCCn3etxxqwGkQrvfMCPnXGHAr+L/Ix+oNOYzerCLmO?=
 =?us-ascii?Q?n4dIKdrt8AOyjlmUYWZggtBK8/8lqxFtnix6+3BWIZ6EEgsBm2RLD4XSZgpD?=
 =?us-ascii?Q?33BOQQsirIgBDIz1w6vd+FBetSAmQdHBtXRk/YG6LM0/VWU3FqJld281iGvy?=
 =?us-ascii?Q?XzvKowrPPTnjdXxMU10RuvOc?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB6593.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: de9e03b5-c4be-4676-35d6-08d97c492b59
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Sep 2021 15:13:14.9637
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Wiby8ZeEMTjOz705zamkZsrq3TD6vmJiKzi8VdxJcsSW2yy6E6Dr1cq5ApBjQpRwDsbKOBXhMZuhBc6rTQnZtQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB5239
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>=20
>   > On Fri, Jun 25, 2021 at 02:24:24PM +0000, Min Li wrote:
>   > > How would you suggest to implement the change that make the new
> driver behavior optional?
>   > I would say, module parameter or debugfs knob.
>=20
> Aright, in which case devlink or debugfs, please.
>=20
Hi Jakub

The target platform BSP is little old and doesn't support devlink_params_re=
gister yet.

And our design doesn't allow debugfs to be used in released software.

Thanks

Min
