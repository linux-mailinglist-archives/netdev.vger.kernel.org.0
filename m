Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 721E466B4DC
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 00:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbjAOX5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 18:57:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231446AbjAOX5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 18:57:40 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C714C67E
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 15:57:39 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id u8so13384231ilg.0
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 15:57:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XknCUbek0HUyR7hMqJ+X+TKXZD2oRjo4VurNLGt9IEw=;
        b=mG40FLk769xG5ZLZh/B3zBijXI8u4KwzNYreDwgD7NUJM8Lm6W0jfEhoTml7HDVURi
         QLfN2mwotehtuOMY1Qlgb/pJTIwEhOrX7QUlkQxSgSKsoFpISbYLAw5QEmbsOR9meaKH
         ZCebWNmwk6QEmsDGuwXfl1A9svAceUsX06TQYgKMD9AuTP3E7eKHqKeJ/PpkrURJYXDe
         5OWQrHIvDglsskt/GtxWP/geJXvCE+3pkBE/yevUK8PPCRwDhMIv3YWmDm15Q3ifUfxe
         fxLN3CpPMlCGnaKv4WCu7daLwrRfiwJIfEfsJpjDc8emNReQIFp6PpiGzAPB9MyxbA8i
         oo2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XknCUbek0HUyR7hMqJ+X+TKXZD2oRjo4VurNLGt9IEw=;
        b=ZSl56yZLi0HX4/ShQqu7wNcufYIMjXu8r4oyIkqg69LZ5U2SVWw4x0lqXpOQV1kWkv
         l/b7H08iEDBZbn3wAPSbD2t0GvsEs6KCUwHiNZqzmGpToNPMtkpscig7CbbVbTZdHKQk
         idL3tBWFKHfh2ym1gZchcLb8HSuc0uFhcmbk9ahrHBTdtGtPbXcg5Bvi9KZ8PvzNCU5J
         VspkgqHbU6iUWVVTImasse6zaKXWvO69IOKgvDfgMYz4aWaQ0GSkMYfweituLcvnAX79
         aeZmMPtWzW2M/E2YiIbPlkF4EcszN2/YnJvZkyaF9DT78q6vTc8gNymboi/SuF2eUe5s
         XC9A==
X-Gm-Message-State: AFqh2kq/dhmZb1K/20Xw6dgrK0HsewjkCNDMmAnb9Nmw8nYV2wp/EuWd
        0u6K6LI3SjzUeLma52rcOlg=
X-Google-Smtp-Source: AMrXdXs/7rlNVBLWIxduUZTum0p8LdO1X8pqZb0nlGyk5jJrayoort1uWpdJzXx9uODZ9vYEDX8jVg==
X-Received: by 2002:a05:6e02:108:b0:30c:5c54:c264 with SMTP id t8-20020a056e02010800b0030c5c54c264mr34101498ilm.13.1673827058444;
        Sun, 15 Jan 2023 15:57:38 -0800 (PST)
Received: from ?IPV6:2601:284:8200:b700:7de9:438a:dc6b:e300? ([2601:284:8200:b700:7de9:438a:dc6b:e300])
        by smtp.googlemail.com with ESMTPSA id q20-20020a056e02097400b0030bf7ae141esm8050282ilt.2.2023.01.15.15.57.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Jan 2023 15:57:37 -0800 (PST)
Message-ID: <7181c170-3d10-fd3a-2769-7e8e40d54b41@gmail.com>
Date:   Sun, 15 Jan 2023 16:57:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 09/10] netfilter: get ipv6 pktlen properly in
 length_mt6
Content-Language: en-US
To:     Xin Long <lucien.xin@gmail.com>, Eric Dumazet <edumazet@google.com>
Cc:     network dev <netdev@vger.kernel.org>, davem@davemloft.net,
        kuba@kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Mahesh Bandewar <maheshb@google.com>,
        Paul Moore <paul@paul-moore.com>,
        Guillaume Nault <gnault@redhat.com>
References: <cover.1673666803.git.lucien.xin@gmail.com>
 <de91843a7f59feb065475ca82be22c275bede3df.1673666803.git.lucien.xin@gmail.com>
 <b0a1bebc-7d44-05bc-347c-94da4cf2ef27@gmail.com>
 <CADvbK_cxQa0=ximH1F2bA-r0Q2+nMGAsSKhbaKzFTHOrcCF11A@mail.gmail.com>
 <CANn89iK4oSgoxJVkXO5rZXLzG1xw-xP31QbGHGvjhXqR2SSsRQ@mail.gmail.com>
 <CADvbK_c+RAFyrwuL+dfU3hc5U+ytOHC=TQ_xrkvXb4bB7XKjEA@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <CADvbK_c+RAFyrwuL+dfU3hc5U+ytOHC=TQ_xrkvXb4bB7XKjEA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/15/23 1:14 PM, Xin Long wrote:
>>
>> So skb->len is not the root of trust. Some transport mediums might add paddings.
>>

That padding is to meet minimum packet sizes AIUI.

Ethernet for example has a minimum packet length of 60B. Some protocols
running over ethernet can generate packets less than 60B. For example,
ARP is 52B as I recall so something in the hardware pipeline must pad
that out to 60B. IPv4 with UDP and small L4 payloads is another example.
So the trim is to remove the padding added to meet a minimum size. That
should not be relevant for large packets.

>> Ipv4 has a similar logic in ip_rcv_core().
>>
>> len = ntohs(iph->tot_len);
>> if (skb->len < len) {
>>      drop_reason = SKB_DROP_REASON_PKT_TOO_SMALL;
>>      __IP_INC_STATS(net, IPSTATS_MIB_INTRUNCATEDPKTS);
>>     goto drop;
>> } else if (len < (iph->ihl*4))
>>      goto inhdr_error;
>>
>> /* Our transport medium may have padded the buffer out. Now we know it
>> * is IP we can trim to the true length of the frame.
>> * Note this now means skb->len holds ntohs(iph->tot_len).
>> */
>> if (pskb_trim_rcsum(skb, len)) {
>>       __IP_INC_STATS(net, IPSTATS_MIB_INDISCARDS);
>>       goto drop;
>> }
>>
>> After your changes, we might accept illegal packets that were properly
>> dropped before.
> I think skb->len is trustable for GSO/GRO packets.

That is my understanding as well.

> In ipv6_gro_complete/inet_gro_complete():
> The new length for payload_len or iph->tot_len are all calculated from skb->len.
> As I said in the cover-letter, "there is no padding in GSO/GRO packets".
> Or am I missing something?
> 
> Thanks.

