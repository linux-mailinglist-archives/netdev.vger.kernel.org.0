Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18B1634A11A
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 06:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbhCZFm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 01:42:56 -0400
Received: from mail-mw2nam10on2061.outbound.protection.outlook.com ([40.107.94.61]:64096
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229446AbhCZFm2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 01:42:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RHbizd6jq2yAO6gS2m9xShcC8D8s+r2uLDKdtMzEq/iD+iKck2nQCUU+ly/whjLmYLsRKacnyG+v8BtAQwTeOQsK8Bhz7TAEtWz4LX8pnk4tQGa7kp7NcY+hCioqUyqqMhiGzlbAjms3IWd7v9O+lew/x5oK5chgIn8xAANFgkLC9iChhG7P5T9370CwFyhhpe0jr8wY3NdzcYMkowarTpqi0ljxo5E44qA5kJHnbaGvO3kJe307nf/uZ7cO/XA6PfLzWgVJ4iAbXTrku1u2JiF4zh2m/MjOvm3Zz1uyFzqE1mpFsDZ7RR4jmf5erXUarjoNBgs0cNd8VkTx+PaIng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0emtyLUkov4AtvUNq3PWOzuc6GiIocfX8uJwn1z1zTM=;
 b=hD/OQQSX36c/MPB9hNuy+CNwly9R4CBhYrdOuP0AZh0k+LIBFbPdhikmdcNVarF1amnz07J2ihtlrnNQ2Ebdq3lCcaK16lA0HeKrnui9IsHDGzXT72wnRPKxk0eq4Kfm3LJsHAjzQ/bmUI78jcUuhjXxUybnKEB9iraAlm68zSamOqs4jI3ZKwySq/NdXCXuz5vgo/hnwnHbrlvUdhLBnNK4+tES2UHG5e2KFKcu3+9zTqlabenj7DWrzRCHrRcNrSqWBCu47Va9fjA4VHvhEVLp60ED+cL8cAvX+r/hl/lmbcY008BhhUa3rckW3s2enaDzNIecEs7AQbPFbQXfRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0emtyLUkov4AtvUNq3PWOzuc6GiIocfX8uJwn1z1zTM=;
 b=e0eVMFUhmulM9LX2dAZMfHoLX6D9BW/xr5GawYh5HFgJMw5SdaqjA0AwDpQ1gr6B/SFGWYXbA54pJ/SkbgbFETI3Zq1DZNTkzP7TaZQ1aQKn2CPgSiOZlkyw6x7Le+N74m3b7CDzV+O5lA2Tke8BcSc6G5Mfjgr8ymB12hjRDME+MUvEMzDUMe9VZ9gnHyOI/sXt82eXzwVj2GNQf2gunWJaVTFnZcWyyQ0vC01RZAtjs5opqIw9JYDcDr1yA1lzl3v9iZai5rlWEJ7Y24uH+Lwy2eh0uEAy/y+fiZQPQnOAdiRNMtXhcHb4ErmkA293BQ2lBQ5GQIhOFMQCoPBLOw==
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB3621.namprd12.prod.outlook.com (2603:10b6:a03:db::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.26; Fri, 26 Mar
 2021 05:42:27 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::7cec:a7fa:db2e:3073]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::7cec:a7fa:db2e:3073%8]) with mapi id 15.20.3977.030; Fri, 26 Mar 2021
 05:42:26 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "dledford@redhat.com" <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: RE: [PATCH v2 05/23] ice: Add devlink params support
Thread-Topic: [PATCH v2 05/23] ice: Add devlink params support
Thread-Index: AQHXIEFD/G8hoBwdlE6ZByD8K/Qg36qSkJoggAKUnYCAAJYyAA==
Date:   Fri, 26 Mar 2021 05:42:26 +0000
Message-ID: <BY5PR12MB43226856B588B5666C463A5CDC619@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20210324000007.1450-1-shiraz.saleem@intel.com>
 <20210324000007.1450-6-shiraz.saleem@intel.com>
 <BY5PR12MB43228B823CA619460AAF2099DC639@BY5PR12MB4322.namprd12.prod.outlook.com>
 <9ae54c8e60fe4036bd3016cfa0798dac@intel.com>
