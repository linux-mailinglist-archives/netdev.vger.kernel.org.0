Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1C353270A
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 12:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235971AbiEXKD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 06:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235997AbiEXKDy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 06:03:54 -0400
Received: from mail-m975.mail.163.com (mail-m975.mail.163.com [123.126.97.5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C685B793A6;
        Tue, 24 May 2022 03:03:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Subject:From:Message-ID:Date:MIME-Version; bh=Dk7Gm
        fvT3AqfomHwgr/tdhRny1W9IvrJG0afEovalW4=; b=Ua6Zk41Bz9pjD7Cc7WAJr
        /0thv7vEIfvI76vlTdRrrGgKPKh04Poxcl7Ww72lcW1ndO05Hvc5952fnV11JEGn
        O3Nn5jP/VXvT/Za6EfZHBqG7japajYkU0RocvNJqFcdQAnptXmIJwFGiegy11eU6
        4y8vTgUdmo7Tu2fTWZv6wQ=
Received: from [172.20.109.18] (unknown [116.128.244.169])
        by smtp5 (Coremail) with SMTP id HdxpCgAnp_54rYxiqUT3Dw--.11933S2;
        Tue, 24 May 2022 18:03:37 +0800 (CST)
Subject: Re: [PATCH] selftests/net: enable lo.accept_local in psock_snd test
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
References: <20220520063835.866445-1-luyun_611@163.com>
 <CA+FuTSdoZeAncRVAYrb66Kp6bEueWrgyy7A8qP0kmr9pxfHMoA@mail.gmail.com>
 <3f494c7a-6648-a696-b215-f597e680c5d9@163.com>
 <CA+FuTSdHCszjFtkZj37KE-1rfSfzYEd5oXLyKS6Kz9pdi05ReA@mail.gmail.com>
From:   Yun Lu <luyun_611@163.com>
Message-ID: <754c0cd5-2289-3887-e7d2-71ff87e59afd@163.com>
Date:   Tue, 24 May 2022 18:03:36 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CA+FuTSdHCszjFtkZj37KE-1rfSfzYEd5oXLyKS6Kz9pdi05ReA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID: HdxpCgAnp_54rYxiqUT3Dw--.11933S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxJF4xWF1ruFWfGr1kAw1DZFb_yoW5GrW3pr
        W7Xas0yF1kJa4jvwsIv3W8ury0qw4UCr4Fqw1Iywn2yFs8uFy3Cr4I9a909a1qqr1xW3y2
        vFWkZa47W34DZaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zETmh-UUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: pox130jbwriqqrwthudrp/1tbiQxwLzlc7ZnWomQAAsU
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/5/23 下午9:32, Willem de Bruijn wrote:

> On Mon, May 23, 2022 at 5:25 AM Yun Lu <luyun_611@163.com> wrote:
>> On 2022/5/20 下午9:52, Willem de Bruijn wrote:
>>
>>> On Fri, May 20, 2022 at 2:40 AM Yun Lu <luyun_611@163.com> wrote:
>>>> From: luyun <luyun@kylinos.cn>
>>>>
>>>> The psock_snd test sends and recievs packets over loopback, but the
>>>> parameter lo.accept_local is disabled by default, this test will
>>>> fail with Resource temporarily unavailable:
>>>> sudo ./psock_snd.sh
>>>> dgram
>>>> tx: 128
>>>> rx: 142
>>>> ./psock_snd: recv: Resource temporarily unavailable
>>> I cannot reproduce this failure.
>>>
>>> Passes on a machine with accept_local 0.
>>>
>>> accept_local is defined as
>>>
>>> "
>>> accept_local - BOOLEAN
>>>       Accept packets with local source addresses. In combination
>>>       with suitable routing, this can be used to direct packets
>>>       between two local interfaces over the wire and have them
>>>       accepted properly.
>>> "
>> I did this test on my system(Centos 8.3 X86_64):
>>
>> [root@localhost net]# sysctl net.ipv4.conf.lo.accept_local
>> net.ipv4.conf.lo.accept_local = 0
>> [root@localhost net]# ./psock_snd -d
>> tx: 128
>> rx: 142
>> ./psock_snd: recv: Resource temporarily unavailable
>> [root@localhost net]# sysctl -w net.ipv4.conf.lo.accept_local=1
>> net.ipv4.conf.lo.accept_local = 1
>> [root@localhost net]# ./psock_snd -d
>> tx: 128
>> rx: 142
>> rx: 100
>> OK
>>
>> This failure does seem to be related to accept_local.
>>
>> Also, it's reported on Ubuntu:
>> https://bugs.launchpad.net/ubuntu-kernel-tests/+bug/1812618
> That is an old kernel, 4.18 derived.
>
> I simply am unable to reproduce this on an upstream v4.18 or v5.18.
> Likely something with either the distro kernel release, or another
> distro feature that interacts with this. Can you try v5.18 or another
> clean upstream kernel?
>
> Else it requires instrumenting IN_DEV_ACCEPT_LOCAL tests to understand
> where this sysctl makes a meaningful change for you when running this
> test.

I found another parameter rp_filter which interacts with this test:

Set rp_filter = 0, the psock_snd test OK.

Or set rp_filter = 1 and accept_local=1, the psock_snd test OK.

I get the same test results on kernel v5.10 or v5.15.  Analysis from 
source code,  this two parameters

will change the result of fib_validate_source when running this test. 
For most distro kernel releases,

rp_filter is enabled by default, so this test will fail when 
accept_local is kept to be zero.


I am looking forward to your better advice on this problem.

