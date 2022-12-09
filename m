Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DED6647B0E
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 01:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbiLIA6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 19:58:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiLIA63 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 19:58:29 -0500
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2079.outbound.protection.outlook.com [40.107.247.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD56D63B8C
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 16:58:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uwu25J6Dc7y0dytnGUVC/idt+Yronp4+NO/XajxSwl957YaLPO/i8/OdRugHouxskXUt+eMv8U1LQC4zqGcLchaZvaT16Iw5eACiwg9ZaSCnYMQmI5leJy6EsGpE+JnbuTebEGKA1dhJxzHmt03XnzaWZ6XM9mJz1UZQYeluuguVTSBMyHWpIPY6AUma2Ex5hFjBo6gunRjMEL6CrXk8Chqw5C10gznpMyYhELZh3AAuFoAsUW1YxcAwxzUul0nwqUvOxM80Xe0B9UBlbca1baCIzhQH1SZXBsVVaSUedRySMuGXm8t9mW3MD69mjXtASJgDQQhov2FcQ9+K0G1SLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=irkbZ5/dJrrn3NmXvhoLGaXHHQ3vMYu28NSn28vqTk0=;
 b=kC3T3A2fsmI4Ze/n4TxGRHw4eYZD72QoIM8D5RjD/BzXNT/YgwCn5kkF0J3i0xSwCGcj/AvuX8LxnHdSPJkXa1ZA1hVUeqDPDDTnqSeoO6nxBuv36Y+xRyGV8x+lW192VKUpWlfF0jGo0N8eFFW+diqEkYuJA/epY04kh98ihZu9WwQ9eFyf/oxiez3RIjEDGpn11R1u9igxQ4a3/PlONqBdx+wkX5Him5XHJTwKNh1cazUz7iNuKL6ErHtHWnLUqpHZSXQkV+3TmsaSt0ko3ZqQb4wnN9OJyIYJMv/r5UQ8ifpP8i4EabzfIrN3yR91RZ+8S1eBOHVGuQvd4EAdVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=irkbZ5/dJrrn3NmXvhoLGaXHHQ3vMYu28NSn28vqTk0=;
 b=Q6AB69WZh8CKU6VoUrSHliIMeFVTjd3/inyRqI0Dbl8ZCAS5JJuZulowEgsxSAlSDvDumAntKHAUJ56VQT6zNedh+Lwk8jchEO+HS6FtTf6a9py4/rs8FqvOQ344TMipf3262lug8ee76O5D4cob9TafrVcaiCU7RR3pigdU7Lo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM9PR04MB8570.eurprd04.prod.outlook.com (2603:10a6:20b:435::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Fri, 9 Dec
 2022 00:58:25 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::9317:77dc:9be2:63b%7]) with mapi id 15.20.5880.014; Fri, 9 Dec 2022
 00:58:25 +0000
Date:   Fri, 9 Dec 2022 02:58:21 +0200
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, claudiu.manoil@nxp.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, lorenzo.bianconi@redhat.com
Subject: Re: [PATCH v2 net-next] net: ethernet: enetc: unlock XDP_REDIRECT
 for XDP non-linear buffers
