Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C21BA529E21
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 11:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243360AbiEQJgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 05:36:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244969AbiEQJgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 05:36:19 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2082.outbound.protection.outlook.com [40.107.236.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA737659;
        Tue, 17 May 2022 02:36:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f3KMTTa/O1Vxdk2QwEp6ZN5dxCGxK3YQBRCkIJD581PxKCoeOE+/C3e0V+rrw3coeE1n+DVLBUP70umlhDMDPelq9sY8E65NS3M/y6zVJ4JEh88HQ2ELgTdJPUEwkZCB4+o1M3MV+VJIP3LiZRazsW2kTAxP2UC1JKMl78OMrYEeViT/wThb3ci4YrR4pvjN5VxQMfpABaGMenFx7wZzuoRP6gxb4ZG6rgcEFHO17inNrU6pIpKFcHyqJuLptWN02DdpR4704znXA358l6xDDINOfomcycGvrAIP0eswHpFaOUyPlPpqFDeiPh6DAaehyvxo/ZLqecTBxlxdOcAZCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8it8M5OO0TIP2ZydIKsQo31jEinIYneOB0GIU4GnTDk=;
 b=W//5aTvyhzh5T2pvGThzAhU17rhKzg5ar6AVCNWsS/VZoUTvO1zlNyq3JB7mRvSNjCKZMs6VdWdjHcIR0jo1NtFMBkVi8okSdDeKd5SJVThtDdgOl2epltIkJx3y1R0vp3UJ0ZydgxN6m1hv2Ttz//X7ybx1WewmUVLF86ESDpMl4VMjM9Pqd8tM5JLEVXGn/S7jWC526tAX0b5zqqi3pqNrysuOGEQRu/brlkcPhHlpZkeVAbhgFW5hFtz6ZYi0yesAUtGkFQD8SlE6Dq4Xx+nEBJJUDtxmJwhbb31Pyb5WA30O8brDLfo9Uf03gRtq8sWCuiypQPYnKdRexwDFeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8it8M5OO0TIP2ZydIKsQo31jEinIYneOB0GIU4GnTDk=;
 b=o9JmenyMaCyawbSV9Kiz22pzvNQJ/ETiJkQbZy282bOqtYpsByya9+4pKc8YDCsGckM6n7bUZCLjFFAPEekeRy+5eOhjw4nsLczU7mCSJfeaZ3SugaRPS7gfmDBq1gvQn1ypujC643zlEFS0rcInYiSAvpSjL/RtycwpD83qiKxWai+0ws4Ewk1OQQXwlEQ0yJJkF+BydS2gRu9o0EJ8XxuB4QNhn7MiM/YQg2wiCmTYYeZMW6Ybzk77HAwX4H3LPK71X3hSq8YQNm2Qc7pLHBBRkrD01HKfgy7b9fIhOahexaBo/cwviCCme/E1XJ5SIDnXpMQbMTAQ9/A9j3ngVg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM5PR12MB1307.namprd12.prod.outlook.com (2603:10b6:3:79::21) by
 PH7PR12MB5687.namprd12.prod.outlook.com (2603:10b6:510:13e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.23; Tue, 17 May
 2022 09:36:15 +0000
Received: from DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::146b:b38:d5fb:e5a2]) by DM5PR12MB1307.namprd12.prod.outlook.com
 ([fe80::146b:b38:d5fb:e5a2%7]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 09:36:15 +0000
Message-ID: <6f09cbe8-74b9-6d95-0fe0-8745f5a23658@nvidia.com>
Date:   Tue, 17 May 2022 12:36:08 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH nf] netfilter: flowtable: fix TCP flow teardown
Content-Language: en-US
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, sven.auhagen@voleatech.de, nbd@nbd.name,
        netdev@vger.kernel.org
References: <20220517091830.7276-1-pablo@netfilter.org>
From:   Oz Shlomo <ozsh@nvidia.com>
In-Reply-To: <20220517091830.7276-1-pablo@netfilter.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LNXP265CA0063.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:5d::27) To DM5PR12MB1307.namprd12.prod.outlook.com
 (2603:10b6:3:79::21)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 38e9f1c0-6cb3-43af-5285-08da37e8b045
