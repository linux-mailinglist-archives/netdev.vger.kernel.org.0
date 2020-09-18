Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66775270383
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 19:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbgIRRr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 13:47:27 -0400
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:5522 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgIRRr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 13:47:27 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f64f2820002>; Fri, 18 Sep 2020 10:46:42 -0700
Received: from HQMAIL107.nvidia.com (172.20.187.13) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 18 Sep
 2020 17:47:26 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by HQMAIL107.nvidia.com (172.20.187.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 18 Sep 2020 17:47:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YJ2ogf6bZtFY17fCZxK2hHPH61McB8uZjaVtIVoVdn6tp+3DjfkPw32RHHxJ1/YHtoVfRYlLCx/h3wAYqxn+kYmHsRz7rkmxfv1OM7moN7tAJCbuG0EusCq9IPAt0hlkQ65lgZ03ogqWxXCXf/o0IdciLfIRtQxNxg+wNg8UuESxEj+iNZX5Iq9VObs+HF2mUbqpJfq7pCTeqo53vb4lVlpcB7vYoxOS7on7LWLbCXCCL9qI0RVv3yJyEP9uZoqRY7AUGHsTK9ed5HK1FNICkCb8qyzakfwI5PgZWLYjDNxraA5TTlqdIYdFMGffARo4RUA3cARIiQ5aZvrBe3xqnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZdocpepLMXjD417qJzsvBG6hOb7d1S5CuvE94NdLX/Y=;
 b=DoP4Nsr84VZfKT3kE1pYist23VZ955hvcE6w04HQAanGad4a5mippT+S/AGF6Nl3eQFd0rjewCsePO+hsOiSmgtznZTtwYJvjp7iqixnhFFQn8Lu78Fa7DkH4KtrSDNQSAHjA5IVDy/yye20N627u3teGiyNWy+FIGnz7yZshfjgjojuDt7GAhG4COF5Za7AqZ9IoPR6qGKGktBVXagU8QMWdEH2dqCRryHoTaSGpl4RFwvB0Ix6udIXDUsVxbNumc9DZ7Q7ZhRPDT+jzn0DoACEPNknbM6rVYj1wd6/1wwbP9VYhPYQR5HDNkq2PMDEC+8UzQRDudYmrIBf66TF5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB3079.namprd12.prod.outlook.com (2603:10b6:a03:a9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.11; Fri, 18 Sep
 2020 17:47:24 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::3c25:6e4c:d506:6105%6]) with mapi id 15.20.3370.027; Fri, 18 Sep 2020
 17:47:24 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next v2 0/8] devlink: Add SF add/delete devlink ops
Thread-Topic: [PATCH net-next v2 0/8] devlink: Add SF add/delete devlink ops
Thread-Index: AQHWjRbejAHFYrcRiUC40XmVyPqlcqlune4AgAABw7CAAArcgIAAAWQg
Date:   Fri, 18 Sep 2020 17:47:24 +0000
Message-ID: <BY5PR12MB43222DFADC76AE0780BC7C83DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20200917081731.8363-8-parav@nvidia.com>
        <20200917172020.26484-1-parav@nvidia.com>
        <20200918095212.61d4d60a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB4322941E1B2EFE8C0F3E38A0DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20200918103723.618c7360@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200918103723.618c7360@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.209.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dd9f651c-b221-4127-6387-08d85bfae709
