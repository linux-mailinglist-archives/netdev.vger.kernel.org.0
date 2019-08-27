Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD7D9DE39
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 08:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726078AbfH0Gsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 02:48:31 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43888 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbfH0Gsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 02:48:31 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7R6lNvn043146;
        Tue, 27 Aug 2019 06:48:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=gU+HB3pJ65Z/CIPbTOsjIM/I3FGkYW/RclbgyMQoIDg=;
 b=Zdd5A3Vwp1c7tcoRhzODSZJ81G5n5UP4X0YPdoGnPsljiZ7GdWlYS46dKJeBuvVUs7oe
 9sQrq7vgObMsGpIPOAina41iJ/7S8ZbbvuJLYknhPpgRwYh98WtUUPo/XWTpYKmNJ90N
 9PY+tdqUdUcGyeMLPty5WcpaZQsLT6TcoJ2B4BCTBPOnrajV6VlP2A+H2cOybWzRmRLD
 oA1Udcs9NPRvX6ynMRILv++tKYbs3NVBPGBwQH5NE/l33JhAHW/pEBZu8h7CPX++A2+y
 s+1sgr+43DJ+HzeeSMl8Oa2ZkLQ4V9sdKMUe1P3NVtI8lUaxOCLjnjxuq0guJ2gBsr4z hg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2umycc82py-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Aug 2019 06:48:24 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7R6gQ8N170972;
        Tue, 27 Aug 2019 06:43:25 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2umj2y9fg5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Aug 2019 06:43:25 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id x7R6hOpY028054;
        Tue, 27 Aug 2019 06:43:24 GMT
Received: from [10.182.69.106] (/10.182.69.106)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 26 Aug 2019 23:43:24 -0700
Subject: Re: [Xen-devel] Question on xen-netfront code to fix a potential ring
 buffer corruption
To:     Juergen Gross <jgross@suse.com>, xen-devel@lists.xenproject.org
Cc:     netdev@vger.kernel.org, Joe Jin <joe.jin@oracle.com>
References: <c45b306e-c67b-49f5-8fe8-3913557a8774@default>
 <130ea0ab-4364-2b77-dc8d-b869e06d1768@suse.com>
From:   Dongli Zhang <dongli.zhang@oracle.com>
Message-ID: <9284025e-1066-387e-a52f-c46d4c66d2d3@oracle.com>
Date:   Tue, 27 Aug 2019 14:43:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <130ea0ab-4364-2b77-dc8d-b869e06d1768@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908270074
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9361 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908270074
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Juergen,

