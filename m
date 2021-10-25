Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38A04439F29
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 21:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234408AbhJYTR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 15:17:56 -0400
Received: from mail-mw2nam10on2040.outbound.protection.outlook.com ([40.107.94.40]:21655
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234168AbhJYTRf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 15:17:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n2khnePs8luFPw1IhopokPGKLeto/B+2yzesGb6T3SG5/UubxmQwKYJ5JbuJaX5lPd0MFyg28zdKCZ/Bu9V3EAeQiGUJIiHvl9AgP6Gf2rLKUTh9ZsoyOZwLhT08ujY/JQ2ODlXn3HeheD9rL8DUGqAjRNb3YaEhIXJRpRhYMScov1+9gPuyW21fzP2G+ERgKWm1ZYKPSBLvOdhJhKhWHcqU6i16J2k9OlPyHbF0hKLCMZqMzTxMhdnPrs002pK74r1PhliZ8Caj2yyAquwddWT89r6EEhlZ6haiT9kjdYG9fzohtYckKGC2+z8YED0W7sHOPDhhdaqWHnuL6eJmMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AdRzcI5XXKHSpAaV0K3YiHxjUZ4msr6YNjRiLiNFTog=;
 b=UOYo828eTQmD4lR/jneJUYs0jrJ86TEWqrORIemEAgGKkLNCH8UWQXT0TPCrfjnryz9MU8NerLMsdLfAsstGH/rBW6Q1KzpkRYjeQIf8VpMvHWgfkT78SVMBa7iEzf8Io/5Cdhp2MxqjGEfCr1/XyIxJT46nxgdM1mStFL32fIvjGo9pbCsgpB48AjsiS5EuDWDhGCOjxzFAVzO/HEiIzk71DH5blMAF/IdDdBfYJR0P20NLUVlBvhHqDW82Rbeaxsa35kBewly/v6XyxT0RxzZwn/8UVS8A4MN1Y+aMBG6Uow+dc7Le49uEMx6h3NiMTPBRsPyOhj5gWi60rS9XeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AdRzcI5XXKHSpAaV0K3YiHxjUZ4msr6YNjRiLiNFTog=;
 b=bTgSnHu52TTJXFx3e6nogk6m3zt3xdZkSfCD53HsyplHgkERUPVsNB3eL9FnTbqYbBY7WM0WcCirYywdkLLecWYy4nrFbFBQNdFEze26SX9xH/5qnTmd7hPTFbgPb2nmTdTswOgZkCBpRiFEWMSv8yIy5lI4PuBw77inzoG7fP7AygTrpi9wEnQ0pWFrV/4uCZ3CdhfRUU7pc/itVXTYjUjnluaUp7ZHS9k+u4hh/8gmg99/trNNr1w5iqMF58l4QYLGcESGoykI9tklZtJ0NKkMHsF46E/ojpo1kgw25qAMhQo0tRpQTmXktouQoOq35epgYt39BmS3K8B96WATtA==
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=nvidia.com;
Received: from BL0PR12MB5506.namprd12.prod.outlook.com (2603:10b6:208:1cb::22)
 by BL1PR12MB5190.namprd12.prod.outlook.com (2603:10b6:208:31c::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Mon, 25 Oct
 2021 19:15:11 +0000
Received: from BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95]) by BL0PR12MB5506.namprd12.prod.outlook.com
 ([fe80::e8af:232:915e:2f95%8]) with mapi id 15.20.4628.020; Mon, 25 Oct 2021
 19:15:11 +0000
Date:   Mon, 25 Oct 2021 16:15:09 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Cc:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        Cornelia Huck <cohuck@redhat.com>
Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Message-ID: <20211025191509.GB2744544@nvidia.com>
References: <20211019105838.227569-13-yishaih@nvidia.com>
 <20211019124352.74c3b6ba.alex.williamson@redhat.com>
 <20211019192328.GZ2744544@nvidia.com>
 <20211019145856.2fa7f7c8.alex.williamson@redhat.com>
 <20211019230431.GA2744544@nvidia.com>
 <5a496713-ae1d-11f2-1260-e4c1956e1eda@nvidia.com>
 <20211020105230.524e2149.alex.williamson@redhat.com>
 <YXbceaVo0q6hOesg@work-vm>
 <20211025115535.49978053.alex.williamson@redhat.com>
 <YXb7wejD1qckNrhC@work-vm>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXb7wejD1qckNrhC@work-vm>
