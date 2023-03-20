Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5743E6C1B27
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 17:19:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232311AbjCTQTe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 12:19:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229929AbjCTQTO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 12:19:14 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2097.outbound.protection.outlook.com [40.107.102.97])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D63101ACD4;
        Mon, 20 Mar 2023 09:09:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hCH3fAACBcpkkXeKnTHVitB9KQMk7e944dKfOftV7ziY69LZye7JE0Loy3SwsgkXnxKGgAmmRWdNdkjnTyF9yFmJootHsw16lQkP6Rw3KAmNZqQ2gfy5XH2AueAKqKquolcmVUU19i4MihNOEw8vuRXX7o8J43ustrAmJKQdU9kLX8meIaEZpbQgCxXk1Ztxb/u3rEWXTHTtKHMdn0NEXQjhuGb0ngKJXYCV+RVdromTx8Fsp1L59un5v2TImDP3GiTOoiyRJq6mByaYg87B8k4E2e6BtGYH+HytGIpcT7aNWzubQqLi9vFVJE8W/0dGlKwx8DQZOFmS4v591Tj5Zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fxEUspo5bIQ2wh1lIqWaLuDdI/uKo8dJyb+YlQgE5d0=;
 b=HWIFpIphqfQc2IuK3aAZR61NYk//Q4tToV0iUfAyRDfdOhW9JWKd0KHxPU8LnChY87CkDy/KPAGBN+ih2wUuUdg/WfGt05B+2JIzR9c1msuGIhe/SsocZsx+l+YeARSv6qgLkeN4L8d86BJOpNDlTegs8vGS2EmrS8MubFKA6DE8Eq/n7dRCuo+tzy44dm3jRIXooq7+4jpeTViDnp09Y77EJLLf+LXVA8B1rDSW4vcC9rYqxfyVoGDZ9TX/Cfvr2DNbz6bvJ3I9YQaItZFxMccnidj4ML8K9I65WbEOgkQ3dfBxqbL+8tRX5Fk4cY4IkHOP2Ze0KuRGjzhBUBcZlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fxEUspo5bIQ2wh1lIqWaLuDdI/uKo8dJyb+YlQgE5d0=;
 b=Q591mFmgCfLFeN1Le1gBvq1ZzUx1TJiibaQtv1gImpFg+D+uAOuKlGLsH19duf/Cxxz4CARtq9PEDwbpEggpLEs6CgRmWVDDZXXJJVVbl30ER9H8FVyX2nywGxYJvZ3UAOjeRkKLkb1/iHXT7i8Z9NjfDVLpJDIN3FMas+bq84o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5462.namprd13.prod.outlook.com (2603:10b6:303:195::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Mon, 20 Mar
 2023 16:09:17 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%2]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 16:09:17 +0000
Date:   Mon, 20 Mar 2023 17:09:11 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Bluetooth: 6LoWPAN: Modify the error handling in the
 loop
