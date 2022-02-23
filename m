Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C27DB4C09A4
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 03:49:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237270AbiBWCti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 21:49:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236893AbiBWCt2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 21:49:28 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2052.outbound.protection.outlook.com [40.107.94.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A3256764;
        Tue, 22 Feb 2022 18:47:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GiIVDDjqO1FvTZvUKwA+MYSp9lsWVRXgcaCq2W21hB7R8iSx19fXl8slNin12BOT4oPSHp3MuZUAkfOIJovIPqnZPTop4LfsEj7DXDf/S33IP5NPxwZel06b8+loN4H/myIoHmfScJj/5pt07TISrddXfh5NBZS/lWY3uTs3k1EZu86ERg2WS0Sikss8WL3Lhm4fj6qgVAl35mjn+u5WMzI9X2aw+LvfbzkE68JsPk9aLgaaqdOx9ywctdAQ/d8LXWaPRqyHTiWF5vTDDONtED7CIsNQvEv9iaIHwhI8YKgDCbKJvQq1fb4OhjOb+hQ0nL8s+Z7G+ym1WK5z8KLL8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1lcxFAHn07CfLt2270Ppsty0k29DH84mDUiCfv7V2Dg=;
 b=NC/TnA5G5F5LzRNgPrVNoZGYqyUp8+LBUFWVK8ywp7SO67eVRgNk3G5bavzTtG4V2YaTiZDSemE5iLMNyNr+Kspret7sqZ25+PL7Nhgl0vDEoZwQNkFjPg3AN84gOsR/rvM8w8tWLkB6cJKe+yfX81k/sM+yT/IlLor38raTuEXgPlRl0UUwAvRGXMGWXxl1tbZcHkEG8hgYXvszmchPxwOz5cyDyZ9DRaONAEEkEa2B14/BdHGS8Z8g8lcquWZ8fgnk2Xo6PSuXaoPGRGjZVL4Wn7bBqU9mr8gK+30mzybBWl9xaxoHN0WSdVZEyC2lpetQOb4bRjk3UQXf5LXKMQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1lcxFAHn07CfLt2270Ppsty0k29DH84mDUiCfv7V2Dg=;
 b=a/9Eigx82LGPl6TRQ9pP094S/1X8sTbRt5gB9HfEyiumcJR5GpmN49CLO0FiS9PCtUMvDJpjDr5s5K1HuUTVvnVHRkZQuZBF73JPzwPJcJP8VUyynhiz+tNImRZ2Z1ZKFNEhTEUoeM9VKeeRPCHlPQmXBj/jDSch3zGE98iLU4oAPNFLMx/u6koQuDyIc9fbeXYIydMhwM80lgKyZO6zgpOQiuJHPaAX6urKIZ76TplEbohpPzI9SQc4IEUcsTVM522HzukG92n1e8l/WOFfi7GzM20ZXGgdu5lHRn3I2l9BiwmiIH5xqHyh0LaASQnYEWYuCzDA8SZX3yF3NQ6FrQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by DM6PR12MB4124.namprd12.prod.outlook.com (2603:10b6:5:221::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Wed, 23 Feb
 2022 02:47:37 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::e8f4:9793:da37:1bd3%4]) with mapi id 15.20.5017.022; Wed, 23 Feb 2022
 02:47:37 +0000
Date:   Tue, 22 Feb 2022 22:47:35 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Alex Williamson <alex.williamson@redhat.com>
Cc:     Yishai Hadas <yishaih@nvidia.com>, bhelgaas@google.com,
        saeedm@nvidia.com, linux-pci@vger.kernel.org, kvm@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, leonro@nvidia.com,
        kwankhede@nvidia.com, mgurtovoy@nvidia.com, maorg@nvidia.com,
        cohuck@redhat.com, ashok.raj@intel.com, kevin.tian@intel.com,
        shameerali.kolothum.thodi@huawei.com
Subject: Re: [PATCH V8 mlx5-next 09/15] vfio: Define device migration
 protocol v2
Message-ID: <20220223024735.GL10061@nvidia.com>
References: <20220220095716.153757-1-yishaih@nvidia.com>
 <20220220095716.153757-10-yishaih@nvidia.com>
 <20220222165300.4a8dd044.alex.williamson@redhat.com>
 <20220223002136.GG10061@nvidia.com>
 <20220222180934.72400d6a.alex.williamson@redhat.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220222180934.72400d6a.alex.williamson@redhat.com>
X-ClientProxiedBy: BL1PR13CA0104.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::19) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e425623e-3267-4267-820d-08d9f676d9b9
X-MS-TrafficTypeDiagnostic: DM6PR12MB4124:EE_
X-Microsoft-Antispam-PRVS: <DM6PR12MB412493DB66F5D297B7EC677EC23C9@DM6PR12MB4124.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TdGELz4ixQ79KaFgEfYiyks88qsxmWDiBBo0t+iUHcM07kQLDQe+2JSq9IbFE6p06MwkFQ+l+eEG9CG0Wj5sjrcJbgdunXcZdbCSZxLy6xLF+pSC/mzSawtel3xJzWUW/4RPLj0KE3DMq6e9xPY+UQJF7ZdymhJtZxOpJ+5/f8AobghAE7ZF1pKYWkPfRxKKuxlyz8Bko7aHGp3sLFLIHl8I2gM24AwunZFLfWv1Ja4Wq+FVT58U/c/78V3NVXiQBao2DMfIuoIf2FuprBuRhmITEOTZggS31uL48+2J9c91BO9Eo1vIqeP1jLbxMUO+wWmgSGjOAQzfTxAPRfWWPYU++bs78Zt1tvidljwjpofyzfjnJYL6z5rms2L4q4ejs76FPtGhFA4qDCZfI6dVOaNzLYTPGa+ku+rqNzjT2+vZBG8X5eQcG8n7kgvD36ymvg0qXtP+y4qGDcnXyHKSLqBZT7SOTbrWd2BJKMlufW4jqkSUHlRlnFZKgT0fWlba5j0bmpNokpVKvcRbLA1SO67fPunAvo1LMcrZnDrqVEp19hgtx2GsG9CI99Ljjbs3XEP6WklsFnOcjubLQPbj3KX2LIbbC1H7V6VgXafBXibqccbVTOMgzPz+MRVm3Kt3h4UMV1uDwGWdukLGWnBW9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(38100700002)(86362001)(6916009)(66946007)(6512007)(6506007)(6486002)(508600001)(33656002)(5660300002)(4326008)(8676002)(4744005)(8936002)(7416002)(26005)(186003)(66556008)(66476007)(2616005)(316002)(36756003)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ox1HP6dXDJXQiv7WDxz+HwdvZQB1WvA+WREep7NM8qf89Hp+sidLAfW+bXwc?=
 =?us-ascii?Q?UhfiqyvCH9n58qfU0vMF47zJq/RcTr8juC2sNwRZ0QkyjnXsUMWuFZt0ztah?=
 =?us-ascii?Q?hz4wh+gbT75gbJpPIpcRtl29UFlxLZF9OrIrytDiOZ3RMga9NXO5n3MNjYUo?=
 =?us-ascii?Q?78gpqRR18sa4ajB+/LqEO5oazK6vDtK5dPMp9gw7Jn8LK03s0lo7HCtrSqJd?=
 =?us-ascii?Q?oqlta76AProcWDD3AiMVBk1kHHg7LyB1sDzHobq9n+U3DPz8bW8nd33qldcU?=
 =?us-ascii?Q?we7fYSQIF0QuOY/rK6TDHVeBC41O9WPosl/nYxC7GFkaRnu4k9r79ljgFjz/?=
 =?us-ascii?Q?snyflTohPw4I8f5sV918xUCWJSaMoOZIYymmDBkxqyNvjCxctyh727Om5tgG?=
 =?us-ascii?Q?19xAHTWs75PTkNav+vdFTzjVtwNmqwBp6Zmz3TJTifV/hddgcE7jU8zB/EFZ?=
 =?us-ascii?Q?BsubSEwOTPjxqHMT95KU3u26boLhaEpm7gNy8/4zzlNQj3FJuWDBqU1gxN0Q?=
 =?us-ascii?Q?lfBo6OYQWwjNxhRoggaLZZPVss+fpfZYSgLw5ptIVhbffZit/gQSQZX71+ob?=
 =?us-ascii?Q?/lQ6vevCy2ILOnNWcMiOcf8rOWV5E0mrPcALRH6hhawRYRTjaSNgRC3J3ubE?=
 =?us-ascii?Q?GUHL+U2hDPG3eE5+zdF7hyoEGyL8Qx6JalivsYbuCw7xZf5B/rlwiJXPK/vm?=
 =?us-ascii?Q?qKPoTkvwB/6I93PPFadIlV0c+HrTAsHRowZTpvHH6grj7gC/MJBpSLKq/VGa?=
 =?us-ascii?Q?yXoTxhWXJzd/Z/XOE3hfPNGLPHYIaK5ZeqRh23DddQdLzpiQaaJGnYzMEXkF?=
 =?us-ascii?Q?Z/5a21rGg/C7RMERl9sz7iCRjnvJi12UMxzw1wlKDNV0fLDM1T2eOkhs4iuX?=
 =?us-ascii?Q?9zlzXZF4sGUz+LuCJsStv1uf8cOZgz5rmexU7/twkbVhSyWrkeXQRO93OLML?=
 =?us-ascii?Q?YqEZ4M/hm+KEMitn+c0+EjHr8RoNBbcUqnpBSrRZKAMP+jmGocpdrx/uRRhW?=
 =?us-ascii?Q?TRU2lKvkNvpIhHpcg4Ill7b3PGOTRx0GFnBvkmxWxUw4YrczYLk12Wv07cHl?=
 =?us-ascii?Q?EWOeTbQEn4d//+GkAzNKp0wV/y71f0iiUUvoVKCO/f5XgloKZjlLgaPDgvCF?=
 =?us-ascii?Q?wkyAG9g8VVdSjouVUqSM1XQPJXQpazi1FP0DQ8KG+PDNOp0Z1dpnMmqNtZy2?=
 =?us-ascii?Q?nvAguJpggLDoqGzbYBuSds2Nbi9gSKqK9LfufQ18yZ2qd3VXhra+p0RD6GY2?=
 =?us-ascii?Q?6+6ogewhYAQxPEqLHD9fZNbRz23enCRJSNQMDYkaNQrVLbQtlEMtytTQP8bV?=
 =?us-ascii?Q?eKYjD57TaPyL6uHchqIZ2IDl75hQqYOiC+hQRA9XH6rNss4oHhwPNYa+gZBi?=
 =?us-ascii?Q?IlL91Dw5QdhV79/60zNkQYsLRaYAf7IDK3LUjpnnpP1VPYqirQ56WTvZ9Kos?=
 =?us-ascii?Q?C64/5O+4F3APo7fL5x99eyizo6ybqOC7qVXkFqYyDZyBIEd0tXWAyzP1codI?=
 =?us-ascii?Q?1RIGBeU7BJUAnILIJfHI3VhqxE3bJsw0MIY4q9MckFsyCCRNF4bxkxuCjmoF?=
 =?us-ascii?Q?JuyN+alEjTk1YovtssE=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e425623e-3267-4267-820d-08d9f676d9b9
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 02:47:37.0585
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7e6mi+kc8gNX3X+2FgbzaZ/u7F37TTKjKEnKDqZFB6RgjGbY0xYYA6yGd9jvCTKD
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4124
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 22, 2022 at 06:09:34PM -0700, Alex Williamson wrote:

> So if/when we were to support this, we might use a different SET_STATE
> feature ioctl that allows the user to specify a deadline and we'd use
> feature probing or a flag on the migration feature for userspace to
> discover this?  I'd be ok with that, I just want to make sure we have
> agreeable options to support it.  Thanks,

I think we'd just make the set_state struct longer and add a cap flag
for deadline?

Jason
