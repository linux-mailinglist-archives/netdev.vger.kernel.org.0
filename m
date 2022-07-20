Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1825B57B1FA
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 09:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbiGTHph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 03:45:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231868AbiGTHpg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 03:45:36 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2061.outbound.protection.outlook.com [40.107.220.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D1D20BEB
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 00:45:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bkuU9i1reIcqBRxQfosUHxIDbGgJhkZCFNIWGCKKS00HC4ypdO9tt5Gzvi8TQZCuXaFBAVUW8HBJ0caDjpZvNIjotNGxhY1Zj5I/dxADnokkGjndhCvYyyAhadBx5PRXiseOvQapQZOH/UyJAY26XcCc/+lZkQeMCRSCjEKxpy99nW+FFjVcwY3Q/RWx9MO/1NZzjS3KggNC255Fr6S1atszjzcsGh4qOwN5VtGkEH6Cmfw49305fYy8S6CS3apxqRRUthPnDsBkQ9JnixNu3zTNukYdZY5eS4g4zSvQ0zL4zKRu3eOKpekXiUK6zxVn6l+aY91b8yaEOxkm2PdgMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e27xhBsrJFiHbnr9QczfZ+CZXNRrW9A8aB6f2xnXjUw=;
 b=SVUr4q3E875XWfAhnUFCyVt9tkAf75vDkylGNLN8Szbljk+0xHQanLLwK2UPromAXEvT2Zr9PuY4lRRdpE6nNZsrI1UrOIEZnx7CBd8QkIDIEm0in0myPxnXA9BhlFEPa1xsLHYHhAZe8X3Bss9YFw3UHG/Q0/hawBm/8iUEvVHly7pn18MLXVuMYwo4td4DSgPYlUwE6r8GJbIGXiFSHonEnnzYXr62VNrWC/lZIq1hG5YFKLqiyqIjgkcOzGVr2VV4lzXIgA0gSe4GEUYa5J8lh8NkAEvfW+7GdJoyE39VVI/8pKP44JPIDo9qOlwZ+MJQIuQuOOQaXWVkDc/5tw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e27xhBsrJFiHbnr9QczfZ+CZXNRrW9A8aB6f2xnXjUw=;
 b=bQom3Ieyh2C0w4HN7L5S62Uv7n0o+tSyTHBi/m6SHPuazMuwsV9rnhwHTpgrEHPh0eQV5UX97QaSUZXZsVchm5eHjQ6oR/Kv6oYbsvmVqSini/5iSwLNVbO8Y9P5dgSpiG17wW7J/yZ0smDz4JMIkzFA5Ha0qKvay9zax7juQ6bsbzKwFHaIYSini/snVpi5Q6L2Lf+7XyVlnPyTV083B1SCgtL/dxSfu5NaAWbZQdtESi46Zw2C1OUTRgdFU++Ux7UlKnYXyzHOC7jAI0JzSDsAMYncsQFP8T4JHqDXsbmxMIE3bOeLaU2u64Y6ekqrJ5H/eHBge9haO7d83Rln7A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BN6PR12MB1857.namprd12.prod.outlook.com (2603:10b6:404:102::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Wed, 20 Jul
 2022 07:45:33 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5438.024; Wed, 20 Jul 2022
 07:45:32 +0000
Date:   Wed, 20 Jul 2022 10:45:26 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: Re: [patch net-next v2 01/12] net: devlink: make sure that
 devlink_try_get() works with valid pointer during xarray iteration
Message-ID: <YteyloM9mtRqCI0T@shredder>
References: <20220719064847.3688226-1-jiri@resnulli.us>
 <20220719064847.3688226-2-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719064847.3688226-2-jiri@resnulli.us>
X-ClientProxiedBy: VI1PR0701CA0029.eurprd07.prod.outlook.com
 (2603:10a6:800:90::15) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cb56d5c7-0f58-4138-e838-08da6a23d2cf
X-MS-TrafficTypeDiagnostic: BN6PR12MB1857:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tu4I92dhTsnhmOJO+VDfm4shF4S1hIYbqu5U9MnXN3mm69MY4Ozw4pAYwCiLRco1AJWS7dJ61hN7schXcWDcmM1uaPT4FJR//IrlDs+F3HNkgjUjC/zvojjcQyGPzRlb5N2ILAZ9+XHknGeyP57d8gt6QB5rwZAvMOWhUZtqKwZmiO7yJ3xlcqGfO32nwv5QXHUOaFy1O4AVvqj4E/6MkZASN0FQ++NEjC1ZCbrfUc0g4umMfiyrts40PP/bjrl85GXhMBCxuEAwlVHHT7gDWAdaWiaqDp/ri/MIPByNM1GwZcKoQQHC//eA3gS8YvP1bhlhIxJHS7Ci7YcurTuZZ7bnQUQY+fhNUuKo7NuO+VM8M5A/HBnEj+Mmg0XalfaJvLIhsOeeSKolurrYJ9Lbl3Rwq5+Td0FEYe3BBfmfXnnfsEUc+o8TKzAANPYA0iF1bT7WOBxP8bpiFTWMPmwFArOw+1iDrIGE3bmuVKzdqHULb+aZ1xOCEyKFVaK3dLE+wwLgFp28KN2ZNMbwGNteA7AQ/knBGToREolWvxcn7ld83ClLi2S1zl6svSLu1Be0nt+6OqsmsQXHw/PfjCNrqX/U3c7qZ/qnfG9HuQnr/ovvpxMaSM8MiVDHzw8Iq/f152RVc9jrG7zFAMFAlnLGBh+HMujhMNxtjw1DPmxFrE9fippd8JhEtYJdLo8ZXXSnw5sdW3iD+N6BPae0sEn5MBjRpqrDTRXTP/+9AxGiOcUwSdgTa32f/YHtCrKm9FFe
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(366004)(396003)(346002)(136003)(376002)(39860400002)(5660300002)(8936002)(83380400001)(478600001)(6916009)(186003)(316002)(41300700001)(86362001)(38100700002)(6506007)(33716001)(2906002)(6666004)(6486002)(26005)(9686003)(6512007)(66476007)(66556008)(66946007)(4326008)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GfZLRST8Nj2WcV22SqlKWCNCgvR76KJXk5LPVSvnm3JGMkWUYJAmchpDgCCR?=
 =?us-ascii?Q?022MnT7679El35/YU97M2JefWUqCOt/d9kU6NYXMgQjw0z8fMCHW0T9KojSw?=
 =?us-ascii?Q?Za7nbZS1LGv1PqbOWPTi/PlgZe4ikn6s+03LyXPs6WLz4E9CZvydmwkJwcMQ?=
 =?us-ascii?Q?BKrlb3ckunttwT/i615+HPr0HWyZ2WxWNI8VgpjkKfJKm4PU0HZBVO/IEyCe?=
 =?us-ascii?Q?3FytNC2WlFxKqtVTP0+bMYERRHaX79Au9OmoauEJHc6dU+1YmAeWj7G5q05g?=
 =?us-ascii?Q?TEhHsRG0ZVW8NwCC1OBJVH87A15szqd7ET55fDtmaYJkHcvYCQm9EJqEdM6S?=
 =?us-ascii?Q?Az/i5mRZPX7NCVfQbmYxS0+gTQtVcw7Eq/mCiubIH4D3SDrg01bU4UgtlJv4?=
 =?us-ascii?Q?F3kvQ2wCeD6UjUBgUj7gmDCzOPlgRT5CnPiAM2PIJ2++rJlVBaGqCJ8glac6?=
 =?us-ascii?Q?DAxt+pGqIEg9JTPt4AlT+ypZRlZm7KvbdfmKfJxsyi6vzi5loOWIzLmhlOeT?=
 =?us-ascii?Q?AKzvnMFi/QsDnWIiC3OQsyo1uCOWlaU0uhm6sQZ5wpalpOhtn/4X/QcIjxi1?=
 =?us-ascii?Q?Hkq2Rpil6G6hrsxZmbnPN7IY2i3J9pmbf0AUN6Q1/VOdvI/CS9ZA6LL6VHB8?=
 =?us-ascii?Q?zvPSRG8YUXhw4l75V/mhUwdx+/X4097XNLffbEGyKiB8NPEmgHl1omAf9vsr?=
 =?us-ascii?Q?uRoyM2laY0hX57ScdKbghxGJuqinjyRaQvOEcDD2KzCDgGmJzAWVsd6a/NAM?=
 =?us-ascii?Q?H9G8luRx+gt6vqiJ5dey+ZzaSZZfr6q7c7KPBO7cAvFN5W8o3KGDKzbRCCBZ?=
 =?us-ascii?Q?7yUzT+n+cEqWcU14oO+plg+uJFa6gnUXfBg4RYzzsiMikWS/9BacFfciAJCb?=
 =?us-ascii?Q?2cmHJx+WFtfo1urEElNnkJjzeSg3lsUDvz/XGSsMNP/g71k/lElFSgyIirp7?=
 =?us-ascii?Q?PqLGBmBXku41QJqLp6RX+PFRDtitoaKZu4AjtZl7WO8CIsdN2GseWC6cl0y5?=
 =?us-ascii?Q?5AhFG/GMJPYmRIKJn9qJ0zSIOoff02m/YPM2fjNrQp6I0htJnR8o7JSRCAYA?=
 =?us-ascii?Q?DE/Y3srOpQVTi/FoyltSQYPOFZP7kLPevOcMDfzC9TmKMee48t1/IY5LSDFw?=
 =?us-ascii?Q?TaC5TJiqJkcvjT4bOgLn0nU3/CaLAnwIqD06z4HWcKV+9NqGZsXloMEQ3akI?=
 =?us-ascii?Q?TOSLKDrwQ8QV5vAdmNzGG+r81F5Ag2nDrkH+d4eQB3uDaB94N3wIkSmigxCH?=
 =?us-ascii?Q?Mefov4cbgmx6EVWc1Z72bXBNUA57HZADO3d3UQKgvF7vwqMb275Vjy8F/KC9?=
 =?us-ascii?Q?0NqwUIa7d+4K7YdYZ2Yq6EMKNH5Iq2+h0DsWNpEOPQBk62hRW/O1bs+NP0qw?=
 =?us-ascii?Q?EKCk6oEboaI6UOBQGAuRcyfZynbXvserjSF1UyuHeWWwFr8uPi1cyziE+aVD?=
 =?us-ascii?Q?7vVA4IRTc0KeKBRc8J93s5iWanw5mnMTG36gsL+E4Me2bo2OfxrvBitc1fxb?=
 =?us-ascii?Q?FFRlIc6ITHOEMxWytFTwmoEBVIVlvtKG7QuLoT2p9XZCMn+5dYz0RZA9M8vX?=
 =?us-ascii?Q?RRD5TW6ce/MgaDSe5R/Fkj2lBZLOv2sf4Mah6Uv+?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb56d5c7-0f58-4138-e838-08da6a23d2cf
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 07:45:32.1149
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PVLAwsDpCIw3ASYUCzRFzS8vi2RvYGJwSroC5KXzfeA9dTDqjqCiiRR1xZl47dRWZIkHc2fkfzzf0oa8P7Qzyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1857
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 08:48:36AM +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Remove dependency on devlink_mutex during devlinks xarray iteration.

Missing motivation... Need to explain that devlink_mutex is held
throughout every user space command and that while issuing a reload and
registering / unregistering auxiliary devlink instances we will
deadlock on this mutex.

> 
> The devlinks xarray consistency is ensured by internally by xarray.

s/by//

> There is a reference taken when working with devlink using
> devlink_try_get(). But there is no guarantee that devlink pointer
> picked during xarray iteration is not freed before devlink_try_get()
> is called.
> 
> Make sure that devlink_try_get() works with valid pointer.
> Achieve it by:
> 1) Splitting devlink_put() so the completion is sent only
>    after grace period. Completion unblocks the devlink_unregister()
>    routine, which is followed-up by devlink_free()
> 2) Iterate the devlink xarray holding RCU read lock.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>