X-MS-TrafficTypeDiagnostic: PH7PR12MB5687:EE_
X-Microsoft-Antispam-PRVS: <PH7PR12MB56873C7ABDBABA8E712DB286A6CE9@PH7PR12MB5687.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DQND8HwhGik90zTWdrciMg7qkwrAG85uyFv5M0RXBeW5+378QTRwzhNOrYh3SoPRhfmcdERizu7ynpDwyVV14lWAy4U4oWXHKaqfb5Z5CbNdKvyNG4OGlnxEe/TBKYNDk4nuWbflKNWwAMqojJXOEaKhs9/lExUY7LDwUlomEaCbfbw2QO54TF4lGso1xe+yIGltu2DnYJPU6ClUuwYKHkQxaTSZJ9Bz7zGL07fgjz6AFrs0sXpR3f8pAqu9tP1wlyEaic3FPFXwnP+xHOo0kTk4Cyp8CiNtkwgwAsxZ4+FnrffIlo41BJazxckiOd12WSVoWq4ZZOb4EbpzIXWHjU6xwl/igdYWYuf9yBKaE7slvlRnvryF7skRMlUBpFNoZYj2Z3C3455Svk3S0Qt+eUiC8+IDlBEOWnU/nxEW7t4YB2ZnLtD4HJ0X3Vf9l5vwcf2tS7bRbE1d4WdLwqIlDZ3NW/4eKxhLUwenp6gnatDUTAf2izL6rGsG+F9Sq6ldrAJL5s29CfUt50p2aCcgceBvUslIbCODceoin9eo6tnRmdysLek4XMwM6qLf/EUAKgIgTiI5YUuoYde2oxLKQ+VSsJmJd42jjeSPPoGhA8iaNXtQiXWC2TDDRgqXy55LONAAOrYg0btOiKqOtYk5RstoVrnz5AiPTGLghYnFOOnJnlsQUCZKW64h7A94+GAAG+5CfuS39lcwCDzL04httx+g6B6fl+T1TZc6fb/QhqM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1307.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(316002)(66556008)(66476007)(38100700002)(508600001)(186003)(36756003)(6486002)(26005)(83380400001)(31686004)(6506007)(2616005)(86362001)(31696002)(6512007)(4326008)(8676002)(2906002)(6666004)(8936002)(66946007)(53546011)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bEhFZ1YxQ0Q0Z1psemNzRUVTWm1ZRURoekVaSUJ1WVpNUVNyd0Y0eHNiNVBI?=
 =?utf-8?B?azFjMjV0SnZYeXlsdEZLR0hhV2ZnVU9QYjE0NVhURGhma3BUTzFEUUxuc2F6?=
 =?utf-8?B?ZnNobXc4QlVqK1doUUE3Wk9jWUtzaU9DN2RQQTVHRkR5b3RBWnNadHdITmFI?=
 =?utf-8?B?b3dnMnNodXp4dzRjaDg0WnNvMXlUR1BIOTNuaC9LWS94QlhtdlVET3pHREZU?=
 =?utf-8?B?Tk1xN3Q0YitockRsVGlHbmdGeFRBdThhQVM2dUdDVGxDSnZTWVQzLzVFSGxa?=
 =?utf-8?B?Szd1d0paOHBoUjdoeEFtMllSL0lEMnJvNk5CUzZ6Uldud3ZTd1pPS1hZQWp2?=
 =?utf-8?B?dXVsSGpZNzRCNDd6TlU4S3dCQWJRNXlJZ0RCV0MxMUhLc0ZXYWRKVHFuakRJ?=
 =?utf-8?B?bElIcmRhekt6VGwzSDRCTjJCZWVKTUFHb2FzU2V0WlNGRkwrRWJPODRuN1Fn?=
 =?utf-8?B?R1kxT25MSnlid1M5NEI3MDNzNEJkVjhxMTJzT29SUW9DZVBwbit3UDVmVXBP?=
 =?utf-8?B?NDdmSnZ3c3R0YW9POWo4UDlkVTltSitESGpjbnVLZU9WZThIOFlhZFBUL2V5?=
 =?utf-8?B?a0owSHBPNmRjRzk0SWFDSXVwZGhPR3ZIaXVSNWhCZE1QZ05CVnUycXpIc2dh?=
 =?utf-8?B?TEtnTDJJcEwxMEROVmFCekJacC9DOStGbUIrU1BFeWlDS2dGVXNCWHZLZlg5?=
 =?utf-8?B?aWNjOXR6TmVKamZFTWlNMWl5cWh0cy9zL29FRnl4UUQ1b0R2VDM5QjhyQnNz?=
 =?utf-8?B?bzN3NDZvU0c5UUlhNHF2OE5sL3pENFZGYjZCY3puc0lRVXA3bEx1S3N1czJw?=
 =?utf-8?B?YnBwMEp0Q0dmZW5adkMrNVpSWk5pSzBxUjlKSTJPYVFwVzB4VklscGJ2UG9q?=
 =?utf-8?B?Ujd5QU1MYmg3cGZDVExPOUg5TjZmMStUU1dZV1pncmQvWEp6WUpEdFoyTEx6?=
 =?utf-8?B?R3RydERqUVRROWhjTGs1VkVMQlQ4azVuc1JLaXpaK1J2a1Rjblp5TXd2Mm94?=
 =?utf-8?B?cGNIYitZRmlZUk0wYkN5WkQybXBmbGRDeGZXejRMQ0FiK3AwdmFVQmNxTStx?=
 =?utf-8?B?Q09OU2VTTlV2ejdHZS9sNEE2d25oWTNFQ2Z1NlNhK3JkNEkybTBTLzgwVDRi?=
 =?utf-8?B?aVQrUGErMnUxWE9uRUY1SDNrSzcyNG5jNGxYbGtaaUh6bDRYRTk2a2ltcDFE?=
 =?utf-8?B?bmIzYmkzRGI3d3Y4dEtKaGhDMUVQV1d6SWQvWThScVZKNWxLRzM5SGhEa1Q0?=
 =?utf-8?B?clJkTmdZZzhQdjFTSW53cnJieEhHTS9tWFVGbXJ6Z3hGZkQ1eHY0THlBWHl3?=
 =?utf-8?B?NmRXK2RXaWc3SG5JeEt5UEFocDhaNmRzZXRnSTd1UUlRY1pOQzBWUXhybFA3?=
 =?utf-8?B?K2Q2VmUzRlUvMnIvOHFwcHcrMGd3blllZFF6Q0R2WlB1T1RLaEE3L1RVWHpX?=
 =?utf-8?B?Y1g2b3Y1OW5MdDZrWW5zL3k4L0ZRSlVwZzdhdkhiYXdiMFFzWG9ISXJoRC9Y?=
 =?utf-8?B?UzlqcEQvYmdRRzJtbWJnVU5zUUdwS01KU0ttZjlRSzArRFRxTFE4bFVMTVph?=
 =?utf-8?B?ak1QVlB3THhwaGNRTnZqdXV6elorK2kvaWdzbFBSa01DYVRlNEcrSDl0UmVu?=
 =?utf-8?B?TjU1QjFsQlc4RWpZaEpnS2FEYXljcnZDRkY3ekxJSkFxVjZhTlV2YVR3WlFP?=
 =?utf-8?B?ekQxQmNqb1NLSXU5cDZYL3dOc0xzNEcvTjFhMW04YU5rd25SVzA3UFJ0RjRC?=
 =?utf-8?B?YkNLbXNyS28xU0kzT1hBckdwdi9KVkRhbWJHQytyeXlIVWg4aERIcU5EbVZP?=
 =?utf-8?B?UmdPTHJCc3RrN0QrZHFDbEdVK3pEMVZUSGZOcFc0TXZ6NUtuajJXWm5nWkw0?=
 =?utf-8?B?K0xXb0JreDJjT3hzWkxSQlFFQTNKTzVkMUpnYnNUTXRxM3pDRUVDYVkxTVQw?=
 =?utf-8?B?VEsrQWRUcy9OdmY5M1VYSnZ4WTdNVG9ucVJNeTBmWXE3MFFSZUdtU0Z0K0FW?=
 =?utf-8?B?dllVOHFhUjRUa2RSYXhmb0FOWFo0TC9jMDVoaDlldUwrbUt1VGVZdm9IaVNp?=
 =?utf-8?B?bDJrMWQzTG9GOW81bGNtRGt1cngxdXBValcrTmhGZjFST29zSTZqcGZldmcr?=
 =?utf-8?B?bHVGUkYzVWQrVkdVQnBnaXdydTFTcWdnbnhNMmtKT050M1lBczdPTitTQUh6?=
 =?utf-8?B?NlpraTc5eHd1SWVrZVZtbGkxdThjTmdRTnppSys3MUdBOHNzY2tjYXdxYjZB?=
 =?utf-8?B?NEw0ZEhPWG1lQ0xUT0ZHeGJ5VWc2TC9UZnhQOU0zbDN0bWpMakk1bGpIZGpv?=
 =?utf-8?B?cHlOQ3d5QUh1Q0FiQWg5Y2xETnVWZlcybGFEOFBZbGN0clZNTVpFUT09?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38e9f1c0-6cb3-43af-5285-08da37e8b045
