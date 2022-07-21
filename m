Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4C157C634
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 10:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbiGUIZz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 04:25:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiGUIZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 04:25:54 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2040.outbound.protection.outlook.com [40.107.94.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B1AF18B35
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 01:25:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LxfTmq7YteVcrnIrNTUWQ57sMOPEfwuHoD808QKsYcUJHM98743U2C3cOmEO7k7tVfESRWJU02eAEnfgyyIwJmebtDZhYQeD4xpzcmJvu4X4qSxKsodsu42T2D5TLdDCKKJk1mP9M5E+EElVmvBbns29LTB52rj555mESdYhoJKXxpeqatlLCPLT3GGH6qo/eLgEA0fY9sl6awwTFXajmPdQ17jOMc9hrkLju4vdqYI3AHZQmt2QP4BAKgVkYpm7LDtjcnNPS5/RNEcoVXr2so1/DozlsBHUKZH7XbkaDxlQ6SAoOZTdp+BqUJ+IK02b2HSTwSPCX/oKd7IMgXyZxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N2gHII8xKFM+R1WBsjTjUsCAc8HBTo/LgG5vfuQmL8c=;
 b=agl41Jo45FdqKDhZVVeV0MWWGdYxHQuUEmz3OpZdY7ppwJ+OiRiT1uOIH9pWlLolFsZHfljhzdwAvI4VlStMZ2H50+eWCIU94iDdZykPS/Y7/Q8EepW1WaTdPmHXzfVupxlUX9hDTF6LT4IMhs84HFUGE90yq08AO0lU1v+FRC0XIMkleFR/UaAI2SeozXGSkBsdBxsdWxkMsqBDAane7lKo1RSzJ2it3g/fNLjArfiDEBvYI1k+vwaJhKFNSPovMRjNgg/fmN8lO+FFYWksfGVIHXiYVe8HEqyCkf+X3kR7GfCI+I/jzK3lL/MWRfj/jXCsYPiVF/S0y1Go4a+Uhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N2gHII8xKFM+R1WBsjTjUsCAc8HBTo/LgG5vfuQmL8c=;
 b=YL2WWCGZO78gFd+Qf3QuQpmbBcUTtNfpyVelHRUQA4mdX2zIIYZwUC2Er585edTR+Pvua94fw9ZH2wOvT9mpSSHjyucxZbhni9uV3Kg/3LOZY4vNHBSaBiGfpXKtCvzYfLYKsyFkaV6PiOywjJwg2B/Ks1tsgi4ro1vXqeK54tGJNxA3+KH1Tgx0/XLp3roSYtY+A71jF0oAyXIUS+UXNd1ZUviUPQ9P1jz285GJFFW4Pnaviqv/QQYbCCFVTuJFVDEtz6cTyPdyjmh9A3sQxYnM+eaEyNUxXbcZOlLELqjZcEhZV5hJKcXUQPKfRJHY/AgMLPzjxWjcPEQW98jGFQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM6PR12MB4909.namprd12.prod.outlook.com (2603:10b6:5:1ba::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.19; Thu, 21 Jul
 2022 08:25:51 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a525:8fcf:95ec:f7ad%9]) with mapi id 15.20.5438.024; Thu, 21 Jul 2022
 08:25:51 +0000
Date:   Thu, 21 Jul 2022 11:25:45 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, snelson@pensando.io
Subject: Re: [patch net-next v3 09/11] mlxsw: core_linecards: Implement line
 card device flashing
Message-ID: <YtkNicMHKuC20RIQ@shredder>
References: <20220720151234.3873008-1-jiri@resnulli.us>
 <20220720151234.3873008-10-jiri@resnulli.us>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220720151234.3873008-10-jiri@resnulli.us>
X-ClientProxiedBy: VI1PR0701CA0070.eurprd07.prod.outlook.com
 (2603:10a6:800:5f::32) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 10f48742-5dab-4f9b-5207-08da6af29f77
