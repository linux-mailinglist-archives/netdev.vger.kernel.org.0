Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD7253F3D7
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 04:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233200AbiFGCH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jun 2022 22:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235898AbiFGCHO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jun 2022 22:07:14 -0400
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2089.outbound.protection.outlook.com [40.107.100.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F693BA57D
        for <netdev@vger.kernel.org>; Mon,  6 Jun 2022 19:07:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YyJeoUX8kU2ew5fAioZv8VZaj1tlN7rDYmsaGD/HGouHVcaScdl7WyvuU9ibwG7uqofoM2Vv71tmmHUPUNR9+6qyTmrtGPexNP8FUbBYUnJMaYAx8WVZoLh/BykKxMpsQJRWsruxMlKoJ7QXtVQVcdJGV8PbWgM66SqKyckWpih/3WNTxqcNihAouHm/RhXVsmBywES3ILLzT0/+Qt3nvyKL6mRPtGzYpKY+gFpHlWyHjwYauTncwQJrZ0ffieGHN0stukdbKN3KJcqFPvQCsJ4GJ9PqWIWnzRMlvEkMczBo4FQNzyi1tdXEfqQJSl+yIEByT8DgfP5+87jv8Dpw1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aQTD0mGaPrVdg9WaADAbaEncnHwFCF2ngwiC6CzGQ0k=;
 b=a/I51v/o74LZKUk69KWorbYOXbLIv1e8RyIApvclJkhdxI3zcAfcYs8L1k99RXnp9+4c7htutc3/UjNPLE0M4RvSRHOdcarYFqyZHcoNdAxW9Ezo8Ec6iBT1ucKQoFpTzWP3QG3706w8Z5mdiccK+HYwRCN96y1Ijy00ku7nzY0s4JLqb/40dBlvamsg+0qmPAvEzhsE5ev9nvTMjTMZT1Lz1YTNrgCFF0mgY6lj0CcuUrkHT8h/cPuSzSjRgJIdXAEgOdHB4z1fN9ik8ZeoVbksyEq+ScCTsDV5zWXhuKsAbZY1k+dLL9eY24fnvkGCAPxg3fL2UmZ7rzMc0rT3Rg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aQTD0mGaPrVdg9WaADAbaEncnHwFCF2ngwiC6CzGQ0k=;
 b=pls6U0FMvJoswE+i8S6LRFA9Ue553xmAhLT4EbPp8kq/10R6YlujWcCISXTlyBwdzkQ+rxDIHS0sfHB/t48tD2Rq1e4Le3jtIY7CJn93zei2RrJoJavTXg55xC8UWzAyceEMVS7P3F5ZIe/MHFqrpaOFuArKtXidLbdV/VzxxNA/GBfWjMPYsDnUEP1Iqj6xemyMiQl3nTPvKY95Uefk3dQk0X6DyHtCTrVCAm9d71Hd9pp2nyANv8rxG4bviRIi72gTQ17RJydBBjbV8mtUGwNPMgtNPWu09GhdRFCn07KK0xt3akW/brMTejpJUnNQkWmWDXpQTXP4Mi1EyvVAJg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB3127.namprd12.prod.outlook.com (2603:10b6:a03:d8::33)
 by BN9PR12MB5161.namprd12.prod.outlook.com (2603:10b6:408:11a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Tue, 7 Jun
 2022 02:07:05 +0000
Received: from BYAPR12MB3127.namprd12.prod.outlook.com
 ([fe80::302b:ad67:78c0:64e4]) by BYAPR12MB3127.namprd12.prod.outlook.com
 ([fe80::302b:ad67:78c0:64e4%7]) with mapi id 15.20.5314.019; Tue, 7 Jun 2022
 02:07:05 +0000
Message-ID: <ed6768c1-80b8-aee2-e545-b51661d49336@nvidia.com>
Date:   Mon, 6 Jun 2022 19:07:04 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.1
To:     fruggeri@arista.com
Cc:     netdev@vger.kernel.org
References: <20220606230107.D70B55EC0B30@us226.sjc.aristanetworks.com>
Subject: Re: neighbour netlink notifications delivered in wrong order
Content-Language: en-US
From:   Andy Roulin <aroulin@nvidia.com>
In-Reply-To: <20220606230107.D70B55EC0B30@us226.sjc.aristanetworks.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SJ0PR03CA0089.namprd03.prod.outlook.com
 (2603:10b6:a03:331::34) To BYAPR12MB3127.namprd12.prod.outlook.com
 (2603:10b6:a03:d8::33)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed7f7caf-6a66-48e5-38de-08da482a6b80
X-MS-TrafficTypeDiagnostic: BN9PR12MB5161:EE_
X-Microsoft-Antispam-PRVS: <BN9PR12MB516122A26472B5899268D54CCAA59@BN9PR12MB5161.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KvRpEY2XgWerWVcU7dF/u6L6QjyTXoiOS1rmKSxcX83xauBJ4DFVhU56/+fuuWOHIpBfmrVCuIJHw48JZiLeSFH02ZkqhiRFjYzIpEmjTkkbCoCxlfICq8LQhr0kTPwfBoWyX49FAYUB1iWwWijMM5+G7O79fcf4XkiMBS2zpcfgvbxAEoG+lKwJaSO2n5SbwchwwJdKBm/hqqBZQk0bKZKBs8IcEr7w8o74e3U5C95YNPib+ozn15PmI/Z38CWdPYtQx2aaILki6MIn56UbIjNXqp6royNir2dCwZuBDIpxHGN6TRy4WI0d7/50LNstgs4vt1j5ISP+9oBUyQlIVjPyO8tCz8gyX14TOax+gL2As/yHL3lxO6i3N3A/CQpIt1wzDo1qduJNKvYktod0KmDZ+6GlMxZsThN3feMwr39eLN8PMoeR0DeD2v2a6ACB9u6G/PPIOeIvFtF0T53DWwwIMhZVZ/6HNSEtBBaIY7hc1wzDuin37Ek/9JdGBWiSINMvHAFnlw+qtrXJ2WPNL+N5xot+HmjYNyK3dKmKzFynwzsPBUQLks1v5kBRe5Hq0qehfrONLVsqb2TlRtckKbbLvT1Ir0EOTwzk8LOQKepJ57FBGDwESSI/oHjU9GHCej3ogZHO82brX0Lv+ulMX7I8mC7mdCO178+0v5PX6p/EPyIR4HwN30/VDCzo5yBVvmyqXbAdUx55EAi1nCSCDqoFUqPcrgTDU6KyvxYbtUAkXYnLhELOeGK1Jo10IE3h
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB3127.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6512007)(86362001)(186003)(31696002)(316002)(66556008)(15650500001)(5660300002)(38100700002)(83380400001)(8936002)(4326008)(66476007)(2616005)(508600001)(6506007)(2906002)(6486002)(6916009)(31686004)(26005)(66946007)(36756003)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SEM3NitwVmt2azdkYk1ZOUozUTNkMjlCRjFEdFFiNWVqU280UndEMEtuenpL?=
 =?utf-8?B?Q0xMQXk3ZFRZUTc5UE0vNklnTldjd3BkYVBtM2NCcnA4d0s0bEVkbURPdTlw?=
 =?utf-8?B?STRNL0xPK0cxM0EreFBLSnJJVitiQ2xaMnpuK0FlUG4xSlB3SVlsS2dFclpi?=
 =?utf-8?B?azl2a2Z5V0M3SGoxcEViY081aWVUc2hLOVR2V1RDSG4vdWhWbFZpWWFTeWJk?=
 =?utf-8?B?U0Z5dzlKWm56WTl1U3BQUk5CWmpwNzlRbjJIQkxkVlU0czNqaUhpZ0NFTUlq?=
 =?utf-8?B?ZUF6RCtadE5neGlWclAyMjMrNGpFR2Zzc2I5OTc4R2xWc24walJZS3J1aVlz?=
 =?utf-8?B?L0hQMnVQOHFkYzRabkZXWXZSQUlvYzdSVFphdFFHN3FIcVNNd0R3TFRxY1FW?=
 =?utf-8?B?WWZzV3VGL3hKQ2ErQ052dGJSSFZqQTlHc0JLY0tZZDlicVZBelJvUkowOUYw?=
 =?utf-8?B?RkF0V3FFQUprUHMvOGF5Wnp2WitES0tPc3NpWVBZRmt3YWlqSWxFcTZPS1NS?=
 =?utf-8?B?UEFUSmR3eDEvTW81V2VRUjRCZ1hiQUY1OE5EUW1FdHg2TTRHQ2tXcjZaR0xq?=
 =?utf-8?B?Q3lPM1B4cFovMWs3bWp3UGdMUnY5NEdUekI3SlpFSHZWeWtwajQwRXRUK3NG?=
 =?utf-8?B?U0U0bEtpcDZBVXd4UTVibjJzVkxVZEhMcnZzREkyZDliYXFiRzBzNFFndGNG?=
 =?utf-8?B?U0NHQmVwY2tTRCsxY1NrMEtWRk9sTTI2MW50WjZNb1RIcnV5MVRiZG15MzBJ?=
 =?utf-8?B?YnEvcDdoTUhyMXdGMTdTaStqVkNKT3NYYzZCZHI0YWRqQk9ZOXQ2RDJTRlcy?=
 =?utf-8?B?dnhRanJQOG9ESXQ0NDY4b3M2ZlZ5K0ZuMTR6VXNGTVFsQUFKNTArNEJRRHRP?=
 =?utf-8?B?MzFUQ0p1dit4ZWtlRWRuaVpSMFBmb1czdjFNcnV5eG50d2txMldGUWZtRnBt?=
 =?utf-8?B?a3Qxc2kzOE5qWUpuM3JWS1h0enllbExqc09XT203UlVHVk1GTXhDeHdyY3F3?=
 =?utf-8?B?SWxJNG1ONitqT3pEZk1obHBOc25zY0gvZnI2VlBlOTh2Yjl1azVwK01ObVMx?=
 =?utf-8?B?K0Q4dHR0Tm04eUN2Y0N1T0NsMW05dXY2ekd3djBSc3NEUndmdk9LTFV4T3Fy?=
 =?utf-8?B?RVhvUVVjY0t2QnV6THZScXcwWklmMlpCdzVVNFhsTTVYRG1vU1NueVg1WUpv?=
 =?utf-8?B?WExYWFBqRkMrSkdzbElXS1NnZ3NiU200ak5IZG8vbVNiOFRDZ2N3UDJ1ZGts?=
 =?utf-8?B?TDUyOXRxSmZrT21yZ2dYUUt6NXVvSnZvR2hMQVRuamdpMCs4S090YnM5UDAr?=
 =?utf-8?B?MTBjTHZUQmhuUHZ1OTl6U3VtTnVGNFNwTDBsaUhvQTY3V3M4S1NOYWlmeWpG?=
 =?utf-8?B?MWtPTWtLaGpjODA4UFQyQ2Y1UXZFb1VrZWR6alNuK1VMRVpNMjRqLzBhRjdx?=
 =?utf-8?B?ODd6dUVMR3dOVHFNdFJMSEhPOVlsMXNRbDA2a1piTWtoeUdXVEcwRk1ZQy9B?=
 =?utf-8?B?S25ZeVdrSS8rUzF1Nkx5TFhzRlVrdEFLcFdPWmRlbUU5bjN5NGZncjdoRk93?=
 =?utf-8?B?b2pSbXdJb2I1TWtBMTliU0l0UThGTzZqamkvWWx4VlhQTS9WOHhwSEJtTFNi?=
 =?utf-8?B?ckJGSXNKeUtFT0NkNlFkU2lFOXNURWxzUzRnRzJ4UkkvT2R4RFNVeXR6bEky?=
 =?utf-8?B?VDg2SkEwcmFjeGNpK25JVXFtR1psT2c1Z2pDemQ2cFV4SjJkU2owYk5CR1NG?=
 =?utf-8?B?aXo3YWs5dXAwNXF0NzBJazJ5Y3EwU3hod1VMbFo1KzJBR3M4L2VVSnlRcjQv?=
 =?utf-8?B?cjJ1cHdoV3hGUnlhUkdlS25VcW0wY0UrcnZNOFFWcG93MVg2ZjlmUHFodDJS?=
 =?utf-8?B?ejN1Vi9XME01a1J1YS9QMFZtaDVLQlBsL0kvcXFETGxKdFhWdXpDVU5yWHZH?=
 =?utf-8?B?Mit3M3Jaam5NU0Z2Mjh5cExtUyttdW5NSVQxc1RRdC9ydW9Ca0ZwMEZNd2pB?=
 =?utf-8?B?d2ZVbnZ6bFVheGpGOU4xUHFJbi9vRDg2STZkS2l2dHhaVFhhbTE0am94eXNr?=
 =?utf-8?B?Z1BvSWQ5YVhaMzZ6WDV1UjA0OTMzUksxai9rZ0wwYmZCbEd5d1U5QkZBUGRw?=
 =?utf-8?B?eEMvaTBNM1ZZYWZPUG5iZE9ubFBGUzQ3V2VVandaanBCcHY0WkRPVzN3L1ll?=
 =?utf-8?B?YUUzanNoVFhQdVhwRUcxR2lYRGNjRzBFNW9pcTFUTXVLN3BIVXNUQW1ObkZr?=
 =?utf-8?B?MHp1bkJkM1ZlN0x3akJrTTZiNXVtQ3pET2IvRnB2TjlWc1N0Syt0bSsxSEJZ?=
 =?utf-8?B?UzVBcUFBclllMG9SNjhqNllNeUY3UU9VUW52Y0NlODl4SDlHLzRZb05wTkZu?=
 =?utf-8?Q?QH8BEUC1EMiosxic=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed7f7caf-6a66-48e5-38de-08da482a6b80
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB3127.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2022 02:07:05.6831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5ndxo17rwxN2cgZuDzuzr3ynz89h1bdb+KwLNuqVfcJGzeCKl4I7tJeIknEHRTCTxob/CsD7d8DwUZxnB3KmSQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR12MB5161
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Below is the patch I have been using and it has worked for me. I didn't 
get a chance yet to test all cases or with net-next but I am planning to 
send upstream.

----

neigh_update sends a rtnl notification if an update, e.g.,
nud_state change, was done but there is no guarantee of
ordering of the rtnl notifications. Consider the following
scenario:

userspace thread                   kernel thread
================                   =============
neigh_update
   write_lock_bh(n->lock)
   n->nud_state = STALE
   write_unlock_bh(n->lock)
   neigh_notify
     neigh_fill_info
       read_lock_bh(n->lock)
       ndm->nud_state = STALE
       read_unlock_bh(n->lock)
     -------------------------->
			          neigh:update
				  write_lock_bh(n->lock)
				  n->nud_state = REACHABLE
				  write_unlock_bh(n->lock)
			          neigh_notify
			            neigh_fill_info
                                       read_lock_bh(n->lock)
                                       ndm->nud_state = REACHABLE
                                       read_unlock_bh(n->lock)
			            rtnl_nofify
				  RTNL REACHABLE sent
		        <--------
    rtnl_notify
    RTNL STALE sent

In this scenario, the kernel neigh is updated first to STALE and
then REACHABLE but the netlink notifications are sent out of order,
first REACHABLE and then STALE.

To fix this ordering, use read_lock_bh(n->lock) for both reading the
neigh state (neigh_fill_info) __and__ sending the netlink notification
(rtnl_notify).

Signed-off-by: Andy Roulin <aroulin@nvidia.com>
---
  net/core/neighbour.c | 25 ++++++++++++++++---------
  1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 54625287ee5b..a91dfcbfc01c 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -2531,23 +2531,19 @@ static int neigh_fill_info(struct sk_buff *skb, 
struct neighbour *neigh,
  	if (nla_put(skb, NDA_DST, neigh->tbl->key_len, neigh->primary_key))
  		goto nla_put_failure;

-	read_lock_bh(&neigh->lock);
  	ndm->ndm_state	 = neigh->nud_state;
  	if (neigh->nud_state & NUD_VALID) {
  		char haddr[MAX_ADDR_LEN];

  		neigh_ha_snapshot(haddr, neigh, neigh->dev);
-		if (nla_put(skb, NDA_LLADDR, neigh->dev->addr_len, haddr) < 0) {
-			read_unlock_bh(&neigh->lock);
+		if (nla_put(skb, NDA_LLADDR, neigh->dev->addr_len, haddr) < 0)
  			goto nla_put_failure;
-		}
  	}

  	ci.ndm_used	 = jiffies_to_clock_t(now - neigh->used);
  	ci.ndm_confirmed = jiffies_to_clock_t(now - neigh->confirmed);
  	ci.ndm_updated	 = jiffies_to_clock_t(now - neigh->updated);
  	ci.ndm_refcnt	 = refcount_read(&neigh->refcnt) - 1;
-	read_unlock_bh(&neigh->lock);

  	if (nla_put_u32(skb, NDA_PROBES, atomic_read(&neigh->probes)) ||
  	    nla_put(skb, NDA_CACHEINFO, sizeof(ci), &ci))
@@ -2674,10 +2670,15 @@ static int neigh_dump_table(struct neigh_table 
*tbl, struct sk_buff *skb,
  			if (neigh_ifindex_filtered(n->dev, filter->dev_idx) ||
  			    neigh_master_filtered(n->dev, filter->master_idx))
  				goto next;
-			if (neigh_fill_info(skb, n, NETLINK_CB(cb->skb).portid,
-					    cb->nlh->nlmsg_seq,
-					    RTM_NEWNEIGH,
-					    flags) < 0) {
+
+			read_lock_bh(&n->lock);
+			rc = neigh_fill_info(skb, n, NETLINK_CB(cb->skb).portid,
+					     cb->nlh->nlmsg_seq,
+					     RTM_NEWNEIGH,
+					     flags);
+			read_unlock_bh(&n->lock);
+
+			if (rc < 0) {
  				rc = -1;
  				goto out;
  			}
@@ -2926,7 +2927,10 @@ static int neigh_get_reply(struct net *net, 
struct neighbour *neigh,
  	if (!skb)
  		return -ENOBUFS;

+	read_lock_bh(&neigh->lock);
  	err = neigh_fill_info(skb, neigh, pid, seq, RTM_NEWNEIGH, 0);
+	read_unlock_bh(&neigh->lock);
+
  	if (err) {
  		kfree_skb(skb);
  		goto errout;
@@ -3460,14 +3464,17 @@ static void __neigh_notify(struct neighbour *n, 
int type, int flags,
  	if (skb == NULL)
  		goto errout;

+	read_lock_bh(&n->lock);
  	err = neigh_fill_info(skb, n, pid, 0, type, flags);
  	if (err < 0) {
  		/* -EMSGSIZE implies BUG in neigh_nlmsg_size() */
  		WARN_ON(err == -EMSGSIZE);
+		read_unlock_bh(&n->lock);
  		kfree_skb(skb);
  		goto errout;
  	}
  	rtnl_notify(skb, net, 0, RTNLGRP_NEIGH, NULL, GFP_ATOMIC);
+	read_unlock_bh(&n->lock);
  	return;
  errout:
  	if (err < 0)
-- 
2.20.1

