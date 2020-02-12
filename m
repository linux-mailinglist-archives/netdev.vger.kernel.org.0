Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 007E615AF16
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 18:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728815AbgBLRwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 12:52:07 -0500
Received: from mail-vi1eur05on2071.outbound.protection.outlook.com ([40.107.21.71]:6090
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727231AbgBLRwH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Feb 2020 12:52:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZoxUxXUGWBshBQgyqp0p2tcRSKXbrzt6/94fJ6Hb1BoWsthzd3kvjMsk54dZW82zIm/0c8l+UgHYQ+uGjApw5RiOHy06y4lCUKpACksGjMFfobFCwEaWpqtQos658usD5nDVqhWXecCbl4hQP8Qlhro17vL6ZpLeeqKNHjkjIbnR03m+sG01kGIYkfyyj/mGUfy2CHpOH+McPDkP1sj7WbzlprECz4iSy2sL9MDWngI4RGy+rFtbWpk7MigsTaQh6g2tMStix8SvatIVI+teoH/O50E/SMQIurmY0/3ASGex4EYwAW6cS6tt7NgMWlOyEMjblk3AE7s7NVzdcvmr7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lOpzw0JJTtcVurpkyE315SMZ90y7tPN20bRRWsfDmDY=;
 b=SXX69FcoNCBOnuEXtOsZL7mtUBBnfJDpYGgRSFMQ0qSWs/18YtivJ/LRp8HCs7qLEfKFbOw1z/6RQCSNBs2/Off1zC9GXOAAFxJldODxNH3pqnY+W8QGc0Kg8GwdJ39SAtXLVIhCjAPP4eO+s+6E0pVr/oioUo07Uc7C/sc3ux8qwFVwWfZDUFFiW2NPUjsoypGNTByp2fhQmeXVWTwS21xtMNVSzSr36LxgMohroKDZL3DQMzwUNe9qP+Jv6k1GXrnR181zBuQTfKVuVRIJSGIQ1wj08naapDJrjj/D3x9l0uJA2CnsQ+pE58FoSemvS+id8QF1TmJ1F1z9HYcHNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lOpzw0JJTtcVurpkyE315SMZ90y7tPN20bRRWsfDmDY=;
 b=YHaxc43YySgnvdrIUFUyqgPw6y74nhQIzOibViTbglMB+qWYVLRf3uzz1MTOmlRY25DNCamUX3+6fAPCwzEsfV1L6j9mDaScUOTDwYvgjqVx+wW8ymVC++hfKWhgn6ewYTNNpl5kRsHXNR4NIESJg8vf6xth9CWj9Vn/WBHFeoM=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=leonro@mellanox.com; 
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com (20.179.5.215) by
 AM6PR05MB5459.eurprd05.prod.outlook.com (20.177.188.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.21; Wed, 12 Feb 2020 17:52:03 +0000
Received: from AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::c99f:9130:561f:dea0]) by AM6PR05MB6408.eurprd05.prod.outlook.com
 ([fe80::c99f:9130:561f:dea0%3]) with mapi id 15.20.2729.021; Wed, 12 Feb 2020
 17:52:03 +0000
Date:   Wed, 12 Feb 2020 19:51:59 +0200
From:   Leon Romanovsky <leonro@mellanox.com>
To:     santosh.shilimkar@oracle.com
Cc:     John Hubbard <jhubbard@nvidia.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hans Westgaard Ry <hans.westgaard.ry@oracle.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-rdma@vger.kernel.org,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] net/rds: Track user mapped pages through special API
Message-ID: <20200212175159.GD679970@unreal>
References: <20200212030355.1600749-1-jhubbard@nvidia.com>
 <20200212030355.1600749-2-jhubbard@nvidia.com>
 <c0d8d04e-08d1-60ff-ea4c-e6c71f3e118a@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c0d8d04e-08d1-60ff-ea4c-e6c71f3e118a@oracle.com>
X-ClientProxiedBy: AM0PR06CA0058.eurprd06.prod.outlook.com
 (2603:10a6:208:aa::35) To AM6PR05MB6408.eurprd05.prod.outlook.com
 (2603:10a6:20b:b8::23)
