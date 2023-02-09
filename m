Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB43D6905E9
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 11:59:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjBIK7Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 05:59:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbjBIK7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 05:59:22 -0500
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2123.outbound.protection.outlook.com [40.107.102.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 979CB56ED0;
        Thu,  9 Feb 2023 02:58:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QT2U4+KwJzz8EPgTE8h+mMK9TJY6k3PIT1O3mPG2TI0y4jUCQb+MMBBPuWUuHQy88zylhmv9qxp4IhhD3CSJqEGQDclLCBeR3p9jTc/2RLUpYLo0QN2ok1eOTNobsToomBXj+nZU5cvRZedYdTsZgUxHcPJbuecuarW6wh14V69QtWc2DnL9pr+Dk7E1RDqJUaH5dNvFT78fc8Rvkxhm5NIP/IqRD/gb0CX4dX6Z1Q+s9P9/C7/IuYYkGB5jQmjLQFVgiHXvztJ6OXsRZrD1PW3UVx8vUIbIUavI0lG+J1ljxAPzjhrq9mBq9Usww+b5dPdy17h7MUj6Cy3mEidcRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=y9YZ4u2AQfNLOj/Gy3Dl2sWQX6LR+ur/4OFDIuPpOio=;
 b=YvDq/OaeXV8YYQ6QEkCQbd05g56mNeOBKF6M/Y97aYC2KFvpXV+ctXBznfhIspdbCRW1cyp0qrhSpl4KevHN7oqbY3OS5kWosRVI6aZynwr7pq3pSu4M1PV0fI1vIRXvQXlEaaalPIAf7G39Z5A3pb+kLydTkxSGgVWvxAjfIU4I+NUjegnYqTPMxocqpgRPqa4F53ebbIAcoEr5N+DlM7PbqZ6hVgKu+8l78n4YazBJC9wKIffEHW3IEp0uT5Sx5BsIb1+V1LIPdHMWy7OpZMgMPUcHlg8NUwqIRbzVa5xb67FEhIJ/mxic7QRWDlwcqwC8QC360Furfd+F0wMzNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y9YZ4u2AQfNLOj/Gy3Dl2sWQX6LR+ur/4OFDIuPpOio=;
 b=LBtriH362LldLDBlS+Bfv6oOITW3yFvDxSU6r2PkbbdG0rEj9Em119AY1Lf08kYu7g0hB/Ky/683VRnn3kbyyFyfK0E5W2qN8NKrIU1R0vz3C9qTIdM8ZSWN2cK5uu4trtCGzP5P8wqV/GUIEC+Kb4oWc9D60t9C9pHBaQgKjUQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB4764.namprd13.prod.outlook.com (2603:10b6:610:df::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Thu, 9 Feb
 2023 10:58:45 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb5c:910f:3730:fd65%7]) with mapi id 15.20.6086.017; Thu, 9 Feb 2023
 10:58:45 +0000
Date:   Thu, 9 Feb 2023 11:58:38 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Hangyu Hua <hbh25y@gmail.com>
Cc:     pshelar@ovn.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, xiangxia.m.yue@gmail.com,
        echaudro@redhat.com, dev@openvswitch.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [ovs-dev] [PATCH v2] net: openvswitch: fix possible memory leak
 in ovs_meter_cmd_set()
