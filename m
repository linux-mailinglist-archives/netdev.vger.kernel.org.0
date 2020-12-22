Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1AD2E0B47
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 15:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727402AbgLVOAY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 09:00:24 -0500
Received: from mail-dm6nam11on2123.outbound.protection.outlook.com ([40.107.223.123]:47328
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727193AbgLVOAX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 09:00:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hsdiVvpPoUcZsfXGP4ez4WQgevDPzMAS1QD+2ETzY6Nrqu20xA+7dUP9M3R2VrE/6dbLQm0ZQLQXmWKxrn7mL3kmRAArapiOQ4DdimQwOHCB5kFcfAG1B5SpZLRIrOIzPUJKMQ4IEuUGkAfyonRs2dwD53oQxlFYP6wlXrhWaPtLAAqK1O0EkhzHKQU/7rErcVcAY6tIb+zdmm1a5zna5lAoxILF144pj1coiRO7dmIyaqAu1xEMR9Ywv9xWG8P/4Caluj9y/nUgZdjKTFnMTBWw4qDmqWBQq/yw/kmvemBATDI0xaeu5HdfDKw6+WErfrQPpxnGcn/Rb0amKKy3GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HDUF0cAZKsfGHVVAzPQFLDjwoHQMjOWQMJbha1injtc=;
 b=mgARonGYB2DUgkJvBotVfWCIYqpl77YmMNYo6WywTozHAGyM10yeoBc/yPCf7/KF6AYaGcHJ39/ZHFJATHyJ6QW3Xtgew8zMBYgDxxrDu6zM4grQ4NSjwk5o7yklvd9HdxDc3I2yqClUKLa6g+nNA3NVPNnzZFi8nGwKHqAWZgy5IjP7Y7+oGH6Cv1a7fH6x8CXbs0C2eiqvCUzvC4F0eqndCWdIRvJJ0lvA76ppwWMc01i2LvYeXQNlN3Nb/NAg0i/KZdPTV0WRoBUnmKIkAOB7X900mQ8dCn1s9B7eyWd8Q/3O4lig+wWeaKEwxsy3kMHy3/yblQUky1fPL05j2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HDUF0cAZKsfGHVVAzPQFLDjwoHQMjOWQMJbha1injtc=;
 b=cXnOxJ36/ckPOYUDMmlZgFitcn5Qt3pRj8du88JiKWcStwX4zpIp3hz2n5IKSyM6K6yIJ7OC1w6DufhySIbfRjPe5H5P4kWpKlBUeLAzJniMXjuJCcm1aRYNyViYGqXBGRlVFTDFmWKv8TXBSwO2uIVNqa3qQWWZmKK74Eat7mU=
Received: from (2603:10b6:302:a::16) by
 MW2PR2101MB1834.namprd21.prod.outlook.com (2603:10b6:302:7::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3700.4; Tue, 22 Dec
 2020 13:59:34 +0000
Received: from MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::b8f6:e748:cdf2:1922]) by MW2PR2101MB1052.namprd21.prod.outlook.com
 ([fe80::b8f6:e748:cdf2:1922%8]) with mapi id 15.20.3721.008; Tue, 22 Dec 2020
 13:59:34 +0000
From:   Michael Kelley <mikelley@microsoft.com>
To:     "Andrea Parri (Microsoft)" <parri.andrea@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        Juan Vazquez <juvazq@microsoft.com>,
        Saruhan Karademir <skarade@microsoft.com>,
        Andres Beltran <lkmlabelt@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: RE: [PATCH v3] Drivers: hv: vmbus: Copy packets sent by Hyper-V out
 of the ring buffer
Thread-Topic: [PATCH v3] Drivers: hv: vmbus: Copy packets sent by Hyper-V out
 of the ring buffer
