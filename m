Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF7536781C
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 05:56:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234247AbhDVD42 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 23:56:28 -0400
Received: from mail-eopbgr750048.outbound.protection.outlook.com ([40.107.75.48]:25927
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229536AbhDVD40 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 21 Apr 2021 23:56:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yoxegb5VXy5v4Jicz8b8NPUTW9IRYTsVPmn3rLqdw7VIE5tqlHx9nBIRDnlJRaxnd7DoUN/mWJnn7b+tvIl3Ryz15nemGbc37EwIL51QzDnH8k/I4BMucA7FMaPu+MCHp99pAv+heTZwAWcmZLulB3LBMvUyRmUk4ptJl3Cs2LwfuIauoOW9ioZNjr+txKg+u+r+wQ1/Wrvl1r76IR2YdrHsF3Ud6NGrRRA6ecT6kSQuwiRsuFHYUrOaPRSnGQEWzPWG7hJIlsio9+W1ESq0ztw+//GClvt4QC+A9Q0kEMm9iRjZrlHDjSiSfuBo+vq8K3+f+aEJIDac1GmH7kc9gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W3talBYDTz9fRjFjU5zrLTUBGR5cFCO9N/yz9/DsMas=;
 b=D/AZMQsrIeBjoT7v9QAAgKv0EyVAljbcyYym1Xtsw9Er9eLEKm0UTjfPWSPscegt06L/EYl2ed8Xu33NvL9hXQKjdr4OkCcSZZI1CQbXrVOVdwvRjzFHtMl8FnFcYhA4vAkq8IB32/KBH+ILvkXfWM0arC1e5p/ZnLbwdbE0EelRzdwMfU70lXOWR/nXbBSn3cxXKK09kqnTWO4RPoCFvV7xHIvlz7MQmB235E2SMkW4e6z4pgSQLNuhyo7FQ1kXTZ15lBx9kKeOKuY+MQGpz9Tk7a9CI1eOiJlMJSlM1LOuym8b6uKVBQoemqr9klsPVvvf64YjcaUHB+dlV/vOfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W3talBYDTz9fRjFjU5zrLTUBGR5cFCO9N/yz9/DsMas=;
 b=NK1j+d7N+p8g0xcJlbNa7GtI5fOlOfzmdeLWtRmmdh3DD2bJ5kWeR6BI1Y0hR44P26mgsC+MMXFHlLH6cryUgIcRcOOqc+BceG3A/geTj0Jb0KgVsF/moYLu3uxv25aiSFMW3/HT9L1U5jezxthIbxZffyVtZec3iOLjq0P/fkawGy101+cpBlNWh+qXr84uZ49vNN+R4gtAE2KU4YQTzH1324/sYcEJ4QnAXcD/k+ef3sdjccna42G/bDR/0p29sXVVk3IEw2U91S/iz6iqIrFZy3xZTwLZNvRDAOCK4BkdNRpu9VPyBjzSnxUMoVcEdaJn5DjmbH+97k9C7Gm7ww==
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB4904.namprd12.prod.outlook.com (2603:10b6:a03:1d3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Thu, 22 Apr
 2021 03:55:50 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::7cec:a7fa:db2e:3073]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::7cec:a7fa:db2e:3073%9]) with mapi id 15.20.4065.022; Thu, 22 Apr 2021
 03:55:50 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>, Saeed Mahameed <saeed@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@nvidia.com>, Vu Pham <vuhuong@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: RE: [net-next 06/11] devlink: Extend SF port attributes to have
 external attribute
Thread-Topic: [net-next 06/11] devlink: Extend SF port attributes to have
 external attribute
Thread-Index: AQHXNtZtTFdrJ8Neg0uMUAwPgg5Dvqq/WQEAgACOQQA=
Date:   Thu, 22 Apr 2021 03:55:50 +0000
Message-ID: <BY5PR12MB4322B0D056D310687E3CEA58DC469@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20210421174723.159428-1-saeed@kernel.org>
        <20210421174723.159428-7-saeed@kernel.org>
 <20210421122008.2877c21f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210421122008.2877c21f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [136.185.184.152]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d1d59dbd-2414-4a19-0426-08d9054284f3
