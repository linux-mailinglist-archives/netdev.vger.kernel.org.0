Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 061031DCF45
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 16:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729524AbgEUOM6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 10:12:58 -0400
Received: from mail-eopbgr80047.outbound.protection.outlook.com ([40.107.8.47]:31494
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728630AbgEUOM5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 10:12:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XaN02AoeL+P9NwHbrpRweaCZR0QBbBoHLSf+/3EwTLj4pUlhYQmydZWy+0oEMdVNLDWKDGHbSLjeZAW0FH64OVdlqvCeFg9MJhgpik1UUB/TcJE1AhddWDAvLTlej3iGXUJDtunS+Cxd+vP9RfIVWKZheeiL/mXqs1r3v6sLvuqm1AD1Q/ML27eSV+4awNE1K2Hzo/kxE8iYHHFwZgiMOzQ3iWW1Kgm/kPlKg6PTn/vnvGzQ+99tyT9ch9E2Eb7mQ6sHPJkqU13JtWDXfpvzmL5a7opDgCt1wuMUFKFKFWZuao8BKt1hEnKf/rSD+514HkmqTqYwJ//Jq0b8E/QkAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/0l3I1+bZ0chwWve0hATjdi/mBb1m7phoWVsZvifpw0=;
 b=M+WrspyG6Nq9kL6CVwU12eC+uFyLglKczJRUOII/xxHyltXAQnhgoGzeUHgxLU9EWC+gC59TigUDoh2a7YqOlsOof/2FyWWRc1gynLvnXZC/0YhH1XbufmO0nP4N83f1qkoi2FjH/4wNFmSRN352eGvwUglQBo90BLA/BSjXHUTTiHUG+vdz0xxcMDmQT37+apV1PTD62CopXpUktQWuE8YqSTRM/LasaSAVj452JsH4/sF+7oxxsWecE7krengRqg/GDUzZ7xgFbwwYGdslEs7n37wh6BPZWEkACwQdGMVdA6mOetSPPuFyTHpEKssyIbMQpS1WJpWCFXIqp7qlzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/0l3I1+bZ0chwWve0hATjdi/mBb1m7phoWVsZvifpw0=;
 b=diKF4aZ7KWYQhE4+YDLoOJIHDUxr1aT7gCVKbFhu7mkX/MXXgUMiwHlYwmtV25K5BtSoHkQ/ovmGm+TupYEq0sUBsk/Dnx6OxkbnHNaEqcwG/C1evfZPUGYJZ5xXRO8o3M8JcvqGq/EzX/16MwrZk5wQg8dEm2vpRwa4RYAB3Go=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR05MB7037.eurprd05.prod.outlook.com (2603:10a6:800:187::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23; Thu, 21 May
 2020 14:12:54 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::848b:fcd0:efe3:189e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::848b:fcd0:efe3:189e%7]) with mapi id 15.20.3000.034; Thu, 21 May 2020
 14:12:54 +0000
Date:   Thu, 21 May 2020 11:12:47 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc:     dledford@redhat.com, davem@davemloft.net,
        gregkh@linuxfoundation.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        poswald@suse.com