In-Reply-To: <9ae54c8e60fe4036bd3016cfa0798dac@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [122.166.131.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6e648177-28fc-4b81-b7c9-08d8f019f041
x-ms-traffictypediagnostic: BYAPR12MB3621:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB36217974825227EAFCFD6BE1DC619@BYAPR12MB3621.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qR3MKbvh63qkubyYcseojWVgRjCA2ffKgTWYakYyLKPceC7cVjPZrnAVSY81moUIXcbJGew21BzUjJUU4SZbuCQwZ6a+I5t7dgFV/XnaSlw98hGQDALJn/w98iuC3y6LWhdYDB76Gn4dBY23fC7OJWqM8+nmX7EZbv1j5LFVwfVD/35kpB9MUco88F4Jiin4yisN9kJBdpOZFDk6ABK+jJYo7fK4Uj9h9tt1AEMgHyzyc60kwwhvaE9spvKyQEDg6TvUqlqdmiKb/04vQQj2UdAWWxE8jVs/YItVc5fybhpg4Ckwk70QsqCne/nL2eylFfUbwlN95tqTXBmy1AHbLOuEEpyOer2YhNj5JqgOCjcWPQ47jbEVmX9h7kb/N41tnqOqxOFVTZq/BJTBRVSGVFsBzZhabmxWP497BJol5n3qMKLlfrXIwaUUSpxmB54bVV2DPQNRdSNTfG84NF/qW5Dty73dS7lcHqEJkPvabepek7XEqE4z/FDYrRktWw637stawkJEY6Az2R31EeVpX8yYZsmfNJrRPdVx5yIvQSLH65l3DDI2RKz5Ok03HN+3DA0jReALEpJNApDvHgnX/x3g3o2pjP9OgcSfNFIabAn7TFliiYVanno2EzTCN2sRjufihufWiXk0VBOq8sdRe7KQ6HUr+OeovvFiq2KuAtM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39860400002)(376002)(366004)(396003)(346002)(8676002)(33656002)(478600001)(83380400001)(8936002)(26005)(110136005)(186003)(6506007)(53546011)(4326008)(2906002)(86362001)(64756008)(54906003)(71200400001)(38100700001)(66946007)(7696005)(9686003)(66446008)(52536014)(66556008)(76116006)(66476007)(55016002)(5660300002)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?H3qjb5NTFIE+awGMJ55gnLhCORlzisGQJczqvfxUBZBVuDzpiDO8IbNwowi4?=
 =?us-ascii?Q?6f4YCCS04TjYhOLfnsOatVOU5nd8duqegKhRsMlIW+AvrlbANfkr0HbUMYoX?=
 =?us-ascii?Q?LTgi/nMsny95v7EDhnPYtVhm1NJdjtGR4P+3uopBLV9stQAYIAvvmQiADucX?=
 =?us-ascii?Q?Qhn4WXtZdnZaQme8Kc4jb39MpC4FXo32TTPjV5vOzP38fYpZ51/u10oShH5j?=
 =?us-ascii?Q?CwiTaPWK4vNTJDmdS7OTXAXKmzBSuJjKkp/zHWXKvRrJA5y4q9OX5MMm6UJa?=
 =?us-ascii?Q?+rRdwEtgG+EgbSfDVnoZ8E2okmtGffQ7Jz7UaP+xnyL86jRlSwH+lxZFTGI9?=
 =?us-ascii?Q?Qvs8z1x32G2BhRbVOdmrogkJIVFGPE3KYFimnoLq0pYzuOdJBV910IBDstQD?=
 =?us-ascii?Q?l1RQTiJFD/zWeyIRN5db9WW9mI/cDaJPJCGgUka0kQvQm2ki66YoG0PNqq2g?=
 =?us-ascii?Q?ICTsnrCYaeInTOxYdxVP8ZtXN2Yv4tBUt/CKaY5BS8tqXeaZO8mffsshc6vJ?=
 =?us-ascii?Q?RUlXC/pUS7g7E70puQJcd+rcK4fFcO2vJoezDSTJGkjU/o2q7EFQqRs5617E?=
 =?us-ascii?Q?wMkNY+r2+5HOX5DV3rawKu3LQvO1ZTakRs3dujl5yl+rkav11/R2pTuCAlrt?=
 =?us-ascii?Q?N7jONckmMl1nGFKeG6XUKd1O0N7un1K6TuWYnEVMQFyDPHcK/YYpA9RyYQY3?=
 =?us-ascii?Q?0Us7URSM150Ciz0uXeAkpkFMUvmvP1GBKT6MV747iLr3DH5Cy6hN/whism2o?=
 =?us-ascii?Q?QyBwWpqkrRmC1F9Tj5OwM8gIeoAfQsWK0djhKm2ek6oR+yOqo81I/uUjQHQC?=
 =?us-ascii?Q?JAVDUMIFjCduSQtBvixzDBzfdFROtiTbslOgnTKAOBqtUo1Fiwa825RdbPIl?=
 =?us-ascii?Q?rzimNfxZ8lkC7OiyALwootZb4xhInPRphH8+knnfojJe+sq/KxFS5t9l/3Vm?=
 =?us-ascii?Q?qOTvpM0n2DPYV2IbwBln4m9yhc7JjObXG9HZkQRy2oXKFRGNpbnOtsCWBRcB?=
 =?us-ascii?Q?5Ov5AHkUvcG9CImwI6ZUwZqGL4agKXpnhZMdEyq1JVAI9jV642hx/0auANHV?=
 =?us-ascii?Q?DhTkwoGXW5bBiROeWKXjqBczN1maAdF7Vv9Nfy8UpkpcaPg7Yk2QxB1p2ect?=
 =?us-ascii?Q?gs2cKTXnj/s/+C4QmnKrzbNKd/5LWzdD5zAawPIvUvZpHBxOzpPmjLvnclgv?=
 =?us-ascii?Q?FwB7S8QzdWDiEIcDLs1rKCWVnPa5yeaerSlHXtyMpzSCYaqORi+qapi2QlNJ?=
 =?us-ascii?Q?Pjl+kQwZ+0QOhhOltWZ8wl0IzgJsbVMoBi2AhnJrdqSya6yBxuDR/ftdGJJX?=
 =?us-ascii?Q?U9rGYcG7n/WEg1DkLUksthG/?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e648177-28fc-4b81-b7c9-08d8f019f041
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Mar 2021 05:42:26.7557
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 70lshZMLZbo+n8CcVH++cMnf0ei8Ywn00O6OdF8lctYLSjlF4NheB5TXwdFCFwsDx3Y+Ek58HdodN9aX9nG8ZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3621
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Saleem, Shiraz <shiraz.saleem@intel.com>
> Sent: Friday, March 26, 2021 1:40 AM
> > Subject: RE: [PATCH v2 05/23] ice: Add devlink params support

