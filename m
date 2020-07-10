Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4847A21B4E9
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 14:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbgGJMVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 08:21:31 -0400
Received: from hqnvemgate24.nvidia.com ([216.228.121.143]:7289 "EHLO
        hqnvemgate24.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbgGJMVa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 08:21:30 -0400
Received: from hqpgpgate101.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate24.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f085cdc0001>; Fri, 10 Jul 2020 05:19:40 -0700
Received: from hqmail.nvidia.com ([172.20.161.6])
  by hqpgpgate101.nvidia.com (PGP Universal service);
  Fri, 10 Jul 2020 05:21:29 -0700
X-PGP-Universal: processed;
        by hqpgpgate101.nvidia.com on Fri, 10 Jul 2020 05:21:29 -0700
Received: from HQMAIL109.nvidia.com (172.20.187.15) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 10 Jul
 2020 12:21:15 +0000
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.177)
 by HQMAIL109.nvidia.com (172.20.187.15) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 10 Jul 2020 12:21:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mBqxmvzylqH9UkcNGdN+Tp0pM39lWNc1da8TBGU/vZ73AdmUAUK/yelKBU+B8lCDvqncvjfTQCgkSC5fqX+XCIi+99YIpd/nriYCJakC9BDPXO/MekLPrlNCh8gtjQhMRhl/7/iukvzE5FWUGi99mPL5dz7fvkv55z2aj8z5mJqOm/kMTKVa2cF5Nr/rlh/SBXPGGrUC4rsRruYdtNOcuKlrSnb+lmfFnevJAMsSclHIx+NVqQvUAPToy0EtVyzadXTOVdPESfC9xWIU3osJCZM3fVXFEbT6KRDKTswSGhA9FZ79p+btUNBqCrsZxXZvjV3A0fDo6oOjy6Y41YIFoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4BHAuOghb0UIp9ylK1/S8zk3DWmS9Q9TdBlQ9zeMkog=;
 b=Fsd0iPZrrJSQHge5ohxxa2yZHyNrTm6L+tPYjJQkw4OIFjejpUEWUnG7aYWcgQtNKEexBPanE/v/a2BHOIW3TG5I1k4sMs9d2i9LkkDPHvbdI3BrhRP/R9wKqpIOeRJquXh1kzdxWSSDgeTqCWrt+/66qzCR5mbwvT9pC6T0M+kZZRXEO85uQf2mljKHTl73TwdTrv6aaLBSdkr/ZpujwqCE8+x/LGpHIzPGI1JZ7JWWl5nUPlgWQ/Sgti9/6XAsGD3m5nMv8ygHXmbH3PWKHwzI+WAsXgL1jVvJG6cediKJbm5ZB0AH3IagIL3373cuPsyfBpdtjsnfjtRusXwSfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3116.namprd12.prod.outlook.com (2603:10b6:5:38::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.23; Fri, 10 Jul
 2020 12:21:14 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1d53:7cb4:c3d7:2b54]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1d53:7cb4:c3d7:2b54%6]) with mapi id 15.20.3174.023; Fri, 10 Jul 2020
 12:21:14 +0000
Date:   Fri, 10 Jul 2020 09:21:13 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
CC:     "kuba@kernel.org" <kuba@kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        Aya Levin <ayal@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Tariq Toukan <tariqt@mellanox.com>,
        "alexander.h.duyck@linux.intel.com" 
        <alexander.h.duyck@linux.intel.com>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "helgaas@kernel.org" <helgaas@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net-next 10/10] net/mlx5e: Add support for PCI relaxed ordering
Message-ID: <20200710122113.GR23676@nvidia.com>
References: <0506f0aa-f35e-09c7-5ba0-b74cd9eb1384@mellanox.com>
 <20200708231630.GA472767@bjorn-Precision-5520>
 <20200708232602.GO23676@nvidia.com>
 <20200709173550.skza6igm72xrkw4w@bsd-mbp.dhcp.thefacebook.com>
 <20200709182011.GQ23676@nvidia.com>
 <20200709124726.24315b6e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <64f58446adb2536f87ea13cc5f0a88cd77d5cd5b.camel@mellanox.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <64f58446adb2536f87ea13cc5f0a88cd77d5cd5b.camel@mellanox.com>