X-MS-Exchange-CrossTenant-AuthSource: DM5PR12MB1307.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 09:36:15.7651
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +5tFaakVJp7YPMqxEO98OgDFHlcZKvkeywt3WsnIfMgcyJPFBEdKRcsC64tSk9BU
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB5687
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



On 5/17/2022 12:18 PM, Pablo Neira Ayuso wrote:
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
> Everyone happy with this? Please add your Signed-off-by tag.
> 
> I'm showing as the author in this patch, but this is basically a mix and
> match of Oz's and Sven's patches.
> 
> Thanks a lot for your patience !
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
> index 187b8cb9a510..6612ad8f1565 100644
> --- a/net/netfilter/nft_flow_offload.c
> +++ b/net/netfilter/nft_flow_offload.c
> @@ -298,7 +298,8 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
>   	case IPPROTO_TCP:
>   		tcph = skb_header_pointer(pkt->skb, nft_thoff(pkt),
>   					  sizeof(_tcph), &_tcph);
> -		if (unlikely(!tcph || tcph->fin || tcph->rst))
> +		if (unlikely(!tcph || tcph->fin || tcph->rst ||
> +			     !nf_conntrack_tcp_established(&ct->proto.tcp)))

net/netfilter/nft_flow_offload.c:297:39: error: passing argument 1 of 
‘nf_conntrack_tcp_established’ from incompatible pointer type 
[-Werror=incompatible-pointer-types]
          !nf_conntrack_tcp_established(&ct->proto.tcp)))
                                       ^~~~~~~~~~~~~~

I assume this should be:
nf_conntrack_tcp_established(ct)


>   			goto out;
>   		break;
>   	case IPPROTO_UDP:
