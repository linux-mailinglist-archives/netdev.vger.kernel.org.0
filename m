Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A66313D4C7
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 07:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727011AbgAPG7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 01:59:35 -0500
Received: from mail-vi1eur05on2077.outbound.protection.outlook.com ([40.107.21.77]:21205
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725973AbgAPG7e (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 01:59:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fUZWl40mblkthLAp5vYfNm2wE/FjvrHq3QWh2TvJU86vF0GIbsfpNzT1X1XT1pFBu4V81C/S0iJMTNpMkZJbbhBWoUGpLHgZTLNRSan5XQoHnbZHRB7tB1kGNMzdAYL4dNNfAot2NgxRq2xtv8D/51DJZRgvdc2Y7Pez27FX2lvjlbDp8eTy2q5Qnc7Qmr1BYaalvSzc5MKok48163Dl/fAh9CtRs42K7FdfPuZu3s+u3eJT9V2UpiqpLyboBTmQADh7iXhT98PeMYy+VHqD086R3f72IkfQGbrpSiCtKPhy2Wywhs5P2TQNNLWRnQNhYp4Sq5BT70xBrY+B8Al7rQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GKPy4VDWGUworjY263Ob3CUjFEFzeAVc1Qe/qjUaLXU=;
 b=gSTTx7qv6YLWmUg4/M9X/rM6i7fbwCA8I/jMbCShUglkXHn5AYspteSYzscgXsmnSx4tEfzvSdxczaxF3DTDiuZzARvncpZZ33KgD3dGd/IiAueFdvu6Cid5bH2ai/4ZrTEPOsZR0dO0rbBq8LzBeOFLFFXcwZm8RUX2QoTa+l6bNzkssuPsN68Kv9a3ESwq1n71r0O90s+2/j+HImnF+v9XGwAemUlR/ZmfcDxQuVkDCW/mRLsGDUqQtC1MlWd/aML0Gtz9JIBzFa5wDnmzZg+qBVf0fkkDEogjraTFAGt9i+iYLP5DIzoCRX2TPnRN4Dz+LgwJuGDCo9ENWZOLeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GKPy4VDWGUworjY263Ob3CUjFEFzeAVc1Qe/qjUaLXU=;
 b=j64IcIqIOca4km/Tc+wsvaRw6c1bBh5jmNAf/o1oc3I6hetQ7JAAzzAuFGJo5b5YAOj035HoTHcnChn55t8sBzJRGThMRx+5KBAmcmSldwsfZMSllP/EC3J3My2uhvphW4PnkmZg8Zd3JNQ6LX2QNOHkuJHWhE49NJKdmU+Zxfo=
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com (20.179.5.215) by
 AM6PR05MB6069.eurprd05.prod.outlook.com (20.179.3.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Thu, 16 Jan 2020 06:59:29 +0000
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::d1:c74b:50e8:adba]) by AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::d1:c74b:50e8:adba%5]) with mapi id 15.20.2623.017; Thu, 16 Jan 2020
 06:59:29 +0000
Received: from localhost (2a00:a040:183:2d::810) by AM0PR01CA0085.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.19 via Frontend Transport; Thu, 16 Jan 2020 06:59:28 +0000
From:   Leon Romanovsky <leonro@mellanox.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>
CC:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Hans Westgaard Ry <hans.westgaard.ry@oracle.com>,
        Moni Shoua <monis@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH mlx5-next 00/10] Use ODP MRs for kernel ULPs
Thread-Topic: [PATCH mlx5-next 00/10] Use ODP MRs for kernel ULPs
Thread-Index: AQHVzDp/CSjR/DYOQk+aO4L2fYjfAg==
Date:   Thu, 16 Jan 2020 06:59:29 +0000
Message-ID: <20200116065926.GD76932@unreal>
References: <20200115124340.79108-1-leon@kernel.org>
In-Reply-To: <20200115124340.79108-1-leon@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM0PR01CA0085.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::26) To AM6PR05MB6408.eurprd05.prod.outlook.com
 (2603:10a6:20b:b8::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2a00:a040:183:2d::810]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 30686047-ab61-4a08-862e-08d79a51a183
x-ms-traffictypediagnostic: AM6PR05MB6069:|AM6PR05MB6069:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB60692D7531F8B87A2D51181DB0360@AM6PR05MB6069.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2733;
x-forefront-prvs: 02843AA9E0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(4636009)(366004)(136003)(346002)(376002)(39860400002)(396003)(189003)(199004)(71200400001)(4326008)(6486002)(16526019)(33716001)(186003)(66556008)(66446008)(2906002)(66476007)(66946007)(6496006)(52116002)(64756008)(316002)(86362001)(110136005)(54906003)(5660300002)(81156014)(8936002)(478600001)(33656002)(8676002)(9686003)(1076003)(81166006);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB6069;H:AM6PR05MB6408.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R//8020csxm2UKWAfD1WQLyIwbblClJrgXobnT1wk9GLryFqa6n9vR7cnEN23uafLxA4ykX2NKuYV/erUpc7UmFc3XiQlDqJhbElRkarU+hWEGAa5zRGbdUPz2Ek8foHcJhL1ICkZKvspRg0gwHWo3rb3h348UVNJXPkMmoBE2ScBGADB2LQglOJp9c+gVs9DW5ArTSfa5ADg1VjOxkpNQQHhaTnd1r6pDN+LO6pSWGtT3nxZarpG/U44CXL2VbQqFGmOTofthd4y4DFQ79o87g/THs9bJtX6OmpFydXjvbcoiCbztJmDaXeUkOZDfisCHXHALtrArlAj2zND4WwxmEeyqNy+oIavivhvZGf8XDbiHe0Y+K/DiumY0GWgqzi6/blG1QfU03ult0CgjV+Jz3XbbPmzmu+BI+J2srTIwiT8eVS0yxS4TlvwP86RM6J
Content-Type: text/plain; charset="us-ascii"
Content-ID: <77C8EEFDF27B6A4FBA19C65AE2EBE3D3@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30686047-ab61-4a08-862e-08d79a51a183
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2020 06:59:29.3161
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: StRZ2tHjoCB0e0kZ9C3g20/owhTeBw6mWUZlT1ZY6lfdcplM5Jzkbjp9hXvFKM78YQk3IvmVN6Zua7qDx3q07g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6069
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 15, 2020 at 02:43:30PM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
>
> Hi,
>
> The following series extends MR creation routines to allow creation of
> user MRs through kernel ULPs as a proxy. The immediate use case is to
> allow RDS to work over FS-DAX, which requires ODP (on-demand-paging)
> MRs to be created and such MRs were not possible to create prior this
> series.
>
> The first part of this patchset extends RDMA to have special verb
> ib_reg_user_mr(). The common use case that uses this function is a usersp=
ace
> application that allocates memory for HCA access but the responsibility
> to register the memory at the HCA is on an kernel ULP. This ULP that acts
> as an agent for the userspace application.
>
> The second part provides advise MR functionality for ULPs. This is
> integral part of ODP flows and used to trigger pagefaults in advance
> to prepare memory before running working set.
>
> The third part is actual user of those in-kernel APIs.
>
> Thanks
>
> Hans Westgaard Ry (3):
>   net/rds: Detect need of On-Demand-Paging memory registration
>   net/rds: Handle ODP mr registration/unregistration
>   net/rds: Use prefetch for On-Demand-Paging MR
>
> Jason Gunthorpe (1):
>   RDMA/mlx5: Fix handling of IOVA !=3D user_va in ODP paths
>
> Leon Romanovsky (1):
>   RDMA/mlx5: Don't fake udata for kernel path
>
> Moni Shoua (5):
>   IB: Allow calls to ib_umem_get from kernel ULPs
>   IB/core: Introduce ib_reg_user_mr
>   IB/core: Add interface to advise_mr for kernel users
>   IB/mlx5: Add ODP WQE handlers for kernel QPs
>   IB/mlx5: Mask out unsupported ODP capabilities for kernel QPs
>
>  drivers/infiniband/core/umem.c                |  27 +--
>  drivers/infiniband/core/umem_odp.c            |  29 +--
>  drivers/infiniband/core/verbs.c               |  41 +++++
>  drivers/infiniband/hw/bnxt_re/ib_verbs.c      |  12 +-
>  drivers/infiniband/hw/cxgb4/mem.c             |   2 +-
>  drivers/infiniband/hw/efa/efa_verbs.c         |   4 +-
>  drivers/infiniband/hw/hns/hns_roce_cq.c       |   2 +-
>  drivers/infiniband/hw/hns/hns_roce_db.c       |   3 +-
>  drivers/infiniband/hw/hns/hns_roce_mr.c       |   4 +-
>  drivers/infiniband/hw/hns/hns_roce_qp.c       |   2 +-
>  drivers/infiniband/hw/hns/hns_roce_srq.c      |   5 +-
>  drivers/infiniband/hw/i40iw/i40iw_verbs.c     |   5 +-
>  drivers/infiniband/hw/mlx4/cq.c               |   2 +-
>  drivers/infiniband/hw/mlx4/doorbell.c         |   3 +-
>  drivers/infiniband/hw/mlx4/mr.c               |   8 +-
>  drivers/infiniband/hw/mlx4/qp.c               |   5 +-
>  drivers/infiniband/hw/mlx4/srq.c              |   3 +-
>  drivers/infiniband/hw/mlx5/cq.c               |   6 +-
>  drivers/infiniband/hw/mlx5/devx.c             |   2 +-
>  drivers/infiniband/hw/mlx5/doorbell.c         |   3 +-
>  drivers/infiniband/hw/mlx5/main.c             |  51 ++++--
>  drivers/infiniband/hw/mlx5/mlx5_ib.h          |  12 +-
>  drivers/infiniband/hw/mlx5/mr.c               |  20 +--
>  drivers/infiniband/hw/mlx5/odp.c              |  33 ++--
>  drivers/infiniband/hw/mlx5/qp.c               | 167 +++++++++++-------
>  drivers/infiniband/hw/mlx5/srq.c              |   2 +-
>  drivers/infiniband/hw/mthca/mthca_provider.c  |   2 +-
>  drivers/infiniband/hw/ocrdma/ocrdma_verbs.c   |   2 +-
>  drivers/infiniband/hw/qedr/verbs.c            |   9 +-
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_cq.c  |   2 +-
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_mr.c  |   2 +-
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c  |   7 +-
>  drivers/infiniband/hw/vmw_pvrdma/pvrdma_srq.c |   2 +-
>  drivers/infiniband/sw/rdmavt/mr.c             |   2 +-
>  drivers/infiniband/sw/rxe/rxe_mr.c            |   2 +-
>  include/rdma/ib_umem.h                        |   4 +-
>  include/rdma/ib_umem_odp.h                    |   6 +-
>  include/rdma/ib_verbs.h                       |   9 +
>  net/rds/ib.c                                  |   7 +
>  net/rds/ib.h                                  |   3 +-
>  net/rds/ib_mr.h                               |   7 +-
>  net/rds/ib_rdma.c                             |  83 ++++++++-
>  net/rds/ib_send.c                             |  44 +++--
>  net/rds/rdma.c                                | 156 +++++++++++-----
>  net/rds/rds.h                                 |  13 +-
>  45 files changed, 559 insertions(+), 256 deletions(-)

Thanks Santosh for your review.

David,
Is it ok to route those patches through RDMA tree given the fact that
we are touching a lot of files in drivers/infiniband/* ?

There is no conflict between netdev and RDMA versions of RDS, but to be
on safe side, I'll put all this code to mlx5-next tree.

Thanks

>
> --
> 2.20.1
>
