Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98CD626E381
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 20:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726416AbgIQSLA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 14:11:00 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:44957 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726401AbgIQSKl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 14:10:41 -0400
Received: from hkpgpgate102.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f63a6970000>; Fri, 18 Sep 2020 02:10:31 +0800
Received: from HKMAIL104.nvidia.com ([10.18.16.13])
  by hkpgpgate102.nvidia.com (PGP Universal service);
  Thu, 17 Sep 2020 11:10:31 -0700
X-PGP-Universal: processed;
        by hkpgpgate102.nvidia.com on Thu, 17 Sep 2020 11:10:31 -0700
Received: from HKMAIL104.nvidia.com (10.18.16.13) by HKMAIL104.nvidia.com
 (10.18.16.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 17 Sep
 2020 18:10:31 +0000
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.107)
 by HKMAIL104.nvidia.com (10.18.16.13) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 17 Sep 2020 18:10:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A7177KTBxXJ2VQu24oONnhYSCo8bOd9aQ552Wg51z6MkUZyD6QeX7HY/U7BeSayPjkxDM7g7+PY0W5frudL/FiOi3VtOoItjBRDEeafO949ivLfORlIjbW4TRPACgGbvV9YW9/ofH9+jn5kurZOIFgaWvyMnMq7nLjGNgCdc/yLe6tSL5JWgzlSBqSah+hF4io3csCBSW8j8pj+FXrZv7ooMgSOteSZAY9ge/owNslxe2zdxwc/lhicpbeVSwQ2g1eOQsfA34Kxpgw9MCXhv4evfm4kvYodn27ske58t0xXbe6GH/NoHqnK15NdlR2n9gPRkjV9Hjy8/gFpfagYbVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=v0JSfB0PxYfT4bcnDMLWNqBgAXHHQcDQGPvw21tT7ZI=;
 b=FDR2VFYJWBA/HOnoqQke4oGlaEjSY3U6k7cxaYB6Z3t8wkoxj4n4cZgcN6Y6azm93v76diPI/GKnqlXacEFBNJhKr9GeTNPgoVczcgcsdIW2g1l3SxEV0GYWah06EJO78OSuSasXV/TChtbZv0CKSCwjvWvdt3uqtZBgtxPRCWGaAtKnEROGf2ggbXr8PmZ2YTrBoAYiwmxsh7H3NDK+4wIuv483wF1MnLf92NNOBbzjZgwPcP4OWmTbZH/7jRSDdvopNH8E4nSjKrxPMCHK3FG3xQIoqLnchvCAeBKNCtQGzP0/O45MRecZs2Qi1rTYZ7RmnXCdb8c/dVZ2T4rGtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3020.namprd12.prod.outlook.com (2603:10b6:5:11f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14; Thu, 17 Sep
 2020 18:10:28 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::cdbe:f274:ad65:9a78%7]) with mapi id 15.20.3391.011; Thu, 17 Sep 2020
 18:10:28 +0000
Date:   Thu, 17 Sep 2020 15:10:26 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Alex Vesker <valex@nvidia.com>, <linux-rdma@vger.kernel.org>,
        <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH rdma-next 0/3] Extend mlx5_ib software steering interface
