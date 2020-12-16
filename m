Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B17A52DB9DF
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 04:56:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725852AbgLPD4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 22:56:21 -0500
Received: from nat-hk.nvidia.com ([203.18.50.4]:50385 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725287AbgLPD4U (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 22:56:20 -0500
Received: from HKMAIL104.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fd9853a0000>; Wed, 16 Dec 2020 11:55:38 +0800
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 16 Dec
 2020 03:55:35 +0000
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.169)
 by HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 16 Dec 2020 03:55:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kV4wZnuIbwoB6I3KI7XRRji4Yg/+W1Hdmj9vxDWK62PtKP3DEEL+nfAaoHYhZUUANfVKpGrIhWCJL+456QWtfqgYtLcvUJcbqcwcOLHyS8bWBBA1vQNhjAKKkSA5kMnX+av0Zq2rR8QZkFt2yeRTLQQuBA0x5z+effRXNd5PjQ2FBuvBE1ErrG/7QbSjdxs/fBzd7QaWiPiM5HytOtabcv/MEWStS344weyZZeVCJ5GqwHNbBpBfqv8Pv+1BFVUoSlnmUddY9ofhH7ITzucwH4FxJWn7R8WyK3U6lmUo3N0YS+Gw3itpr/cjcf9G0TOJYQF3ptcBA4TmzmqBga/S6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=svboe2p1SnPWY4ncefYQy0xMCQk00Rs8lJwdTkUJY5Y=;
 b=n39zJiIfIEvYi0Ds5GyyCREImHIL7ZpR2seSDeD71Qivxn3K9mJhPUbpo2QMX/xs2auL1ClW/KQBJqcP7tFWO+e2QHXGlaBTJveDf3rmyIFkL5QeYN6kRcfNqKqh18kNvoBZTD4g5T//jo79gtn17bCPofuwt9Z8cHf2puh4C76JfPiHRwyiOt5yfUcUQK8zUsiSS67n+nS6ojWX7HphzPcIUR4JhyUtGpn26rkR2U6n889YXAiT5PNdWeOnfiAEZwfSHc7Z+KoSOszdIQoSZEyi8UVY773K2zX18L1Q9KL/PvYATYtF4crtJlm50+SfkrLmJOBS8O4LQg7/xKZUlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB3543.namprd12.prod.outlook.com (2603:10b6:a03:130::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.17; Wed, 16 Dec
 2020 03:55:33 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::a1d2:bfae:116c:2f24%6]) with mapi id 15.20.3654.026; Wed, 16 Dec 2020
 03:55:33 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>, Saeed Mahameed <saeed@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        David Ahern <dsahern@kernel.org>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Sridhar Samudrala <sridhar.samudrala@intel.com>,
        "david.m.ertman@intel.com" <david.m.ertman@intel.com>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
        "kiran.patil@intel.com" <kiran.patil@intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: RE: [net-next v5 14/15] devlink: Extend devlink port documentation
 for subfunctions
Thread-Topic: [net-next v5 14/15] devlink: Extend devlink port documentation
 for subfunctions
Thread-Index: AQHW0sFKQJaY46+MjUegyHtGsMrUb6n46E4AgAAwtjA=
Date:   Wed, 16 Dec 2020 03:55:32 +0000
Message-ID: <BY5PR12MB4322938B44400C3071A1A99CDCC50@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20201215090358.240365-1-saeed@kernel.org>
        <20201215090358.240365-15-saeed@kernel.org>
 <20201215170056.6a952e9b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201215170056.6a952e9b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.199.116]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 86d89fae-dbd1-4ef1-f6c5-08d8a1766ffd