Message-ID: <20221209005821.virs3rtc2tth2lja@skbuf>
References: <1dc514b266e19b1e5973d038a0189ab6e4acb93a.1670544817.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1dc514b266e19b1e5973d038a0189ab6e4acb93a.1670544817.git.lorenzo@kernel.org>
X-ClientProxiedBy: BE1P281CA0106.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7b::10) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|AM9PR04MB8570:EE_
X-MS-Office365-Filtering-Correlation-Id: 86c0037b-4532-4e92-fd90-08dad9807a0d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ThrKKF3mxB6Yr6IvGnUajvcSbRJam+6B9LvR0rXOJCVZYBeVYAHtQl6c66q/DqpgIktxyj8LrsdxX1Qs2JPsbjhyCSLKySdCFB37PBvw+42iuorFgnUQOzXtAOp6548VBLUq1CLFHLEPRG5g+m9/GU4yRHca5t3tXke/+oQRo7kWp/oDDk8jD5ddnLmzHwSMS64BC5RnryCFzVVR1HSW7r5nkQ5eViS8vHjV37TaXBTzd0mjG7pLaXgd/56bZxFa6HJIZq6SLMKiaN5Ihlq0VsVqu4lF0321OCsq74gUNpf253D7Xtfs2Rmjmoo7Sy8BoT5S2dBF9I0wO8aiVwXQ4BcScO4j934k76kfLqcf4aX6iE36kOp6cWjlDlhitinWePfH0ABnVNbTeGahJTWQB/0AByguLwNydO2JumcXm/5LuZIAsBC22fUGuLk38vRLfzyRU7x05WXwBr48EuCqWfsDfcoa5uCdAbFcFOR+QZBv179ANYjz50ORXjZuYv4I3M0PUs0NF0t1FdVRaCfGfUi6CNnl6FeovTmBnfwTd6uSYFMAL6i8OBr40JRRC747jU53+b4VNTpxpEYkBPHXnpcfnqQoSyDAkJYShbcrd8UmH+k0LskxQvuwyjyQ3xphE6cBeVkcjzpcoJ8P7ofn/w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(4636009)(346002)(376002)(39860400002)(396003)(136003)(366004)(451199015)(2906002)(44832011)(6486002)(86362001)(6506007)(478600001)(5660300002)(33716001)(8936002)(4326008)(8676002)(66946007)(83380400001)(66476007)(41300700001)(66556008)(6916009)(26005)(9686003)(6512007)(38100700002)(66899015)(6666004)(186003)(1076003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mxqnpQ7yEeiD7qyP9YUq5RCXeyzUncnUy6uVSzTOfIwWlG8LQDwWHEGaVPuk?=
 =?us-ascii?Q?itCCeFufxFMJKItnBapIeLPz6t3+UJMG4waEcLX1X7L6I7Pm5grq7DxqgLjk?=
 =?us-ascii?Q?Bgt+YNO/rKgGOEOlHRGo1jZ32MZ/5KSU4iRS7lNaQ8GnOuTJVBpNHdkQ+Sjo?=
 =?us-ascii?Q?M6F/STSbWoGagp8g4iLcCvmJDl/zMzsOdm+quPc2jLep5mqrKbHi7rrf0C/k?=
 =?us-ascii?Q?8EF3sfRxdDLKXkPhRy/b6dzaFBFYaimhbsSl3LjoN1MlQwij+mvGt2MhhFYp?=
 =?us-ascii?Q?D8EWkoJs7jcKpQ/BselluNF7+u2pIgGzJd5gTqbrl/N7fSwo3uEfCrzfBZIf?=
 =?us-ascii?Q?VFsNC11WBAXUCbOyjgtBwyHRPCpzriSm1SCyr/dw/RRCuwj4blsix+VKM8Gr?=
 =?us-ascii?Q?sxS5IbSsN8uNa2fozJYL1gZt3fBG+hpKbaPNJrelEd7Wb9hXrZmjj+PtE2nx?=
 =?us-ascii?Q?Aj/mZIF0+Xn1DnxperpQX7yxe9XDQb6lLSzATdO7IMxJz8fobg3a5Oi+VMRI?=
 =?us-ascii?Q?S+UK7tu3nXOMu4rRpRErBmuASDdE4VkPQ6impiAlTB1Cax7DEU72OoQNfyUP?=
 =?us-ascii?Q?rB6fCVi2jvPgRH8VeZffV8rDPd4dbBP5+68BOuwssE4MrWVp6jch9Ee7W247?=
 =?us-ascii?Q?lIgJ64VOP/BOE+5SwwMLpVWeFR4Mlnuc54RhqIKJwRd7/3S9cC9kMLZwO07g?=
 =?us-ascii?Q?4aCfBqArDwGT8nzKNNh1lEmv6idwDNkpH233K+GiijvyG1itJPJ23aVt7y1L?=
 =?us-ascii?Q?MRNJ+djk+5BLI5ZuRMZmE4itQg9tEC1AhkoUpOnzDr8WR30oGnAkvfrTBxHu?=
 =?us-ascii?Q?r3FfVoAEx4KoH2fRUS+u19r25cs3STOTjjdheHxzwEG3e49nQvRcDfw6JTrE?=
 =?us-ascii?Q?DDD+7KPac/ffxwhU6bkt5SjnZCc2F9e7P/Tz27qZhGKkGbY027oMbRtdCTPa?=
 =?us-ascii?Q?gLnpqO31ECjtxalMMPYCjHJn22TijGtieSe6H9P8U+yPVWoe+mcofTJLVk8K?=
 =?us-ascii?Q?hkxA7ySNDcAeSqnJEwLKn7jkF36PyAiypLDNXACawAkeinyPQL5GczvqBe25?=
 =?us-ascii?Q?Pfn36AzAfs3ROgjE1TZUR5Rg7xLp5eRhkDKupZrXVZv0vg+MUU5kMcvyH15M?=
 =?us-ascii?Q?NcPOQEpXE7xL4c7wFwIYPlotfZX42t12FrV3FlSTUFQM5NB6g/xCBU98T9XG?=
 =?us-ascii?Q?ox3PjUudD4Hzf+NuDC37G8KSKLVFres85dJO35xDfdi/znU5VyaYGCKg1kNi?=
 =?us-ascii?Q?ScJUn3ChXdrVM5jLEqVX+C5i/QfDMkC1CLRqz8/Cdxmj8GIg8NsD3OVQnP94?=
 =?us-ascii?Q?EYShws7Lu6Ts7fWFA8wo+EAD8DijwoDwy9GVichTlsxuatuxt9yQBOLr+SHY?=
 =?us-ascii?Q?vG7oAIAlPlzB0f9SGNb3EgI+nqmuP1xXviCUX/QiNkRQwlNLu3zrh1qWnkEr?=
 =?us-ascii?Q?T9CzcU5ei7c9rp/+k9gMLp9uTfTT1oYkPFKh3xF0NpbL55KNk9zJSxUN0Gco?=
 =?us-ascii?Q?LSv9mOBsw64/FgWQ1eZJYxu/8adkNYLYY/Vv63LlmrOwmWLTLVmPN+2FH6GJ?=
 =?us-ascii?Q?jX6y7ikTSzZ4Bs8PtCcCKd28nr9aPZ1atpzkWV0r6CWe7oMqlti+mTV4wzto?=
 =?us-ascii?Q?xw=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86c0037b-4532-4e92-fd90-08dad9807a0d
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 00:58:25.5468
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3K0ESy7Ikx4siYIK4aatuH/J04g6NYi3DUj5f/FPEUTzyaeQCHWVe6gfxEOQf/uWOVLZblAj7z9Xjy8fdH3Uwg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8570
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 09, 2022 at 01:19:44AM +0100, Lorenzo Bianconi wrote:
> Even if full XDP_REDIRECT is not supported yet for non-linear XDP buffers
> since we allow redirecting just into CPUMAPs, unlock XDP_REDIRECT for
> S/G XDP buffer and rely on XDP stack to properly take care of the
> frames.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
> Changes since v1:
> - drop Fixes tag
> - unlock XDP_REDIRECT
> - populate missing XDP metadata
> 
> Please note this patch is just compile tested
> ---

How would you like me to test this patch?

>  drivers/net/ethernet/freescale/enetc/enetc.c | 27 +++++++++-----------
>  1 file changed, 12 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
> index 8671591cb750..9fd15e1e692d 100644
> --- a/drivers/net/ethernet/freescale/enetc/enetc.c
> +++ b/drivers/net/ethernet/freescale/enetc/enetc.c
> @@ -1412,6 +1412,16 @@ static void enetc_add_rx_buff_to_xdp(struct enetc_bdr *rx_ring, int i,
>  	/* To be used for XDP_TX */
>  	rx_swbd->len = size;
>  
> +	if (!xdp_buff_has_frags(xdp_buff)) {
> +		xdp_buff_set_frags_flag(xdp_buff);
> +		shinfo->xdp_frags_size = size;
> +	} else {
> +		shinfo->xdp_frags_size += size;
> +	}
> +
> +	if (page_is_pfmemalloc(rx_swbd->page))
> +		xdp_buff_set_frag_pfmemalloc(xdp_buff);
> +
>  	skb_frag_off_set(frag, rx_swbd->page_offset);
>  	skb_frag_size_set(frag, size);
>  	__skb_frag_set_page(frag, rx_swbd->page);
> @@ -1601,22 +1611,7 @@ static int enetc_clean_rx_ring_xdp(struct enetc_bdr *rx_ring,
>  			}
>  			break;
>  		case XDP_REDIRECT:
> -			/* xdp_return_frame does not support S/G in the sense
> -			 * that it leaks the fragments (__xdp_return should not
> -			 * call page_frag_free only for the initial buffer).
> -			 * Until XDP_REDIRECT gains support for S/G let's keep
> -			 * the code structure in place, but dead. We drop the
> -			 * S/G frames ourselves to avoid memory leaks which
> -			 * would otherwise leave the kernel OOM.
> -			 */
> -			if (unlikely(cleaned_cnt - orig_cleaned_cnt != 1)) {
> -				enetc_xdp_drop(rx_ring, orig_i, i);
> -				rx_ring->stats.xdp_redirect_sg++;
> -				break;
> -			}
> -
>  			tmp_orig_i = orig_i;
> -
>  			while (orig_i != i) {
>  				enetc_flip_rx_buff(rx_ring,
>  						   &rx_ring->rx_swbd[orig_i]);
> @@ -1628,6 +1623,8 @@ static int enetc_clean_rx_ring_xdp(struct enetc_bdr *rx_ring,
>  				enetc_xdp_free(rx_ring, tmp_orig_i, i);
>  			} else {
>  				xdp_redirect_frm_cnt++;
> +				if (xdp_buff_has_frags(&xdp_buff))
> +					rx_ring->stats.xdp_redirect_sg++;

Ideally we'd remove this counter altogether. Nothing interesting to see.

>  				rx_ring->stats.xdp_redirect++;
>  			}
>  		}
> -- 
> 2.38.1
>