Message-ID: <20200917181026.GA144224@nvidia.com>
References: <20200903073857.1129166-1-leon@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200903073857.1129166-1-leon@kernel.org>
X-ClientProxiedBy: BL1PR13CA0026.namprd13.prod.outlook.com
 (2603:10b6:208:256::31) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (156.34.48.30) by BL1PR13CA0026.namprd13.prod.outlook.com (2603:10b6:208:256::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.8 via Frontend Transport; Thu, 17 Sep 2020 18:10:27 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1kIyMU-000bWx-Ds; Thu, 17 Sep 2020 15:10:26 -0300
X-Originating-IP: [156.34.48.30]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a2249408-a2a5-4c33-3e75-08d85b34f4fb
X-MS-TrafficTypeDiagnostic: DM6PR12MB3020:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR12MB302094653EF403AB3CB99376C23E0@DM6PR12MB3020.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r3KyckqJ9B+zybu+YhwQVwBUSD+zUTMHOhskOKynzyRfX6DxlVBtokJJWSRD8lY0q5rHxAlj5Zmd1O9uNgcGdaEk4AmD2EIc3rFsSLzEQ15RKA3k5mXywvQOXTuk0GtUhY0LjObFk/xFM3ofCEcYF+jvv0H04yM/FUDrxZLQ79ap3uxg8iJeqXOKxR+2g5WDsuJORx4zWPFw3ocFq0wSZhNwK6Cam07hxJWYMQPwkiAHnLkyg1ROawJPY9irWjpDVYjgBKP5K7q802UnKQLJjItPHaYzM9eXJWTwd+XcjJRyv4TcvFQE4vKvifF82W6I0isTYzg0oh1SZlFHU5dXQUf77VyXn9u4rlF/P1s9QeZYuJwhMpzPU7yJfoASBgTU
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(39860400002)(376002)(396003)(86362001)(186003)(426003)(26005)(4326008)(6916009)(2906002)(9746002)(54906003)(9786002)(107886003)(478600001)(8936002)(36756003)(5660300002)(83380400001)(33656002)(1076003)(316002)(4744005)(66946007)(8676002)(2616005)(66556008)(66476007)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: bLNVL/jMBo4cpgwrWoSu6dUHKNA7wgQxOknS9zAbmQ1b5IpOLAYqNv5dg+JXSy1wf99/HfN9UqKlD3Hz63zDs82HtQjAtgP4XLa4y0xqUBaPvncVErBi2E0y541/+LRWM5UlzyBJRc0Y06k6BjXXlvBiPJeXT953X8WATPsGRrLRlmRJyFS54EY3/2Tv5qMDJr9vXRnzcXN9Z3Hx4CjJdWTawjPooEUNuBSBStgL0JrSSJ9QRZrzF/1bF0//TI0GPoRVDhQ8BnJjXN50f9y1nYMdnAecAOYsgdk/fC/wCyNb4jQegHEOSQRwY8g9gk2OzmaFr9/aeMg//qIwzzBH2nCfVAMWfWbBs9mZc4W90/mHSjV12AJcqWJ/59LbFyyhT4ZKw35DLgMHDZeQs10vKznRqv8G2qSZtheA32+r89e71xqAoZwNqOHTpZHZ4FdcnT/0TnUpF9F6Fn2dUXHClwsZ1YjYpSVd19cePII5/HnUQYAb2jmJ2AM80U3BeMngCcsHeE9+k06gK0yNbIlVx+fvLIAZGosUasHNFbD/ZqQIVl9C7611+poec2xpO0WKmcMrIYbLXrsgrGPaf0/cHwtWUiBr7Mn71oGm4FQp3xzzsAmD2Q7L6I766NodL/jKs8cimON7PrtXr1IgSZgOrA==
X-MS-Exchange-CrossTenant-Network-Message-Id: a2249408-a2a5-4c33-3e75-08d85b34f4fb
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Sep 2020 18:10:28.1187
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r9fzcVoTjHIeWMozBvCZuebMNOauXhEYSi3f8f1F3+e9IcMOX8YtT2rPQBseRvHz
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3020
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1600366231; bh=v0JSfB0PxYfT4bcnDMLWNqBgAXHHQcDQGPvw21tT7ZI=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:Authentication-Results:Date:From:To:CC:
         Subject:Message-ID:References:Content-Type:Content-Disposition:
         In-Reply-To:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Originating-IP:
         X-MS-PublicTrafficType:X-MS-Office365-Filtering-Correlation-Id:
         X-MS-TrafficTypeDiagnostic:X-MS-Exchange-Transport-Forked:
         X-Microsoft-Antispam-PRVS:X-MS-Oob-TLC-OOBClassifiers:
         X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
         X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
         X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=FSJijcYI1xbrQf0kKSr2D+IzYLZ8ms5He3zqVd5fUUJ/89WkvNKd4+B6uDjCiXHJg
         VxUashjy5QYS9/Ghyy6ShXB92bWd+q0UPDx7upmCjkH0P6PkfHWFVZ05bHiPkFzmxa
         Yc6sj4hoCyFmp9iCAaJ3wPkVixWmR57KM3WbKUnODQVMAm/pwbpyWAzWvsma/9K4Dz
         NWhSaCfvxAmtzBqctPkkjLqZiS1QNLoKkfxxl3CxEEDPYc/WcmFaq3XUs/o3QHe5e4
         NfYQHXRP95mGjb8Jp3Ge7YThm2UOcZ13Tt1p0A9bvy9kVJPtPaYt30pLigVW8L86zz
         3r0DrnCi67khA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 03, 2020 at 10:38:54AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> This series from Alex extends software steering interface to support
> devices with extra capability "sw_owner_2" which will replace existing
> "sw_owner".
> 
> Thanks
> 
> Alex Vesker (3):
>   RDMA/mlx5: Add sw_owner_v2 bit capability
>   RDMA/mlx5: Allow DM allocation for sw_owner_v2 enabled devices
>   RDMA/mlx5: Expose TIR and QP ICM address for sw_owner_v2 devices

Ok, can you update the shared branch with the first patch? Thanks

Jason
