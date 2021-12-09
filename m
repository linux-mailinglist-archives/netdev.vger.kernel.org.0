Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85EB646DF80
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 01:32:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238252AbhLIAgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 19:36:19 -0500
Received: from mail-cusazlp17010007.outbound.protection.outlook.com ([40.93.13.7]:10587
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229478AbhLIAgT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Dec 2021 19:36:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=foNtpmwMlhVzYuAfmK8/HNErvZdUYk3NClT29q4U/lrJbkJkU0CCbkny6AxP087THD2QfyswPdABEfySczDzYCBI2O1duqoFEylxq/gVRm/wuNO4B39neG+gGCiWGcXOg/hcZFGZtC0faZnohJ6roc+uxy02fo7BNiTL1eXndPXlyK8b+k1YYT+p4L5jEDqBDrsNHrZHek6AG/n8gEIBYqVjHflQMbvzFym4hh6JxhnCxKddoxhguKfawPHHBa/O+VkTAV/cCFoI2JeomhVrHdl2O0UtcPTmUU4fO8I/TC0/hpspTmXhSyrKpDZAWuuUlRy3SsAfW5BoOZBW/oiXDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=otZCjO/nidx0f7EYgzqfUCuW6sv/kHQHi098v9gL1n0=;
 b=IgeAzCbcP78a3N5yI2SgMho7jyf9grWklm0Tlg/g5h0MpFV5w/DuIaEcYy5c7n5EnLYpT1utTGCBgdkinANSQ++bSLG7timmnyeULUtUDiPgBl3KfC7JWWUvOxXbl+hZBZdaDb63p7+oh7KBTznd1kymWruxlgqWk+vmNW17INpv54IVlx0gQ3MI9AMeLiGqOSBbL04PX/OZw1n0cwfWECOdagx/vyWmdR2fB6sqIVMNJKPdATVa1dC52qRRnOGwEWF7y/oPmEBZtfVQGSHEqs9kqadBZ3h1Pa9Rd4L6lPGDZojKFAXW6iBPvzFhcN45RMr7xMX6vQW34slTeiqBOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=otZCjO/nidx0f7EYgzqfUCuW6sv/kHQHi098v9gL1n0=;
 b=iBPOEL+0l9YW8eO9Y/FpB1x/a8uKdfjf9hCwNJxtS7LQOMNoRtNrKzZvhyRccFAphhsCs0jwZQzD36EHvFKEx3SEtWEc64Kdvmx3y1vewBb9CsN0Z+P3mqT/y2YTjMcLJrp6Twx0BRBUlx8JB32JRdRvA7Vlr4JJHiiQ12DWVVs=
Received: from BYAPR21MB1270.namprd21.prod.outlook.com (2603:10b6:a03:105::15)
 by SJ0PR21MB1885.namprd21.prod.outlook.com (2603:10b6:a03:291::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.7; Thu, 9 Dec
 2021 00:32:43 +0000
Received: from BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::9904:180b:e610:fd83]) by BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::9904:180b:e610:fd83%4]) with mapi id 15.20.4755.004; Thu, 9 Dec 2021
 00:32:43 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     =?iso-8859-1?Q?Jos=E9_Exp=F3sito?= <jose.exposito89@gmail.com>,
        KY Srinivasan <kys@microsoft.com>
CC:     Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "sumit.semwal@linaro.org" <sumit.semwal@linaro.org>,
        "christian.koenig@amd.com" <christian.koenig@amd.com>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>
