Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59E84529ECB
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 12:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343803AbiEQKHJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 06:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245712AbiEQKFg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 06:05:36 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2049.outbound.protection.outlook.com [40.107.223.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F67D47AFD;
        Tue, 17 May 2022 03:05:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NUFZNJu1fU7A2uMQwUhX5WFhuZLV+5djfrNLTIdLcTJbx8AZFxsmHx53PsNcqN79aOA1OhfspoblZhuyhf8LuuYLjQvcepKMuWi7fKb/2BCaDKVnZjbcuxuRYX9hnjyf+QmkCWuNLUrybMlG/XOElMTJRyZjpaP5RI01lZ1w65XdscyBElGAceXsZ8sXgsFayeNGeQ+gK5pNWyM8+ZHhi23ddQFLtrNOhzTugQunwDRbOtDqAiBbZ1hCvoBfweIxsig+WkhGJY//miiXrR/2PJbaOq+WowUi88kMGYHBvWPcP1SJZ69VtAX3KUEBHQ6ouqExVp0iXWY0OnVj2ihXRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lCV5aubk6fq3Vl5m7l38QJEDEk+82AdrzypxgNhuRZQ=;
 b=mQN7On28Gr8oxqE0n/FSMuAA8I9dwe0XQb5vJBqIlQtVR4FSXTtucRm4CkMmegFCQ4aT1KNgHij6lEzM0mzuIrRwJWi5aO0AB7xR8rXyN6yadBKkp76rphOYYh57s/E676b18+tJHushC/F8JJx0apLVfnIQ7lvEqe1hpchTiF/Ajbcu587DUVzaWa36S/pr8KFv7v3FB0sGcRGyqwqg1VVYxIu7P5YP19Gd+/1I9juFurAwNHj//1WeJOOczumfFPikktR8XMok0CuqzjuzOcf0/vmaLOfycnzAvCktPH6cbrmAGgk3gGkXVWrOMpdEEaMAOVX5017qJrlj+MbyBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lCV5aubk6fq3Vl5m7l38QJEDEk+82AdrzypxgNhuRZQ=;
 b=d94PTVAIv9d/QnDb18zp0YMi0h5KOQngwWrTJKPGJz/I9qG3GSeRj51eCsp6tgVL+sHpyL2n4Qx11ji8Y2q/sPlL5nUBt/Vjkzihk07hKF8qyk1ggSnfjGX44i3SRTSrItaVgoIPFVi96tRc7UnJvV8t2URBKU2xn92tFikuSraqBHxuPcH+9K8KgfEY+WMWMpn0taTI65f0dO2Fqm5N9pB4W9nAAl1OX86YLOwGpNyVPXuVfQjSP/Xw6RBWpTKSl9YBN/q+LNZcucdNRxA2Rv+Ssm7ReWuBYsruu25DxuruTM/MIljgaZYnrpmxjSc29KRLtEGuF+oqRVaU8dEKHw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1307.namprd12.prod.outlook.com (2603:10b6:3:79::21) by
 MWHPR1201MB0093.namprd12.prod.outlook.com (2603:10b6:301:54::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.18; Tue, 17 May
 2022 10:05:00 +0000
Received: from DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::146b:b38:d5fb:e5a2]) by DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::146b:b38:d5fb:e5a2%7]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 10:05:00 +0000
Message-ID: <f8247247-4109-18bc-c422-a69619b50258@nvidia.com>
Date:   Tue, 17 May 2022 13:04:53 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH nf,v2] netfilter: flowtable: fix TCP flow teardown
Content-Language: en-US
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     nbd@nbd.name, fw@strlen.de, paulb@nvidia.com,
        netdev@vger.kernel.org, sven.auhagen@voleatech.de
