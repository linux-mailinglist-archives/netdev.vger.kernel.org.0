Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 702476AC7EC
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 17:29:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbjCFQ3D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 11:29:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjCFQ3C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 11:29:02 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on20702.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::702])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13EFC3527C;
        Mon,  6 Mar 2023 08:28:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jWBdeWc2FMY0UScWv27N1SsLvq5DwYUidwRmHtk45gvXBaAYYh5Jyp2a1OUMa8noiQuHr+wHkN/fV6zUi/K2sphZ/X2a7SG1r7T44i111S3eBjCgMNvA2WnMO0L3QHAjktGh2hsP1bO+D/BRl6ezEG9zQzLRBjUdIwTfGgDuleIrYJ38xdmJdyYjWpavy9LBlEUVtWAFtv9fSCQPwH2RPC6Gk8anFzSDZPBI2kcEAjVVcsuhlVLa6rTIA2NTRCD9INceWp/Xs0eIl+y7YVDF4hZCwimqMa6dB1M/dWZbAdm9o+5agst1fpvPDAnDFEqbuRPXr3aC0m51akZSkpzKww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IKKXB32K4nwlVKvny423mmIIT3OT8vOHZStjOyOQ6WU=;
 b=mDblxvS3O2VNZJRt+skvzm/4Dqo1kNxn/qDcIndRCHJjkgiMw13zwfYhTubDBlcOz2jkmVrkX4HjAnmEhLY1krtmlQVwxVxPurpJL/tWDtvQ2oze5CTyB+HlMD2E+vU2viitbhjUVIdckfoqmi9BsM88F387EIXaoJPT4xPJuLCDqLgicj0ZQEDF/zqjCq+GEJK0kNBsPFJJ7mvQABnwFzujpFtflRMVyDdoURIsAfRK7vdam5BpTsY7ENNaDZTu25uOBepMkzr+JPPPN5gCI+UyN3HuqRJTH7gL+9dSHeLCOOfD6dgRz++Tj73DITgMYaN1njuLJpO39JMJnLt22A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IKKXB32K4nwlVKvny423mmIIT3OT8vOHZStjOyOQ6WU=;
 b=kO3XMBxNiIRfE2VYgr5wuLMFZ3/EzAv+5VY28GDBkzuloyxLbqP8otxQ6TrF81Aw3ukqHNMv4ZKXWvf/+UMJpWzRo+eXB6Z/RU40XOsVVXOk8jIhWg7kXugVA5PdEyb4S0aabvyD+mn/oO9JGfFV8CBcHK7x8BjZic3qfofG7nw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5755.namprd13.prod.outlook.com (2603:10b6:a03:40e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.27; Mon, 6 Mar
 2023 16:27:06 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%3]) with mapi id 15.20.6156.028; Mon, 6 Mar 2023
 16:27:06 +0000
Date:   Mon, 6 Mar 2023 17:26:58 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netfilter-devel@vger.kernel.org,
        network dev <netdev@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, davem@davemloft.net,
        kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Aaron Conole <aconole@redhat.com>
Subject: Re: [PATCH nf-next 3/6] netfilter: bridge: move pskb_trim_rcsum out
 of br_nf_check_hbh_len
Message-ID: <ZAYUUplZOcAUu5Xc@corigine.com>
References: <cover.1677888566.git.lucien.xin@gmail.com>
 <688b6037c640efeb6141d4646cc9dc1b657796e7.1677888566.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <688b6037c640efeb6141d4646cc9dc1b657796e7.1677888566.git.lucien.xin@gmail.com>
