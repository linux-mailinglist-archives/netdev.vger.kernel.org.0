Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2030957B4AE
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 12:42:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbiGTKmX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 06:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230285AbiGTKmW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 06:42:22 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2041.outbound.protection.outlook.com [40.107.223.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D6FA599C6
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 03:42:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JLy5oa8I205GBkB3DlQJ1oBtDqzY61J0k/fsJjk2kzSMUvVWHlKew1OC7Qv20HT4TULySQvDKHFSXl5HtUlAsGCKFxHp41pEtNo+GwN+IpDwIkQWsdXe913HiiAOOAsbsxzqNa11sryeUxdGasbhF1aoF5HgBazQ9QuyjSLtG5K+7/FXGzSAyOzkMDGT49dMs9PgxRhSl+AIBkEeFbv8RW0H6wKUuRFod8ZQ4CRh2Mc3wW9i/SpKYRlH2kwm1haIgeaPheQYfpUuN1g1LfQvH0a1X6o8L0WqY4ZZKeEHVlIPddg4iIyvATbH8qIbTBe8xsGlKp3Tul6HypdsoJXRzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Lc0wZp1qMzaY+QI2ZZCdI4+C8m6ezVPrC+nmy/nV/xc=;
 b=mXNbTli7SnsFfPQVap0xtKmvedVFGHnsLIZ978dqsekuICvC7xtxcPam4S/8TsLpI4kk1BbIDYiqoM0ns5WAU3Y+KAl7dCZQIareXiVg7aIq6DYXkj/830LYyCxYATl6/b5nb54KBgwkSWTxrpXYhQSD7ikbcpS/URCHXK9po1QHKrw/qy6a0KiBh4X5GQfz8O1jUFIjNsZGXWxIYP2+EwnZCew2yAFFfznZtWaYXEqRWBUq2n7TwvfhX2OnRsJbzSHhb9sXGKclN7lEfHRw52EWCcwn7KBMZNO/C7/NESSW6EI0bVMUq5HnF64LfkdNYoeQxT2GXPFbG9FPk1JHRQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Lc0wZp1qMzaY+QI2ZZCdI4+C8m6ezVPrC+nmy/nV/xc=;
 b=fJGcXqZmVFWpvOgP9XskgwCGXzBC5kLftLGmPBEZq50obJ/w4MUaQLPzHjzvBKdzHIaIUzY1y3NHNsILcc5pKnROn/n0HUFSOqMtYsSkc4HsGHNyJ37bNO/paC4nYnFzYmS9DG5J9G8jgzFDrXycIY/hP6Uodn0a3DVI6zWY3MzZIrOAafNjRy29OQZ2NfJ8d6VESTvTjcW1K4o7in7p98Np8proBMiXhgpqQ8CFbigs2XvrvhfyxF6Jk2KIv4QzKjyeE6PYBuwfXSgt2zS1S7nWCfByT5XOKhSb4XNiqiFJp/4SkP0fM0UAknaamh3ztP+jz1NROb35rCfbizQN5A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BN6PR12MB1313.namprd12.prod.outlook.com (2603:10b6:404:18::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Wed, 20 Jul
 2022 10:42:20 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5438.024; Wed, 20 Jul 2022
 10:42:20 +0000
Date:   Wed, 20 Jul 2022 13:42:14 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: Re: [patch net-next v2 09/12] mlxsw: core_linecards: Expose device
 PSID over device info
Message-ID: <YtfcBhgCFsxz5EKX@shredder>
References: <20220719064847.3688226-1-jiri@resnulli.us>
 <20220719064847.3688226-10-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719064847.3688226-10-jiri@resnulli.us>
X-ClientProxiedBy: VI1PR04CA0073.eurprd04.prod.outlook.com
 (2603:10a6:802:2::44) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7d6ca101-5e49-44f6-02de-08da6a3c85d0
X-MS-TrafficTypeDiagnostic: BN6PR12MB1313:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PoR3bpXIb7EvgGSk284HzH7FHbv0aftkOiAHX12DoRkrn9N4x0uX+X4sYDjXIVdbbOGZNVMsjIN+GmD2ju+Sfe8wXDY1okCo+/sSwMNmU8HEuAN8IKgdzGvcdOg8jlBDw6s9StV6Vm2ped7uoj4UYU8EvZssKOm3529qtI+WjYev9Mf4z0Dy8mRV0Cnh6nKxCynxDOnwktbgrN6bG+W1e1MrdSnsGOC3/a0kfS9jPNdAsgrHPPW2LIpk3ShgBcC3PDIlQXAk1bHnZIMrHHK1P+X+nCszkC8Ycw75WtktszxrdwJkpDx8vdpSRah+oQWlcuzuAHn68x618DI7y3XWor2rc+p6cegWcQRXJP2+vpNGtntQCl339IPwipKlfV4rsa7MmL8pyAGXKsBHGtgcHGmpPbkQEWkVyB6U9GFPpGP4O8zgbmDb+pBFGhhYPj0CoEtARqkyNliGHmrENK7Z2XGqc9oSEGCKNxW7hu+n+JVlKQ44RV3oxmLbJtBUdMNbP5FsS5oPcQWOHtm7GDXNHSIXBhFZX60OaLtU2Ml8vRG1U/O8NHA5/04aBpS/Zv/Zt3761hUDcYpa5pVeR1w78LhrzIqWwyU6cZttUL4RsPB+PKexI+NonCb2EojFo+xKzZWh6S/2EyGXOEDyWUstdBY+glGji+u8o/qeM1ggnNpD6a5uJC1Q7SK96h6B8emlI5oKahZcNz6sKEkkK+UO2Fqs1KlIPabVHv/YG6uarVGE2Z2Y+xTmyEGJDJdUzHnY
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(39860400002)(136003)(346002)(396003)(366004)(376002)(26005)(6486002)(8936002)(2906002)(41300700001)(33716001)(6666004)(5660300002)(6506007)(316002)(86362001)(9686003)(186003)(6916009)(6512007)(66556008)(8676002)(478600001)(38100700002)(66946007)(558084003)(4326008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CST64GavCn5MItpqKvp7M4ITh3AFoQhqPl1P3jw9zokUe/tbgrJAu0JPaIfq?=
 =?us-ascii?Q?KJXhovNbfb/EYtJ5y+82Jw7OoUr2/djOsfm/0cUq8CnS65fg5A4NOFj1DMRd?=
 =?us-ascii?Q?h2Wc5i/GcXujNNxKi8aHWgobGfbWHCtPFgiio4Eeseqe54hpnHUTJfMos8zw?=
 =?us-ascii?Q?TDOvm7nXAvY4dDPt8Cf1Pg/bQmWZ7l+SHzbCSWPzkY0AE9t5SnCi1iBtSDtw?=
 =?us-ascii?Q?6TG6sbAtTVihfL1tEG1nJMg5zVvKubCk8nnqrd7Y46ErExaMm6i86nRqeXIv?=
 =?us-ascii?Q?tqf8A4dwDj35f4LDp07HuRkCytxrobza4GTOBbrYujbcKCF697mPIEVvRbZL?=
 =?us-ascii?Q?xuFtNMg+tJxjPzUdaV+C0qkBjJ+1S46FgTdXrNiADvz5YwtPbYBlPnlB7Vbs?=
 =?us-ascii?Q?5XdkDiDoCd8IopgCyjsq3yLdjMnuRztWMW457eftP7lsxrGkMRks0FPvmw7o?=
 =?us-ascii?Q?wyLaz2rsPEEonzWhzW7mN84dcUgzMGiz8E4VM6vH3qjFH4s14NjPCOsKGY2t?=
 =?us-ascii?Q?wvxSs3b3xocSEkqure5nj2rqrtjoKdyAHhr7VlZxzAzhOnRc+ELFDp0ynSDa?=
 =?us-ascii?Q?lc4gZfXuuJbBqWDbc23fba7XnM+ElDBc/HzT0h9fcFKMzJvtAaOBkqjX5QmF?=
 =?us-ascii?Q?1s0cyk+vmKxxd0SjYxx5TCAABeslhnCvDL8ZdLE9gmfxt2VkLFoc37p93wlp?=
 =?us-ascii?Q?XYt/ouMbCX/1l0Xtd8DgraC9CxKdlF8tlcabgF8nSm60pnLAMXl7H4T46Mnc?=
 =?us-ascii?Q?yx4/h9uX5kmoPVDWuYgwYYBVYs92vNsrWx7CMR5qLI+1ze2hwvGhpZDeHvwa?=
 =?us-ascii?Q?XgRV2vptih59liDdjAUh9BTKNjb/9bbMRAEoD5gR50y6rduOhNbaf+bjOCy7?=
 =?us-ascii?Q?ULnAyPvG4p5qJ9ZsTByxkhfCzw5QzyX1ijn6hm3jwPjmynFvN7nszs+9Ev08?=
 =?us-ascii?Q?rizOtXr9YFDefT/d3LAquCAButfk0G57g9/22HC/W4A4em7QpK+QqRuPxvN3?=
 =?us-ascii?Q?CEKXYOR+BttUB6ZA2R58uz68+6hT26BQ0YkBv9PPNZpVPZEZkWFxpj6JNvqK?=
 =?us-ascii?Q?U6FPoesZBAFcgRGned4B0Mimw33XJzN0077Fp/8QmoDOvJREKjSQx8gKtY23?=
 =?us-ascii?Q?ExeVRLj0n2bLFjZ+NaYOIXpFz9ShXb5Gnux7wk2JByNqgAkQFCXIXlK7Ls6O?=
 =?us-ascii?Q?zVzOD1OZZMA/M+XWmUsUUDGl6v1kjP3hEfjykLazAR7nVZzfQONucvEZ0bAH?=
 =?us-ascii?Q?I20h3dJdlf+EcnFzslbXPr3sBoaVDHgT7GGmFiG55GBAEUlSvsEgfYXcVl7r?=
 =?us-ascii?Q?HmuMNx4R+yTN8hllSexHw/2JYgo42b+da7aX1YVEglXUZC9wpcic8J+eQ4cg?=
 =?us-ascii?Q?EZLYyw4Is+yTUMTvwI7KbpMDiUtUGFBAgrVkxiCZykTPoxuSd7VfErBPi9mL?=
 =?us-ascii?Q?zFguQDstYumUe2UaskZePzktHS/vQ2Rg9+y6EI4ymqiJOEnKn/NltFzuIfkt?=
 =?us-ascii?Q?DSUWiJuyMJmMFznooJ7vSL4TYsf3+tu7db+0M19yMWSnYLJpRc+l8Xqei/bl?=
 =?us-ascii?Q?yyCPyTx5hG5UU9/Ft+Be3WXVgy6j9BYXWV4pV8gk?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d6ca101-5e49-44f6-02de-08da6a3c85d0
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 10:42:20.3418
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: BXlqIHuWpQ+aQPEyMTZ/09UtEllb3zczD3jN1qCgUKuwaXSdUzkIjUE9TQIUdqMB0Ylxu2eCxoKLhQ7ctMcy4g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1313
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 08:48:44AM +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Used tunneled MGIR to obtain PSID of line card device and extend

s/Used/Use/

> device_info_get() op to fill up the info with that.
