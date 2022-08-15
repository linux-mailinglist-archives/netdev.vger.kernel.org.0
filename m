Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 930A8592E89
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 13:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbiHOLzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 07:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiHOLzW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 07:55:22 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2072.outbound.protection.outlook.com [40.107.223.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7395F5FCB;
        Mon, 15 Aug 2022 04:55:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D6JHZwTKoCZtyuau9VAp4hI9KeOtlAUCMFNU2uuvaZnGOFTcaYKMTGSoRq9ugeCxf/7/GG2Sw59ItW9dENWO8Ai2qfaRUxhQgJSUrJeUEhT5O2bxCRfyilXpWv7u12uu8Cm5rjafSQBtgKy5xq03tV0emespAo8ePiVzwsYDE0wChEL8t4Bc23dre8a0ca6WY1VE2UN2GstuCxOWeCXR0cUOSMpvoIPeCagGb2hOaG+E6agfglB9bB+4Jtn4PyCtNzzUBIER6d87QUnLKZ6l0YX43YIP/Zpz573aAcHO7e6+Z9zev6bcAwKzOJsReImNprvHMwmLaT/LouOCtjm1+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yze7MYTiJqcw3c0eRxQX+SvOMM35pFGWCdUgYU0nWnk=;
 b=TaXIf0SI9BiAUlXj5N0dDDnhsEtQObR0ZYAVm/H8FyqHXMMUe6PssR1r00zo+0cF1jSwvXiI26xsWpc6xKoxvgOE/ti8u7HsRbvOrWOYPFGnKUi+XMBWAP26DQZx6eM7MpP9hnL75j3lvqHoXFINMIL2IMLZN3m4szYKPVmjzlJMQ88SFvRetWSwmUNaU5MAHGxmORZ4gUShMt9urnyfKr9iQUkAkbgtrQDLqn91UvBQXNiit/kTE/0O96oBnVx6zZ+O3M4Wh8DL3Oq0lKLRvWjvON0pVB7T8bwBC6qNFckocx7/79qB/R1PqtSSTHFfnU+IucUhfeSzjGrV681OkA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yze7MYTiJqcw3c0eRxQX+SvOMM35pFGWCdUgYU0nWnk=;
 b=mh01m7uQwcaRdGC1QkS3z8oPrZhZuOeLl9S3aN8yuVzq6NQSWDnbCSbUKsA+FonQNeaQUJXM6VCErNAquzAojWgIIWP4fUknfBAeueuBw8GlO0osgLoS28oCOtogs1SwXnBA7ljlK9aIP0+28p9geIwsXajVVbAAbLEvCf/KNrbZyxALQgvHIOIi9fyruAu5i+bcY+vyqNn8t+5CW0wSmfbN6PMq/20pLSc43OB9uXrxHkna7eOeXw3AtjF5Pu20n78t5o2hwtyxgonB385J5dQi83MqnbH0cFt2pLOxJWSuVCSMPWsXlrWf9PCeq5s3el7Q/k7xa65eEvkx/Mwb0g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB6163.namprd12.prod.outlook.com (2603:10b6:208:3e9::22)
 by DM5PR1201MB0108.namprd12.prod.outlook.com (2603:10b6:4:58::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Mon, 15 Aug
 2022 11:55:17 +0000
Received: from IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::a52c:c6f5:f9f4:59cc]) by IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::a52c:c6f5:f9f4:59cc%5]) with mapi id 15.20.5504.027; Mon, 15 Aug 2022
 11:55:17 +0000
Date:   Mon, 15 Aug 2022 14:55:13 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Daniel Lezcano <daniel.lezcano@linaro.org>
Cc:     rafael@kernel.org, vadimp@mellanox.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vadim Pasternak <vadimp@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v2 2/2] Revert "mlxsw: core: Add the hottest thermal zone
 detection"
Message-ID: <Yvo0IWgDQ0wZ20g6@shredder>
References: <20220815091032.1731268-1-daniel.lezcano@linaro.org>
 <20220815091032.1731268-2-daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220815091032.1731268-2-daniel.lezcano@linaro.org>