X-ClientProxiedBy: AM0PR01CA0109.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5755:EE_
X-MS-Office365-Filtering-Correlation-Id: 0fc52c39-a9f2-4b0b-a034-08db1e5f9fdb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O81nB8EdxZF3VTGArownIDJfnWwLYyNk36rY1AgaBgbN9gYKqsPh7XdizxVOSgHECmo2hWMxcqMD/C9RJNPhqf2G73GwPZ5Dy5wiRJwqy3blyRCIyuZlukojr6jgp1esFgkjCsCbbQbJk1H2dMBurtzOJEPE15oS75vI6Q9ghMB8wB2s+4/jynAT9nLbbeIKBdyr18ba/VuaoojuIu6d2OsGwdc0gRPL/Y0bQY5Nf3V7OCauSSII8KjnmgFsj99YywMKtWqwCLUgoY/hee1kAazKguNXNVZYJ7Vaf+n8CnnSTjdfD6myNn3BHOzLKbC28aLMKrmjtOj4vjvczN67qPvOUYZz3iVnTnfS6aE8xm1uZo++wqZtM+lbq/7pzuZSltZgQ5L72ZjaO6nDtCLR7b518dnv6om4EhsZdalxNGizkEFpr5zvQ+v4gIDk/ODROCkF3HCqdH4aSdSr/q7UFO3sJhaysFXCDtlP8pmmRToxVaQCkU46jxZH4IX0zJrmzEfrK02hDnVgRsAREGwog6oj54E3AAI0iLz01BGwn230rKF+EZXVAOzJwZmTlVODVNr5eqd79fvf6iwk5b8PXbh7j7V4uQIz6/uLN8Zb1v6572ZnWnWmpSqVWmjKgpHGSvLYG6Xn/vrDJ5sG+17WxV2yF2XdmUgYiAyosKtCPlIbF4H5KDX0GRIKfQ6i03Fy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39840400004)(396003)(366004)(346002)(376002)(451199018)(6666004)(4326008)(6916009)(6512007)(66946007)(66476007)(8676002)(6506007)(186003)(66556008)(41300700001)(8936002)(7416002)(44832011)(86362001)(2616005)(36756003)(5660300002)(83380400001)(2906002)(6486002)(38100700002)(316002)(54906003)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?shrAS7YIWlUYpP4Ih1bVqQESSQFHy05FlQzVo3vRFv303x7mttqq3wCMqxQE?=
 =?us-ascii?Q?QeuDwWtdyiCusXB3z1AavR18JNJ94L2F1vwpRyEMYqhyYN0lTvD2h9Od29po?=
 =?us-ascii?Q?J2hrGBoOx/tVSZwybfV94Nw74tdesPxWb1peB/GWOFrU6lBELEURSHVnWIwE?=
 =?us-ascii?Q?2grDwvvORFvkr+p3gqUmmPegRN/dE3fo/R/+qLLrS0c7TtovQ5g9XF74jg9a?=
 =?us-ascii?Q?YPF2n63yBOooZCcJOoSvNlVqceOIGFxvqoECwMhycvc7EVoGM9CfAX+kAKZO?=
 =?us-ascii?Q?bmmzDs6b9a48QW3BdV0/g0lBZW3PUMNPqL9TkaI1oB8OyG+3BPQdR7iWpTap?=
 =?us-ascii?Q?x5IX6Mjr/5IOt2aNNq3ygl5N39HxBMk3jpKyC3aGpVo7AjLIYE/YP4H5T4tm?=
 =?us-ascii?Q?XhSrL1J13Irzc+UaahRzi52NGetiJzCld80EwpsYbZ9CmDtBch/NiDU5W836?=
 =?us-ascii?Q?UoN//O3RLxfIzFkva8U/gY/2CxtVTLgRZCVqn5/0EI+2kg2xH9QVLK3rm7PS?=
 =?us-ascii?Q?kfKJgQtMB5ktiQjcuS/RUoq+VI8z8j0NnPSR6hRkb+DxW5ZuG+vVvaDMvplu?=
 =?us-ascii?Q?DG8xweGFt887v2XQb5lPXsGtLQI36A8oincgGKwOuPLugSLVb02MLfBugr9e?=
 =?us-ascii?Q?+AglbtaJYRUDztfwwuAwV5cFpTKCSFc5v2mojcFg1/iUTdVsGw3lVOLndr7w?=
 =?us-ascii?Q?0UNmw5tBzSNkzgRL7P57zHKTRf5cAwVHiZcRtYDJDWEXX+AHiA1T7nafdwWx?=
 =?us-ascii?Q?2V0zQzuF5/zoU58DyZoK99x62c0mbu1usbuC0IazRjn8FjtpAjfCGNQ2B5P/?=
 =?us-ascii?Q?fSm80SAZILgWygPzmG7mPT6r+Yh2sb5zE1ow1P9YGW+zbovnJ2h3NrxosOgH?=
 =?us-ascii?Q?JPW84j5moBZLN/yPe3OHC+NAn8t8NTd3efhbmaRwBCLEv4lR+UB+age3VYqj?=
 =?us-ascii?Q?GQBetoz/DruavIt2glxvM4P5ztgFBtQmTbtmIbkMw1WP+5EQ5ZU/dNTN30S9?=
 =?us-ascii?Q?vebpXJYwApI0SeFkfELSpiE7bL0PlX6Lzy4u4QgJgYFkoOsgNouXBgMY468o?=
 =?us-ascii?Q?m3NfMwcO15Tkse5WlnbQqykVmzEmCFYTA6O9pXfjX8GVooJ3qz46W/pHZkX8?=
 =?us-ascii?Q?nA68MMZ7N1Y3uLhX+9BwYAb4PQYU1XhIgB5EOcVAknx7ZLr/aRVZnt+XkDTG?=
 =?us-ascii?Q?3EAl6JOuO1XNDDuIFqJsDHI8Y1Bi0A/IF7K6x4W32OyUN8vc83PdILbwPPPZ?=
 =?us-ascii?Q?XvAqLIue33/Y7nQIUya42naRQ5e6Br9B4UIv6RL/plYJ6Wph8UqhNxZkvPlM?=
 =?us-ascii?Q?yoVgWpA2G8q+jDjcHEJxIJEDR70NzU7PGIDTCF7o0Uzs9MZDeAeTmjncMTUR?=
 =?us-ascii?Q?kaznJDEsv2Ke/3QxDFTNsYAMk0i5n+mOlkE+K3lC6DQqVG82Osdd2199AjSd?=
 =?us-ascii?Q?Mi225Y8Mv6W2CEABNdKwCPUonPZDIh9jlm2D+AQZEgNP++FI6ln1aNBYLU3e?=
 =?us-ascii?Q?d4EJoldJ/WSwzGDW9rXbEfl0o2VridMcnLuomar/5NME/bjATMlKMNHybmN9?=
 =?us-ascii?Q?jNUjT8Oh7ygLuLqzl/sjG4tIvRtB3ioYOUQ+C/IYB1idslO+bj1GgA4N5KA9?=
 =?us-ascii?Q?qjaPWtqNNo0xKjK8cxpAevZnlzOY48zHqWcP3Rhl2RedC3EjfTmYz+JXZwtY?=
 =?us-ascii?Q?ot+MRQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0fc52c39-a9f2-4b0b-a034-08db1e5f9fdb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Mar 2023 16:27:05.8878
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iLrfEEUsGdDKTiMZlPVKWvtODM1dDGyLbsEtBvhmZoLvhzodo+cDWNeq1sXjdKNwhajFdcUoLhdmPQDs+x8h05RjDQjKNTP1oOD1X85fhDs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5755
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 03, 2023 at 07:12:39PM -0500, Xin Long wrote:
> br_nf_check_hbh_len() is a function to check the Hop-by-hop option
> header, and shouldn't do pskb_trim_rcsum() there. This patch is to
> pass pkt_len out to br_validate_ipv6() and do pskb_trim_rcsum()
> after calling br_validate_ipv6() instead.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