X-ClientProxiedBy: BL0PR05CA0026.namprd05.prod.outlook.com
 (2603:10b6:208:91::36) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by BL0PR05CA0026.namprd05.prod.outlook.com (2603:10b6:208:91::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3195.10 via Frontend Transport; Fri, 10 Jul 2020 12:21:14 +0000
Received: from jgg by mlx with local (Exim 4.93)        (envelope-from <jgg@nvidia.com>)        id 1jts1h-0087DV-6r; Fri, 10 Jul 2020 09:21:13 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2ab9761d-1b96-4744-eaf1-08d824cbbd1b
X-MS-TrafficTypeDiagnostic: DM6PR12MB3116:
X-Microsoft-Antispam-PRVS: <DM6PR12MB31162DB1E149543DBB5022DBC2650@DM6PR12MB3116.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DcehuROUybr3uUOkl1eF5c7k1FnYmqOGGQJTAsgUgC5JSh6IHr7PKC6rNWpQJ6FJPW7ZNFF1+zPl3EOcs0BuGLUtjkDP48REgLp0oMZy1OMJyLBMxru9cw4SDeoK/hizmicyylvDxRFW1/1nf3Wp3/H4Brs4Fuu6vywTQt6XBZg1CD4C3+fYzjTz3WJWRcC2AEpZFxAtqEuWYFrUlKUF7Y5vSBTQA6RvE0PKEaUAQvNiQi/KazbRECZPkMy8CYX4cwd9QtEvdqX0kpVxXiiMPlTK8t5wwh/GxYcD2NDW9VdfiwvD4kw6/dJup3f9yaQ8zCejUYRFMPmf7TxOmJZjtg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(376002)(346002)(136003)(396003)(366004)(2906002)(6916009)(5660300002)(4744005)(186003)(36756003)(316002)(86362001)(54906003)(26005)(83380400001)(66946007)(1076003)(66556008)(33656002)(9786002)(9746002)(66476007)(8936002)(478600001)(2616005)(7416002)(4326008)(426003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 1YUr+qD1YEmwH5JCQFVSTJ46Y4pr5TF33hDMoc/22c6nZux25RNjtHHvhzCPltQJA+lR842ij1xlohm3Sw8CvHEeq/CPkJBQGIOI0yoWgjtMrQ8/BRKwP/08WxEKNyUiIweaU51TVbg7vX/6atYTp19sOiV7HV7wmALcMyxDnY/oNpY0QlgbwPBq8t5P/+sqXOvcvvDu1VJ8W2rRI3CoJmaEkPcKvfGGIEavpJqT7rWKltqWTEtf8xl9Po1lufdsUWR5x/35/9f4oxr3WN49iTDi+rwWub+nPhNEFw2OQJQkhWRbOAIqTjl+IuQlOrpVmUpylkGqOem5kTCPSOkZz47HnlcnsyqV/kUh49CmoL5O1CQ/W0iBcsnc9W+Db0e0n8fkdvtTufW0LqivRsl0vknfGDP27ZjWY1y1yTTlwOWvZ8vBLzzMDN74agC7hKxYRiQMV94b8ZeF46ppfOyUze893EqCQZrkQKPGh/nC3Vg=
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ab9761d-1b96-4744-eaf1-08d824cbbd1b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 12:21:14.4518
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y+7WjChz/oK/1e69i2z8X2n1qoXmYL7Qr7GQa3x6Bq5KPBah37GCkJOiZ9UBLzVm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3116
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1594383580; bh=4BHAuOghb0UIp9ylK1/S8zk3DWmS9Q9TdBlQ9zeMkog=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:Authentication-Results:Date:From:To:CC:
         Subject:Message-ID:References:Content-Type:Content-Disposition:
         In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Originating-IP:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-Microsoft-Antispam-PRVS:
         X-MS-Oob-TLC-OOBClassifiers:X-MS-Exchange-SenderADCheck:
         X-Microsoft-Antispam:X-Microsoft-Antispam-Message-Info:
         X-Forefront-Antispam-Report:X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=GazCMw5dR933eG1fpzTerD7sgW0dAUhyG6bL48rDCvDMGonfCNjGFJIizjuYrhHrv
         4nUmgab9rpB8D1s5rymiJbh+XlC4KwZTxc4YuX94tAmnBIFIaGjQBN5cqpJxe0W+0k
         kcgs1+gZUlWcg4CIsdYfyTFASXx6g0B8A9rx3X8j2qQG7LSMhp9Anjkk3QGxF01s47
         j+MII93NmQjgKK8D897ywi24SThULvhQpK/CbE5JcyP7YBdhCQjSyShMugdpfHK5+o
         IF8ND6qOqHZrJAEGV27KAyQbBnDX38TjT9Nz1dWHKalFGgRFRls+1xO9cP3kz5lmT9
         LW02aW54jofsA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 02:18:02AM +0000, Saeed Mahameed wrote:

> Be careful though to load driver with RO on and then setpci RO off.. 
> not sure what the side effects are, unstable driver maybe ?

According to the PCI spec HW should stop doing RO immediately once the
config space bit is cleared.

In any event continuing to issue RO won't harm anything.

> And not sure what should be the procedure then ? reload driver ? FW
> will get a notification from PCI ? 

At worst you'd have to reload the driver - continuing to use RO if the
driver starts with RO off is seriously broken and probably won't work
with the quirks to disable RO on buggy platforms.

But as above, the RO config space bit should have immedaite effect on
the device and it should stop using RO. The device HW itself has to
enforce this to be spec compliant.

Jason
