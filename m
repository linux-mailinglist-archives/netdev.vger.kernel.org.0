Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4521B4CBE
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 20:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgDVSge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 14:36:34 -0400
Received: from mail-eopbgr70089.outbound.protection.outlook.com ([40.107.7.89]:39366
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725648AbgDVSgd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 14:36:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jpo2mC9s3RCk1oSch/HZPjKZBVW+Aavp2urOGDhxvet7mQgh2bHUPWhEBug5EfjjgiQQ8wq5G9P5aYYcu6yb6fP/fc50KEydeTtR/ENyAOwMswG0AbseDXxESTt/bjxDXwUrfPhpwc84F4BtgmOGFkV2AgjQpn1qZh2DXEWrVt4uIns7mUv69an3EZaBXMdZau+4NwkRabyNMV3BkM49xRnWLreoTgjgYYcOXLQXRqSXIct8YOJ/avdTA2pP2T1uFnr6mygMMVqKclJQtzwXFAKzYWmSRRzTPAarMuLI+a8rsi7qQmj6+i9Azu33VHlf2JWVs+j7sH3fAMdBU/uQ3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/nLMf27VVWml/njgvwzJHq6YdIcZVfvkUEZhF2mVwz8=;
 b=FRzMbwnYx+r0JWIyO5mWsC+7xi9dLdVbQUezUK7p7be3mFzAXBFEmiHDxNAcmFPFs230MJ8vaVUW6YKwfHOqsNGRw32GMgDab1TCoN2DEp9cgu0arotj+/XqxrGUO/TegkIPgg6uOJlxQjQlWwHI7mrrP/MU9CKyeJjyScX8Q/esuqxN561KLQvHjRaauuFXqBZAufYkW4WfGhISCqaAW0hNc5RyN58mBqY7v1jr+bydU5CKMkg9xauhym/mlJhosVLSxeqDuBZzg4YiFRxYx45IzBnAVcbLlqdmyIoU6Nhu1XPZr3QC+sv0Jxjj6lUAI8gCee/xM34imftMFHFR5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/nLMf27VVWml/njgvwzJHq6YdIcZVfvkUEZhF2mVwz8=;
 b=VtZfdZYwnyBpZPWHPYBgOeUgN7cLr5cNqjsSqALyIGgkAhiGiTtqmVa6LGUKgwzzL5REUtwI2NElCzU9mB+9l6B9O6WRbYHdDrMmWgURxo0FGGeDhL67n50egfeaDp8JgSrBnb+MBQOsHx3VIH39G/thiHf7eIZQo1OHzkqqM8o=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com (2603:10a6:20b:b8::23)
 by AM6PR05MB5524.eurprd05.prod.outlook.com (2603:10a6:20b:32::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2921.29; Wed, 22 Apr
 2020 18:36:29 +0000
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::1466:c39b:c016:3301]) by AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::1466:c39b:c016:3301%4]) with mapi id 15.20.2921.030; Wed, 22 Apr 2020
 18:36:29 +0000
Date:   Wed, 22 Apr 2020 21:36:27 +0300
From:   Leon Romanovsky <leonro@mellanox.com>
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH mlx5-next 02/24] net/mlx5: Update cq.c to new cmd
 interface
Message-ID: <20200422183627.GC492196@unreal>
References: <20200420114136.264924-1-leon@kernel.org>
 <20200420114136.264924-3-leon@kernel.org>
 <20200422164948.GB492196@unreal>
 <20200422183214.GW26002@ziepe.ca>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200422183214.GW26002@ziepe.ca>
X-ClientProxiedBy: PR0P264CA0238.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1e::34) To AM6PR05MB6408.eurprd05.prod.outlook.com
 (2603:10a6:20b:b8::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2a00:a040:183:2d::a43) by PR0P264CA0238.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1e::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Wed, 22 Apr 2020 18:36:28 +0000