Message-ID: <Y+TR3sB4X5Yt79Tx@corigine.com>
References: <20230209093240.14685-1-hbh25y@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230209093240.14685-1-hbh25y@gmail.com>
X-ClientProxiedBy: AM3PR07CA0104.eurprd07.prod.outlook.com
 (2603:10a6:207:7::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB4764:EE_
X-MS-Office365-Filtering-Correlation-Id: 5f246024-18b4-4f6f-8779-08db0a8c9ce4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1NOgczWQMiVQlm5suuMBW0ZwowGIo+PAM5cMviS9tFAmiCE/3qRHBsNNkJyRgTTDuSgI2AqdB45bIYwFjhwkxNAvs3zsumnkszBrNlnchPfgHZiHHSmFsCZa+IfEZy2L3LAMO37eTqYrEYu6F/tZOVxpg6lygkH3nL/hTpApBKwOQZ6VC3CM68hgaXTDYdisUWrLFxWWnhMoX81oLmx1sEpl72eHRDEEBQmoO2FXZhFOUrqcXTGS3Juvj5wJgSOredY7Ra5fezGukmiKgRI5ky1zo4ONT52sX0l0SBAIk6NjqDeDPlpyM5Y9//Y9e/Q1LzDqfXjgYwdd9IKAWVsTBmCJ1QOwykKT7GD0raoL7KC4Zh7twTGaM8tTbQ/RTp14KWvexOiqxj7KCET/RTGcYQ9k1R9vn00+TS14YLCkKBDh5A//q0phJS2ivnsXwYKZTBEvnx8jf4Hdo7Pdn3/QsO4I/U4DP4lm6wm+7JARa3CBD+tqVt3VZfiPwSge3H/apcbl+Xj+heTobnMRQ1yj93mD6kMUp5gMud0mASrnJKabk5xg6IABqCKR9DD8cPRMGzG+oYKnm+5n7BsFV1d6fm6POQcdtBQC5WWyO1HPFhy3B8QvFaT3LKOFy8EfmgO3MXP9LAuGCZgKaWHT8RpGKdipmbQ9Rprw/sc2PuUdfOqHPEgaoOEj/QX1oWbBRl/bODYAis8CEiePyuW871AK/1bErU1GWfyOKIv+vaiwAzA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39840400004)(346002)(396003)(376002)(136003)(366004)(451199018)(186003)(6506007)(6512007)(86362001)(6666004)(36756003)(6486002)(66556008)(66476007)(66946007)(316002)(38100700002)(8676002)(44832011)(7416002)(966005)(478600001)(41300700001)(4326008)(6916009)(2906002)(83380400001)(2616005)(8936002)(5660300002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z+sha/Uo3s64Kxk8fGXyvZ3L8nO3PEsgfGORHX9Chd/jDPDso3s6W+cpab6P?=
 =?us-ascii?Q?Vf33PQfHC9Q5Y3GM50rFiHQQ7LXDicV0aNJaVMGqZSpYabaFjmMbc6IZHyFF?=
 =?us-ascii?Q?0ez/2iMFKhgb+TiREfkizBbPYlOlYdwswU4ikS4UD6c1NYSO9zJyr5779RGH?=
 =?us-ascii?Q?1kuT+OtGIuHhWGD9tkFpmNTaDPaISs5G6QJHz6XMMzU7q1I+QAUH5E8yf28/?=
 =?us-ascii?Q?q4ms3HyqnX7LSHMsykXRgin0o5eBHMS+tzlwdVtkL/kU1N1lr9MjUBXFvpaT?=
 =?us-ascii?Q?DyBvrNfPbvXaR+3gNSGMSJROi9zIri/K189C7VWx4CFQp03GImCjH4O3TPFv?=
 =?us-ascii?Q?osf/LQkqBm+jBnfLaN4QY/+oWf/0cQsAjeOCXoAx47XyK1p6ru/eB3m6k4AG?=
 =?us-ascii?Q?5ykd/F/+lOFLydcXSxX9MoN8WNDtUYtDOC/YxXHlXyPnqhLlkvQWIvL2sI3n?=
 =?us-ascii?Q?HgD0+DMd3h5i/+oGYIcmlbqQwI3kViYobtQ/yQe9hmNypG2D5/ew2Igqt3Y6?=
 =?us-ascii?Q?T4RoF2t59YWQpvxA+CGveBwXKvoI1EuKrHF0zGG70q6gzKIPOTLws5i5IaU1?=
 =?us-ascii?Q?WeZftbWvY3P6ZT5V5gtwpZNFvomClk7fX/XfKDY/CflFxBiOzGcL2XlNls1c?=
 =?us-ascii?Q?KLMXA9O4JbzerUl9tL9BeUUhx9djI8BEdK9i5RXVVgYq4lZUmT0EXRgQWFqJ?=
 =?us-ascii?Q?OXWwdcSpPkEjwUhn6TrzZ53HKmldMaFybEF/XsTuIA558QUU5vs20HZs4nOJ?=
 =?us-ascii?Q?92sgFcBECURvpkOEKVBwR24pbQfnExECjWVnYVkEA7DW+lXJlr0EMPc2Zr2p?=
 =?us-ascii?Q?5EI6p9ZA50YIiEHYe2eMWqmS7B5G9F4AwS/xo6APdpRVIUe8VWdBvK8Bgx5F?=
 =?us-ascii?Q?O7Zh3sWE3FOyXucSiq0zB2eO3N3Do6lEJXsiaz7BvQ0tKJF9lolPvaBhcRov?=
 =?us-ascii?Q?Ug2HVRTTzVp+ZQbPgk/UoyJzc5e+Rg2jzvZURnaw/gK3t0aQw4upW1hDGDfN?=
 =?us-ascii?Q?ZIBy6pwucqohW0ztxlkiEV/b8Z1InpsTviedTmTfvn/pc88cUGiydXdBCV0P?=
 =?us-ascii?Q?G5pqArXoCKdiTvXFQAAJJX9hSnqoXnHyIvHLvvAZO+gttTk4h5gCwotWotjL?=
 =?us-ascii?Q?xI0VGMFr/mKPT+FSLRMSGSiJDY1qH8sHdPZn9/Yx+s4Q9GioKh5klxDnbYcf?=
 =?us-ascii?Q?Hh9Wh3M9pPJFkvkiGIsk5VEJTAfHal653LNKAW6s1JLLbc9sYxKDWVOLPdqU?=
 =?us-ascii?Q?WkrscE5sN6a7cxs8+yD2OMiPlekSpOCJJ/Pu+ae0yVz6F3oIvt8TH3FEyo8P?=
 =?us-ascii?Q?XdTpUm1UfOVVH7tgUdh0xVCe+1w0UYMgIDHvkb4uZuoGjz66/TduElEDVW4i?=
 =?us-ascii?Q?aucVWHk1uM94sxbAyjbJ4Kg0hfiEovVSGGy2enDpaq7fHpz8R5ecZ8PW8Yzz?=
 =?us-ascii?Q?fZ+Gy/QSvUkI3UNEGgyjVHLjJFff7gISUl1IN/gqLhvQgdh6TfnDwQXbVp1x?=
 =?us-ascii?Q?UbD3CoQJraOq31E03zmGmAhO6yeo3kuV2aX8xB6+vyp2P/6x3ZJbMLma7GLe?=
 =?us-ascii?Q?2KJeW6LOG/GYiQmAPLP2r2xu5C3Q/tCGAJ8VB9SShu22asCHB50Ffv3VZyeo?=
 =?us-ascii?Q?rqrdKVYIIQ6DtcuSnxVT0yqgwsGNPoeIvY1cw2upsB9l6LXGCJpbO0qGZztZ?=
 =?us-ascii?Q?R3UAng=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f246024-18b4-4f6f-8779-08db0a8c9ce4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2023 10:58:44.9009
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tNKntn4w/ZqVmiW6EnIYUs7+vrhMJxOPkhAKzYQxwfQn/xfLrOaV/rHC0cpBDaQw5sSr52+q87z5YI1PCdvzKtsKYc2tproSElyGO38tk4M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB4764
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 09, 2023 at 05:32:40PM +0800, Hangyu Hua wrote:
> old_meter needs to be free after it is detached regardless of whether
> the new meter is successfully attached.
> 
> Fixes: c7c4c44c9a95 ("net: openvswitch: expand the meters supported number")
> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> ---
> 
> v2: use goto label and free old_meter outside of ovs lock.
> 
>  net/openvswitch/meter.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/net/openvswitch/meter.c b/net/openvswitch/meter.c
> index 6e38f68f88c2..9b680f0894f1 100644
> --- a/net/openvswitch/meter.c
> +++ b/net/openvswitch/meter.c
> @@ -417,6 +417,7 @@ static int ovs_meter_cmd_set(struct sk_buff *skb, struct genl_info *info)
>  	int err;
>  	u32 meter_id;
>  	bool failed;
> +	bool locked = true;
>  
>  	if (!a[OVS_METER_ATTR_ID])
>  		return -EINVAL;
> @@ -448,11 +449,13 @@ static int ovs_meter_cmd_set(struct sk_buff *skb, struct genl_info *info)
>  		goto exit_unlock;
>  
>  	err = attach_meter(meter_tbl, meter);
> -	if (err)
> -		goto exit_unlock;
>  
>  	ovs_unlock();
>  
> +	if (err) {
> +		locked = false;
> +		goto exit_free_old_meter;
> +	}
>  	/* Build response with the meter_id and stats from
>  	 * the old meter, if any.
>  	 */
> @@ -472,8 +475,11 @@ static int ovs_meter_cmd_set(struct sk_buff *skb, struct genl_info *info)
>  	genlmsg_end(reply, ovs_reply_header);
>  	return genlmsg_reply(reply, info);
>  
> +exit_free_old_meter:
> +	ovs_meter_free(old_meter);
>  exit_unlock:
> -	ovs_unlock();
> +	if (locked)
> +		ovs_unlock();

I see where you are going here, but is the complexity of the
locked variable worth the benefit of freeing old_meter outside
the lock?

>  	nlmsg_free(reply);
>  exit_free_meter:
>  	kfree(meter);
> -- 
> 2.34.1
> 
> _______________________________________________
> dev mailing list
> dev@openvswitch.org
> https://mail.openvswitch.org/mailman/listinfo/ovs-dev
> 
