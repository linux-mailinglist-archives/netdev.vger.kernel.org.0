Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C34304ADECC
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 18:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242895AbiBHRAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 12:00:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234257AbiBHRAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 12:00:09 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2088.outbound.protection.outlook.com [40.107.93.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8981BC061578;
        Tue,  8 Feb 2022 09:00:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kcdR3kO6oJ7UGuPUekdvOWcB7EOimbjzZB63/j8sRu3v5uzlrx9rGyHvcZFiewjXGNNzR0C+OC2/RhoNgT1Vt/86B9hQj/+UM1A0dqGm7iwNwik4HvU9jFfFsezaednFv/Lq72eF4LdvPYzlCZjVL34HYu3UJlojpB6WDFk7l7XltAO2Ah3BQNMMf8h8qoKxL1hzHMGT9n0bCFPReAQ0qbB8QC3wjVXpp3wVHXiSRrx5uVZhcB4CmjlrO9nicbGfVi/V5MZaZzddF2KHIReShWM3hcNGFBA7Mi1eYUVGRaAFEm38V6QY2N3nIbRqZcwByITTND66paYtvREP+R1XDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MQMQn/eQGuJWTQhMfLA7XnuxvhGSTcDJq4fouJ7AofM=;
 b=BxzZesfVNPC6ayzqi2GOgI0ZnkG64iS7w+7bV8DpndkuSWMEyYxnbdaELxbQCbPiRE6+cKbP+69I9+HbGXN3Iy+Kf26GaVzPHBNzPnSZcj7qm8wTl6bKPc9LN7UC6MgJHwpZTQV+JPtoS92nvhKnEYie7PyPv/B2pHI0+CWR7De0flplwNoqh+h8hn7VnhLrg+8HBGxCA0tKDUpDxepDfVTYDXfvcmjsdfzS35V3wz+4p7Na44zlIRnaxi4p6ZyI0flPrXCAM/yWm6WBgnrFSt1E7njCaKr1ySbYMUQCci6tP+8YtFJYFNS82Bo1U1el+jZmvOlRTcZWxg29KS3LMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MQMQn/eQGuJWTQhMfLA7XnuxvhGSTcDJq4fouJ7AofM=;
 b=Zd11XStKv2S6ORC328bQGD4HdA6Iu++Om0b8WndsFlulgtIASORHHQ7kgjaI/QDreDsUYhA5VtXfcZmzQFCgywYqjJ0fjvNTGnqenMY1jTQ5ui1jHk32T55m+CwwZ7aegcha7VGqFJXmht0hEVaNe43XvZzdEP4EkwuQqispumxKBJzaXNL2g+NV8XcJcPU32QH1jwZLWogVlP7CD+dGsDG0PhxbgK9LlPCQdVuLx2WWU68QLPJHgvR7mE2abIePXRUK9Kgw2YiFKsPzb3wfxaXV1b2JPD/coDEH/qL7pmDl82g8s2gK41mEUFTAZWaFJ5YPFXMSIhjrp8GOsrnmGg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by MN2PR12MB2975.namprd12.prod.outlook.com (2603:10b6:208:ce::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.16; Tue, 8 Feb
 2022 17:00:02 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.4975.011; Tue, 8 Feb 2022
 17:00:01 +0000
Date:   Tue, 8 Feb 2022 13:00:00 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        david.m.ertman@intel.com, shiraz.saleem@intel.com,
        mustafa.ismail@intel.com, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next 0/1] [pull request] iwl-next Intel Wired LAN
 Driver Updates 2022-02-07
Message-ID: <20220208170000.GA180855@nvidia.com>
References: <20220207235921.1303522-1-anthony.l.nguyen@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220207235921.1303522-1-anthony.l.nguyen@intel.com>
X-ClientProxiedBy: MN2PR01CA0058.prod.exchangelabs.com (2603:10b6:208:23f::27)
 To MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fbd3e7d5-858f-4df0-f24d-08d9eb2471de
X-MS-TrafficTypeDiagnostic: MN2PR12MB2975:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB2975755489267625EE0A0187C22D9@MN2PR12MB2975.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GuNK5G8QHrObZL9uBz7vmaKgyVaU7/XaeNRnzHwY9lxEzXOseO3cV/BvH4v2x56/watkvdCnj0G0LgSvpiC9ZW3xVVr1GIore1CtFK9S8rPV1EBiIBj7VtNh8wX2lyGtFKtIulUDu7Zv5yA4Z8QHIW+CruWG6sAap26kgTpIWXTe5D5CTrLI+6z8tO6Mbkum3Bn9dE4M7w5Z2M4EJrdmqV7Q4ZelGScFgMFGZA3pE0p6Tk2qjrEfEbWQwKIU0gH9xDdYvSRcV5Yq0C6acH4AqQBzubfQppm3pBXOLtQWGAJFEPV8fRfApecZj+WpoG2rgbMYG+cIfT25f+3nVGMrLfC/W0Cqi+wUhkvwUScEkbxqfUuWGgm344Bo0dAP2wseHE3UKArd1DY8A1cio/7a/kqZodzgPDEZ3X7QAQlu020RMOHpME/NYZWdT/O+lBGlGcnKiFLo+ZlhsI1hgnRQJv3shmEypRB2fKZ6DMDAGF1zg4o4ksxjDENVCW01Yj0mSmYmTFGHT8VlCuRb2b3+xLMUYNcok4fhSwG1QVV2UFTTa9ksHaSVcszfSuuuXylpJOv/+DuLflU26FRFsWE9s5KE5QzvKVVn4IxcW2DvQYMAICq8y+TjEv5yy7xrgonVzn5b0BlMWaevu6Kcu5H2XFKFr928rbKuHj4XlEjQhBZnBPaBTjtEPZJhPjowYq3iK4b4x4f4FF34JRu9Co/rA2gK1TNiOfigLGvMQX4t9f6xZ+ENk3VgMUfGMM71+Ag68IBv7j+ABxdYQGq5Og1gfH4YbNHhHCpZPk/Ej6Ak2ZE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(4744005)(6916009)(2906002)(2616005)(316002)(36756003)(4326008)(8676002)(66556008)(66476007)(66946007)(8936002)(6506007)(33656002)(6512007)(38100700002)(86362001)(508600001)(6486002)(83380400001)(966005)(186003)(1076003)(26005)(27376004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?103KNdmUhvLh5kmTawiCnd4RQCI4XVVQw0wIWVyv5qxYEBFKDaN1w0AdMBKy?=
 =?us-ascii?Q?5tTJ+i7CoI3tZjQ6aCQQdDYPSM1GHGjq6XgI7pN0zqLUdcJSS4RSX7TpFJ7W?=
 =?us-ascii?Q?CYjrSKk5TcAYwGthORZVBJKOVzzVhvvSRXu39jAczKQs/5YYHv9pNYhdBVxi?=
 =?us-ascii?Q?iEL4Log2Kqjsz3G2iLFtwjWSLzKuM7tcqKcp86ztFzYPNY2zrcpdpjoOE8jM?=
 =?us-ascii?Q?UgT2QLGieZduXZvBmvu98ptalLYX+2f49OtuJgjnQ8ysDImJ30LJCPXi5CcS?=
 =?us-ascii?Q?YNzgTMedi5dtWXcdxF6jBXoz+qM02L0+Raz9SnGuCujMNT8Gmeda6ORP9ASY?=
 =?us-ascii?Q?sc3McfqLzWlde/W87AO3CPaqYN1/4DkjAXwwkJZFdxoRu7v86PMlUMwfOXHI?=
 =?us-ascii?Q?Xw1moQxtC2NZQ9vex78CUvZjD3QwaDkD2ff2sp/ake3OWzk+dJgwmixmRfNs?=
 =?us-ascii?Q?rXBVUvtLkvjALpL6XZ8UetmyKbaT8iDZE1/24/Gi9ZfNqGkhJEnXBM88+L8r?=
 =?us-ascii?Q?EqfOr4/Xs4xMyHzE+zPVw+AupY2AHjMM/oHl6NB1yFolZV9peAFd6T4w3M3x?=
 =?us-ascii?Q?G8hgsKuZZeIvLKimnYeiJemWSwbDYIA65xOzl6ii2xrbAathnSnUEovkcVxt?=
 =?us-ascii?Q?L1LQOexJTdV1TTrJMIJs5Ww3lnZxvjQBmfBB5lgTqk4GyDdla4DnYO1DEjuw?=
 =?us-ascii?Q?HMGYjmsr5W2Lyx+19HlyEPWlp/2P5xGbdXn96MrilcR1qA7+0l8K1ZFRIv08?=
 =?us-ascii?Q?fTsYq4V2XNGk5GOOMww6jyx8LtRvPdEI9yKmbC5Er1lqr5YGSnVNU2B9bQSF?=
 =?us-ascii?Q?mwkHHod+GQsY7PuwuXEfywk6+fEmEKOz310TNXJWl/Cm5DtjjUUVEjOmdS3k?=
 =?us-ascii?Q?+Pc+n6tfuj70DV30/nwkRiuE7iaqy8iF6iW25a8zbw2dBPzKBiFvGys7i8v6?=
 =?us-ascii?Q?GbH7gDjJ/bh3/6lGlsS2FM64kB3YiKmRSLoCOBz6MF1S8s0T9O3XqEXiXr8x?=
 =?us-ascii?Q?fTyWCzLIkpMEb1NttbYATgmbfewExi55R1VoDwTPLQwG6Ky0wrIwOXviz9xa?=
 =?us-ascii?Q?p2/6IxmRRElMJ0J0fzZxklSGC+gJVDXgOshqhBbGFGQpFTc1gUP67w5Ba2cE?=
 =?us-ascii?Q?Nm1tUmEuTsio/AamvQqgppzd8kAzWFAGvVkszA60gC6fU2+D+CMngKtiI1Po?=
 =?us-ascii?Q?xgLXPET3qtqEySsN6YFbwUSG2cw2CZVBMeRpsLOiSAMueP1Qpwk7COWwZqKZ?=
 =?us-ascii?Q?j+vDlh6e8Fe9jt+DcbZHi5jFTTidEup3zIqY23gxNFooLMOiP052UrpgcesZ?=
 =?us-ascii?Q?WhI4TQT7oGiLIBtLdZtyQC1k7Jd4MJxIFEcUrvKDZqHhbW0LEpnD7Twyl+Xj?=
 =?us-ascii?Q?jTFTumtu7zljP67cX5RC4mu1ulGijDK4SVaW9FQQHLUSr4Gj4JgdYoEpVQ45?=
 =?us-ascii?Q?daLCM5jWRc+mm4g3OeklH0sD+eDUvezUMa3OtMMfKuOVb6VRmLUG1NOjcy07?=
 =?us-ascii?Q?feLyA6goD+b2JtrrFosT0i4tyYD98/Z4+ClqURGGg3Za2box+/A/PIL9VtLQ?=
 =?us-ascii?Q?FBA20UKhEKRJQijwzBk=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fbd3e7d5-858f-4df0-f24d-08d9eb2471de
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 17:00:01.4078
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VnIeBIdQzUvhqjTqMzkqt3ODsVODMAMEY57ll8R8dWrc+b75hpm5uFNNaf9BJyn3
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2975
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 07, 2022 at 03:59:20PM -0800, Tony Nguyen wrote:
> This pull request is targeting net-next and rdma-next branches. RDMA
> patches will be sent to RDMA tree following acceptance of this shared
> pull request. These patches have been reviewed by netdev and RDMA
> mailing lists[1].
> 
> Dave adds support for ice driver to provide DSCP QoS mappings to irdma
> driver.
> 
> [1] https://lore.kernel.org/netdev/20220202191921.1638-1-shiraz.saleem@intel.com/
> The following are changes since commit e783362eb54cd99b2cac8b3a9aeac942e6f6ac07:
>   Linux 5.17-rc1
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/linux iwl-next

No signed tag?

In future can you send these in the standard form so patchworks will
pick them up?

Also please add cover letters so there is something to put in the
merge

But PR applied along with the matching two RDMA patches.

Thanks,
Jason
