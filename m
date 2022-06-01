Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96E7B53ADC5
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 22:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiFAUmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 16:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbiFAUmi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 16:42:38 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2064.outbound.protection.outlook.com [40.107.101.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3230C1D5AA0;
        Wed,  1 Jun 2022 13:23:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gKOJoPC5XHOME4J8+S+w8DzoDchE8ZCsM4U50xd7JFYlgLpp2H2/YjHoNNY4vxK9/crvgtZ0gsZX5594GXCLqJ/M8V80PFBH5JV1rp/inLVGTJvTQe5a2D9CrnNJJAomZ1hsyl6WENPv5p1T+F9pG/uQjJtj9YXkcxWTXMT4c1sic+kD0Ii6Q0ee79MVzsP0qrUsrXe1GgkbK8yFKHZIoIPZCAPUmMmAHj++9cpapoHkitk9panPbghUi2jtMwY5gXPzG+qoDMoGd0hVWV5EL0HnzyvfGp0M8s+x6KyzvYeKoIGKCwofsxNzAAQFiOkl9NTM3Mg4oCcd7sRLeStuoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hn60ivQJmJV+bG6M13r5JDBfKGyc96V3puCHuVeolJw=;
 b=nuRgLLW8Te6G+Ve202W3CFvTQFcqLuOwegj99I4nBJ/KNtxVI1RmOONib1lI15nmKDQ4CfAhDvAPasjKSIQEnPjschICyYH2oZV/6Rf20ti5LP1Zih9FzKadKVAfJ6Y9bOLJpo4LxyQQjyvsH9JuAfDxkHff2B2upZr06Xk/XJ4Ac5I+2bd7pS0oZrT/GAISPbFUHs4QJzMK+3xsDJyFdq8IhmVta50ygIG+lgSTEKtsomSE92DjYUwPGIpw4vUrFrS9uECbbxAe4Ua3EnBpayZJnLe7POo5RYRXEI5G0IVJ0rC8c5bjO3VRudsEBAxPoUExoJzoMXL/GFqGWSiBdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hn60ivQJmJV+bG6M13r5JDBfKGyc96V3puCHuVeolJw=;
 b=oD1Fxv94RMEAeBcImSlGOcmmZgRlqKd8sKJpoTQowxX0wn/GG+cYqhTzNwALTowFaS08eKLPgC1kdYYGjsyqgHZaU5fTd1yCPFc4nJ6sWZuCXYDVdQOYuUb6QE6njHhXe/NSPdq/413bp7bOPsQObnwwtpz05x2Fmr5NTgDyBJz65TGkQIqlWyuLk21771YOOd0O3dQAutEC5q+fnX+bqOghhs4a2bZQE56bGPzecoviT3y1AOLARxgmfRhv7DPgitkykqcwZ7HK1aM7lAT2ojhDiO35NCUknVlnqYzOHnqabkRxBTrkciWgGRxqdjcUv5qrMH/GBHkgHaakIxmw3w==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by BL1PR12MB5320.namprd12.prod.outlook.com (2603:10b6:208:314::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.12; Wed, 1 Jun
 2022 18:58:50 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::489d:7d33:3194:b854]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::489d:7d33:3194:b854%3]) with mapi id 15.20.5314.013; Wed, 1 Jun 2022
 18:58:50 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jason Wang <jasowang@redhat.com>
