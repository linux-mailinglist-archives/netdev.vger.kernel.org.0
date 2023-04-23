Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 639156EBF27
	for <lists+netdev@lfdr.de>; Sun, 23 Apr 2023 13:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbjDWLlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 07:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjDWLla (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 07:41:30 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AEAF10D8;
        Sun, 23 Apr 2023 04:41:28 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id ffacd0b85a97d-2f6401ce8f8so1984305f8f.3;
        Sun, 23 Apr 2023 04:41:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682250087; x=1684842087;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kpS45IYQE4yTiEppNYA/ViNM2eZOtP6RpIfPQh7BvVQ=;
        b=h5GQ6ED1qo7quwyDOldE9/IYcHQfVDcsz5AX9Kq/35//2zfaikcSRwLWvZtA/g1/Rx
         +EMKLlcTTlBIU8NFj3DcR+XtvkE32209IlrAeDxwXPswINQWZ/QJjbYzfzJeFTAyMby7
         p4uco9UZRjmzwrskjR2pmFPEAYFQetT76/J7toweeWI+yskg1a9ffwGeCaCaXBSK1Bsc
         +fqtdxmq5681v5Uaq2q+w02cPxfGshT4+dNP5Ie0LV+13TGEDErOqamHSCo29mKn5GAl
         5760+8fh60mtQLom8A9kTBAHc/SyhNU7TLGKBty6Mk5p3Zof9i2n0XG26sI3q2cyBODd
         3TXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682250087; x=1684842087;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kpS45IYQE4yTiEppNYA/ViNM2eZOtP6RpIfPQh7BvVQ=;
        b=DkHfx3EVUzoI+n7pBI0eoov/8VUhE0b1vUgZOuRm7YOjq2+flv8yvHbs0VGVNuh/0y
         GPYrAB9jgTejFYdq/98WK3iVkqpbcAYsrjF47YwX0tAA0mzhCG8JrYp3bZLO1rBqjRAy
         iV026vuqFNafPde36W/jporn5pKxhG/UyBn7A5jZ+XhND3ETkG1m0icCObPtgegP3aBF
         TSVrZHGnA4k+oo/9aw0aaOHpeOyaSTdmq3wfbVWzdyhujaignv9WowLYDFS3TmiMNapA
         z9TgTkgBV9ibzKJzF6kxxNUmJW2+EeSQ9fD1/sn0mUAbS9fY479SqeGS1zcw8WTeazYb
         wOfQ==
X-Gm-Message-State: AAQBX9f0gbsQxt4jd4IwCLzkM+a8fKisWeCatw1+QoKyK10T8C5/a0/Z
        mnLo2v0Ri5MPs541jSlecek=
X-Google-Smtp-Source: AKy350aIlb+c7V0wHfcNLQc8C2fqbuo7uG0MxTk/DFunQiamw8jtQ/5vfj49gjbqDZbmKHGDqEBp7Q==
X-Received: by 2002:a5d:5307:0:b0:2fe:6b1e:3818 with SMTP id e7-20020a5d5307000000b002fe6b1e3818mr7692501wrv.51.1682250086693;
        Sun, 23 Apr 2023 04:41:26 -0700 (PDT)
Received: from [192.168.0.157] ([46.120.112.185])
        by smtp.gmail.com with ESMTPSA id e5-20020a5d5005000000b0030469635629sm3486346wrt.62.2023.04.23.04.41.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Apr 2023 04:41:25 -0700 (PDT)
Message-ID: <2ebf97ba-1bd2-3286-7feb-d2e7f4c95383@gmail.com>
Date:   Sun, 23 Apr 2023 14:41:22 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH bpf,v2 0/4] Socket lookup BPF API from tc/xdp ingress does
 not respect VRF bindings.
Content-Language: en-US
To:     Stanislav Fomichev <sdf@google.com>
Cc:     dsahern@kernel.org, martin.lau@linux.dev, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, kpsingh@kernel.org, haoluo@google.com,
        jolsa@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mykolal@fb.com,
        shuah@kernel.org, hawk@kernel.org, joe@wand.net.nz,
        eyal.birger@gmail.com, shmulik.ladkani@gmail.com,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
References: <20230420145041.508434-1-gilad9366@gmail.com>
 <ZEFrcoG+QS/PRbew@google.com>
From:   Gilad Sever <gilad9366@gmail.com>
In-Reply-To: <ZEFrcoG+QS/PRbew@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 20/04/2023 19:42, Stanislav Fomichev wrote:
> On 04/20, Gilad Sever wrote:
>> When calling socket lookup from L2 (tc, xdp), VRF boundaries aren't
>> respected. This patchset fixes this by regarding the incoming device's
>> VRF attachment when performing the socket lookups from tc/xdp.
>>
>> The first two patches are coding changes which facilitate this fix by
>> factoring out the tc helper's logic which was shared with cg/sk_skb
>> (which operate correctly).
> Why is not relevant for cgroup/egress? Is it already running with
> the correct device?
Yes.
>
> Also, do we really need all this refactoring and separate paths?
> Can we just add that bpf_l2_sdif part to the existing code?
> It will trigger for tc, but I'm assuming it will be a no-op for cgroup
> path?
The reason we preferred the refactoring is to avoid triggering `inet_sdif()`
from tc/xdp. This is because in our understanding, the IPCB is undefined 
before
IP processing so it seems incorrect to use `inet_sdif()` from tc/xdp.

We did come up with a different option which could spare most of the 
refactoring
and still partially separate the two paths:

Pass sdif to __bpf_skc_lookup() but instead of using different functions
for tc, calculate sdif by calling `dev_sdif()` in bpf_skc_lookup() only when
netif_is_l3_master() is false. In other words:

- xdp callers would check the device's l3 enslaved state using the new 
`dev_sdif()`
- sock_addr callers would use inet{,6}_sdif() as they did before
- cg/tc share the same code path, so when netif_is_l3_master() is true
   use inet{,6}_sdif() and when it is false use dev_sdif(). this relies 
on the following
   assumptions:
   - tc programs don't run on l3 master devices
   - cgroup callers never see l3 enslaved devices
   - inet{,6}_sdif() isn't relevant for non l3 master devices

In our opinion, it's safer to factor out the tc flow as in the patchset, 
similar to XDP
which has its own functions.

What do you think?
> And regarding bpf_l2_sdif: seems like it's really generic and should
> probably be called something like dev_sdif?
Agreed. I'll rename in the next patch.
>
>> The third patch contains the actual bugfix.
>>
>> The fourth patch adds bpf tests for these lookup functions.
>> ---
>> v2: Fixed uninitialized var in test patch (4).
>>
>> Gilad Sever (4):
>>    bpf: factor out socket lookup functions for the TC hookpoint.
>>    bpf: Call __bpf_sk_lookup()/__bpf_skc_lookup() directly via TC
>>      hookpoint
>>    bpf: fix bpf socket lookup from tc/xdp to respect socket VRF bindings
>>    selftests/bpf: Add tc_socket_lookup tests
>>
>>   net/core/filter.c                             | 132 +++++--
>>   .../bpf/prog_tests/tc_socket_lookup.c         | 341 ++++++++++++++++++
>>   .../selftests/bpf/progs/tc_socket_lookup.c    |  73 ++++
>>   3 files changed, 525 insertions(+), 21 deletions(-)
>>   create mode 100644 tools/testing/selftests/bpf/prog_tests/tc_socket_lookup.c
>>   create mode 100644 tools/testing/selftests/bpf/progs/tc_socket_lookup.c
>>
>> -- 
>> 2.34.1
>>
