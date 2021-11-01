Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74336441399
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 07:07:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230462AbhKAGKH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 02:10:07 -0400
Received: from mail-cusazon11020018.outbound.protection.outlook.com ([52.101.61.18]:18215
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230333AbhKAGKB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 02:10:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cpcj0/rIRMGJu5W/+b2V0oMoDlZUkl/qwVYQ2cN4OUg9plqlptOYNlI6Y1TpSyuPSd+deTro4gsu4G63hdqCw/tWXP2WOPaIzKJcpLfQ4pZni3KTJswwCBh7DATcIMfBFGM0U/9HHRZxznKHLrbzoVpG0f8ppvSvdZkEpuGcvtuMHaZClQhHuts/W2bfzu4AGQpIOz1FxOcZniJt4GZb8GNkcAUXibqd/+qmjI4y4bfbGxw24rGd1SGAxeGzVL+2wXmSulq+RNJQvpxZqsrelxCxxiDAezq72zzLSm2hrEmBmjJmlPLpiBRYkwBKHswLqi6FsRRvbBzyRl330XSmWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PgdmJYeDQDjA5yqfoByc/fCDup9IiM6eonumG3X3Mpo=;
 b=RAeJQSPgW2hz+6Eo/QImQniHibYuuoxLJsOoilCTi8QbN4nc6QFrCzGKRVoihhsVAXAb6Gapt/dg7V3XI9ssBwELaVi489JWl5j3IaKu1Vl8zkv2fu4uCcXAsSyrcqMzezuI/klFeo5Bzm3ihkjHbh0agGw0z7yFSgHgW8Qvv/v66vknOQnGSeY0XjvBOpgXLXVVLR7ly12E9zhJ++RR7XD5KvlvHLc2BBDWFCWyu+3cMMFRq5hbDItgcYkS2ZbAuZ7wVJw99onarwAoEm/O70QcFMMD4V9BRdEifoZDWk3t4tooYEbTJHFj8DVcMB6+lN8eJEQNPdIjSVCCLVsw1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PgdmJYeDQDjA5yqfoByc/fCDup9IiM6eonumG3X3Mpo=;
 b=T3pwtcHMwDo3UiA23tUl1Zxs9g0NPKxxmbdF/geTra9G2MBpien1IjjNUE1zJePdSgO6pMnk5c+wPOjxIkP8ZkZrPLsQRsrz+586O6atcudQ1wvbCYqgGr6W30mOyuDTTMh5VTeJjNCpiRkKZQjcxIrFIAg0HwZT2SQEbswnaUc=
Received: from BYAPR21MB1270.namprd21.prod.outlook.com (2603:10b6:a03:105::15)
 by BYAPR21MB1623.namprd21.prod.outlook.com (2603:10b6:a02:c7::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.1; Mon, 1 Nov
 2021 06:07:22 +0000
Received: from BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::9c8a:6cab:68a6:ceb1]) by BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::9c8a:6cab:68a6:ceb1%6]) with mapi id 15.20.4690.002; Mon, 1 Nov 2021
 06:07:22 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "gustavoars@kernel.org" <gustavoars@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        Shachar Raindel <shacharr@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>
Subject: RE: [PATCH net-next 2/4] net: mana: Report OS info to the PF driver
Thread-Topic: [PATCH net-next 2/4] net: mana: Report OS info to the PF driver
Thread-Index: AQHXzSi7j12SBr54K0+FgVaU2HF9LKvrq/WwgAKGocA=
Date:   Mon, 1 Nov 2021 06:07:22 +0000
Message-ID: <BYAPR21MB127031948D2C6E22F8EC805ABF8A9@BYAPR21MB1270.namprd21.prod.outlook.com>
References: <20211030005408.13932-1-decui@microsoft.com>
 <20211030005408.13932-3-decui@microsoft.com>
 <BN8PR21MB128404C264B2E9081C97CF19CA889@BN8PR21MB1284.namprd21.prod.outlook.com>
