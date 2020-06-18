Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B74E1FF286
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 15:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729920AbgFRNBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 09:01:36 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:61678 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725898AbgFRNBd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 09:01:33 -0400
Received: from hkpgpgate102.nvidia.com (Not Verified[10.18.92.9]) by nat-hk.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5eeb65aa0000>; Thu, 18 Jun 2020 21:01:30 +0800
Received: from HKMAIL101.nvidia.com ([10.18.16.10])
  by hkpgpgate102.nvidia.com (PGP Universal service);
  Thu, 18 Jun 2020 06:01:30 -0700
X-PGP-Universal: processed;
        by hkpgpgate102.nvidia.com on Thu, 18 Jun 2020 06:01:30 -0700
Received: from HKMAIL101.nvidia.com (10.18.16.10) by HKMAIL101.nvidia.com
 (10.18.16.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 18 Jun
 2020 13:01:23 +0000
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (104.47.45.52) by
 HKMAIL101.nvidia.com (10.18.16.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Thu, 18 Jun 2020 13:01:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k6JdnTFpVrxRI6XnPgeeYwDqOet7usvGj40sBCWBSK3NtTVubBhWBWSvaw+C/vu+3Fl1g4dX3Uo6AkW85SSt+rnPcrskZs4ghTN99XsTJ8njMX35K7/rmNzo0fPTImp1JFN37n167seYdJBsh7SiOtobevUaEH3cnfgThlfqC4qR9nSchO7KSXu744kCX7Yq1lYS5py524sUrf4WBZm2Wt5aJp5H2mEPH99ONPJ0D/klLUjwo5rgOwiNIIgc/jUFlfiuO+/lQ5jDRKcZD3BSZwPxJwMR0X0aQOz9x5WXdDcR6L+3mOIbFyyO7t2QAFJMdAbWAiyXWM9swZjdu/jpag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZS6djPfbx+7bCqfr7Pn6QJAi8r1tS8uB1l0XZ3cwA3Y=;
 b=AsxZDF0vSUXpkRUSKuGk1JUqruTTmp0uvMM+mxGj2KEXG5A8LTFkPpO7bnfaiJvI8z4xISXT73E7EPDx2CEoytgXMtmxaOr891iXuoA2dk2yUxzDVwbXsNphhYj8YsrLWAV1dkDxDKz4xKHf5eoR+zfKYG9TC3ncKLoFA9o3QbA/PdOWrXdxGS7YnC+RzoCMe4BMjB3DETX/3O4I+K7Vmazls5spgjmS+2B5+vt2Z/g9cPzE1tGF8A7BynT6rKeTreSqv0O1i1M9xGkxCb/Xn8v5QZZbYNEv07eyzEMnJ7vn/sAXpHsE0YQuHhfCvabhkmHixwfrXhe569lhunxjxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3515.namprd12.prod.outlook.com (2603:10b6:5:15f::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.21; Thu, 18 Jun
 2020 13:01:20 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1d53:7cb4:c3d7:2b54]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1d53:7cb4:c3d7:2b54%6]) with mapi id 15.20.3109.021; Thu, 18 Jun 2020
 13:01:20 +0000
Date:   Thu, 18 Jun 2020 10:01:19 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@mellanox.com>,
        <linux-rdma@vger.kernel.org>, Mark Zhang <markz@mellanox.com>,
        <netdev@vger.kernel.org>, Saeed Mahameed <saeedm@mellanox.com>
Subject: Re: [PATCH rdma-rc] RDMA/mlx5: Fix missed RST2INIT and INIT2INIT
 steps during ECE handshake
Message-ID: <20200618130119.GA2406318@mellanox.com>
References: <20200616104536.2426384-1-leon@kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200616104536.2426384-1-leon@kernel.org>
X-NVConfidentiality: public
X-ClientProxiedBy: YT1PR01CA0008.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01::21)
 To DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (206.223.160.26) by YT1PR01CA0008.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22 via Frontend Transport; Thu, 18 Jun 2020 13:01:20 +0000
