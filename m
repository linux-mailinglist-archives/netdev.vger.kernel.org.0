Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E55753519D0
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 20:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236172AbhDAR4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 13:56:32 -0400
Received: from mail-bn7nam10on2047.outbound.protection.outlook.com ([40.107.92.47]:23320
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237217AbhDARvI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Apr 2021 13:51:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QlV7IuVOb9CGGreZz9rDHOLMxSm2W6Zlwe41YbudvIE73Aog8yctxK3Jm0BAmTkdzRs23JKUw6E3ikdrIWkkX1R2KQV0tM08lIcvy07mirdiB8lDgoJ1iEMPwVnqEFOrqZbq47aAy1HG/FK0x7AGVPCWNcHtKNQzkAqfyl3R8RLAIvLNwmo3eOpVOXcrLi1cvLTM6FpVRV/bHKxj19XqI8OZ5X2u71tsEJDK0Jrfp61ObJQXHenlqQSs4PQHjnexIjS7AJvPZ9JTGrSQPEReh0w/bIIdJlDJhV1sT+IHZ1gfrJ2zsMIjJB6JHxEDhyvduFNKNzBOnGqpNclFfpIAXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/zxA3tgx7Zqr4C+iNVANeBD/IDtrPViVf22qo4mWv2A=;
 b=EXbV5S8gF0SlmvMN/azpSYAinrqlixQZcokLnSECPxUuWIGg5irSc1xhXhTh6MnyQCVQPYkFlOOvWCKBNllHDl6WrCy8d7Jb2SGDQyw9f9tpWhJlHXwlRD6JM3TnMvqRLJPTmKtc4Msw8p5v4i+1bVQC5xR0/Ih/1ioYqwIGalHVimoFMyTRgCLgEvzL6IR/SCONwJObPTF+doHNTm5tuxxurbdDpqNGmnAaz2tzXaxkjLEjIkDEYCEpikB8xyUsW+oFENLJIzgPm3C6aCznROWyCVmYDlHzbuU08jbDNxXOY+ggNMESVW7h5raZoPIxh3sO5gYVsWp6sNUxYTOoCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/zxA3tgx7Zqr4C+iNVANeBD/IDtrPViVf22qo4mWv2A=;
 b=cNC5GuoBJpLY7KJdLqT+rW8q+n/cSxGdna4TqnhIE4VgIT4+3cRMYQYNQEdxDmzOR0ah3LP3prfk9+b8qqACncy/nBNXnTQomfFtp7nUMHJRK+QJ360EDi+Z8uL5EsNVV/RVuZUBbGdbNRDVkLbTkFcF87i38EdT9aYSGZUySMsPXP8Dx0lgF+LQx+W5pPRdpdHZ797mGZE94FE4OpkQqTmo218XaUa4QwF7r89GoCE7k3xQuPxYe1SjjpuUR7ahCbPdVwD7Pc1h22kFyOG24mSVvCrb4PlFjPVDsGImCoZiZTJjNtksCSrPBIy2Sb1DLvD8Fik1g11ol4mINukLKA==
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB2487.namprd12.prod.outlook.com (2603:10b6:4:af::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Thu, 1 Apr
 2021 17:51:08 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.3999.028; Thu, 1 Apr 2021
 17:51:07 +0000
Date:   Thu, 1 Apr 2021 14:51:06 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Santosh Shilimkar <santosh.shilimkar@oracle.com>
Cc:     Haakon Bugge <haakon.bugge@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Doug Ledford <dledford@redhat.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Parav Pandit <parav@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH for-next v3 0/2] Introduce rdma_set_min_rnr_timer() and
 use it in RDS
Message-ID: <20210401175106.GA1627431@nvidia.com>
References: <1617216194-12890-1-git-send-email-haakon.bugge@oracle.com>
 <BYAPR10MB3270D41D73EA9D9D4FCAF118937C9@BYAPR10MB3270.namprd10.prod.outlook.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR10MB3270D41D73EA9D9D4FCAF118937C9@BYAPR10MB3270.namprd10.prod.outlook.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR15CA0037.namprd15.prod.outlook.com
 (2603:10b6:208:237::6) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR15CA0037.namprd15.prod.outlook.com (2603:10b6:208:237::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend Transport; Thu, 1 Apr 2021 17:51:07 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lS1TG-006pOH-Em; Thu, 01 Apr 2021 14:51:06 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cde8bab3-0f9d-4c72-8ca8-08d8f536ba5a
X-MS-TrafficTypeDiagnostic: DM5PR12MB2487:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB248794042267877F0950CF35C27B9@DM5PR12MB2487.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6BJTrCkpuYowUejuDO3W6Ghf9SpJRV+LEYF4mbTP5kmU3OItruQUGWP1a/03JoXgOfcFfE9MSOpjG8Ef7Nn9iSl0RugsUdnLAr1+eZxyJ3CtdQ0n0e2A/P5Yyc4t3AlENre59X1S6FDHDHBicDjtTJYA34Lc6O0oTaHA2m0iBX/rhTal72w8IxjbgG6ssxsd0+MlnWvP2fBXPZavR38YWFzLLnHwSZMu4HMXLggzroVEp1zavud9OXiwtXfQd0Sp28HrYujcORF174E1cR1pHvEx9iNV5Rjn6GS24U9AHm9UD5h+xuk5l6XJp+HMUh3TbOoWmjv/VWQsYAOylhMC5spuSwDlPzi1aAhnb0ZRGqBbGYhuT1ieHsfjWWm8bNTvV8DdhON+z78tc7kMmloR4LItBwB8VH9eXcXBED2DkGpS5ARhWoEQjNhxmw0kehG74o3Yrtg7YdBKMpSQnHmnd+RtwLx2RTVY0PVaEMH6GN6L3wOIE5DBI0A2RlcNbrMl9JlJa6hDK9K41qNyG5ZBBRpqZEXKG8+ePW1OLAD7autk75dfto4wV5mm07s6HM9Tr/6/g4qDnGn2Wj1V+YpyxIPHR4qgvmZjn17iMCjCmt0qjeTDmI5tx30KuSXGLlSJpYOAg8+ceMY0RFtG346NCCPwDDpOmniSN1Tid0iyC3g=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(366004)(346002)(39860400002)(8676002)(54906003)(8936002)(5660300002)(26005)(9746002)(186003)(4326008)(86362001)(33656002)(38100700001)(66946007)(2616005)(9786002)(66556008)(426003)(66476007)(558084003)(6916009)(478600001)(2906002)(1076003)(316002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?QPUaiR+7sutZEEMtjli9DHYsXYY6DzWrsaMwmGkh5aevWV27hkCIVGdquCYw?=
 =?us-ascii?Q?ykSoEHpd0XUYlKnR6Y4YTiuETWWBIjauMP+rqi6hSRppF6V5YIwhIBOsUvVb?=
 =?us-ascii?Q?scHyvN52isHx72KrGf1CaVojFT/wImByRgQ5YVrdjAtsWa0vL7iANoClQT3o?=
 =?us-ascii?Q?X55+nNugKCUjiZOI3GNVUEyt7k2YBQ5PTEZbyHOsBZY996zwS0Ms2+IgwVqX?=
 =?us-ascii?Q?+gis1+4yKMsiWFDB42CUumRy4/4SfuovaMEZIqGZblFx3nBc+0eQtLIrYSxO?=
 =?us-ascii?Q?EK8bn1U4sCBISbX06i21PUEPa/IlYgpPdYtO6s00+VKgEnr0XvTVdS9ij/lK?=
 =?us-ascii?Q?goGyl1YCoZDC/kAwzOf9IHiSBNVDgxr+3SieFt7brtp7WhdMNixLHyXCSqSk?=
 =?us-ascii?Q?3u/zvf1IDDUI/BZre1fOoHW5L9z9NNYLWcEYXvLTxQsDN3Fl+HbI7Xg5emRU?=
 =?us-ascii?Q?182WbHOe1+qWtRM6QQfmdr1Ox8alW40pM1JyThL01a4KP87+UecGiE5ba4ua?=
 =?us-ascii?Q?StGvp2nHdrhWCdQESR8EZ+4/1Fm6h5VfTXyXii6IY7BGR3I7oi11seLuLEVs?=
 =?us-ascii?Q?opZf6gCwsPtshhESb1Qxggyxhv0pyS6LQCSSz/ltxlRlCJLXq8xiqJR9FrdG?=
 =?us-ascii?Q?qLBgmhHPbF1xQE7DjYfQneDdtGzXSs3pohMJTZBUzPdWKnIkjSDc6iOK/Ekc?=
 =?us-ascii?Q?CZPsOkx/kNNS3bYj5L8ivI1gjZOFwYzMVRZtNaU8UcH4PPi0VkIolbyNjder?=
 =?us-ascii?Q?3yuAn2QQGnuDX7b/FWJaCQ3B9GLPqmOx9cy7jhY0dx8OUKWx8AU24YrHY/hM?=
 =?us-ascii?Q?e/REGdUOFBdW2LmMma3YAnBFqcn5FNDPmi45IPCHf1NB20phrewFAEAoqOzD?=
 =?us-ascii?Q?WrdQu5MqfmPdGs+oyMO8yxhI88leKwstUq3BPKDhXvmF1SQjzxU2DvaWcID+?=
 =?us-ascii?Q?OrB2wogUZKbMCGlUF4A5PjVkKhe1J7yL1OdBenU7ARLICUqnR9eeCnlNF0aa?=
 =?us-ascii?Q?aOQqqRID+YiCHfNz++kH8sDoQtITr8+E1tPjb9glOwFO/Wvo3Ic2ugft7Q2Z?=
 =?us-ascii?Q?69437nFIqstSN/5wKvRMrIP4BTJ8BqSTdeHOQfPwMoLJw01IAFIyfhx57NaG?=
 =?us-ascii?Q?jlJ/4PfJyHh+GgausvYxqrtnOUDO/u5yK4a6CCwjg6gdqYmiH6/kSOuMSong?=
 =?us-ascii?Q?Y7vfS2H1ZybhW2yFzlDMQkHxmEcOgNvnz6Y/kgA2ZvfOhY8YojK0MvIKRMV/?=
 =?us-ascii?Q?gJk9+FwzoN6ubmfAX8lQt55obmm8PCKrMXExlbqyCahCHl7tq9xm2bolrDxB?=
 =?us-ascii?Q?16fzgzzQ8KDr+3L7y7IE8R0kcGoaaZvJTQhKpovPz7VKgQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cde8bab3-0f9d-4c72-8ca8-08d8f536ba5a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 17:51:07.7889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5OcY/W25uleFw5GC/0sGx2/nXgfU4Xj8/OkmWSNaOjzuU/lmYuqcp/5RIiNoOY54
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2487
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 31, 2021 at 07:54:17PM +0000, Santosh Shilimkar wrote:
> [...]
> 
> Thanks Haakon. Patchset looks fine by me.
> Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>

Jakub/Dave are you OK if I take this RDS patch rdma to rdma's tree?

Thanks,
Jason
