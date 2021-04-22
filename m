Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBE2367626
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 02:18:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343865AbhDVASv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 20:18:51 -0400
Received: from mail-dm6nam11on2104.outbound.protection.outlook.com ([40.107.223.104]:2112
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231958AbhDVASq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 20:18:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c5K5XYB2XjiP1ajUSMexcBojcFaMR/8Cz1ehe14f9KES/I8UtmGVTD/P6tHCjY8pOjB8NQHhRF+XES8VPw4CZ0YVT8becktrQwMfO9ZKhmg8L2anbqpPw58ViKI3GmgRZuVvgiKlIutyBZ4BntbhYe5r25ViFQpR5FsLlkrM33kaD4dvsmuQ9mTtLfpDkvz8JDu2j/JBk3jcn/bdlCSWgztTWg8RalbfuQc28N7JprXG1jg/sW/jrObxJOG+JnA+LVFfL9wjkCrfGm+U4o27gccTiJjYQE3vawK20M1AYqJCFXEcBIjhhFw3RBLiMb3N4qs9sZd1qQEBCSNPww1iGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a1ZZ9jf84gwUkou7ZhzjXa66Xsz3uKjM7Q7UBJjZfbY=;
 b=nhJ18iJdGIFd12E5fJOhhzBXtakS5+mO/zD1PrlIqTzyZ5Pxs/kfqrDOtTeJssqxQBMbr9LUHl2X3BO76Ot3hUOd/Ey4w7OGA3xAFbPV21eO9P8NVe7N0ttd7XBYlWCRiJpoYWgLccS5x8mnL1v/rBDRiaWTHNvTOtJsHrotYGY3OTUq0gjBKma5GWsURLz47XMuHvcLcx8LGHzHitcs08KdIHMkUH2NBUp3teQN+xhJa0a4ZaPylSs+QrXrdsK8bYSe6t4mzJVwa7y+gLt3PiO+yXIj8n5ev0Lw3gZ1HrsBi8BIetbWI8X/GyFiDr6WvlvHg7emBOJSb1vsoTFnlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a1ZZ9jf84gwUkou7ZhzjXa66Xsz3uKjM7Q7UBJjZfbY=;
 b=aJwjMlpF875pQEOwj8f0a9W3lrfX8BvKsq1CeIibWVqYGMkPOSVllOzZHTfxcMdFI22mMEeaNO3HwtBF/44e7kkVjQvCxkLwPTBWbnUa9TftB5IFaq5KIJ+wFdrhbRJedlPybZ6gFAy4HORdxTC381OgXD4FKJ8Zvs3dcUDAW8k=
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 (2603:10b6:302:10::24) by MW4PR21MB1905.namprd21.prod.outlook.com
 (2603:10b6:303:7e::6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4087.9; Thu, 22 Apr
 2021 00:18:11 +0000
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d]) by MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d%6]) with mapi id 15.20.4065.008; Thu, 22 Apr 2021
 00:18:05 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Stephen Hemminger <stephen@networkplumber.org>,
        KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        Wei Liu <liuwe@microsoft.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "bernd@petrovitsch.priv.at" <bernd@petrovitsch.priv.at>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        Shachar Raindel <shacharr@microsoft.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        Joseph Salisbury <Joseph.Salisbury@microsoft.com>
Subject: RE: [PATCH v8 net-next 1/2] hv_netvsc: Make netvsc/VF binding check
 both MAC and serial number
Thread-Topic: [PATCH v8 net-next 1/2] hv_netvsc: Make netvsc/VF binding check
 both MAC and serial number
Thread-Index: AQHXNTQ3wllrslXhXkux4l9YQOqs3Kq/rdoQ
Date:   Thu, 22 Apr 2021 00:18:04 +0000
Message-ID: <MW2PR2101MB0892328D0151C3983BD7EAC8BF469@MW2PR2101MB0892.namprd21.prod.outlook.com>
References: <20210416201159.25807-1-decui@microsoft.com>
        <20210416201159.25807-2-decui@microsoft.com>
 <20210419085348.6f5afd0b@hermes.local>
