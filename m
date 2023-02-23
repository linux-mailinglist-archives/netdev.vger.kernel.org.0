Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBC3A6A088D
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 13:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233630AbjBWMZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 07:25:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBWMZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 07:25:03 -0500
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01olkn2052.outbound.protection.outlook.com [40.92.99.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27FBE37B6E;
        Thu, 23 Feb 2023 04:25:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=grKIV9gVhCSwEpEM/oQvRR+XLwm1o6m0qqkx0i5+XQOjrxuP5WB7jHJbsUPN11RDidDeXOG3/arvZcDFKaDI6VUojl5pt+meEFJukSJxfGx3nNAqThWsVqpNSuuzJNX3GonFYl6tn47IgLsyrUofmW2GlgMrJfn0h2Y+ZNFp4qKsb5fSC/33i8zPcAKC+capQ6mdALgI+cDCmj3ZbUNCLq0xujEH1/kjGcbq+1R8nAH+sxzUfbUluQlKutBWmAJJB0MiLPLKI3KidUM423DNNwVqcEecYFW0mAsmKBM6M37F2ssdI8JBL6I+nc34tZn73HgLRgPI3tGeWjGAGGZLQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cxvwrQxmyTTm/NPD+PkL89Ju/tnQBQTyPtHYHape3Xg=;
 b=a0WULxhRUsS+Ls7RWUtpW63KsyPqX86v/fbqDpdEq5VndIVjxqbAnTsakT5RNmaSQE+AtRIAwqhRzvS5jLtYGIrIyL/j28TJpEZNIZB/XAqOKiqGvpLobpK0OTJd+QO23Lvvv9onE+GtiE6Ny+OSDRp1aUwlerPm8Pj2d3w88HWDBAyq0uqzRTqvhvdwZX14rs1WrucxF76aPhJI+zssffi8pjhmTwKFXXSIo7z1dOKaWtuCtII6DjDYZ/C82pKEFlry5vCjx9alB6oDKf4OgM3HZfxK2XGnByoVxAZ0yDIlyA0mxAh1SjuVqGdtqN3bCyiRyzSlobe3aWvEhyq3mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cxvwrQxmyTTm/NPD+PkL89Ju/tnQBQTyPtHYHape3Xg=;
 b=YC17fzq2VYViQVgDM2F7crPFxm4eDrNg3KzFnCZCHSnhMGVVC/wChtkoaH3fLoMKmC1Ljdan7zcYnjtM1BEUnox5b57QTYqrPSqDAmrWvTQAxgLNc4n2fI1bNsGik+aCTrFFl3x9UTAxaAU2Je1lr6+MWiRCN3Z71a0dmafARtzt81eNJ5cW1Z1LqDDiFS8gAMzuFWDeu/Ot8NRUHNKaj9vCYy56Gzs/GlfC+h405STC17QBSF565ZIkdvzFFFb+/akd06nvlFeAoai0Z3GkuZ7tZB75yMRA2q1pRmQnbknhWWnDAeKlvqtn12b4n9bC82VykOwrVS37ZFfJ0CNhjA==
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:19b::11)
 by TYCP286MB3487.JPNP286.PROD.OUTLOOK.COM (2603:1096:400:3a3::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.21; Thu, 23 Feb
 2023 12:24:58 +0000
Received: from OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068]) by OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 ([fe80::9a1d:12f5:126c:9068%3]) with mapi id 15.20.6111.018; Thu, 23 Feb 2023
 12:24:58 +0000
Message-ID: <OS3P286MB22957CD400DAAAB7786FEF96F5AB9@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
Date:   Thu, 23 Feb 2023 20:24:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next v2 1/1] net: openvswitch: Use on stack
 sw_flow_key in ovs_packet_cmd_execute
