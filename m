Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88F7457B4B6
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 12:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbiGTKqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 06:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbiGTKqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 06:46:35 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2076.outbound.protection.outlook.com [40.107.92.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F8C95F981
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 03:46:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=me3O5hlun3e2DTP17CGjsA58zTq2kFvqob5XICe7Cg4Zc1IsMuf1NwOlPh0LrS/JN2+i7maBQzfjkJAjA12+klEjeJS2lKc9E9OdKJbwQbXc/PgBmCoWB38JtXKYeAGc9DluJy1M4QxshI+qmYFYznc/5eYdNKJ3y8zUVBrC6oV1IIGCDx0VzgiO/NMqb2WgV8XlSkWsMJRN2CMO0Ona+/3iGcExzBQ/ccjEoSy7P9YdebTldbob5AV66KzB3rBe569V9vurrsva3y4p4sR0unix3J76UqijY08zrJZJtkODjH7QfEIx51VWtN7G+lSMmcH7e3d5fE6Jx/RTEh/EdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=08/1KMIl4XRdm5mRvnRuSknz4fYR+5L0GO4WgTWtCy0=;
 b=Vjtk7etCAHmG3cQ7gudVQhaN7Kyk7+mZ9xdlh6jtGYIqq2Ng0gGw13VjMKBZXYn4DWDOLx0rymafL24IHSNZ3BQMlQTtSAGyn4jh8SvXSarxPD/b2C0jFZfqEAqYas5i61mON5sxuyEA4LT1XxPO80BtdAbqGxjq8bco8lCyHMUyecoUFq2uLzaADVJLstENouNdNAsIFA3fFxG73BotUuhEYOl3FzJI0qatSsybL4tfSvUZDOAx3O5/wPcax9WQTW0g6A5wucuLwNCvVi0R/k6gbhZNGm+9FSC5PwziPQGYnwYU4eCo9E5xzbJkCDX5lW9HZl3u7+xtXtZoOik92A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=08/1KMIl4XRdm5mRvnRuSknz4fYR+5L0GO4WgTWtCy0=;
 b=bhPktWl94Y61LMCISj2jVq5gqcoWRsoW3mX3agzpy3KGVx27fKV6P2MsRa6qFFvwGBXYrAPavFNxeg1Z/BHcVvztRHG4qTzTT/uDWr9MYcUPW8HsxFinQW8NMM/hNfJgepSPMzy7MLHsi4N2IPdVI79ztVwun2fPdH8c2Sulmd0nqxLsSHMULL4aDWsR92frQJriXz/e6QS39t0//AfPJ6s5bqyBaaTr7jw6E0UURO84gKcS5cyvYMovxkHbXFa5kg0RyRFKhuR3anYu/E6NVb/FNB2nMwIH44tmdruL5nb3tqHC8L8jZ6CN/icyeYzEXxnde7XUDhze3gH0A3NW6Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM4PR12MB6062.namprd12.prod.outlook.com (2603:10b6:8:b2::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5458.18; Wed, 20 Jul 2022 10:46:33 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5438.024; Wed, 20 Jul 2022
 10:46:32 +0000
Date:   Wed, 20 Jul 2022 13:46:25 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: Re: [patch net-next v2 10/12] mlxsw: core_linecards: Implement line
 card device flashing
Message-ID: <YtfdAenTfUa+EyL2@shredder>
References: <20220719064847.3688226-1-jiri@resnulli.us>
 <20220719064847.3688226-11-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220719064847.3688226-11-jiri@resnulli.us>
X-ClientProxiedBy: VI1P195CA0079.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:802:59::32) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8a462069-2030-491e-043b-08da6a3d1c25
X-MS-TrafficTypeDiagnostic: DM4PR12MB6062:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7zCdNByArjIb6AFsKLbn+S6K0RF+EIhcIz/zmfgnRJY86yfzwGTqAT0TvOlCgrzfgizIl7RqXCOoO2Kd4RTuFNxbQ+DZMKTKtA/+5qlQ4i57wIH9L+EXN7fgg0qSRzaxTts+3C/R+2D489q8JFEVd97iTFgwJZnKwam8aOgTsTLy881VF/+kMp01HdlbCmWvdCBIT8xsBFTpWzs8RUh0TS/ecxirOgfTRCP37/lYGRZhJQxSXOqwJND4PfI0GXShihyy3krbZvEhpelY6igsZAzWUbeoKU54wxP5/fI8D4vqOjVtmydUkjTID5kAbdl+aZM0h4tNeUxJC2wKY3XUWa83UaLwLJu6cszQ+EvvDwfbB/nbHafaAOq9o4JaN19GsDerLZI1RmOCZo+bf3lCBlZSO7uramdQlHhAw2EER+S0l0OJ/T8FHxTDmdZem65cAV1OsHNLVlGz0E5Be63mMko/iA/wHl7eTTwnvM/D3gDsXR3saOtcj2EJZb31z2DJ3+7eKdqegYgoaArlMlIqnRVf+5gAnGgEJJ0smbzWnN+GKCO8ziGZeF22H+j08eXK7Y1U/ijNsUgSwDnizZFrAdSnjxm6oGUj33R3xEeIZh+nvn7mDh8Ocx8TvXl4EbsKuMhW87pvSBsrmuyP1XKyVi/WhaGM4ZhwI70Oz/zXO5IQy7JNDAht+TfSj/JF7qkaXU7/fDDqxTvZNo52Iqxsz2OugrfYBBLqZEHn1SZ6w82iYCRown0y27K9hBLpb4ASH3hpPHMWsYTyjwy+uGMDK9+ieMOuliozY5kFx2D8X6k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(346002)(366004)(39860400002)(376002)(136003)(396003)(4326008)(41300700001)(2906002)(66946007)(66556008)(66476007)(33716001)(8936002)(8676002)(316002)(6486002)(19627235002)(478600001)(5660300002)(6916009)(186003)(6506007)(86362001)(38100700002)(83380400001)(6666004)(26005)(9686003)(6512007)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dCcauH7I7ujbDTfSCWhvqMfBjgiRWFMAnckIqBXMfcQu/ZQYAWkBeFwJoL1F?=
 =?us-ascii?Q?cB9ynZVImSskF3W+6i2+KeHATnWLa964v96m21laKnnjMK60XhIvv02xR1/S?=
 =?us-ascii?Q?/H2anyREqQNphKS3WcHJkx4lrw5bcD5R05YO31oe9rdStDptLI0dCxDZ56Qx?=
 =?us-ascii?Q?egLNKgnVi22ag2WpX/r+RISZQn+1vU7+ttYh3XcQqzBajRPsztro1ic3K2XA?=
 =?us-ascii?Q?vrW5SZYBQbm57qKaT1burGtBtvLuQMTSfUnopeP8Z+YxlI7Ll1kb22CKR9v3?=
 =?us-ascii?Q?gcw8goK+LVy3mh+YLRV5whSu4QWD+lrsgzwkoPvh7k+pmYpHyFJgeyq3xvdL?=
 =?us-ascii?Q?CpvnpWQrJO9OQ0JjOlEqwNeq14xSuwzMx1zgEZZgHzv2Wxh3Gt0FxHcNIkLu?=
 =?us-ascii?Q?HUwNFB4/lln6tgVte5gijTwY/awOG5EfbeX5vvESVrojbHtTrtXKR+yq3xsG?=
 =?us-ascii?Q?dQ4IftSdS/0RBGT8yAggN5T9yt7//NuthnnHl05f+azG6lZ5rIRKE4q8mEnP?=
 =?us-ascii?Q?k1NZCv3kU4s08qu86Sk8KpLhOA58bauGdma6wYfI/bUoBHrbmuh7Zo2IGEHp?=
 =?us-ascii?Q?tx5W1jpARX8gOBr6ycTxbTO12EyB5nyt+ZD8Truq37JaHqqHRS+IxFuyQdfn?=
 =?us-ascii?Q?4gfz/Di7Uvtog29oh95YFwu8n4cLqgU1gAE9PNxwGyTBFZnUdoxb2SqsXcXD?=
 =?us-ascii?Q?fDimbM66BMgUB6QAPHIhI2lk5lzCObjkBfa6JB0S+Kq7nCSlPPNMrDwT85io?=
 =?us-ascii?Q?s1IXNZ/UtHVLsa91nT5gW8Z/1zvlM2YnYMRTkMoNOfOejXU03Jz2RSh62Oqm?=
 =?us-ascii?Q?PXFObSl0TN6BQlelA0IQQSwhncFjeKnYX5Xbe5Q705wOz7qjDehF7q22aRur?=
 =?us-ascii?Q?4hVKmLNrwGqOV+xVZsGoMt6H1RJuBN2ia8BFps8VJhyZ9QbOBERCWIVvijUZ?=
 =?us-ascii?Q?JNHLCcskEhG2tapgItPXvaRLvdquVuIjGqmCQbiZF2G50QV6vmRcuZ/Nnni6?=
 =?us-ascii?Q?zoCLRihzU2Ba4PVN9lRPiChVT7Lp0xRDhFGqu8xDQG3QD8Mc6fmx2nlSW5UV?=
 =?us-ascii?Q?yz5dzqUWFxVmESljwdYeXCaGYSQEQpHQkn/+/54rjbl1AKg57Goyk/LNFNf/?=
 =?us-ascii?Q?RNxTWb686T0LM7AqYp5TsiWTOo8k9bi2fkEqt96br/iCaTCdgAH2wGRFhbLf?=
 =?us-ascii?Q?5UTPlSRw9ibzXvzGuMCZcleZjBzh9B+0PCbMZ4MZLUIGh4ecFi+TfEcCs2fs?=
 =?us-ascii?Q?M+cHsKGGhsJn8MfzipjzqfWGq1ePjzHBkfDfcVFuMMDPhpgEXVQqwb7xt84i?=
 =?us-ascii?Q?lMTVvzfNRIboLDf2GvdZPe1K9QQ+ilekADiNYNirn0Osb9ydMrEs6IibJOZP?=
 =?us-ascii?Q?9/Z1XK1ALE5PGZVqGYuMRn4fIUQVUomeCDXkLCAFsnmZN9xH2Tnwh6G18f85?=
 =?us-ascii?Q?eLC9Mpu6j8GZi0qLwOofO8NMbV7IWMUFruVi6rd7GzVqoE8qPZFrdtXu/OD5?=
 =?us-ascii?Q?dUBDwFhh5oZvP4Ek04/zeebxsCp5szRWSCwwaDdV5pDbhy1uNWXE6s9JJIZh?=
 =?us-ascii?Q?nPYZV6XUE8pL8Z0yqL+iSP3Q8R8ljYElspO6k2AU?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a462069-2030-491e-043b-08da6a3d1c25
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 10:46:32.5192
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FPgtRon+fjAboOpvHERzfeCv0GNFTVaGJEP2EhJL//XLfgg4zPpLzUtOmKILFrqQbCROpLBiF1AeP+YAK/JLLg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6062
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 19, 2022 at 08:48:45AM +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Implement flash_update() devlink op for the line card devlink instance
> to allow user to update line card gearbox FW using MDDT register
> and mlxfw.
> 
> Example:
> $ devlink dev flash auxiliary/mlxsw_core.lc.0 file mellanox/fw-AGB-rel-19_2010_1312-022-EVB.mfa2

