Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E93E54CBC4
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 16:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239847AbiFOOw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 10:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239067AbiFOOwX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 10:52:23 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2086.outbound.protection.outlook.com [40.107.220.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B4BF49B7A
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 07:52:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aqGhvK7139N6+6qGEFLCh24lT/rr6mpkzlByFCoGBBHPhJgp1/UfMnnspkt3eq9/aw3mI9aHaoFGtpt8F/Q4V/zOoycO40Wubtc/M+ZXTSXKuU7PY4QtI8deetb4Q6rhMZA79+RfeJGw2jr+29vQ8MbYdIgoqW5wWjkqEhqIKIkuJjote4mtV4gQcCz6iDI2gEYB0F6crc7zK27RiXZQgh45SHROICgugwReJylrIlz9UFdRtI8kqi+Jgt8o4aGIfvSroSh1IZtowLpBV+Kyv2y6CBujsNnmFmIV1ZDdLzJ3gvDhnBVEfwyD7FV0x1L9kY0u+v2RCkdRWEYN6JL/zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pXoSUygeci/Yk9QSMT1kUsLZJVMvcIz5rrE+GkBsBYc=;
 b=AuBTJ+UCflJ4YqKcozOISMebETMzNaG5KaYwp5Y51JT4bpS6HEBZYmS9WX71Dh9YLnua33Q8tMUPJhckAKXqmZB/TNeyk7qkthZXuCCbh65hE1ioloNbb+VQjphwVxYxo9StA8kWxlTTiLPLLoi4zB6EacnI+8ntFNicbfxiLVUr8BqUzHjSJFRx/LNX7sSK6fkvtma3NE7ffm2Kwg24IWCdfl5c0QG2076dxYdOOxVLNmQaW9MYk4Y858c9xyntMB2M8lduxmGWnbR2cJ1Hu4Qyx4Rw2gdLazLRF6qzuByhOlam59zyo3GCN8ctDdk0E3Xo+SMtJf0Yq21G/j9FBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pXoSUygeci/Yk9QSMT1kUsLZJVMvcIz5rrE+GkBsBYc=;
 b=Or6OHz1SirA2Q+7R1UaFNMYZjGYKyv5z0tBsR3ig7vm17xz+Qb3T2IEybTjTP/VbXhXQZekXsyjsLcZkFMeffUX0qFuDxoiWJT+ZsPOkwEGNtuVAy+A6vIt89a/n2du87+D9Qb0KOZy8FxaqgzHJvLrHOtou+BfvcLPsbKxdBXC19WySF7pTVz0WZTiZUl9SnMpVPvUsUtQud65u3ShaOAUKjgsVknZRpKl/yyvGIYVtvDHteu266//4syVGZncYLs3YjXaDDp3Df0NVEWndTHY807SAiduz7Ye4kMZ+N9TfVkH3VP2CRe2eKm9hKkJtAZ4rfLcwCMWf73vC1k4Ydg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BN6PR12MB1780.namprd12.prod.outlook.com (2603:10b6:404:107::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5332.13; Wed, 15 Jun
 2022 14:52:19 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::9157:69c9:ea8f:8190%9]) with mapi id 15.20.5353.014; Wed, 15 Jun 2022
 14:52:19 +0000
Date:   Wed, 15 Jun 2022 17:52:13 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com
Subject: Re: [patch net-next 02/11] mlxsw: core_linecards: Introduce per line
 card auxiliary device
Message-ID: <YqnyHcsi+GPVT9ix@shredder>
References: <20220614123326.69745-1-jiri@resnulli.us>
 <20220614123326.69745-3-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614123326.69745-3-jiri@resnulli.us>
X-ClientProxiedBy: VI1PR08CA0206.eurprd08.prod.outlook.com
 (2603:10a6:802:15::15) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7ec4d8d4-853b-48e2-965a-08da4edea5bc