Received: from jgg by mlx with local (Exim 4.93)        (envelope-from <jgg@nvidia.com>)        id 1jluAR-00A608-87; Thu, 18 Jun 2020 10:01:19 -0300
X-NVConfidentiality: public
X-Originating-IP: [206.223.160.26]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 539cd25d-822d-4a64-a988-08d81387b259
X-MS-TrafficTypeDiagnostic: DM6PR12MB3515:
X-Microsoft-Antispam-PRVS: <DM6PR12MB35151EE1DA24173089006F90C29B0@DM6PR12MB3515.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 0438F90F17
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2DzyPZhRRzR6k6cv5Cb+Ys47SrR+Oo3QTSyV2w4un15NtaV7AhjC//QDHeCk85t0tpxN/v6A2kIOosg/OYhyHIERqXCybJtf3GtJ/+bcrKxhtMqctcDyrm8XsuS4KgaOglnrfcI37Y9FP3J4TsXSEftXZP+POObb2eTOfI1gW6LMS99XxcTTeaPZD7R+A+mrk4IRztIGsoGfhpIN5c0OrkjYA8CVIo0MvphVpRFHIOQ5t/tmJ0zaRVK3NLwV1+0YNAF5qtMbG0aAZiEU6eHZQxI5R0JVgeoPafMzQFtiR0UCzt0Sud7JBiA7B48dmJCnI/dc+LySw0y9Zo8bU0gUHA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(136003)(346002)(376002)(366004)(39860400002)(396003)(2906002)(86362001)(316002)(9786002)(1076003)(4744005)(66946007)(66556008)(478600001)(9746002)(26005)(186003)(66476007)(54906003)(8936002)(9686003)(6916009)(8676002)(33656002)(426003)(36756003)(5660300002)(83380400001)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 5bpqkPmGE6BcQA2Pk6+7aRrAhW+A8wJboN+M1yjBQYy2WTLrRXVdMKrWxpWpn9Zi3w8CCwQ4OD2JALKD0QRdHNj7qmACMdl+rLA0FnudXByB6Z7wcn5s0gVOPkJNk3V4Tl49/Nl/t8jwXwCe/FvqZxcpXHXIgBC/FKU8/p44gxj+w6wmME2wGfMQu/gXv/O9LqjW1eCt8KSJq9EwbozQTQ0ILZG6jdd4ice/Ctfyx5BRgVSBVysUo1FviTLu6UVHo3EGtKDruGdZTZ79Es8zyLWthbIMRqX5NUXFmlTu6JVCRvIUDTpvbyX8kR3MiXqOwEdmy5jHr7MT4UZwkz29FM7KWBv3rZCnPHS//nPDE/zXmnerG40rilF4mfFbI31T9NEtajztyygDhwKSZ8nD5cpeuXUtLsOdGlhlNJ9K18k6lfs7wtLeQkE4raxt2T6WZ2HX7O7ChrM8S3VnRTDNwQfx6WOdlqk4XaaC1+7NkpPtCLFG7PZKwpkXNBjJw71f
X-MS-Exchange-CrossTenant-Network-Message-Id: 539cd25d-822d-4a64-a988-08d81387b259
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jun 2020 13:01:20.7727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bufiwKhG0Fp1JqN+rk7nFtf2FrCxyRLEhYA37UsDhMdQ66IKdus3rrQ/J9Mw+xKW
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3515
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1592485290; bh=ZS6djPfbx+7bCqfr7Pn6QJAi8r1tS8uB1l0XZ3cwA3Y=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:Authentication-Results:Date:From:To:CC:
         Subject:Message-ID:References:Content-Type:Content-Disposition:
         In-Reply-To:X-NVConfidentiality:X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-NVConfidentiality:
         X-Originating-IP:X-MS-PublicTrafficType:
         X-MS-Office365-Filtering-Correlation-Id:X-MS-TrafficTypeDiagnostic:
         X-Microsoft-Antispam-PRVS:X-MS-Oob-TLC-OOBClassifiers:
         X-Forefront-PRVS:X-MS-Exchange-SenderADCheck:X-Microsoft-Antispam:
         X-Microsoft-Antispam-Message-Info:X-Forefront-Antispam-Report:
         X-MS-Exchange-AntiSpam-MessageData:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-OriginalArrivalTime:
         X-MS-Exchange-CrossTenant-FromEntityHeader:
         X-MS-Exchange-CrossTenant-Id:X-MS-Exchange-CrossTenant-MailboxType:
         X-MS-Exchange-CrossTenant-UserPrincipalName:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=Q/10GwcF8ZwxnTZlLhvPTWdnusPCQ3I4k5RefPxda9PuOR5llgoNnC6tkK3rwzQFk
         FaIL0mG561fi7wtJyzovtrM4ctIa/ceBPE9d8CfUJEkG1aVWJM6JZByB9O5lBPXqFF
         Ykldr4r7k2g1Up/uCq/aPsUzcEWkrW2YvC9NYsju74hB1U6MecOA75JEMjPKShqPwd
         5RFHbUAKp5FXfpw/g1/TaxNruneTULPZRVuKuza+vC5ncJi7LdijY2+NLErQJyOo4A
         FxLPKieAoNKI+1MQ6yLODbSfM2SD/hIsfjmUWVfAQ9/UHVZUTQGxpUb+f1OWU6q8ot
         HRGM5H9T0MyXA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 16, 2020 at 01:45:36PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Missed step during ECE handshake left userspace application with less
> options for the ECE handshake with a need to do workarounds.
> 
> Fixes: 50aec2c3135e ("RDMA/mlx5: Return ECE data after modify QP")
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  drivers/infiniband/hw/mlx5/qpc.c |  8 ++++++++
>  include/linux/mlx5/mlx5_ifc.h    | 10 ++++++----
>  2 files changed, 14 insertions(+), 4 deletions(-)

Applied to for-rc, thanks

Jason