Message-ID: <ZBiFJz5meJqoodzE@corigine.com>
References: <20230320063156.31047-1-jiasheng@iscas.ac.cn>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230320063156.31047-1-jiasheng@iscas.ac.cn>
X-ClientProxiedBy: AM4PR05CA0012.eurprd05.prod.outlook.com (2603:10a6:205::25)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5462:EE_
X-MS-Office365-Filtering-Correlation-Id: 0ceeb41c-640b-43ee-149c-08db295d74fa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pVwcJGNdcjnFUfg9uNbkCu4X4JfISOtIJOsuAPaP2VuoWfDRwenRbib9WPlVBNJ7moVtFCL2V/yhe5V7r/6ioDZtt34tP7AGhJwK4F0A63JHnWu3rL1vJNq2Ttn7ztVcZ+sTxaU0jhDTCQEnlauwp7E8jgLNThOfrxGe9tBUDBxw3rfJAKiZ/ShUv0sXeaoVmSFzw+Cvbtqst/mK6/LIwRrDF2CafntHQrDhSUCu8GC2NPlv7uAgAo6nLU5Wd9/5u/ozTCF2sMb2WQV+Q40aw5fSAZF2/SK27DsSbexnOIl0gW/lUovEtg/6GmcmAiYmpeAAvqNF3ycWun0U/JAMB700mUkc2o3rpuJsOC596bMJ6FJM2HBGeQyvTYetW9rHGlPWvlxIdtWwBMVKo9lBKBtWvEvkajuAZn/CFPZldAFRtBMX76hr6UlIOm+s3VC5zY8mxINABoN6vN8DqZ+ISWaKiRcWybFxDE6joHdcro9T3b3i2Aaf/Zt5loAS76iU9SsBIMumAsaAL06ta1HmXA2GwnKFbyLkducOw6zA7EVW/amBrfo17HbRDlXKfkzr38XxveDTfVw7h/A8pAijbK0MasFeRknmEESfdw83H8l/xdpTNk0weFHotiR2n4XxFueHEQlGAVk0XTDjecgNbA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(366004)(376002)(39840400004)(346002)(451199018)(83380400001)(66946007)(2616005)(38100700002)(316002)(5660300002)(8936002)(41300700001)(86362001)(8676002)(66556008)(7416002)(44832011)(478600001)(6916009)(6486002)(4326008)(2906002)(6666004)(66476007)(186003)(6512007)(6506007)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jLSQz2/oDjsTzyXE4m0kdlD7GOWH1j4S4byjAADnfyLSONnBaIJcno64TD56?=
 =?us-ascii?Q?VYlDSFRPeyDRgTdgY6wq9JItpTAfWbzDeVGY0eQCi5PZMdPPSEfLiO9TRRK5?=
 =?us-ascii?Q?3u3cEooKMcaiGdbixgDcwwZ16FFs3ICRVTs4I9bdJQPOYhWx4SSfaS+JFXsL?=
 =?us-ascii?Q?+zXT3LTuaKyb5U3JDZ/TEc4E5YE07sqBAWPmbOB/A6pALoV1/n18XFdHYhAG?=
 =?us-ascii?Q?Dp5lhpmY6wZ+IhJ+iHThWe6GP0RMKO8aRkveZKec2NxMePPCBOLG37npv3Ao?=
 =?us-ascii?Q?/evMQLBSaTWIuSmcJcSpiakfp3Agx3lOdKqNqS21ybhOagm7LydvQumG6j7O?=
 =?us-ascii?Q?hQC3NHzOci13XUwrpXBMFKCHuf5tjhGKkXOw1oPUh7Hw4HWtNftVf8dlAKfa?=
 =?us-ascii?Q?r91z5Zd1EcCutpFkQkMw/26atWyCsAyNUR+TiFJV4V1w9nhsw5SYNNl6wuL8?=
 =?us-ascii?Q?8Wswz4iNOAQ3ghQA762Vs/Dq2gTyMDH40CMWK8FX9KWa57d4BmvSojLHQTpw?=
 =?us-ascii?Q?ED7qCJQme69TXNai7VqaYBP0qUHap+azoJoMFZ6cKOmMZMnZmDOAyfK2kP5q?=
 =?us-ascii?Q?61psxxSpJy4uMTWgGvzdsc70tgv2wguh2vmqCgKooacfnlOEGfvx6I1jaz7/?=
 =?us-ascii?Q?7LLU2kpNOk3hWSrxNMNm5C3/Z5HJZQiufvlos/TOwDIE2qX0bH0plmgb1vrl?=
 =?us-ascii?Q?IiVPTRLOgdaJJZCEIcVeP0Ay5HYFbe0ydmY3sZG2438gJFeF4Lqgrst4k8vE?=
 =?us-ascii?Q?U06ycajAIo2B1fJb3KZyEecKzIbm3rq8pirb+B786waXewJMgKwOgU5QmR+4?=
 =?us-ascii?Q?PuI5aVYRA+LXX7Sw+uLjoSb42uNUTdSzgAzdUrdIN7ULI4IP2p3+vhC9hdm7?=
 =?us-ascii?Q?DSIWFaRWLO3TOrimlx5GxndK7aJNxuJH/nAEJjmUvKIntHxqv1XAviiJaJlz?=
 =?us-ascii?Q?FDL1pDkygO0eBN/Tu6nDoUjgovz+ee17hdwmwgulbi0CCzZW6OtSSvCvCfNd?=
 =?us-ascii?Q?6NOuVK96ebvsitOTxRs9zOUuiUr8XSbLZ5IyrNxFrACm0T2iYD09SoZqAJgx?=
 =?us-ascii?Q?Lr6pkMb2BMq+TsHfSeqAabM/SZCuW33FNSfCf9VEnwS4QX+D4QKsQjZzveP7?=
 =?us-ascii?Q?hKxgCStjPcnGJxnv7yVC8Wk3HfeSUsr3q3P9n2i7lMIjfCe8G1h9U3QUAfBK?=
 =?us-ascii?Q?yqAZkwee19Ridm/sxOGgkh5KqIexq8dP3mdkbW8/dzW69CPkI9sIAbELHNqI?=
 =?us-ascii?Q?yH2iKW7xXnR1f3Q5tZ2EKxjtdBoCbZHBOwpC2m9fI4smKRvNqNkEfLmZ8hJ8?=
 =?us-ascii?Q?DA0744qaIi9WzTEWshpYNwo7STo7ENh4bky8YLHRjqTN2lGp7wSCu1eokBuC?=
 =?us-ascii?Q?yEM+/7YBzrNAhD98YnezdAGTgtiw/O01A8GpEWUUEChA0MvwqiXg6/jmpNGs?=
 =?us-ascii?Q?5w1IomlmtJw+LRkUxEKkdoJokh2tu4Cp9hlaACHdxxr0Vjvwb+M0ekI7vd4a?=
 =?us-ascii?Q?JFr/7CDn1a3HUf2d/J8y8nSMbY9klX8YVhbePUdQzC+OH/O12ExdTiTwlehN?=
 =?us-ascii?Q?OQCTUewFdG7OE+yQMIykubMrCvQAFzuzIJS1PYK8KS6T+yYeyadQZNBxkF3K?=
 =?us-ascii?Q?cJkxkVHSRVLL62wsWbmFsSu+xHZpi5IF6y8nJQABBKOLOTnHvsA83wQ7QsSE?=
 =?us-ascii?Q?XzsFDw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ceeb41c-640b-43ee-149c-08db295d74fa
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Mar 2023 16:09:17.6019
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: THXYNtP7VXnpVXMUrVOd1sQ90tK4YkS1YlyW+vRsRr8FLOlORxrzxgQtfs5B0BI3rx60FWJdK+57w935AeLXMTI5mDWOPQjsEh7/AX1gxcw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5462
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 02:31:55PM +0800, Jiasheng Jiang wrote:
> Return the error when send_pkt fails in order to avoid the error being
> overwritten.
> Moreover, remove the redundant 'ret'.
> 
> Fixes: 9c238ca8ec79 ("Bluetooth: 6lowpan: Check transmit errors for multicast packets")
> Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>