X-ClientProxiedBy: LO4P123CA0588.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:295::18) To IA1PR12MB6163.namprd12.prod.outlook.com
 (2603:10b6:208:3e9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1d1f3c1-360a-4d3a-4e71-08da7eb5058e
X-MS-TrafficTypeDiagnostic: DM5PR1201MB0108:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IohPBlowZqFbNCRNEPDZaisnsk6F7+z3/ZXCuk09HHrgWrJiEwXZOp2PfaBRTmoFI395hrSgtqgIP9ZxHKxVDYeN18sUKf+TZ6j4OuaFmWjhLEd46GJPEk/od+aHA/Iu/7EbkSVr+4q1AjqrgDynKm8WxbZ7O83IK1+Rt7DVMRQwkAb+TUt1okHILBdsf3PVHTutP2xHKzDc7Vmlkzl65TOdUkFqrFxzQmxIdCELChXiDc87PyoaLZtCHyFXv57vvwupDiZ+K2MGjCNYYGd3UYw7Xc0LBb2SCIGznhjpdngjT7xGK/bW0Ua8SFWAlqMT0DRqtbcRsZGQMNoeCR+wILUCRnQbSPzBVe5mx4Etz4JljB6DuPP13kIfYwU7Kn6QtaAYSjernStZxQNdNnYQU7cAZl6DoAwoFwHOsCFGWeH6iMNIICIOpcyt9tASN+n3IdT7Mnna8CWAlSy5QY9e6qghGw3Qk9VZxAED9s5B6P6lZdtIe1WsCTF15i/9BoMTgzj4AhtaWBOnEC/LGq3OzMcdBsrcPZcFf9WazkrB56aTAGdlgdFYOPqqRUFj/HY2srWpXcfDDK9jkSEKQfzQg2Aqcb/bfPHpV/Bgxtw4LsZtB/jFwOHjh6EkRIdiLxuodVBmeDjJzjvqpDb7L/y9vE12rmVqh/vitDBa7GkL3r6QAvChdaQfcgfNP6Z4VctZr479HZG2bXCAPtHMJ+mMk8N/hqCx6GDgSMJWs0KnUczFC4VCSPGacWOGs6Nml9QYwpzNCM0LVo6SC4JoT7/txxllnaT9N2Y3OC2mujtwoXDVZhw1l/h6Gpg0W/FbX7sJS+WZWT5JU+ONAZIsZ/Y0GQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(366004)(396003)(136003)(346002)(39860400002)(376002)(54906003)(41300700001)(6666004)(9686003)(86362001)(6506007)(26005)(186003)(6512007)(316002)(6916009)(33716001)(4326008)(66946007)(66476007)(2906002)(66556008)(6486002)(5660300002)(478600001)(966005)(4744005)(8676002)(8936002)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xRqAD3FOvis83oSTJyynSIMX91AiP9hJTFMjJXWy5V0187SJpa0NBNfGPMZ7?=
 =?us-ascii?Q?TIFg0gNtkaiQOaWD/jdXgTkU8cHiZesVWeExlzs1/fzb/wibGKyYz6hNGOVx?=
 =?us-ascii?Q?wnaISVME6zGMJmuSQqmDqDZrgAEwTZZY6gsdgh1tBmVtLhXrkwHx8eWP9Wcg?=
 =?us-ascii?Q?q13jk5cphGhj/Bm3GGmSo6PT9DCegni36szJ9cKKp+0Elt8oS1QTf/qxJIEk?=
 =?us-ascii?Q?2RLJap5KM4XUS3U8SFKQRG7bmGkq3SfZLAPxe6DDqu5cbed8xyrx2IFLr3xX?=
 =?us-ascii?Q?1B4phHFV8bYxKZ+AGGpIQWnEHv4AFkyQBPEYtFDzassrmiGwjsrTWnvl9yPR?=
 =?us-ascii?Q?Q8qgb6ObgXCmQNjjxoHBzERkWBBMeGfNg0L4eRU35uiOOEmMK3iaq2Y3bWNx?=
 =?us-ascii?Q?hX9R+AommRhOI6YoZoUi978DoFQP/c/6vgJo4Ut1JxyMebBwnIV2PjeHpOIp?=
 =?us-ascii?Q?RfXDudChFcx/IcvNqWDAh7tNV+O/HVqTsBtkGglK/s+ANBwzUVDnyKzvbZhU?=
 =?us-ascii?Q?Lodlt85W6llDEyclNoFNmLisariP/7Kzk4Otf1CU8VsdbTf+3/d0seViRdSB?=
 =?us-ascii?Q?feL6efTYZ883QoKQXeke76iGehQpgCf7LOrr8YDH4ckMwheUIgSJLzqwzASX?=
 =?us-ascii?Q?PH5DxVu3qPYPVL9x08+MlEowWd+HmwcjjGNoxj+0WcO/4u41Ui/mMbTXR/IO?=
 =?us-ascii?Q?OKvJGwxA1LIGYFO9tOl6iikPicFjz/3Xvm5+wjFQ6VT1lFGxKDkX1Qe+aseR?=
 =?us-ascii?Q?Q70HOwcojnSUdLN3udHL76nsuY/6UStUxZRLEMlytJv8bAJDUPvqDVcGuArQ?=
 =?us-ascii?Q?iSRipjZ9im0zzlCRGo453/SN0rKFTYT+FIapYiHusd/Q+C1hgTbA/Z5FSH/x?=
 =?us-ascii?Q?0goaX6nlwxb6H6M8ZmaDUxky3p1yfAYx+G95F6W2d1h3loO8Wtb7UvGEWR6Y?=
 =?us-ascii?Q?tNGeFM02C1jKXHmqJIitI2/wIDQ69CEQJpnEE5DCvSO6HmDV4VWmbRVJN1Be?=
 =?us-ascii?Q?kizkw0B9Ji4uOe+pv3175HdWjCdLN1vY9lzO5eBuaGMkL/VAMKkDYbMZDprL?=
 =?us-ascii?Q?cen/isXQbou1hELUN7Oero3S9dIEkBuL0iU7D92LjFp2++uK9uSkysmtML7U?=
 =?us-ascii?Q?3HxPz72sdXARgkNmn7aUbu/fLutHvFDBGBRuKhj4XBmEXE4+OR+MiMX4MPCk?=
 =?us-ascii?Q?titEfjeMuF/6vgLxG80J0IaxgLrpCO/PnoZHGN0szs9Qx/uCmOP4ZtCFdkX9?=
 =?us-ascii?Q?ghem034kX5z7eiQwKV0MQjFN37LBcaWvMnfpwOlAkqN73rN3iSWGlqjsbYmO?=
 =?us-ascii?Q?/eJMv9P0trHu/TISjy1EWFMnFdCo+uHPu5cnoh+LsOkkKht38eVYBCR9br+T?=
 =?us-ascii?Q?oNPlAEHLqEQc+47wSAmQhgor3eWdMIzCpzgoebkMwnGTJQVW6eN7QzUUf7fO?=
 =?us-ascii?Q?hfkk8As/Vphg4OX3MPFSJ+wDyMe+QKsyV6KZv7V0poFDZGwPgBnx9WBeAKNt?=
 =?us-ascii?Q?N5Jm2ZriyewBnrKKK7cCaVZ9eIccJa7ezeAdujn1q4g+MEhlwtgbrvwdE8aP?=
 =?us-ascii?Q?PUj35N39+hdIvvCYmUIjLdFiqSRYJsqZyCvA6I1I?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1d1f3c1-360a-4d3a-4e71-08da7eb5058e
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6163.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Aug 2022 11:55:17.4676
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +gwBhzhHJ5ZzFhUxITfeqz3X4r19SHZiMBRa77hQjwcIPWw2bajZ+TrAMGDyOAlV5mi7jn4TeqbgTdKFF88aOQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB0108
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 15, 2022 at 11:10:32AM +0200, Daniel Lezcano wrote:
> diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> index f5751242653b..237a813fbb52 100644
> --- a/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> +++ b/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c
> @@ -22,7 +22,6 @@
>  #define MLXSW_THERMAL_HYSTERESIS_TEMP	5000	/* 5C */
>  #define MLXSW_THERMAL_MODULE_TEMP_SHIFT	(MLXSW_THERMAL_HYSTERESIS_TEMP * 2)
>  #define MLXSW_THERMAL_ZONE_MAX_NAME	16

Which tree is this patch from? The define is no longer in mainline:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/ethernet/mellanox/mlxsw/core_thermal.c

Getting a conflict when trying to apply this patch

> -#define MLXSW_THERMAL_TEMP_SCORE_MAX	GENMASK(31, 0)
>  #define MLXSW_THERMAL_MAX_STATE	10
>  #define MLXSW_THERMAL_MIN_STATE	2
>  #define MLXSW_THERMAL_MAX_DUTY	255