Subject: RE: [PATCH] net: mana: Fix memory leak in mana_hwc_create_wq
Thread-Topic: [PATCH] net: mana: Fix memory leak in mana_hwc_create_wq
Thread-Index: AQHX7IQ6hDfqEUINL02UEFLUNC++MqwpTypw
Date:   Thu, 9 Dec 2021 00:32:43 +0000
Message-ID: <BYAPR21MB127035BB4732C65B02EB793EBF709@BYAPR21MB1270.namprd21.prod.outlook.com>
References: <20211208223723.18520-1-jose.exposito89@gmail.com>
In-Reply-To: <20211208223723.18520-1-jose.exposito89@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=c00fd344-3c21-4465-b076-ac8feef6df8c;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-12-09T00:31:25Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0f57a678-2e36-4737-6896-08d9baab6a54
x-ms-traffictypediagnostic: SJ0PR21MB1885:EE_
x-microsoft-antispam-prvs: <SJ0PR21MB18858141C085BE9006B08338BF709@SJ0PR21MB1885.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:608;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NdgueZSFzfLnD/Q7z0J113kkl2PrjYngOJkI8HaTUaeXYAZKGTpIwuMzKQ3ozvqEdsVvxqCdIDH0aC6hhcVstvXqSfTw0D8jqr2jSQRLH/CcjvNk284YKlpIJYh0vdTIpTv/w4lL5q0NmvcX7N8A+ZLuu7mNL9uUMpZK8cnKV7pU3iZ37Be36kZv+NPt1ymbmFpSYhG3NXq++cabUQiE/8XfZNZhFR3IE1g0l/4hTOmRCakEr4aP0P6C1UDrIVi2v/TJEFhjoUlEWGDSZE1IjKEsnr3eK2kLv8TTjATpsY0MlR0yundmKisU6K53k5qY+B+4vOfUt76MC9l9yvQqLT+bdW4Ms+gQKbjtoJcvgSi6ypglBRRgi7rwaBg/VdIPxBPw8KI7gEizV1wdNspf1xKwZ26Dpe/So8szl6FBcXhPA0ozwPIhBWTis4nRePNcBcYKgQgQXT7m/M1rcSKA2P+lHmVvj8XXs0Dul9QM5vdRKGCN7hbakP0ibpuY92qqHLgtE59/Wrz3p7hf32A9YonMUXtxEsE2BKAex1EA9ROSfIEqhaDbZ0z9jwePPzccNkvIjTYbn5mAlNL/7txL4jC8RrARsk3Wq56nARNAG+wFkE1I4U9/NFWYt3HZTQcSCnAdgk1nocGcK/ce4ACOzgx6w7morGLsdkTFMSvZn0iM52HkQscqS0yPXNZvmv0R7ZZmVj2wydGvMnTXk3Hbeg0Cz2QGO0TH8R4eqEfylYml4XhZQM13jp1Qt98njsON
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1270.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(82950400001)(4326008)(86362001)(38100700002)(5660300002)(66476007)(64756008)(55016003)(66446008)(52536014)(2906002)(66574015)(71200400001)(7416002)(7696005)(66556008)(38070700005)(122000001)(8936002)(10290500003)(82960400001)(33656002)(9686003)(316002)(508600001)(110136005)(26005)(54906003)(8676002)(4744005)(66946007)(76116006)(6506007)(186003)(6636002)(8990500004)(83380400001)(20210929001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?ISlBzg8ZqloJQiFOhVTNsPbZIHvbwZrf0L1DPPq2Odc8UMDNFN8jontaLW?=
 =?iso-8859-1?Q?6ydIQ9k138gLKWBcshypJXqqn7hmh6xuYUMndj7GmBAmSE+0PnC8EpvTCF?=
 =?iso-8859-1?Q?OVu90X6OMw/20sV5WZhrKxky7Tup7jHmGVAhDq5CI52LTU6FbGu0G/kriA?=
 =?iso-8859-1?Q?vf/s4AmwRQSYo/cbrFxFMHnfMbiyw2ewXBKtCM4/HeIHMeg1V4Vx6fDE6E?=
 =?iso-8859-1?Q?Cf8jxOVy/uwxUFSyVDlFdCf07FUVdepcaSloq5w5ElRdmNJledLCLb+qM9?=
 =?iso-8859-1?Q?DOSpzvffTjBsszzGsMq7sbazs2Js48s0igTg1xtU3LEesxqXOYqRIFd1Az?=
 =?iso-8859-1?Q?MS30QEPd127wlnDI+B12BWfY9WDhSp8VYbkdPC4N13mp23AO3NiKW3HdPx?=
 =?iso-8859-1?Q?HPZRlR9w7pwUW+Jp94emtTxJNcosKy4k0LpTWakQh2DPnsNArpmScygM5R?=
 =?iso-8859-1?Q?t+iJD+oB4k8GPlaDCMh1soohJrY6oxiWQb6QO9EHtO5ht0HnbR1oY+NHW/?=
 =?iso-8859-1?Q?YbzAZRsCc58BcXw3qdk4Vgg9QcqR1EVzJwqil0fJnofNf3I2yaDg/DxIqt?=
 =?iso-8859-1?Q?OEz7S8ktJ+U8Zzj0pKqEeIK7Kn1hQJjV2exNfN9dwLQJWGva//4kWt6q9i?=
 =?iso-8859-1?Q?whjrM4kpNbyIaXqVI9ACHUGzU5Ma4R5UccvCRY3d9q0huKg57JxXFEKZLY?=
 =?iso-8859-1?Q?vnT/TU16f4rGLLEGD1pxgdmNfHvm4efsOywMGgjf9da1w/BSp/kQu1nBRq?=
 =?iso-8859-1?Q?T985rQPKBAT7KoKCmyDnTy+gLXbWPPNHPir+AJNDMgNDZqh67pmHPbi3vq?=
 =?iso-8859-1?Q?iWxkLZlO+eqISUPWj4w+ST9vEP6aihdqTbOue7Z0pQsOrjKoWxadK0Kd9y?=
 =?iso-8859-1?Q?gBScGsN8Zx5MBeMes9Fto2RePQjYcHNgJWnq4uyzQ/BV0EOsLCof06Atmu?=
 =?iso-8859-1?Q?sciIbEpmU3HNiD3S6i84xlNCSuf46kCANac3dm0urAJjUwZq69YbvXsumM?=
 =?iso-8859-1?Q?ONekOgeULV4w8W52iJUnKa6L7fkEQ0HH1WXvoymgQf2eonk/zE6iXXPg6T?=
 =?iso-8859-1?Q?fuClAWb7cQNSmXNZeGR4GTVyn8KeX3d8RtglCioWM9Kqxfpv4kZZd4PYFp?=
 =?iso-8859-1?Q?6VxrHRXCKhjmSkaM4mLL5PSupami3jH8loClnp3SmbN7svOK2gvBhIMlOi?=
 =?iso-8859-1?Q?eM9ZU+TJyf/RXsBJ3mjLd6OlVkjfdqwcVdyonkhNDFXl8QIFoF79F0DTeW?=
 =?iso-8859-1?Q?kLlWgQiDIFqf4hRh/FqfOG99YRtoHsAN5HVFp6uRIWtJg6k/mUJ7ycC4wf?=
 =?iso-8859-1?Q?8Zsq7qEOgr5IlA++4ftAjlU3kD8gdDxu3Ctrf8efMPRlb8DSF1q8NuUB7z?=
 =?iso-8859-1?Q?S29fp8hfGn8bd/6AbRS5FsWqVYcVQa+3So8cWDr30D6kjSWpr29RBONo/s?=
 =?iso-8859-1?Q?7vMa7DZvBmXbk/rmOYqEbjhpdLmsrbo9UIX/BIe1kMG8QtKaej44jOABim?=
 =?iso-8859-1?Q?8fmMCLsblZQpuO6Qx9elQ2Asr6IejA8FKiNwK54ML6yIC/lENJDX9R7N16?=
 =?iso-8859-1?Q?va8iRZUUbJt53boQmuSQ5o3W1T5vlFxLpUDSvEhHrXPef3wshXIEFXBWfd?=
 =?iso-8859-1?Q?q59zC/73ztTSFtb4iz8guSGo7YS3KtlxC7BBjUFbXzoheJJlftCbo7QmqZ?=
 =?iso-8859-1?Q?Hh5FLb7eUATzcOccP7g=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1270.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f57a678-2e36-4737-6896-08d9baab6a54
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2021 00:32:43.4376
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r5NBUXYqGvcUXdhER/hrtskbgLjVdXosFXRQ8Tc71hIANdsx3izlLZ0xI1uvVtLAZFrHKRAZP4RccoSUSR7SeA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR21MB1885
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jos=E9 Exp=F3sito <jose.exposito89@gmail.com>
> Sent: Wednesday, December 8, 2021 2:37 PM
>=20
> If allocating the DMA buffer fails, mana_hwc_destroy_wq was called
> without previously storing the pointer to the queue.
>=20
> In order to avoid leaking the pointer to the queue, store it as soon as
> it is allocated.
>=20
> Addresses-Coverity-ID: 1484720 ("Resource leak")
> Signed-off-by: Jos=E9 Exp=F3sito <jose.exposito89@gmail.com>

Reviewed-by: Dexuan Cui <decui@microsoft.com>