> ---
>  net/bridge/br_netfilter_ipv6.c | 33 ++++++++++++++-------------------
>  1 file changed, 14 insertions(+), 19 deletions(-)
> 
> diff --git a/net/bridge/br_netfilter_ipv6.c b/net/bridge/br_netfilter_ipv6.c
> index 50f564c33551..07289e4f3213 100644
> --- a/net/bridge/br_netfilter_ipv6.c
> +++ b/net/bridge/br_netfilter_ipv6.c
> @@ -43,11 +43,11 @@
>  /* We only check the length. A bridge shouldn't do any hop-by-hop stuff
>   * anyway
>   */
> -static int br_nf_check_hbh_len(struct sk_buff *skb)
> +static int br_nf_check_hbh_len(struct sk_buff *skb, u32 *plen)
>  {
>  	int len, off = sizeof(struct ipv6hdr);
>  	unsigned char *nh;
> -	u32 pkt_len;
> +	u32 pkt_len = 0;
>  
>  	if (!pskb_may_pull(skb, off + 8))
>  		return -1;
> @@ -83,10 +83,6 @@ static int br_nf_check_hbh_len(struct sk_buff *skb)
>  				return -1;
>  			if (pkt_len > skb->len - sizeof(struct ipv6hdr))
>  				return -1;
> -			if (pskb_trim_rcsum(skb,
> -					    pkt_len + sizeof(struct ipv6hdr)))
> -				return -1;
> -			nh = skb_network_header(skb);

nit: Something you may want to consider if you spin a v2.

     It seems that pkt_len is only set here.
     So *plen could also be set here, simplifying the return path slightly.

     Also, if so, then a not entirely related clean-up would
     be to reduce the scope of pkt_len to this block.

>  		}
>  		off += optlen;
>  		len -= optlen;
> @@ -94,6 +90,8 @@ static int br_nf_check_hbh_len(struct sk_buff *skb)
>  	if (len)
>  		return -1;
>  
> +	if (pkt_len)
> +		*plen = pkt_len;
>  	return 0;
>  }
>  

...
