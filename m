Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C64876EFD21
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 00:24:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239550AbjDZWYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 18:24:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233809AbjDZWYk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 18:24:40 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43BB130F4
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 15:24:39 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id e9e14a558f8ab-32b102ca487so59446945ab.2
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 15:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682547878; x=1685139878;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FWiTJqbPhhp18mX6z+Z8+5ZDuSrFB2q+Wye/c5xSqOo=;
        b=mk4KkdEyPOG1VRhtC5/WrAW53otONJvTlmJUcKPQeUtFHGmXoxBa9OEgnl/h2rc32K
         fYhrUlkgm0pseaQSWP9JLBEHUrUjkB5m6FeijZa2RHo0cPozpbejHT6jPpbmCbUWLmDc
         xPC3evZS0X2U6YjokvMu50+z0hIReZdWWuS5bjVBsf8gz6w/bAqAZAxgD1CNV2xd/YUz
         PeDuCpISyShr0Z/xdcovLg5gZC/GStJx3G47XR+N7uL1neB/QMPPL4/M1d1EHmXd/7be
         A/WqA1iKlhMbpQ+A7iDzbxAn74TOhGXrD9wMxVVl0yCO9MhbWvWHBgtlJ0mj//jGMAY7
         rsCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682547878; x=1685139878;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FWiTJqbPhhp18mX6z+Z8+5ZDuSrFB2q+Wye/c5xSqOo=;
        b=TNPn5/bYWJqM5anNgUove8pxC1ireAj8J7hgAFh1Jd96CbpjRtvpay6YJ/PnN0Yuhz
         l3R71TYAcFSpGmWZ7Fje0uCY1a7XcYL3OJz7hBwdlLxwt6gmVkMc4s2+bEZX4noN9Ugb
         B6AZBDUkgpwBPft5IwHKPvNA5eq8GlEbYxOe/gNuz6quP8riNTMrO3zfR8ZMa6PL/uuX
         jjzbSvauYIp3gdy0FkuL6cyPGkDbvha/3UFhWHcfuS/T7hzrnvdDnRbtMMFHyR+KGFqF
         CSGNeEQstZryJUbGwNMzgiVUnaVBOsZ7v1lKrhXacowublmuWstIEcfr6VE23NKaJOXk
         zypw==
X-Gm-Message-State: AAQBX9ei7WoJSg7ZcfhV079pAgNrxoRot1eSyRAhdAt8IBUL1zEhvQ2N
        gZa/e5hro4N5zcRr9xI2mkm+84lq1Ns=
X-Google-Smtp-Source: AKy350aCeHqJ8lk9okt2P7hf/WkZVpMp2MwCQd0r/rpsxD99WzRKpQN8Yo+hKnsAkcH/bQuN+8sDVg==
X-Received: by 2002:a92:ca8c:0:b0:32a:bd64:4950 with SMTP id t12-20020a92ca8c000000b0032abd644950mr9229156ilo.9.1682547878477;
        Wed, 26 Apr 2023 15:24:38 -0700 (PDT)
Received: from ?IPV6:2601:282:800:7ed0:cd3f:3e10:b939:59de? ([2601:282:800:7ed0:cd3f:3e10:b939:59de])
        by smtp.googlemail.com with ESMTPSA id r3-20020a056e02108300b0032934416cc8sm4570101ilj.27.2023.04.26.15.24.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Apr 2023 15:24:38 -0700 (PDT)
Message-ID: <c70000f6-baa4-4a05-46d0-4b3e0dc1ccc8@gmail.com>
Date:   Wed, 26 Apr 2023 16:24:36 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: kernel panics with Big TCP and Tx ZC with hugepages
Content-Language: en-US
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Xin Long <lucien.xin@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Nikolay Aleksandrov <razor@blackwall.org>
References: <5a2eae5c-9ad7-aca5-4927-665db946cfb2@gmail.com>
 <64499d0a996d1_23212b294b@willemb.c.googlers.com.notmuch>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <64499d0a996d1_23212b294b@willemb.c.googlers.com.notmuch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/26/23 3:52 PM, Willem de Bruijn wrote:
> David Ahern wrote:
>> This has been on the back burner for too long now and with v6.3 released
>> we should get it resolved before reports start rolling in. I am throwing
>> this data dump out to the mailing list hoping someone else can provide
>> more insights.
>>
>> Big TCP (both IPv6 and IPv4 versions are affected) can cause a variety
>> of panics when combined with the Tx ZC API and buffers backed by
>> hugepages. I have seen this with mlx5, a driver under development and
>> veth, so it seems to be a problem with the core stack.
>>
>> A quick reproducer:
>>
>> #!/bin/bash
>> #
>> # make sure ip is from top of tree iproute2
>>
>> ip netns add peer
>> ip li add eth0 type veth peer eth1
>> ip li set eth0 mtu 3400 up
>> ip addr add dev eth0 172.16.253.1/24
>> ip addr add dev eth0 2001:db8:1::1/64
>>
>> ip li set eth1 netns peer mtu 3400 up
>> ip -netns peer addr add dev eth1 172.16.253.2/24
>> ip -netns peer addr add dev eth1 2001:db8:1::2/64
>>
>> ip netns exec peer iperf3 -s -D
>>
>> ip li set dev eth0 gso_ipv4_max_size $((510*1024)) gro_ipv4_max_size
>> $((510*1024)) gso_max_size $((510*1024)) gro_max_size  $((510*1024))
>>
>> ip -netns peer li set dev eth1 gso_ipv4_max_size $((510*1024))
>> gro_ipv4_max_size  $((510*1024)) gso_max_size $((510*1024)) gro_max_size
>>  $((510*1024))
>>
>> sysctl -w vm.nr_hugepages=2
>>
>> cat <<EOF
>> Run either:
>>
>>     iperf3 -c 172.16.253.2 --zc_api
>>     iperf3 -c 2001:db8:1::2 --zc_api
>>
>> where iperf3 is from https://github.com/dsahern/iperf mods-3.10
>> EOF
>>
>> iperf3 in my tree has support for buffers using hugepages when using the
>> Tx ZC API (--zc_api arg above).
>>
>> I have seen various backtraces based on platform and configuration, but
>> skb_release_data is typically in the path. This is a common one for the
>> veth reproducer above (saw it with both v4 and v6):
>>
>> [   32.167294] general protection fault, probably for non-canonical
>> address 0xdd8672069ea377b2: 0000 [#1] PREEMPT SMP
>> [   32.167569] CPU: 5 PID: 635 Comm: iperf3 Not tainted 6.3.0+ #4
>> [   32.167742] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
>> 1.13.0-1ubuntu1.1 04/01/2014
>> [   32.168039] RIP: 0010:skb_release_data+0xf4/0x180
>> [   32.168208] Code: 7e 57 48 89 d8 48 c1 e0 04 4d 8b 64 05 30 41 f6 c4
>> 01 75 e1 41 80 7e 76 00 4d 89 e7 79 0c 4c 89 e7 e8 90 f
>> [   32.168869] RSP: 0018:ffffc900001a4eb0 EFLAGS: 00010202
>> [   32.169025] RAX: 00000000000001c0 RBX: 000000000000001c RCX:
>> 0000000000000000
>> [   32.169265] RDX: 0000000000000102 RSI: 000000000000068f RDI:
>> 00000000ffffffff
>> [   32.169475] RBP: ffffc900001a4ee0 R08: 0000000000000000 R09:
>> ffff88807fd77ec0
>> [   32.169708] R10: ffffea0000173430 R11: 0000000000000000 R12:
>> dd8672069ea377aa
>> [   32.169915] R13: ffff8880069cf100 R14: ffff888011910ae0 R15:
>> dd8672069ea377aa
>> [   32.170126] FS:  0000000001720880(0000) GS:ffff88807fd40000(0000)
>> knlGS:0000000000000000
>> [   32.170398] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [   32.170586] CR2: 00007f0f04400000 CR3: 0000000004caa000 CR4:
>> 0000000000750ee0
>> [   32.170796] PKRU: 55555554
>> [   32.170888] Call Trace:
>> [   32.170975]  <IRQ>
>> [   32.171039]  skb_release_all+0x2e/0x40
>> [   32.171152]  napi_consume_skb+0x62/0xf0
>> [   32.171281]  net_rx_action+0xf6/0x250
>> [   32.171394]  __do_softirq+0xdf/0x2c0
>> [   32.171506]  do_softirq+0x81/0xa0
>> [   32.171608]  </IRQ>
>>
>>
>> Xin came up with this patch a couple of months ago that resolves the
>> panic but it has a big impact on performance:
>>
>> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
>> index 0fbd5c85155f..6c2c8d09fd89 100644
>> --- a/net/core/skbuff.c
>> +++ b/net/core/skbuff.c
>> @@ -1717,7 +1717,7 @@ int skb_copy_ubufs(struct sk_buff *skb, gfp_t
>> gfp_mask)
>>  {
>>         int num_frags = skb_shinfo(skb)->nr_frags;
>>         struct page *page, *head = NULL;
>> -       int i, new_frags;
>> +       int i, new_frags, pagelen;
>>         u32 d_off;
>>
>>         if (skb_shared(skb) || skb_unclone(skb, gfp_mask))
>> @@ -1733,7 +1733,16 @@ int skb_copy_ubufs(struct sk_buff *skb, gfp_t
>> gfp_mask)
>>                 return 0;
>>         }
>>
>> -       new_frags = (__skb_pagelen(skb) + PAGE_SIZE - 1) >> PAGE_SHIFT;
>> +       pagelen = __skb_pagelen(skb);
>> +       if (pagelen > GSO_LEGACY_MAX_SIZE) {
>> +               /* without hugepages, skb frags can only hold 65536 data. */
> 
> This is with CONFIG_MAX_SKB_FRAGS 17 I suppose.

correct, I did not enable that config so it defaults to 17.

> 
> So is the issue just that new_frags ends up indexing out of bounds
> in frags[MAX_SKB_FRAGS]?

yes, I see nr_frags at 32 which is clearly way out of bounds and it
seems to be the skb_copy_ubufs function causing it.

> 
> GSO_LEGACY_MAX_SIZE happens to match the value, but is not not the
> right constant, as that is a max on the packet length, regardless
> of whether in linear or frags.
> 
>> +               if (!__pskb_pull_tail(skb, pagelen - GSO_LEGACY_MAX_SIZE))
>> +                       return -ENOMEM;
>> +               pagelen = GSO_LEGACY_MAX_SIZE;
>> +               num_frags = skb_shinfo(skb)->nr_frags;
>> +       }
>> +       new_frags = (pagelen + PAGE_SIZE - 1) >> PAGE_SHIFT;
>> +
>>         for (i = 0; i < new_frags; i++) {
>>                 page = alloc_page(gfp_mask);
>>                 if (!page) {
>>
> 
> 