In-Reply-To: <BN8PR21MB128404C264B2E9081C97CF19CA889@BN8PR21MB1284.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=92854149-9044-49ec-a825-aa3732946519;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-10-30T15:30:59Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 10d23757-37dd-4eb9-8a35-08d99cfdde7d
x-ms-traffictypediagnostic: BYAPR21MB1623:
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <BYAPR21MB162319FE4DC46680F2449610BF8A9@BYAPR21MB1623.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1728;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PhyWixYxeNXJsG01oyJrgoK0l/XgLvqJw5KfN3AviM5Br/x/FndooWnibmJoTQwzyGhxq+4D4EXt/9vOnQc8E8BekqMhbk26DCrPqo1zZLQr0UNFHQ6L2ACOsFS/CfOXrGDlGRmvVh5FVa71xeq+3i9d/t6zguR/akJ/WjhWw31QuzOURg+m00rKzBLOYvB6jIALmNzzB4AuIpXydXgE0EXmVClFDIf5bjXMo3T7FL3gOReAkpcNoXscGAmgvvLPrce0cC6ugT2k7FTT5xYBL9yjfDBXAWWx+WOWjFHQooe9Wqp7rxcQUAomqNOJWcSEECY7gbbKwQ+99HcxLUPIEZK2fBhVMOZ+Nca+1L8Zj53tzy+xR0dDf8Ps7O/I3ifH1f21oeIN1Vg3d2r00MSmlk0iDtcNf29v/35yg30mrKzTqfclwRqAtL0mGJnbTckAE7uxcsCv8p413I1lUxnjQge8CmnxJ0Xa6FjAsecdM2FstrKc0qSIb4Hl/utF20bLfW1LMV0ppVWIgbvS02tj9mMJzTkWiizXJQV5HZP0YyeIsPaieRlJinMrknqTsCoT9BOYNmd1yajLoV9oYUbktIaiAMDjB5Jzk+CssREPUgrvIX8IEVH8/l+Fr2fcWGpK9hhNSBUxRW+mhjAlwvz8AHG7RqbOgXw+fEr1cprRtFRw0iUeRRdEkZCTLvz4ScJd5DxL940J3vAVxdwvJhyx+A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1270.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(9686003)(66556008)(86362001)(54906003)(2906002)(76116006)(7416002)(55016002)(38100700002)(66946007)(66446008)(186003)(83380400001)(122000001)(64756008)(4326008)(66476007)(52536014)(71200400001)(110136005)(82960400001)(33656002)(7696005)(82950400001)(8936002)(6506007)(8990500004)(8676002)(38070700005)(5660300002)(508600001)(10290500003)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BqHyG8hEXKt5qaHssZIXKCgdObwm2zmcQmbYfpmWNxSllu1YqcMllpljSC1e?=
 =?us-ascii?Q?Slytrt5htEofmr5q3AhC7k3hVhGKc/w4mHtiih2BucnmwuzHmUn2mRZSrAmf?=
 =?us-ascii?Q?7WpiNvwILSqIUhGn06IYRi0zPh6pXjQq5qbTlLMsx3bTxEYRfCT5wxAkz2A+?=
 =?us-ascii?Q?zQWrzPNfl+kxVaqnCNV1lheNkvZw/X9jZ7Pfp5w1l2L0Sdi/WwhdgqP447eA?=
 =?us-ascii?Q?ZOCHjm8B/EQFf97yopvRrBgxaJ6iOuZ13oNjZYb+8FeRkGk/aken/z9u4Bwn?=
 =?us-ascii?Q?nVkzQ5e+wdUp/3v8x5XYbbnW1rw6drlQ+V74ZymDw+nCEgBNN/3zRVxleomO?=
 =?us-ascii?Q?sIH8h1EJRKUkdgisyF4jfRhElHksbEPnz+nohuXriCHlacEW6vx8JBqf6Dtc?=
 =?us-ascii?Q?fcN8Fv2Sx7y0eCpC57lBjMV/tGaZbB1+YvhDarEnXoHZYhWfsAl3zgnIV6mp?=
 =?us-ascii?Q?4QjxIySG1Sabj4cZoPp62wbSfgDRH8I3kxOA+Ig7CZRxTB9kJ9fXPtl2igpu?=
 =?us-ascii?Q?FGMFE94t2k0f+Kx1+iKAsz1dMOaUAy1Oba7xP7Aew3hISw4WlaVjLpnNPsf1?=
 =?us-ascii?Q?/6I3v/58fkFQy9LGiCdD58PaFqzNRIKU8Pm6pV/RSBWb3Gwuh/Mn/Dr3QtZs?=
 =?us-ascii?Q?UshRNHSMWlajRazlftjcCBdbij+614ZEakTLX/k6VVnv13hK4oWl+SadcmKE?=
 =?us-ascii?Q?gSO0za8ySIfBiNP+1Avgfjn6RpIySBC8k0vY/xqkho/70Kd8acEWp+tVv3Lq?=
 =?us-ascii?Q?1H9RkDmYxlrmdBO6MAvqYJ+QYJijRRY2/t/YEcgOqiDuJaPzUxJ4p8DbTFfQ?=
 =?us-ascii?Q?/PjhBApXsIa/tCfjPZhGrhuSYTiHRAkbN/Z7X1/30jdMbMJWN7Xd5DjziyOQ?=
 =?us-ascii?Q?8DFACaLuVePc1nhf2KVVZyflv3DAEgtrkc7plJQBiS/KRI48q/kHnFIIbSAL?=
 =?us-ascii?Q?2dSXjQYBN6FBO2mmFcsIVvfm+fxiC63TklySVXvZt20bxXK9YriIulwMX4AW?=
 =?us-ascii?Q?vuG+Abq0OA8OHm8y4DkuakLI22VKn0VuiK8tTGVOF40S27J0IzFYczTq5zDc?=
 =?us-ascii?Q?lVIz9wNQcp00E3q573+ZOKxHfVooNRWlKe/HV5avf2PT64ZYfRvl3OIesdxk?=
 =?us-ascii?Q?sCpFXBusa18Yk2LIQUFvznLHDizYNeU/KchLm46Ag/KBbjxKOZK0uPdiNxcC?=
 =?us-ascii?Q?ffhHT8yR1vln2LkUBZwqMZou+9eJMTvxnPQiwXoOjzcXP56jJ5HIvbKJNuri?=
 =?us-ascii?Q?eMPHUoAx5OMd+LT9soroBgein71pNCVBwpuwMhKBPOVwSRXhAqB8yk5wdfvJ?=
 =?us-ascii?Q?5HU3lq+2huUN8TxymyFEi8FX+iy65ESZ9QkzV1M3Xo3iHwDW8hswe5fKOPIu?=
 =?us-ascii?Q?Jrer6JqpsX87VBpGVIHLT7tvmzy8dL7p8wg3Eeaojbhf4Hfm2iIS9I9cFZKu?=
 =?us-ascii?Q?JVAoYrtkVxURkia65pTxg1SsIV/bfcJFjq7OD8unepnHN6M0OOF1198Z59iR?=
 =?us-ascii?Q?EynT9uRDLoXnuAn9xwjRoB2s1KLEBbm61qgPZfUXZDXu25YqYD0sulNXknbZ?=
 =?us-ascii?Q?TvvLiWwbLQFh8pjGmoF4SB8f1BYbwL0KrdJhI+WkMwKVmih1EBAOvvt9ICJ2?=
 =?us-ascii?Q?wyGtcLeejPI27YJ0PuqNWno=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1270.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10d23757-37dd-4eb9-8a35-08d99cfdde7d
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2021 06:07:22.1844
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: glYaDUL87KhkxAHLcgivvpGLB36xW07rZMWK5hLXhMR3BKMQHayKz0kvOgLNC9wKOYFuJS+6QCZdzAA4hr1YxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR21MB1623
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Haiyang Zhang <haiyangz@microsoft.com>
> Sent: Saturday, October 30, 2021 8:36 AM
> > @@ -848,6 +850,15 @@ int mana_gd_verify_vf_version(struct pci_dev
> *pdev)
> >  	req.gd_drv_cap_flags3 =3D GDMA_DRV_CAP_FLAGS3;
> >  	req.gd_drv_cap_flags4 =3D GDMA_DRV_CAP_FLAGS4;
> >
> > +	req.drv_ver =3D 0;	/* Unused*/
> > +	req.os_type =3D 0x10;	/* Linux */
>=20
> Instead of a magic number, could you define it as a macro?
>=20
> Other parts look fine.
>=20
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>

