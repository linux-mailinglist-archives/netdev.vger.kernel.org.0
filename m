Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B6516471C6
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 15:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbiLHO2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 09:28:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbiLHO1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 09:27:55 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2106.outbound.protection.outlook.com [40.107.92.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18C3D31375;
        Thu,  8 Dec 2022 06:27:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JJnanO8V/Se65n/7UhlACv8tYaX1iX5OvLWJ6XOkNdr2qHqJ4e3JHOn5qe5+Xm/SOgV33MVsj8sD7QvJh8/3lbksiUB379Y1E/vx7veJw72NQhYq44EoysCZDJ2/8L6OzmWX5o1hbA3qqXTbTg0KEiP/g1vHgr+iK9PH2VMffLNw/r03/tP70AV8+ezI7xMjCY13X/YKP+AibonTfLT1ynuZwnIWJ2e7JNH/dZtecEfj0TbYtgFSS1BUQ+MJr+YV22lqRiV6olatBBZ9UhTuygUzzT5HcaeJLolh86nvoFcTWrdaQf4Z9i8pGBmeGk7/Y8G7UmCIE2hQx6KS+P7jRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aOjjoPB9xyd1NCYMKURsO5lJBn0G7/rBPdr8qY4MvUk=;
 b=MoyfWsLL2pES/zBDWQvqvzxLq8bMD2FB4T1Jy7Bo4yqIdPOeyX9SWHKDeMrkBK4tzVnnuxMjUKfQhR/4Qzm3VovrYgPGcHlFJfhIuNGYdLnRnj1OW3aPwSEyVuJBRkoRRzRIAsaDzHRTo7BIUt5ZQkQfnnn2k+VGIRRIeinR+nWJaXmVpielxf6Uu49E8BQ0V3GJ5d3NhvMLysEnGeN/ZfAZaBowlDlwbzDdKqqN2dFkp6df4HGsxzgeXiIgH9L8bo+fmFdvnlq0xbTePBqFaMrOjOowMHplDuMlyjpWp6Reda5GTdwv+hugJwKxg6A+zjZBo+UGns8mAozb+1P1tQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aOjjoPB9xyd1NCYMKURsO5lJBn0G7/rBPdr8qY4MvUk=;
 b=hCZ4enU6k44qLOhyt5zngTpN38PDcA5bBnwihLH0NHzqs68RkBqAMJLPnPxVzZWIqJh+lfqKVJ1bXMRZ4Sp4YaAjBpbIvGZBfjPILcpCJRIFm961+p9K8igi5QW5xfrRIMl4vhYm5cMSynlFO3lct0wmpUOxJ+5r3ttWmtVT4r4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DS7PR13MB4607.namprd13.prod.outlook.com (2603:10b6:5:297::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 14:27:44 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::483b:9e84:fadc:da30%9]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 14:27:44 +0000
Date:   Thu, 8 Dec 2022 15:27:37 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Yuan Can <yuancan@huawei.com>
Cc:     amitkarwar@gmail.com, siva8118@gmail.com, kvalo@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, prameela.j04cs@gmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] rsi: Fix memory leak in rsi_coex_attach()
Message-ID: <Y5H0WZtp2BTlHfyM@corigine.com>
References: <20221205061441.114632-1-yuancan@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205061441.114632-1-yuancan@huawei.com>
X-ClientProxiedBy: AM4PR0902CA0011.eurprd09.prod.outlook.com
 (2603:10a6:200:9b::21) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DS7PR13MB4607:EE_
