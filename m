Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD97135D08D
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 20:45:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245116AbhDLSp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 14:45:56 -0400
Received: from mail-bn8nam11on2066.outbound.protection.outlook.com ([40.107.236.66]:7735
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S239578AbhDLSpy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 14:45:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tg4NhbQj9pVl+3JZ5jHbRkdd6LgObhLKFGYqx2gE19WnfCzi29DQUU6yE1FnsZBYbdYZ0I+/R5NXvIfRKohzw2Zl/t23/FnUZm28lrGB4aPjQBr8/+u3gcflquiHFEqoohh4GnblBMWQotLLWddA2lH5IY/Y92P2+0xdDor3LWWtJBIi+ERvdTMIO5Ax7XPSnYVGlqkswbgZjQdCTmjLW3psoAc2Ekl5cxMwM9nCTc5Q7LNVZXvSaFP72AthE2i4ML01B6bdZQ9kefbAUT4ZEFbPkY2Kf122H+BytEaEt11qzBIu7IDl9UIojzQhpr34v134bNu8F9xLdN0g3h/Qvg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vdnv52I8rEGFueJoQ1lcAE+5wfRJ0JwSNyaFHi6dtlk=;
 b=QA6yq1/9errlfCeed9238lgITCK3YDh92V+SwPoIYGz+QR9kOXCgKzWnDOOAS5PlJ38stIzDqm5bXOGICWx+n9MH201w0RVo6+K0/jrK8mxchwAPgUuUXUHnW9z+GTTq2znhR7oXY5zioFk9E8XlKegT03vuJ5B9JpJr62iIs+C5VaBIl+1gctsttAir5FHvMh357Rz9vTEcq8YbUrQaranDCcWqdQ/uYYNFSd2CaXL1BOpmaGpQSt6I/hvxUCj1Trc5ab7fLkxxeI/RBd4VXL9Cjj9Eaibzgo2O15SqnSzbHpzO+vrPvQXuxzaLFkCzJmfq2nVLhGz2r8Y5e6PJLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vdnv52I8rEGFueJoQ1lcAE+5wfRJ0JwSNyaFHi6dtlk=;
 b=rtEvZUNJOaY4gpjMz3zTxIyXH3jC81cHWNus1TuQGlNhGq0llBqrINNpCddramrWbzYwLjebqQWNxx2qAOJplVqP/AIVIGfR66YBhiNlhUSDXZSyFzDbnTr0hT44ACJfAT9xKRZ0fosUhTpX0I5ZgmxPv+Am1gT0kbbwptPRlDoMWp5UMuqTkJvJGbUo1y/4GmFVKJWCPht1OIUPeIp1AYg89XZKm6uV3lwqcIdgiN8CBagm7+CAZ9gnFBP077woDJMBSBqIXVEnY/zCyTsjbNlzo9y0/Zfs+5gtmtS/R1LPFw3KKC0lZ5UDJFyZZ0wzmmBJ51IDm/3pSAKgCb6PfQ==
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR1201MB0107.namprd12.prod.outlook.com (2603:10b6:4:55::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Mon, 12 Apr
 2021 18:45:33 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.4020.022; Mon, 12 Apr 2021
 18:45:33 +0000
Date:   Mon, 12 Apr 2021 15:45:32 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Haakon Bugge <haakon.bugge@oracle.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Doug Ledford <dledford@redhat.com>,
        OFED mailing list <linux-rdma@vger.kernel.org>,
        Parav Pandit <parav@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH for-next v3 0/2] Introduce rdma_set_min_rnr_timer() and
 use it in RDS
Message-ID: <20210412184532.GP7405@nvidia.com>
References: <1617216194-12890-1-git-send-email-haakon.bugge@oracle.com>
 <BYAPR10MB3270D41D73EA9D9D4FCAF118937C9@BYAPR10MB3270.namprd10.prod.outlook.com>
 <20210401175106.GA1627431@nvidia.com>
 <75DFACE2-CBA6-4486-B22F-EFE6D8D51173@oracle.com>
 <FA3BF16F-893A-4990-BAA4-E8DC595A814B@oracle.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FA3BF16F-893A-4990-BAA4-E8DC595A814B@oracle.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR11CA0008.namprd11.prod.outlook.com
 (2603:10b6:208:23b::13) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR11CA0008.namprd11.prod.outlook.com (2603:10b6:208:23b::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Mon, 12 Apr 2021 18:45:33 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lW1Yy-004stc-5d; Mon, 12 Apr 2021 15:45:32 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9c56d378-30df-4913-d8e8-08d8fde3275d
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0107:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR1201MB0107E4A989A5950F3E483949C2709@DM5PR1201MB0107.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hCv8qVu+QWURETh1qAqqrmZNgY2bo5wol/cRnRPiwaZkArsckBCkC5dk5bV45bhFwXJReyASmZi3XsfxY9MdJUYSZVdmboV9KRVmsUx43XLWPNf3YVM4rPbsgjIEYq/G8k5e127HPs1TokbKTKQCTMKchiyPvbUW3qtClpgomj27unXPUpO1lMLWWUTZ4ynyhCFi8apzCy8tLGJkbnONL+VxqBrPfGjXN5fQd5jSAIxl2Yb3gVGNXDCVEVo92FLkC+UmV6kk6aX6qFwDt0fw0PtuMGQU6UKT67HogG5BJohm+pg11eROSwv87Wz3BvHSpGKP4im6hv9O5y4ZLQBEdy6wyqhGFFsRphh26hXbQxZqtrg5WfRBbrEdaHxP9JC/O7pI4ZsgQkl0aWP3eYnqXC03+zsz8eJCI1UTdVZNhfisyfGmdlYNfPWptq258kPfdQmznUxVs/kpwwkC4Y2cCdwED5l+anElYlkKQIWF1PgX4km/2pFIn/Y07NCrC2wdMiD4FOrUrLr1/Spfxr/G4JVsP8FQ7lVTpgZgaonZbHohLwP3bTLskFyZXqvcqbuBxusKyx9ZPJeSQzAhxwynm3eqMvNpIhN6qkpjgIwwgDE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(366004)(136003)(376002)(2906002)(1076003)(4744005)(6916009)(38100700002)(36756003)(66476007)(54906003)(66556008)(316002)(26005)(66946007)(8676002)(426003)(86362001)(2616005)(186003)(9746002)(9786002)(8936002)(5660300002)(53546011)(33656002)(478600001)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?KmnodAHuCt3Mhy3IesdsajowOAHN7Ec+5jllcrLXWSIL1E6iMlu9a8OXc1b7?=
 =?us-ascii?Q?i2Z+Z7y3gF6399FtmZgl+PSXMqdIB7TN1Cav1lf9qDdUTun/5baTEunJnxQL?=
 =?us-ascii?Q?qX03e4b2aR5I3/TqhyJz6HON1Z/CubYoAXZmrhI68lLM+BmyI2zDYDDPR+rl?=
 =?us-ascii?Q?ENjMRV2LY7VVCmltr2o8CnbU8uAvSHT16PIEwvyj2/e3fquZoe3tLp+Wg97V?=
 =?us-ascii?Q?CgFeSnFNWCSFit56k8qe5LD/+qewMxag55CTmUzOKmhhN0sUgvjv48LCtz3t?=
 =?us-ascii?Q?2IxHGHqnxdjgClerzWmUvhA8Z3TlL2Peuz/gNH17eVv0i1mxQLlbOtoKFOHH?=
 =?us-ascii?Q?Xv+/3whUOgV1ZonrQNzK6YQAFIU5g4tHf/DNGKnJate6t7cuC/RrdIf2DdXq?=
 =?us-ascii?Q?tQ2zbfzs5guRN2DxKg7bjfP4F0+G/F5wfrAmPu71/UUKL5f9yW6rT3CuHttx?=
 =?us-ascii?Q?eoyGHREZoWSc6He3GOcJKiRjoYq8m/cvc9B+qc7H07dpYQDtIr4KAOzmwUYT?=
 =?us-ascii?Q?nkFpKqe867FbZl77bHmVHwnoC879SqLlCHZwubA/owgbj+ERL30pN7Zx1BvJ?=
 =?us-ascii?Q?ObDh+hhIzkGKZ3DprObXOZx6rpYxYeFP7w8fpOuBh6iDIutNJgXcDG+eqbf1?=
 =?us-ascii?Q?XG767uy8a0HmNlzpNYPlRLQxF/80e7/0RFz3KPfTbsVYf7XVNi3+kdlhVvWR?=
 =?us-ascii?Q?9fHCa6MjQXzgxfJLwwkHyxAGbrTZPi342/KSkZwzG2+I2/rAMMJn7++4KPBF?=
 =?us-ascii?Q?Kq54O1r4386AzyJx6JGKFUG5jXlMVVqKP9k+WPRxgxGJUdgOhapaQUJUCd7+?=
 =?us-ascii?Q?mAS9sPjmY/lbFwzlx//uRZ/zawKR/Tx084nYtHvRVlpfB1fRSt65wZEgJTbN?=
 =?us-ascii?Q?6TssyinKNWMWw0SaHSza0xA/ocKM9RDw8wrTkd529Nx63fQ0oTIyDgS6Pbb6?=
 =?us-ascii?Q?28x5nZxBOfyLu4U1XxYVhr6MvV4kaEWa8DmBKPGC6olwEhOYPJf5mvNjfNqd?=
 =?us-ascii?Q?t2Y0Tkvt3zw49d3fL2+uw414K42FgcRazcpnxBUbWOuluehqcLKrYCpmT0wQ?=
 =?us-ascii?Q?hJwjQMOTEKNjRFqI/U6t8Otyj53nKvmL+ZWgwsqKcxsRDFCMGvp9eXPRQurW?=
 =?us-ascii?Q?mljkFZpXebDxpTHuHe+CmrZBYkTce1zM9Vg0H6xey35ymUiJzvje1OM4G1n9?=
 =?us-ascii?Q?YU9t2FcSrYp/saAXJRW/KbM31Uh7/1oeDZOF31YOaHDmikrW+PtHTXWNDudj?=
 =?us-ascii?Q?xIaS0ZkRk+OIUE2FOnegn/JJGeZjFDmCt9uG8z4qIwFixGQmmX10Vckt6WFh?=
 =?us-ascii?Q?fMyoeSuzavyKXJ9IWUF00uGXMSFQ6vUDJSlIU2w4f5RETQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c56d378-30df-4913-d8e8-08d8fde3275d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 18:45:33.4249
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PSCla/FTzgCQix7fWsikpVrQckm2qiT3kJW0/dGZZOLi/xyhz+IB0MfNPfsC1KDF
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0107
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 12, 2021 at 06:35:35PM +0000, Haakon Bugge wrote:
> 
> 
> > On 7 Apr 2021, at 18:41, Haakon Bugge <haakon.bugge@oracle.com> wrote:
> > 
> > 
> > 
> >> On 1 Apr 2021, at 19:51, Jason Gunthorpe <jgg@nvidia.com> wrote:
> >> 
> >> On Wed, Mar 31, 2021 at 07:54:17PM +0000, Santosh Shilimkar wrote:
> >>> [...]
> >>> 
> >>> Thanks Haakon. Patchset looks fine by me.
> >>> Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
> >> 
> >> Jakub/Dave are you OK if I take this RDS patch rdma to rdma's tree?
> > 
> > Let me know if this is lingering due to Leon's comment about using WARN_ON() instead of error returns.
> 
> A gentle ping.

I will take it with Santos' ack.

Jason