x-ms-traffictypediagnostic: BYAPR12MB3079:
x-microsoft-antispam-prvs: <BYAPR12MB3079F5127ACA7733E7ACE46DDC3F0@BYAPR12MB3079.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 30mXyxj0wOsoHHOdgiDL/V8l3VORlJ6dFgzQlujdClbLCU3Is20M//0zUvIGImmTOMTMPX00NdWgnQwkbDgO4qjgPsFCRk5nz8Cl0LOMP+1CGhR9yTCnA504tkTQRFpISJ7CDo/LsLD1ZjPOOiV0KuxhFq4+NxQhRuzVCDAEsbViJn7KQpZaJB5m+mJpKlIfL15y981A2VEZiXkIRBO0BAobgxuX1m0gxYW19z1CotKjMiLOi9N6/L7CaHLX5UfrY+/olLkgvVoC7H8dWspq4WogV7xdRvpE7FD1cl9xseaAgZhQoN1Ym8Jfy1GvDggWWhKKrgnsThF7v6UcnbcgfscHvkLuFfPHTO3rLqHmR2zS34R8krcJYGNZnzqKKBzA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(136003)(39860400002)(346002)(86362001)(316002)(8936002)(33656002)(8676002)(186003)(7696005)(83380400001)(52536014)(76116006)(55016002)(2906002)(9686003)(5660300002)(66946007)(6916009)(55236004)(54906003)(64756008)(6506007)(26005)(66446008)(4326008)(71200400001)(66556008)(66476007)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ayEm5YW/lN5ihpJvZLf52Z9USkn0zYf/auRn8U13v+IeIcwPCMSmUVF2vMZvdbdpWjHKVp6gbRlK1qEDaXnoGCNzl3S3ztTNjad1bheO679RWf9pGgBXwBYUPZMdQW2d9T1ZqNbtwRZ+KcHF/WTT+YLIrjkZ8F8ePNeQe3s8KA0gYe9JzFeWCYRGzuAevqLQ9lbIoyb7OP9S9lSVzW8jnStxpcyU4WOooxGn09iO5VcUDeqKA/4d2A83VE0zyyPHRBUWcP1QBjh9rhIoqpW3Dr2xlr2Xs9KMzx2FsX+azlUzSZIwgY8DuFwV0bRdZSBgpJ9MxPsRW095YuXzjQLlTCH2nqKVcK1xuHlpoiobjMs7mfc7P+OZM8o6LsCUEWhwTdxvLmnyeZi8I9zR9v2aWtY9wZFXmWMaE4dgX7GCFAMZEfZsmHxNwRAF8Fs96SVl8OP/eFRZ41R8YUNuTJwE5YsKlfyIT8p6iq8/BYS77XhAOCv9wH/s+sK1Av2Oyqhj/DfMhQcYM3k+Pm1AcKcyfbAQvCoHDeH378TxbCT8qmg719IEsMC0cvrCZNkRn1vNiisZEceC7ZT0dbb6wB8EdDcwsMiwXi+KNaAJEi/OpGxToT/yzbFCsKlwRZEF/iZDa//r5C3hvvqzM3j74eYwbw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd9f651c-b221-4127-6387-08d85bfae709
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Sep 2020 17:47:24.6958
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7PqwjALGwdQBWRrDIixBpAlJXKlbqoqdA0t7FeHzX3PWmNB1t/8bip1dD7EHQbaRbc9Yp/M/sRfcLgofIat4zQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3079
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600451202; bh=ZdocpepLMXjD417qJzsvBG6hOb7d1S5CuvE94NdLX/Y=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-microsoft-antispam-prvs:
         x-ms-oob-tlc-oobclassifiers:x-ms-exchange-senderadcheck:
         x-microsoft-antispam:x-microsoft-antispam-message-info:
         x-forefront-antispam-report:x-ms-exchange-antispam-messagedata:
         x-ms-exchange-transport-forked:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=HCguLyrOPbA33TlXkGm95c6esE1oRDcMfQ/3FL8vYsTAudPvjT8QZcnYbbxi09vvJ
         hMr5NKlyk22HH6j7fSq8xukhGufJzs9NYak/xHblI5/PDTPb1Rfhj26Ic/SyqMWPyG
         V5isW+tuDEW5YQJfioIRDBwONzBPJVaYB80plSGrnB76OwGVw+CBEDuvzDO43CQrQC
         FR4HFTzEJGWeplpneIcPbdF04lpB6sq8iT7iA/PShh0/vZdQoohiVYL4PS5uChifhJ
         3sUTfvG1U87cuMvJG0xVUWRgqrgTTYPbu4UtiPOrdEApthanM03GbviDZChwsddyDV
         bbTy+5Yo6GYjA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, September 18, 2020 11:07 PM
>=20
> On Fri, 18 Sep 2020 17:08:15 +0000 Parav Pandit wrote:
> > > From: Jakub Kicinski <kuba@kernel.org>
> > > Sent: Friday, September 18, 2020 10:22 PM
> > >
> > > On Thu, 17 Sep 2020 20:20:12 +0300 Parav Pandit wrote:
> > > > Hi Dave, Jakub,
> > > >
> > > > Similar to PCI VF, PCI SF represents portion of the device.
> > > > PCI SF is represented using a new devlink port flavour.
> > > >
> > > > This short series implements small part of the RFC described in
> > > > detail at [1]
> > > and [2].
> > > >
> > > > It extends
> > > > (a) devlink core to expose new devlink port flavour 'pcisf'.
> > > > (b) Expose new user interface to add/delete devlink port.
> > > > (c) Extends netdevsim driver to simulate PCI PF and SF ports
> > > > (d) Add port function state attribute
> > >
> > > Is this an RFC? It doesn't add any in-tree users.
> > It is not an RFC.
> > devlink + mlx5 + netdevsim is crossing 25+ patches on eswitch side.
> > So splitting it to logical piece as devlink + netdevsim.
> > After which mlx5 eswitch side come close to 15 + 4 patches which can
> > run as two separate patchset.
> >
> > What do you suggest?
>=20
> Start with real patches, not netdevsim.

Hmm. Shall I split the series below, would that be ok?

First patchset,
(a) devlink piece to add/delete port
(b) mlx5 counter part

Second patchset,
(a) devlink piece to set the state
(b) mlx5 counter part

Follow on patchset to create/delete sf's netdev on virtbus in mlx5 + devlin=
k plumbing.
Netdevsim after that.