X-ClientProxiedBy: YT3PR01CA0085.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:84::16) To BL0PR12MB5506.namprd12.prod.outlook.com
 (2603:10b6:208:1cb::22)
MIME-Version: 1.0
Received: from mlx.ziepe.ca (206.223.160.26) by YT3PR01CA0085.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:84::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Mon, 25 Oct 2021 19:15:10 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1mf5R7-001pfr-DE; Mon, 25 Oct 2021 16:15:09 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1f85461f-f930-4013-3712-08d997ebc3d9
X-MS-TrafficTypeDiagnostic: BL1PR12MB5190:
X-Microsoft-Antispam-PRVS: <BL1PR12MB5190773F3101D0D3C251F65FC2839@BL1PR12MB5190.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8dSmWnW4CJ2z79//nme4ba3i9bIaXgx8dIQ+YqLH+ZSnaQwOZBsTjcq3pTjWrmVdIA77huf5J9AKqoaSjEg1qdBZkN76f/2bqoT0LOt1AbCxfVKIxgqI0ywt4Yv/iNcfBXS/dMhTAWbd+UwYZVLfC8zkecC72YyeSPSsOoBXVkA3MWsnmzD94r3zDymofjI+fElsPH44txEjjwRwD13ZMtqz8ERsSdUBj/hDwAel9Edlci0E3cJHazoNJ0Mj7HohD18UJbvChT5mdkPvkauOQ4rVXSfYryRsd4nSZUoSMdDVvGRZPIpkHFasrNEB8GBPzHhtxBBvU1Xhvdr8Bbvz6aW9vB4bFXSJAFKgoxCTJ8CJ16rztuIG008eV7/YNkAvMotNuTxnz4RgGCdk8vHXwOBPU1TGjaAviXEsgvWF99X2yTZfePHyFQYGiEA18w68v7jsBOXNyH8LmDsTx7XJnRE7gopvCLOV4us/iuClyFoo1vs/yQkVQbzhzMjPZ9oBmICd/MFGi8Sq1mSQwlk/wEvUjmhu2Wn9ZA7E4szICwDtLOvnzAHi0+pqxhQCw10JSfcNVBZEwXf9ZYU2HQH0GmReD43Y+1WUvzCzpBi4Nl/gGDmRCIdi4vO88mlUMUe5wvmqsQFU4Moi9a6nqwFZbw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR12MB5506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38100700002)(8936002)(316002)(9746002)(8676002)(66946007)(54906003)(6916009)(66556008)(508600001)(9786002)(33656002)(66476007)(4326008)(186003)(36756003)(2906002)(426003)(26005)(2616005)(83380400001)(4744005)(86362001)(1076003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mvaXTLWBIoZ8zgydsS5nlCCGCj9mSXMVWRj2Z7RRfhrzAbEPoPUxviGNBY8w?=
 =?us-ascii?Q?K2kqlWfr2+yt7Z1TcnL5Xey0NeoTvKb/hFDH8O5VjqtYZJXQUA70xHXL5DCf?=
 =?us-ascii?Q?iOw1fS3z/KrodY2ZCZWEm0SagBnHFgkFaGpJD/mgNwvJBU4/V31Yxejc68Ai?=
 =?us-ascii?Q?eBxhO3dxl3cgP7+0ZAwr8E31v12MqwIa1Si5MnSL/lowVxUao/yDBsCm4qE4?=
 =?us-ascii?Q?QdeZ9J4XPqXFq9fV619IbF2BxptOEqubPjW+bTYj6tWvINMQ5gywYSjeIsmz?=
 =?us-ascii?Q?hsfqbP4yuWewCP0H6mAOAo0bub2O7+PSO/0YNlBxZ5eFg53IRXUg8OmW8N9z?=
 =?us-ascii?Q?8Nmdnf+ro4i9A55ZemcWrX2a5AlPBomw0XdHWl3yodL5P9m01TGAX2pxJYqT?=
 =?us-ascii?Q?HNlSedeBm8BQmg/nKqfSXT7MzK6Q6tAw/5ZOwgjo/u+cXQfAry/DeI9gVloH?=
 =?us-ascii?Q?JP3bAbtOD2JhCYSIKjkUYQKn/RLLAKBrblt2ynb2wqy3KcXTCmYoqf7mXPIE?=
 =?us-ascii?Q?89jvN9GUfXsNJPm9ddzzBHcpV/Z7HPtbm+nakFP0o1f262wV0f8Erwv+woI8?=
 =?us-ascii?Q?iOPcJBziK0D+WRCJl219ZhWMfpTE92EteWPh0X9cN+X4ccI4SsUEjssZFd9R?=
 =?us-ascii?Q?5sMUiSc+icP3uA0dd31wgq8lWBCAqFOzSQgCeLLP5pSti+T2EUiR9z48JWqZ?=
 =?us-ascii?Q?R7r1ES5+HN9A+LC7E/ZFhYSZCyeR9gDIDe2jPXeSlGyP2LhYhjfum+d9dubC?=
 =?us-ascii?Q?RpJLWWgRXLC05E6HiN1HHXqxHWAatdIXMk/pSgRGY8f0i3y4l50LsBNOuD89?=
 =?us-ascii?Q?/9NEl7lA4Y0shTrtpsfZ2bkxpwFNxwEih8GCAcgMxmKAJb9iMTMRODfMqqTO?=
 =?us-ascii?Q?To/SqzTvzqBaEpysWOCL3CgtVzg0AAN5y2wM9EnmCcWOZH5ve3NwBXZsT80H?=
 =?us-ascii?Q?1iBPytBiuQGF1QPs0kF958d6M8Gt4qlba8VMW+CkcJgMPOFM8PT0FXvyfmgP?=
 =?us-ascii?Q?0lT7AKLjqjjvZmCFx/xP4HxxSByWm76HrWugzKF1dpevp6Ut9L4zhSFFbB9/?=
 =?us-ascii?Q?1ccihlXSjizsdf8sJ6BQxElepcIhzwkgCB8HlmJRNm04/EO7ViZAbk5yjsIy?=
 =?us-ascii?Q?Ib3jVQyaw2jmj0nmXgeSP6s6gzRdR77nJDZivRie+g+gJzgNmz3d5QaJZjGI?=
 =?us-ascii?Q?AB5RrIYf0EvJfpWZinoZRo6hloebhtQtDUgv8GOtKVvuPCG3fG3Fo2YeoL6P?=
 =?us-ascii?Q?TCrNVVyngwaiOLXbb1jly15sMRZfZNo4YkOWLigrSdoMCHsSCJwHKH9EH1o8?=
 =?us-ascii?Q?TMArWrZAFRILEhOyGgAbXj7cqEUwCvlbpKNVMLOyrWUACrbn+iPfhkvRE1JK?=
 =?us-ascii?Q?+bi489xMBnjjMAiIs0WkquXeOMeQX5KMkSQMwq7W8W2WEL8Au4A7sZ3el6gK?=
 =?us-ascii?Q?cKRfDnromFXeHA6UP6ITeLlrpc43muFX+ek7BWyPs0vi2aCXmrFeHdrFTGO6?=
 =?us-ascii?Q?sF/e5dqY76KJldg5t91FsEf6nLHE0FRo6M2Ef6bsYJ/Poa7rImJJeujztV4O?=
 =?us-ascii?Q?9DqkdeqPliPeS9mNhZU=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1f85461f-f930-4013-3712-08d997ebc3d9
X-MS-Exchange-CrossTenant-AuthSource: BL0PR12MB5506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2021 19:15:11.0777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uOWlaZTSJv/AYlfZ+UyGZmeGTnIInKUqKdj+/TZQV8+c4Nm6NwCvV9y7QfUhVXFM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5190
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 25, 2021 at 07:47:29PM +0100, Dr. David Alan Gilbert wrote:

> It may need some further refinement; for example in that quiesed state
> do counters still tick? will a NIC still respond to packets that don't
> get forwarded to the host?

At least for the mlx5 NIC the two states are 'able to issue outbound
DMA' and 'all internal memories and state are frozen and unchanging'.

The later means it should not respond/count/etc to network packets
either.

Roughly it is
 'able to mutate external state' / 'able to mutate internal state'

The invariant should be that successive calls to serialize the
internal state while frozen should return the same serialization.

We may find that migratable PCI functions must have some limited
functionality. Ie anything with a realtime compoment - for instance a
sync-ethernet clock synchronization control loop, may become
challenging to migrate without creating a serious functional
distortion.

Jason