X-MS-Office365-Filtering-Correlation-Id: a0750d86-1fb0-40a3-e956-08dad9285eb9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T9fER/i4E7Ww4o4b5VvJSh3KbxSPzw7MI+DtavotkCE/j3uPUwjxI3x2fvEXUQmpUS/pEI6liya1KZxgINRKvDaLFIZcozcGyPTZ3JuxWJjf7Y1ha3tKKXPm678tnF30r3TfUNOT3wscoucbFUkTSNLZYXbM/7RpnaM9SGt25OJ2Pzt34GtKIpy5Ri7yTc4TZPSKU+CuNed9bbKj5ctO/3z1tpkt28yG7IMKXIbQGkygR6Jqp3655ts2mlcJ9AddL09koa2yulrbeQEmfZWxWDUatbcek46nrdQw0rQ6AgOxIsiCHLekOnkqo6DF4yax1vXfDThg6dn0eDLtAW/WpKvOhKLaWvm+uOHiVO0xFw8LDFF+G7l47177OlL/vzjTZ457JxMydyelgmCJgRMpqvK1b5QXxAqqLB9zNUGZlJJG8n3ZiL7FnGzoNj6kXPYOe/mtaWRxcKeU8TFvnxPkiyCSd3sZ+kVhUjwO23hPdiO7mJqfd74/t5FSDknisbDNmfz0ROnGiqhErStEOp2gPehYuYqfEfPJJs/0fRcFVlO30XjBjQoYOOrNVw2PkQPcdcAdsxWmNqu6ErHGe14RPZIozy88oZXb5GQ35XRLAuBzySD8C5Pyc+Qwht8rnp3a8b1EcChzTIcJFtZFxcg31bF6Pud2pzTBb1vxkjZCyBx5//KtJ5nmUHYMCvYz2Kqt
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(136003)(366004)(39840400004)(376002)(451199015)(478600001)(86362001)(36756003)(6486002)(6506007)(66476007)(8676002)(8936002)(5660300002)(41300700001)(4326008)(6666004)(44832011)(2906002)(66556008)(316002)(7416002)(66946007)(6916009)(186003)(6512007)(2616005)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EzKb2vcsc22f15UbhrFhBoqPMarDayALLLcLrpTCyIlQkuKUg5XjOqp5t/JV?=
 =?us-ascii?Q?kBlEVk1twXLVRHzTYYM+UMLduk7khv6Lz34L7hcqN+/grNenAa9/JYEssAOn?=
 =?us-ascii?Q?HycbaryNPE4NEzmIxJSqnL055Y+62ycyldp+WZZowxosMZXPpeH5CyhRdXGV?=
 =?us-ascii?Q?v9a+2sun1Hxl+sgnetj3qdIwdRBJdTzu+vJ2RStIptNAhQHGPhMfUZrRK56F?=
 =?us-ascii?Q?RBtAwmy6GBdjQb7voNKsy0O23X4CjT5W0fL45xuByI6r7vPhIon3Lx7vPh6L?=
 =?us-ascii?Q?gqeNcpwRAKQtnx84Tid6M8Z87CVBZxRsf4ORMRQRvIAX0u3/CNcHT08ESj1u?=
 =?us-ascii?Q?//t9E90R3gVpqN7U53oeKrzhCHsUzIr7N46oECQ/73woEWI8Ze59gf1HADDs?=
 =?us-ascii?Q?4oBdPgprzFcP8nCfYuundGNx/OQBYproR5ns0i3TBygYQvZOkzsqdcNYwkRE?=
 =?us-ascii?Q?Dxaf3SFoW/udxMUzxH34EgfVOZDS3B/Kugqks3y7v+F+q19eUiPyIxi89WZW?=
 =?us-ascii?Q?tzSsgqpBudarHVHU9h/ESCSiP4YcMJBnwgpawO0aA8BuONjESQxr/jIaDX3E?=
 =?us-ascii?Q?J5FRMqsIBW/kA9Cm+Uj+u76T0tlkBvshamTb6J7bROEkCBZT1ZfIKW4sF2G5?=
 =?us-ascii?Q?q2TMjw8lqvYKWMdOKckv6nBCHh4WbZQUsamIiez7zLLwPhOvYCgm+BUc4JKx?=
 =?us-ascii?Q?BbvO+kqsrcEZ8qSSIqyN50g79AuROaMaFRQZso3q0rOc/AsIWqi98bqZtu9K?=
 =?us-ascii?Q?i5xHBgSDL/6ySKPfrqLkScHwyzom92MXMbN92p5srMMJQbG6NDJSf6nAnTYF?=
 =?us-ascii?Q?+y698zJxD7y4tc+XwjrweRbk/mI2h3tvRRU60M8fFL5gvmefIz49swEtnmyt?=
 =?us-ascii?Q?ru7OaTjjBRdu9L91n74rijpqf+sTWuZrS80vcub2PaTh6JIwMZsr1RUjWA4b?=
 =?us-ascii?Q?iMB84WCvIWRljzH/9sS4SqclAuuWKbOyn3XECJkhIUG6L8NHjVrKzbjp6lVH?=
 =?us-ascii?Q?kUt9iDpeEyPWxhdlbYd5JP0ETjr715Vzu2Jc0vbph0Wg51yKAMzHg6OckH++?=
 =?us-ascii?Q?SNXScJdwhMCcjfb1vkO0a6ZElH3EwK0pZ1re93ZC0fzTmSzeEDLJGw8FPNmI?=
 =?us-ascii?Q?GwZYVizhIjkVkMo942y8Fc908jzSRZBC6RRc8AwPL89n3yeNFvy6l4g8YEkt?=
 =?us-ascii?Q?nkYzlf2SEi4aXl1HL+VUW+nuhPT1bjiaI1b7dZb7ZRwZDM7g4CgQI2Z1LxRu?=
 =?us-ascii?Q?kB9hYUnFA0P/2zgV4s+ASpqNeFXdAvYD11LtsxtP1a7yruQmZVVCtMCS+SYJ?=
 =?us-ascii?Q?KD9f/VuGP9sKuPcZeR1WuQg5AMWBVvE7AdisUSM+8BqM6z/ujoy/GFTXEMYE?=
 =?us-ascii?Q?DyPZp722J81FY2PJbRV+bFYzEyMzhZQcIr0pqHmiqBaXPlwPP5GnEc5cG6mj?=
 =?us-ascii?Q?AAc1axT9TSSbLSR7RK5mVCluFD+Fo1cjMw6ENFfYAm/KN/YSc+J050TteRa/?=
 =?us-ascii?Q?Vcg+iuUcY4tVnbDBjOPM6Exl1ECMPpfTCeNxAC1imCBQVXHIVw8njCr7SYS6?=
 =?us-ascii?Q?l7Rts5pWmlx0dMNn0eJrFdw1bJ2fzgpIjK/6cVOemSwgtLVf1oMnPY8RS0uo?=
 =?us-ascii?Q?otgWj+CXnjnypuCVrdZntVfYWxP/8vjFayZkehn6fKsQRf/OJhrAGgkf3Tso?=
 =?us-ascii?Q?1flhuQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a0750d86-1fb0-40a3-e956-08dad9285eb9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2022 14:27:43.8913
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Bk2mmiDyjjDXam9gzWidZwPE6FQ2z2DmNr3tDR9MCPz1wwdg5qPRZ0HSsYAjPrxO8DofTDk97qcY2RU6K+/ZB2Lar1uevfe5PFK8VvBGbUc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR13MB4607
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 06:14:41AM +0000, Yuan Can wrote:
> The coex_cb needs to be freed when rsi_create_kthread() failed in
> rsi_coex_attach().
> 
> Fixes: 2108df3c4b18 ("rsi: add coex support")
> Signed-off-by: Yuan Can <yuancan@huawei.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> ---
>  drivers/net/wireless/rsi/rsi_91x_coex.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wireless/rsi/rsi_91x_coex.c b/drivers/net/wireless/rsi/rsi_91x_coex.c
> index 8a3d86897ea8..45ac9371f262 100644
> --- a/drivers/net/wireless/rsi/rsi_91x_coex.c
> +++ b/drivers/net/wireless/rsi/rsi_91x_coex.c
> @@ -160,6 +160,7 @@ int rsi_coex_attach(struct rsi_common *common)
>  			       rsi_coex_scheduler_thread,
>  			       "Coex-Tx-Thread")) {
>  		rsi_dbg(ERR_ZONE, "%s: Unable to init tx thrd\n", __func__);
> +		kfree(coex_cb);

I was going to ask if the assignment of coex_cb to common->coex_cb
also needs to be cleaned up. But I see that the caller frees
common on error, so I think this is ok.

>  		return -EINVAL;
>  	}
>  	return 0;
> -- 
> 2.17.1
> 
