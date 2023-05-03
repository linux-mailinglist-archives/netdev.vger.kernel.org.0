Return-Path: <netdev+bounces-216-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 674E86F5F1F
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 21:29:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2010A2817D5
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 19:29:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AB712DF72;
	Wed,  3 May 2023 19:29:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4ABDF44
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 19:29:21 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF2DC7AB6
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 12:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683142150;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jRwjvZ2VKO5tJCw7F2X8M4sdJim7dIHGW9ircHbAPdA=;
	b=PH292c4aaBNGaQ6dmTxLO8H9iX1j/+tEvfBygeb1vPJxXz7qM/sOQYEypxdxYzEhYdR4Np
	McJ3KcnXgJpIpqs1ugumFwEXWLQNj9/LUdkdMx4D/ec6RXzJe7lZVs6RWC2zMcbA1fq5x9
	g9boZRUlRKzGxsfPDrX7BhcSIIjpFlg=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-195-4RIABJoxN7qF4ViH_-bKWA-1; Wed, 03 May 2023 15:29:09 -0400
X-MC-Unique: 4RIABJoxN7qF4ViH_-bKWA-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-61b5af37298so23097376d6.2
        for <netdev@vger.kernel.org>; Wed, 03 May 2023 12:29:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683142149; x=1685734149;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jRwjvZ2VKO5tJCw7F2X8M4sdJim7dIHGW9ircHbAPdA=;
        b=UqrhiTbHwl6ZSUqvym61IKZ1n7ZLHjX9i3Yrr1YfB9HBRm8DsH2Kv7EtnzgrPrfUSj
         lwjtThYepSDCHv904GZ13qI2RclrpWP/dDEMvIQbxc7G9ule1ZdmW/5RbM0knRMCJoNi
         5Wis9JS9OAc1jrgzsDx4T4D6M7ljqtNrHQUCn0MiGJbbXh/f8+eSlvknnoXqL41XGlJj
         4nHUB9G2MdqkEVCN7qx6tQQ0NfSfWj14uBuhN6vrOOW1eYCPDMdBftD2hu4pIP90KA1o
         o/LZBLlTofIwSwKd/VGGt+BADvvmiH0xyPapCZ97PCk70ynObYmJhHWl+9IBqTs1NfyC
         lUiQ==
X-Gm-Message-State: AC+VfDxm04uGDr9yoNqogLB6N7DxH/COUKKyAsCzn51+w23Gs2bXvpVK
	pgGKUu620tY+2fOnD694gZ50EW4hYlo6z/2OiiqaZAeyFnEHISB7Qc/sAsLUuEdgWVyPf8B03vE
	aXePvACstq65GjwJpQnoW4IZt
X-Received: by 2002:a05:6214:1949:b0:61b:6c88:4bd3 with SMTP id q9-20020a056214194900b0061b6c884bd3mr8654980qvk.47.1683142149160;
        Wed, 03 May 2023 12:29:09 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7VOT2ZatXLqDl2g8Nzo8ESPBlGcGo/BveO2meXQifLvoHE06HAOD7NyAv1gygW9NYItHalLA==
X-Received: by 2002:a05:6214:1949:b0:61b:6c88:4bd3 with SMTP id q9-20020a056214194900b0061b6c884bd3mr8654955qvk.47.1683142148829;
        Wed, 03 May 2023 12:29:08 -0700 (PDT)
Received: from [10.0.0.97] ([24.225.234.80])
        by smtp.gmail.com with ESMTPSA id w29-20020ac84d1d000000b003e4ee0f5234sm11845724qtv.87.2023.05.03.12.29.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 May 2023 12:29:08 -0700 (PDT)
Message-ID: <d7ccfcc9-b446-66ad-ab04-baa1cdbbe0ce@redhat.com>
Date: Wed, 3 May 2023 15:29:07 -0400
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCHv2 net 2/3] tipc: do not update mtu if msg_max is too small
 in mtu negotiation
To: Xin Long <lucien.xin@gmail.com>,
 Tung Quang Nguyen <tung.q.nguyen@dektech.com.au>
Cc: network dev <netdev@vger.kernel.org>,
 "tipc-discussion@lists.sourceforge.net"
 <tipc-discussion@lists.sourceforge.net>,
 "davem@davemloft.net" <davem@davemloft.net>,
 "kuba@kernel.org" <kuba@kernel.org>, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>
References: <cover.1683065352.git.lucien.xin@gmail.com>
 <0d328807d5087d0b6d03c3d2e5f355cd44ed576a.1683065352.git.lucien.xin@gmail.com>
 <DB9PR05MB90784F5E870CF98996BD406A886C9@DB9PR05MB9078.eurprd05.prod.outlook.com>
 <CADvbK_f5YPuY0eaZj5JcixUU7rFQosuAWg8PdorrGz08ve6DmA@mail.gmail.com>
