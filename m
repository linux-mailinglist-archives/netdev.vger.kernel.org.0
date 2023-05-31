Return-Path: <netdev+bounces-6874-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AC44A718816
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 19:08:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E8A3528157A
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 17:08:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E503182BF;
	Wed, 31 May 2023 17:08:35 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1869C17736
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 17:08:35 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0A3E191;
	Wed, 31 May 2023 10:08:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZIKRpgAEdHZVY7t01rihYviAhw+F6hmPnBBS2nzUtJnHlyiaqFkY56UAUVxRveW+a2yuiSK/yZjKEqlzFj5Il5nTM+07zJkNRg47xRd3/E/Agj/XSyWgpr6qSO8BRqYiMzqoRY4NOpkMuNOg2UTRxWtAr1XZadErg5AkYlxzXOVcE8z6/jXsyypWr2E9Dt0Z4L3zM30dXlMzknLtQLT0XSe1xJYKWPIe3M7NpAtX9AoUdSJBXK8B/94BvaXgZk5XtXfKxart21TN8HRGASjFG+87QFQOmAeMBdjJY76w85bb4mwNpNpw2Vi9efMgpldi7IDkWy8lEaLbPyvtkDsjBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZQlh+ANcOvNl51W6EpHFYqOdFQUboyT3PuwDcdDOZCw=;
 b=PjLL5q707Mx1ZBICgQLpgmx05syCy9LD2NTqAdHx4cMo8WOIRsrV0Agnes0ptbJpDjQYy3r93bK4bVrZOfcPAI8UT5FStk/BGBruk0HKKkYH8wigjMVky5cchCrEaasEcRqfZVuxA8HPl7/qhczCg9KvUDhRCysvNOTvYl3HrSDZDxTK+0ryJ7DXWM73aZJpqiIb8rmMDyiYYLREPGXKpi+V33lqDoaPtvrIjJHU01B2vLjF5dc7SmBgfPZMr0+u7lp3wbQPyac3oW0fTHlZUQVLW29eWK3bHBQVAoPLQOL1sOIN2UbHJBR2eHZP9O6EF7MaR7FSUCMQM0RhVURDSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZQlh+ANcOvNl51W6EpHFYqOdFQUboyT3PuwDcdDOZCw=;
 b=ALsBokl8d+RDU8L5o0g+RIG+FRVMAtkE8ngmErw5llLX5xD6u0qf1q5s2CeX06KCgic0kxiUcEhx3Ri19bw8V18e4Fni8YVTQUf7yc027eHDGYXofTasm7E5rQvH3kPB0MaMISIHLiKivBaJhCJa8XseFV+dzNd0JL9YDPqf1kQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3758.namprd13.prod.outlook.com (2603:10b6:208:1e3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.22; Wed, 31 May
 2023 17:08:21 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 17:08:21 +0000
Date: Wed, 31 May 2023 19:08:10 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Kurt Kanzenbach <kurt@linutronix.de>,
	Gerhard Engleder <gerhard@engleder-embedded.com>,
	Amritha Nambiar <amritha.nambiar@intel.com>,
	Ferenc Fejes <ferenc.fejes@ericsson.com>,
	Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
	Roger Quadros <rogerq@kernel.org>,
	Pranavi Somisetty <pranavi.somisetty@amd.com>,
	Harini Katakam <harini.katakam@amd.com>,
	Giuseppe Cavallaro <peppe.cavallaro@st.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>,
	Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
	Oleksij Rempel <linux@rempel-privat.de>,
	Jacob Keller <jacob.e.keller@intel.com>,
	linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	UNGLinuxDriver@microchip.com,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Jose Abreu <joabreu@synopsys.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	intel-wired-lan@lists.osuosl.org,
	Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
Subject: Re: [PATCH net-next 2/5] net/sched: taprio: replace
 tc_taprio_qopt_offload :: enable with a "cmd" enum
Message-ID: <ZHd++lqP8EQocWQC@corigine.com>
References: <20230530091948.1408477-1-vladimir.oltean@nxp.com>
 <20230530091948.1408477-3-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230530091948.1408477-3-vladimir.oltean@nxp.com>
X-ClientProxiedBy: AM4PR0302CA0003.eurprd03.prod.outlook.com
 (2603:10a6:205:2::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB3758:EE_
X-MS-Office365-Filtering-Correlation-Id: 0e23b032-5eac-4bd0-d94a-08db61f9a2d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	huwoeMTz1rYjn+YOfMe52Job4Ubla0JL9FwQz6MZrzODHtxwvKc64LOC+GbAnm343hzv8QTiL/l676rDR8BLIXmi7tnNgpBbzwfn7J5tPdM8s9hZKiwAerO1BmgEa+l+gn3Pa1KmMjlBTBl5Lb8fw6FAnCK04zf/+ylvW6eW0E/NruVw4ibqsOPS4VTYI5DedhlzZF9Ipz8kFOSMGbDEeeWBr+A3B3v07jz5V07cLCdgZ1FW2CAWegKS+jOYVR81wHht8NNHeyyiCe7z4ZnoakFK8xylgWNbVuIL8R0NylPL8d4L3i+8kNAijj9oVhl1kqyxZEMt2V6+HpBYb0sKueQ0RnADkobfpb4iwW1N5g2AQts0VWq4tdCnIzOEXDjmTISkNFtTce9UicZxf6xISVPkYi/k1LsGnrLU+kkPsJmoVHkVwv3lymSUYC5Xy1WBPwbDpbYZxp8QqWtyUF9DzbnIW3HY7SeGTFjbJvpNLb+RbGYkr447TF0wASVnGYP5WQUqwWoO/NNkgMaB0iAPs6tSlC7fh0WQxBAO2XIWGj7r7BM/MdY5l9W5eiAISh2T7e0H2sxytgEP8i6tdu3M6MYFEir+LFxqAqg641qGi80=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(376002)(136003)(396003)(346002)(366004)(451199021)(44832011)(7416002)(66556008)(66476007)(66946007)(6916009)(7406005)(316002)(4326008)(41300700001)(54906003)(8936002)(5660300002)(2906002)(8676002)(6486002)(6666004)(478600001)(6506007)(6512007)(186003)(36756003)(83380400001)(2616005)(86362001)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?bg5KahjNYj2IYeLi7fPOxS85Tnke5FVe8S0H5vlN/yJQbS9NMW8itle5VIzQ?=
 =?us-ascii?Q?1YPvxqT/OGFlaSTgpwwY/oFAu4pzqqef9FrO++7uBGkpfBZwzK60TffaiBDC?=
 =?us-ascii?Q?kkjwoLUMP5W6ZYyIBz75nx/RmGcGn5DlSf4syeKGIuY1YVS8Vrd4qgGQaxah?=
 =?us-ascii?Q?TH5GqCetzqJsljikRX/ct04uNWVTvmLjOFugnfO7KkUaj1grDzv/vPlcAWl6?=
 =?us-ascii?Q?aHDzu5/RxswAWBv3OzScG1a/1WHjW4PkTvnesaN+ct23MMwsibticDWG8NCS?=
 =?us-ascii?Q?lCDHMlBrinSUL1sMSfE1mxyWIbeGSsTVPU7KuEtKWyRbwxtfth69E0IYIbNL?=
 =?us-ascii?Q?94PFAImZHcpfEEDFQrvCShiPgqRoqQN6G32A+98V1bdH7iopjTz42lNiEjSu?=
 =?us-ascii?Q?WmykJ6RAGozVOTBUsd/sp4a8WCsX9mbwRaq2C0mK5HAYGylaAB5L14eP30Ue?=
 =?us-ascii?Q?hIeXpCiUL3lWxYf5AQztcpXksVu5zj+JC2Pnx4Sqq8NXOQEEhyXT0PMj81WK?=
 =?us-ascii?Q?4yoJ+jR9eZBxzG6D+5vmH7OXiiuZ+PheRxSbugwQlh1noFIlEcy37nS6HnSX?=
 =?us-ascii?Q?kPVZOnfEhNCTl0zyajUhlv1qhwfu9eHUJPzh4zUE56ARji4RUBZPD67xxP3U?=
 =?us-ascii?Q?xsNG8JKXZiIsAhP5FLtcNy1UGisQVkVnVhLFOTvBcOppJe2GpK0l0qgibsHw?=
 =?us-ascii?Q?p7lkgmlj8jEXjl4do01bQ6BUN1UK/Zu2n9NqJmDj208iOmarRUFf3PPNS7tr?=
 =?us-ascii?Q?+y5yuzjPiIVKZddtX6nBHy6fdsgxSjukUHQJoYmrEE0d3Orp2fj45x+4wpTo?=
 =?us-ascii?Q?hUoHQvqbebpB72+fMAC9jckChyWSbA+QIUYO7NskdDEX2PGYKa5nrUAGyzOs?=
 =?us-ascii?Q?exfTqaGMPH0erXGP6a2qynB+vlQLTBRPbMi0P5DMkWnUcSV27uaV65eekQGD?=
 =?us-ascii?Q?8ZkQMLCB5cnN1X6aqrIUFm59+WRNlbdql7eCCy5wrgh6dxiHiC0RSYDzHdlX?=
 =?us-ascii?Q?tTrEbBxHM/GR14OcQ23QPE9Vrj7i/FP8z/wyGTeiwEe/Mf0cwnbaz+1G4uiz?=
 =?us-ascii?Q?D3kWh+tUi5yBIiPvBiD17Rst1431rWG6PXHq8QlxHqfFC5BPlzFWZZ/MnbBl?=
 =?us-ascii?Q?ihUD8tmz5noJ4q8fTrTtSzFMPICs39o8Y6xEZXNeWOIamDF7WLq9qusaMB2c?=
 =?us-ascii?Q?NaEv3bsLLfUX4F9afcsn8onfQIMXvzRdsf0VtpXugxi9Hn2Y6vfbJFhqGOnE?=
 =?us-ascii?Q?szSQdDZdx6bt1U8Wm+/6aLUkRnPrda3J9n32nCfpN1V6LSLOtnxsV6KSfVXu?=
 =?us-ascii?Q?5tWB9XV6oHJhNeHvhK9uB7NbWFOUPOsheeY77nVfzO0MFxJb2hB788Hlj9pn?=
 =?us-ascii?Q?cAX8wFYPdh3GxdTsDO/3Vd2FpSS83JU+imtPf4vAffmbDmjLCU6IIBXwmwa4?=
 =?us-ascii?Q?5cDQ7yHt5bApoulXF48tPkmFl/FUMvguaKw7Z4LiPvLoqy/8AKkerBmKZ08B?=
 =?us-ascii?Q?Ufy5xgZKmk+6BC+76IBMpmCXyCOtHXxhJ7XmoVfwApmvFvDtZupihDxj+sUi?=
 =?us-ascii?Q?pfjcttvhI2deAKeQQiXVOtM1C6l9l48jgv2pgW2s8kw719qyGwc5MXPATVm5?=
 =?us-ascii?Q?UM7hBvx1GvOFI/QpawOvAjgS/mIfn0Fr/WkyuKenwgsy2sWa7lOt6zY7I1FF?=
 =?us-ascii?Q?7eWjYQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0e23b032-5eac-4bd0-d94a-08db61f9a2d4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 17:08:21.0977
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FCd6RnTiuUotpy1/PeeO9ZxcAs39SISZfptxVELNuvztXQYX/r4zVARMnQt1LN85azFVZIiltRXqmAIbEwFvbtDgoBigtmXHcZSgwSgl2zc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3758
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 12:19:45PM +0300, Vladimir Oltean wrote:
> Inspired from struct flow_cls_offload :: cmd, in order for taprio to be
> able to report statistics (which is future work), it seems that we need
> to drill one step further with the ndo_setup_tc(TC_SETUP_QDISC_TAPRIO)
> multiplexing, and pass the command as part of the common portion of the
> muxed structure.
> 
> Since we already have an "enable" variable in tc_taprio_qopt_offload,
> refactor all drivers to check for "cmd" instead of "enable", and reject
> every other command except "replace" and "destroy" - to be future proof.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

...

> --- a/drivers/net/dsa/ocelot/felix_vsc9959.c
> +++ b/drivers/net/dsa/ocelot/felix_vsc9959.c

...

> @@ -1423,6 +1423,8 @@ static int vsc9959_qos_port_tas_set(struct ocelot *ocelot, int port,
>  
>  		mutex_unlock(&ocelot->tas_lock);
>  		return 0;
> +	} else if (taprio->cmd != TAPRIO_CMD_REPLACE) {

Hi Vladimir,

Do you need to 'mutex_unlock(&ocelot->tas_lock)' here?

> +		return -EOPNOTSUPP;
>  	}
>  
>  	ret = ocelot_port_mqprio(ocelot, port, &taprio->mqprio);

...

