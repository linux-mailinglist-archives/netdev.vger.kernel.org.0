Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32C004F847D
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 18:03:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345504AbiDGQFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 12:05:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234257AbiDGQFX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 12:05:23 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2059.outbound.protection.outlook.com [40.107.244.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60AD21E6EB6;
        Thu,  7 Apr 2022 09:03:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lJQz9jQ1c6rWVUvbWCia6THECFR7fE47aE1xvG0TmzuUVGxBv8vmSG8pIk/+EcgRuFWIVegrxEbnOSGG/tjUHBwY0GhJnwNmeKF+S/ZPfC7j8Gt8ic8PNdL1pF8aVrROwLRG5k+xJPaiHVB2ULlFBw9DjPh+Bpqr0rWlKg1YPWO9Vunaf7el9gLMnIctDe3YbcStM/8XWn+Z0Mtt8hEnNJ4nCQxvcRgWSq6jznOi0Jeia3n0Xir2o5+75mXoRXW6x9ngKbWGjKje6Lc/0+RX9otd8wpj+Tnuw6zePj56xUosMe3otVEyPrM+HYnpUTexjgNrhh2SZ8kMQSHHDSaZxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EKLmve+AfnltkRtIBW4QNFGwcvNoA3YRTGhK2ba5PaI=;
 b=T049GM+RX57UOXRj5ghQE9LhB0OJZkdYYZC7cwNJLnlBj+XQEX+QoOOTR5lchq67u/iMuD9DRe44CMFgneHxjf0CV/XLx5n9W1itjTs9vSNdD6BlmqpGHcB9XhL8Pt1jViu0ywl0LdYSatny3yST7Xt5OpJgR7akAKeuT8DeLb2FVScZddQCTbXfTlGRiwcQSRbRLSlfgo3HkuhdPK3BWOBoK5mpKoLpwZKYeXOJzMK4F1DVX+cycWPOJc1Q8ZR0iFJ4EKU3B6hLEl7RKsu91zDl7Y/sQRlslGlU0sIsjyFdaXHm1kOJkY/nelClita16iVIb7gvEzjC/5RbI7SUTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EKLmve+AfnltkRtIBW4QNFGwcvNoA3YRTGhK2ba5PaI=;
 b=dV+74AIZjYbeybBVpJWxh1CmwlSL3eVMS9J49W94pE11RQxlZvrN1ZeVF2Cv/b4hF3ZTpx0dMfg15RuzHrWr+3JVmF8beDOf+NyGAUIkDEiP4wY9A5OT+RyaHcM/UXSVfsjBTCKgFTe1GDKzLSJ2r6zy7YLVMkxe2o2vfwrsLApquCOn4awgKfV+LuQicK5MrmN78VWwQ/bVudh+Sy+W3pg0E1kr9rqWPUSSKlF3Je/QBv7A0p99L+ie+wvH8cjD/wIsz1qAM8RovhaDZfNkXdCs8alPlVnYe0ypz+JQ8TWPR4Biln5bakdspl36px4jcprYmZk5DkLMRt4bieLLmw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4192.namprd12.prod.outlook.com (2603:10b6:208:1d5::15)
 by BY5PR12MB4885.namprd12.prod.outlook.com (2603:10b6:a03:1de::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.22; Thu, 7 Apr
 2022 16:03:16 +0000
Received: from MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374]) by MN2PR12MB4192.namprd12.prod.outlook.com
 ([fe80::cdfb:f88e:410b:9374%6]) with mapi id 15.20.5144.022; Thu, 7 Apr 2022
 16:03:16 +0000
Date:   Thu, 7 Apr 2022 13:03:14 -0300
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>
Subject: Re: [PATCH mlx5-next 08/17] RDMA/core: Delete IPsec flow action
 logic from the core
Message-ID: <20220407160314.GA3429238@nvidia.com>
References: <cover.1649232994.git.leonro@nvidia.com>
 <a638e376314a2eb1c66f597c0bbeeab2e5de7faf.1649232994.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a638e376314a2eb1c66f597c0bbeeab2e5de7faf.1649232994.git.leonro@nvidia.com>
X-ClientProxiedBy: YT3PR01CA0070.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:84::18) To MN2PR12MB4192.namprd12.prod.outlook.com
 (2603:10b6:208:1d5::15)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 20dacdbb-12e4-495e-537a-08da18b0207c
X-MS-TrafficTypeDiagnostic: BY5PR12MB4885:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB48851EAC475D98F07BB13BE7C2E69@BY5PR12MB4885.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +gdrztrPN4z+rzkOSIXB7fpNdTDnywzq2E6QGV585hYzwR/Q0hsLUKnqwgHBI+y1GdR8DqZV3YuivW8KfNXfJr6fC7boLULVTiESbBS6BwMx5+aU0agKhDDhFpdK5sbww8l9DjjIrZEZ2nhyOqV0qauXuJtJpSBpwotBlqi6ceLn0FojbdWr7ssWzPONRgbulqomBv+FDvccL5CG4W8ElSrnsV0MmJdXCfu7K3XhDk2RAIrqYkBHJ8t5eFlQ5MMdTHRDoyEG1/FYD9+SQBKKYPMgXYASq1CymlCLGCXwnGZKTdQe72gfS5RYOPo6/vIBrAUPp3hyytPbmOJGwp8t809A/+8g20K279929FTkf+JH70usgbasPUffSUnVosd/jy89LCQz5S6cZjRnxDr8PUDpObf/v/2HfX9OQ2O46gisHOHMLBGetA2PAu2tLyUJMqCbCb3scpqTplamo8lvyGX+CICFo05ocLAGu3wL8Uef8RCnij+8TbzU7rKMP5xCWWWZii7vdls3Rp1ugh6MT0ERNEaZ6qe8ZBPuIV7+W2nx5Xv89qpfGDcZk9yyLLSDwqiqUZXfj72gXx9eBCadvelkN02YYhNhXYLlDW6gK/nxi05IclIcxv0jtKqYwv7Cd/TiAmCvrzDFtRGit96p0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4192.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8936002)(5660300002)(1076003)(4744005)(186003)(26005)(33656002)(4326008)(6512007)(6506007)(86362001)(66946007)(66476007)(107886003)(8676002)(2616005)(83380400001)(66556008)(38100700002)(316002)(54906003)(6916009)(2906002)(6486002)(36756003)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?n3cZW0TqpEKZ8kbACwMptOdMmQ6gbhv3YWSXLYLlL9VSxSt5Wz8fayku/5bs?=
 =?us-ascii?Q?gVwzf14mbOekUYzFKQ6R/yFvvmnCoBoBPVv9gp705OLueJW/fxtEH04t4hRn?=
 =?us-ascii?Q?LWfHESy3cGNUNyelMFrNcuZ8Vm0NCPbb7My8h3NCvBjf2WxlcU/K0qWVnFkB?=
 =?us-ascii?Q?XDzyjba4j5OQg6cU0bQ0dngKJRVcwLibA9+eU1LuOh4k2IIVivYF3hxGHpAS?=
 =?us-ascii?Q?GEBApRLOos+kAQ4rz6/INkskUcR4vvkbX3NhqMYa0CVbhwSchzQgc8+eE2ZJ?=
 =?us-ascii?Q?PTox3NYL7GY2HNYKiK4a6AogHOEBAbMpwl1w988tnn27yxd9bPnUXh45/RVa?=
 =?us-ascii?Q?F9WxGbLS9FMyJ+CL9O1bYh5GkBdsjYeEkGfsx6FEFt7d44jWPgy3DPDdQmoh?=
 =?us-ascii?Q?DmnAo8Skj6GzzbkDSG4BupWLDgoVsFvLQpWjVsCJPtcfSH7yI488Fck3fWia?=
 =?us-ascii?Q?rFPcUdUUceqj/whRj7ABfdL5RMMJoSS5sX+xpzq33ektPchCRUqYQ+iyTk+f?=
 =?us-ascii?Q?ityIn49VsbeQTT06D43ungH7KXuijZgncHNfQa+STHk+v9mbrjm5umuRI/rm?=
 =?us-ascii?Q?zus9NQpeXem5HPPTqibpc/qWVeHv/7SeU7UvPuIo0T53kqdXvgmUuKD2bj8E?=
 =?us-ascii?Q?/GsLrQQatWkXtLjioj2Ne9m5VpAm0VxdtEFyNvc9fvqCXAsUnPtcy0uUAm4S?=
 =?us-ascii?Q?q69ug+PaRhuvXcRl4TPuEXT2WozsnpvXdPlBjWZGUMTV6stJ5y16GZczUCI5?=
 =?us-ascii?Q?uqtqwA5ZfNOyM2+N0NF4ZTmymZbFPenbsQxgFM9ReZluDrvaxOm5HT46NXvz?=
 =?us-ascii?Q?yweQH+cEpHYdeb3bbY1cQ9XCoGEdYr6tk0PoSzlx27NTxIJ83L8rfnLatgfc?=
 =?us-ascii?Q?hRnElFZI78oXCgfXbuFSGvYoYd0ag/0KoxP3UDbflbQQ4+COrwf+SXlTTxO8?=
 =?us-ascii?Q?BEydaFyj0tELIYYPHaUiF/LqsinhVRV3ADcICBIayzC/1jz8J5qewZMBLsmW?=
 =?us-ascii?Q?sHvQEUfo/8qLC7TKiiCSun9DOQ24QfveiOVTKQ7Y62kpggMQUc63kcP7Nsa0?=
 =?us-ascii?Q?N4XIN6dy6i5Pfag4xHbBNY8gL5kcp2M0bMstbDDfNTrf+EaCBhA+DotIeEF3?=
 =?us-ascii?Q?HYefqIQBX0vnOHV7DW7CXdi1diRkfx2FsyHJKtXwPuy5RuMaduvRM7q8RUV2?=
 =?us-ascii?Q?FwEGiEDuHrrCUe/vuoXBu1awoibcm2uFrdv6QIwpEdYk3Bu7S3s9XR/K+F8R?=
 =?us-ascii?Q?UNOXC465Pknq8GuWzs9aoUedeyUwMhZg4KxlXyvLC/QXBSwprGfDr/Aeq42M?=
 =?us-ascii?Q?75KkDlSyf+7kOBS+0vCHvu4J2SmXBod5uan9PToXguVvZM/YIq0xC4prpgaa?=
 =?us-ascii?Q?ssqGgCnbBykOFa6eoFV8bhwnw+/QS2APjypyn0Rkmoea7HwBdlW6vka/tiTT?=
 =?us-ascii?Q?PXsMdv2ISxizJaiAw+Z74RGMHDQHg1bLG82S7dEZ6qoCSWHHYTC36tSMFCZQ?=
 =?us-ascii?Q?5Nbq+KdZ6RqVZM7GmGAEzRPgbbwsyMUi58GaRelKYX4Etbr5me9Avgka7uKf?=
 =?us-ascii?Q?2zJJDf6duEZF8CXYe02N1VptvE1m7yc+6XIojKN6VlLVDCgOK5CTo8v0FjGn?=
 =?us-ascii?Q?n4ht49Mfh678ptMWWSJAHPoyBapwqOa9Drkz3n0XqP/weA3qt+PlMoNy1tXi?=
 =?us-ascii?Q?UwzpXC3YO/DsC6/KOLQsIkw+nuXYke1zQd9AAT4SoE8gvFbapYqEV2sPGtTl?=
 =?us-ascii?Q?RZupLvrgkg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20dacdbb-12e4-495e-537a-08da18b0207c
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4192.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Apr 2022 16:03:16.5769
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tVxgGD0pCpUxVRVk6ZFJ6LZzWxcCNIdSUDpXpDGbuCxsUWEqXec9rKzZfsbV9YlJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4885
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 06, 2022 at 11:25:43AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> The removal of mlx5 flow steering logic, left the kernel without any RDMA
> drivers that implements flow action callbacks supplied by RDMA/core. Any
> user access to them caused to EOPNOTSUPP error, which can be achieved by
> simply removing ioctl implementation.
> 
> Reviewed-by: Raed Salem <raeds@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  drivers/infiniband/core/device.c              |   2 -
>  .../core/uverbs_std_types_flow_action.c       | 383 +-----------------
>  include/rdma/ib_verbs.h                       |   8 -
>  3 files changed, 1 insertion(+), 392 deletions(-)

Acked-by: Jason Gunthorpe <jgg@nvidia.com>

Jason