X-MS-TrafficTypeDiagnostic: BN6PR12MB1780:EE_
X-Microsoft-Antispam-PRVS: <BN6PR12MB178040A62FF18CC2E6343B0BB2AD9@BN6PR12MB1780.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +yDv+g9PzISPKHlpUm+x182zhiPwlkQ30vvrlc9Cbyr0OewdyGzKXuNVBGTVANubVOfnu7pP9WlGpJ9LPu7VWArk950lK9O3N/fUIobhD4tBOCzXOPzZt6wi9BLjP/s2D/y/pKaQF/OOlGwBI9ZQv0Q4gUsBAmLskglP1v/Im1WpaYvmONihknd9gsC5vcEgMV4kYfYAnmG52SxCX1uK6FgBfkp6cgcKU6UvGvh/buT1xClqyVVO+414wjsNE05MzXgQVVBH4stGPrQZHLyj2GRCjeEdCIf+dAF778hGJm9AdbNt7U+F+rwDj7pw1fLu4BKK8NOXDd2lwlint+HMF168yjBG3+Y1CoRzT97sZnRt1qBBPWprha6BO/y/ssXskqKmJ4tRsyhOE6zzX5rnFyQ6Ww89ugd1cDt2OXUyDmamviMWdKok/z+EfXLh+FbSGNboYnsZhoQOu/u2+87vawF6CKi7cAS7ZFlZxh+z/a5HFaNfyeKHauvMCApdFTphdNiqCab0kj4rc0CB+UMcU31U0vnKCIfVauRT5hcDdabYm1OQ0Ig/arafG4yUfpywTIhNPqBTSfQOmTh0kEAi3ijOJFNKrgIEVyZ+d4ptDbOxF/OPAAH8acMowx5suzbUOHfIA8GjjGeWxXjp9oMOhZOaMbKiQSCe9kFSdAhL8o4FElbYhpZxuesq5aIcg4IaYVh84Mzs3Wx/+f8UK2DALw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(366004)(83380400001)(33716001)(186003)(2906002)(107886003)(66476007)(38100700002)(8676002)(86362001)(66946007)(66556008)(6916009)(26005)(5660300002)(316002)(6512007)(9686003)(6486002)(508600001)(6666004)(4326008)(6506007)(8936002)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u2Uib9s9UOZEwP4ecFSU1DctVEfNQdkMXx4fTNSr9Vs8R2gVS0HW3iL0cgNX?=
 =?us-ascii?Q?5p4KoQqAh0F+BbMKS9u4RYSfmwNHEZJThEKnBhDE3Z27aST1e8o4EeSX2jyk?=
 =?us-ascii?Q?u9x87r0VZZjkTqhwGHtBngAWVen21xH0CR+wBY88TZimL8LuyRkyPx+SCvvO?=
 =?us-ascii?Q?MoFXq9uao0kjHlZJqD4UxLYXSFXnBZZDXoKLq/LYUdp3xhk++CiESQwaJ5By?=
 =?us-ascii?Q?4GWTtDZshc3UPQELzNhC3J1YUO8w41gIbBPElPViWCh2GxQz3wDYVqkkNvEX?=
 =?us-ascii?Q?a0DT74J+bo1En/pVvRGEm/QhkzX+MZkKL5LvlNEc3OvpkS2LLQ3G6WELM9D7?=
 =?us-ascii?Q?gotIGyVrfiee6QFsA+rbLHHJ6iAiTI9fv2DYkKOkqg8wmxs7zQFZE3K+A/GA?=
 =?us-ascii?Q?An+ye5M1uqhXSlRFVwRLMDzGYU0mqE1nQOPfF7FOyYbaqTfgDzWpFoSNYUaL?=
 =?us-ascii?Q?eQKG9u17Yu8mkb5cTEtCvVTOV3/1ZyCVXCWpluKWdqf2idcuiVJIhsoxcac0?=
 =?us-ascii?Q?kk/vOqg83gn/PIWgxcc42J5iAraYmnYglUcfKuxtZBjsBaqXBnBMYZ1rV1fn?=
 =?us-ascii?Q?UxEogm07zahXz8Je3cx1hADs6+Ccmek/mU/WqOZZcxp56EwQF6SI2UtdnXW0?=
 =?us-ascii?Q?4IxDQWi5ZCcPrnfa5gdUD21yy94pBFei39FZsKcpRQmGALmYFk9SsweZ3mLC?=
 =?us-ascii?Q?qZ28GQq7zB+Cm4BRKd4NnqEdWCLliTSI1voo78cxxB1ShRzFm7jz0MMbpfr5?=
 =?us-ascii?Q?7pO07GKFrm4jHJWBi0UULgU+vVOjM5jPxIcFR0xI4hjmLYmPDUGOnf3FRbMl?=
 =?us-ascii?Q?1yytHR41Utp0uMvPK6cUnig9fXg8DeHwYAFeS5XNCZcG6k7urKAAVOI6/6EK?=
 =?us-ascii?Q?l3DdoORSk+7wDlDF4f6kY/cxXoIZN3Oe6O1I1DS88EdMMaNXTlT7/CsRsNFb?=
 =?us-ascii?Q?RLNzg7FcIRPM7Hwk8x4LIFeWP5lmdPGXzaHL3trBHomWzm640toLCqbYpHgH?=
 =?us-ascii?Q?6E2I7NvhwSill90MBx5B23XyJW/Na5frwY9r5H7dhSqtn2osDHYx3QIfQrx5?=
 =?us-ascii?Q?4sc7QfvxNoQxlgO3mi7utHZf1vcfx3Vo2yI5vKhwT9i+m6xnhfkQoT5kmZxb?=
 =?us-ascii?Q?8cFQ+yZstz2s8jPlHYd8JZNdzw1s/WwXNUnNT6S5ivcY/h1EmOTttQTex/jt?=
 =?us-ascii?Q?I0VVCf4cSjguwBbIhHLcXi570AftgWua9bHEXzBMiF4m/1fnTFrrSV63oqIq?=
 =?us-ascii?Q?hKk5tgEfeGMJSaL4Xc0E724+t6Rb7jha84UXZbxFSb1T7b5F5W/U/RopLV3F?=
 =?us-ascii?Q?b1QCAUsli+gximAX0occCVks1JqtzGYtDvO/NzxJtHZGLhUvUOAAz30+bvSJ?=
 =?us-ascii?Q?4LyBKtZGHQWO6lGezQSUeMiSQt2vYveEeuUkTxxxX8VLFp4LGgVEmTARUmrb?=
 =?us-ascii?Q?RY27xfZTWnzVvPc8aPxGbRRfljxV0c3Ei8zQ38J+r95sGN83DIE3bO541g3s?=
 =?us-ascii?Q?3cQjhSBB7AXSxrdmF8DipvYIG8ZtyN4LO3jh2cOhBUUPFGWa0iMH2RiY9+KZ?=
 =?us-ascii?Q?elkTP0riI3LtwjzNL/hJVVOt+yKvOTLoTcygYqEQSoxkxMZv5moCcqerljvl?=
 =?us-ascii?Q?n+NKFXmsnwiYFMFuiv3u/vuW35EzSVa/l85tlZrIxwR+MzKaHAUV/Jqju3o0?=
 =?us-ascii?Q?tn5dPYqYosgyKG+4fNGgzzc1ThOKy4CNn+rR9VEnwb/QePseafsbnlmkLvSA?=
 =?us-ascii?Q?JyRw0qjuPA=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ec4d8d4-853b-48e2-965a-08da4edea5bc
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2022 14:52:19.7902
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3eYz8znus7nqdK+0/KWepZEZBGqZoux9JC/m3pOJDg0P6wfPoJl3HHsAmjlj+r/MaSNeAoVonkmQI9+ros6pUw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR12MB1780
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +int mlxsw_linecard_bdev_add(struct mlxsw_linecard *linecard)
> +{
> +	struct mlxsw_linecard_bdev *linecard_bdev;
> +	int err;
> +	int id;
> +
> +	id = mlxsw_linecard_bdev_id_alloc();
> +	if (id < 0)
> +		return id;
> +
> +	linecard_bdev = kzalloc(sizeof(*linecard_bdev), GFP_KERNEL);
> +	if (!linecard_bdev) {
> +		mlxsw_linecard_bdev_id_free(id);
> +		return -ENOMEM;
> +	}
> +	linecard_bdev->adev.id = id;
> +	linecard_bdev->adev.name = MLXSW_LINECARD_DEV_ID_NAME;
> +	linecard_bdev->adev.dev.release = mlxsw_linecard_bdev_release;
> +	linecard_bdev->adev.dev.parent = linecard->linecards->bus_info->dev;
> +	linecard_bdev->linecard = linecard;
> +
> +	err = auxiliary_device_init(&linecard_bdev->adev);
> +	if (err) {
> +		mlxsw_linecard_bdev_id_free(id);
> +		kfree(linecard_bdev);
> +		return err;
> +	}
> +
> +	err = auxiliary_device_add(&linecard_bdev->adev);
> +	if (err) {
> +		auxiliary_device_uninit(&linecard_bdev->adev);
> +		return err;
> +	}
> +
> +	linecard->bdev = linecard_bdev;
> +	return 0;
> +}

