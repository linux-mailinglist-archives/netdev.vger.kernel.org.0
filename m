Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9F551E20F0
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 13:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731422AbgEZLer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 07:34:47 -0400
Received: from mail-eopbgr40072.outbound.protection.outlook.com ([40.107.4.72]:50550
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726325AbgEZLer (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 07:34:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hg7OHtzJ94PNxkxfxbXS4xHGjDNSPJLywghrAp4rAUEUvDh5O7awGZ2WuXm8EkAsUXzSSChMl9VUMOtePC+a/pXoCHAlbG/HWQWSdle2SHGe3yK2BfZBrNV0wwRccOXlqTS5DC0TYD/6f66oPY5m4AMCKpi7aJ5ESR+Vxx05KmUNNKOsH3rkJ1qCIqmeoLXPznTSrPSwDFuBgK9G0O/C8KRoEWSQtYWFmyg19FAERZJpdD5VTK/O59v3UEcOzMYjMHaK3tz2p1Osgm39dOTamouhv+VW9IPHzqSZutXmyD8SRg5U7g2LO/k0oUfc0J2MzLAhPPH8GN9pv4cn+fW5ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I5TrDQmFninneD/5s9zTgEpe3nZ5R0K0SDrq68I1PdE=;
 b=b8CfG6cyWnYBkyKr3FGe+J04g2QmR1gy2NBf6JgYoQfSEBvOY6lI0vPhZWDqxyiFwHrIviISAb72WOpQBOGghclWlynLygR6Cxm2/h0IklKA9ZOUCzjili9ckJqtrlno/dpnaPSXtv93dpzGshXFYmLfu49xOI8my18QV4YySA4uTXlTn+n7Z9FM6PE93PYDdmlBmtUcMI5RY/BgUeIerb5TqTI1wkpq2pNKOHT17LbBN6PJFng1RCKvV0Of80PK4ZjRejCOvzH6Gnc6oz7m6f9PHD5ZW6nwJarvYy73zJ817/4odDaKJu3wAPlI57gj74wJ026V4/4yqVzAWvdyNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I5TrDQmFninneD/5s9zTgEpe3nZ5R0K0SDrq68I1PdE=;
 b=PRCuYmnE5WZBRW1ddv620g07xCsI9enz1wjEHrNSi4Zm16tyzfuoXMzCQvjw4Lga5u05+hw2YXdC36moOuVJ4RG26qs+qQXybIt3lhh5jxHoaEI/4jOZEhNz4r1gSDZlw6snLAiD0ytFzwewqmTOZma7swCQ9lY9W7Br0giUaBQ=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=mellanox.com;
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com (2603:10a6:20b:b8::23)
 by AM6PR05MB4984.eurprd05.prod.outlook.com (2603:10a6:20b:4::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Tue, 26 May
 2020 11:34:42 +0000
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::1466:c39b:c016:3301]) by AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::1466:c39b:c016:3301%4]) with mapi id 15.20.3021.029; Tue, 26 May 2020
 11:34:41 +0000
Date:   Tue, 26 May 2020 14:36:28 +0300
From:   Leon Romanovsky <leonro@mellanox.com>
To:     Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Danil Kipnis <danil.kipnis@cloud.ionos.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, rds-devel@oss.oracle.com,
        Sagi Grimberg <sagi@grimberg.me>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        target-devel@vger.kernel.org
Subject: Re: [PATCH rdma-next v3 6/6] RDMA/cma: Provide ECE reject reason
Message-ID: <20200526113628.GC100179@unreal>
References: <20200526103304.196371-1-leon@kernel.org>
 <20200526103304.196371-7-leon@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200526103304.196371-7-leon@kernel.org>