On 8/27/19 2:13 PM, Juergen Gross wrote:
> On 18.08.19 10:31, Dongli Zhang wrote:
>> Hi,
>>
>> Would you please help confirm why the condition at line 908 is ">="?
>>
>> In my opinion, we would only hit "skb_shinfo(skb)->nr_frag == MAX_SKB_FRAGS" at
>> line 908.
>>
>> 890 static RING_IDX xennet_fill_frags(struct netfront_queue *queue,
>> 891                                   struct sk_buff *skb,
>> 892                                   struct sk_buff_head *list)
>> 893 {
>> 894         RING_IDX cons = queue->rx.rsp_cons;
>> 895         struct sk_buff *nskb;
>> 896
>> 897         while ((nskb = __skb_dequeue(list))) {
>> 898                 struct xen_netif_rx_response *rx =
>> 899                         RING_GET_RESPONSE(&queue->rx, ++cons);
>> 900                 skb_frag_t *nfrag = &skb_shinfo(nskb)->frags[0];
>> 901
>> 902                 if (skb_shinfo(skb)->nr_frags == MAX_SKB_FRAGS) {
>> 903                         unsigned int pull_to = NETFRONT_SKB_CB(skb)->pull_to;
>> 904
>> 905                         BUG_ON(pull_to < skb_headlen(skb));
>> 906                         __pskb_pull_tail(skb, pull_to - skb_headlen(skb));
>> 907                 }
>> 908                 if (unlikely(skb_shinfo(skb)->nr_frags >= MAX_SKB_FRAGS)) {
>> 909                         queue->rx.rsp_cons = ++cons;
>> 910                         kfree_skb(nskb);
>> 911                         return ~0U;
>> 912                 }
>> 913
>> 914                 skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags,
>> 915                                 skb_frag_page(nfrag),
>> 916                                 rx->offset, rx->status, PAGE_SIZE);
>> 917
>> 918                 skb_shinfo(nskb)->nr_frags = 0;
>> 919                 kfree_skb(nskb);
>> 920         }
>> 921
>> 922         return cons;
>> 923 }
>>
>>
>> The reason that I ask about this is because I am considering below patch to
>> avoid a potential xen-netfront ring buffer corruption.
>>
>> diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
>> index 8d33970..48a2162 100644
>> --- a/drivers/net/xen-netfront.c
>> +++ b/drivers/net/xen-netfront.c
>> @@ -906,7 +906,7 @@ static RING_IDX xennet_fill_frags(struct netfront_queue
>> *queue,
>>                          __pskb_pull_tail(skb, pull_to - skb_headlen(skb));
>>                  }
>>                  if (unlikely(skb_shinfo(skb)->nr_frags >= MAX_SKB_FRAGS)) {
>> -                       queue->rx.rsp_cons = ++cons;
>> +                       queue->rx.rsp_cons = cons + skb_queue_len(list) + 1;
>>                          kfree_skb(nskb);
>>                          return ~0U;
>>                  }
>>
>>
>> If there is skb left in list when we return ~0U, queue->rx.rsp_cons may be set
>> incorrectly.
> 
> Sa basically you want to consume the responses for all outstanding skbs
> in the list?
> 

I think there would be bug if there is skb left in the list.

This is what is implanted in xennet_poll() when there is error of processing
extra info like below. As at line 1034, if there is error, all outstanding skb
are consumed.

 985 static int xennet_poll(struct napi_struct *napi, int budget)
... ...
1028                 if (extras[XEN_NETIF_EXTRA_TYPE_GSO - 1].type) {
1029                         struct xen_netif_extra_info *gso;
1030                         gso = &extras[XEN_NETIF_EXTRA_TYPE_GSO - 1];
1031
1032                         if (unlikely(xennet_set_skb_gso(skb, gso))) {
1033                                 __skb_queue_head(&tmpq, skb);
1034                                 queue->rx.rsp_cons += skb_queue_len(&tmpq);
1035                                 goto err;
1036                         }
1037                 }

The reason we need to consume all outstanding skb is because
xennet_get_responses() would reset both queue->rx_skbs[i] and
queue->grant_rx_ref[i] to NULL before enqueue all outstanding skb to the list
(e.g., &tmpq), by xennet_get_rx_skb() and xennet_get_rx_ref().

If we do not consume all of them, we would hit NULL in queue->rx_skbs[i] in next
iteration of while loop in xennet_poll().

That is, if we do not consume all outstanding skb, the queue->rx.rsp_cons may
refer to a response whose queue->rx_skbs[i] and queue->grant_rx_ref[i] are
already reset to NULL.

Dongli Zhang

>>
>> While I am trying to make up a case that would hit the corruption, I could not
>> explain why (unlikely(skb_shinfo(skb)->nr_frags >= MAX_SKB_FRAGS)), but not
>> just "==". Perhaps __pskb_pull_tail() may fail although pull_to is less than
>> skb_headlen(skb).
> 
> I don't think nr_frags can be larger than MAX_SKB_FRAGS. OTOH I don't
> think it hurts to have a safety net here in order to avoid problems.
> 
> Originally this was BUG_ON(skb_shinfo(skb)->nr_frags >= MAX_SKB_FRAGS)
> so that might explain the ">=".
> 
> 
> Juergen
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xenproject.org
> https://lists.xenproject.org/mailman/listinfo/xen-devel