[..]
> >
> > Resources are better represented as devlink resource.
> > Such as,
> >
> > $ devlink resource set pci/0000:06:00.0 /rdma/max_qps 16384 $ devlink
> > resource set pci/0000:06:00.0 /rdma/max_cqs 8192 $ devlink resource
> > set pci/0000:06:00.0 /rdma/max_mrs 16384
> >
>=20
> Hi Parav - Thank you for the feedback.
>=20
> Maybe I am missing something but I see that a devlink hot reload is requi=
red
> to enforce the update?
It isn't mandatory to reload, but yes either reload or driver unbind/bind i=
s needed as you suggested below.

> There isn't really a de-init required of PCI driver entities in this case=
 for this
> rdma param.
> But only an unplug, plug of the auxdev with new value. Intuitively it fee=
ls
> more runtime-ish.
>=20
Driver unbind/bind to reflect new limits is ok for cases where it is not ti=
me sensitive.
For mlx5 use cases, user expects device to be provisioned in < few msecs.
And driver unbind/bind are sub-optimal to achieve it from time and memory w=
ise.
So mlx5 driver prefers to stay away from driver unbind/bind steps.
So I am working on series to not create class aux devices by default for SF=
s.
Rather to create them on reload.
Something like,=20
$ devlink dev param set pci/0000:06:00.0 name pcisf_classes value false cmo=
de driverinit
$ devlink dev class set auxiliary/mlx5_core.sf.4 rdma true
$ devlink resource set auxiliary/mlx5_core.sf.4 path rdma/max_qps size 2000=
00
$ devlink dev reload auxiliary/mlx5_core.sf.4
This last command will create the mlx5_core.rdma.4 aux device and when its =
bound to driver, it will create IB device with right max_qp.
So rdma device is created only once, instead of twice using unbind/bind seq=
uence.

This may not be possible for the PF/VF device due to backward compatibility=
 and their different usage in system.

> There is also a device powerof2 requirement on the maxqp which I don't se=
e
> enforceable as it stands.
>
Right, but similar to size_params.size_max, size_granularity, I believe siz=
e_params can be extended for alignment restriction.

> This is not super-critical for the initial submission but a nice to have.=
 But I do
> want to brainstorm options..
>=20
If max_qp is truly a dynamic value that doesn't require device recreation,
extending existing rdma resource command seems more useful to end user than=
 doing unbind/bind.
