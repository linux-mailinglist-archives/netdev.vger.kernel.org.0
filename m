Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76E2C4DA981
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 06:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353538AbiCPFKx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 01:10:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbiCPFKw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 01:10:52 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2068.outbound.protection.outlook.com [40.107.220.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A8269FD2
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 22:09:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NMcB0H0AwexvwA25H5qgQ310UL865+8HsBXeWcsoYT2HQ4xs5J3GijzPnCGP5jomE9P8SXgeaD0KIG77s7nTiQIO9m49fHPS1oj1XY3Vms6Ngeh09bltii+yZaZc8Vx/XJJNiRPuPH9X8RYbbiGliPJllXJynAMp6+PHZEhyFpILKhHPq+s+xRWX9zzomDNzYSJSDhcR5zGVH1HuZBDcOkckpXVcNKso8N8EW4FSVTFGjc14wb29BHZF8XsNy3ENgeRhT+G49N1uLt4NgFwQTkWWnr+r2Ycl07Usglmq8PYGoo1BIw3ciob+u7/Iu7Dr1COUVoKXVSN5mhS+U0o5bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BtexydFyW5JE0W57X6zud2GlfR6iAViisFt426KSvpc=;
 b=R2K36lTML2SOk5k2H/9Vev9IMXIgg3WB5kiHJvA/BbX5f+S9bVRDQeBkbdQ/77Pp+zLuZN3S1Si1dhfJMlLbAR1sBBlSItelC6zRNneqaOq1kFmhnyonJpO7v2/8Yr6smAhUwFyBvkifCiuXjFjSa+995qdBFcLdOluUZTj1zxJP68FrZj0JzscmfiIrDmUiHPyUhm/XkR8HCCi+JK058C1Xo9IAiaJeVw8LNEGh8hLwTFPPA2p8J6ggDjiRyvCIaBo4TPk/9h+R7PgqcTgEUuSC1PEQ5NbTWbFst3A2DmDORfi92VPvT30nLVyuHxiyd5HoWLDurNSbKqC9FgIyDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BtexydFyW5JE0W57X6zud2GlfR6iAViisFt426KSvpc=;
 b=OhBQhAaITi7S/mPc5gIX7Wl6068L6IfKixG37Dg6Bmxi3NVOrlDgcuBffxoRd02gkdYCExZ78LhIrB/Df2pMBNYtgdSqhe8gcgnsrr3WPtmefyDrRYKFrArtqoWpD1x0mm58Dd85wxccOs+I6eP9EOWWbeAMhEYag5B9b4e3EQ2NjhLdADXoRyWzTLruT4uUEHHKRSyOU3ccHDdXEOYgBbApbchN5ofJS02+yd9GHBN4pW3lSa9O1ZxstY2C7ANqxVQDFNQ6H6oKmO8CL/uCGWcua2FdHVUaNjZ95Cnmn7WT61GjeiBr/Cf1AwUCzQmLzrmripPfV8ChTbqs7flong==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from PH0PR12MB5499.namprd12.prod.outlook.com (2603:10b6:510:d5::23)
 by MN2PR12MB4062.namprd12.prod.outlook.com (2603:10b6:208:1d0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5061.22; Wed, 16 Mar
 2022 05:09:36 +0000
Received: from PH0PR12MB5499.namprd12.prod.outlook.com
 ([fe80::60da:a210:cb5:fafb]) by PH0PR12MB5499.namprd12.prod.outlook.com
 ([fe80::60da:a210:cb5:fafb%6]) with mapi id 15.20.5061.028; Wed, 16 Mar 2022
 05:09:36 +0000
Message-ID: <a8dcaaa8-2041-f7dc-974f-4659d12cf858@nvidia.com>
Date:   Tue, 15 Mar 2022 22:09:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next] net: geneve: support IPv4/IPv6 as inner protocol
Content-Language: en-US
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, shmulik.ladkani@gmail.com,
        netdev@vger.kernel.org
References: <20220315185603.160778-1-eyal.birger@gmail.com>
 <5218b1e8-ee36-f708-00a3-79738b8f7ac4@nvidia.com>
 <CAHsH6Gvj5CVZUVw7-EDrTYzs5vSae3TmFQeRJYuA9wycmVhfOg@mail.gmail.com>
 <377ae473-a908-6dc3-c658-ca2b81d364e0@nvidia.com>
 <CAHsH6GsW6=OK+=CxaLw_=bcDFspNO4nPmDOTdytpJJYih6khgg@mail.gmail.com>
From:   Roopa Prabhu <roopa@nvidia.com>
In-Reply-To: <CAHsH6GsW6=OK+=CxaLw_=bcDFspNO4nPmDOTdytpJJYih6khgg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BY5PR17CA0025.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::38) To PH0PR12MB5499.namprd12.prod.outlook.com
 (2603:10b6:510:d5::23)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 285c736e-c183-4906-d47d-08da070b2a27
