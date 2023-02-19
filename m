Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBC269C085
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 14:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229727AbjBSN4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 08:56:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjBSN4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 08:56:24 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2071b.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::71b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 441D910AB8;
        Sun, 19 Feb 2023 05:55:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kxbGy9OSZr+4sSJf3n0TgUYJVWeb3zXDzU+417clQMksWsoiPqtjKkSQS7YCKUqp1DM0d84Pd0BeP6XWt8SmWkr9mxSF9AnEKNbjX/viVxkdHmf4C6U7PBdZjad3pW346aNBuTiHoK/HHCt/mHk8KBa6Ff2v9lZXrpNLMV+Wce7j8ONs6CqPyEZUS48PAEmkjDJ1sqQXQpoIT3hWsGRFP9iaf6IrBcDa5yrqQTXw6vojnBjwMCcjIaO1YcHmSsFOWheDaB8Tdd10fpXeZXI8fpMV0gKCVKUdb3sDKoXf406bWrBrh9AARsxxFtMIGEf/ip7ZFCgi3NVJAgrX/jXKeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VaIDQUYw4OdflkjSeCF5QZpXktU1nAkcnA35T57NYaA=;
 b=Smdgwc1rEVSYCxXW6j+TT5yD7Fi0V5/quSw+iD1sV9f2iAxy7diSKcAAKNdnwE/AZAjKpnDb3lNOdYKlDWZOOK6w2NyETIcAj+MZMK7Q0zxHfjao0RhVyZ25omrPhHBR6z+wUGqPDFTz++OR0XsX9Sn7D5TMSjoD5dvh4FTVLe6BpAg9/h5MjDNbNVN9XaSoxhAA0YZVi2XukBg10rAwlioIyEkxmnUY07nFTpfHSsrr4iuEY6vXBKGYqj8Y7wSbPLrEUWFmMOSw9tMP+XEzyIQGvRF8EMMk+Yn3OEkQ84ejS/cqjhR2TFYAQ7qVZ+9EHELgOYOa4hU0S/VSi2ip2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VaIDQUYw4OdflkjSeCF5QZpXktU1nAkcnA35T57NYaA=;
 b=vSnjG7p/yvNLKo3FHhhTahuQS6FNurAhgQ5RWbuqDFsbYJJ7Mz4UpoTKRvy+AnnR3ngrdrOWPLObgz1i3o8BbsSBTGfzm7hQk8dkZ1h8i/pY58bNLeoCnDQmX3RgR2Bo69ZO2a/+SzFPtRWDKazxc8VnitC3omtHghcMc5a4yYM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5847.namprd13.prod.outlook.com (2603:10b6:a03:435::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.18; Sun, 19 Feb
 2023 13:54:52 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::85f5:bdb:fb9e:294c%9]) with mapi id 15.20.6111.018; Sun, 19 Feb 2023
 13:54:52 +0000
Date:   Sun, 19 Feb 2023 14:54:46 +0100
From:   Simon Horman <simon.horman@corigine.com>
To:     Eddy Tao <taoyuan_eddy@hotmail.com>
Cc:     netdev@vger.kernel.org, Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v1 1/1] net: openvswitch: ovs_packet_cmd_execute
 put sw_flow mainbody in stack
Message-ID: <Y/IqJvWEJ+UNOs6i@corigine.com>
References: <OS3P286MB229509B8AD0264CC84F57845F5A69@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OS3P286MB229509B8AD0264CC84F57845F5A69@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
X-ClientProxiedBy: AM3PR07CA0081.eurprd07.prod.outlook.com
 (2603:10a6:207:6::15) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5847:EE_
