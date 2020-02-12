Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB29315A97B
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 13:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728247AbgBLMvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 07:51:21 -0500
Received: from mail-eopbgr140053.outbound.protection.outlook.com ([40.107.14.53]:8417
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725887AbgBLMvS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Feb 2020 07:51:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cVN3pEZLk7RuLRjABcQWSaZKc6WGzC/KfWM+H3MMD/T8x3pQTZFPadDk3Qg1iC8rkFQ679gvUVcKLTJe6LI12H3vm3r96Ecsch2vCqyeYjcWBVQOopLk67ERV50dHHKzr5ZyIlP0U73/YMj1+5dkW6m2fEtrlEC4NuJFNpOztxVMtN3GwaEK3nyU9gpHfsDzHosN4BnWcexkkJoN/m/l5mwO+C2ZfjS9gneC/XNjk3P5UZlTlP2NllKkmY72TBx5Z+U8maOMjWne96rTGKHuTq4v+73XdvQzm+w/i6FI6zU88UYeSLUTw2wLMCZus1bd+eXq0WtmtStIGCLhr337hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=raNv4B1CGya4jkTomUvQp5srpXT78rPNqVMaS88pbdk=;
 b=TeLrifVuPbF3jwXOmPU2lCqClQwRgjj3OmRLd4UVvExsMVwu/JzOWwv34QjZSAftvALnZbXRVcu1n/Csd139EhBieDACuqcAq0vTBTYjMkkoq/OHBf6WCX0V8UDq26WKbyV+btXayzdVN6PeNLj6iiovakQqO1Ky5Go5uX46xtE1ozCbGk6EaIL6R13IhlTw2H/vZBjfG7geDcvud0DHvNQMlZT5hFU6H6a8Bm27nGVNC3anGvsuZWZxVOz69FPRzR+X1MSeVDT5wbeBYrkywr9wnPm5s3RCgcvdDP9eMbwpi3nP/4Z02zaSPurrzG2yvUhNAC6ZgPI8wz52EzJMJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=raNv4B1CGya4jkTomUvQp5srpXT78rPNqVMaS88pbdk=;
 b=kIgp6Z9vbjYXi6lvzY/FeajA8XO4ButnTgC/U1fEN7QK0qaaj57nqpOaH3ziL+l0uX39wgeGmYryeydyt4Y/k1t9sTHarWke8kefklvbFrfG+G1Vk9QXaNQ2eFakt/458Yyiqq9krBCLma53zUOp0F6Cxz/yHv5Ua2D2f9oGBO0=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jgg@mellanox.com; 
Received: from DB7PR05MB4138.eurprd05.prod.outlook.com (52.135.129.16) by
 DB7PR05MB4956.eurprd05.prod.outlook.com (20.176.237.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.22; Wed, 12 Feb 2020 12:51:12 +0000
Received: from DB7PR05MB4138.eurprd05.prod.outlook.com
 ([fe80::3942:d5fb:e94f:503d]) by DB7PR05MB4138.eurprd05.prod.outlook.com
 ([fe80::3942:d5fb:e94f:503d%6]) with mapi id 15.20.2707.030; Wed, 12 Feb 2020
 12:51:12 +0000
Date:   Wed, 12 Feb 2020 08:51:08 -0400
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Jason Wang <jasowang@redhat.com>
Cc:     mst@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        tiwei.bie@intel.com, maxime.coquelin@redhat.com,
        cunming.liang@intel.com, zhihong.wang@intel.com,
        rob.miller@broadcom.com, xiao.w.wang@intel.com,
        haotian.wang@sifive.com, lingshan.zhu@intel.com,
        eperezma@redhat.com, lulu@redhat.com, parav@mellanox.com,
        kevin.tian@intel.com, stefanha@redhat.com, rdunlap@infradead.org,
        hch@infradead.org, aadam@redhat.com, jiri@mellanox.com,
        shahafs@mellanox.com, hanand@xilinx.com, mhabets@solarflare.com
Subject: Re: [PATCH V2 3/5] vDPA: introduce vDPA bus
Message-ID: <20200212125108.GS4271@mellanox.com>
References: <20200210035608.10002-1-jasowang@redhat.com>
 <20200210035608.10002-4-jasowang@redhat.com>
 <20200211134746.GI4271@mellanox.com>
 <cf7abcc9-f8ef-1fe2-248e-9b9028788ade@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf7abcc9-f8ef-1fe2-248e-9b9028788ade@redhat.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MN2PR18CA0004.namprd18.prod.outlook.com
 (2603:10b6:208:23c::9) To DB7PR05MB4138.eurprd05.prod.outlook.com
 (2603:10a6:5:23::16)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (142.68.57.212) by MN2PR18CA0004.namprd18.prod.outlook.com (2603:10b6:208:23c::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.23 via Frontend Transport; Wed, 12 Feb 2020 12:51:12 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1j1rTw-0000B9-CE; Wed, 12 Feb 2020 08:51:08 -0400
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ed96b891-59f9-4a94-0d5e-08d7afba3d1c
X-MS-TrafficTypeDiagnostic: DB7PR05MB4956:|DB7PR05MB4956:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DB7PR05MB4956AA17C07270CACC5C8FF8CF1B0@DB7PR05MB4956.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 0311124FA9
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(376002)(396003)(39860400002)(136003)(346002)(199004)(189003)(7416002)(86362001)(33656002)(2906002)(66946007)(4744005)(52116002)(1076003)(186003)(36756003)(2616005)(26005)(478600001)(5660300002)(316002)(66556008)(8676002)(9786002)(81156014)(6916009)(8936002)(66476007)(4326008)(9746002)(81166006)(24400500001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR05MB4956;H:DB7PR05MB4138.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1fsf6/9TirB9zdd8ibh8ca3PfvZQY3rF5xp9QwPOUtT+NePlUAxvmceW6mK2UgaFwyzu61OJIBKdpAB+TY/f922pgqm6kgyvRFsGt+ais8JL1kF1Jav3iazMPLuYawFa0xfmh5dLlALqCBN/UO6zTSuXDwsXS8NtFrjYXkB0G4WOuIBVNS0eKNalPbVsBpqQUr4g6pntxDbs1HrUNSOJW6JR6tx+DbOxLi5ogiEFarPlfX7SsdkP/JCRSEATuAFaPD4rEg32vO8grT3+vJXOGVEq0RklZbR/h5Wt2YXMNWioHlXbNGRKX+ssIB0KYaHbS8V0CiloQpRZGzMUIgwRLp3YuMk9gtDyI7Lk27+gOvRUJ2cponOeuqICTkpIAiivJ/R9t3nKqOpyHtrKUW8b4nxTMtlZY/4MiGJIo6LvPb894hpQMTCIMO2ofWkVkvOrzHc2PN+hVBBtxJC4XpUTYgnGYV91TqAGZoRtZX7LwmTl8DagvXzEZ3PxYKSNgAzN
X-MS-Exchange-AntiSpam-MessageData: HgdQ42Q+9akSUY+Gvqw/Sh0W+EjPBozu2I+v6CNDkYgZEkvUgssCsCAq4HN3aRAVlWDjkFDrOh9+YneoFiua9Qmt4Xi4Gj178z9BnZOjc8wIaOOatWX9bDO/OXrn9NcSeGCLhOIEE2ACkFR5J63HqA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed96b891-59f9-4a94-0d5e-08d7afba3d1c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2020 12:51:12.4008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x8D6xDbWq8wQq7TMiTAlPcoBxWXvCy/6rBbFG1RIYOuIVI5B4wyOz1D7048hLWS/pBRkvH1ZMM2duyS0ZpQaQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR05MB4956
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 12, 2020 at 03:55:31PM +0800, Jason Wang wrote:
> > The ida_simple_remove should probably be part of the class release
> > function to make everything work right
> 
> It looks to me bus instead of class is the correct abstraction here since
> the devices share a set of programming interface but not the semantics.

device_release() doesn't call the bus release? You have dev, type or
class to choose from. Type is rarely used and doesn't seem to be used
by vdpa, so class seems the right choice

Jason