To:     netdev@vger.kernel.org
Cc:     Pravin B Shelar <pshelar@ovn.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
References: <OS3P286MB229572718C0B4E7229710062F5AB9@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
Content-Language: en-US
From:   Eddy Tao <taoyuan_eddy@hotmail.com>
In-Reply-To: <OS3P286MB229572718C0B4E7229710062F5AB9@OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TMN:  [c09wdAO3XQCA+k1VluYtMlRGO7q9uLF6]
X-ClientProxiedBy: TYCP286CA0150.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:400:31b::17) To OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:604:19b::11)
X-Microsoft-Original-Message-ID: <f1c1a4aa-3deb-0686-8b8f-6b48c2c94a6a@hotmail.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: OS3P286MB2295:EE_|TYCP286MB3487:EE_
X-MS-Office365-Filtering-Correlation-Id: d9f7f0ac-3e7b-416b-b08f-08db1598fa7d
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6AM/CSFR+w44zaow50hBWtlRp/lmNcsr9tOVST52i+GieJm+U85H37sBzReYX0brhDSRc5yk+HKS61c2jCnlKp+do7QBvjZkrzBhf83naz9STDRSlrbvjw29hs3d0d4pxyojXcWpjPTtyGla6sAyvIj9FTS0hA87W4sNtIYD3dkMKNfZbPiSNhOKekGKisiUfQLB9LvFY97Ue6O3wa9HARccGL2a3EBlIqLP2pnG/Ig3HuZwGxdlBA9cHQRcNv8fDAvj5ePQl1/j2siK+RmGNOVFtO92yjucDpiCpUmK8DALSRLAjsOIY8RNkXEbZ8o4SmIT44x2I6FMdTwwFyYrRia+zirohUI5IJNg7bDDEFCvxAIETydkOiFPv0OKu7vpfE9bpwiRV+S+j/HudY7FDWEvXHX6eqwKmFHGhbK8HsW6HXJbzAUTr5DHlqi8Q+hND+5sumYJhvHRDzj5NNOQ0H9nHxcLa9sBJABpgPUADjdFKbARcb0QHnNpCZEn5lwAwWBWNJ0oNcvROnrfPBviNfDjGrSJsXhanIqCrW5DFlvZ4dZtRWpjbJbW1kyhLIzxXhmCvqzuOVZA6F6kuZ/vD5i1GKrpS8wN6J6/B9lIv8kQUEo3ph30sPWkgZ5wjx4tDWFffmBhek8U87ma/LHUdA==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c0dPMnFlVkxuekphcnNrUlFRZiswajdCZU9tVTFXWk5TY2ZORkdGMXZVeVNo?=
 =?utf-8?B?U01oRVg2a3NyMUo4aEV2SHNhbXNHSzJlWERPdjliUjZhWHVQd25Kd2dPUGNK?=
 =?utf-8?B?NlV0SHNrbDNwU1Nmd1A2c0VqUll5aDRTbTQvZllZNVNFb2lSSi8vQmFUeUZP?=
 =?utf-8?B?eDI0cHZKUkpRdStHMmQ2a1JBZ21hL2Z3M0ZkN2dDT2wycDRQWjVSMmRtNXRO?=
 =?utf-8?B?SmQwMGVYb3N1Z1RnVUk1ZXcyYzNLdU0xZGM2Z1NtLzR3UzQ3WE5oWkZmL2tz?=
 =?utf-8?B?bTJESzQvdDdjTStoWnJQMkt5TTltVFJOdHVIZGd3U1plOHhDVElTNTc1Qzh6?=
 =?utf-8?B?bGtPQlNLci93VDdKSWJtQ0ZVUmU5MEo4bjVnVFVoSlpzbVNkK3hoQk9lMG1k?=
 =?utf-8?B?MXpTZERzZFpkVExDdEN1cEI4Y1hUUWUvY0ZEa1NQNGVPcFEwSlhwazZPeEtE?=
 =?utf-8?B?VnBlaldSNGFkZ1FuWHZYdmRySHplcHpJcUZIZnZVRXRqVVgzZVh3dVN5blhi?=
 =?utf-8?B?enhGQ090czZSNnZ1a1FtRW43ZmErMkwveXprOU0rYUh1aGsrMnR1K1Bha1VG?=
 =?utf-8?B?aGphUjVWR0RXeHptWVZDdFJxc1FnREhPQnFVU3dCblo2RmluczFsU0xCMEYx?=
 =?utf-8?B?eUxzTldzeURkcGR1dHFHUmVGM2ZpSXdJVlg0Wk9LSjk2SzhGdHh3WHUzVmVO?=
 =?utf-8?B?M2ZBekdESUxMRjRwVFdRdkdDNXpxOWRCQWxiKzdGQ1JBazh0OGd4cUs5QVQw?=
 =?utf-8?B?enFJd2p4bTJ0REZnYjFacVhqT2ZRa2pTYTFDVEJOYXBRbThDN0NCNlFOSVdV?=
 =?utf-8?B?STBoOW8rZERyRHBHaTZUUTBzVkFiOTJScDJ0K0JnOVVVbGt2c1dhNjVPTm0y?=
 =?utf-8?B?WDRwNzdpR0pkUlppZ2Q2VzB4UU0xMU96Mmt6UFl4OTgwUUVDYldpTkFiTHc5?=
 =?utf-8?B?clAzVDNkdzdNUWZUQlg3dHRJcXhOSkp0R0ZvR3RZVDFwbWlDWTAwbEUyVjE2?=
 =?utf-8?B?bkExQ2hSTXR3MVlvRjVsNUUvZFFsNm5DQjhMd2wyVmUyT2l5RG4yVEJYZm9O?=
 =?utf-8?B?ZFBpYzd5b21HL3VIU0pXeUJPWkgzSnZmT2tPZnJaQnJzcys1RTNSZ2p5SHd1?=
 =?utf-8?B?cXlTNVFpZ0FycWg0L2h2ckkzSXdNeC9UZHFkdjhLV2JCU3RKRldSTmZCdmhO?=
 =?utf-8?B?YzVjNkVmWTQ5dlZ2TWltYmFnNVFjMjA1NmdlM1IyNnluU0FPVCs2Q2FUZ2dG?=
 =?utf-8?B?K0FxTEh2OHoxbmVuMk9pUWdsUDVFYytKZi8xOU9XWVBqdkhlMnE4ZHY4ZjQy?=
 =?utf-8?B?cmc4ZDZxckRzeS9RS3VWUVZHNnJRckRsNS9CWGxRNmJ4dlNTWFNzVGI2aFlo?=
 =?utf-8?B?T2ErWlhqNmV2SDhEYjVXbXhkb3RiMXg0TUE3cXBoRmZtVWxyZzNBQjVqM2Js?=
 =?utf-8?B?Si8xTnVQa2krakpxK0t4SDFhbkxKY1BudjhIL2FJb0k2UlFpZEdkdXhlNDNL?=
 =?utf-8?B?d21NWHhJbk9USGo2TW4vaU5OTHJvUGdJelBab2V1bGUxbEZKS2EybEpHWWE1?=
 =?utf-8?B?cGVmT0k3T2pyVEt2L2x0NW55VzBZcTEyQk1GZXZXamZXWWNReGpYa3RlYkdH?=
 =?utf-8?B?T0xtRVV1L1Z0SEsyUm5VbmFROGVySVhiMjJZYlJ5NS9Ra0xzTVp3eDJNc1NO?=
 =?utf-8?B?Tlh6OW9kWlZCS2ZndVo1S0szVkRPTmY3WEJsZG9wTDc5MHJDbnJYT2N3PT0=?=
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-05f45.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: d9f7f0ac-3e7b-416b-b08f-08db1598fa7d
X-MS-Exchange-CrossTenant-AuthSource: OS3P286MB2295.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2023 12:24:58.6685
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYCP286MB3487
X-Spam-Status: No, score=1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FREEMAIL_FROM,HK_RANDOM_ENVFROM,HK_RANDOM_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry, there is a typo in the mail, i will resend shortly, please ignore 
it for now