CC:     "Michael S. Tsirkin" <mst@redhat.com>,
        =?utf-8?B?RXVnZW5pbyBQw6lyZXo=?= <eperezma@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "martinh@xilinx.com" <martinh@xilinx.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "martinpo@xilinx.com" <martinpo@xilinx.com>,
        "lvivier@redhat.com" <lvivier@redhat.com>,
        "pabloc@xilinx.com" <pabloc@xilinx.com>,
        Eli Cohen <elic@nvidia.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Xie Yongji <xieyongji@bytedance.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Zhang Min <zhang.min9@zte.com.cn>,
        Wu Zongyong <wuzongyong@linux.alibaba.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        Zhu Lingshan <lingshan.zhu@intel.com>,
        "Piotr.Uminski@intel.com" <Piotr.Uminski@intel.com>,
        Si-Wei Liu <si-wei.liu@oracle.com>,
        "ecree.xilinx@gmail.com" <ecree.xilinx@gmail.com>,
        "gautam.dawar@amd.com" <gautam.dawar@amd.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "tanuj.kamde@amd.com" <tanuj.kamde@amd.com>,
        "hanand@xilinx.com" <hanand@xilinx.com>,
        "dinang@xilinx.com" <dinang@xilinx.com>,
        Longpeng <longpeng2@huawei.com>
Subject: RE: [PATCH v4 0/4] Implement vdpasim stop operation
Thread-Topic: [PATCH v4 0/4] Implement vdpasim stop operation
Thread-Index: AQHYcP5BrBz66eonZEeOxjwIzt98aa0xHKkwgAFx+gCABD0SgIACqRJggABroACAAQ+R4A==
Date:   Wed, 1 Jun 2022 18:58:50 +0000
Message-ID: <PH0PR12MB5481CAA3F57892FF7F05B004DCDF9@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220526124338.36247-1-eperezma@redhat.com>
 <PH0PR12MB54819C6C6DAF6572AEADC1AEDCD99@PH0PR12MB5481.namprd12.prod.outlook.com>
 <20220527065442-mutt-send-email-mst@kernel.org>
 <CACGkMEubfv_OJOsJ_ROgei41Qx4mPO0Xz8rMVnO8aPFiEqr8rA@mail.gmail.com>
 <PH0PR12MB5481695930E7548BAAF1B0D9DCDC9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <CACGkMEsSKF_MyLgFdzVROptS3PCcp1y865znLWgnzq9L7CpFVQ@mail.gmail.com>