X-MS-TrafficTypeDiagnostic: MN2PR12MB4062:EE_
X-Microsoft-Antispam-PRVS: <MN2PR12MB4062959BA781F7A5F1EB7FD1CB119@MN2PR12MB4062.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e1R8CLDfmDFr2Q73IG4akqy8lFqmBVibKwaxhdcF6LRX5fRQI9QqBW1zWch535J8VWQzGThKGlousweGp5cRDPtaK7KXmjFDwUJwh468aj+v6Ns/YOagluRDsDcAzhnmIaV2EbZFtrh9Ixq3w/UQU1O48LwXnLK+isHlMD9xth2p7p/CTgdcXNelTQb/un1T88jEIwPznLzTw0yfUXOQrEXgASSGQxXpoZCN/amlBMOEIzoFSQXqE67IwvWI4RY/AZdnmFpmioWPBC5HSe4xYdyjMjggIol8n3AE4hbxvDnlytvKfCVXjeKw0wTr/RGcboiTGVmO3sWcFjHm3C7YKHygJHlCWhnchffSO/XsxP7Fy73wmf3k+raP4G9LbFzkFoYBjnr8iWTGAUqMA1OrId2MCXuQCUqvAWwi/syMJPE2UrbZQVq+Vqie2iLSyJLRFQMQz7HLgWXyDIfbXE0zddFIfpUj1JIUrQ4L4eL9kzy+pMZRzqoGz/9KxpJzwA1z8+o0zn5PTQXR51MMijkrpFKKwhpzf0Cb4UxIkGN8MMlBQSLDzGHozVeXLHrIT18qV8CkJtoaRgVaXO/0VRgS+h3RzTd0/XpkNpJzN1xGkeDPzGi4YsAQj8gDJJd46RkWjDMvFmZYvAzYfKzpotEOemCV4YlZQs+iBHr2IwgEMc67IfeimWRglTpo9FovX1E8lhQ/SojXAY59fjhjuJkbuXnqsuZlteqc5xTopQAJiGUXFp0qmuWJx2dgscGQoiAOrVU+V4PQaEh76pQyYqugOWQ5OhV1VqJn0taIhV2/zgDbgUE1O1kAJ6SnOuddDPls
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5499.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38100700002)(186003)(26005)(83380400001)(36756003)(30864003)(5660300002)(8936002)(31686004)(2906002)(4326008)(6666004)(966005)(6486002)(508600001)(6506007)(66556008)(66476007)(2616005)(8676002)(6916009)(53546011)(316002)(45080400002)(31696002)(86362001)(66946007)(6512007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TnVjN0dETlJXaS9ybWtPZGx1UEtiaWZsNnQwOTJacC9XRSszZk1Hb3hzcDVz?=
 =?utf-8?B?dmpSNVhvLzFzOE9DMElnQnJVUkg3dWtoMGhpN2M0NnAzcDUxdDU1UUpwRERT?=
 =?utf-8?B?VGF0NzNpUEVRcE85QnhjUDQvZGdjdnJFbFl6dVlobGFaMko3RmZVMktITDVL?=
 =?utf-8?B?eU5DcTdxaVZjcFBZSWJxSkVXbTE4OVpWR2NZSkpoaVJVb3R2V2pqMCtSZE12?=
 =?utf-8?B?ZWR5bUp6QkxiYVhaVzZ5NXpQY1UvY0o1V0Y1a0ZZK3dKbGxNZUZQYmUvNTM1?=
 =?utf-8?B?VXZ0K1RxWnRTU1BRZ0l3R0Iva1FhdVUyN0IwbGJ1a25zbXppT2RGdmYwakw1?=
 =?utf-8?B?TDZxOHlwVTArSW82VlAxMjNza3ZXLzdIc1JNWmJZbGFGUWxXNkl3VEZoVjhp?=
 =?utf-8?B?TEJ1dXBDUXV6bUdWSktrc1BLWC9QUlYwNHY5WmNTbUkwUkZ3SWZhMVpVN3Fu?=
 =?utf-8?B?N0JjYStlU05TcEdSR2lzNHl5VzMxV0ZUaWxCNGpaN3Q4aUI0VEJ2RHJwU2NI?=
 =?utf-8?B?Q1NTeHRzbTJubFlEa2l3cFpOVTdTMkZvWVEzdUZYbmZCeFFYU1d0S0JZYzB0?=
 =?utf-8?B?TEdUaVdpK0kxamgvM0tTb2g1MWdTZU94L1RzY1pxVnpFa1VVSldyTmt4RFBt?=
 =?utf-8?B?Z1ZtZ2JTTGd0RlFtNTAyanA4TXRHdHZtUzlvd0lNdCtlV0VydGxoeW04RzNl?=
 =?utf-8?B?dTk1cmJGNDdSVGhGSW53cmExQXAraHc1Vm1EYlRPMG1DYzk4NEhWcXFJVGg0?=
 =?utf-8?B?aHFrbEVqZ3V5VWIzZTFpQ2pZUnM1NUZOeDdGNzgzUEQ4akNnUHcyd3o2d1ZF?=
 =?utf-8?B?L1RZaEM0REd6SHFNeE4wd1NCMkJzMHJpNkNZVVh3U01PTE40bHMxKzNBMkRv?=
 =?utf-8?B?UkExeUo3RXZJbFRGL01tSVpSbHpjeHl3S3JkNjRCSWZUSUZQaE4rbFp1dUt4?=
 =?utf-8?B?MU9Cb1M5cXNvc1VTUnh4NTRJcHJFSThGaWxxV2x3b2JXLzZsRXVwVWZiOTVO?=
 =?utf-8?B?Wk11OVd6UFJ2TnF6NjJIL3JaaDVzMHlsRnpkUjYyNi8yWHhIQitLOTJZQkw4?=
 =?utf-8?B?dC9TSTJVc2N5ak1VZjJjYmhOeXpkMlIvaWxmK2N4L2NqSDdPWVpCRXpaMndU?=
 =?utf-8?B?aDZQOUlOMmJnS3NBY3dja2pmSFJSaDFQRnpGTU5LZ0l3QUI5Z0hMY3NIT3JL?=
 =?utf-8?B?ckduc0VOMWJ4aDg1S0RTbitqN1Yrb1pONDlPbnU5MldKY0tjQkgwZWc1ZXc3?=
 =?utf-8?B?SUEzRnhSZFdGb01QNW42SUlsZHpLRFpDb1lrR2FmYnlLR29HOGlCUHhwVHA0?=
 =?utf-8?B?MnovRTZZQk03MEQ5dlpXb3FEMDJKcysyQzhHamdNTHlkRUp6b3dsWm5yQi9J?=
 =?utf-8?B?K1YxcHlpZWlQQmUrM0Q4ekorTExjTE5rRGtidnRrWEJmL0IwOGIzVmVjT3JH?=
 =?utf-8?B?UnpBV295c0IvUEFrU0N6WGFNTG9yVXduT0VsaFptVmZvOUJiSDJ5U3RsNzRN?=
 =?utf-8?B?RzlSRTFJYlVnV0lLVjV2NmdUcnU4Q3hJSFlhT2wwM0RCY3RVTFNRVzhUekJI?=
 =?utf-8?B?SWpaVVVjb2VURlMyY3FVb2RhTEdmWVBZdmlwM1N3VjFmTWlOejltVnNUdGE1?=
 =?utf-8?B?bHowM3dJWHcrMHFBeDMwempQMmw0STJMMmdYQlA4MVVsS0FPcTh2NEJqOTJZ?=
 =?utf-8?B?cUlFZjZUYmdCalVLZndmakZLL2M3TWRmRmFSMGx2NXhVeXFPTytZbEwyaG0z?=
 =?utf-8?B?ZjZ1SnZTTkVOcFlsRElVekhHZGZFdjNndXR4ZEgvYllxUlNVWFFaWVh1Rmlo?=
 =?utf-8?B?UllCNTlNNzZOb2krRmxmZk9zOXMvSFNMcHBBTysxVFp3cXMvcUlaMkRlUzRk?=
 =?utf-8?B?NjVwYi8zY0dSUjB6aUpkUmgwUnBVWUdJUGlVN1RmcDdhMDRxcUhNaTd2aEJS?=
 =?utf-8?Q?o/Scil+nvhieGiHEy78Y4pufsnvB5ykZ?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 285c736e-c183-4906-d47d-08da070b2a27
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5499.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2022 05:09:36.1509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z8W3dcarhuVhlb05dQsKv8E4XmyY3RzYW6PY0JdUHAIB6wJp7cGDkUh1R0BqM07zTJ170XaLdrDX7cIJZ08YMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4062
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 3/15/22 20:50, Eyal Birger wrote:
> On Wed, Mar 16, 2022 at 2:33 AM Roopa Prabhu <roopa@nvidia.com> wrote:
>>
>> On 3/15/22 13:22, Eyal Birger wrote:
>>> Hi Roopa,
>>>
>>> On Tue, Mar 15, 2022 at 9:57 PM Roopa Prabhu <roopa@nvidia.com> wrote:
>>>> On 3/15/22 11:56, Eyal Birger wrote:
>>>>> This patch adds support for encapsulating IPv4/IPv6 within GENEVE.
>>>>>
>>>>> In order use this, a new IFLA_GENEVE_TUN flag needs to be provided at
>>>>> device creation. This property cannot be changed for the time being.
>>>>>
>>>>> In case IP traffic is received on a non-tun device the drop count is
>>>>> increased.
>>>>>
>>>>> Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
>>>>> ---
>>>>>     drivers/net/geneve.c         | 79 +++++++++++++++++++++++++++---------
>>>>>     include/uapi/linux/if_link.h |  1 +
>>>>>     2 files changed, 61 insertions(+), 19 deletions(-)
>>>>>
>>>>> diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
>>>>> index a895ff756093..37305ec26250 100644
>>>>> --- a/drivers/net/geneve.c
>>>>> +++ b/drivers/net/geneve.c
>>>>> @@ -56,6 +56,7 @@ struct geneve_config {
>>>>>         bool                    use_udp6_rx_checksums;
>>>>>         bool                    ttl_inherit;
>>>>>         enum ifla_geneve_df     df;
>>>>> +     bool                    tun;
>>>>>     };
>>>>>
>>>>>     /* Pseudo network device */
>>>>> @@ -251,17 +252,24 @@ static void geneve_rx(struct geneve_dev *geneve, struct geneve_sock *gs,
>>>>>                 }
>>>>>         }
>>>>>
>>>>> -     skb_reset_mac_header(skb);
>>>>> -     skb->protocol = eth_type_trans(skb, geneve->dev);
>>>>> -     skb_postpull_rcsum(skb, eth_hdr(skb), ETH_HLEN);
>>>>> -
>>>>>         if (tun_dst)
>>>>>                 skb_dst_set(skb, &tun_dst->dst);
>>>>>
>>>>> -     /* Ignore packet loops (and multicast echo) */
>>>>> -     if (ether_addr_equal(eth_hdr(skb)->h_source, geneve->dev->dev_addr)) {
>>>>> -             geneve->dev->stats.rx_errors++;
>>>>> -             goto drop;
>>>>> +     if (gnvh->proto_type == htons(ETH_P_TEB)) {
>>>>> +             skb_reset_mac_header(skb);
>>>>> +             skb->protocol = eth_type_trans(skb, geneve->dev);
>>>>> +             skb_postpull_rcsum(skb, eth_hdr(skb), ETH_HLEN);
>>>>> +
>>>>> +             /* Ignore packet loops (and multicast echo) */
>>>>> +             if (ether_addr_equal(eth_hdr(skb)->h_source,
>>>>> +                                  geneve->dev->dev_addr)) {
>>>>> +                     geneve->dev->stats.rx_errors++;
>>>>> +                     goto drop;
>>>>> +             }
>>>>> +     } else {
>>>>> +             skb_reset_mac_header(skb);
>>>>> +             skb->dev = geneve->dev;
>>>>> +             skb->pkt_type = PACKET_HOST;
>>>>>         }
>>>>>
>>>>>         oiph = skb_network_header(skb);
>>>>> @@ -345,6 +353,7 @@ static int geneve_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
>>>>>         struct genevehdr *geneveh;
>>>>>         struct geneve_dev *geneve;
>>>>>         struct geneve_sock *gs;
>>>>> +     __be16 inner_proto;
>>>>>         int opts_len;
>>>>>
>>>>>         /* Need UDP and Geneve header to be present */
>>>>> @@ -356,8 +365,13 @@ static int geneve_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
>>>>>         if (unlikely(geneveh->ver != GENEVE_VER))
>>>>>                 goto drop;
>>>>>
>>>>> -     if (unlikely(geneveh->proto_type != htons(ETH_P_TEB)))
>>>>> +     inner_proto = geneveh->proto_type;
>>>>> +
>>>>> +     if (unlikely((inner_proto != htons(ETH_P_TEB) &&
>>>>> +                   inner_proto != htons(ETH_P_IP) &&
>>>>> +                   inner_proto != htons(ETH_P_IPV6)))) {
>>>>>                 goto drop;
>>>>> +     }
>>>>>
>>>> unnecessary braces
>>> Will fix.
>>>
>>>>>         gs = rcu_dereference_sk_user_data(sk);
>>>>>         if (!gs)
>>>>> @@ -367,9 +381,13 @@ static int geneve_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
>>>>>         if (!geneve)
>>>>>                 goto drop;
>>>>>
>>>>> +     if (unlikely((!geneve->cfg.tun && inner_proto != htons(ETH_P_TEB)))) {
>>>>> +             geneve->dev->stats.rx_dropped++;
>>>>> +             goto drop;
>>>>> +     }
>>>> Does this change current default behavior ?.
>>>>
>>>> its unclear to be what the current behavior is for a non ETH_P_TEB packet
>>> Currently non ETH_P_TEB packets are silently dropped.
>>> I figured that if the driver supported other ethertypes it would make
>>> sense to increase the count in such case, to assist in debugging wrong
>>> configurations.
>>>
>>> I can remove this if it's better to keep the current behavior.
>> yes, agree. counting is better.
>>
>>
>>>>> +
>>>>>         opts_len = geneveh->opt_len * 4;
>>>>> -     if (iptunnel_pull_header(skb, GENEVE_BASE_HLEN + opts_len,
>>>>> -                              htons(ETH_P_TEB),
>>>>> +     if (iptunnel_pull_header(skb, GENEVE_BASE_HLEN + opts_len, inner_proto,
>>>>>                                  !net_eq(geneve->net, dev_net(geneve->dev)))) {
>>>>>                 geneve->dev->stats.rx_dropped++;
>>>>>                 goto drop;
>>>>> @@ -717,7 +735,8 @@ static int geneve_stop(struct net_device *dev)
>>>>>     }
>>>>>
>>>>>     static void geneve_build_header(struct genevehdr *geneveh,
>>>>> -                             const struct ip_tunnel_info *info)
>>>>> +                             const struct ip_tunnel_info *info,
>>>>> +                             __be16 inner_proto)
>>>>>     {
>>>>>         geneveh->ver = GENEVE_VER;
>>>>>         geneveh->opt_len = info->options_len / 4;
>>>>> @@ -725,7 +744,7 @@ static void geneve_build_header(struct genevehdr *geneveh,
>>>>>         geneveh->critical = !!(info->key.tun_flags & TUNNEL_CRIT_OPT);
>>>>>         geneveh->rsvd1 = 0;
>>>>>         tunnel_id_to_vni(info->key.tun_id, geneveh->vni);
>>>>> -     geneveh->proto_type = htons(ETH_P_TEB);
>>>>> +     geneveh->proto_type = inner_proto;
>>>>>         geneveh->rsvd2 = 0;
>>>>>
>>>>>         if (info->key.tun_flags & TUNNEL_GENEVE_OPT)
>>>>> @@ -734,8 +753,9 @@ static void geneve_build_header(struct genevehdr *geneveh,
>>>>>
>>>>>     static int geneve_build_skb(struct dst_entry *dst, struct sk_buff *skb,
>>>>>                             const struct ip_tunnel_info *info,
>>>>> -                         bool xnet, int ip_hdr_len)
>>>>> +                         bool xnet, int ip_hdr_len, bool tun)
>>>>>     {
>>>>> +     __be16 inner_proto = tun ? skb->protocol : htons(ETH_P_TEB);
>>>>>         bool udp_sum = !!(info->key.tun_flags & TUNNEL_CSUM);
>>>>>         struct genevehdr *gnvh;
>>>>>         int min_headroom;
>>>>> @@ -755,8 +775,8 @@ static int geneve_build_skb(struct dst_entry *dst, struct sk_buff *skb,
>>>>>                 goto free_dst;
>>>>>
>>>>>         gnvh = __skb_push(skb, sizeof(*gnvh) + info->options_len);
>>>>> -     geneve_build_header(gnvh, info);
>>>>> -     skb_set_inner_protocol(skb, htons(ETH_P_TEB));
>>>>> +     geneve_build_header(gnvh, info, inner_proto);
>>>>> +     skb_set_inner_protocol(skb, inner_proto);
>>>>>         return 0;
>>>>>
>>>>>     free_dst:
>>>>> @@ -959,7 +979,8 @@ static int geneve_xmit_skb(struct sk_buff *skb, struct net_device *dev,
>>>>>                 }
>>>>>         }
>>>>>
>>>>> -     err = geneve_build_skb(&rt->dst, skb, info, xnet, sizeof(struct iphdr));
>>>>> +     err = geneve_build_skb(&rt->dst, skb, info, xnet, sizeof(struct iphdr),
>>>>> +                            geneve->cfg.tun);
>>>>>         if (unlikely(err))
>>>>>                 return err;
>>>>>
>>>>> @@ -1038,7 +1059,8 @@ static int geneve6_xmit_skb(struct sk_buff *skb, struct net_device *dev,
>>>>>                         ttl = key->ttl;
>>>>>                 ttl = ttl ? : ip6_dst_hoplimit(dst);
>>>>>         }
>>>>> -     err = geneve_build_skb(dst, skb, info, xnet, sizeof(struct ipv6hdr));
>>>>> +     err = geneve_build_skb(dst, skb, info, xnet, sizeof(struct ipv6hdr),
>>>>> +                            geneve->cfg.tun);
>>>>>         if (unlikely(err))
>>>>>                 return err;
>>>>>
>>>>> @@ -1388,6 +1410,14 @@ static int geneve_configure(struct net *net, struct net_device *dev,
>>>>>         dst_cache_reset(&geneve->cfg.info.dst_cache);
>>>>>         memcpy(&geneve->cfg, cfg, sizeof(*cfg));
>>>>>
>>>>> +     if (geneve->cfg.tun) {
>>>>> +             dev->header_ops = NULL;
>>>>> +             dev->type = ARPHRD_NONE;
>>>>> +             dev->hard_header_len = 0;
>>>>> +             dev->addr_len = 0;
>>>>> +             dev->flags = IFF_NOARP;
>>>>> +     }
>>>>> +
>>>>>         err = register_netdevice(dev);
>>>>>         if (err)
>>>>>                 return err;
>>>>> @@ -1561,10 +1591,18 @@ static int geneve_nl2info(struct nlattr *tb[], struct nlattr *data[],
>>>>>     #endif
>>>>>         }
>>>>>
>>>>> +     if (data[IFLA_GENEVE_TUN]) {
>>>>> +             if (changelink) {
>>>>> +                     attrtype = IFLA_GENEVE_TUN;
>>>>> +                     goto change_notsup;
>>>>> +             }
>>>>> +             cfg->tun = true;
>>>>> +     }
>>>>> +
>>>>>         return 0;
>>>>>     change_notsup:
>>>>>         NL_SET_ERR_MSG_ATTR(extack, data[attrtype],
>>>>> -                         "Changing VNI, Port, endpoint IP address family, external, and UDP checksum attributes are not supported");
>>>>> +                         "Changing VNI, Port, endpoint IP address family, external, tun, and UDP checksum attributes are not supported");
>>>>>         return -EOPNOTSUPP;
>>>>>     }
>>>>>
>>>>> @@ -1799,6 +1837,9 @@ static int geneve_fill_info(struct sk_buff *skb, const struct net_device *dev)
>>>>>         if (nla_put_u8(skb, IFLA_GENEVE_TTL_INHERIT, ttl_inherit))
>>>>>                 goto nla_put_failure;
>>>>>
>>>>> +     if (geneve->cfg.tun && nla_put_flag(skb, IFLA_GENEVE_TUN))
>>>>> +             goto nla_put_failure;
>>>>> +
>>>>>         return 0;
>>>>>
>>>>>     nla_put_failure:
>>>>> diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
>>>>> index bd24c7dc10a2..198aefa2c513 100644
>>>>> --- a/include/uapi/linux/if_link.h
>>>>> +++ b/include/uapi/linux/if_link.h
>>>>> @@ -842,6 +842,7 @@ enum {
>>>>>         IFLA_GENEVE_LABEL,
>>>>>         IFLA_GENEVE_TTL_INHERIT,
>>>>>         IFLA_GENEVE_DF,
>>>>> +     IFLA_GENEVE_TUN,
>>>> geneve is itself called a tunnel, i wonder if a different name for the
>>>> flag would be more appropriate.
>>> I tried to find a reference to something similar, so went with something like
>>> the tun vs. tap distinction. I was also concerned about the possible
>>> confusion, but it felt clearer than something like L3_INNER_PROTO_MODE.
>>>
>>> I'd happily replace it with a better suggestion.
>> o ok, makes sense. I can't think of anything other than simply
>> IFLA_GENEVE_INNER_PROTO
>>
>> (maybe others have better suggestions)
> My concern with calling it IFLA_GENEVE_INNER_PROTO is that inner_proto is
> used internally to denote the inner proto value.
>
> Would IFLA_GENEVE_INNER_PROTO_INHERIT make sense?

yes, i like that better (and there is precedence to using inherit)


>>
>>>> what is the use case for this ?. is there a RFC reference ?
>>> I stumbled upon this configuration when trying to receive packets from an
>>> AWS "Gateway Load Balancer" which sends IP packets encapsulated in GENEVE [1].
>>>
>>> But to my understanding the RFC allows this so it doesn't seem something
>>> specific to AWS.
>> that makes me wonder if we need a knob atall and if this should be
>> allowed by default.
> I didn't find a way to make tx work without requiring a flag, so I thought
> it'd be better if this mode was enforced in both directions.

ok, in that case flag is ok.


>
>> wonder how other network vendor standard geneve implementations behave
>> by default.
>>
>>
>>> Thanks for the review!
>>>
>>> Eyal.
>>>
>>> [1] https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Faws.amazon.com%2Fblogs%2Fnetworking-and-content-delivery%2Fintegrate-your-custom-logic-or-appliance-with-aws-gateway-load-balancer%2F&amp;data=04%7C01%7Croopa%40nvidia.com%7C15818ae5c7f949db55f908da07002ccd%7C43083d15727340c1b7db39efd9ccc17a%7C0%7C0%7C637829994585887100%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000&amp;sdata=a4hU8aizVq%2Bp4ETdpn4oNIUAkNT%2FPkDiVtTGr8ksBts%3D&amp;reserved=0
>> Thanks for the details.
>>
>>