References: <20220517094235.10668-1-pablo@netfilter.org>
From:   Oz Shlomo <ozsh@nvidia.com>
In-Reply-To: <20220517094235.10668-1-pablo@netfilter.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0438.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1a9::11) To DM5PR12MB1307.namprd12.prod.outlook.com
 (2603:10b6:3:79::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ff6f3a68-02b9-40ab-25f2-08da37ecb442
X-MS-TrafficTypeDiagnostic: MWHPR1201MB0093:EE_
X-Microsoft-Antispam-PRVS: <MWHPR1201MB0093C79A43AD9E069B803DD4A6CE9@MWHPR1201MB0093.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: viBn/43koKX5Ep+g6EhcMqXcp7cll64ZIBdHdulouyWBg5X+AGDHiZStynqqT296GgSphLMa7F1cWLuBEQ/9+KSQ0kEdzgQVFRQEHPeGBNhwE454uVXLbCrf9eN3Fv4/9LXIKi+vae2CyPauhS1pl4yhhOQb2uROw0TwPZ7nA2ZOWg9+kLTwbcUl6Y7/P9Vq7jQ9grBewW/w+ZIP/2QWv1NIUXFKvpvs1nuZW+KsMxiJ/fVC+gh0zaNaft6667cwJUyTujk+MMpnu4RADAPydROXnrdkjUwE8HD23HcYFFFBhPIyLK0VoAQUDlp7nqsuMoq1oD2NeT0pslT3U2am6GeOhRlChyetFlIQwp53i4+UCmZoiMuX/VGcuJPoUNymsQ/U14PDPITHbp26XpMTMSRxroeAALZ2ErGHIwGzeFqWL8CywTXJ3TVZBKjr9QSTjgdHpCICdmLbWOEEIa07tf/LPSEyzMv1hEQLJlM6CEFAfIgvbHe/aiFHUKcRimb0B1P+i+6wgvbc6ZJp0AQgw2opGxUo5KSWHUu1/t1qNUV8ns9r4xZqFp0intWVNcJW4BvOYYxBmGAHZ0G4cM9vxyjgJdkNmlcNSnuT9w9wZ0RNQF7SLeYxw3dW7y1Nl8hF+pvV55UQu9KgGeneSrIpEtkXLwwcNbY/7B0BRHIswsbiiIWdm1hvWlwPY30Yk030liDrPM4r/NLcoJ29eNNqgifh8h7BvU0OLTyILsIMmuTxqtbSyPREqhc7gzEt5L85
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1307.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6486002)(186003)(86362001)(6512007)(8676002)(31696002)(4326008)(66556008)(66476007)(31686004)(8936002)(83380400001)(38100700002)(316002)(53546011)(6666004)(6506007)(36756003)(508600001)(2616005)(5660300002)(66946007)(26005)(2906002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?K1VPUk9mbGZtZ2FDazlzZ3VDd05GamlsWE5KcDZ1dlZENkNuaWpmK3JWOStJ?=
 =?utf-8?B?ZU1YOVB2U0crRWs2Q2RpM1ZTNHpRVkhVOE9QNFg3cTQzM1F0blhtMmVFYkFy?=
 =?utf-8?B?Y1N0ZUd2WSt6SVVHek5PbkpUU0hCMmZyUFU1R0FML3VsTjc4MnQxV21zbElx?=
 =?utf-8?B?a0lVZzM1VU9iOGIrQ1lrbk1wa05oRERKeTNNSHJ4NDdFbGY1UUltNzdvbDRV?=
 =?utf-8?B?cXdUWGVVbmNxVVQwT2d0K1I0VitMVTBIVXJwMVJqRGhWRFp6ZGJxK3dTeDM0?=
 =?utf-8?B?MmlwOVAwVUtBeG1vR3pRV08xWFgvWlhKUzdwamczZmI5TE1HeDlnRXRVS0Ji?=
 =?utf-8?B?Sk40am1FaG80UmJQOTdmVkdDYUJKbVVMWFduTUVsUFBnSUR3QmNlSERWZlRI?=
 =?utf-8?B?S1UrZFdJUGxzSVl5K2VPWGV3K3A5RXZwMXdrbEJCalorMllrUFhOb3hPMFBp?=
 =?utf-8?B?Q1FMOXd1eFlzbU05UzdySFZtQ29HMEc0RWp2YWZoKzBuejRtWDQ1TmRlNjZY?=
 =?utf-8?B?ZmtLK2tRQWtJT1Z1S0NaaEpvbnBycHFnLzZWMkVDR3ZtZjZsWXdhd0RKZmo4?=
 =?utf-8?B?RUxlRGc0QlNMUEFUZFRYM2k3dUEydVFxRDBsVTYxZ25yRkpHVVdPY2lDUHEz?=
 =?utf-8?B?blN0bE4vbFE3ZTlqU2NETnhtZTJsUHlHL1ZnbWJEZjlWVzV1OTVlSGxEUG5G?=
 =?utf-8?B?OWFqRUMvUVZGUTJIRFFpdURCbUVKSmJKdk1FY3gzM1p6WEQ5eFpnVXVHNmhD?=
 =?utf-8?B?NGZZSVlOTFJaZ0lRdktuYndOTnZTZUlFeTR2dFBNR1NDTFp6dmwyUi9wOFNI?=
 =?utf-8?B?dUs4OUVIV1NwRkdnK1dBYWswcmQ3b1k3RGl6VzRTallUeHJEYXphbjJ0b1NR?=
 =?utf-8?B?Q2RPbUNWeGlua3RuYm1YMkg5ejQwRXBENUd4QTVaR0thU2xXaUY2WHdBMlpU?=
 =?utf-8?B?WjdhSm9weC9uUGRuNFhYcHNwU3pzejg1eDdNbWVoWTgyLzltdzZ6QmR0Qkky?=
 =?utf-8?B?RkdNMnpIQXM1VnJGMkpabnJjcUFLTFhybFBRRDk1WkU2cUd3cllXODJsdzhS?=
 =?utf-8?B?ZGtiSmRZNWtZVU14Q2RGYllFNlRaQ1RSTlAzdlpEWlZLRWp1UGZPNDAzUUlY?=
 =?utf-8?B?dSsxNHNWM1haMjk1RDczUXM4emx1RzNWUE1mWTJDQnNOYTNZdUNVY1hUd1M4?=
 =?utf-8?B?WUk1Y0crZXpBcnR0aHpHYUNHZ3FoMWdOWkU4ODZ6b0RZZyt3MkhUUDhFZGUy?=
 =?utf-8?B?ZExHbER2MU42OGRFZjVGazlmeWd3eXJRdHUrQ00vQ0daVU9ibXZ3TGFGUzNl?=
 =?utf-8?B?cWNBL0xQRllERjhaSFVydndkTnVNdFAxZzNGVGlrd3A1ZTNFMmFwWkhvMjlP?=
 =?utf-8?B?d3ZOOVl4RndLSUFvZE5jUEk4SzN3VjlNak5ZbkNrNUtDTTVldE50VjN3Y2d2?=
 =?utf-8?B?UXVRR2ZiY2U5ZlM0RnBIcjJwbkM2azJXZUpkcFA2bUZlM2RickR2eUxOK3hq?=
 =?utf-8?B?cEFPSjJ2LzJCLzRBSCtJOXJETGtQQzYvdlhLMGhKNFZKVGZqVW5vbVkreVVO?=
 =?utf-8?B?R3hRUEhxaUdXd2VzYlI3UDdqVFJsdkF1Q0w0WW5UenhMY1FOWUdBOWFMWlJ1?=
 =?utf-8?B?NGZWQTIxM0QyWjZLRk5jRll5amRFVU9EOUF0OW04NHFqa0NOU1J0ck9TTEE1?=
 =?utf-8?B?SVFGYWNBVkprRjNhLzV3ZEdVUW1QMHhPemo0RU5pa3lxSU5zaldRQkdvMXVu?=
 =?utf-8?B?T0FvdXVrK0JGVlB2dDc4TDh5Rk9hU3JtL2gxN3kwUTNqUi95MDZFVElFbGM0?=
 =?utf-8?B?K213Tlh0VHZST3BIV2I2MzRFYlRnM2NaNGYrWXNVZzVOUEhMbzMwZEc4YkQw?=
 =?utf-8?B?ZzZCT0JBR1RKYWY5Z1l3VjBmUHU4WklCcHg2ai9aTlZnSGtzak9hQTdKNXoy?=
 =?utf-8?B?aENmRjlrbGwvQ2dCazNqYjFBWGdDSmJ3R1NBQVc4a20vb0pHWmhxS0cwN2ln?=
 =?utf-8?B?U0M4RWh3M1ZiOWZpOHppWnhBKytzUE5ZZ1ozdy9FSW5pRTRuTWs3bkR1U3pJ?=
 =?utf-8?B?NTZIcTBXTUlCYW5XM0Q4ZTNaS2RiT0w0VENWeG1vNEpCc2FVK21oemZKTmIy?=
 =?utf-8?B?VkQrZnBWSFBUTG11L1lvYThMUkVYZ2psclJXaDdCWmh4SzZNd1prVG9YTjJ0?=
 =?utf-8?B?Y0pjeElkL0dhNVIzSnlpTElVYjFVcHpFT1RCdElPRGxiL1NJRC92MGJ1SGtZ?=
 =?utf-8?B?OWUraytwLzFCOVR3Nm0wZEdINHVpRjdTUVhjWW1xMGxncGcrVkF3MmdHaHNY?=
 =?utf-8?B?VFhQQTQ3Z1NWdmlaeHU0WUJhRVJhcWZNMFA3bVhnZC9kcWV1SC92UT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff6f3a68-02b9-40ab-25f2-08da37ecb442
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1307.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 10:05:00.4889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cMP34/tqcAc1/Xq17wxRocYs23cpFlK1Nn1l0vlXm4XXJkdxm+VUkXOIDRNqsKQ6
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1201MB0093
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Oz Shlomo <ozsh@nvidia.com>

On 5/17/2022 12:42 PM, Pablo Neira Ayuso wrote:
> This patch addresses three possible problems:
> 
> 1. ct gc may race to undo the timeout adjustment of the packet path, leaving
>     the conntrack entry in place with the internal offload timeout (one day).
> 
> 2. ct gc removes the ct because the IPS_OFFLOAD_BIT is not set and the CLOSE
>     timeout is reached before the flow offload del.
> 
> 3. tcp ct is always set to ESTABLISHED with a very long timeout
>     in flow offload teardown/delete even though the state might be already
>     CLOSED. Also as a remark we cannot assume that the FIN or RST packet
>     is hitting flow table teardown as the packet might get bumped to the
>     slow path in nftables.
> 
> This patch resets IPS_OFFLOAD_BIT from flow_offload_teardown(), so
> conntrack handles the tcp rst/fin packet which triggers the CLOSE/FIN
> state transition.
> 
> Moreover, teturn the connection's ownership to conntrack upon teardown
> by clearing the offload flag and fixing the established timeout value.
> The flow table GC thread will asynchonrnously free the flow table and
> hardware offload entries.
> 
> Before this patch, the IPS_OFFLOAD_BIT remained set for expired flows on
> which is also misleading since the flow is back to classic conntrack
> path.
> 
> If nf_ct_delete() removes the entry from the conntrack table, then it
> calls nf_ct_put() which decrements the refcnt. This is not a problem
> because the flowtable holds a reference to the conntrack object from
> flow_offload_alloc() path which is released via flow_offload_free().
> 
> This patch also updates nft_flow_offload to skip packets in SYN_RECV
> state. Since we might miss or bump packets to slow path, we do not know
> what will happen there while we are still in SYN_RECV, this patch
> postpones offload up to the next packet which also aligns to the
> existing behaviour in tc-ct.
> 
> flow_offload_teardown() does not reset the existing tcp state from
> flow_offload_fixup_tcp() to ESTABLISHED anymore, packets bump to slow
> path might have already update the state to CLOSE/FIN.
> 
> Joint work with Oz and Sven.
> 
> Fixes: 1e5b2471bcc4 ("netfilter: nf_flow_table: teardown flow timeout race")
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> v2: fix nf_conntrack_tcp_established() call, reported by Oz
> 
>   net/netfilter/nf_flow_table_core.c | 33 +++++++-----------------------
>   net/netfilter/nft_flow_offload.c   |  3 ++-
>   2 files changed, 9 insertions(+), 27 deletions(-)
> 
> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> index 20b4a14e5d4e..ebdf5332e838 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c
> @@ -179,12 +179,11 @@ EXPORT_SYMBOL_GPL(flow_offload_route_init);
>   
>   static void flow_offload_fixup_tcp(struct ip_ct_tcp *tcp)
>   {
> -	tcp->state = TCP_CONNTRACK_ESTABLISHED;
>   	tcp->seen[0].td_maxwin = 0;
>   	tcp->seen[1].td_maxwin = 0;
>   }
>   
> -static void flow_offload_fixup_ct_timeout(struct nf_conn *ct)
> +static void flow_offload_fixup_ct(struct nf_conn *ct)
>   {
>   	struct net *net = nf_ct_net(ct);
>   	int l4num = nf_ct_protonum(ct);
> @@ -193,7 +192,9 @@ static void flow_offload_fixup_ct_timeout(struct nf_conn *ct)
>   	if (l4num == IPPROTO_TCP) {
>   		struct nf_tcp_net *tn = nf_tcp_pernet(net);
>   
> -		timeout = tn->timeouts[TCP_CONNTRACK_ESTABLISHED];
> +		flow_offload_fixup_tcp(&ct->proto.tcp);
> +
> +		timeout = tn->timeouts[ct->proto.tcp.state];
>   		timeout -= tn->offload_timeout;
>   	} else if (l4num == IPPROTO_UDP) {
>   		struct nf_udp_net *tn = nf_udp_pernet(net);
> @@ -211,18 +212,6 @@ static void flow_offload_fixup_ct_timeout(struct nf_conn *ct)
>   		WRITE_ONCE(ct->timeout, nfct_time_stamp + timeout);
>   }
>   
> -static void flow_offload_fixup_ct_state(struct nf_conn *ct)
> -{
> -	if (nf_ct_protonum(ct) == IPPROTO_TCP)
> -		flow_offload_fixup_tcp(&ct->proto.tcp);
> -}
> -
> -static void flow_offload_fixup_ct(struct nf_conn *ct)
> -{
> -	flow_offload_fixup_ct_state(ct);
> -	flow_offload_fixup_ct_timeout(ct);
> -}
> -
>   static void flow_offload_route_release(struct flow_offload *flow)
>   {
>   	nft_flow_dst_release(flow, FLOW_OFFLOAD_DIR_ORIGINAL);
> @@ -361,22 +350,14 @@ static void flow_offload_del(struct nf_flowtable *flow_table,
>   	rhashtable_remove_fast(&flow_table->rhashtable,
>   			       &flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].node,
>   			       nf_flow_offload_rhash_params);
> -
> -	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
> -
> -	if (nf_flow_has_expired(flow))
> -		flow_offload_fixup_ct(flow->ct);
> -	else
> -		flow_offload_fixup_ct_timeout(flow->ct);
> -
>   	flow_offload_free(flow);
>   }
>   
>   void flow_offload_teardown(struct flow_offload *flow)
>   {
> +	clear_bit(IPS_OFFLOAD_BIT, &flow->ct->status);
>   	set_bit(NF_FLOW_TEARDOWN, &flow->flags);
> -
> -	flow_offload_fixup_ct_state(flow->ct);
> +	flow_offload_fixup_ct(flow->ct);
>   }
>   EXPORT_SYMBOL_GPL(flow_offload_teardown);
>   
> @@ -466,7 +447,7 @@ static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
>   	if (nf_flow_has_expired(flow) ||
>   	    nf_ct_is_dying(flow->ct) ||
>   	    nf_flow_has_stale_dst(flow))
> -		set_bit(NF_FLOW_TEARDOWN, &flow->flags);
> +		flow_offload_teardown(flow);
>   
>   	if (test_bit(NF_FLOW_TEARDOWN, &flow->flags)) {
>   		if (test_bit(NF_FLOW_HW, &flow->flags)) {
> diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
> index 187b8cb9a510..6f0b07fe648d 100644
> --- a/net/netfilter/nft_flow_offload.c
> +++ b/net/netfilter/nft_flow_offload.c
> @@ -298,7 +298,8 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
>   	case IPPROTO_TCP:
>   		tcph = skb_header_pointer(pkt->skb, nft_thoff(pkt),
>   					  sizeof(_tcph), &_tcph);
> -		if (unlikely(!tcph || tcph->fin || tcph->rst))
> +		if (unlikely(!tcph || tcph->fin || tcph->rst ||
> +			     !nf_conntrack_tcp_established(ct)))
>   			goto out;
>   		break;
>   	case IPPROTO_UDP:
