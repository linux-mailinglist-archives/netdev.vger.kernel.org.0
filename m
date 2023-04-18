Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11DEF6E573F
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 04:01:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbjDRCAh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 22:00:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230315AbjDRCAg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 22:00:36 -0400
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9624B46B9;
        Mon, 17 Apr 2023 19:00:32 -0700 (PDT)
Received: from kwepemi500015.china.huawei.com (unknown [7.221.188.92])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Q0nCS6K3jzsR9g;
        Tue, 18 Apr 2023 09:59:00 +0800 (CST)
Received: from [10.174.178.171] (10.174.178.171) by
 kwepemi500015.china.huawei.com (7.221.188.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 18 Apr 2023 09:59:58 +0800
Subject: =?UTF-8?B?UmU6IOetlOWkjTogW1BBVENIIG5ldF0gbmV0OiBBZGQgY2hlY2sgZm9y?=
 =?UTF-8?Q?_csum=5fstart_in_skb=5fpartial=5fcsum=5fset=28=29?=
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Eric Dumazet <edumazet@google.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "imagedong@tencent.com" <imagedong@tencent.com>,
        "brouer@redhat.com" <brouer@redhat.com>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "jbenc@redhat.com" <jbenc@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20230410022152.4049060-1-luwei32@huawei.com>
 <CANn89iKFLREJV_cfHEk6wz6xXVv_jSrZ_UyXAB8VpH7gMXacxQ@mail.gmail.com>
 <643447ba5224a_83e69294b6@willemb.c.googlers.com.notmuch>
 <450994d7-4a77-99df-6317-b535ea73e01d@huawei.com>
 <CANn89iLOcvDRMi9kVr86xNp5=h4JWpx9yYWicVxCwSMgAJGf_g@mail.gmail.com>
 <c90abe8c-ffa0-f986-11eb-bde65c84d18b@huawei.com>
 <6436b5ba5c005_41e2294dd@willemb.c.googlers.com.notmuch>
 <a30a8ffaa8dd4cb6a84103eecf0c3338@huawei.com>
 <643983f69b440_17854f2948c@willemb.c.googlers.com.notmuch>
 <64398b4c4585f_17abe429442@willemb.c.googlers.com.notmuch>
 <47fca2c7-db7c-0265-d724-38dffc62debe@huawei.com>
 <643aab0f2f39c_1afa5d2943f@willemb.c.googlers.com.notmuch>
From:   "luwei (O)" <luwei32@huawei.com>
Message-ID: <0f1d25fa-0704-f3b0-cc33-d89a5f87daac@huawei.com>
Date:   Tue, 18 Apr 2023 09:59:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <643aab0f2f39c_1afa5d2943f@willemb.c.googlers.com.notmuch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.171]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 kwepemi500015.china.huawei.com (7.221.188.92)
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2023/4/15 9:47 PM, Willem de Bruijn 写道:
> luwei (O) wrote:
>> 在 2023/4/15 1:20 AM, Willem de Bruijn 写道:
>>> Willem de Bruijn wrote:
>>>> luwei (O) wrote:
>>>>> yes, here is the vnet_hdr:
>>>>>
>>>>>       flags: 3
>>>>>       gso_type: 3
>>>>>       hdr_len: 23
>>>>>       gso_size: 58452
>>>>>       csum_start: 5
>>>>>       csum_offset: 16
>>>>>
>>>>> and the packet:
>>>>>
>>>>> | vnet_hdr | mac header | network header | data ... |
>>>>>
>>>>>     memcpy((void*)0x20000200,
>>>>>            "\x03\x03\x02\x00\x54\xe4\x05\x00\x10\x00\x80\x00\x00\x53\xcc\x9c\x2b"
>>>>>            "\x19\x3b\x00\x00\x00\x89\x4f\x08\x03\x83\x81\x04",
>>>>>            29);
>>>>>     *(uint16_t*)0x200000c0 = 0x11;
>>>>>     *(uint16_t*)0x200000c2 = htobe16(0);
>>>>>     *(uint32_t*)0x200000c4 = r[3];
>>>>>     *(uint16_t*)0x200000c8 = 1;
>>>>>     *(uint8_t*)0x200000ca = 0;
>>>>>     *(uint8_t*)0x200000cb = 6;
>>>>>     memset((void*)0x200000cc, 170, 5);
>>>>>     *(uint8_t*)0x200000d1 = 0;
>>>>>     memset((void*)0x200000d2, 0, 2);
>>>>>     syscall(__NR_sendto, r[1], 0x20000200ul, 0xe45ful, 0ul, 0x200000c0ul, 0x14ul);
>>>> Thanks. So this can happen whenever a packet is injected into the tx
>>>> path with a virtio_net_hdr.
>>>>
>>>> Even if we add bounds checking for the link layer header in pf_packet,
>>>> it can still point to the network header.
>>>>
>>>> If packets are looped to the tx path, skb_pull is common if a packet
>>>> traverses tunnel devices. But csum_start does not directly matter in
>>>> the rx path (CHECKSUM_PARTIAL is just seen as CHECKSUM_UNNECESSARY).
>>>> Until it is forwarded again to the tx path.
>>>>
>>>> So the question is which code calls skb_checksum_start_offset on the
>>>> tx path. Clearly, skb_checksum_help. Also a lot of drivers. Which
>>>> may cast the signed int return value to an unsigned. Even an u8 in
>>>> the first driver I spotted (alx).
>>>>
>>>> skb_postpull_rcsum anticipates a negative return value, as do other
>>>> core functions. So it clearly allowed in certain cases. We cannot
>>>> just bound it.
>>>>
>>>> Summary after a long story: an initial investigation, but I don't have
>>>> a good solution so far. Maybe others have a good suggestiong based on
>>>> this added context.
>>> Specific to skb_checksum_help, it appears that skb_checksum will
>>> work with negative offset just fine.
>>         In this case maybe not, since it checksums from within the mac
>> header, and the mac header
>>
>>          will be stripped when the rx path checks the checksum.
> The header is pulled, but still present. Obviously something bogus gets
> written if the virtio_net_hdr configures csum offload with a bogus
> offset. But as long as the offset is zero or positive from skb->head,
> the checksum helper works as intended.

    OK, Thanks for your reply

>   
>>> Perhaps the only issue is that the WARN_ON_ONCE compares signed to
>>> unsigned, and thus incorrectly interprets a negative offset as
>>>    >= skb_headlen(skb)
> .

-- 
Best Regards,
Lu Wei

