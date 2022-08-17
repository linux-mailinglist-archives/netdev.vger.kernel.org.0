Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16CF25971A9
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 16:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240304AbiHQOiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 10:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240278AbiHQOhi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 10:37:38 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2074.outbound.protection.outlook.com [40.107.92.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 430759C1E0;
        Wed, 17 Aug 2022 07:37:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BOdRtnICa+P3uRyNUaMVCz7ocKwyevcDR+j7zQah+gBxrDtxl2Q9TqqhgZtqnpP14LPjEwpf8hqKZwRSzjtcIkmurMeU/W+JAdeTD/JLzU7Htj1ylM8uSCZOy+B/gX2zAQtoRPwU2+Go/HOaAsJaXomG3AUsZsRReVV/EIqIFYOEvcERkDrCjiXTAbYFxun1yW2COw0SPzSfdPYlxvZx2Bn050RLGD/mpJkMoFidgWJe1U7luEVUiV1QNpg0aJ/c6/V2O3sPahIqDrrO5gupKlLgsKlfQXyX7m5KpRndIjWrX+nVoguGBU0g8od3Gd7Ffl0gQEHpScYzDDfPIXVHJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5zZA7Bv+h8EsWM/tjV8dnRR1iuNXUURUDPqlaIALA7I=;
 b=JC7VJbI2P0ZuJSOx+KjEDU6WH17OrdditARl+vPpG64o96W2M0Xcd8eqD9PJnvbQae0KwkwaVx2Qv50V9gf3UDawCxAd7xogWEHZDz8ZQC6bqWVIhW3GRHWRbhWy6S/rwH/AULj5xUGKGtJl4hOie0zIuVEsE8mPA3oqg1dflPL5ez+Gt5GSS2ku9yIhD99JSt39qMM1mAEFEY0EsKn15LAiKnV5XN1IHGnNvSABg/1pHhmoNvTB6AIvp+dmlzXQC63lreAGBnPYnmeTpW2y9Og9a3UVNrcnx99CceWCzRcNjhPm8Om2GvxtK2vIvMWhQ1ckX1+WhQ0y2d1liuB1/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5zZA7Bv+h8EsWM/tjV8dnRR1iuNXUURUDPqlaIALA7I=;
 b=OEhZWZgOsLCYjKf0ZfknD2I13VIikkoSWK5H+zmkNhGoTQJSPZE+Abm0NtzCiUISaroAGg3N5RKUNKEgtBPPT1sNTVPglrWZhxJ9wzY7pwXHKxSOdMctGsPXkyzpsDntKu0vGXzv5BWKYFip9DgWdYIsoy643KbNhF1fzEesupCm+QoDAeRG2qRsnWu9bLcm1t3KK+heOf+IqNgea9ztLRWEtC/thdfep9NLLaa2fMJBaLfibSTLsmpmbyX/Z9qQRVtFQ+5NbJ6UHq4rMyjW8wB2VOJsHNlGdZ61T1nKQOkEOvHRRJiNqibfJ/u7U1AWZOcDazRFF7vtDsEwZB1+Sg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB6163.namprd12.prod.outlook.com (2603:10b6:208:3e9::22)
 by MN2PR12MB4320.namprd12.prod.outlook.com (2603:10b6:208:15f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.19; Wed, 17 Aug
 2022 14:37:01 +0000
Received: from IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::a52c:c6f5:f9f4:59cc]) by IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::a52c:c6f5:f9f4:59cc%5]) with mapi id 15.20.5504.027; Wed, 17 Aug 2022
 14:37:01 +0000
Date:   Wed, 17 Aug 2022 17:36:56 +0300
From:   Ido Schimmel <idosch@nvidia.com>
To:     Daniel Lezcano <daniel.lezcano@linaro.org>
Cc:     rafael@kernel.org, linux-pm@vger.kernel.org, vadimp@mellanox.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, vadimp@nvidia.com, petrm@nvidia.com,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH v3 2/2] Revert "mlxsw: core: Add the hottest thermal zone
 detection"
Message-ID: <Yvz9CIelQSbGuqCg@shredder>
References: <20220817130227.2268127-1-daniel.lezcano@linaro.org>
 <20220817130227.2268127-2-daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220817130227.2268127-2-daniel.lezcano@linaro.org>