X-MS-TrafficTypeDiagnostic: DM6PR12MB4909:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YtSjVYkbjLkal0HL00lnlfqfwiSfKZy9PA4/52+1pzAZ0pypwWcETy4FD0Yahsya7adBktUvRs7H5mfbdovBC8bn2P07F+0pkQ4i2AX0qxzd7QF0yuLq5Hk1KIlioCV5jhvLjsDuD6Ckz8UcD81T+L/W8i8KZZqEyvFruQdrnTYBZ5qIIK1PDvERbQX4oPkVVsxJUP4biJ33moWLq/wLwGHxrQnUDr3LTweIgmdrF03D4BkxKgU1Tpqjpibd2v0yc2d+XEW/NlTJaVY5WB9uA8vVvbt/754VyLBD9T/ENeW/eRL+mY+3JHhuepB7qM1VUu+K55OKMNlC9Look01wTYfVlN3hhgMNcG72gr60j9WjTjSmV3iyxbnN4p0dobj/8kLCJmtQmI6KEaSFcJtJ1YmqwpvcvF1VJo39wKLCL5a8gG++vthOOE9ApUKGlDfb75/2azCbgW7CIYCmkgmYJ6m3gUVmPylKb+aaX6FUhtvziPy0q/asB7O47GVf/E/cvW6ooRcO9WnZ4nvVjR5vD83TaRIHetaOZkFsKPW0nIN3ppSvPWw7KgZxxD9mEX4dSgMxtZPqkY4cl71j6GCSKsCznht06QREBegSQmfA+rQlPKp/PovdVZQ80Uw3/em576mXJvlbzBUmqUD0VHtrL1gsSPF1B04deEfgGz6KEejZbgJATq0EBHZU1DX+xtVrBfLSFd3mY+By4KxdWH1C++pLnE1HsDeg7cHq/NLgiRfbASYX5rSBodlA4KHmZ4Wl
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(39860400002)(366004)(136003)(396003)(346002)(376002)(6666004)(316002)(9686003)(6512007)(6916009)(6486002)(41300700001)(6506007)(83380400001)(2906002)(186003)(5660300002)(38100700002)(86362001)(26005)(4326008)(8676002)(66476007)(478600001)(66946007)(33716001)(8936002)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?OPV8io9LggRN6QjvJBgXXVNtqm2hHGn8ME28i52oA3pnaLtUbVngcmrYfeIp?=
 =?us-ascii?Q?LQSNfw8QBT1NFbd3lgOXgABfnG9/h0i4QgPBhUBHp2zbcChGoTVPBumGXIlc?=
 =?us-ascii?Q?2yAikDegFs7FybuoHz4M4bldAuuJDQBRSNHU8cGJOZGO7GL9yemumymngdf1?=
 =?us-ascii?Q?YA5QYu9dy/AgENei+3ysPwSQkfWV9f4M93cvHPw36sYd/GUOL2sD7Vxo/aqv?=
 =?us-ascii?Q?GrD/YfZpAKD1BrT901+gFNxKsjm8J29JgMAaHjiumvGIgEECR4v+CsddxpfA?=
 =?us-ascii?Q?cZibxlqiSvPVxIJVyX32smYg/H3i9H6PXrwQhDQJ2uNUlR+7iLp6iw/9YJP3?=
 =?us-ascii?Q?EOB2oKeKU/DpKxxiAJSfDE/XivU8j+WL0fAJaV8EO/7shim1iLd/KMoP2UF3?=
 =?us-ascii?Q?MvxwTG+hny8x4WG9//PvRwRHCGYb/zLa7LNrWA7W6iqAAxPr+XgfQPqnMaj+?=
 =?us-ascii?Q?uG3D8vMjndlbceIj+syPjYk1sQRiJbJ4DkzKVBGmHAehgJtJQfnB9Rxd9+0r?=
 =?us-ascii?Q?DGRKFSp0Ru84bmNco6t+fuWMj4dhgj4MH/B/VWYyv590/VoMPKgt5ogpfUOm?=
 =?us-ascii?Q?6fYT5gxehZkeiCe7fCAPbY1zLL75Idc0XB9NWwgxgbw0tpg8Cg2zd7FtXfuN?=
 =?us-ascii?Q?ovTQZ3OOBpwkF57aizjuLHtInpkHb4Ucu4XNoffxvUg2yA6xtWB5Hiu7nOI4?=
 =?us-ascii?Q?DEfKbtVa+0hoHNHtGuKat7zMO5w6HOgcwwSQQdNMrvLgINlaBKPKrgnYDLK0?=
 =?us-ascii?Q?y1sjgRjpPrjY14gvgFDxS9ol8lUZDl5IkaALXxuK2kmh3Mwe6haT0qTZjit1?=
 =?us-ascii?Q?94Aa4NUK/79ShsxH6O0bPovD9rE9nrruN81wG/tz3M6nr2ZHFWT+cKwRwzNA?=
 =?us-ascii?Q?MtvdgqB2KNgTJXyquAbMWfocA9kQKEWtzJjPQkzvvU6pWP1fuQhVcLH6uA9E?=
 =?us-ascii?Q?msRyIIGKYMKjADmEDjwQxisTIBWdiGFoN8xQw4WupiIzXJYj8XraOOfEYin4?=
 =?us-ascii?Q?HcTYpUkBZExxG5x/sLwaZbk1RKonBmu3vTJbwx2YLI49k+k9gJVtpAd+fOZa?=
 =?us-ascii?Q?w0iOq0n4nrXKeKaVx0lUNikWdI6AH1+bPVbL49dNzN8f0+N4PUB2ycOVBoji?=
 =?us-ascii?Q?S3t6iBuI8vpAuPekk4NEYSsJMUciQh0z+i11/pEOacsXNnJuZ6m8Wi0mFuYE?=
 =?us-ascii?Q?BOIWE6U/f3TqPqyLYp610yJrP2PaG4j1wD6hfjkpQkJrBiXvco8oWVFEgR8r?=
 =?us-ascii?Q?EEve/k+FbmyKAKgxbN84e5Da1kjVD8LXLp90fUI6inQjFqLJppyMNw8SupGn?=
 =?us-ascii?Q?pyaYYSVWtt+24sy6o3iIt74RxsDjo7E3QcLNrpGwEmC+p1wSd5APwsjPlY9+?=
 =?us-ascii?Q?AYQo7W+9vGebNYAyFHN0I6W9lfPe44wpN78TR1HpvByjrRkPcMlnTWFCSlcr?=
 =?us-ascii?Q?hOFNJc4+9A87N4TZMHpjqkpDv8HI/DQpTqqSLvpLrgWcpMwiJ2QDSbe9xgz4?=
 =?us-ascii?Q?bDm8ZZeiHYBwZM+deJ0wF9odU7nm208v67EFsUDxma0wuUso2pUqJ7vhYK+P?=
 =?us-ascii?Q?R44Y3P9OJbHANEypJZyt+noCBa3qGTMBdn3WIOGn?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 10f48742-5dab-4f9b-5207-08da6af29f77
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 08:25:51.7623
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Isu5zR9HU1cTE9pDERYDhdUKqhLdpQdjosWrA6TDk/fy7oK+WuILYEYq/JqBZShI2zZGEjq2koK5rtQ2myJh3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4909
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 20, 2022 at 05:12:32PM +0200, Jiri Pirko wrote:
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
> +	if (!linecard->active) {
> +		NL_SET_ERR_MSG_MOD(extack, "Failed to flash non-active linecard");

IMO it's not clear enough that the problem is the fact that the line
card is inactive. Maybe:

"Only active linecards can be flashed"

Either way:

Reviewed-by: Ido Schimmel <idosch@nvidia.com>


> +		err = -EINVAL;
> +		goto unlock;
> +	}
> +	err = mlxsw_core_fw_flash(mlxsw_core, &info.mlxfw_dev,
> +				  firmware, extack);
> +unlock:
> +	mutex_unlock(&linecard->lock);
> +	return err;
> +}