X-Originating-IP: [2a00:a040:183:2d::a43]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: e7c2a326-c7a0-4c7e-3263-08d7e6ec1262
X-MS-TrafficTypeDiagnostic: AM6PR05MB5524:|AM6PR05MB5524:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB5524E93AEDA94629EDDDB3AEB0D20@AM6PR05MB5524.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 03818C953D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB6408.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(7916004)(39860400002)(366004)(396003)(346002)(376002)(136003)(4326008)(478600001)(107886003)(8676002)(81156014)(5660300002)(8936002)(1076003)(316002)(16526019)(6916009)(186003)(2906002)(66946007)(52116002)(6486002)(33716001)(66476007)(66556008)(6496006)(9686003)(54906003)(86362001)(33656002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: s1BYQwOgm542BQNKMox5m5Blg9ma6vrML5t8WUTfJBOgGpluSHGFL5lOt1N3ExkIP8AkVk/lPthL+Oh89b9+Vj8dQnqpBVJ9lDEyztVRv3z5e9nxD97f6/g3/8kunj1DRyKpacw7lar0wlxZqwWw69BHnC+Za7LXSLqog4tpXenSleL8/1ibI2T6FyNPIp1QL1Z11ZRtuN0zBAIynt8Oxt7t9zWb6ds0Oj4VzvA/IgPFz2HA9vnF1Mwjn1zUsBt9b6HPISlDn7OnV85C7UzLCCmTvuHjA5lC9a+7eTKN3Oa+rYU07+Vtv+UrjWdVCKC2qsZ+W8Q7yDmbQCl93PpyvkM5k1dy+1NxtstcYGBpSNYCBzWgFk0HrUuQEfuhfHS6eIvizGmDqeQq6F+XgmHfahkHnfv1bvnqlsBpXh+c7SC3PwSVBHs2BMOONcGXUFqU
X-MS-Exchange-AntiSpam-MessageData: S/qS9PwfPvzsvXsNeOWBiPtEBS+po+sJPKaBPzmufDDpZGr0P7sGXEpmUfsGQuJUhNx6rGqRMx3Se8n301Jna0731yS7SCct0E+7lNWqkykVaBBX/ADSMcM5Xds+xOCDL8JyeE52RMC6CGVLCLznyuf+OPfQBS5skDs6PXjcZkI=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e7c2a326-c7a0-4c7e-3263-08d7e6ec1262
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2020 18:36:29.2599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4D7N3htDNFmb2Zy2RR/XpcOZb5aXFG07pxLxagUmOip+RZ3s10XJK3rScaBGu5kUQa+/xlKZfvS7cMFezMwXDQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5524
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 03:32:14PM -0300, Jason Gunthorpe wrote:
> On Wed, Apr 22, 2020 at 07:49:48PM +0300, Leon Romanovsky wrote:
> > >  int mlx5_core_modify_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq,
> > >  			u32 *in, int inlen)
> > >  {
> > > -	u32 out[MLX5_ST_SZ_DW(modify_cq_out)] = {0};
> > > -
> > >  	MLX5_SET(modify_cq_in, in, opcode, MLX5_CMD_OP_MODIFY_CQ);
> > >  	MLX5_SET(modify_cq_in, in, uid, cq->uid);
> > > -	return mlx5_cmd_exec(dev, in, inlen, out, sizeof(out));
> > > +	return mlx5_cmd_exec_in(dev, modify_cq, in);
> > >  }
> > >  EXPORT_SYMBOL(mlx5_core_modify_cq);
> > >
> >
> > This hunk needs this fixup:
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cq.c b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
> > index 1a6f1f14da97..8379b24cb838 100644
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/cq.c
> > @@ -187,9 +187,11 @@ EXPORT_SYMBOL(mlx5_core_query_cq);
> >  int mlx5_core_modify_cq(struct mlx5_core_dev *dev, struct mlx5_core_cq *cq,
> >                         u32 *in, int inlen)
> >  {
> > +       u32 out[MLX5_ST_SZ_DW(modify_cq_out)] = {};
> > +
> >         MLX5_SET(modify_cq_in, in, opcode, MLX5_CMD_OP_MODIFY_CQ);
> >         MLX5_SET(modify_cq_in, in, uid, cq->uid);
> > -       return mlx5_cmd_exec_in(dev, modify_cq, in);
> > +       return mlx5_cmd_exec(dev, in, inlen, out, sizeof(out));
> >  }
> >  EXPORT_SYMBOL(mlx5_core_modify_cq);
>
> Why doesn't this one work with the helper?

In the mlx5_ib_resize_cq() function inlen is equal to

1290         inlen = MLX5_ST_SZ_BYTES(modify_cq_in) +
1291                 MLX5_FLD_SZ_BYTES(modify_cq_in, pas[0]) * npas;

and not to MLX5_ST_SZ_BYTES(modify_cq_in) like helper assumes.

Thanks

>
> Jason