X-MS-Office365-Filtering-Correlation-Id: 2218c40d-465e-4d8a-3643-08db1280dfa0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cgq353g6WJ6U8rBketj4Kzrx2Ye+73Sa6RTctOn2ANReRFSKk0oATUi501Fbdag7E9zuZjyHy6CmpxThZCMs7Fp/z0eoJGsLbUpoLbsVEpdFaqwimOGlJ3on25SXjqI2xEDhCjQkzrJvXCrBcnoi2m0d/rnLcd2vc3LhTbwxPqvl+6lDTiwdKRStoUYn6575hyTwZLDm67MpR6Ff7b8CgUlVupW2xAGrQ/U2EcWNmuRj9Kk/P6ZQHbrReYr4Zx9c+mkVieXChFxjpDpVhPatKMFntQql+A/aI2vljQqU8tl/+kQZQFaP6UXwuJkx5erz+9p3STi8GC/K8g59mPDEWdz1vKMw1v5iBa6qUgj3fyIlt3ad31nZ3xS9eLGmRg+J7+h2wM2CJbLidoFGbmLKh7V3CQhVXilbobb+BwaS/e9tJ5hMWIWckrRN45qgkjao5kqCy+KAxOP9dHAV7q4TjpJ9Flp403IWVVWELPFjy6yHzmu24NhH2Jtr4hueA+akymkARlPKF3mjGyvh5QE/1EHFm7n44bK+g94ouvM9Yy5WFuY7gPp35ci0tR2zOHEZf14StPxd8ve3Lmmt3AkgZ1sn5oUpkQ7045/WdUizBxlx2O6A+6kIPBnDPyYqwj9xpQn/gveUHqgWBtGo/b6eLthubkCtshNEJzU2AmgOZLRlYnQVa3JUpRlBg9AYWYxf
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(39830400003)(376002)(346002)(396003)(451199018)(54906003)(66946007)(41300700001)(8936002)(86362001)(5660300002)(2616005)(316002)(2906002)(36756003)(6486002)(4326008)(66556008)(8676002)(6916009)(66476007)(44832011)(45080400002)(478600001)(66899018)(6506007)(6512007)(6666004)(186003)(38100700002)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MopPzRl+sQMmEKDE0Q22LbCtJ+L9vyT5kKgkpCoqcI5HcYdx7rIJtn4qthmY?=
 =?us-ascii?Q?muBli1YiAwa44LHli2faFW9yB4hXp7r9VpSyrLqtPS8dOXyTGPjBmtkQG8ht?=
 =?us-ascii?Q?9sIPvAzqItbMXHKRl9ytEQHz5lV+5Yt9LoXqIfPO1C5sGj40lTiFh101e9tM?=
 =?us-ascii?Q?h/SoCrKNXwO7XKYqIhc1cjRWfxcZZQ+oX39x8LTsoRayRtkev1hYsNPGZ+uf?=
 =?us-ascii?Q?SfSDEcn4BOXPEaJIDSzdISroE3F+cD46B5kANeMn+zXY0utHAkul8ECv0Jv8?=
 =?us-ascii?Q?imQlR0HFA87/P/ORAQV40QNbVt7I/sU6AAhxmJnTObFRW6uBWUmuIpxBxr6d?=
 =?us-ascii?Q?5G+c5vhV7nCzhgh0i+DWrhFr1t3qHxPbdct58scYbDAdI/+D1bF7DF6PtT+5?=
 =?us-ascii?Q?DVnESI0h/F4HiSPAR1HjD10cOaG/H3FrlHDPw+vQTw+V1O3tTV9LlsDdhFjY?=
 =?us-ascii?Q?/bMd++nLiIWH+1Sf/J0NtEmzi7Q0UwJCD3vpyjf26L6Z1mSfIM9ZuW0N7RPO?=
 =?us-ascii?Q?5yRw5ceGTBsMHDEjxUSIAivaliN3my6Ce1gyNSGLl0REUs7eX7ilyGpxrsMJ?=
 =?us-ascii?Q?EkJrOCWymI8vFZFlEnE5VggoqH0wH1GypH00A5mE7XN55RCVYFbuG7AIZmuc?=
 =?us-ascii?Q?hKUcIFCavC5B3O+LJK0gte3ovIExBPzZIwY1F5TIxQh9Vn9utNOeBptpE/tu?=
 =?us-ascii?Q?tKYNJz17KkbHYqWHVUSG6W+KDEA4MW2j9Nvwx1rjdcREl+Fi/eYnY2g1+8le?=
 =?us-ascii?Q?HAIRWII3OAQwWFknvtdzj6d++IYieOwgAn04V541jXfIDNuM/GZVs5I4WCZD?=
 =?us-ascii?Q?W9ubKr5NCthrWHTYWS73aNWFXXrFKWgclKhSIzSIPGwuhdx574u6P4eHZV2V?=
 =?us-ascii?Q?eynIVXbqjJU4HzeASm1GM/IP5f3QkexIJLv8+Th9oK8htEoFfxYz3YcQqYR0?=
 =?us-ascii?Q?nYEneOlWNySO6UuVxXm9YhX8K5H7Q/3uUP0bF9hcNUlszRgf0i2iX4YEMBse?=
 =?us-ascii?Q?FSQfw7A/NWS78Hc7erYxZfgU7g/NBHeHETXmUqv5ZPbypLyG/I/60MUreM/R?=
 =?us-ascii?Q?Wdds2tcimVBd++C9+6vcFSj7Pj2/veJ22LW1sWjWQIrEPtnNlyZYQt8LACjK?=
 =?us-ascii?Q?tmF9/rslxAwWqhj04xsTH6HRg8Gu0sun6JqB2PGSeNwIeReqzW8PN3Y65tVb?=
 =?us-ascii?Q?SngwRGa+UbUAyzndpulmyW2gQsCKOdQoMJyx+0+wG8HEmg7Upu90BRTS6+rB?=
 =?us-ascii?Q?e98rdnN6QhZ3DuwfJFCQye6aqlA7q3r169bxvfmiucj+BFrmJ7V075qvgB7z?=
 =?us-ascii?Q?GZZY5Nj+SMQXMpDfkfgPQlr2lbM2/oAPflBv8Niol/VZpo9+hF6br31sWLxk?=
 =?us-ascii?Q?jAjf8PU+QORghj0JCqRup2ukUFIhixiy5qq1nBg+2uJlvM+/HY77E3goxtHC?=
 =?us-ascii?Q?IZzjE7RcrHFfeqTSLfdcWhHVErB1mimpYr+lNhntfcdoJ6ilVqzIJibL+LA7?=
 =?us-ascii?Q?hARr9P/j2bqvNleJyCoHa5wtzSfvG6AnkthPXWOUzc6ZF9H7pQhfYj5yiaUX?=
 =?us-ascii?Q?Oqgv3nPBLg28dY60MMCGbyQdnFtZfcQgdDXvr2UxCHMFw7xlO7vcghNnVZpc?=
 =?us-ascii?Q?fdLObf+rKZvFFwiUkhWYP+TaYAqbJj5lWFNCl2IOko7oLyfM7gKyJwmw2VOC?=
 =?us-ascii?Q?FtTKzA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2218c40d-465e-4d8a-3643-08db1280dfa0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2023 13:54:52.2176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: du5rzu+3MWgk4MUxEvHw1lesOrr+LyrEKNO0wXjuWJlID+2CU3u5l7LFCjOjUTQ+gA883xcF3PE3k1sad1StrBPivBZlDnfJY8PHXMudluI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5847
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 18, 2023 at 02:53:29PM +0800, Eddy Tao wrote:
> Add 2 performance revisions for ovs_packet_cmd_execute