X-ClientProxiedBy: VI1PR09CA0089.eurprd09.prod.outlook.com
 (2603:10a6:802:29::33) To IA1PR12MB6163.namprd12.prod.outlook.com
 (2603:10b6:208:3e9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 323e8a9f-98f5-44db-1b3a-08da805df27f
X-MS-TrafficTypeDiagnostic: MN2PR12MB4320:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TIXy/4W3KNIUyJeelIrmBWwMKmC6SpC14Xq+LlSdP18mxrhIi+l5wUF06scAIBOhl9nrRqVVDk0ITBMpNWrX5OkKve0S5Ji4XdNAeUjcJ/Ioc1ZYihdcLOj8MIfpT4J04+edPSEKjIV0pxqE5CBHaAHMjvnghc2g0KxL9531WCxWxd0RscuhNdedxonddyR/Bh8zcDUS6PuELTgqUEZVH2mv5SvM9AeGZ+C3uCcW2dK9AOpkDotTbe8s+SxHxXz2/S2GLZ+YCy8WOd1rqLrXNvZP5SM6RcXIpZLr9Cj6MdbopKnFgBOGipKAyaoC3wrCGtdlT5szXFO5Iz/xDdci4Pp0htHCAUFusvk0rpPwIY5qjy1jmXEL5xoa4FYkmmQxm8NFakQbtRdZBiHFSf3bUrGpnJjZgm88MVwktoh1TPORImCfr/ZdK7SpjNOLv0IA7Bcdsj1UCov+UW+4ogpIL11hrmqrHyQkQkZeZR9WHkDPOt7Xj5U9V7Mw7NlmrmhPmEvLwhE6pBHQqKEHO4qhJilWJHti7cBdN96i8l55Bfvc3yocRNQI8Xbx5Z9AHpIbegl4E7XTt1WaIqaNKHdvPTU9gEn71ivjnq++JsMklYm57IACaK861TYAccGoPTTMuEB1y2wmWH6pdXQ5+7oLDxM33dg2XVxqGCaTt+sKPmqjfSUOSa1NYOcqNs1MHhGj4dpfJ7Ulbad+wBBcdwM9X6U++tdIH2u17cU8DTKWnGnRugYgAQ88Uavqwq8MRL/C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(39860400002)(136003)(366004)(396003)(376002)(346002)(9686003)(6512007)(6506007)(26005)(86362001)(186003)(33716001)(38100700002)(83380400001)(5660300002)(4744005)(478600001)(6486002)(66946007)(8936002)(41300700001)(8676002)(4326008)(66476007)(66556008)(2906002)(6666004)(6916009)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MrK/IqKt9wf5TOsYstctZvFNNGg43DlQt0IdGjiinsLfK2WrX5yQuhfcQoHc?=
 =?us-ascii?Q?UhFbTd9u4sQEY85uobO+HIObXqnM4VuXxpwCu8hprxzpg8nx7F2aX6d9G/aA?=
 =?us-ascii?Q?km1Sbg5jFQ0E/9Zd2Q/dc4cQ6II8seDVviQGa6qnAu8hv9xJHM828NmZSILu?=
 =?us-ascii?Q?m8JvZQwqzE9AVGsVKF5fmaHbm251KQyH/vBGArIQL+kGZNmjOJgqcPjBR7Xq?=
 =?us-ascii?Q?vLZXH221jiMg3a26x8Z14p3MYe27mRDoYtj45KVEZ7nUc02HOdpZ+qf+kEWD?=
 =?us-ascii?Q?nrud4GC+5oz2maf0+l7C8TA/KWcIvAxw1KWA8cE6tKX4Jf3b8AmtMii/ISUT?=
 =?us-ascii?Q?WfTfFCo26xSFDgpFgcOH0r8umNB8h8FcGBHsqnbJaFBQABW+mV+3BdC0Famz?=
 =?us-ascii?Q?7NPGpSU2PTtXk8AILamyOnKWF8+R9u08pC5UQqVO05hFEv4fPeDbtkY1w/lo?=
 =?us-ascii?Q?CoOOc3cr/oJ6tNCRxW9qc1TbvHQGgGxF6z7ZR97HHmaGNY5kFMrKIlVEaijH?=
 =?us-ascii?Q?1MsLJphIuU5IQEGKTmnE15Lqd98T5MwZGp/po1JmgOdaq4ousxnjsB0tHilR?=
 =?us-ascii?Q?DtfY4J5q//pCToVZImvdFvdSLEciNa+Q3uT4rzd/LVxGoh5sqeVEVdwpMksy?=
 =?us-ascii?Q?ujY5NV0sv3HPfTRh63XdlXGywC4QXqi48rJn+1bDuBL2pMQKjKpVrRU+a6Bu?=
 =?us-ascii?Q?dxjRxOUzdVArnJJc8pCjAkzmbyKTutmHQ0Te7EA+GV0kPOYaqbn6NPgeDoPM?=
 =?us-ascii?Q?AZwJnqwHRkujVZuj+1ortle7T1ZZ5EiZH+kAoQQI289N59HlaSfDqxYJsmdV?=
 =?us-ascii?Q?4q/8JiyihR191oy8s/W3M8tv6gftmPK0K5t+geXag6uh3HGv8k9MP+tx4JGh?=
 =?us-ascii?Q?haVtCNFC+O19SBQietgDuJrDcPxYqSGHiOjr+G0kpDxwprb4wInINtF02YJB?=
 =?us-ascii?Q?AuiGKHG8XzYRXxS86oORN95gJ/3+OSEadwaXi1hlTJLdK4G36fFqCyItfrJJ?=
 =?us-ascii?Q?4TTA7nt3OHkLEyHSKgBLjfxA+AtTZyn6gOtnWK44dHWTHLfULrswebdqBdZf?=
 =?us-ascii?Q?yZZVLm6Rx+0ewkxHcz/3hAQeVrt8uIVo9ZrvtNYYteXF70tBMU1h7/rpm1lg?=
 =?us-ascii?Q?3SNX4EztphuzIaA/0ggKXHdPiWsozwVRK7PnEAR1lIT2n8CO8MPmq+MsbIYa?=
 =?us-ascii?Q?Y5pqb5JuNgrD8B0dA9Mjwm0cKsSPtB8BwTMEnTICzQPnSafxr0p6UG5ai3bP?=
 =?us-ascii?Q?AWVKphpDRzn4StoFD0wyrv3xy/vsSbWjw+rUI0lUnY7fUJ7VLhsQ5PXQqwBh?=
 =?us-ascii?Q?O30reS/v6zJy8S0bsuR6JfsVT/Al8mJZcGqOTsmVKeh6X2zGwaTtRn6E5gZv?=
 =?us-ascii?Q?M4WS/BhKbBRrXQ9m4DqYoRYTliUJV4H0t+7fJaoRz/nH6V5uack6PJdOoMGH?=
 =?us-ascii?Q?bTDXAy8zrFI1UrHW+4PTP8+r+M9lKWdq55GMo1shgzaRW12P69aIb8G5xluA?=
 =?us-ascii?Q?bJ+NEDDoGIrqzVqgOP5rBCZRzPHn5TuYfxWivipofuLaOk6VjvB3cBOHjXxp?=
 =?us-ascii?Q?DqxfAEJ/AqE/0BtLVfrBon2edOW6R/Hhg7n/be6s?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 323e8a9f-98f5-44db-1b3a-08da805df27f
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6163.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 14:37:01.6326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SmHH6xr8MsY3MWEu9M7dTX/3YXZ7GhweKcdjK/bo/GkZ0dY03uWiZU7Ag1+OXHgJOS1NSjqBe9yvrchLYqeHHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4320
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

On Wed, Aug 17, 2022 at 03:02:27PM +0200, Daniel Lezcano wrote:
> @@ -285,10 +254,8 @@ static int mlxsw_thermal_get_temp(struct thermal_zone_device *tzdev,
>  		dev_err(dev, "Failed to query temp sensor\n");
>  		return err;
>  	}
> +

Unnecessary blank line

>  	mlxsw_reg_mtmp_unpack(mtmp_pl, &temp, NULL, NULL, NULL, NULL);
> -	if (temp > 0)
> -		mlxsw_thermal_tz_score_update(thermal, tzdev, thermal->trips,
> -					      temp);
>  
>  	*p_temp = temp;
>  	return 0;
> @@ -349,22 +316,6 @@ static int mlxsw_thermal_set_trip_hyst(struct thermal_zone_device *tzdev,
>  	return 0;
>  }

[...]

> @@ -680,6 +623,7 @@ mlxsw_thermal_module_tz_init(struct mlxsw_thermal_module *module_tz)
>  							MLXSW_THERMAL_TRIP_MASK,
>  							module_tz,
>  							&mlxsw_thermal_module_ops,
> +

Likewise

>  							&mlxsw_thermal_params,
>  							0,
>  							module_tz->parent->polling_delay);
> -- 
> 2.34.1
> 
