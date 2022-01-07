Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4230F487B92
	for <lists+netdev@lfdr.de>; Fri,  7 Jan 2022 18:42:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240289AbiAGRmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 12:42:00 -0500
Received: from mail-dm6nam08on2086.outbound.protection.outlook.com ([40.107.102.86]:49780
        "EHLO NAM04-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S240245AbiAGRl7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jan 2022 12:41:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HeqEUxIRlzUleDj9B+PcqleZYNzofU4Gs8wPMGIvZzHkBaBT1RNWAcZ/0L5pepFgxx8j3YZIBwiBmTDXijFGowr2mMOqFcKHfMkoSMEAqjM65oxy+w5eVD6cqKpDc3+YKYfBTttQxyA0jKuBW7XWxrCZRuUNw8pplGTOfdFDpIdLxmnc3YxDoP90umNLyL5uYZUslB9TGqiiM5NuVXcfmi9w3qSDij4++TP62uV0oUaYWMj3MencLcB1l7k4y5MzFngEiLFh5PPrMTMslOLaoOYbRL+JnlO1MbGPEbSuKG47TZMhRgkuuLZok5h45Pog5A7qNMrYJM6xbym03++AgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TowZkR01M1MmePqV7cgTFxmrNLvMDTFm4IW54O98Yfk=;
 b=gaqq/kQ+YXHuS7B2URV1FFX9bKFPUGvc6aBJzeruZinpjhAU6wzoX83RrbKrP0PSVoJ4YUkEMe288r7kRnRDVe5S2DhF2Ksshlu5uEduDqi0oiw361DSTALVqSin+TzApKvIGhPPOaPfh8KnrXK7seZ50jFybqvw09qUkNj89jNK1cqrDqJPbC1xVvgojeLHXllx7yswWp42p8WmXUEnA3kVSR6/HYaV4NhqpsPo9q987vvzWr2M8nEEzI2nwmdhtzaWmcCGSfQb4ro0dDzDc7lvihAwot0uV84bIA8uO0W4Tgd6I649DwbqcyoF2sfNdC12mtGd1oY2oy+GiKv5yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TowZkR01M1MmePqV7cgTFxmrNLvMDTFm4IW54O98Yfk=;
 b=W3PkxezNqh8Q/4/D0ilulCSpWyk9J7+16ekfk6w/nQoCaO19iP/MtwU7NNWh2uLU6NLiL3P66wEPN7pAlJeaE3A8+RLsTGEYRDLH/DWDQawRzsDfOFq+AXAHi2B4WAicM5yD61TYvekKptK0zMHulDVxkGbO5IhlhvG2OQuokgXI/bb/Q5e9kt8DmrtBqk8eetZkrTuTCt4F4j13fcJ6T+6Aja3N/V7Jgb9nhMFJf+eGQg1/sgF0P8g2nQtPIOqBMVlZd0PSLipIX87zS957g0LH4PqnRCAd/RiM/e+yV3KbPrHD7YyuVSOnU2kNaIpgU1I0M0TRdLU+1qqtN9s+aA==
Received: from DM6PR12MB5534.namprd12.prod.outlook.com (2603:10b6:5:20b::9) by
 DM6PR12MB5536.namprd12.prod.outlook.com (2603:10b6:5:1ba::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4867.10; Fri, 7 Jan 2022 17:41:58 +0000
Received: from DM6PR12MB5534.namprd12.prod.outlook.com
 ([fe80::d807:741:72b1:89fd]) by DM6PR12MB5534.namprd12.prod.outlook.com
 ([fe80::d807:741:72b1:89fd%6]) with mapi id 15.20.4867.011; Fri, 7 Jan 2022
 17:41:58 +0000
From:   David Thompson <davthompson@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "chenhao288@hisilicon.com" <chenhao288@hisilicon.com>,
        Asmaa Mnebhi <asmaa@nvidia.com>
Subject: RE: [PATCH net-next v1] mlxbf_gige: add interrupt counts to "ethtool
 -S"
Thread-Topic: [PATCH net-next v1] mlxbf_gige: add interrupt counts to "ethtool
 -S"
Thread-Index: AQHYAyL132wckj2nsEmOcpYE6TswKqxW4IQAgAD0v/A=
Date:   Fri, 7 Jan 2022 17:41:58 +0000
Message-ID: <DM6PR12MB553445B69CEA2675BAA69EF8C74D9@DM6PR12MB5534.namprd12.prod.outlook.com>
References: <20220106172910.26431-1-davthompson@nvidia.com>
 <20220106190516.147e9e32@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220106190516.147e9e32@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 48a36b7d-ca3f-4550-db6a-08d9d205011c
x-ms-traffictypediagnostic: DM6PR12MB5536:EE_
x-microsoft-antispam-prvs: <DM6PR12MB5536694B6A7067F06C14897AC74D9@DM6PR12MB5536.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ry0XOVM6rmGJexHHGzIAOBJu9PTwIDZ1s8yI/oDRv+JqqLw2Hk+VvSgCEGFycJg7zmE+WK/B/V5pl6A0rGC2RBWg0aO3WTL3gelNOA7MBqMMu2vfPiaIpWkGPxO78K5yLnnLskiod+ulL5v7jyuRL7WJTQWi54FcA5h+Pmt0ortJX9LaZ17ayl62Pc/KhiHOB1bpS4wLK6K8bhmBp+8xD7BpxuCU4QVG7h+qtuJsqmBLphq2hEcUNYQuf06GUr8OxREdYoYKhrb/xBe4CLo1XSSEhAq9AZjSbo5tDFBaqFTY/zow6stlvJ4D57q7O7DmsvC3mwUPheailA4acMCQ5RlxeHtKDuertuqzF/CTm5NpPacqn+LMYiLToYdpvfdRl2sas7IaNyDJCRErxYxjVy2SjK8h0r5/CDTnDOjbGbCTyHEJz+l6sn26R+YyyzTzirFZg/vNrEwPi837wLDL2hsNZAnWsmiBW9MkGUCRhSPDGUhWBunWTFJMlj6Zw+1d9M7Hf4vb7lqlSlNMLLZcBUYEZ8Thtc2GUX1JHsOVe7hfjR8ZgRqXc0sjGAiP0+IuevxssAoqnlJojgqTtWkSKfNNsP8lXm2cdyyuN9QtZV8xTz76OcSxKIoHuIwmXtDlhmIB8Pp0yBv/0d33qbCVdKwwNobldcrYUq+THQYb6sfmLOUp/W+1heu88rVtr+9aj6Y8wHylw899C8qZy6PIEg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5534.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66556008)(4744005)(66476007)(64756008)(66446008)(2906002)(54906003)(76116006)(66946007)(55016003)(86362001)(9686003)(33656002)(6916009)(8936002)(6506007)(7696005)(8676002)(186003)(71200400001)(53546011)(122000001)(508600001)(38070700005)(4326008)(52536014)(107886003)(316002)(83380400001)(5660300002)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VoXQZ90vxTmzcoEeZ5M75t31fyNsA/pDv/8SI2HONT/NlAjs/jEa0yGHK9z/?=
 =?us-ascii?Q?+EXgwh3S/zHbPXQZSZqTwiApcc3/CLJaLmkKuhjj2IYCIxslx1n0h2/iC18f?=
 =?us-ascii?Q?6BKPDjfqSAw7Wkl+gSrwF830p96tKno4K0rDmKf/theQrCe8aefapxw9Yhnk?=
 =?us-ascii?Q?ahEFHK5cUv+hLlZ8SA69U+aJNDiz0ZwyomKoRnsDKTvHYI4wzJLkkkF2zUZG?=
 =?us-ascii?Q?pcZz4Qcpe4N8J8nE6JtWu6Z+kLvbDSqDSfrgeVjysZ6j4I5Kw5WMO5wuFgBk?=
 =?us-ascii?Q?HmcJ4tQlq0W7xb7aXvg87oS0+e8Rc/feouTUnvst1Id21l3fiC1BECGnp6cM?=
 =?us-ascii?Q?Ip0dCRpKmkrjzpOsYqONQAd9NUVDUvgvj3X6GaWsNEjSrw5AanUC4JDMSWE0?=
 =?us-ascii?Q?CcrH2qYUFOUsQw5IV4MaLNedHCOQP6qoQ0LsvaVCV5qjDtbUXg4xABVhwrdU?=
 =?us-ascii?Q?X57L+rWrFNMR6HyqtaabXjx0VwkKQaxdUQs9o2UmRUOUKOrc4kotJqnTwuZe?=
 =?us-ascii?Q?L/ilOdxJnN3Mwiwf0UpP6A/MyPfngFAZzryaH+TbIuqkKtVEckO8hFFUOXEC?=
 =?us-ascii?Q?KC3S5mwx2qqVX7VF2zh3sPf0EyJbD4Wbc0rXy61Ny+qUcfOnLmHyqizcHN3q?=
 =?us-ascii?Q?xVcbwVQ2coKK41b+dFGUl9dkHJ9OVucVJ43kNXlEZeS+fvDBfeMepCwikmuC?=
 =?us-ascii?Q?TvcM1FNMCcieSNPaMEkzkksyyeUhcbYfscclwuWOOxZWvkyzvsWicuchHpKo?=
 =?us-ascii?Q?KGGuQ95vQgsCmWkWe7LqK7mRphtxrdVttfT2ZbagNKdn2uCZ19d5XoO0Kkb2?=
 =?us-ascii?Q?bBG/KzMRCJ8mHvgy8mB5NoUCJ5Jvas0shuW0ZfdqeOx1zCYr+AaR15FL1qPW?=
 =?us-ascii?Q?kEymImOqlCGnp6R5UGGKGXSvvqm54fDkmslaX/qWEfoKui5ZwofFpN16K4Rr?=
 =?us-ascii?Q?dUVdu6oM5FwWr9vJcob7tShdPKBWKTGSV8ppSAdfQdqSy5F8OgkpzC3MuXQq?=
 =?us-ascii?Q?PUteHRgH2v53C0zB1KqFoSl25U3Ev/62AlcHO1HjPKdtCrLwknrM8EB8q+DU?=
 =?us-ascii?Q?LNCNLm7fVKp2okmWkFgseMbWE8rhcafAWQ4YxGIjauP4To/hhugZbGFSEZrK?=
 =?us-ascii?Q?gip5eBK94S/3xktt3MdYyX9kvZaAuw2cjDoiFAdKg8eRKvTJExv1nyRbAA24?=
 =?us-ascii?Q?zt2xORgKUw9MmPy2PxeeJxae7tIhqCOepJQVrc9OVny//fyUrj8s+KIprqYl?=
 =?us-ascii?Q?uOMkLzZB+3rqXRvS7JP4GeaDmdypTI/WF/6wuhmPEy7KBv0Qq8UX1h0NI0fE?=
 =?us-ascii?Q?kEfES8h5qtouMBVGIaXFRoqUpZBlNGraR101patO8Vs1cWLMmc1JjXId13Ch?=
 =?us-ascii?Q?TrPZU7Ccv48PxSp8oWdqBnetfL+ue5eF4wp/1RAvUGLe1jvYsEelUVxF44fI?=
 =?us-ascii?Q?9PTroq8EDDe90EpZ075IFBJwdKojQMzDP4eKazMOEUO5MnvlTyzCn4pIT8o2?=
 =?us-ascii?Q?PcVhqmBTsFLizJGLW4KZnlaV4xL+KvPRQ6UDqwGDOytGXkifDGEY16pG77o3?=
 =?us-ascii?Q?jqm1QgSBbIk6YE3PlSNivgbVWwTeVN+2MeOoLoVvYsYu9f5fVdkq284FzOEd?=
 =?us-ascii?Q?hJ9oOM2M1swe34jNQJ0nEiQjPDWN0SJE81TUeVuAzQ9HcAYe0Dk8+RZvO3IB?=
 =?us-ascii?Q?O69fQg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB5534.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48a36b7d-ca3f-4550-db6a-08d9d205011c
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jan 2022 17:41:58.4348
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: h+DysFxVWxvniOKvB20gXJeEUbgltDaLxwMjn0CHV1exCmrX3qK0v2Yy7wr+XDMLVi7nN+B0oR7ecXkIgjlG0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5536
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for the review Jakub.  Will look into removing the counters.

- Dave

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, January 6, 2022 10:05 PM
> To: David Thompson <davthompson@nvidia.com>
> Cc: davem@davemloft.net; netdev@vger.kernel.org;
> chenhao288@hisilicon.com; Asmaa Mnebhi <asmaa@nvidia.com>
> Subject: Re: [PATCH net-next v1] mlxbf_gige: add interrupt counts to "eth=
tool -
> S"
>=20
> On Thu, 6 Jan 2022 12:29:10 -0500 David Thompson wrote:
> > This patch extends the output of "ethtool -S", adding interrupt counts
> > for the three mlxbf_gige interrupt types.
>=20
> Why? These count separate, non-shared interrupts. You get the same stats =
from
> /proc/interrupts with per-cpu break down.
>=20
> Since core already has this information rather than reporting those via e=
thtool
> you should remove the counters from the driver.