In-Reply-To: <CACGkMEsSKF_MyLgFdzVROptS3PCcp1y865znLWgnzq9L7CpFVQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b4a25959-63de-4510-5b56-08da4400c3d8
x-ms-traffictypediagnostic: BL1PR12MB5320:EE_
x-microsoft-antispam-prvs: <BL1PR12MB5320CBC9DCF23529BAC7464DDCDF9@BL1PR12MB5320.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dCn49QPxbJdYjTfpHLo7/hc4GbiHsZlpD2bHK21G2nh352KrTUKnlLqq6P6aEXoG/3hrT5+GYSUcurFmFvjNHEFZSD11qlPRfwi1J2FjNWcE0ZYN94hCu+sLpFx3BFMFrb52DOu1cLsXSS/UW8LgzxsIijPCjbTAGUlwEXInnf54TUWJtkI8YnftCPxv+P0ObkgcBIXzqZIdIXiIJHmUp9+oHWfHzRBMN2eEV75DorSDQD7hGFwkDTWdOoFk5ITzdp6Hmx+GHkEbZdBEfju66Mq8W2cXJnsS1VDg/wilPrZQFHjrxVMciR3hdJnfSz3BhloC7UbaD84T1ho1Ls3B3f2RBu/NXnlBu3X6hvcZwTxmG7rg7hTyhmSI31vpsKLTzqQHxukym8N2lzG5tzw30sc47H7fz+r8lZWZkJaEqY6pDYtD5N7ltQIdyW7G6sajGRul1QEuzdXVLBEbiBuhL0UlCpSLgZtyQ/iI1g1GFB1PnZiXWPxe4i8Ki8G9E+mOcg6Qq3Wl1Ob4SuMcfY114cCr38E4s1QpZnAKw52LMZBSmg30kKhn58LqioMXVYMlyFNC2rBg0SeHwIMeU4nxECvY76anNePXLu2m7xAZH2fCzjQli+8lf9fo3paQKmJ6B+jhZJy0gzhVQBycJvfjV1NQeVX454HqCjRjBV0UosHv4AEu/3pltnZDN4CGJhSmpakxigEFs3NWWeJUdjbwRYufdxyJpocnWoRSwJdWvcvqPnWxibMkcJnIrMqKNRxU+YEEiJt4pIvoVrKhEODoR6N0KkJ1hpsoNe57jKIsrxs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7696005)(86362001)(6506007)(38070700005)(52536014)(2906002)(54906003)(316002)(8676002)(4326008)(38100700002)(66556008)(66476007)(76116006)(66446008)(6916009)(66946007)(64756008)(7416002)(55016003)(71200400001)(4744005)(186003)(83380400001)(9686003)(966005)(122000001)(5660300002)(508600001)(33656002)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WmFPYWpDeU9ERkk0ZlBFTjRsMnJGVG0vNTI0MWNaMnNCWkVHOHpSWUkyWWJz?=
 =?utf-8?B?ek5QM2hBRW8rOXN1QlhSY0FpOG1RS3Z2ZWtGVkFZbENhYnNvMDBqZmNJTnkr?=
 =?utf-8?B?VmdnV0o3K2UrNEdjYWdHZDJEVGpiY1VocEFnYWZON1pLaGYzM3pzYm1HTDJn?=
 =?utf-8?B?S0NNa3lnVWE5ellHNWNZSFo4VDhrSVZKK3FJN0FlbG1xaTNWZHpXbDRQR0dB?=
 =?utf-8?B?a3hOM1hYaUNuZUJ6Y0trN2NRclRnUGQzbDc5azhReDA0ckhHMVErNithU3Ra?=
 =?utf-8?B?VGFpblJFYXhYK2pLNkE2VTh3cTFGbGxqSE10ekpxOFJXM3ZycXVsS1BUR1N6?=
 =?utf-8?B?dWZCWGZrbi9neTRYcEtTUEMxRUtxQlZOaFc4Vlpaa0RQdkZ6Z0QzOERNOVpk?=
 =?utf-8?B?bDJuL2M1Vk9sY0J2K2JTUWFtL3NQcHkzR2kzaVpRUXNxcnA1ZEVEUDY2YzRw?=
 =?utf-8?B?cGFHa1ZIVEFncENnMElNY25YTFhnSkp6SXNxQ2Q1UVRiUVN5UXJEZmlra09l?=
 =?utf-8?B?S3RtVlYzRkJ3MlpPQURlRHpmQWtGYzBKaWhNSjdwSTdINFFDRW1Eb002UlVt?=
 =?utf-8?B?ZEZ0SUdJVHhaYTJsM3lWcG9RYXJEcVN1cjE2ajl6OGhKRmhlVmxlNUptM0Vr?=
 =?utf-8?B?U3k5L1RHcXlKeDArVWhFQ2lrQUNsZjFKZDcxTXpmaHhPenpYOTV0MWlqdXRD?=
 =?utf-8?B?ZzBReXBCSThDNU5Zc1ZFV3V2NlltRE1nVDZKMnZGT0JoUjVEcVhHeHE4SUJt?=
 =?utf-8?B?dFg2ZEh3VE5VZ3AxbEhYelorTURzeTBrbDVXMnY5Z0lQK3gvaUt5N2RHaS9H?=
 =?utf-8?B?aVNMcXk0WGhhWUpUQmNGeEhFTzEvL3UxRVRVOEU4T1JURzh2Z05EWHlselFZ?=
 =?utf-8?B?Q0VrZGVpNnYyaXMvODZEU2JrYjFDU2wxR0tabXFiV2xnMzlsNG5nWmtCYlZw?=
 =?utf-8?B?dUtDajNLZEtEbU9UYXRCRzkySmxWRHJHL3p5ZkU5T2ZnczZ1V2ZhWFRrUHNY?=
 =?utf-8?B?MzJSaTB2S0UzN0pBekJOeDBRRVhLa2NsVmpZQjNmSTQvbVNlUDNvMGFOdVdY?=
 =?utf-8?B?aUdLRTlFeTZ1K0EvaGN6dk1wNFY4Qk9CTmNEZnJxc1RiTE9uYVdGUmYyN0k5?=
 =?utf-8?B?UFUzRTFia2xHcDkvT3MxNEdyMnBZcjlXSnBBV1pDU2x5YnlHWFNQelVPV2FB?=
 =?utf-8?B?bkR2OWF1bGVPSys2RkNPb21rQndKbGR1T1IxK1JtT1VvSE5ZQUFmV0JGbHZt?=
 =?utf-8?B?bFJKZm1LV1hFalBHTStyV2dISDU5bm02R2VRc3dkRXh2M0NiU0NaeEJYVG1W?=
 =?utf-8?B?cC9Mb1lCY2xmZU1rR0tYNzBIS2NiZDc2ZmNSY3FqanhuaDZKdUc0OW1uemx3?=
 =?utf-8?B?T0QvNWpZdXZsQjlTWWxTUGhPdkpPNFhUK2ZwM3BIOS9hWXE0b2ovQVZkY0Ji?=
 =?utf-8?B?RUl5cXNacElNdnR4ME1VNnMremZmaEhLR0ZqemdHTHRFcWJGY3FvdDlpR2VU?=
 =?utf-8?B?YWYwV1RURGNOMGJqRXZoY3drRnpDeVRYVVh3WHhlaGRsc0lTb0FPQVg5VjQ4?=
 =?utf-8?B?RmxPK2t5V3lLd0ROZU1ldmxJVWRRU080TXMxUVJsM1NCVzlrVmgrajdwWlRK?=
 =?utf-8?B?MnlKdjdFeUNRdnA5d3ZkNlJTU3hma0w1Q2hOL1NyV1hGYVZxdzN0c2xZM1pr?=
 =?utf-8?B?OEk0VWhWS1p2UEM5T0x0NFRxV2lLdVJmS01OS3RSVkJ2ZmpwUmw5dXFwSC9H?=
 =?utf-8?B?ZGlsanJLK1BMdHdPUEMxTnl2SjFrN1BNMElGK0ZsME5XSWEwcm9hRXpTcC9y?=
 =?utf-8?B?TW9TMTVUejRVeFp5UjBHYUN5UTZXWFllSDVKYTRDeEhrWHRxSWhTdWh1c0Fp?=
 =?utf-8?B?ck1TbXpGMG9BRXBiWXV5RTJweXR2eDFoNHlVbFBYTWZrdlhyQnIyeVU1dkMz?=
 =?utf-8?B?Qks1aVlFbjVQUGRtTnQ3SlZaWXRIR0YzL0d1UWsrUlp3ZnpBYTh2bDVWaCtD?=
 =?utf-8?B?UDY1ZzF1TlRlekVWRXhOUjVrdlJkTFdHZGJ5NW9PTFZCUVE0bVlyNVZaNmdC?=
 =?utf-8?B?VW8rL1NBRUJYOWNlbTg2b281cWlOMHRSK3pvclNlWERRcHQyYVE0eVNsUWFL?=
 =?utf-8?B?bXVaMnp3ay9XMUVtMzlNOFlNUmo2K0JvQm1jYnJCUC91cWlFaVNLTE9BdXBj?=
 =?utf-8?B?WnNZRTVFMko4N0M4bDNOQUl5K3V1VXVkT3pSVU5qMlUxM3Z6US9mcjNvbVZu?=
 =?utf-8?B?a2c1SnQwZ1Baa0MzU2U0M0h5SXhsN0VpZEVTZzM0UFFrdU5Tcks5aWhXNEFm?=
 =?utf-8?B?L0lMbFkwVUFmUlExRVNUNmQ1RDFiNEkzellMV2lxZy9wQmFGT1hvM0c3ZkJo?=
 =?utf-8?Q?tVxN/wPsS1gaBv+MKGvT99QIt9C99mWFJ3wWSyLITVZYM?=