x-ms-traffictypediagnostic: BY5PR12MB4904:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB490479E9B1FA63C109DDF33ADC469@BY5PR12MB4904.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: wSb6RjrFJ8qJ8Mht+t/8pUoiuzNlTA7sKIvVfDCadVHXiVB88xcZxLCxuK1OemU5XdNYCDHfGpdvjzvrWVP/86AHvhEXYKHbVNrPKIvLB5o/mra/5b0kRtTsENLeqdxGjFpXzIwkCl5U/E/QxGhyfM5y445OgR45vh4queTTAoHPMg6FN4qrLixO6YWH0Sx4MPO67K6eH+Yg5UJXEgsArPOlKS3CrY0H8Pip/XVP3QH0dCRD/hsG2lJ3mMzZapRi5grz8nBvMKNvWTqy3TAMASfHqg61JbCDK80Frx7Qj/f/BKL6LpVGMW4wj+cJQBEs2d0qHsjO+WEUbOJs4GRuJBqxFNU6I9Qm+1IWf8E78CSQR1P8V5m4Y19Ao8zzAagL9cZW6WdJbmmZ4GrgqVQeFEpgQ99rYwrTjfQ3uNNk9Zn9yWfhVfN1uTm0U7Zqexz2OYUcqPR8g6wBQX3ObO/4Nj9yv9NdrczUNuNfpvn0hX8WxvO/KP+oalblLcYgJXS9RKJ3bPfLYQKKzPWwZ8ER1n0nTmgmNC6Z3zDBvult5HthCIrw7EZtTeDZef+SeNOXD8TKXkTdGpR2LMx5wUEKoO8qnDnHSN0VQCwr+TCdrQk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(346002)(366004)(39860400002)(26005)(54906003)(7696005)(33656002)(6506007)(8676002)(66946007)(122000001)(8936002)(38100700002)(66446008)(186003)(316002)(107886003)(66556008)(2906002)(71200400001)(76116006)(110136005)(66476007)(52536014)(86362001)(478600001)(9686003)(4326008)(64756008)(5660300002)(55016002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?WC5LOKmP0O43gc6cJmRYkpIt5pXTLsQ+C2GbGpOwqJRWcnwCQA8383RyVxeB?=
 =?us-ascii?Q?Wo9TsFLGVyF4SCeia1c/fmf2E5MWEjme1yGmgE3RvlXRi0bpaItbpXkTG4a0?=
 =?us-ascii?Q?p0RKN+CIjrBbP/KzCLbNKKxel7+5M7PjB5WhC6fXeTs2K6/xxK7orWCSzAsQ?=
 =?us-ascii?Q?fimhDr5PxzvOiD+ROPx6zMCU4rQVqNyA91F32uCLqVFjcSMn6ZXtn/2q3KOe?=
 =?us-ascii?Q?sSi2jWLFcMbtD/wkXPpa9I5hyRcmqZ2NiyL1sdj7+2Bs+mnc5Ms+4IVid9/j?=
 =?us-ascii?Q?SR8et5cs+oggdmdwBCRrU7rbjn2ljMPVCZEYQKdSkdR4+BQpl0CLj/tF2Dlw?=
 =?us-ascii?Q?4gAYnyiuk5tFGbp3h9TjRE2ELJX2Qm/HEdM+Fu+rUG//i3S4sERZ2Rw+HY95?=
 =?us-ascii?Q?e1loLxPOylKSxQSifOo/I8vABpwKt6eM4qih+FASafRKIocWM3yOR+vt20qw?=
 =?us-ascii?Q?uwm6fSp7/AFtIObUmB6IDFyPSwhKwFKZswHnp9hyO1T/mLGG5XQZ09+LEhjY?=
 =?us-ascii?Q?dzGo/POuDYr8Aqkt0Ttwk0V9gIWPGnxtGNcLN2fJeM9Th8R0scA4M02U4iLF?=
 =?us-ascii?Q?B5Wk9HXGg5P3fYWpoLuZ2hko8LRhG+l+KrmYRBZUYp36VXlZLXq3CsjUHgY8?=
 =?us-ascii?Q?oRpIX75+MRAjzo1IlenM2YAQBbsz5mE67aLChA0mTUb0x3K1pzTBs5ill67A?=
 =?us-ascii?Q?WEqu57aQZXHYLQnOwcuaA+qHtML9rcGqP3RCZiHoNRpAOfEiUGfjsTQjGnn5?=
 =?us-ascii?Q?dGMfLLN50VJXvI7KIbhoqn2bMwPeYT2npAAbuoY/qm9KYg5bPJBrykyzyHT3?=
 =?us-ascii?Q?+lWZv25Q741HVawhnPaZGnvl531j9yFYx0nGVaytSZSIvSxVlOdPcg9c5QyP?=
 =?us-ascii?Q?onw1sZr8o2oKCIkqsCMRmHOFA4JsHzx0tJFR9dkKIK/rAZcD0FwyBIxoEwG+?=
 =?us-ascii?Q?XVp/IEO0/YAiXNIdnZMkJ7kmAVq59fwx4u45UTo9CZX8R6inhznRK3SosMDB?=
 =?us-ascii?Q?Ehc1OUqP3N+nUvGDOYWnRxadmwkiCr2RRUWnWgAR+mSOmNBT5YiDM4XGEihc?=
 =?us-ascii?Q?hb0LQ9GY98MD++dYcIJxfuBu8NRS9u08Ym8UX23opyfIAVvIQz8znKALFVzg?=
 =?us-ascii?Q?AmiAAJi0URDAznQ8TwaG0EalIvjySlePNiePLc+exJcGzfLWCE6daqI87QNc?=
 =?us-ascii?Q?y4WDLIyzAGzlvFRSQ5xyiOT+5BQohQ9vroy2Y14+u+HfIpZGDI5lkL80jD6v?=
 =?us-ascii?Q?zsph6XII7ymmUqYkGfS26i2GZQPjFJO4DuB1qfD4Br2a8gVRIQ8QYjBxCZh0?=
 =?us-ascii?Q?OfLRSyL9iTQu9f8TVhgSbOnj?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1d59dbd-2414-4a19-0426-08d9054284f3
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Apr 2021 03:55:50.3984
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wwWXdfSDBigQv5UgH8cpuwgfgh3YLK4ChJBPx2Z1ahKm6rK2CX4fORA0WxiUuuHiuRFuOcfkwomggUyAL5FYcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4904
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, April 22, 2021 12:50 AM
>=20
> On Wed, 21 Apr 2021 10:47:18 -0700 Saeed Mahameed wrote:
> > From: Parav Pandit <parav@nvidia.com>
> >
> > Extended SF port attributes to have optional external flag similar to
> > PCI PF and VF port attributes.
> >
> > External atttibute is required to generate unique phys_port_name when
> > PF number and SF number are overlapping between two controllers
> > similar to SR-IOV VFs.
> >
> > When a SF is for external controller an example view of external SF
> > port and config sequence.
> >
> > On eswitch system:
> > $ devlink dev eswitch set pci/0033:01:00.0 mode switchdev
> >
> > $ devlink port show
> > pci/0033:01:00.0/196607: type eth netdev enP51p1s0f0np0 flavour
> > physical port 0 splittable false
> > pci/0033:01:00.0/131072: type eth netdev eth0 flavour pcipf controller =
1
> pfnum 0 external true splittable false
> >   function:
> >     hw_addr 00:00:00:00:00:00
> >
> > $ devlink port add pci/0033:01:00.0 flavour pcisf pfnum 0 sfnum 77
> > controller 1
> > pci/0033:01:00.0/163840: type eth netdev eth1 flavour pcisf controller =
1
> pfnum 0 sfnum 77 splittable false
> >   function:
> >     hw_addr 00:00:00:00:00:00 state inactive opstate detached
> >
> > phys_port_name construction:
> > $ cat /sys/class/net/eth1/phys_port_name
> > c1pf0sf77
> >
> > Signed-off-by: Parav Pandit <parav@nvidia.com>
> > Reviewed-by: Jiri Pirko <jiri@nvidia.com>
> > Reviewed-by: Vu Pham <vuhuong@nvidia.com>
> > Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
>=20
> I have a feeling I nacked this in the past, but can't find the thread.
> Was something similar previously posted?
Your memory is correct.
In past external flag was present but it was always set to false.
So you asked to move out until we set it to true, which we did.
This series uses it as true similar to existing PF and VF eswitch ports of =
an external controller.
Hence, it was removed from past series and done in this series that actuall=
y uses it.