Need to mention that this is only possible when line card is
active/ready

> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

[...]

> +int mlxsw_linecard_flash_update(struct devlink *linecard_devlink,
> +				struct mlxsw_linecard *linecard,
> +				const struct firmware *firmware,
> +				struct netlink_ext_ack *extack)
> +{
> +	struct mlxsw_core *mlxsw_core = linecard->linecards->mlxsw_core;
> +	struct mlxsw_linecard_device_fw_info info = {
> +		.mlxfw_dev = {
> +			.ops = &mlxsw_linecard_device_dev_ops,
> +			.psid = linecard->device.info.psid,
> +			.psid_size = strlen(linecard->device.info.psid),
> +			.devlink = linecard_devlink,
> +		},
> +		.mlxsw_core = mlxsw_core,
> +		.linecard = linecard,
> +	};
> +	int err;
> +
> +	mutex_lock(&linecard->lock);
> +	if (WARN_ON(!linecard->ready)) {

Can't this be easily triggered from user space when executing the above
command for a provisioned line card? If so, please remove the WARN_ON()
and add an extack

> +		err = -EINVAL;
> +		goto unlock;
> +	}
> +	err = mlxsw_core_fw_flash(mlxsw_core, &info.mlxfw_dev,
> +				  firmware, extack);
> +unlock:
> +	mutex_unlock(&linecard->lock);
> +	return err;
> +}