X-ClientProxiedBy: AM0PR02CA0010.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::23) To AM6PR05MB6408.eurprd05.prod.outlook.com
 (2603:10a6:20b:b8::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2a00:a040:183:2d::a43) by AM0PR02CA0010.eurprd02.prod.outlook.com (2603:10a6:208:3e::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27 via Frontend Transport; Tue, 26 May 2020 11:34:41 +0000
X-Originating-IP: [2a00:a040:183:2d::a43]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 215cd39b-a6c9-482f-d29a-08d80168c803
X-MS-TrafficTypeDiagnostic: AM6PR05MB4984:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM6PR05MB49842207410BAB993BC722C8B0B00@AM6PR05MB4984.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1247;
X-Forefront-PRVS: 041517DFAB
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0K5I3zBIGTHL+8rCzAvDlRh9wz18l9yRjspFzVPMd9jO7ASPn5VAjyWdw6rg/eXKHC/yKwsBayg2EiFek9Tp+awO6BdYr5QIJ9YoxbdkPikoj3cOApg3IMfyH5olFVYu+QpvAb4/XoYUHgdNYMitjB5hr9+wLjQHjmdiQePUG87sdh6gcbXTSc5DIaHGiSKZMSe5e8npSTAqa6cIgZYxu0yttw2Bqaaw7iJq+Lcvmp7dvoJCE7/yUP0ll13xPGLJQJweECHoFEkFGka2O5HRHlhHi/cgJZkoy6tCj2rN5YletPA7K/+cTm5kAnsPeLLh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR05MB6408.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(7916004)(366004)(136003)(39860400002)(396003)(376002)(346002)(4326008)(6496006)(8676002)(9686003)(16526019)(186003)(6486002)(33656002)(52116002)(8936002)(1076003)(33716001)(6666004)(478600001)(110136005)(316002)(66946007)(2906002)(86362001)(66476007)(54906003)(66556008)(7416002)(5660300002)(6636002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: GcV+0B5o+BRIR5LF+ZmyfObcaug4qX5iSlYkDIdzRiTrrYsgCZIlFsnObH/uKJUuW4tYj3Rk8Bg+3N2RcPnIg49Y+ENne95uJzjodEgvA2a7vfJlChbjz1WVJ00VT1ZeLid/ESbbTAWIvUqbmUfUQI/as/aQIQ6DKpxSSgw5v+PwDaDKLBzDwUAJHiirESJlNsiIaLUlXkzbQXyfsg7C5EsY5OkxTSGfROvYQzFPJYkCTj0qwa2nfP4y6LFLL4StSDTLKOsUOp45N5pT88XGqYnAnDyNqIRz1oDpoxNREgTD8R/dJuS9c9LvYqG2b3POH3rl/8wWhBIn2RY1hgjdn7WnbE8TQT58J4UK7M5srGNUXHX0YKgdoIsB2lfO2bHDSWLRHQUzvlzvX6prUMCrZWkjT3KglEnzyvpBh4qaDHJx4CH1acPDW+8lLYs+B92yx6x8s935iQghnpUIzRbsfu1OMZAyIXZM7RVJczLtPsJVdov+iKf3sEkwAK/1oxRpFY4MhtoyVbxQthQfpSS6Rg==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 215cd39b-a6c9-482f-d29a-08d80168c803
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2020 11:34:41.9024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h2/K7CFHfV0q+nDYKHQaEiMNOYatK/iXMdNZutpwHw5+ux2XVtZQzUz3hmto3izbSqMbeqbJY578Yr7X+wx0EA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4984
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 26, 2020 at 01:33:04PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
>
> IBTA declares "vendor option not supported" reject reason in REJ
> messages if passive side doesn't want to accept proposed ECE options.
>
> Due to the fact that ECE is managed by userspace, there is a need to let
> users to provide such rejected reason.
>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  drivers/infiniband/core/cma.c           |  9 ++++-----
>  drivers/infiniband/core/ucma.c          | 15 ++++++++++++++-
>  drivers/infiniband/ulp/isert/ib_isert.c |  4 ++--
>  drivers/infiniband/ulp/rtrs/rtrs-srv.c  |  2 +-
>  drivers/infiniband/ulp/srpt/ib_srpt.c   |  3 ++-
>  drivers/nvme/target/rdma.c              |  3 ++-
>  include/rdma/rdma_cm.h                  |  2 +-
>  include/uapi/rdma/rdma_user_cm.h        |  3 ++-
>  net/rds/ib_cm.c                         |  4 +++-
>  9 files changed, 31 insertions(+), 14 deletions(-)

For some reason didn't get the failure in CI, this small fixup is
needed.

commit af02a4a50ec0d18fe9bfb86b96411dfb42054f97 (HEAD -> rdma-next)
Author: Leon Romanovsky <leon@kernel.org>
Date:   Tue May 26 14:34:34 2020 +0300

    fixup! RDMA/cma: Provide ECE reject reason

    Signed-off-by: Leon Romanovsky <leonro@mellanox.com>

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 30a0a9adaddd..d84765f66d49 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -18,6 +18,7 @@
 #include <asm/unaligned.h>

 #include <rdma/ib_verbs.h>
+#include <rdma/ib_cm.h>
 #include <rdma/rdma_cm.h>
 #include <rdma/rw.h>

