Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D952F366011
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 21:10:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233750AbhDTTLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 15:11:02 -0400
Received: from mail-dm6nam12on2063.outbound.protection.outlook.com ([40.107.243.63]:16448
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233509AbhDTTLA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Apr 2021 15:11:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F6xiK5n7gJ4zZkw1tMDQKKdz8WSWXtOyD2+butM7YT7cBS52eo1K8l6bsW+stfJESKz1f21eWjKiZljtyQbV9QWgzeZOG17IGofqR2vfKaf/DcuhTAasbILlYroG95koPyO+Grup4fbY1wf3xWm7qGPckjG1/yvH6BeZs/GGSy4Uptv+XII4P0my/5AdHtFnTq3QQTCJdwCTGQxB6N64XdfQHZZoZbzKIVmp1BrzMu+MUCeoLJ6Cc8uqesirAe23MHYnS5iYjDbvfo+NL7zzUmZHrn75WwrIL+hY0nd/AWVJ5ZN/PpRKx207JJqrzHL4avHRDq2JdVO3b6oLiP4dag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=piYAFGj4XMIhNhQ5vLwbS7IZTdgXWLpyc4gOSkSfu2A=;
 b=ED+s/mf1yPfR3+/oDsXoyKuk7YJf4yyewB/qKcKBL0L1GG7n56rwjYogBWkMWGpwPyMvcM9cNM5ppf2NEsCm3KnZ+cbXxp4RDqmmlBb2wPWl/axWezvLfaf9rzbSDe64GDYmOYlMUIzBy68OIdPv5YVOp/LlxfMzaCy84u0CeKPVxjOMkPdy0KzSuNaGJCsCZmb4WjWdTgbdOhfW9sq/sBSTttT4EkMgzak333KdHQB7tmkov0bdOkaaiw6ZanMgVifY/fy21py/xMRhi8fnFnex+xWTB5VuaunmKBvUWdsqD1Cf4F8cYJETEHa6s0a//CWl2YUZXcgMqV9Y41+4LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=piYAFGj4XMIhNhQ5vLwbS7IZTdgXWLpyc4gOSkSfu2A=;
 b=KxlbPyA+ErFR4ehFxaeQbCtF2UiL7kbgfZILs2EapR27/t6y9+nc43UycGEe/+vBsYgD89JJT259WNyxfmjjnOvZEozInJf9Yvqd8+XeOej34zHTkZfUOp8Uk0zoTPUWQgi//9ypsvvHhWeXJfW30sKD5EMPtAG5XW5MLEkzvoO9hwlnF01AdhOhswJJlvItxh0z5yqXQc0vs9x6ILm72M9s4mJRqPyo7DwXnPTOjJhfITyyl9TxgC54eLHE7fwbmTRzhixGf6SJmPimQnWO1g7+U0+dVSMI0fNkv7VrYLIsfWq0UNCD1z75cAMX4Kco6+wkEcBVDZT7N2I5Yx0pDw==
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM5PR12MB1657.namprd12.prod.outlook.com (2603:10b6:4:d::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4042.16; Tue, 20 Apr 2021 19:10:27 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::1c62:7fa3:617b:ab87%6]) with mapi id 15.20.4042.024; Tue, 20 Apr 2021
 19:10:27 +0000
Date:   Tue, 20 Apr 2021 16:10:25 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-rdma@vger.kernel.org,
        Maor Gottlieb <maorg@nvidia.com>, netdev@vger.kernel.org,
        Parav Pandit <parav@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH rdma-next 0/2] Two fixes to -next