Ok, I'll apply the below change in v2.

@@ -497,6 +497,7 @@ enum {

 #define GDMA_DRV_CAP_FLAGS4 0

+#define GDMA_OS_TYPE_LINUX      0x10
 struct gdma_verify_ver_req {
        struct gdma_req_hdr hdr;

diff --git a/drivers/net/ethernet/microsoft/mana/gdma_main.c b/drivers/net/=
ethernet/microsoft/mana/gdma_main.c
index c96ac81212f7..bea218c5c043 100644
--- a/drivers/net/ethernet/microsoft/mana/gdma_main.c
+++ b/drivers/net/ethernet/microsoft/mana/gdma_main.c
@@ -851,7 +851,7 @@ int mana_gd_verify_vf_version(struct pci_dev *pdev)
        req.gd_drv_cap_flags4 =3D GDMA_DRV_CAP_FLAGS4;

        req.drv_ver =3D 0;        /* Unused*/
-       req.os_type =3D 0x10;     /* Linux */
+       req.os_type =3D GDMA_OS_TYPE_LINUX;
        req.os_ver_major =3D LINUX_VERSION_MAJOR;
        req.os_ver_minor =3D LINUX_VERSION_PATCHLEVEL;
        req.os_ver_build =3D LINUX_VERSION_SUBLEVEL;