I think that in general it's nicer to do one change per patch:
i.e. split this into two patches.

> 1.Stores mainbody of sw_flow(600+ bytes) in stack
>   Benifit: avoid kmem cache alloc/free caused by ovs_flow_alloc/free

Perhaps I am wrong, but 600 bytes seems like a lot of stack memory to consume.
And thus probably needs a strong justification.
Do you have some performance numbers showing a benefit of this change?

> 2.Define sw_flow_without_stats_init to initialize mainbody of
>   struct sw_flow, which does not provides memory for sw_flow_stats.
>   Reason: ovs_execute_actions does not touch sw_flow_stats.

Are there other code-paths that would also benefit from this change.

>   Benefit: less memzero, say each 'sw_flow_stats *' takes 4/8
>   bytes, on systems with 20 to 128 logic cpus, this is a good deal.

Less is more :)
Do you have some performance numbers showing a benefit of this change?

> Signed-off-by: Eddy Tao <taoyuan_eddy@hotmail.com>
> ---
>  net/openvswitch/datapath.c | 22 ++++++++++++----------
>  1 file changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> index fcee6012293b..337947d34355 100644
> --- a/net/openvswitch/datapath.c
> +++ b/net/openvswitch/datapath.c
> @@ -589,6 +589,12 @@ static int queue_userspace_packet(struct datapath *dp, struct sk_buff *skb,
>  	return err;
>  }
>  
> +static void sw_flow_without_stats_init(struct sw_flow *flow)
> +{
> +	memset(flow, 0, sizeof(*flow));
> +	flow->stats_last_writer = -1;
> +}
> +
>  static int ovs_packet_cmd_execute(struct sk_buff *skb, struct genl_info *info)
>  {
>  	struct ovs_header *ovs_header = info->userhdr;
> @@ -596,7 +602,8 @@ static int ovs_packet_cmd_execute(struct sk_buff *skb, struct genl_info *info)
>  	struct nlattr **a = info->attrs;
>  	struct sw_flow_actions *acts;
>  	struct sk_buff *packet;
> -	struct sw_flow *flow;
> +	struct sw_flow f;
> +	struct sw_flow *flow = &f;

I'm not sure it's really useful to have both f and flow.
Could we just have the following?

	struct sw_flow *flow;

Also, it would be nice to move towards rather than away from
reverse xmas tree - longest line to shortest line - arrangement of local
variables in OVS code.

>  	struct sw_flow_actions *sf_acts;
>  	struct datapath *dp;
>  	struct vport *input_vport;
> @@ -636,20 +643,18 @@ static int ovs_packet_cmd_execute(struct sk_buff *skb, struct genl_info *info)
>  	}
>  
>  	/* Build an sw_flow for sending this packet. */
> -	flow = ovs_flow_alloc();
> -	err = PTR_ERR(flow);
> -	if (IS_ERR(flow))
> -		goto err_kfree_skb;
> +	/* This flow has no sw_flow_stats */
> +	sw_flow_without_stats_init(flow);
>  
>  	err = ovs_flow_key_extract_userspace(net, a[OVS_PACKET_ATTR_KEY],
>  					     packet, &flow->key, log);
>  	if (err)
> -		goto err_flow_free;
> +		goto err_kfree_skb;
>  
>  	err = ovs_nla_copy_actions(net, a[OVS_PACKET_ATTR_ACTIONS],
>  				   &flow->key, &acts, log);
>  	if (err)
> -		goto err_flow_free;
> +		goto err_kfree_skb;
>  
>  	rcu_assign_pointer(flow->sf_acts, acts);
>  	packet->priority = flow->key.phy.priority;
> @@ -677,13 +682,10 @@ static int ovs_packet_cmd_execute(struct sk_buff *skb, struct genl_info *info)
>  	local_bh_enable();
>  	rcu_read_unlock();
>  
> -	ovs_flow_free(flow, false);
>  	return err;
>  
>  err_unlock:
>  	rcu_read_unlock();
> -err_flow_free:
> -	ovs_flow_free(flow, false);
>  err_kfree_skb:
>  	kfree_skb(packet);
>  err:
> -- 
> 2.27.0
> 
