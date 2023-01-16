Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8085C66C36E
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 16:17:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbjAPPR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 10:17:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232105AbjAPPQ6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 10:16:58 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E10623652
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 07:08:01 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id j1so5396143iob.6
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 07:08:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nRRd6135lmLLOqDPSrkBu4cafynzyYWoOTtIQj6AAt0=;
        b=WWu2cf1DfgDtBCzvDSkQ1rRM6L5SbgMsdBOvpwoYxh0x35LRd+ee2R9HoXpN2wLaFT
         aIBediRFoGhw7IIQh9S3NfL+YxothswCVxS0iuo4EIdoHpfz0lj2RqZFzvqDCtZHBa3J
         dOdhWTV88iWKRQI4+WqXiOUpDbldl+ecJKNm+Z1S2aM1WkY6I8QvdPK8/bmGDTA4XwRa
         SYNkAJryYTEg/QQpWGmSJVgshWVNJAIiPQjwoVnh/S9zAGTF2N0SFO7XTFuRwlAU0iVZ
         DBjfZmLdLggV4PqPUKHPqLnv4RQpybkszY6z7U1MXi3en5sD9DNnNDE1zMcLY8jBbKU8
         aKFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nRRd6135lmLLOqDPSrkBu4cafynzyYWoOTtIQj6AAt0=;
        b=ykybXnTfJhyVGUx9J7xNlY2WKoys3v9lxHtb+0gpcxmyIrAjOIdvcRnsB9SyQ83omg
         +jxsbqVqPh1JqMZVw12hMivMJgiJRcForNaMdZZwzCK8mUaui2tjqZPxc85JPJHvWRq/
         dZioa5eTMTq0e7b3H0aaTnSZ3V84PUH/ado+uC+tg/mBa/zCKIyZ6RLtSnKuQyAvUgCs
         9FmB6dux8C1hUC2AyUkWc6biRiN6eek6lLo2nfp2FMaVj2OjxV6FRCNbla+gx1wUQDCz
         h0ehDxKuchUPs5UEB5UN5TPQUYK3QDbI88SGUTYFj6cQHwez5XT9BwfLGivf15Ay76bi
         kCjw==
X-Gm-Message-State: AFqh2kra7yygV+WDOvGP6jnf/xZdZByIBqZNKjhgNY12di9r5zIHYtPt
        bmEKV65EKQY9N6Fh1MPSg80=
X-Google-Smtp-Source: AMrXdXt/8WKkLYUAebfbDtQ7HWuHSAxun+pzChXOMkKlyvy4Kj4ykfLNotqNRvtkWk2a9UpA4rwWBw==
X-Received: by 2002:a5d:9656:0:b0:6e3:1ced:b60e with SMTP id d22-20020a5d9656000000b006e31cedb60emr56477935ios.9.1673881680680;
        Mon, 16 Jan 2023 07:08:00 -0800 (PST)
Received: from ?IPV6:2601:284:8200:b700:7de9:438a:dc6b:e300? ([2601:284:8200:b700:7de9:438a:dc6b:e300])
        by smtp.googlemail.com with ESMTPSA id k1-20020a0566022d8100b006e4e8ad6b2bsm9745449iow.36.2023.01.16.07.07.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jan 2023 07:08:00 -0800 (PST)
Message-ID: <b73e2dd1-d7bc-e96b-8553-1536a1146f3c@gmail.com>
Date:   Mon, 16 Jan 2023 08:07:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 09/10] netfilter: get ipv6 pktlen properly in
 length_mt6
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>, Xin Long <lucien.xin@gmail.com>
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
 <CANn89iLtF3dNcMkMGagCSfb+p5zA3Fa-DV9f9xMHHU_TX2CvSw@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <CANn89iLtF3dNcMkMGagCSfb+p5zA3Fa-DV9f9xMHHU_TX2CvSw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/16/23 2:24 AM, Eric Dumazet wrote:
> On Sun, Jan 15, 2023 at 9:15 PM Xin Long <lucien.xin@gmail.com> wrote:
>>
>> On Sun, Jan 15, 2023 at 2:40 PM Eric Dumazet <edumazet@google.com> wrote:
>>>
>>> On Sun, Jan 15, 2023 at 6:43 PM Xin Long <lucien.xin@gmail.com> wrote:
>>>>
>>>> On Sun, Jan 15, 2023 at 10:41 AM David Ahern <dsahern@gmail.com> wrote:
>>>>>
>>>>> On 1/13/23 8:31 PM, Xin Long wrote:
>>>>>> For IPv6 jumbogram packets, the packet size is bigger than 65535,
>>>>>> it's not right to get it from payload_len and save it to an u16
>>>>>> variable.
>>>>>>
>>>>>> This patch only fixes it for IPv6 BIG TCP packets, so instead of
>>>>>> parsing IPV6_TLV_JUMBO exthdr, which is quite some work, it only
>>>>>> gets the pktlen via 'skb->len - skb_network_offset(skb)' when
>>>>>> skb_is_gso_v6() and saves it to an u32 variable, similar to IPv4
>>>>>> BIG TCP packets.
>>>>>>
>>>>>> This fix will also help us add selftest for IPv6 BIG TCP in the
>>>>>> following patch.
>>>>>>
>>>>>
>>>>> If this is a bug fix for the existing IPv6 support, send it outside of
>>>>> this set for -net.
>>>>>
>>>> Sure,
>>>> I was thinking of adding it here to be able to support selftest for
>>>> IPv6 too in the next patch. But it seems to make more sense to
>>>> get it into -net first, then add this selftest after it goes to net-next.
>>>>
>>>> I will post it and all other fixes I mentioned in the cover-letter for
>>>> IPv6 BIG TCP for -net.
>>>>
>>>> But before that, I hope Eric can confirm it is okay to read the length
>>>> of IPv6 BIG TCP packets with skb_ipv6_totlen() defined in this patch,
>>>> instead of parsing JUMBO exthdr?
>>>>
>>>
>>> I do not think it is ok, but I will leave the question to netfilter maintainers.
>> Just note that the issue doesn't only exist in netfilter.
>> All the changes in Patch 2-7 from this patchset are also needed for IPv6
>> BIG TCP packets.
>>
>>>
>>> Guessing things in tcpdump or other tools is up to user space implementations,
>>> trying to work around some (kernel ?) deficiencies.
>>>
>>> Yes, IPv6 extensions headers are a pain, we all agree.
>>>
>>> Look at how ip6_rcv_core() properly dissects extension headers _and_ trim
>>> skb accordingly (pskb_trim_rcsum() called either from ip6_rcv_core()
>>> or ipv6_hop_jumbo())
>>>
>>> So skb->len is not the root of trust. Some transport mediums might add paddings.
>>>
>>> Ipv4 has a similar logic in ip_rcv_core().
>>>
>>> len = ntohs(iph->tot_len);
>>> if (skb->len < len) {
>>>      drop_reason = SKB_DROP_REASON_PKT_TOO_SMALL;
>>>      __IP_INC_STATS(net, IPSTATS_MIB_INTRUNCATEDPKTS);
>>>     goto drop;
>>> } else if (len < (iph->ihl*4))
>>>      goto inhdr_error;
>>>
>>> /* Our transport medium may have padded the buffer out. Now we know it
>>> * is IP we can trim to the true length of the frame.
>>> * Note this now means skb->len holds ntohs(iph->tot_len).
>>> */
>>> if (pskb_trim_rcsum(skb, len)) {
>>>       __IP_INC_STATS(net, IPSTATS_MIB_INDISCARDS);
>>>       goto drop;
>>> }
>>>
>>> After your changes, we might accept illegal packets that were properly
>>> dropped before.
>> I think skb->len is trustable for GSO/GRO packets.
>> In ipv6_gro_complete/inet_gro_complete():
>> The new length for payload_len or iph->tot_len are all calculated from skb->len.
>> As I said in the cover-letter, "there is no padding in GSO/GRO packets".
>> Or am I missing something?
> 
> This seems to be a contract violation with user space providing GSO packets.
> 
> In our changes we added some sanity checks, inherent to JUMBO specs.
> 
> Here, a GSO packet can now have a zero ip length, no matter if it is
> BIG TCP or not.

Meaning your preference is to set tot_len anytime it is <= 64kB so the
only time tot_len == 0 is for large GRO/TSO packets? That is doable.

> 
> It seems we lower the bar for consistency, and allow bugs (say
> changing skb->len) to not be detected.

not sure why you think it would not be detected. Today's model for gro
sets tot_len based on skb->len. There is an inherent trust that the
user's of the gro API set the length correctly. If it is not, the
payload to userspace would ultimately be non-sense and hence detectable.
I tend to use ssh to test changes like this for this reason - L4 payload
must make sense.

For the Tx path, there is a similar line of trust that the skb->len
passed to the L3 layer is correct. IPv4/IPv6 blindly trust what it is
told for length.


> 
> As you said, user space sniffing packets now have to guess what is the
> intent, instead of headers carrying all the needed information
> that can be fully validated by parsers.

This is a solveable problem within the packet socket API, and the entire
thing is opt-in. If a user's tcpdump / packet capture program is out of
date and does not support the new API for large packets, then that user
does not have to enable large GRO/TSO.

