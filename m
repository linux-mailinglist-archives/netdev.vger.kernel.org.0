Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B163F663B4E
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 09:38:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbjAJIiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 03:38:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231537AbjAJIhq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 03:37:46 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F0DCB1FA
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 00:37:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nzrwk450MvfMse89meMliPloSVvE7pFQVHB8j7iAYMppDHCjMBQoikSrv1ixxWnyxltCHdUsGxp2sHqSUDVm4wOuK4HH6K6Hvsh7+BYYT9KCOdKYnMnEXTdGAUNcnrDD1V/eBitULelVehlh+lOkkcvKSk6DzZrgRzlbCdw2IaPVWw/uF7LNnaGc0iRIMy/Wfq4pEbUBs4lk+Fw082Z8SScx5atYtRgoC1C9SYZjkB+Y04Sbk0ySAgMEjMSzfn9o5Gl6WiED7rtvyqJJgTqFX/Q5jugygkPZYVlgb+G6z1fUvsc774fMJdFdNK/mCt4dqJ5ivSb93MMZ0jBhdpg5Lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rUGJif3CfSkN/0dbIVABVV9l8YJ/dbYdw3b2KEszCjA=;
 b=BaW+oeeC6lGJATUcD/O//vGDlsSnQ2/00vRZMvNkmqxZWzDvE+cO54nVpajrHj14UY34snp/ukYKGyPaRHTHuo0/1pO3vY6sHYDSPeTTUOmugl8ubKfvyTJ0GgdCoXemP/r1buTr6EP4oc800loT4g0jTRvGyzLENZEdiTek6X76LtefnbjFuafWFc56V9TGlg7spPmnoZ//gyWXwI02tE3RLFd3jZ21oWHS5Ui0sDAS74ivVC4YMZEsL6F6xvkF64VPy4xjmKCSyymKvWoTRPc6uKUqb8ENOEPHFa2xMvEuLn+3TAIQYRl66ClV7WZ3qk7KuSZsNizyeEHGtb0eIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rUGJif3CfSkN/0dbIVABVV9l8YJ/dbYdw3b2KEszCjA=;
 b=QcdWc9TWaHPOvfgwaBmgH2TDWxVNk/yMjtRJm8EfhIPD/1M58/XciYc6JIWWO+98nJsnw1NGajrJF9F0iomepTiWKqwB8aDsHVoZbrJA9bl4JaxERR3mDBtYs7UtNOS0+Uc6gjPnNB6m/PAdAWUoBtL3XCx/+b9AL5kraOnGNgHcya5mfQdA6c8DHZ60zB/LxIBO74p4zaK1gkF+1EHH5TqDs9lxAT6SA0XnTQe8zCi4AB+pTcFLXs0Hjm8a6ma+iWroWCG9T0ah9+QZE7/ZmCQXtZVQRw5zuTcgskEh/PRx8eaG5u8dLFyzrB0hCRX0hMoXuMqoCDovCPZiz6D4Rg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM4PR12MB7525.namprd12.prod.outlook.com (2603:10b6:8:113::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 08:37:17 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 08:37:17 +0000
Date:   Tue, 10 Jan 2023 10:37:10 +0200
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: Re: [patch net-next v3 04/11] devlink: protect health reporter
 operation with instance lock
Message-ID: <Y70jtmWJitiPxXwK@shredder>
References: <20230109183120.649825-1-jiri@resnulli.us>
 <20230109183120.649825-5-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230109183120.649825-5-jiri@resnulli.us>
X-ClientProxiedBy: VI1PR09CA0136.eurprd09.prod.outlook.com
 (2603:10a6:803:12c::20) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DM4PR12MB7525:EE_
X-MS-Office365-Filtering-Correlation-Id: c5d26a6f-7117-479b-7338-08daf2e5e18a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GP3fiWnQNAQE9AV1sw/tuUQIjJP3uinUq3AYFbIBIb8Ko+VRs9OukSNM4iYRW9Y0h1l7nppQBydyX0sCZW4vnhJxkp9anFs0QPrvDMiPvh9Y3DnRmO8ZYu/Kr/7du0f8qvebcPEzaHm/rxZIdWQGzDw8SyGrvxz4x6ccZE2XbL+J48braL3kyXLkkIP4XLuiMzeG5YvKTe56hQBuGFuwJjQf/p0vgwh8dEqSZHYvbV9c84Jl+ur6CALJehA4XuNWxCL+WFGHeiK383yT/KauDEUa25jD9Tmx+iI+niBtDV+dURhv75Tv70WsTwQg1vR8sLOeIL5Z30yIXzgZPTFepIAE29WK6nrxkoqK6DmmclXTyQpkmyfsY7Da+GXm06myskWfel3Q5uWZo39yp5/uadxXpw+Wez2PPXdxUGxvxMk4gdewarTcY/UPjucWKfsYr1qXgtxQu/EG37sKPFnJm57pHBY9MHIglFpBeT0ZpyqsjmZhfk4a5FFFzjGJmV1RnYG7DrNLDsPSsfDJXT5k+Sq0NQsjTx6RGpO3nycMkGPjRaj0FeUBddOUoLx35ET45W6le/HemOMbDgBRirg9eQumJDqiR2iU2w6zZt8H0YFadfjImnlguU6FW8u6agHdpn+jyuFJjbUFhFDgFv/3pw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(396003)(136003)(376002)(346002)(366004)(39860400002)(451199015)(478600001)(4326008)(86362001)(4744005)(8676002)(5660300002)(66556008)(7416002)(38100700002)(66476007)(66946007)(41300700001)(8936002)(316002)(83380400001)(6486002)(2906002)(6916009)(26005)(6506007)(33716001)(186003)(9686003)(6512007)(6666004)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6WiUu7nm3/HsvQQq6AMUXipqpCs/9qzOu1DSpZbwdMRu0FYHoLmz8zzO1ajJ?=
 =?us-ascii?Q?uewqVsYQX1VjZK6CHiHEuxlnY/2pNbPwzO22qpgcDundd2A5dCRB8gTyuga2?=
 =?us-ascii?Q?QW8cmhtDOhrUzO9QggLkAc+d+fnwOLIZqUlP8HO445/7VFru7iCpT1aDXBMX?=
 =?us-ascii?Q?jtjzJKzU8z4UJlNTQFLx2kCCOSfzdSJzWGm2wjl0mFCR2ZrbGoZHT3aC4m9w?=
 =?us-ascii?Q?DujvtRch4sAqIVPMBvbR6s0OKGz0JegONRfVh1OEte4oCkCAt/H0lEu9U7yY?=
 =?us-ascii?Q?PgGBDusRU3Nj/uuOGlAeGZode/zPXyvWbDjYNcc8L+HxNZc4toIiJmkHpWVY?=
 =?us-ascii?Q?mpi8xikQtP7nIoWCKfAGDm6SFiU7LDI2B3tDFk+dphUJin3P9Asrd5WV4UjS?=
 =?us-ascii?Q?Dzddu94eewC1qSxxR7sWy5anLoQ6b/Uq2wqXSBKb5lVih4GFL1Z6OSU4Uapc?=
 =?us-ascii?Q?Pfdfmz+LalLpJj9SWBv3GgVcosykJMsXVpqys/b8k8/8U11gb0Nauuhpvrgc?=
 =?us-ascii?Q?swCC3e2nfTdrTTOp7RBafDU6JHkKkC/UTJYvOfvXfnT9sz7575ZT3y4YyZbk?=
 =?us-ascii?Q?91KY2w8/6hy79PDbyk3OA94n8Oil6+TefzfacY2Zv8WMDvzAyFO1a8vMD53H?=
 =?us-ascii?Q?K1RKQ5mjRxm+t6JG0xsjkJML06fzsdl+kebY2RNtGZZkZvT5wfXBPLmNmOKv?=
 =?us-ascii?Q?3NNFAOytpa+4jZ68OhI89vGW6vDglVuCTlTfOjQE0LlwOWD90IctEmyBXxyk?=
 =?us-ascii?Q?8RDDJJerANBMbhYTvjnrJTH8ngrSJ/immMGz66UjvarC//FRPk+H7+yCmwHt?=
 =?us-ascii?Q?HFNd7vofwsxeoWVol/E9dx4ct6v8/IxjwiMwcfx+s0XNa8YzRh6R7Fknv6u/?=
 =?us-ascii?Q?VTskAcE/etzCHg9w6EEWpL4EzN8/+M3EoTGr4B+81KYuCLraRHDlXjJJOhy7?=
 =?us-ascii?Q?e0my2gcfbOZhYzVYXugU6sKWw4s+e7CZhrCrlhtg6oHCvmQ5XfUkAGV0lzUj?=
 =?us-ascii?Q?fpb4t1gApYsDl0AegxbN0gv4Ywkbq9bYiIeq0L5GcBWVDI0jcpgfQNi7LR6E?=
 =?us-ascii?Q?iE9yvCe9PeXxjwAqibS4HlS3hk6lXE31MHIZ5J0tG0AvXpwQkx8j0eNEQWIl?=
 =?us-ascii?Q?G8USy3RKrXSysEVQ7VnjJ0fz4ZgYeJ7mXfROX07kRodngnYC9Yjlpkw7bql8?=
 =?us-ascii?Q?KlUoVxVjtaX5+EfTbDMQBZNQfcQou6V2SE/L4zq9wSWaRE4G7+Jd8gNAWIcr?=
 =?us-ascii?Q?x3rrhgym54KsiatpIuNVqx18jIesjIdTYPaZZX2qgZdHTWhIUKQbFVxqZ0Zs?=
 =?us-ascii?Q?vRaXLCS/U5xSv5J+TBgcADumLENUyIFrmZoWgg1bhjHwSo40s9ytteGWnnYC?=
 =?us-ascii?Q?v7/8FNXCimR+kS69UI3i7167gpX5ybCubbaw2bgSmwxR9Coi+L7uszs2yyh7?=
 =?us-ascii?Q?ppAijXul3NPyrUc55y764HuW/M+gcLwT1QahOQTW6El7ixzxO7fYzYJW7Opf?=
 =?us-ascii?Q?lIY07DGxrAUv0wMM+N2THQidJbW4tFAuu6K3PLIchIeIECSFv9KoanL7FY89?=
 =?us-ascii?Q?q6qWCusBGDOpxdBDbyxIhetdnFa/0MldhE62nEKc?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5d26a6f-7117-479b-7338-08daf2e5e18a
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jan 2023 08:37:17.2819
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aSZ8T8G3romA2G+nUuD9IyDFPRZchDjzTSztuA7mobq/Kkm4KcAXLK+I0qjGNuGTENLx93S9OJGKFhWeplAQ6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB7525
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 09, 2023 at 07:31:13PM +0100, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Similar to other devlink objects, protect the reporters list
> by devlink instance lock. Alongside add unlocked versions
> of health reporter create/destroy functions and use them in drivers
> on call paths where the instance lock is held.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

The changes in devlink, mlxsw and netdevsim look fine to me, so:

Reviewed-by: Ido Schimmel <idosch@nvidia.com>