x-ms-exchange-antispam-messagedata-1: kLLLBaaw3QEQ1g==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4a25959-63de-4510-5b56-08da4400c3d8
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2022 18:58:50.2146
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DMYXAQdqACFd3kqWqB0gg32nP960djVcPVEf12O6ZC9YdPk0vIZYRQDYpXV4rv8g+ERBwWqm2+o4FLFo09K+Bw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5320
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IEZyb206IEphc29uIFdhbmcgPGphc293YW5nQHJlZGhhdC5jb20+DQo+IFNlbnQ6IFR1ZXNk
YXksIE1heSAzMSwgMjAyMiAxMDo0MiBQTQ0KPiANCj4gV2VsbCwgdGhlIGFiaWxpdHkgdG8gcXVl
cnkgdGhlIHZpcnRxdWV1ZSBzdGF0ZSB3YXMgcHJvcG9zZWQgYXMgYW5vdGhlcg0KPiBmZWF0dXJl
IChFdWdlbmlvLCBwbGVhc2UgY29ycmVjdCBtZSkuIFRoaXMgc2hvdWxkIGJlIHN1ZmZpY2llbnQg
Zm9yIG1ha2luZw0KPiB2aXJ0aW8tbmV0IHRvIGJlIGxpdmUgbWlncmF0ZWQuDQo+IA0KVGhlIGRl
dmljZSBpcyBzdG9wcGVkLCBpdCB3b24ndCBhbnN3ZXIgdG8gdGhpcyBzcGVjaWFsIHZxIGNvbmZp
ZyBkb25lIGhlcmUuDQpQcm9ncmFtbWluZyBhbGwgb2YgdGhlc2UgdXNpbmcgY2ZnIHJlZ2lzdGVy
cyBkb2Vzbid0IHNjYWxlIGZvciBvbi1jaGlwIG1lbW9yeSBhbmQgZm9yIHRoZSBzcGVlZC4NCg0K
TmV4dCB3b3VsZCBiZSB0byBwcm9ncmFtIGh1bmRyZWRzIG9mIHN0YXRpc3RpY3Mgb2YgdGhlIDY0
IFZRcyB0aHJvdWdoIGdpYW50IFBDSSBjb25maWcgc3BhY2UgcmVnaXN0ZXIgaW4gc29tZSBidXN5
IHBvbGxpbmcgc2NoZW1lLg0KDQpJIGNhbiBjbGVhcmx5IHNlZSBob3cgYWxsIHRoZXNlIGFyZSBp
bmVmZmljaWVudCBmb3IgZmFzdGVyIExNLg0KV2UgbmVlZCBhbiBlZmZpY2llbnQgQVEgdG8gcHJv
Y2VlZCB3aXRoIGF0IG1pbmltdW0uDQoNCj4gaHR0cHM6Ly9saXN0cy5vYXNpcy1vcGVuLm9yZy9h
cmNoaXZlcy92aXJ0aW8tY29tbWVudC8yMDIxMDMvbXNnMDAwMDguaHRtbA0KPiANCj4gPiBPbmNl
IHRoZSBkZXZpY2UgaXMgc3RvcHBlZCwgaXRzIHN0YXRlIGNhbm5vdCBiZSBxdWVyaWVkIGZ1cnRo
ZXIgYXMgZGV2aWNlDQo+IHdvbid0IHJlc3BvbmQuDQo+ID4gSXQgaGFzIGxpbWl0ZWQgdXNlIGNh
c2UuDQo+ID4gV2hhdCB3ZSBuZWVkIGlzIHRvIHN0b3Agbm9uIGFkbWluIHF1ZXVlIHJlbGF0ZWQg
cG9ydGlvbiBvZiB0aGUgZGV2aWNlLg0K