Subject: Re: [RDMA RFC v6 00/16] Intel RDMA Driver Updates 2020-05-19
Message-ID: <20200521141247.GQ24561@mellanox.com>
References: <20200520070415.3392210-1-jeffrey.t.kirsher@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200520070415.3392210-1-jeffrey.t.kirsher@intel.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MN2PR15CA0018.namprd15.prod.outlook.com
 (2603:10b6:208:1b4::31) To VI1PR05MB4141.eurprd05.prod.outlook.com
 (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (193.47.165.251) by MN2PR15CA0018.namprd15.prod.outlook.com (2603:10b6:208:1b4::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.23 via Frontend Transport; Thu, 21 May 2020 14:12:54 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1jblwF-0006ht-DH; Thu, 21 May 2020 11:12:47 -0300
X-Originating-IP: [193.47.165.251]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0938db4f-2797-4f80-3a7e-08d7fd910e18
X-MS-TrafficTypeDiagnostic: VI1PR05MB7037:
X-Microsoft-Antispam-PRVS: <VI1PR05MB70372823888630E55172C7B9CFB70@VI1PR05MB7037.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-Forefront-PRVS: 041032FF37
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rZxdtJFwKl1IZ8XNP8ln585DdZKZCEiuzyK2P8tTOld4kWgIEEWXp3X6ZbE76/C2aGa7q/XBqeVNCQih5o9JAID6JimsGJF3iI9Xg1yhqHnSGyCMMtTs8rkg9sAfWyPcdXIc8mEpXo9PmcoqGpCxP3o+VlxN9F4wCfF+00gAsOUz5jcOjfXdoKIxLPZpOKNyFoCAvR5+W9DvIs5laI5VppiComkKG/kBQBp+uXCUNjgGT9GPwmbdxHj90AdEWJ7/l6FjjLG+k+AJc9J0ICt6Rih+MO/+08yO5hBSAJJb8iMyJvuq/yGshjbAH078ZGbLKU+YxKEu7CH/mAzUozIBFVVndFMu9FHfFwTi8j11HYgW9Pz1Ve50H/h1W4zGMynD
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(346002)(39860400002)(376002)(366004)(26005)(8936002)(86362001)(5660300002)(2616005)(478600001)(1076003)(8676002)(15650500001)(9786002)(66556008)(66476007)(33656002)(9746002)(316002)(36756003)(66946007)(6916009)(4326008)(186003)(2906002)(52116002)(24400500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: zxfQ+F4pCqhkjOxv1ej8WEAnWofI1UbKDhtzj+GSLi6p57d6WCMXSxsKgdTHXjhtW3wy4J8sN5rWyEYe+8EzlTWE8ddoXFweToeVTI4ygxGra93bKrvm723BcFpxqf3fvZv/g2NquyOL3LiBetvyHATmeeEwLLBo0ENz9KWn/Aym2oeh2q7gqellEMISS40HQ5VhXLeRvkmEbPukDGzwc0PswnMoxdoljAfm21hZaiCVrUTHNLp2ZaqLcEzIpvihzGrGSmix9OfurKSOSvjvWkPfVCiBEssM2IlQeSqjdkGce5StcBQUxLhOqc2RBIogDvhQ0BCFdM2d2G1ftP+NB1HkfTPbBJMjRRADTdcOblb2e683qclOynnOJ4EhQGLY3aDZZbRn4cvBD7lRFJwh2BawHFZhfDiCg6O+oWhikj7ZNwFcLsk01Q9BN/EcEFwY17yYg9wk4KrwwFEogDkvW+3RZclA4UvxjTZemnEWqp2YCHPl1Z6ou1Tazh43nJSp
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0938db4f-2797-4f80-3a7e-08d7fd910e18
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2020 14:12:54.6207
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aE65ZzYBuToUT9AQnwmXpLM6UbN0mFkyTjM+5LzhrF0XatgBKRZm6eJOH06bDvYqATslQUhWlQqon1zrQwWbJw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB7037
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 20, 2020 at 12:03:59AM -0700, Jeff Kirsher wrote:
> This patch set adds a unified Intel Ethernet Protocol Driver for RDMA that
> supports a new network device E810 (iWARP and RoCEv2 capable) and the
> existing X722 iWARP device. The driver architecture provides the extensibility
> for future generations of Intel HW supporting RDMA.
> 
> This driver replaces the legacy X722 driver i40iw and extends the ABI already
> defined for i40iw. It is backward compatible with legacy X722 rdma-core
> provider (libi40iw).
> 
> This series was built against the rdma for-next branch.  This series is
> dependant upon the v4 100GbE Intel Wired LAN Driver Updates 2020-05-19
> 12 patch series, which adds virtual_bus interface and ice/i40e LAN
> driver changes.
> 
> v5-->v6:
> *Convert irdma destroy QP to a synchronous API 
> *Drop HMC obj macros for use counts like IRDMA_INC_SD_REFCNT et al.
> *cleanup unneccesary 'mem' variable in irdma_create_qp 
> *cleanup unused headers such as linux/moduleparam.h et. al 
> *set kernel_ver in irdma_ualloc_resp struct to current ABI ver. Placeholder to
>  support user-space compatbility checks in future 
> *GENMASK/FIELD_PREP scheme to set WQE descriptor fields considered for irdma
>  driver but decision to drop. The FIELD_PREP macro cannot be used on the device
>  bitfield mask array maintained for common WQE descriptors and initialized
>  based on HW generation. The macro expects compile time constants
> only.

The request was to use GENMASK for the #define constants. If you move
to a code environment then the spot the constant appears in the C code
should be FIELD_PREP'd into the something dynamic code can use.

Jason