MIME-Version: 1.0
Received: from localhost (2a00:a040:183:2d::2a5) by AM0PR06CA0058.eurprd06.prod.outlook.com (2603:10a6:208:aa::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2729.23 via Frontend Transport; Wed, 12 Feb 2020 17:52:02 +0000
X-Originating-IP: [2a00:a040:183:2d::2a5]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7c3ffc77-241c-45b9-b379-08d7afe44430
X-MS-TrafficTypeDiagnostic: AM6PR05MB5459:
X-Microsoft-Antispam-PRVS: <AM6PR05MB54595FDBF66A31CBFF483365B01B0@AM6PR05MB5459.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0311124FA9
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(7916004)(396003)(376002)(346002)(39860400002)(366004)(136003)(199004)(189003)(966005)(16526019)(6916009)(8936002)(81166006)(2906002)(81156014)(6486002)(8676002)(52116002)(186003)(53546011)(9686003)(4326008)(66476007)(66556008)(478600001)(33656002)(33716001)(54906003)(316002)(66946007)(7416002)(86362001)(1076003)(6666004)(5660300002)(6496006);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5459;H:AM6PR05MB6408.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kRypZls59DKPPzfEXkd/wLrInf+w9wUQ6tmBY+lW4VBwRZFcL+HNSTy7gxye3KIeWDLKdSbvspdASM5gvaf28IEGyg9TGKnOHO8Ql+UubZRsvnu0CbawL49lcUOnVpxWKB/KQx6rzB9O1pt5ubnJiIceksV3T4gndH9xbtNIrkcjOMsMezJWi/ZeU5+HrVUqEgvauS96a7s43NoSI7Pg3G9C0WlsdtZwmGr2hR0SXyj5wpffPKaiHBv2uCV176MJt+KvoccuL+Eo2zT6jF8oovwlue/a3QslwcaABCW+XiJ4vXxM2mYm1TDM5kL5KODj6JBzi5d+s9QCwWTupTYt4oSDowVkuasbDMvaN8wtiSErs5UXZldspH+2FIPI5FjMBglCr/KGvPp09h+9hk5rYWbpgWtDaeQqqshuO3z+W+eavDD+3by/KjSG8LBocSPgjN6tOIHseT2TJCiUM5w5KaLp/xux/ywXRnWcf0oNNz0MmZuje3gl8OZC84wyL+M7g2mem2c/BLSSkkx9H/EXAg==
X-MS-Exchange-AntiSpam-MessageData: z+VV5rgtpNwRGhZYkFqfu7+dNNmdcVG19YHzhjjrIqbcMrf9EO2oOlK65UMFGhf28FchSe9lgku8X2RkmE4cGxtbm+mAL9srHbZHEkK0akzAoFYjrQwY9hrpvRNNpXBkuP2mUw6Qw1WfAuj8ENjS9+mNHpnA9urDITNXvWTY5V4=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c3ffc77-241c-45b9-b379-08d7afe44430
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Feb 2020 17:52:02.9790
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: L0PjSxxiQSR1wodXQO3OvbOn+/d28d+tC6rbaNKc2y6z/qhDrvKD9xinnEL7s/8RNxT5sWd3K+DvRQgci5SeAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5459
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 12, 2020 at 09:31:51AM -0800, santosh.shilimkar@oracle.com wrote:
> On 2/11/20 7:03 PM, John Hubbard wrote:
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Convert net/rds to use the newly introduces pin_user_pages() API,
> > which properly sets FOLL_PIN. Setting FOLL_PIN is now required for
> > code that requires tracking of pinned pages.
> >
> > Note that this effectively changes the code's behavior: it now
> > ultimately calls set_page_dirty_lock(), instead of set_page_dirty().
> > This is probably more accurate.
> >
> > As Christoph Hellwig put it, "set_page_dirty() is only safe if we are
> > dealing with a file backed page where we have reference on the inode it
> > hangs off." [1]
> >
> > [1] https://urldefense.com/v3/__https://lore.kernel.org/r/20190723153640.GB720@lst.de__;!!GqivPVa7Brio!OJHuecs9Iup5ig3kQBi_423uMMuskWhBQAdOICrY3UQ_ZfEaxt9ySY7E8y32Q7pk5tByyA$
> >
> > Cc: Hans Westgaard Ry <hans.westgaard.ry@oracle.com>
> > Cc: Santosh Shilimkar <santosh.shilimkar@oracle.com>
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > Signed-off-by: John Hubbard <jhubbard@nvidia.com>
> > ---
> Change looks fine to me. Just on safer side, we will try
> to test this change with regression suite to make sure it
> works as expected.

Thanks Santosh,
I wrote this patch before John's series was merged into the tree,
but back then, Hans tested it and it worked, hope that it still works. :)

>
> For patch itself,
>
> Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
>