x-ms-traffictypediagnostic: BYAPR12MB3543:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB35435C401FBB4B38F2D1785BDCC50@BYAPR12MB3543.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ox0MduAHsJbJCrNmarmldu9ypxShpHhQlc7utweKc457InLkdPl86fSTNq6sy2nMdiLIeIs1jtbToI0cvKqFi/370alEY6dpvDphJl1+h8DI53itU2LC08XorGBxHJGrjOaRRmDorEdTqwbNO8GE23HlCiexuZUjVXFAFyERStBz1zwnc5iL3w1mD6mtUbBoqcgVASs4mcrEqOsAv8frzf+PwOxTSRoc+H9VyIVMgz4G4aClRmDk8p6cpKztI+s592foyKf+4onzMwAJWMuXSHnSjTvvPredBcpeeMAV8M5f5NWm9slBGxWUZ5hH6+WrqDsu7ciRGPxa9QwOb2kJQA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(376002)(136003)(39850400004)(396003)(346002)(64756008)(66946007)(107886003)(9686003)(110136005)(7696005)(86362001)(54906003)(8936002)(52536014)(55016002)(83380400001)(2906002)(71200400001)(76116006)(316002)(33656002)(8676002)(478600001)(7416002)(186003)(55236004)(26005)(6506007)(4326008)(66556008)(5660300002)(66476007)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?Q+Hvfnkb2dDj0R6h7ZmffmchyWR2MuePA2cIzRa2c7K23AoXaOKG5LqCdtvl?=
 =?us-ascii?Q?qchFfH/JFfZnJW15AgsiC1YkVgeeJXmdAa0t1Cyi4Kvgj8XHJQJb9+XHF5L/?=
 =?us-ascii?Q?wFXnogj+4jNeH+8+pHrEP2D/xUq7+dykGfMBo5tILWIvc9uEazgMrgt5+8UA?=
 =?us-ascii?Q?C3Qh0zcJ5xKKXAfHAEsZuGCPFejIzAVo9T578AL4KdsoBK+SEVgZUqSevruz?=
 =?us-ascii?Q?gBH3aru8z4/b0SwyTBOU1hoS6ZU3rHvRuW1+m/bLyXpXsgKCTZLOtEzpQhui?=
 =?us-ascii?Q?L9RQ5abPy0ibAcyTeL4E68Mx7MqxHn+cDGog48y5psrglLgR6Y3gnSvaxbwg?=
 =?us-ascii?Q?I49JOIk6wEFQOcAOzoMdFgF2ldTCgQNuqXbVmKOs4ubVhnoYCZPBzt7ps2IN?=
 =?us-ascii?Q?47/pR8aCqGPm7SwheYWBzRtAzZDbnDGZCEahQGfjrndEXvLLSx87nl1tb976?=
 =?us-ascii?Q?OM0ttfHr+70g7sHxCy/AY2Dfw1fm0Adu6Jb41NivBVoDY5OL7f6nfr5am+ZH?=
 =?us-ascii?Q?PE6LlWDGLCAVjFvNZXg1ffL434KmYXDtB5XQWiENLDJRbEAiKYjGNZivKE5D?=
 =?us-ascii?Q?c9HtpsqaX+9OQT5jRuNG0s1yPx0AuMvo6t2yXS44svijwPKDSFk0Hp0zeOA2?=
 =?us-ascii?Q?wIjZislKfEE7pmpva2F3cGkSgQBMacfFGoBL7i3iblusIuLQtHOge5FV2Ian?=
 =?us-ascii?Q?tAIxp7pbuTdhmIsTgL7mmBhsftVx7c31x0zk4KnTr4YA500pUqPRj3Sss+nQ?=
 =?us-ascii?Q?hgmQykx9efNUebpJ1og2FP3rHivT56F5W1zfmijhBv9TQrAXFI+HoZL25NAk?=
 =?us-ascii?Q?b9LK7I7xHlFfxVRGSnVj350wncW5oekGdYPwJ7I93w8qtTzuB99rzFwJIroV?=
 =?us-ascii?Q?yFPegQDuK4xhD7VaGeKzWQh1fPhmJqrOf0C8b5hhx95VWXV3QDZWi0VqnzM0?=
 =?us-ascii?Q?57rkJX0EmiUPkE60RwMlmzdCNt9PROsSKw9eQWkgtO0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86d89fae-dbd1-4ef1-f6c5-08d8a1766ffd
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2020 03:55:32.9096
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sD/sMGf+EbVwNrybF6Z/c18dnQSbA/o9JEfaDgp2i1JryGVcH+m/fi+nTPRNWFjphBCvxVwgQGhPo0t271jRww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3543
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1608090938; bh=svboe2p1SnPWY4ncefYQy0xMCQk00Rs8lJwdTkUJY5Y=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=AJnAYuCEV8hcVXkUYmIWphsmgPMoPbY05yaBXrE09PSuzyrehvVaDON1zBd8wn1F1
         pQ5ztNiRIiv5+UlZHPqFm0slYwWhbmfWumummHYRNhWI76b3ZjPsGi6qO60F5G03fl
         WO+cbH18KQZipye5WP+yGC+cD+6V3ZuFxCSCD+uS1YRRqTReBbFh+v/iRLHIGHSix0
         Rx5Vl/9CNXkbkEC67nTxOSfCXsESS+7hVwXxv9arUEV00Wxnn9VPxcQfVDTFLfb3F2
         MTepQgQLmec/ebcWhCt5UQ8Pcn4qoPS5MgzeAhP8p9yoO6X/OY/Q2kV7/hd+ntu1ir
         IJmx31eYgKYuA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, December 16, 2020 6:31 AM
