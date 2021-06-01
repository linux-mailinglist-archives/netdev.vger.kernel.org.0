Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01058396A8B
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 03:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232412AbhFABMV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 21:12:21 -0400
Received: from mail-mw2nam12on2058.outbound.protection.outlook.com ([40.107.244.58]:60533
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232035AbhFABMS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 May 2021 21:12:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FN2SaryJvNrTU3CZJ9IijTuak40BqRqFMnBMpnmBDdN/e0gBqcZdwdKj6wiur5MmwntJYDvVrKdC1wm3KRmstZbQ+yz027vI7ZSpTVfYydEBS8XSZegQ1Q2TxmhTA2+cnqZ4s0Vn2oscuw/qvAy3rx/m4LfB0bq8w7EpRlA4MTEhjqiHndaewdXyCpo1dtIY+FjD4Rq7C1NS88LzKiuWsn62anNgfUalkNge8W0GuZzG7RBElHLx3NUej2ZxedvdLfqDIuxTGDrDMOUAPHS9H0Jfl79X94KXLXbUEgiFnzJMmgI6pcN50TNz3/jzQkKkCqFvWBzSQY33XcSuaOIZow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vHhDzeFYJbC5Q0Y+Zg38GgLQcY1e1LRQe1afdY2lPpo=;
 b=a7cLlOoj1fWweHC69q8h13rHrefRt9GnMd1ZXFK8vJjOtk4IbAjbgG6Ad/rC3/ZNKPEZLqAvXpiabRnIAcm4I1J8v57M6sG5vyTliSIPXTZcxzuKS9tPD/bFUOKPN7Yca2po10iIqAGxd9SajnoflwCc+GNsjeTIMhTcoaH6meNZQi4yX1pzyWoULqPtRp8RbheM9sy3PNhTT8j6Zkv+M0k6O54WP3ULpLsTWbxUwe7YZrdwoF5kOtmEwacAMR9bq5HsR9/ENUrF4CB8rnPpxB3EZc7Pv4K0CtEgtg+pTSiVXwPMfL2dq8IoOZah7z5AIhrOV32BGLsDBym//RoArA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vHhDzeFYJbC5Q0Y+Zg38GgLQcY1e1LRQe1afdY2lPpo=;
 b=G9IQd/aoNVYeKH3IrY+cHiIIxUzTwi/yElD6mOOmF17dZ6ruXjuxEgjAorh+gJDpMqyUQp1+tlViJLydC8rAcCuM1ta91EqRaqEOjbGvqnHZiTwG/DF/OS5XtrYkJS3Ji5uTrpX3viMLRDyjvYEVzIVKBOSV+Sw4AP+by86Ksv5Q6k68QNtf9/+FP4EiqnT24ZS61Mq6IHJBcRtDAhyicD/BDTkQpGF+yN+uIBWOEl3T4cLLgjHoX1H+YE2bntAgwxN6sP8KgjhY/6LAlThB8PAKEBjtLZkBPRddayXjnIyX5ofvBUmUEVHjoEANxWVLljNkePHhtuYkEaXJ5zII8A==
Received: from BN9PR12MB5340.namprd12.prod.outlook.com (2603:10b6:408:105::22)
 by BN9PR12MB5097.namprd12.prod.outlook.com (2603:10b6:408:136::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.22; Tue, 1 Jun
 2021 01:10:36 +0000
Received: from BN9PR12MB5340.namprd12.prod.outlook.com
 ([fe80::d41:8407:ca2c:be6b]) by BN9PR12MB5340.namprd12.prod.outlook.com
 ([fe80::d41:8407:ca2c:be6b%5]) with mapi id 15.20.4173.030; Tue, 1 Jun 2021
 01:10:36 +0000
From:   David Thompson <davthompson@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Liming Sun <limings@nvidia.com>,
        Asmaa Mnebhi <asmaa@nvidia.com>
Subject: RE: [PATCH net-next v5] Add Mellanox BlueField Gigabit Ethernet
 driver
Thread-Topic: [PATCH net-next v5] Add Mellanox BlueField Gigabit Ethernet
 driver
Thread-Index: AQHXU/jmO7+em7bwTECTswzcc3JPcKr5dcUAgATnZbA=
Date:   Tue, 1 Jun 2021 01:10:36 +0000
Message-ID: <BN9PR12MB5340F9DC21DA0F1634279F82C73E9@BN9PR12MB5340.namprd12.prod.outlook.com>
References: <20210528193719.6132-1-davthompson@nvidia.com>
 <20210528151442.470bbca7@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20210528151442.470bbca7@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [24.62.225.91]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7136ec21-a97e-4c9d-fd80-08d9249a1059
x-ms-traffictypediagnostic: BN9PR12MB5097:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN9PR12MB50973439F350DA5C8DCB3E97C73E9@BN9PR12MB5097.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RtuJmpGz4ql516BI4pvFQXpLu7TxzqJUGial5zS2m1NGAbZ2PuQk607HtLpjE+SMCnPObB2lsLeKRhpLJQy7S8f4Jmowz1KjnKYsGGo8Kc157IrrssbzQbMSMJldib6khUJz3IFDTnvWp7IF/klibiH/fy/IVhKGDdgeAcuFUMhjJlMBkb0sUhi60rQMYkMN3WNeTvaTDlr/MfuddSZw1N1/XsTAFCj72pUZM9F3/1me9mvNIPYs3cuHxD6BcJ1+rc1v4FlQMvjTaSzHOZ5E5uRcYH4XHJggQoIEPn+1syvGUzg22GqQZEJO/rYNS5cRgzNvCbeR5TAOdFNsqGHUd7ggnMqNRkUoWwP/RCkRvpt82ZoYNTvUJQrGRLSJivrc/1BfbSoJUe/I+Hq4kM4aaOSmkWlXfp7B7+mzKAXvHHogBcKGz/cRii4ns9HvELErK1NkJv/6Vv0LSdmpRBI1d3Eq6FSBEv1IhzW8WJvYUdDm8qgvyIE/WpdAoNohvrt8QBqi8TsqvwixSLra83mAb7t9CPA5bahMQaBPG0teLWjkddm7Wzorrj69Kk1IvTQVW5SWh8a8/5TmZbXmxngpzj+GhfXq4tZY6y5B4FZO0BY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR12MB5340.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(366004)(396003)(346002)(5660300002)(71200400001)(2906002)(9686003)(8676002)(86362001)(66556008)(316002)(107886003)(66476007)(38100700002)(66946007)(53546011)(66446008)(6506007)(186003)(6916009)(64756008)(33656002)(8936002)(54906003)(4744005)(76116006)(83380400001)(52536014)(7696005)(4326008)(478600001)(122000001)(26005)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?3Bt2k3w2+ic+vCBrWfFenvZgLwYSYBrL/oaj6gx+1kHdbG3zPFBX1if11QC+?=
 =?us-ascii?Q?QUwM9rY2p873/pVwL6zq6Ye/6oy7G3quCn7xswzUVjrFgHZA6yVXKdvR7ZDT?=
 =?us-ascii?Q?CQqd8bxRYfBonj3z5RmKsGnGaPzATwHXmGRaiBN4pwhO7qro8Bau4odjN5Yt?=
 =?us-ascii?Q?j1OXqZbV1vrklBQf885zMDJ2ZVW7IhlcJmQBRd0oFaKDdMF+Mydnyzu2pabU?=
 =?us-ascii?Q?NtfgjpnWB3m2TV80hzhJ2D8aaQiMzayPrEx7P22M6wMNMoqi2VRNlwZKqiWm?=
 =?us-ascii?Q?XkUbgTCaMt4ZGH19jN4pp6PaU0rzxPm1CqnsMOp1uhonJX7JKS3d+cl/skn/?=
 =?us-ascii?Q?6jg7Be/XOEpUwZwj9vjp1Duj5hrKq1kXlPI6syJisKJRl7lOcBhzRE3kyHDp?=
 =?us-ascii?Q?lg5ox1nCC6gRYRjH5nt+cNxJQ2WFZKYVIe0Oe4p5qj86h+n00T2QedjjOayA?=
 =?us-ascii?Q?1xQa30NqphHSLtbZhAMUxa1aHfX46Z/G+bakEDZmTCRbjXCilKgNqtq3Mlwh?=
 =?us-ascii?Q?k6/a4EPlLVmIEjdPR7NGQNOwvqBp654g9MbpTgbkaq2FK0XLyITX0UTTlfF+?=
 =?us-ascii?Q?UegFn3G8TlullL5caI7E6sGoyPHzI3u6gSBjuA9VqPFAKBKzDiXIwgGWZMHZ?=
 =?us-ascii?Q?Up4tiooChehLNeJJ/96A2JX8JMWp7I7lnSDQZDP+bEcZTh5XF2WLIbgSGZCk?=
 =?us-ascii?Q?0EWXRF+mDbhQlizbhmxZvrQ3Qpdv7LnXSn68Nm8r1Hoby45HgRCWoeQANhv3?=
 =?us-ascii?Q?8Bz6N+63wJ7VqJo3PfljM/hsEcVTkFD3GSeLYa7DTES53pl/6vlmJu/Vdcs7?=
 =?us-ascii?Q?12jY9lhbVZmFXBgB9f+MPMGv5LYHlVjqZs5BXsvlMp+lRs8grMLqNlaw59Av?=
 =?us-ascii?Q?PO8iaJWaV3j54x7RpGPNorlU1Liq8qBs2uTAUuj48VNsMMl2PmUg/nBwqq/Y?=
 =?us-ascii?Q?WUYfxDMYLBBF4ihh9Vlq4lGm+ZHu85msGU6UkOLC14bnKa2YoYHYYeJ5NMAO?=
 =?us-ascii?Q?RnZrwNdO0FCS/wbcaSjdGwgvmOTi2DgTsrLk85xpiNup9eVvuD1m/UrISI18?=
 =?us-ascii?Q?lLKJ5RSAdOuqa57ttEznfNRkZPYI5WtuIIrYC0Yp2h7ODszbPnqJJK/8WTSl?=
 =?us-ascii?Q?D2U3hYT2tlVl4AZutJIldx2VhdLSBxCn3FSYrKsraseYgFtUIEC6KY8HNQg9?=
 =?us-ascii?Q?bdfpQOV1DUSItroZBqkV0cUfzA10mSCwe1WZJQYpXgDjn7LoZL2IlYU0HKVu?=
 =?us-ascii?Q?zmE3y2tDSr/zCfPucb76FqYH2yHaXLbWUG1GmNtGMCRhLgZmB7hZQYPkoXgs?=
 =?us-ascii?Q?PMY=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR12MB5340.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7136ec21-a97e-4c9d-fd80-08d9249a1059
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jun 2021 01:10:36.6188
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gdLKIUXd4VWJ8sq0qcPRhGc1n07K4JLF4e9bniH1fc/Vfvd+GPum7NPKY7hLldHseZqb2Z1MLrMCczN9uB8ZOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5097
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, May 28, 2021 6:15 PM
> To: David Thompson <davthompson@nvidia.com>
> Cc: davem@davemloft.net; netdev@vger.kernel.org; Liming Sun
> <limings@nvidia.com>; Asmaa Mnebhi <asmaa@nvidia.com>
> Subject: Re: [PATCH net-next v5] Add Mellanox BlueField Gigabit Ethernet =
driver
>=20
> On Fri, 28 May 2021 15:37:19 -0400 David Thompson wrote:
> > This patch adds build and driver logic for the "mlxbf_gige"
> > Ethernet driver from Mellanox Technologies. The second generation
> > BlueField SoC from Mellanox supports an out-of-band GigaBit Ethernet
> > management port to the Arm subsystem.  This driver supports TCP/IP
> > network connectivity for that port, and provides back-end routines to
> > handle basic ethtool requests.
>=20
> Please address the 32 bit build warnings.

My apologies Jakub.  Prior versions of this patch did compile for ARM32.

I will change the code accordingly so that ARM32 build succeeds.

Regards, Dave