[...]

> +static int mlxsw_linecard_bdev_probe(struct auxiliary_device *adev,
> +				     const struct auxiliary_device_id *id)
> +{
> +	struct mlxsw_linecard_bdev *linecard_bdev =
> +			container_of(adev, struct mlxsw_linecard_bdev, adev);
> +	struct mlxsw_linecard_dev *linecard_dev;
> +	struct devlink *devlink;
> +
> +	devlink = devlink_alloc(&mlxsw_linecard_dev_devlink_ops,
> +				sizeof(*linecard_dev), &adev->dev);
> +	if (!devlink)
> +		return -ENOMEM;
> +	linecard_dev = devlink_priv(devlink);
> +	linecard_dev->linecard = linecard_bdev->linecard;
> +	linecard_bdev->linecard_dev = linecard_dev;
> +
> +	devlink_register(devlink);
> +	return 0;
> +}

[...]

> @@ -252,6 +253,14 @@ mlxsw_linecard_provision_set(struct mlxsw_linecard *linecard, u8 card_type,
>  	linecard->provisioned = true;
>  	linecard->hw_revision = hw_revision;
>  	linecard->ini_version = ini_version;
> +
> +	err = mlxsw_linecard_bdev_add(linecard);

If a line card is already provisioned and we are reloading the primary
devlink instance, isn't this going to deadlock on the global (not
per-instance) devlink mutex? It is held throughout the reload operation
and also taken in devlink_register()

My understanding of the auxiliary bus model is that after adding a
device to the bus via auxiliary_device_add(), the probe() function of
the auxiliary driver will be called. In our case, this function acquires
the global devlink mutex in devlink_register().

> +	if (err) {
> +		linecard->provisioned = false;
> +		mlxsw_linecard_provision_fail(linecard);
> +		return err;
> +	}
> +
>  	devlink_linecard_provision_set(linecard->devlink_linecard, type);
>  	return 0;
>  }