>=20
> On Tue, 15 Dec 2020 01:03:57 -0800 Saeed Mahameed wrote:
> > +Subfunctions are lightweight functions that has parent PCI function
> > +on which it is deployed. Subfunctions are created and deployed in
> > +unit of 1. Unlike SRIOV VFs, they don't require their own PCI virtual
> > +function. They communicate with the hardware through the parent PCI
> > +function. Subfunctions can possibly scale better.
> > +
> > +To use a subfunction, 3 steps setup sequence is followed.
> > +(1) create - create a subfunction;
> > +(2) configure - configure subfunction attributes;
> > +(3) deploy - deploy the subfunction;
> > +
> > +Subfunction management is done using devlink port user interface.
> > +User performs setup on the subfunction management device.
> > +
> > +(1) Create
> > +----------
> > +A subfunction is created using a devlink port interface. User adds
> > +the subfunction by adding a devlink port of subfunction flavour. The
> > +devlink kernel code calls down to subfunction management driver
> > +(devlink op) and asks it to create a subfunction devlink port. Driver
> > +then instantiates the subfunction port and any associated objects
> > +such as health reporters and representor netdevice.
> > +
> > +(2) Configure
> > +-------------
> > +Subfunction devlink port is created but it is not active yet. That
> > +means the entities are created on devlink side, the e-switch port
> > +representor is created, but the subfunction device itself it not
> > +created. User might use e-switch port representor to do settings,
> > +putting it into bridge, adding TC rules, etc. User might as well
> > +configure the hardware address (such as MAC address) of the subfunctio=
n
> while subfunction is inactive.
> > +
> > +(3) Deploy
> > +----------
> > +Once subfunction is configured, user must activate it to use it. Upon
> > +activation, subfunction management driver asks the subfunction
> > +management device to instantiate the actual subfunction device on
> particular PCI function.
> > +A subfunction device is created on the
> > +:ref:`Documentation/driver-api/auxiliary_bus.rst <auxiliary_bus>`. At =
this
> point matching subfunction driver binds to the subfunction's auxiliary de=
vice.
> > +
> > +Terms and Definitions
> > +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > +
> > +.. list-table:: Terms and Definitions
> > +   :widths: 22 90
> > +
> > +   * - Term
> > +     - Definitions
> > +   * - ``PCI device``
> > +     - A physical PCI device having one or more PCI bus consists of on=
e or
> > +       more PCI controllers.
> > +   * - ``PCI controller``
> > +     -  A controller consists of potentially multiple physical functio=
ns,
> > +        virtual functions and subfunctions.
> > +   * - ``Port function``
> > +     -  An object to manage the function of a port.
> > +   * - ``Subfunction``
> > +     -  A lightweight function that has parent PCI function on which i=
t is
> > +        deployed.
> > +   * - ``Subfunction device``
> > +     -  A bus device of the subfunction, usually on a auxiliary bus.
> > +   * - ``Subfunction driver``
> > +     -  A device driver for the subfunction auxiliary device.
> > +   * - ``Subfunction management device``
> > +     -  A PCI physical function that supports subfunction management.
> > +   * - ``Subfunction management driver``
> > +     -  A device driver for PCI physical function that supports
> > +        subfunction management using devlink port interface.
> > +   * - ``Subfunction host driver``
> > +     -  A device driver for PCI physical function that host subfunctio=
n
> > +        devices. In most cases it is same as subfunction management dr=
iver.
> When
> > +        subfunction is used on external controller, subfunction manage=
ment
> and
> > +        host drivers are different.
>=20
> Would be great if someone from Mellanox could proof read this before we
> spend cycles on correcting spelling in public review.
Will get it done.
