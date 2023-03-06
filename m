Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 152FE6ABF63
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 13:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230027AbjCFMZD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 07:25:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbjCFMZB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 07:25:01 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2128.outbound.protection.outlook.com [40.107.220.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92B5621A34;
        Mon,  6 Mar 2023 04:24:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k6aP3bKB59tVrYKpky+DRscXXqBZBj6cXzfePgPxIh+N1YJ9N/GBOzD+86SwVDj66OT147E4TCjO7Y19tbFbYi7jkkkkrUNis2xivabwxoeLNeHRkiy1HHPQhW4FFYLpaMsRk1GVIRKG4FSFzmTO2MSdrgMqy1cC1cHHq4aiBKMlN0U1+o/PKAn+jznt/ysW08KiJGBo0EFQvv4rgUpJ2BJopJBn8p9l1Mrc1EcG45BvDhLLVwMxRFryJzN6RRLWlcooXE3aksy6U7Zf7bmOvPE/xGsBQHLvP3US35onOKvuMhD7/WyalGlgqC6aqbQkPFOOMDbz3H+3P8a0VfX6hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dlN+iPFRCMxvsJamjQ5wMtshstDDb+H7nJF0UnYzQhw=;
 b=OWOYXpeUcMEf6GBhiXf8RFxW9zz9eoM4ldzskKSSIELNd+eOHoVCX43Go03Lprn0Tj9mUg6H83wFyyzmpe+HIqp5Qi1u5I+R2lBPfZmSoR7tgaez9Kh+qVW1/lO1IZipiRyvR01DLmg9AGMZ/W5/HfgkuJKo9vc10zSsd/2t9uAbiZVmNKx11gPZmBGrBjBhJDyQ5f3Sfg9zOzWEnRwvPAA1vPOrvGmdGnQbelBQFwRfkKqhbBo7tCTY+/rBXP++wwMPC8HH6xALmjo78me7Bb8sr/hZC30Q85sUHBaFSsJEDuN+WkiVxv22yW16kKveB0bnylCFmMkmRTVy8VctmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dlN+iPFRCMxvsJamjQ5wMtshstDDb+H7nJF0UnYzQhw=;
 b=otQ10nAqYgEfaScRiXQBUjU7rdsSoYNJiVEwQDLvUvR97dGtWjyV4MNTfgBtKAbXiJl9cjo/ExWMyquHGqUJTvfcVb1sq6DTJkt8Ysj1Le3HphDb9wM0kV5FU62RT694edsTJOFG2Ro0UNm4LkFuDXpvpPdpauj0Z31Ibc39V2s=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM6PR13MB3987.namprd13.prod.outlook.com (2603:10b6:5:2a5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Mon, 6 Mar
 2023 12:24:56 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6156.028; Mon, 6 Mar 2023
 12:24:56 +0000
Date:   Mon, 6 Mar 2023 13:24:49 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     "D. Wythe" <alibuda@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, wenjia@linux.ibm.com, jaka@linux.ibm.com,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH net] net/smc: fix fallback failed while sendmsg with
 fastopen
Message-ID: <ZAXbkUh4h2rIJdR2@corigine.com>
References: <1678075728-18812-1-git-send-email-alibuda@linux.alibaba.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1678075728-18812-1-git-send-email-alibuda@linux.alibaba.com>
X-ClientProxiedBy: AM4PR07CA0007.eurprd07.prod.outlook.com
 (2603:10a6:205:1::20) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM6PR13MB3987:EE_
X-MS-Office365-Filtering-Correlation-Id: 5add2def-4b2a-471d-da55-08db1e3dcb78
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UGOCJBMhLr3ah4D35tAecaC1JH2FZF1itQnd/3tfcc9bYB0rio+KxxiLwfjymwilayH1WxwDzc7+nwoVvlbUGixvFRZbtlSSvUcZFgPrMHqxVQf+tYS2ja+Ao+5bkqHcl7zlCQSWwOJfcqJJed+m2Fj+RsqeWqT+QuY9wbn0iIDv3CF4n+76S0hO+5xuyVsz+C3rIwWiXbNhTFGgjiEOjz4we/LyaPEjvgP0R9zIPz0CwZl1yHaU88Kh4+P4Vk8NkBU6flBaelpzB8yIkwlSwZ9ArFUk/QweD1BF6lf+ybqhZuzJxkgDZnVtPMEwE91YpN7i0yeWxsX4iJIXgu5iXdSDOoaUGOTQlLPkQ4LJCfzealSOdrJWpNSvRTyMRH0CtubOqfz5M2XCuAPABG0u5a8oVK1akWv27e+u2kC7+/frdtaIGQXcOW+yD4Np/DfKSxGbvwUKSND1uzUMzcfDq4CsG6wipNxnZkZAOWztglh1Zr2u50Zoo8pYh5VZ+l+H3aEVCz9qvqbTunVUX+ANwLSzrVmMyzizJdaxn5kedi16bghp6HLvjKv4yW5HKqqKrMyAAIgyyjzMJ9n8KO9wl0XztwcZgzmkFMx2Uz/3Ym2mq7/ChCttAj7nO+UoK4KprsQPqRTOLjvqNBVkluEi0w+DEme9aLmktiRVrQFXzoMxkB4NadvnJiuTA5ptaMNx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39830400003)(396003)(366004)(136003)(376002)(346002)(451199018)(186003)(6666004)(38100700002)(8936002)(6916009)(66556008)(66946007)(41300700001)(66476007)(4326008)(8676002)(44832011)(2906002)(5660300002)(478600001)(2616005)(6512007)(6506007)(6486002)(316002)(36756003)(86362001)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?61iCe7n9UmE/YcNd432iruhHM8ewYsKnx+m64DNNxowE5JTfPSKFnWQkodaQ?=
 =?us-ascii?Q?DCfvoBoLBWgC+QmxNlHsSLjHVuQQP/cWRTeqYc8eakJ7frV3dtCW9/TFKvZZ?=
 =?us-ascii?Q?e/HSCAt0b5g34EWklTG7iZ3LCfQhppMFMYPjk2kI8LcBViEFwXNT8SyT6f4V?=
 =?us-ascii?Q?L47jDRtKxYmCD62AJyhbkrvkJQIozdRwUNNNSn/A5Z0hHoBol888Zf7J7H4A?=
 =?us-ascii?Q?FkKtB/X5QQS8LF5sDe1EdhT2P11+8wvxREChwfJe86as15daf4hsS/X/pN4W?=
 =?us-ascii?Q?AfKapEiIpxq9h/K6u430EYhiQj97fbsXRRIoGIICZ9ni6LJcAJRTkbycJ91m?=
 =?us-ascii?Q?HH5vhdqTn18NcrYw6QT8dKf6pDNV4pBm8NTHz4sd05LacSQ0vQu9nDnZD7wK?=
 =?us-ascii?Q?fpjgGveSKnO1cdmK9wYzqh9k09wUvItua0dFVQy1FO1eF0FUcVNtSuQkkxjJ?=
 =?us-ascii?Q?ujViGVrVJQCRlyu93F5d9rMFMsdvsk9859DSYfHkJ65qyjTru0IptuO8EzNg?=
 =?us-ascii?Q?vCcnDGtEpRPp1oRxqQQGFmUmIgrSrYJ0gI92mGDvnXmDp9PS7TIkj8gjzGRn?=
 =?us-ascii?Q?3uposh/o2yLhNSJL3w90NRgdyiscR8TGXhXXCuh1LuCty/iC8+3RZANFBUeV?=
 =?us-ascii?Q?NyKJRdGFmy9yo08rS5Gbw/qpN7M0m6qAfSj/T0rP6uIWXyezoP32fnT/Wjom?=
 =?us-ascii?Q?Nf7SyHc4Hb+Z24C6jg3tkyrQnuYpHrhgKFUswpOIP9LeKhQTsxBRUldWdf1g?=
 =?us-ascii?Q?hGV7RceFuwjGmQERH1Z9SC1aaihRNlyN8TbLbwWvp5Vn/mKDIwQr4R/9gVve?=
 =?us-ascii?Q?H3Eo9hQC/w1gix7DAZLbcLTc5S/GixLc1jwUn7lEAXJ30/ApC4omHvpVrzaD?=
 =?us-ascii?Q?uRCnJxiIvU3z9PIxvqPN7Xw43Ny2WxXO/MMF5S73nIrX7EKGcvZsSzpXc6Ie?=
 =?us-ascii?Q?PKMND0CJCi22AD+KmcmiieJ/FzE60ycQPmw9jHCwTGq2oMvFdl7yVTjdUmyu?=
 =?us-ascii?Q?9kM+uWLxb0X53XMiPFcsbi3pBA1SmdN/t8XnHKGGERFAzGQeRh0mB93Xk6UG?=
 =?us-ascii?Q?PaRk6EHSmRQgS3wN3pBVUTogKcfkjL8jIESLW08n4ENjcdYamN/E0h3ztmFC?=
 =?us-ascii?Q?sGAJpwro705A+5Z5ZiJjvE2AgKpUu+mpYS0QMcxoakxbdAy8lyzjz/0FOzbB?=
 =?us-ascii?Q?AEoqmaLDjskPJcQ3X8aU1w0cdISp0tbv4mvl3iETdCejbfco3/GIUHpeAb1M?=
 =?us-ascii?Q?BrOSmCJ2tcBdeJ5Ujvyl9u4J5BKOPTffup3bOZm2wL2/6UjHvWh8B/CeE1T7?=
 =?us-ascii?Q?kxiIOYnNTBluggjXqszTugy0G7whATQXMPs4NkVmJOSICqQikn3tdXBa0uZV?=
 =?us-ascii?Q?dozIOgsgfTXhn80GX94tlHbmKCQRWs8ce6ESnEXNaCOHkkfV9JRQf6ox1BuC?=
 =?us-ascii?Q?XH/bAKH/38Cy+5ydNyZNQg5Dwtn8ykn+P23LBjsfbchJJE9JGPt0vKzLASdL?=
 =?us-ascii?Q?CtUmgfJNC+2PoUn55GE3w2fMU623B6LFJ1vbsXPvRbXU5HYdqhlwGbg9Oe9E?=
 =?us-ascii?Q?ycf7LdXa6MedUZ5C5XtqPoz3eb1cm11Nz+epIiRrrIgxAN3tkSw7lBAW9z02?=
 =?us-ascii?Q?7E5SdT/S4VJqzFm2vW2T88q6OvY41mhQcaWZ6g1+oxBz0t6pQATaWKXR+QK7?=
 =?us-ascii?Q?iqZkCg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5add2def-4b2a-471d-da55-08db1e3dcb78
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 12:24:56.1714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Sh4eFFyRp94TSGNr+KNCXpVy1zC/W5muDH+E+6KXfHcWRJYTNTJDW9G4Dx7o4tW/rvCTw2/xgKJdINQmNi6Tz6Y4cao0+Of3k/8dLCRfxuE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR13MB3987
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 06, 2023 at 12:08:48PM +0800, D. Wythe wrote:
> From: "D. Wythe" <alibuda@linux.alibaba.com>
> 
> Before determining whether the msg has unsupported options, it has been
> prematurely terminated by the wrong status check.
> 
> For the application, the general method of MSG_FASTOPEN likes
> 
> fd = socket(...)
> /* rather than connect */
> sendto(fd, data, len, MSG_FASTOPEN)
> 
> Hence, We need to check the flag before state check, because the sock state
> here is always SMC_INIT when applications tries MSG_FASTOPEN. Once we
> found unsupported options, fallback it to TCP.
> 
> Fixes: ee9dfbef02d1 ("net/smc: handle sockopts forcing fallback")
> Signed-off-by: D. Wythe <alibuda@linux.alibaba.com>
> ---
>  net/smc/af_smc.c | 26 ++++++++++++++++----------
>  1 file changed, 16 insertions(+), 10 deletions(-)
> 
> diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
> index b233c94..fd80879 100644
> --- a/net/smc/af_smc.c
> +++ b/net/smc/af_smc.c
> @@ -2662,24 +2662,30 @@ static int smc_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
>  	int rc = -EPIPE;
>  
>  	smc = smc_sk(sk);
> -	lock_sock(sk);
> -	if ((sk->sk_state != SMC_ACTIVE) &&
> -	    (sk->sk_state != SMC_APPCLOSEWAIT1) &&
> -	    (sk->sk_state != SMC_INIT))
> -		goto out;
>  
> +	/* SMC do not support connect with fastopen */
>  	if (msg->msg_flags & MSG_FASTOPEN) {
> +		rc = -EINVAL;
> +		lock_sock(sk);
> +		/* not perform connect yet, fallback it */
>  		if (sk->sk_state == SMC_INIT && !smc->connect_nonblock) {
>  			rc = smc_switch_to_fallback(smc, SMC_CLC_DECL_OPTUNSUPP);
> -			if (rc)
> -				goto out;
> -		} else {
> -			rc = -EINVAL;
> -			goto out;
> +			/*  fallback success */
> +			if (rc == 0)
> +				goto fallback;	/* with sock lock hold */
>  		}
> +		release_sock(sk);
> +		return rc;
>  	}
>  
> +	lock_sock(sk);
> +	if (sk->sk_state != SMC_ACTIVE &&
> +	    sk->sk_state != SMC_APPCLOSEWAIT1 &&
> +	    sk->sk_state != SMC_INIT)
> +		goto out;
> +
>  	if (smc->use_fallback) {
> +fallback:
>  		rc = smc->clcsock->ops->sendmsg(smc->clcsock, msg, len);
>  	} else {
>  		rc = smc_tx_sendmsg(smc, msg, len);
> -- 
> 1.8.3.1

Probably I messed something this, as this is *compile tested only*.

But as the code at the out label looks like this:

out:
        release_sock(sk);
        return rc;

And smc_switch_to_fallback sets smc->use_fallback,
I wonder if the following is a bit nicer:

diff --git a/net/smc/af_smc.c b/net/smc/af_smc.c
index a4cccdfdc00a..5d5c19e53b77 100644
--- a/net/smc/af_smc.c
+++ b/net/smc/af_smc.c
@@ -2657,16 +2657,14 @@ static int smc_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 {
 	struct sock *sk = sock->sk;
 	struct smc_sock *smc;
-	int rc = -EPIPE;
+	int rc;
 
 	smc = smc_sk(sk);
 	lock_sock(sk);
-	if ((sk->sk_state != SMC_ACTIVE) &&
-	    (sk->sk_state != SMC_APPCLOSEWAIT1) &&
-	    (sk->sk_state != SMC_INIT))
-		goto out;
 
+	/* SMC does not support connect with fastopen */
 	if (msg->msg_flags & MSG_FASTOPEN) {
+		/* not connected yet, fallback */
 		if (sk->sk_state == SMC_INIT && !smc->connect_nonblock) {
 			rc = smc_switch_to_fallback(smc, SMC_CLC_DECL_OPTUNSUPP);
 			if (rc)
@@ -2675,6 +2673,11 @@ static int smc_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
 			rc = -EINVAL;
 			goto out;
 		}
+	} else if (sk->sk_state != SMC_ACTIVE &&
+		   sk->sk_state != SMC_APPCLOSEWAIT1 &&
+		   sk->sk_state != SMC_INIT) {
+		rc = -EPIPE;
+		goto out;
 	}
 
 	if (smc->use_fallback) {