I see that the error handling is imperfect - only the most recent
error value is returned.

But I think this patch introduces a behavioural change: if
an error occurs then no attempt is made to send the
multicast packet to devices that follow in the list of peers.

If so, I'd want to be sure that behaviour is desirable.

> ---
>  net/bluetooth/6lowpan.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
> index 4eb1b3ced0d2..bd6dbca5747f 100644
> --- a/net/bluetooth/6lowpan.c
> +++ b/net/bluetooth/6lowpan.c
> @@ -474,22 +474,20 @@ static int send_mcast_pkt(struct sk_buff *skb, struct net_device *netdev)
>  		dev = lowpan_btle_dev(entry->netdev);
>  
>  		list_for_each_entry_rcu(pentry, &dev->peers, list) {
> -			int ret;
> -
>  			local_skb = skb_clone(skb, GFP_ATOMIC);
>  
>  			BT_DBG("xmit %s to %pMR type %u IP %pI6c chan %p",
>  			       netdev->name,
>  			       &pentry->chan->dst, pentry->chan->dst_type,
>  			       &pentry->peer_addr, pentry->chan);
> -			ret = send_pkt(pentry->chan, local_skb, netdev);
> -			if (ret < 0)
> -				err = ret;
> -
> +			err = send_pkt(pentry->chan, local_skb, netdev);
>  			kfree_skb(local_skb);
> +			if (err < 0)
> +				goto out;
>  		}
>  	}
>  
> +out:
>  	rcu_read_unlock();
>  
>  	return err;
> -- 
> 2.25.1
> 