Message-ID: <20210420191025.GD2185150@nvidia.com>
References: <cover.1618753425.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1618753425.git.leonro@nvidia.com>
X-Originating-IP: [142.162.115.133]
X-ClientProxiedBy: MN2PR07CA0003.namprd07.prod.outlook.com
 (2603:10b6:208:1a0::13) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by MN2PR07CA0003.namprd07.prod.outlook.com (2603:10b6:208:1a0::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4065.20 via Frontend Transport; Tue, 20 Apr 2021 19:10:26 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1lYvlR-009AUn-DY; Tue, 20 Apr 2021 16:10:25 -0300
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 088c7049-0973-4194-0a0c-08d9042ff4d0
X-MS-TrafficTypeDiagnostic: DM5PR12MB1657:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB16570A971E978B779BCF694AC2489@DM5PR12MB1657.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Oyi08XmZtb6JiSm+sYPyHecFQaTdjWlK+wSwBsLf0dsLMJVDNKhOdbnU6BKkrvVdMdSML9XrgMtD2RpFbi2V7YVc+r3s1EDDvSiBuEM9WNr2aAj+PfWiZ46vV+Y0d01A2VYmtkjTWYE1RlZgFr9K2/hSjVZaDbyVOGb175jZA2twQ/jEZnmyFHnfbo/ugRb0R242TX+uUej8kDBFoU5TZmcRWO8xd1mGYtvmygAe9gkDy1H1Gwkfr5Mj6Kph8x/4VBv15FNqO1MfFSLGm1VDFR5GAM/PSzFnOZ1chV/oPCYNkH6rRGrHjvD19sz2IxAkYhTSn0lpjN8lJA61FLgDq778YvjwOUv/V1CxOjiIm4DZOTiea3rhkmAfz8jC9er/bgHcUSzDUk4fTpR+oVAIFmbuY+ZQ7aINxsvZaZ9/OTcdhO5/v8pREYpE3Wq0uKelMBdum9ax/RiVAn14YntSH/MXvMiMXodUbsi/mcmTkEs5mjtZsmxRF42jdSOT/360fGiQNY2+5V82fQiO6f2GgHRA2CbIlDnfPjY3eWIu2lZCJDTRSbPLwZenUFxiWHjFMa6TP/+By2VPlJcA1V5TWALTQbFugsNMI51aoMt936Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3834.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(376002)(136003)(39860400002)(66476007)(426003)(186003)(4326008)(9746002)(33656002)(83380400001)(5660300002)(66556008)(66946007)(316002)(38100700002)(26005)(9786002)(8936002)(86362001)(6916009)(1076003)(54906003)(4744005)(2906002)(36756003)(107886003)(8676002)(2616005)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ypwpgnAYkSAxJP7BCtm+nJdL4z/Iu8/64HkqdvKMTschb5uvOKmqt//NZP7k?=
 =?us-ascii?Q?5ARWJC2bZ2H4JJuRmrwU0rNtstqUYqyt72iBdGluQu7GuT2pPgsJcePImmbf?=
 =?us-ascii?Q?Csf2aPA3/q3/eR/v+Px1QOXFVA9SvszhBDMW5tifhfQ73bL3v1NrJSYKekcM?=
 =?us-ascii?Q?5ynPftnnlM1n091ngdB/607uYc1ORdIJ60eRHyNQU/vYcxvqy9zBilQvgHyS?=
 =?us-ascii?Q?oKqXwix617MbtiCxAs7OoQ1DUmkWRvIfU3wVlA5sqeFWWO+vZVgGunDZvnrL?=
 =?us-ascii?Q?HVcsstKNIR9RGTAqG223S3fYJkC6Qq/XKcMrSxiOMSWzc3aOhKAO67VCzXKL?=
 =?us-ascii?Q?jGqYJCCqHVgAjLk/cJODXpMee5SIL3nj2Bub0XbeZrPlvDePGP/ct4SujZLF?=
 =?us-ascii?Q?4yNnUrfKy2GOysZUIDkFg12fUd0YMWm4edGs2t+1f9wg7Q7zR27KBwAEhpXO?=
 =?us-ascii?Q?ixUtbW7B/QpUzorvESs7nFD7qUJrqJoSIhvJzBI4xfYrTmR0Z3XDZCEpZvZ8?=
 =?us-ascii?Q?dgFRD4zU/dn5H8KKj8w7yTOCQGBIGSgnPXBjwo4e5HIBWr7XG56FMH4nCvWv?=
 =?us-ascii?Q?fn4sfuH0NyDPsNcoF17/1eREk0S5z7waSr6KisdwYv/9CYzeBsQnx1SviL5V?=
 =?us-ascii?Q?mSC9qDy+l5Z7xEzDXwvFhPdysnsrITnTpYWnyjF9yVkhr5aBxMnJYr7Rnx7X?=
 =?us-ascii?Q?VPzpRDTk+/vQa21ztJ1CHUQfojrpU5hXR2W5ycO9mZih1Y/oc5N3PwPROXyW?=
 =?us-ascii?Q?kFv5ZRObFIenpzNuC9Xert55HCIB/UWK32SJYp+tT+6ChAx+axYbu4AS9vwU?=
 =?us-ascii?Q?p/yfN72Ze0dxsYGbjB+JU8nKpMgDBzspC9WC9yMboz+PhRW5E8ohUz12L9f8?=
 =?us-ascii?Q?MdFT9cGDg3MRy9UunmgYZGWvFySZ/mRS9jcguBSVE+CpbRLo5GAg9abRkfke?=
 =?us-ascii?Q?Gbd/SrwqIOfHW7NKHA910pvQcXJLTfoNIAdxPFfAETAXcxw7pYGMz4LEeaRT?=
 =?us-ascii?Q?WUzc3TKXF9PQLQZcR2XVbssBkdFr6WHnO3cI5rgAlyF/eOh9xm8YckJqyEuu?=
 =?us-ascii?Q?UPGLj8ZAZgNIPDf3Ah9rgbM/M7AqaFe9BSOFJvxJU21LV5KaDkZ+2SLuX8d9?=
 =?us-ascii?Q?VnwrEpgyxUX1DbcRHrnp9Ja7LwChr2TmQxL48jtanPFG2pq37YH/hIZNFEjm?=
 =?us-ascii?Q?8Hj1tdOvZznorXrXrEgqe2shSFVXKVmu4r4ls+R5iynK3WpS9rVgjjcI5sxo?=
 =?us-ascii?Q?PacPr0y08qnjyMHoSYCstIjy4xg9HhsDsXNudkx2NIaWKo1EJF+Lcfma2x7Z?=
 =?us-ascii?Q?9g1jsZwrSnNf78W2hGw76BgwqawgxoG5U8E4SCUV5zqheA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 088c7049-0973-4194-0a0c-08d9042ff4d0
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3834.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2021 19:10:27.2411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xdLyIhUcdnHoJF7VNdlM27D+VrP0dfUytSoCikkBzKbV/6Bc6DKd88dDZ11no9Nb
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1657
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 18, 2021 at 04:49:38PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> The two fixes are targeted to the -next. Maor's change fixes DM code
> that was accepted in this cycle and Parav's change doesn't qualify
> urgency of -rc8.
> 
> Thanks
> 
> Maor Gottlieb (1):
>   RDMA/mlx5: Fix type assignment for ICM DM
> 
> Parav Pandit (1):
>   IB/mlx5: Set right RoCE l3 type and roce version while deleting GID

Applied to for-next, thanks

Jason