Thread-Index: AQHWzR4az71bP2nb+UG9oIbXZQA7faoDOtVA
Date:   Tue, 22 Dec 2020 13:59:34 +0000
Message-ID: <MW2PR2101MB10523546B825880C298E1C64D7DF9@MW2PR2101MB1052.namprd21.prod.outlook.com>
References: <20201208045311.10244-1-parri.andrea@gmail.com>
In-Reply-To: <20201208045311.10244-1-parri.andrea@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-12-22T13:59:32Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=5c5a53a7-7716-4111-bbd9-53313df8a34b;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [24.22.167.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a4170048-d2d6-4bdc-daf7-08d8a681d038
x-ms-traffictypediagnostic: MW2PR2101MB1834:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR2101MB18348BF4CA5C7D501673F6C2D7DF9@MW2PR2101MB1834.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Z7anvE4OTvPC3mkapRkWC5dPoI6umCL0gGKCrBn1G9cr5GeMQjEtViXnQbpuvhkTssrAkCvdLSIimDpG2j9PrPGJP9qtm4sri5FSajAfU81O7p9aAqhFTdUFvHEbXXAnkFYw7QLMurhK+ydaw2oGDLUOFQSmmuWNdH+M8ED9haWNN6HaBtkmcfN/KGkIeJskgUhE/zHLr60QGYvLFzcVlcnHcp6G57zEvwDfR8NyXNdnKB8epvbwoB9GaOmgDLKeH+ev1yN0D48mYnD6RkcnT6fN36o/8ZuNyOAYxfhAhQeemkNdhQqbEfn5g79pzZwRfTknUgrbcrC8bg3fepoqlUb9DPT3BOpoRZ253XL/rf0+9MZHB9j5gOqkslWZJOVroLSUkYfmfJgyG8OGjt8nrA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB1052.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(39860400002)(376002)(396003)(136003)(66476007)(55016002)(9686003)(66556008)(7416002)(76116006)(8936002)(66946007)(4326008)(7696005)(82950400001)(82960400001)(83380400001)(2906002)(64756008)(66446008)(52536014)(6506007)(5660300002)(8676002)(33656002)(54906003)(8990500004)(110136005)(86362001)(71200400001)(478600001)(316002)(186003)(26005)(10290500003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?jOHJwnfTomzAf+lbOkTppvlteu6OX+KEp7I7ErJCwfir7f3fu9Xj7arMtWKa?=
 =?us-ascii?Q?+BhdTh54gyJc15sjRneDXTHEquuY6BFMe30qbhzTFEiWSZyLYRMDEAayMzIW?=
 =?us-ascii?Q?pzDAfmkMeznu+NFoIQE+HdggLC5TfHh6PBcs8+U25dXXLKNjwUcyvs8wgc+O?=
 =?us-ascii?Q?/ffs8b7ZfQQj7z+cRiRWEiKAUeHNa+A8OnNI8M+H9uRN2bnaHZsoh1Yz19P2?=
 =?us-ascii?Q?yJ0kVa+Sm8vvrIBKmskcLQ5ffvuUBzuVTX2ns9WaVXSBTewr5uDsh3lVdF9w?=
 =?us-ascii?Q?A8Kq/0V3rUyQXSqapL9VoDhWiWTtDfy2Yfuw0oxgxdbzFN0nZBCTA9mhmdDz?=
 =?us-ascii?Q?iyYW6KCsmbA3srhBQ69TJFfQYvoA1ua/6J2cXHSf6q6TWIr5NbAS8/AOGd+r?=
 =?us-ascii?Q?X62QUbpdxeUMcFoDExr9OLYqzHrXfU1jC3OMYGLKYfxS+uOKu3djqsdFvCkw?=
 =?us-ascii?Q?6OGbLa8HxGKlHX7WcdGTV/zUjPHOqiHfeurxzilR8E4+2l56l8X5qeewXXMQ?=
 =?us-ascii?Q?Wq5vUrGgEmCnFQkRjni7dAZy9czvtn/9d6OXeHY/CI5hCqTKHbucS7SozPHT?=
 =?us-ascii?Q?T7kLIUxsbNkaGzFDHLi+ei0+IQLfG44PRIpiw66l+O3sEbiF1ArVh8mA1xRz?=
 =?us-ascii?Q?XSVB04ZVeZ5yHyjTsHuKrkKosJGMdJfyYJFID5pI16D6gDRfd10f/lL1t/AP?=
 =?us-ascii?Q?UFK12u2+U0bl1Bn20Oh3NNyRbu2Ncp9X4vNe1y1H82O4bQRFgNhuaGI/3Kbj?=
 =?us-ascii?Q?a8/FMTcaPyYaWOeR9mpESJDCUBXnfIdc2RsGZSpFDThu3CdqVCM9Hr9Y/duf?=
 =?us-ascii?Q?8vgufQn5RyCZRrFxn+lnqCOMXf5uIsxx+BvOwBts5K9k8McSPcbB2mLhwEiT?=
 =?us-ascii?Q?Ak8dlQ7rqGYWuvqKso7x7UViE4XgSjxUvgjuv1szwW1RMumk7pz64okeuKiu?=
 =?us-ascii?Q?gs2vLK+0/r4rs1rDYW5XSIiLPGm5OAkGf8rX5XOdcbE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB1052.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4170048-d2d6-4bdc-daf7-08d8a681d038
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Dec 2020 13:59:34.5575
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XGkYLgKNuxMyr+9VDYs70P5DBj0HvMHoLz5s6FUhdQn0fmjwEHPdgBmJtvOYySbKtQgPilOPNKExvo7ejPQcCoLAPUaf33aujZ5Id0PdWUk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR2101MB1834
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrea Parri (Microsoft) <parri.andrea@gmail.com> Sent: Monday, Decem=
ber 7, 2020 8:53 PM
>=20
> From: Andres Beltran <lkmlabelt@gmail.com>
>=20
> Pointers to ring-buffer packets sent by Hyper-V are used within the
> guest VM. Hyper-V can send packets with erroneous values or modify
> packet fields after they are processed by the guest. To defend
> against these scenarios, return a copy of the incoming VMBus packet
> after validating its length and offset fields in hv_pkt_iter_first().
> In this way, the packet can no longer be modified by the host.
>=20
> Signed-off-by: Andres Beltran <lkmlabelt@gmail.com>
> Co-developed-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> Signed-off-by: Andrea Parri (Microsoft) <parri.andrea@gmail.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: netdev@vger.kernel.org
> Cc: linux-scsi@vger.kernel.org
> ---
>  drivers/hv/channel.c              |  9 ++--
>  drivers/hv/hv_fcopy.c             |  1 +
>  drivers/hv/hv_kvp.c               |  1 +
>  drivers/hv/hyperv_vmbus.h         |  2 +-
>  drivers/hv/ring_buffer.c          | 82 ++++++++++++++++++++++++++-----
>  drivers/net/hyperv/hyperv_net.h   |  3 ++
>  drivers/net/hyperv/netvsc.c       |  2 +
>  drivers/net/hyperv/rndis_filter.c |  2 +
>  drivers/scsi/storvsc_drv.c        | 10 ++++
>  include/linux/hyperv.h            | 48 +++++++++++++++---
>  net/vmw_vsock/hyperv_transport.c  |  4 +-
>  11 files changed, 139 insertions(+), 25 deletions(-)
>=20

Reviewed-by: Michael Kelley <mikelley@microsoft.com>
