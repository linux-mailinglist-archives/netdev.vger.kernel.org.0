Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D52735827C
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 13:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbhDHLyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 07:54:02 -0400
Received: from mail-bn7nam10on2048.outbound.protection.outlook.com ([40.107.92.48]:41729
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229751AbhDHLyB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 07:54:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aDZ3bL86WxDx9aAH51JdDxnGYhE9Bf0rxYcKnWuUCFUW9cmxVh3Xn5gb1nnCnzIJLLMZTrn2tb2OoGNynTSxKyQ0zgAYHV8eHG/+uONnNiY3YeixVH9ONbU4mOajfSCZeS1cl0xKxPXd01H2MV2xqF3XZqgqsQbiRuof1Fw1K4jW6b5j5qNT1uYwFxv9xSE7ZBZYtK+OsWe/vxcmhbh737lZMlXiw4mx2auTroe+jNJ0naPCG8CQc9ZoTq5TbKn7Jd3kile52KUYRn+E9WSll09MyQPn/rtrXTYBl2n7fANpSgeq7vRHacgJqSE4QxlGXunjPZ1oss8svdQ79dgt0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gZxz5mfZye2LkAAm9Sb9z8UHXB1uZ8/aU5EtLeROlSc=;
 b=G/le8AQADJkCJMf5puCV4EwpqSg9yB/Fc870EejClo/eNZwXj1rjTZfUlCcZvlpOBl3UChfV4VHShmZk+hwbOdr0dH/CCqKeg56xmJUxNRBVog/0nhbVtgedjP1jAU3jusYcGUaHNr+WrhyK5T0m1lCpUXgSzxyIAl3tdmmixXo2XClhKYNMtYXHMULlDrVmvxvzN7fK2lOierWhIudrLQahSUu5x8xxfmnSu8rKihpjFnWA1Lpt+pR8Rv764iMukLhmOvlRzPJvR0iSxbyMJV1nsLpFT0fNi5X0G/q7zxMrdKlNFHc9W1q29UpLJNOIZDNlGRKhIPHTud4Js5k13Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gZxz5mfZye2LkAAm9Sb9z8UHXB1uZ8/aU5EtLeROlSc=;
 b=Aqe1KpxYdEBxEkHD+cCC7DlHdJYCcmpHUZF17lwyWTDbeMPtPUnCkB+QLWWx5fU5Z0EUp0uUuSSbka6rLHlod50FaVi3y++3fqfrj6qxDr5zliZHqPF+eW3jUTFE/tFHyNg9NdHABWRiRXh3WJnIUYys1b+PrjBgDqEnHgDtDgzNCBi11SibFgytMy5ieIo1fYu+NGF2mx0+gl1Rf51rjwfqOThJpPLyAOKH73Hs0W6f42XlKNWIBHs29JijH4atoo41/pb6jvdt4/avhXyN/wEPu0ovItpTLHzj9QnbqxqZPWtTY60lGq4KdYPptu1IVTY2ewd6Uettkb+cHfYFGQ==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3116.namprd12.prod.outlook.com (2603:10b6:5:38::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Thu, 8 Apr
 2021 11:53:48 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3999.032; Thu, 8 Apr 2021
 11:53:48 +0000
Date:   Thu, 8 Apr 2021 08:53:47 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Devesh Sharma <devesh.sharma@broadcom.com>,
        Doug Ledford <dledford@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        Netdev <netdev@vger.kernel.org>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>
Subject: Re: [PATCH rdma-next v2 0/5] Get rid of custom made module dependency
Message-ID: <20210408115347.GO7405@nvidia.com>
References: <20210401065715.565226-1-leon@kernel.org>
 <CANjDDBiuw_VNepewLAtYE58Eg2JEsvGbpxttWyjV6DYMQdY5Zw@mail.gmail.com>
 <YGhUjarXh+BEK1pW@unreal>
 <CANjDDBiC-8pL+-ma1c0n8vjMaorm-CasV_D+_8q2LGy-AYuTVg@mail.gmail.com>
 <YG7srVMi8IEjuLfF@unreal>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YG7srVMi8IEjuLfF@unreal>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: BL0PR02CA0090.namprd02.prod.outlook.com
 (2603:10b6:208:51::31) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL0PR02CA0090.namprd02.prod.outlook.com (2603:10b6:208:51::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Thu, 8 Apr 2021 11:53:48 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lUTEJ-002hCG-0f; Thu, 08 Apr 2021 08:53:47 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c80727b-f3b3-4d7f-d96e-08d8fa84f87f
X-MS-TrafficTypeDiagnostic: DM6PR12MB3116:
X-Microsoft-Antispam-PRVS: <DM6PR12MB3116BDF2962CBD5FDE0D61FFC2749@DM6PR12MB3116.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QMJYQpNj31l7wsyT0dE+LvlifrLnbzKws++pdUJxvo95Xyh7uOGhFtu0B4ttrZHnEvrFMTh5nvHoWoSl1ziX0vpJx1XFLlfOzc/0nKvpt7VV7JlyLgd4gyB6nEp3Jk6ych9mgE9U/QPO/zJFOeZNabmIbhK6ZEYPE58r05HLGZIwdXNFa7/ATFW407VgIdShkC8QQV1w7C0VZ3dzdvgTsLEcyGc+aodlAH7JbTKyGp8t644I1rTUilHkhpDUKMwAv8gE6ZqvuoYBYb+q6AtEwmOy+ghxlHIe4OR3h8KR5zt+4RE3/Z7/7g2m6EI5VzMUMGaXlpZ/Y56J8b4eRv8PL3MH53GbkyJQXV9UGZMTiczx7LCiGBvN5vNVqa4JWkAcw4OvB8Nix5sbOTzCxTbno7f+cKGg8D0XnSu5WY/sUV9lXbNaEPa4a75sZliYShy5OAGDl1fo6rSxa6TFUwbAwoGWtx9/yYHaqjbU00fXuTo4d8EtTT5hP/uQAu4rZGkObHNr9qii3iGNeL1xnO6hrzWlacT05MeKoJS6wIWVsvLH5Dtdex45KcmenTYIrcDReyqv2e3HstxZ5IaIzRQsvfuSi0FYlYNEfD6ggKQecXsl7dOvGQjixRWwOYKNqBZSb+H01QJtTBZwq0rSMNWaaH1bbL+//iEsc0wkE0vay7CIsABaIGuUrPnOLEncYSnG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(136003)(376002)(366004)(396003)(66556008)(38100700001)(1076003)(4744005)(2616005)(66946007)(66476007)(5660300002)(26005)(186003)(2906002)(86362001)(478600001)(7416002)(8676002)(36756003)(33656002)(316002)(8936002)(9786002)(9746002)(6916009)(54906003)(426003)(4326008)(26583001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?YLZ1bhQtTEuJratyN/AZc8TT+uUBe0Lpn7SWa7TAolCvcqPn9rx+zUCJKPis?=
 =?us-ascii?Q?5SM7CoBawtbuc75kI32WMjGGeCgLDOTRv5orUiH+xkWg7VzjynmJyyVtyG0Z?=
 =?us-ascii?Q?D1nbMJrWDn4TSNdntKPBs+9S15GDgWy76bRslt+8YqCF23RzDh5zwpGZazJ5?=
 =?us-ascii?Q?jx36vojX4bzUujwn+ltUUIPPb7WdJTap+ULXH/ZXHkB2Oz36pq3gHbeva1NK?=
 =?us-ascii?Q?U009ACCkIudQadOvRBJcJmmtrokV+BbYDNDoZhZqy0CpblGsOiYu+ca00I79?=
 =?us-ascii?Q?yqtUTBLNOeTjLVRZ5UUdjGbpYMVLvP3JWHgQSf45N+XuwgBvfcf3/dqoyEHA?=
 =?us-ascii?Q?mcsw/aOU7aOVpcKLosRoQZkVqWSZKUHpxzavsSRlJxkyGqLNh19aog/XCZWE?=
 =?us-ascii?Q?Yshe+A9MP/64gokz/vIev5g768WLgxx9DjGS8RyPiWG6PajHC3+Y7K47+z8u?=
 =?us-ascii?Q?KcQ1ULp3u7BNw6reJNikDO6y3xgl9BYoBeY+4qvru7EjOWEsT1vR3eAYoXiZ?=
 =?us-ascii?Q?RDMKZGXJVXn7aT3hztc7UgwHTTylM74ufL3TjrA7AHe6LdH44T7mBlSx5IQ3?=
 =?us-ascii?Q?luJuDTkc4wSP+ifdfwmc6849T1dk3jqGZ+Ap0sif+2j72DmGr9OD2V1J+Pp7?=
 =?us-ascii?Q?DCarxmhPsLSj1S/o4t18Xeyab9pNkyRzzIxDUF1vFTGWXhoqYFGfJpbfKI6l?=
 =?us-ascii?Q?oK8oBwC/Q/0JABbIKKa7+XbtX+P8YhPMsYIPMRvNiJboDdLG9dQ8QNCOsEeH?=
 =?us-ascii?Q?9BK8z6/DVmaw2h3e1swTFdYf12fNiev1gvs7EcAnh1TgQR3SBeg8apQg8ti4?=
 =?us-ascii?Q?+nrTBZnbqmn73VpDcTRrq5RK2pJrawg/lGEv1mI4NXDxmJeFgBxs7ls0e3si?=
 =?us-ascii?Q?gGlPkSR7I9GrNg1ZKRB9UoD52XG+egAloElrpv4CwgsHgdoyhBcBuSsUty2W?=
 =?us-ascii?Q?FA1xARTgNREA1MyH6ZWMTDAmPq+u5WYUXc5Y5chX0ikim7XLWQA24Bozdme0?=
 =?us-ascii?Q?wawOiKIFbR5VR7sEiPM3Q/oMHOzv7yWEUFWXXeWQ/9LCSm878o03IOx7CVN4?=
 =?us-ascii?Q?dHAYws95i8Apw0Hb3A/Z97MMPTTf5Ydshg9Bc4PwQLOXzoqvMnysVaj8OfyN?=
 =?us-ascii?Q?GAY2zqJVLX+G3OwxLF4oySDnIIpN8ifVCk7YTnYxruOb3v6ueECFCDa9roeR?=
 =?us-ascii?Q?gXC9Jn8WJ93uTULyge2we8vN6HpfnfwiVdUfKZvDsySCXOmv0U3N/F1OYzXM?=
 =?us-ascii?Q?9kdsQHx2Rw5TcF0sBOw8zKYhwEtv6v8wGVpASQrrw5fNbbpiPgeE1Pp0U3vm?=
 =?us-ascii?Q?KDPuLYuTQj0YKNFgqJ3uoISJlyHCi5Err9yYyW16/dz4Jw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c80727b-f3b3-4d7f-d96e-08d8fa84f87f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Apr 2021 11:53:48.5799
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PXrRDh2e7EU5up4jSyHt+MW5RE2XgLi0ENS/zQKj08hPfG/CO+SJEnufMER0VqSL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3116
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 08, 2021 at 02:44:45PM +0300, Leon Romanovsky wrote:

> > In my internal testing, I am seeing a crash using the 3rd patch. I am
> > spending a few cycles on debugging it. expect my input in a day or so.
> 
> Can you please post the kernel crash report here?
> I don't see how function rename in patch #3 can cause to the crash.

I looked too, I'm also quite surprised that 1,2,3 alone have a
bug.. Is there some condition where ulp_probe can be null?

Ugh the is_bnxt_re_dev() is horribly gross too

Jason