Content-Language: en-US
From: Jon Maloy <jmaloy@redhat.com>
In-Reply-To: <CADvbK_f5YPuY0eaZj5JcixUU7rFQosuAWg8PdorrGz08ve6DmA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 2023-05-03 09:35, Xin Long wrote:
> On Tue, May 2, 2023 at 11:31 PM Tung Quang Nguyen
> <tung.q.nguyen@dektech.com.au> wrote:
>>> When doing link mtu negotiation, a malicious peer may send Activate msg
>>> with a very small mtu, e.g. 4 in Shuang's testing, without checking for
>>> the minimum mtu, l->mtu will be set to 4 in tipc_link_proto_rcv(), then
>>> n->links[bearer_id].mtu is set to 4294967228, which is a overflow of
>>> '4 - INT_H_SIZE - EMSG_OVERHEAD' in tipc_link_mss().
>>>
>>> With tipc_link.mtu = 4, tipc_link_xmit() kept printing the warning:
>>>
>>> tipc: Too large msg, purging xmit list 1 5 0 40 4!
>>> tipc: Too large msg, purging xmit list 1 15 0 60 4!
>>>
>>> And with tipc_link_entry.mtu 4294967228, a huge skb was allocated in
>>> named_distribute(), and when purging it in tipc_link_xmit(), a crash
>>> was even caused:
>>>
>>>   general protection fault, probably for non-canonical address 0x2100001011000dd: 0000 [#1] PREEMPT SMP PTI
>>>   CPU: 0 PID: 0 Comm: swapper/0 Kdump: loaded Not tainted 6.3.0.neta #19
>>>   RIP: 0010:kfree_skb_list_reason+0x7e/0x1f0
>>>   Call Trace:
>>>    <IRQ>
>>>    skb_release_data+0xf9/0x1d0
>>>    kfree_skb_reason+0x40/0x100
>>>    tipc_link_xmit+0x57a/0x740 [tipc]
>>>    tipc_node_xmit+0x16c/0x5c0 [tipc]
>>>    tipc_named_node_up+0x27f/0x2c0 [tipc]
>>>    tipc_node_write_unlock+0x149/0x170 [tipc]
>>>    tipc_rcv+0x608/0x740 [tipc]
>>>    tipc_udp_recv+0xdc/0x1f0 [tipc]
>>>    udp_queue_rcv_one_skb+0x33e/0x620
>>>    udp_unicast_rcv_skb.isra.72+0x75/0x90
>>>    __udp4_lib_rcv+0x56d/0xc20
>>>    ip_protocol_deliver_rcu+0x100/0x2d0
>>>
>>> This patch fixes it by checking the new mtu against tipc_bearer_min_mtu(),
>>> and not updating mtu if it is too small.
>>>
>>> v1->v2:
>>>   - do the msg_max check against the min MTU early, as Tung suggested.
>> Please move above version change comment to after "---".
> I think it's correct to NOT use ''---' for version changes, see the
> comment from davem:
>
>    https://lore.kernel.org/netdev/20160415.172858.253625178036493951.davem@davemloft.net/
>
> unless there are some new rules I missed.
I have not seen this one before, and I disagree with David here. Many of 
the changes
between versions are trivial, and some comments even incomprehensible 
once the patch has
been applied.
I have always put them after the "---" comment, and I will continue to 
do so until David starts
rejecting such patches.

But ok, do as you find right.

///jon

>
> Thanks.
>
>>> Fixes: ed193ece2649 ("tipc: simplify link mtu negotiation")
>>> Reported-by: Shuang Li <shuali@redhat.com>
>>> Signed-off-by: Xin Long <lucien.xin@gmail.com>
>>> ---
>>> net/tipc/link.c | 9 ++++++---
>>> 1 file changed, 6 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/net/tipc/link.c b/net/tipc/link.c
>>> index b3ce24823f50..2eff1c7949cb 100644
>>> --- a/net/tipc/link.c
>>> +++ b/net/tipc/link.c
>>> @@ -2200,7 +2200,7 @@ static int tipc_link_proto_rcv(struct tipc_link *l, struct sk_buff *skb,
>>>        struct tipc_msg *hdr = buf_msg(skb);
>>>        struct tipc_gap_ack_blks *ga = NULL;
>>>        bool reply = msg_probe(hdr), retransmitted = false;
>>> -      u32 dlen = msg_data_sz(hdr), glen = 0;
>>> +      u32 dlen = msg_data_sz(hdr), glen = 0, msg_max;
>>>        u16 peers_snd_nxt =  msg_next_sent(hdr);
>>>        u16 peers_tol = msg_link_tolerance(hdr);
>>>        u16 peers_prio = msg_linkprio(hdr);
>>> @@ -2239,6 +2239,9 @@ static int tipc_link_proto_rcv(struct tipc_link *l, struct sk_buff *skb,
>>>        switch (mtyp) {
>>>        case RESET_MSG:
>>>        case ACTIVATE_MSG:
>>> +              msg_max = msg_max_pkt(hdr);
>>> +              if (msg_max < tipc_bearer_min_mtu(l->net, l->bearer_id))
>>> +                      break;
>>>                /* Complete own link name with peer's interface name */
>>>                if_name =  strrchr(l->name, ':') + 1;
>>>                if (sizeof(l->name) - (if_name - l->name) <= TIPC_MAX_IF_NAME)
>>> @@ -2283,8 +2286,8 @@ static int tipc_link_proto_rcv(struct tipc_link *l, struct sk_buff *skb,
>>>                l->peer_session = msg_session(hdr);
>>>                l->in_session = true;
>>>                l->peer_bearer_id = msg_bearer_id(hdr);
>>> -              if (l->mtu > msg_max_pkt(hdr))
>>> -                      l->mtu = msg_max_pkt(hdr);
>>> +              if (l->mtu > msg_max)
>>> +                      l->mtu = msg_max;
>>>                break;
>>>
>>>        case STATE_MSG:
>>> --
>>> 2.39.1