In-Reply-To: <20210419085348.6f5afd0b@hermes.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=ae00d4ee-2af6-4a5b-9ea2-1ca014caf706;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-04-22T00:12:06Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [2601:600:8b00:6b90:688b:1c6e:a2b1:f6c7]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ebf88276-2717-4abd-e472-08d905241942
x-ms-traffictypediagnostic: MW4PR21MB1905:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW4PR21MB190530BE62294C9171C41C18BF469@MW4PR21MB1905.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ard28Ig7AvBhphKr3cxn8lgGdLvLiW262MUUO8Sj4ymaCLL1R5fy2I1lkd+yEgIvCu73pVX+JeyREmxUimf6kxpHWYc1J0xdsud+Pe0fjc74ZCcV8QSIrRU30kZZJwMSnsvF/0BI4YKsQLJvl/FQC2QOP6QMmadPdnTRGBGeCMF25POXEjQJg6xnsXOnZD0E9yrmuEaqAuasCl5qs3GEnRvjOMh2hOh91pc1MhA03P9cOwjzAXW1I0UydYSxPHw7Y/lVjBdJfhqYx7iTbAI8Gz+BQbJuvWyWan5GIyOnyamgEUFqjQa6Ly8h/DFv4vpNY0u/JM4fs+gf+vjH5q2HEiwwly63DXsKsBgPk85YsaHNWw3jtG0fM27d3g4YUA83Z9hcKoUxz17LHFnJVgraiRRoPtzajsVWpx9jXq4ZfblQwqwtqhUEPKElre/xlA/DpBtEhIjCeIOlrec1fA058us3fGwkYMjfm7Sh6wcm2CRISV9GXBiRuU/eDyz04hYxxqmPXQQaoX/E1n0FA8ToEE9er0aFmkXr4C8LCnJrnxDCMPlSl/1p9hqEy40Z6D1ve0caQ0qFlfiYejpR7KwT0tKDtgKsppC8ZdQLL6o+xcI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB0892.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(316002)(110136005)(54906003)(66946007)(66476007)(478600001)(76116006)(7696005)(66556008)(2906002)(33656002)(8936002)(86362001)(64756008)(53546011)(10290500003)(5660300002)(66446008)(38100700002)(82950400001)(82960400001)(122000001)(107886003)(55016002)(8990500004)(9686003)(71200400001)(186003)(4326008)(52536014)(6506007)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?P68W7y2/4OL8OrEIO3WrYzm/pxYClbAwuRJ+qXVL3OzSjQk8mWJAEFZUicZI?=
 =?us-ascii?Q?04dcqrR035gpoVbLwSef5LbIk348ay+KDJWgL25+X+cqU47d2/ZhS793TpIr?=
 =?us-ascii?Q?lwUvX21Z5uKtZEirgSk1b2viCeyFS9JgptMWzuH1LWCtRArJivWMnI/T8sLj?=
 =?us-ascii?Q?yh8bWY0ar5gtrs/PxpxP5EYRpZohJEZMSg4YYI5eTFk109E2CG231PM06EaL?=
 =?us-ascii?Q?+hgYM6R5R9gmeAlbbmMIspTS9GUtp6zDKhQkqXJBCxg5Wx7wXgKv8jREmBKh?=
 =?us-ascii?Q?3UqPW7ekZoGdYtTSekkUNXkq3/WdHE2gIcaeMHCrIxepca/l8U4rald9Wi7w?=
 =?us-ascii?Q?UKRUax8tkLKP5Qr9Bf6/PNaVp55bJmEfPZ+Oi0SWg8TsBjpNLXnaTPPoRjMP?=
 =?us-ascii?Q?F/i9I7pKnFhBgN4Z5OjrBX1RUcpUsKsYRwVmQDMsJCEtD9ZSy6JXx+BwDiO4?=
 =?us-ascii?Q?Oa5B8uQoaEnzoPprUSZApfMk3x04hQdQZLbuhMxQIwFrd+X/vW+uf3zTLoew?=
 =?us-ascii?Q?uTMmVp0gtV+BFUWmixrQmbtjZby7jYFTxWHQoOw6+lDGbtCj4GPQqiznsGMv?=
 =?us-ascii?Q?3qwiDNZ/V7GkVB4S2Lt6VclbtQwPv+2HgWqknR4QoBngGhj1/phcZ8xg+Kfh?=
 =?us-ascii?Q?oMzKkeqJ77xd29U++z/3DONuFJTQzNdsoZsO32EoBtLl9LUpYx5mIVoOJZtU?=
 =?us-ascii?Q?o9kXjBZ/MkRNH+m5CCLQxCZqCK0Lgv53wBhalCAuqFMNqORKazRiFDMgP+LU?=
 =?us-ascii?Q?UErYyGAgeODI8LTxkTQAm20st99gBlTlbdjLLej7bNrMmTjTCun7NGIvb67j?=
 =?us-ascii?Q?N13HaQsfDYB6mM06Dy/9+zQSW4QWYgjrAhN1cXfWwXZrETAn9mi1xo+JEVUq?=
 =?us-ascii?Q?doPQLTazpWvKTbaKWrZGcBxJZmSYqDFoLGMIM++x24zh4EM7hOAL03bY3Ps0?=
 =?us-ascii?Q?4xSlD3Ic8Q1kl60APoVqzCw9P0uvUv6fqQvrgUVS0YF/acl4ztucsRLlVTWn?=
 =?us-ascii?Q?mV32iVO1A8cWn1bI6Kjm88dWEq0EtYh2S7Y5u1f4W1LsD+m9izsxV+cgJr/Q?=
 =?us-ascii?Q?0bFgBsBLVEtVD8RCB+knN1XyH346QtGW+Ze4VrNL9O/K2E3C1vHVBRmS0iy+?=
 =?us-ascii?Q?EM6fGXsX+lSY1QpLbss/srPMwyF+GoafpiW4daWZpwJRhIqEtVo4HTsSLsES?=
 =?us-ascii?Q?oWyeot6mHjlb+ANNzI/OEHjbnjzfh4lH1UyieO/0JMuNxKPVegUqReZsbFlG?=
 =?us-ascii?Q?TsG1JnipFI5Smew6eECC/CElieQid4r4iz03e9bI1xPgUO+UmU8B/f/pHrNQ?=
 =?us-ascii?Q?GZgNJTy9s2qXjATPtuQt1g9jqQDtF3dvREgpgCRtVMlBJdVCzhHI1EtQkpGq?=
 =?us-ascii?Q?+SoseBsJzZyRlA7M+wxjRKagfo3g?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB0892.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ebf88276-2717-4abd-e472-08d905241942
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2021 00:18:04.8772
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L+Sjut4pcm5Pvm9Tj/xZAv6Znyoi7uHW9qsve33Ue0pUHHrje/jnw4EBJItSHhW8Ygr86RBVfs6KKw4+v+NBaw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR21MB1905
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Stephen Hemminger <stephen@networkplumber.org>
> Sent: Monday, April 19, 2021 8:54 AM
> To: Dexuan Cui <decui@microsoft.com>
>  ...
> On Fri, 16 Apr 2021 13:11:58 -0700
> Dexuan Cui <decui@microsoft.com> wrote:
>=20
> > Currently the netvsc/VF binding logic only checks the PCI serial number=
.
> >
> > The upcoming Microsoft Azure Network Adapter (MANA) supports multiple
> > net_device interfaces (each such interface is called a "vPort", and has
> > its unique MAC address) which are backed by the same VF PCI device, so
> > the binding logic should check both the MAC address and the PCI serial
> > number.
> >
> > The change should not break any other existing VF drivers, because
> > Hyper-V NIC SR-IOV implementation requires the netvsc network
> > interface and the VF network interface have the same MAC address.
> >
> > Co-developed-by: Haiyang Zhang <haiyangz@microsoft.com>
> > Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> > Co-developed-by: Shachar Raindel <shacharr@microsoft.com>
> > Signed-off-by: Shachar Raindel <shacharr@microsoft.com>
> > Signed-off-by: Dexuan Cui <decui@microsoft.com>
>=20
> Acked-by: Stephen Hemminger <stephen@networkplumber.org>

Hi David, Jakub,
The "2/2" patch has been in the net-next tree since Monday, but this
"1/2" patch is not in -- can you please pick up this patch as well? This
patch is needed by the "2/2" patch.

Thanks,
-- Dexuan