On 2023/2/23 20:21, Eddy Tao wrote:
> Use on stack sw_flow_key in ovs_packet_cmd_execute
>
> Reason: As key function in slow-path, ovs_packet_cmd_execute and
>          ovs_flow_cmd_new allocate transient memory for sw_flow
>          and frees it at the end of function.
>          The procedure is not efficient in 2 aspects
>          1. actuall sw_flow_key is what the function need
>          2. free/alloc involves kmem_cache operations
>          when system under frequent slow path operation
>
>          Existing code in ovs_flow_cmd_new/set/get use stack
>          to store sw_flow_mask and sw_flow_key deliberately
>
> Performance benefit:
>          ovs_packet_cmd_execute efficiency improved
>          Avoid 2 calls to kmem_cache alloc
>          Avoid memzero of 200 bytes
>          6% less instructions
>
> Testing topology
>              +-----+
>        nic1--|     |--nic1
>        nic2--|     |--nic2
> VM1(16cpus) | ovs |   VM2(16 cpus)
>        nic3--|4cpus|--nic3
>        nic4--|     |--nic4
>              +-----+
>     2 threads on each vnic with affinity set on client side
>
> netperf -H $peer -p $((port+$i)) -t UDP_RR  -l 60 -- -R 1 -r 8K,8K
> netperf -H $peer -p $((port+$i)) -t TCP_RR  -l 60 -- -R 1 -r 120,240
> netperf -H $peer -p $((port+$i)) -t TCP_CRR -l 60 -- -R 1 -r 120,240
>
> Before the fix
>        Mode Iterations   Variance    Average
>      UDP_RR         10      %1.31      46724
>      TCP_RR         10      %6.26      77188
>     TCP_CRR         10      %0.10      20505
> UDP_STREAM         10      %4.55      19907
> TCP_STREAM         10      %9.93      28942
>
> After the fix
>        Mode Iterations   Variance    Average
>      UDP_RR         10      %1.51      49097
>      TCP_RR         10      %5.58      78540
>     TCP_CRR         10      %0.14      20542
> UDP_STREAM         10     %11.17      22532
> TCP_STREAM         10     %11.14      28579
>
> Signed-off-by: Eddy Tao <taoyuan_eddy@hotmail.com>
> ---
>   V1 -> V2: Further reduce memory usage by using sw_flow_key instead
>             of sw_flow, revise description of change and provide data
>
>   net/openvswitch/datapath.c | 30 +++++++++++-------------------
>   1 file changed, 11 insertions(+), 19 deletions(-)
>
> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> index fcee6012293b..ae3146d51079 100644
> --- a/net/openvswitch/datapath.c
> +++ b/net/openvswitch/datapath.c
> @@ -596,8 +596,7 @@ static int ovs_packet_cmd_execute(struct sk_buff *skb, struct genl_info *info)
>   	struct nlattr **a = info->attrs;
>   	struct sw_flow_actions *acts;
>   	struct sk_buff *packet;
> -	struct sw_flow *flow;
> -	struct sw_flow_actions *sf_acts;
> +	struct sw_flow_key key;
>   	struct datapath *dp;
>   	struct vport *input_vport;
>   	u16 mru = 0;
> @@ -636,24 +635,20 @@ static int ovs_packet_cmd_execute(struct sk_buff *skb, struct genl_info *info)
>   	}
>   
>   	/* Build an sw_flow for sending this packet. */
> -	flow = ovs_flow_alloc();
> -	err = PTR_ERR(flow);
> -	if (IS_ERR(flow))
> -		goto err_kfree_skb;
> +	memset(&key, 0, sizeof(key));
>   
>   	err = ovs_flow_key_extract_userspace(net, a[OVS_PACKET_ATTR_KEY],
> -					     packet, &flow->key, log);
> +					     packet, &key, log);
>   	if (err)
> -		goto err_flow_free;
> +		goto err_kfree_skb;
>   
>   	err = ovs_nla_copy_actions(net, a[OVS_PACKET_ATTR_ACTIONS],
> -				   &flow->key, &acts, log);
> +				   &key, &acts, log);
>   	if (err)
> -		goto err_flow_free;
> +		goto err_kfree_skb;
>   
> -	rcu_assign_pointer(flow->sf_acts, acts);
> -	packet->priority = flow->key.phy.priority;
> -	packet->mark = flow->key.phy.skb_mark;
> +	packet->priority = key.phy.priority;
> +	packet->mark = key.phy.skb_mark;
>   
>   	rcu_read_lock();
>   	dp = get_dp_rcu(net, ovs_header->dp_ifindex);
> @@ -661,7 +656,7 @@ static int ovs_packet_cmd_execute(struct sk_buff *skb, struct genl_info *info)
>   	if (!dp)
>   		goto err_unlock;
>   
> -	input_vport = ovs_vport_rcu(dp, flow->key.phy.in_port);
> +	input_vport = ovs_vport_rcu(dp, key.phy.in_port);
>   	if (!input_vport)
>   		input_vport = ovs_vport_rcu(dp, OVSP_LOCAL);
>   
> @@ -670,20 +665,17 @@ static int ovs_packet_cmd_execute(struct sk_buff *skb, struct genl_info *info)
>   
>   	packet->dev = input_vport->dev;
>   	OVS_CB(packet)->input_vport = input_vport;
> -	sf_acts = rcu_dereference(flow->sf_acts);
>   
>   	local_bh_disable();
> -	err = ovs_execute_actions(dp, packet, sf_acts, &flow->key);
> +	err = ovs_execute_actions(dp, packet, acts, &key);
>   	local_bh_enable();
>   	rcu_read_unlock();
>   
> -	ovs_flow_free(flow, false);
> +	ovs_nla_free_flow_actions(acts);
>   	return err;
>   
>   err_unlock:
>   	rcu_read_unlock();
> -err_flow_free:
> -	ovs_flow_free(flow, false);
>   err_kfree_skb:
>   	kfree_skb(packet);
>   err:
