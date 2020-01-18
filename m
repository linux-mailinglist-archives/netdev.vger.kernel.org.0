Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 294EF1416F9
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 11:20:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbgARKUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 05:20:08 -0500
Received: from mail-vi1eur05on2052.outbound.protection.outlook.com ([40.107.21.52]:6134
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726831AbgARKUH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Jan 2020 05:20:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TbOJdlI8k3QFEGI4xsR6/vrVR0H6yablHs5Z7XaBhyzedQL7c2UAN80ZW89WdfhIDgQlvyzcLl19HHqHjmZ5cO+Tphy+xxgTnc7Z15/teXxyeGNCcZZceNZ+nlWwg2kcGzkUPUfmUmlwIPqwj/0kDJNoWcRNy0LGnfZxIbA2YAKemQgKnFORZlHrkTFeLnFlCnAj89pqYSgr78r6n8BmeS12WQHTlZlvIVzUetE7LPi8u+Z6CcFLXbZ0a+ZYAe7Sgt+r17F3Cajc46KlEd4p1wSPMeKYOOnj9ZioIb56mzsiibwnYc8gaT1NtUkePV0JP99g6t50FBXTx9ODnWvFsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eanCMBfTXOOgSEIzULUu/j8Vle5vwS2mhq9IXvmKbV8=;
 b=lo8bxhTBJLD5aMuPC1c9ZozlZJnVZwRuXGk3UJRL8pRvLCUnihVjI29sImSH4iJUYP1pNDrD5TgTa0qJq1F5/B1q7aEVcOXjUdqs181V3spVlm0sCm8ivV/4NJyTTDOAMBVTDienhQHxqSYLLYR+Q0IO+7qQHQaLVp2eKjcoPIcQlpAEsjqcGKioQiaCNAvgscQQvCtjiuiHsBl1fkCrt9FKX2fW5uWNh6jgGsC/sSF4sfhG25BsR8ovyL7f0ZS9u/ywj+yf0UfEpIeSCmKTw7UwlYxXCnEayUk5BcV2BwSHCyIvO+N7lvZ9NC8BUN3+pxmfIVxba562HmjYWp8hXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eanCMBfTXOOgSEIzULUu/j8Vle5vwS2mhq9IXvmKbV8=;
 b=sueet6wGI84iPcOG+fBGRrt/7oe/6Kq3D4YSt1VOqwgzMMGYpHHhGhPPOjmX0weqxmJnUgI0FS1fAmA29imH4U0Cr/nW8HboHWas+lK7hdB84zSeXyFMHdDDsquFBuS2bCEvOM50aPgw5+tFOyhak/iy8fxf+cVC8RgA0QUYnDw=
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com (20.179.5.215) by
 AM6PR05MB5569.eurprd05.prod.outlook.com (20.177.119.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.19; Sat, 18 Jan 2020 10:19:55 +0000
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::d1:c74b:50e8:adba]) by AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::d1:c74b:50e8:adba%5]) with mapi id 15.20.2644.024; Sat, 18 Jan 2020
 10:19:54 +0000
Received: from localhost (2a00:a040:183:2d::810) by PR2P264CA0029.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101:1::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Sat, 18 Jan 2020 10:19:53 +0000
From:   Leon Romanovsky <leonro@mellanox.com>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>
CC:     RDMA mailing list <linux-rdma@vger.kernel.org>,
        Hans Westgaard Ry <hans.westgaard.ry@oracle.com>,
        Moni Shoua <monis@mellanox.com>,
        linux-netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH mlx5-next 09/10] net/rds: Handle ODP mr
 registration/unregistration
Thread-Topic: [PATCH mlx5-next 09/10] net/rds: Handle ODP mr
 registration/unregistration
Thread-Index: AQHVzejRF9GQf/kdT0GhRuTQa3ZPLg==
Date:   Sat, 18 Jan 2020 10:19:54 +0000
Message-ID: <20200118101951.GB51881@unreal>
References: <20200115124340.79108-1-leon@kernel.org>
 <20200115124340.79108-10-leon@kernel.org>
In-Reply-To: <20200115124340.79108-10-leon@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2P264CA0029.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:101:1::17) To AM6PR05MB6408.eurprd05.prod.outlook.com
 (2603:10a6:20b:b8::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2a00:a040:183:2d::810]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c34c8530-a200-4765-7749-08d79bfff5db
x-ms-traffictypediagnostic: AM6PR05MB5569:|AM6PR05MB5569:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB55693A722C005D103D688311B0300@AM6PR05MB5569.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:785;
x-forefront-prvs: 0286D7B531
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(7916004)(4636009)(376002)(39860400002)(136003)(346002)(396003)(366004)(199004)(189003)(8676002)(52116002)(8936002)(71200400001)(33656002)(81166006)(5660300002)(6496006)(2906002)(110136005)(1076003)(4326008)(9686003)(30864003)(54906003)(33716001)(16526019)(66446008)(66946007)(81156014)(6486002)(66476007)(86362001)(478600001)(316002)(186003)(64756008)(66556008)(21314003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5569;H:AM6PR05MB6408.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lHYesu4CQl8AdeGQ7a8msunq+YvI/79P9PlyMxyesyEu64mm00RUYrFWHQ0sPq3sriYuWmoc/7Z8GvFfThL7Ptir8iXe/5mqyirI+RrogILp4QanM347VI4kcErp+YNPawYNursmerq9ZdR5nD6mfdS+XwfWr1j4OcboHisb/i278Mc7mlcII1KLdrYh4lY7pTA8OQIvlp3oCjKpO70CjHtaqOVCtFi14CJOwbyg1O9g+0sWl4/zC3aWxbWIuae6V3LyF55cGQcW4mdJPSY9Q63UJA6HQTX0Xq/+n+2/GECeEfxX1CL4HAihhZNyzxIiiepnZYNv8d2nlUixnMIMh7YWtlCEJlqfrJ0EFzjAuiiOXjSBY/ibKT0v+g/9x6nXG8dOZqPPGlJsDf4lkQpCKHcxn0qk3upIHFRbyErFfQbFI6kdBE04iOee6nJXcc4sNXmEEf6XNTGT6/75oKgzgorVyZ+72PWL8O0Rza9hUPY=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <FA6C6B3B40A0184C9BE337A80BB8F888@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c34c8530-a200-4765-7749-08d79bfff5db
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2020 10:19:54.6807
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: n7FHPgefxXnuTzOR45RTC2uruIQgkMh1Ut13monm7y8BH2WlhgVzFBa6TWJrr4gaIo4nvuVuPiDDK3TXf8UgJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5569
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 15, 2020 at 02:43:39PM +0200, Leon Romanovsky wrote:
> From: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
>
> On-Demand-Paging MRs are registered using ib_reg_user_mr and
> unregistered with ib_dereg_mr.
>
> Signed-off-by: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  net/rds/ib.c      |   7 +++
>  net/rds/ib.h      |   3 +-
>  net/rds/ib_mr.h   |   7 ++-
>  net/rds/ib_rdma.c |  74 ++++++++++++++++++++++-
>  net/rds/ib_send.c |  44 ++++++++++----
>  net/rds/rdma.c    | 150 ++++++++++++++++++++++++++++++++++------------
>  net/rds/rds.h     |  13 +++-
>  7 files changed, 242 insertions(+), 56 deletions(-)
>
> diff --git a/net/rds/ib.c b/net/rds/ib.c
> index 3fd5f40189bd..a792d8a3872a 100644
> --- a/net/rds/ib.c
> +++ b/net/rds/ib.c
> @@ -156,6 +156,13 @@ static void rds_ib_add_one(struct ib_device *device)
>  	has_fmr =3D (device->ops.alloc_fmr && device->ops.dealloc_fmr &&
>  		   device->ops.map_phys_fmr && device->ops.unmap_fmr);
>  	rds_ibdev->use_fastreg =3D (has_fr && !has_fmr);
> +	rds_ibdev->odp_capable =3D
> +		!!(device->attrs.device_cap_flags &
> +		   IB_DEVICE_ON_DEMAND_PAGING) &&
> +		!!(device->attrs.odp_caps.per_transport_caps.rc_odp_caps &
> +		   IB_ODP_SUPPORT_WRITE) &&
> +		!!(device->attrs.odp_caps.per_transport_caps.rc_odp_caps &
> +		   IB_ODP_SUPPORT_READ);
>
>  	rds_ibdev->fmr_max_remaps =3D device->attrs.max_map_per_fmr?: 32;
>  	rds_ibdev->max_1m_mrs =3D device->attrs.max_mr ?
> diff --git a/net/rds/ib.h b/net/rds/ib.h
> index 6e6f24753998..0296f1f7acda 100644
> --- a/net/rds/ib.h
> +++ b/net/rds/ib.h
> @@ -247,7 +247,8 @@ struct rds_ib_device {
>  	struct ib_device	*dev;
>  	struct ib_pd		*pd;
>  	struct dma_pool		*rid_hdrs_pool; /* RDS headers DMA pool */
> -	bool                    use_fastreg;
> +	u8			use_fastreg:1;
> +	u8			odp_capable:1;
>
>  	unsigned int		max_mrs;
>  	struct rds_ib_mr_pool	*mr_1m_pool;
> diff --git a/net/rds/ib_mr.h b/net/rds/ib_mr.h
> index 9045a8c0edff..0c8252d7fe2b 100644
> --- a/net/rds/ib_mr.h
> +++ b/net/rds/ib_mr.h
> @@ -67,6 +67,7 @@ struct rds_ib_frmr {
>
>  /* This is stored as mr->r_trans_private. */
>  struct rds_ib_mr {
> +	struct delayed_work		work;
>  	struct rds_ib_device		*device;
>  	struct rds_ib_mr_pool		*pool;
>  	struct rds_ib_connection	*ic;
> @@ -81,9 +82,11 @@ struct rds_ib_mr {
>  	unsigned int			sg_len;
>  	int				sg_dma_len;
>
> +	u8				odp:1;
>  	union {
>  		struct rds_ib_fmr	fmr;
>  		struct rds_ib_frmr	frmr;
> +		struct ib_mr		*mr;
>  	} u;
>  };
>
> @@ -122,12 +125,14 @@ void rds6_ib_get_mr_info(struct rds_ib_device *rds_=
ibdev,
>  void rds_ib_destroy_mr_pool(struct rds_ib_mr_pool *);
>  void *rds_ib_get_mr(struct scatterlist *sg, unsigned long nents,
>  		    struct rds_sock *rs, u32 *key_ret,
> -		    struct rds_connection *conn);
> +		    struct rds_connection *conn, u64 start, u64 length,
> +		    int need_odp);
>  void rds_ib_sync_mr(void *trans_private, int dir);
>  void rds_ib_free_mr(void *trans_private, int invalidate);
>  void rds_ib_flush_mrs(void);
>  int rds_ib_mr_init(void);
>  void rds_ib_mr_exit(void);
> +u32 rds_ib_get_lkey(void *trans_private);
>
>  void __rds_ib_teardown_mr(struct rds_ib_mr *);
>  void rds_ib_teardown_mr(struct rds_ib_mr *);
> diff --git a/net/rds/ib_rdma.c b/net/rds/ib_rdma.c
> index c8c1e3ae8d84..5a02b313ec50 100644
> --- a/net/rds/ib_rdma.c
> +++ b/net/rds/ib_rdma.c
> @@ -37,8 +37,15 @@
>
>  #include "rds_single_path.h"
>  #include "ib_mr.h"
> +#include "rds.h"
>
>  struct workqueue_struct *rds_ib_mr_wq;
> +struct rds_ib_dereg_odp_mr {
> +	struct work_struct work;
> +	struct ib_mr *mr;
> +};
> +
> +static void rds_ib_odp_mr_worker(struct work_struct *work);
>
>  static struct rds_ib_device *rds_ib_get_device(__be32 ipaddr)
>  {
> @@ -213,6 +220,8 @@ void rds_ib_sync_mr(void *trans_private, int directio=
n)
>  	struct rds_ib_mr *ibmr =3D trans_private;
>  	struct rds_ib_device *rds_ibdev =3D ibmr->device;
>
> +	if (ibmr->odp)
> +		return;
>  	switch (direction) {
>  	case DMA_FROM_DEVICE:
>  		ib_dma_sync_sg_for_cpu(rds_ibdev->dev, ibmr->sg,
> @@ -482,6 +491,16 @@ void rds_ib_free_mr(void *trans_private, int invalid=
ate)
>
>  	rdsdebug("RDS/IB: free_mr nents %u\n", ibmr->sg_len);
>
> +	if (ibmr->odp) {
> +		/* A MR created and marked as use_once. We use delayed work,
> +		 * because there is a change that we are in interrupt and can't
> +		 * call to ib_dereg_mr() directly.
> +		 */
> +		INIT_DELAYED_WORK(&ibmr->work, rds_ib_odp_mr_worker);
> +		queue_delayed_work(rds_ib_mr_wq, &ibmr->work, 0);
> +		return;
> +	}
> +
>  	/* Return it to the pool's free list */
>  	if (rds_ibdev->use_fastreg)
>  		rds_ib_free_frmr_list(ibmr);
> @@ -526,9 +545,17 @@ void rds_ib_flush_mrs(void)
>  	up_read(&rds_ib_devices_lock);
>  }
>
> +u32 rds_ib_get_lkey(void *trans_private)
> +{
> +	struct rds_ib_mr *ibmr =3D trans_private;
> +
> +	return ibmr->u.mr->lkey;
> +}
> +
>  void *rds_ib_get_mr(struct scatterlist *sg, unsigned long nents,
>  		    struct rds_sock *rs, u32 *key_ret,
> -		    struct rds_connection *conn)
> +		    struct rds_connection *conn,
> +		    u64 start, u64 length, int need_odp)
>  {
>  	struct rds_ib_device *rds_ibdev;
>  	struct rds_ib_mr *ibmr =3D NULL;
> @@ -541,6 +568,42 @@ void *rds_ib_get_mr(struct scatterlist *sg, unsigned=
 long nents,
>  		goto out;
>  	}
>
> +	if (need_odp =3D=3D ODP_ZEROBASED || need_odp =3D=3D ODP_VIRTUAL) {
> +		u64 virt_addr =3D need_odp =3D=3D ODP_ZEROBASED ? 0 : start;
> +		int access_flags =3D
> +			(IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_READ |
> +			 IB_ACCESS_REMOTE_WRITE | IB_ACCESS_REMOTE_ATOMIC |
> +			 IB_ACCESS_ON_DEMAND);
> +		struct ib_mr *ib_mr;
> +
> +		if (!rds_ibdev->odp_capable) {
> +			ret =3D -EOPNOTSUPP;
> +			goto out;
> +		}
> +
> +		ib_mr =3D ib_reg_user_mr(rds_ibdev->pd, start, length, virt_addr,
> +				       access_flags);
> +
> +		if (IS_ERR(ib_mr)) {
> +			rdsdebug("rds_ib_get_user_mr returned %d\n",
> +				 IS_ERR(ib_mr));
> +			ret =3D PTR_ERR(ib_mr);
> +			goto out;
> +		}
> +		if (key_ret)
> +			*key_ret =3D ib_mr->rkey;
> +
> +		ibmr =3D kzalloc(sizeof(*ibmr), GFP_KERNEL);
> +		if (!ibmr) {
> +			ib_dereg_mr(ib_mr);
> +			ret =3D -ENOMEM;
> +			goto out;
> +		}
> +		ibmr->u.mr =3D ib_mr;
> +		ibmr->odp =3D 1;
> +		return ibmr;
> +	}
> +
>  	if (conn)
>  		ic =3D conn->c_transport_data;
>
> @@ -629,3 +692,12 @@ void rds_ib_mr_exit(void)
>  {
>  	destroy_workqueue(rds_ib_mr_wq);
>  }
> +
> +static void rds_ib_odp_mr_worker(struct work_struct  *work)
> +{
> +	struct rds_ib_mr *ibmr;
> +
> +	ibmr =3D container_of(work, struct rds_ib_mr, work.work);
> +	ib_dereg_mr(ibmr->u.mr);
> +	kfree(ibmr);
> +}
> diff --git a/net/rds/ib_send.c b/net/rds/ib_send.c
> index d1cc1d7778d8..dfe778220657 100644
> --- a/net/rds/ib_send.c
> +++ b/net/rds/ib_send.c
> @@ -39,6 +39,7 @@
>  #include "rds_single_path.h"
>  #include "rds.h"
>  #include "ib.h"
> +#include "ib_mr.h"
>
>  /*
>   * Convert IB-specific error message to RDS error message and call core
> @@ -635,6 +636,7 @@ int rds_ib_xmit(struct rds_connection *conn, struct r=
ds_message *rm,
>  		send->s_sge[0].addr =3D ic->i_send_hdrs_dma[pos];
>
>  		send->s_sge[0].length =3D sizeof(struct rds_header);
> +		send->s_sge[0].lkey =3D ic->i_pd->local_dma_lkey;
>
>  		memcpy(ic->i_send_hdrs[pos], &rm->m_inc.i_hdr,
>  		       sizeof(struct rds_header));
> @@ -650,6 +652,7 @@ int rds_ib_xmit(struct rds_connection *conn, struct r=
ds_message *rm,
>  			send->s_sge[1].addr =3D sg_dma_address(scat);
>  			send->s_sge[1].addr +=3D rm->data.op_dmaoff;
>  			send->s_sge[1].length =3D len;
> +			send->s_sge[1].lkey =3D ic->i_pd->local_dma_lkey;
>
>  			bytes_sent +=3D len;
>  			rm->data.op_dmaoff +=3D len;
> @@ -858,20 +861,29 @@ int rds_ib_xmit_rdma(struct rds_connection *conn, s=
truct rm_rdma_op *op)
>  	int ret;
>  	int num_sge;
>  	int nr_sig =3D 0;
> +	u64 odp_addr =3D op->op_odp_addr;
> +	u32 odp_lkey =3D 0;
>
>  	/* map the op the first time we see it */
> -	if (!op->op_mapped) {
> -		op->op_count =3D ib_dma_map_sg(ic->i_cm_id->device,
> -					     op->op_sg, op->op_nents, (op->op_write) ?
> -					     DMA_TO_DEVICE : DMA_FROM_DEVICE);
> -		rdsdebug("ic %p mapping op %p: %d\n", ic, op, op->op_count);
> -		if (op->op_count =3D=3D 0) {
> -			rds_ib_stats_inc(s_ib_tx_sg_mapping_failure);
> -			ret =3D -ENOMEM; /* XXX ? */
> -			goto out;
> +	if (!op->op_odp_mr) {
> +		if (!op->op_mapped) {
> +			op->op_count =3D
> +				ib_dma_map_sg(ic->i_cm_id->device, op->op_sg,
> +					      op->op_nents,
> +					      (op->op_write) ? DMA_TO_DEVICE :
> +							       DMA_FROM_DEVICE);
> +			rdsdebug("ic %p mapping op %p: %d\n", ic, op,
> +				 op->op_count);
> +			if (op->op_count =3D=3D 0) {
> +				rds_ib_stats_inc(s_ib_tx_sg_mapping_failure);
> +				ret =3D -ENOMEM; /* XXX ? */
> +				goto out;
> +			}
> +			op->op_mapped =3D 1;
>  		}
> -
> -		op->op_mapped =3D 1;
> +	} else {
> +		op->op_count =3D op->op_nents;
> +		odp_lkey =3D rds_ib_get_lkey(op->op_odp_mr->r_trans_private);
>  	}
>
>  	/*
> @@ -923,14 +935,20 @@ int rds_ib_xmit_rdma(struct rds_connection *conn, s=
truct rm_rdma_op *op)
>  		for (j =3D 0; j < send->s_rdma_wr.wr.num_sge &&
>  		     scat !=3D &op->op_sg[op->op_count]; j++) {
>  			len =3D sg_dma_len(scat);
> -			send->s_sge[j].addr =3D sg_dma_address(scat);
> +			if (!op->op_odp_mr) {
> +				send->s_sge[j].addr =3D sg_dma_address(scat);
> +				send->s_sge[j].lkey =3D ic->i_pd->local_dma_lkey;
> +			} else {
> +				send->s_sge[j].addr =3D odp_addr;
> +				send->s_sge[j].lkey =3D odp_lkey;
> +			}
>  			send->s_sge[j].length =3D len;
> -			send->s_sge[j].lkey =3D ic->i_pd->local_dma_lkey;
>
>  			sent +=3D len;
>  			rdsdebug("ic %p sent %d remote_addr %llu\n", ic, sent, remote_addr);
>
>  			remote_addr +=3D len;
> +			odp_addr +=3D len;
>  			scat++;
>  		}
>
> diff --git a/net/rds/rdma.c b/net/rds/rdma.c
> index eb23c38ce2b3..3c6afdda709b 100644
> --- a/net/rds/rdma.c
> +++ b/net/rds/rdma.c
> @@ -177,13 +177,14 @@ static int __rds_rdma_map(struct rds_sock *rs, stru=
ct rds_get_mr_args *args,
>  			  struct rds_conn_path *cp)
>  {
>  	struct rds_mr *mr =3D NULL, *found;
> +	struct scatterlist *sg =3D NULL;
>  	unsigned int nr_pages;
>  	struct page **pages =3D NULL;
> -	struct scatterlist *sg;
>  	void *trans_private;
>  	unsigned long flags;
>  	rds_rdma_cookie_t cookie;
> -	unsigned int nents;
> +	unsigned int nents =3D 0;
> +	int need_odp =3D 0;
>  	long i;
>  	int ret;
>
> @@ -196,6 +197,20 @@ static int __rds_rdma_map(struct rds_sock *rs, struc=
t rds_get_mr_args *args,
>  		ret =3D -EOPNOTSUPP;
>  		goto out;
>  	}
> +	/* If the combination of the addr and size requested for this memory
> +	 * region causes an integer overflow, return error.
> +	 */
> +	if (((args->vec.addr + args->vec.bytes) < args->vec.addr) ||
> +	    PAGE_ALIGN(args->vec.addr + args->vec.bytes) <
> +		    (args->vec.addr + args->vec.bytes)) {
> +		ret =3D -EINVAL;
> +		goto out;
> +	}
> +
> +	if (!can_do_mlock()) {
> +		ret =3D -EPERM;
> +		goto out;
> +	}
>
>  	nr_pages =3D rds_pages_in_vec(&args->vec);
>  	if (nr_pages =3D=3D 0) {
> @@ -250,36 +265,44 @@ static int __rds_rdma_map(struct rds_sock *rs, stru=
ct rds_get_mr_args *args,
>  	 * the zero page.
>  	 */
>  	ret =3D rds_pin_pages(args->vec.addr, nr_pages, pages, 1);
> -	if (ret < 0)
> +	if (ret =3D=3D -EOPNOTSUPP) {
> +		need_odp =3D 1;
> +	} else if (ret <=3D 0) {
>  		goto out;
> +	} else {
> +		nents =3D ret;
> +		sg =3D kcalloc(nents, sizeof(*sg), GFP_KERNEL);
> +		if (!sg) {
> +			ret =3D -ENOMEM;
> +			goto out;
> +		}
> +		WARN_ON(!nents);
> +		sg_init_table(sg, nents);
>
> -	nents =3D ret;
> -	sg =3D kcalloc(nents, sizeof(*sg), GFP_KERNEL);
> -	if (!sg) {
> -		ret =3D -ENOMEM;
> -		goto out;
> -	}
> -	WARN_ON(!nents);
> -	sg_init_table(sg, nents);
> -
> -	/* Stick all pages into the scatterlist */
> -	for (i =3D 0 ; i < nents; i++)
> -		sg_set_page(&sg[i], pages[i], PAGE_SIZE, 0);
> -
> -	rdsdebug("RDS: trans_private nents is %u\n", nents);
> +		/* Stick all pages into the scatterlist */
> +		for (i =3D 0 ; i < nents; i++)
> +			sg_set_page(&sg[i], pages[i], PAGE_SIZE, 0);
>
> +		rdsdebug("RDS: trans_private nents is %u\n", nents);
> +	}
>  	/* Obtain a transport specific MR. If this succeeds, the
>  	 * s/g list is now owned by the MR.
>  	 * Note that dma_map() implies that pending writes are
>  	 * flushed to RAM, so no dma_sync is needed here. */
> -	trans_private =3D rs->rs_transport->get_mr(sg, nents, rs,
> -						 &mr->r_key,
> -						 cp ? cp->cp_conn : NULL);
> +	trans_private =3D rs->rs_transport->get_mr(
> +		sg, nents, rs, &mr->r_key, cp ? cp->cp_conn : NULL,
> +		args->vec.addr, args->vec.bytes,
> +		need_odp ? ODP_ZEROBASED : ODP_NOT_NEEDED);
>
>  	if (IS_ERR(trans_private)) {
> -		for (i =3D 0 ; i < nents; i++)
> -			put_page(sg_page(&sg[i]));
> -		kfree(sg);
> +		/* In ODP case, we don't GUP pages, so don't need
> +		 * to release anything.
> +		 */
> +		if (!need_odp) {
> +			for (i =3D 0 ; i < nents; i++)
> +				put_page(sg_page(&sg[i]));
> +			kfree(sg);
> +		}
>  		ret =3D PTR_ERR(trans_private);
>  		goto out;
>  	}
> @@ -293,7 +316,11 @@ static int __rds_rdma_map(struct rds_sock *rs, struc=
t rds_get_mr_args *args,
>  	 * map page aligned regions. So we keep the offset, and build
>  	 * a 64bit cookie containing <R_Key, offset> and pass that
>  	 * around. */
> -	cookie =3D rds_rdma_make_cookie(mr->r_key, args->vec.addr & ~PAGE_MASK)=
;
> +	if (need_odp)
> +		cookie =3D rds_rdma_make_cookie(mr->r_key, 0);
> +	else
> +		cookie =3D rds_rdma_make_cookie(mr->r_key,
> +					      args->vec.addr & ~PAGE_MASK);
>  	if (cookie_ret)
>  		*cookie_ret =3D cookie;
>
> @@ -458,22 +485,26 @@ void rds_rdma_free_op(struct rm_rdma_op *ro)
>  {
>  	unsigned int i;
>
> -	for (i =3D 0; i < ro->op_nents; i++) {
> -		struct page *page =3D sg_page(&ro->op_sg[i]);
> -
> -		/* Mark page dirty if it was possibly modified, which
> -		 * is the case for a RDMA_READ which copies from remote
> -		 * to local memory */
> -		if (!ro->op_write) {
> -			WARN_ON(!page->mapping && irqs_disabled());
> -			set_page_dirty(page);
> +	if (ro->op_odp_mr) {
> +		rds_mr_put(ro->op_odp_mr);
> +	} else {
> +		for (i =3D 0; i < ro->op_nents; i++) {
> +			struct page *page =3D sg_page(&ro->op_sg[i]);
> +
> +			/* Mark page dirty if it was possibly modified, which
> +			 * is the case for a RDMA_READ which copies from remote
> +			 * to local memory
> +			 */
> +			if (!ro->op_write)
> +				set_page_dirty(page);
> +			put_page(page);
>  		}
> -		put_page(page);
>  	}
>
>  	kfree(ro->op_notifier);
>  	ro->op_notifier =3D NULL;
>  	ro->op_active =3D 0;
> +	ro->op_odp_mr =3D NULL;
>  }
>
>  void rds_atomic_free_op(struct rm_atomic_op *ao)
> @@ -583,6 +614,7 @@ int rds_cmsg_rdma_args(struct rds_sock *rs, struct rd=
s_message *rm,
>  	struct rds_iovec *iovs;
>  	unsigned int i, j;
>  	int ret =3D 0;
> +	bool odp_supported =3D true;
>
>  	if (cmsg->cmsg_len < CMSG_LEN(sizeof(struct rds_rdma_args))
>  	    || rm->rdma.op_active)
> @@ -604,6 +636,9 @@ int rds_cmsg_rdma_args(struct rds_sock *rs, struct rd=
s_message *rm,
>  		ret =3D -EINVAL;
>  		goto out_ret;
>  	}
> +	/* odp-mr is not supported for multiple requests within one message */
> +	if (args->nr_local !=3D 1)
> +		odp_supported =3D false;
>
>  	iovs =3D vec->iov;
>
> @@ -625,6 +660,8 @@ int rds_cmsg_rdma_args(struct rds_sock *rs, struct rd=
s_message *rm,
>  	op->op_silent =3D !!(args->flags & RDS_RDMA_SILENT);
>  	op->op_active =3D 1;
>  	op->op_recverr =3D rs->rs_recverr;
> +	op->op_odp_mr =3D NULL;
> +
>  	WARN_ON(!nr_pages);
>  	op->op_sg =3D rds_message_alloc_sgs(rm, nr_pages, &ret);
>  	if (!op->op_sg)
> @@ -674,10 +711,44 @@ int rds_cmsg_rdma_args(struct rds_sock *rs, struct =
rds_message *rm,
>  		 * If it's a READ operation, we need to pin the pages for writing.
>  		 */
>  		ret =3D rds_pin_pages(iov->addr, nr, pages, !op->op_write);
> -		if (ret < 0)
> +		if ((!odp_supported && ret <=3D 0) ||
> +		    (odp_supported && ret <=3D 0 && ret !=3D -EOPNOTSUPP))
>  			goto out_pages;
> -		else
> -			ret =3D 0;
> +
> +		if (ret =3D=3D -EOPNOTSUPP) {
> +			struct rds_mr *local_odp_mr;
> +
> +			if (!rs->rs_transport->get_mr) {
> +				ret =3D -EOPNOTSUPP;
> +				goto out_pages;
> +			}
> +			local_odp_mr =3D
> +				kzalloc(sizeof(*local_odp_mr), GFP_KERNEL);
> +			if (!local_odp_mr) {
> +				ret =3D -ENOMEM;
> +				goto out_pages;
> +			}
> +			RB_CLEAR_NODE(&local_odp_mr->r_rb_node);
> +			refcount_set(&local_odp_mr->r_refcount, 1);
> +			local_odp_mr->r_trans =3D rs->rs_transport;
> +			local_odp_mr->r_sock =3D rs;
> +			local_odp_mr->r_trans_private =3D
> +				rs->rs_transport->get_mr(
> +					NULL, 0, rs, &local_odp_mr->r_key, NULL,
> +					iov->addr, iov->bytes, ODP_VIRTUAL);
> +			if (IS_ERR(local_odp_mr->r_trans_private)) {
> +				ret =3D IS_ERR(local_odp_mr->r_trans_private);
> +				rdsdebug("get_mr ret %d %p\"", ret,
> +					 local_odp_mr->r_trans_private);
> +				kfree(local_odp_mr);
> +				ret =3D -EOPNOTSUPP;
> +				goto out_pages;
> +			}
> +			rdsdebug("Need odp; local_odp_mr %p trans_private %p\n",
> +				 local_odp_mr, local_odp_mr->r_trans_private);
> +			op->op_odp_mr =3D local_odp_mr;
> +			op->op_odp_addr =3D iov->addr;
> +		}
>
>  		rdsdebug("RDS: nr_bytes %u nr %u iov->bytes %llu iov->addr %llx\n",
>  			 nr_bytes, nr, iov->bytes, iov->addr);
> @@ -693,6 +764,7 @@ int rds_cmsg_rdma_args(struct rds_sock *rs, struct rd=
s_message *rm,
>  					min_t(unsigned int, iov->bytes, PAGE_SIZE - offset),
>  					offset);
>
> +			sg->dma_length =3D sg->length;

This line should be "sg_dma_len(sg) =3D sg->length;".

Thanks
