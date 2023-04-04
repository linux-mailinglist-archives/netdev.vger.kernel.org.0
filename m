Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C6856D5857
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 08:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233513AbjDDGB0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 02:01:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233483AbjDDGBZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 02:01:25 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2075.outbound.protection.outlook.com [40.107.244.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0D8E1992
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 23:01:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N++CFMIPoNkaEbLElv+tT1xi8rhDuZtWPqv5uwEFbUnEkGlOcGEgzOPTX5M11LYhpYOHy4Yny4gaFVaAK4xxBebG+N9WgEtb5Wnw0eyHE22jmJ70wa2hTMBcQOgPhFPcj7eGQO69P8Lfea4i678f4GJgfSqb8Cg3TJ3Y5nMX6Eni4a7pzFHFFJjzI5TzawmTPLdQj6HEvEE2BmA4pcsJGsnmR7CNW87TOrXXpBno16ONMSJnecr0oL/PkWppICb7Y8aRczDnQi+Xw91Ml/GI/SbGeQzKHDlj+7nMn3dOfEPNVMV6bE12+mM3JzjxAv94LPZLwAF1X/7r+m3Z4VJ+Kg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mwwVmWhd15WvXFSUNlMw3zL9/lqwIWaVIaBb7S2rhJQ=;
 b=MywWEeXM7B1YhI5mkKhvhcdG/MVVFimZ06mmhRzcOwxDiuiYwdlAaVIrwxtpa7FMVYBEOgSJGO6W/AVZi2xVYhH7siVsWSRIHk64bONCG9xCrrPWCS3PzA5vvbvik7OqfoUwn1pr58RiGP001T9TciFxn1kzfRUWVWvVkQ2PrYLvjpPBnuN5ZGog89crUXc066bj5owM9etKvuA6NJNh3+NI0nAK1q+OPF4a6dgGcN/ajYIhoHb3C5mCNrwL2SabLyZ1Ufv2KqBd+XZ7qu/bwWpBgGCgMaFoJ7url5XxbUYmf5gzj7KkPMppWg15CiS8cqq3Btmx6w/+SEsQZf/Cww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mwwVmWhd15WvXFSUNlMw3zL9/lqwIWaVIaBb7S2rhJQ=;
 b=ALOF9nGdbCQ5m/+u3iN4H99ijWX10J0hwUcR+v226dtAV/PoWreURaklSxE5VBsJrimUBt9FinurK8GMgeepH6eq81qt1mUVSb1V+36tM1PiuPa20yjXkY2hFxoZYIO5RfbjfXgzDOOeo2uDCaHRaFHxY2nv1rmZfI+/TyIKAiM3/UnEt5aBxVEXq9bzMdVDnkHUWl+uxKPT26q6ahF4ufTehKygwiKXRiKlAh9VZ/uC1xcOuCC8GMoIhJCoQu3yyZlfk3+DqDAUN4pT9vcKiRekXB1VJ3NtGO64qmMvit/ssQCbrujvEp02OlNtyIMpE6W3KotBuafh6EGeJ9dDvQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by PH7PR12MB7890.namprd12.prod.outlook.com (2603:10b6:510:268::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Tue, 4 Apr
 2023 06:01:21 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%5]) with mapi id 15.20.6254.033; Tue, 4 Apr 2023
 06:01:20 +0000
Date:   Tue, 4 Apr 2023 09:01:13 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Andy Roulin <aroulin@nvidia.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, andrew@lunn.ch, f.fainelli@gmail.com,
        mkubecek@suse.cz, mlxsw@nvidia.com,
        Danielle Ratson <danieller@nvidia.com>
Subject: Re: [PATCH net v2] ethtool: reset #lanes when lanes is omitted
Message-ID: <ZCu9Kf1eokdh0w/7@shredder>
References: <ac238d6b-8726-8156-3810-6471291dbc7f@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac238d6b-8726-8156-3810-6471291dbc7f@nvidia.com>
X-ClientProxiedBy: VI1PR0102CA0042.eurprd01.prod.exchangelabs.com
 (2603:10a6:803::19) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|PH7PR12MB7890:EE_
X-MS-Office365-Filtering-Correlation-Id: b4a21599-e982-495c-6b89-08db34d202f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bsYflU4rgzUPQVA9L0rpdNEHdRriYVUt9A/TD35nvQVRVkPv+veyzeZ9JZnp3qXlxu6V8w/fEZJwwruIkn7toCYSzJDdgCLcYTijmYMPa1vCrcoNdIU2p98ZijkvMTf629ij7Oj4+o0Cy3rFpOQVeQfcYC5xDFXTKulFTsS70o8w4JXYWAtg0DZ/58IvaZcZe1wkjfIKSOyZS2rTd86W8r+obw6FHcYeNmolB79AJ9Lm+qAXeeNoD9j8CfW3unJ+IQA4QcMoHJIJDCE5uSheNHaA8Yh/rqz6vppjycj8DW2rWCl9f8+Q7XszGxERpoQbmnQyNREmAE7oxQCkqt/KvijE3fNaS8328PJwD2Z3sMfDUn+kJ34xSeafTlACssdY1WoHWkDnWCwv9IwnsZzd8li80O3fLIx+9oWI7GD0d3WmLnwTsTo0pR46rR2CUEtXl7oBVqwb2FL0Bl6HbKKnXfOT6Z9Kg01DkmuUPuZLf1XIwcuGUdBShu+xSDb3HsXvmbKfP+r2JyBmexjLiCq7/oYOmnEwtQG1+/ox57t8NcmZKl6ZXaYSjzRjtJfkzHM+
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(39860400002)(346002)(396003)(136003)(366004)(376002)(451199021)(186003)(33716001)(6666004)(26005)(107886003)(6506007)(4326008)(41300700001)(66946007)(6512007)(478600001)(66476007)(6636002)(316002)(8676002)(38100700002)(66556008)(6486002)(86362001)(5660300002)(6862004)(2906002)(9686003)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CD9wfjDlGQWgL6dVyOnXdx5OuIl/FwHbBEPskf+/3M6z4gKCzo1e9CFVcRiS?=
 =?us-ascii?Q?x/xjehvfHj6aGPjBOcsCK5IgMfDkKK1VFlL7Zj4EOXSuHzTg8ZBtsuHeTb9o?=
 =?us-ascii?Q?iMTSFZy3pbH8eYL7TI/vtryIZzzVcZxLHKwbZ8C72x1FnjWW0CF49p1oriQ3?=
 =?us-ascii?Q?pQHTZuSuZqZYyT5Bsk0t7iY9N2WUF3bAKJpkjdHNHWcixN67aV+Y0dmkP2UP?=
 =?us-ascii?Q?3ImWYXOPAYssiHN4ht33ByAIUgR6Yyk5ngpFU8wN4a2+Z8fus4CN4LbrJBs7?=
 =?us-ascii?Q?nE4U/yhghE5hn1n48xabu2Dbenb6x53JQRlu92xJjSaP0by+7/LjETJyVc2t?=
 =?us-ascii?Q?WAmKCXxLan9hucX3LF/C8pcTu+TKHMMwwGCWd0WMmv7SKpdKLJDlIUGssN4E?=
 =?us-ascii?Q?2Kr3naJZSGEpoA9w+jGnD+62cPGfPOVXD0+EtgzmgBxxSgqAJ9THf+Hr3N/Q?=
 =?us-ascii?Q?zZqnEmbDsjBaYwhCAetKWih3qcabk/9ExFSE2FiVc1lTBM3S+hZ4yPKto0EE?=
 =?us-ascii?Q?OKA89EMCnP5B4/vDHuT2JfWr4ob2Gy+Wza2yAiXVxQ5yW3XlYN0xO2eQ5LVA?=
 =?us-ascii?Q?vxoRvSoH7Re9+QEjaRQRwqXZOqguDdsU5BWH3ExXZ01GrE76k16SPRRkxlh7?=
 =?us-ascii?Q?fjfn7ZBvlo3xqp6qnH5xxM+o3kPgyGQyE9Advx3WX5bHsIfYJRi2IObsdX3v?=
 =?us-ascii?Q?gwqHYxjUNMDAhXJgVHD11fSMQMEnIGrZyPsdPqGJI7uOYePPG483lPX3B51E?=
 =?us-ascii?Q?Fgk5WaThmVBYMDl6Fjw7WQ2uO9ysPNQAUCgbXJCkHc+WWgrlQPLZL/s878B8?=
 =?us-ascii?Q?htADVFVlGgZywr8KkyKz2qiLOWkJS+lK8YH+tx6GzQb2BMgjVPb1svbSrse6?=
 =?us-ascii?Q?bzVdadMM68scpITziZCF2nfqYPFiDGpUkJzETUd1y5MufJYoL9CSg+u5kPEm?=
 =?us-ascii?Q?QW3Mj5Wxi3gcNWeUtKjd6L3/oBHqdBMMWI0g4R360YuO52CxyV10ypNT4oUH?=
 =?us-ascii?Q?mtcSpgvsOPLmGSTF9T9MFNyEGM3EcXy1MMAZN5nWCb0FDbhzEs5B3fNHAxMi?=
 =?us-ascii?Q?mzga3ch/oySFgXG50ndLZ6TM4DvzXQ572nzFPns531D3H7eyQOv7B5pZvu22?=
 =?us-ascii?Q?GtCj6pwhGoFmH1Vi3nNdGyQn6JEiMxBDGW24CiPlcLklZBt5Rq0JC4fK/Wlx?=
 =?us-ascii?Q?5m5qkdxHmLLhlwpsGOa6KXxhDn4IykLspcdoEpT3sP3c4CfA0EFLmJAfh8b6?=
 =?us-ascii?Q?QV7OF5rQhigGN+HcBoct1veUemiy7+vww17pNc1626vWhOdXn6qK1DKb0t48?=
 =?us-ascii?Q?2bsfDKwU6jTiKWnyySHf8xagdN/e2gBrDSeRpGGg4rWkv0eHTIVK5Y2kas8t?=
 =?us-ascii?Q?LfsP+v7fV1mJ07vWZGSIgBGpgJC0d9XFZsvVtnZDxI0LYsE/JtHnXP32WRoX?=
 =?us-ascii?Q?p2/Ui+efM8BYaZZxOQmK14mOYkWZN0YXhL0REtdAAMW70rwSd4BE7syvabDD?=
 =?us-ascii?Q?o8EmOII2eOdtj/RHZoG1yP4Q4tSPxwwFgHWv5EJt7CHBfmRkRTXSbIllSTpO?=
 =?us-ascii?Q?QGEqzcb7ycz6ZuyfOZCa5EVYaYjAq0rAF6H56r3y?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4a21599-e982-495c-6b89-08db34d202f8
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2023 06:01:20.2680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cx9c7O4HKl7H4aIj2/ImKMVVUqMRSUWRLVmOdlhN2bGuXcXDDOub8VLAxrC0B9+SjHEnZDRkfW5H0UEogHAsqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7890
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 03, 2023 at 02:20:53PM -0700, Andy Roulin wrote:
> If the number of lanes was forced and then subsequently the user
> omits this parameter, the ksettings->lanes is reset. The driver
> should then reset the number of lanes to the device's default
> for the specified speed.
> 
> However, although the ksettings->lanes is set to 0, the mod variable
> is not set to true to indicate the driver and userspace should be
> notified of the changes.
> 
> The consequence is that the same ethtool operation will produce
> different results based on the initial state.
> 
> If the initial state is:
> $ ethtool swp1 | grep -A 3 'Speed: '
>         Speed: 500000Mb/s
>         Lanes: 2
>         Duplex: Full
>         Auto-negotiation: on
> 
> then executing 'ethtool -s swp1 speed 50000 autoneg off' will yield:
> $ ethtool swp1 | grep -A 3 'Speed: '
>         Speed: 500000Mb/s
>         Lanes: 2
>         Duplex: Full
>         Auto-negotiation: off
> 
> While if the initial state is:
> $ ethtool swp1 | grep -A 3 'Speed: '
>         Speed: 500000Mb/s
>         Lanes: 1
>         Duplex: Full
>         Auto-negotiation: off
> 
> executing the same 'ethtool -s swp1 speed 50000 autoneg off' results in:
> $ ethtool swp1 | grep -A 3 'Speed: '
>         Speed: 500000Mb/s
>         Lanes: 1
>         Duplex: Full
>         Auto-negotiation: off
> 
> This patch fixes this behavior. Omitting lanes will always results in
> the driver choosing the default lane width for the chosen speed. In this
> scenario, regardless of the initial state, the end state will be, e.g.,
> 
> $ ethtool swp1 | grep -A 3 'Speed: '
>         Speed: 500000Mb/s
>         Lanes: 2
>         Duplex: Full
>         Auto-negotiation: off
> 
> Fixes: 012ce4dd3102 ("ethtool: Extend link modes settings uAPI with lanes")
> Signed-off-by: Andy Roulin <aroulin@nvidia.com>
> Reviewed-by: Danielle Ratson <danieller@nvidia.com>

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
