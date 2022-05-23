Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2E79530DC5
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 12:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232848AbiEWJU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 05:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232809AbiEWJUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 05:20:25 -0400
Received: from mail-m971.mail.163.com (mail-m971.mail.163.com [123.126.97.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D780B47AD6;
        Mon, 23 May 2022 02:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Subject:From:Message-ID:Date:MIME-Version; bh=DfpMD
        NIunylm+rjN/TUiOOVJaGR7kUA+OeyQ8YTd3dY=; b=ETNY6Hp1JC8fchYTyT4T3
        jwtUjkidtGBc2rT125FQpZDBjSpIPANl6S3jIWAWiSyCce/TCnTtT1+yYKX5IL/+
        NpeX0Umvke1EnQVKSyyIa6RkjFT6OelA4EN1HLMBOnkN5o2ai9GdexFLkA5caYWd
        1D4q4zXCpqdDmyTIbnLwXY=
Received: from [172.20.109.18] (unknown [116.128.244.169])
        by smtp1 (Coremail) with SMTP id GdxpCgDnyoutUYti9ehRDw--.1119S2;
        Mon, 23 May 2022 17:20:08 +0800 (CST)
Subject: Re: [PATCH] selftests/net: enable lo.accept_local in psock_snd test
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
References: <20220520063835.866445-1-luyun_611@163.com>
 <CA+FuTSdoZeAncRVAYrb66Kp6bEueWrgyy7A8qP0kmr9pxfHMoA@mail.gmail.com>
From:   Yun Lu <luyun_611@163.com>
Message-ID: <3f494c7a-6648-a696-b215-f597e680c5d9@163.com>
Date:   Mon, 23 May 2022 17:19:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CA+FuTSdoZeAncRVAYrb66Kp6bEueWrgyy7A8qP0kmr9pxfHMoA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CM-TRANSID: GdxpCgDnyoutUYti9ehRDw--.1119S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7tr45ur48AF48tF13Ar15CFg_yoW8GF48pr
        Z8Zry5Kas5J3Wjvw1ayF40vry7Xw1UCr4rtw1Ivws2ya1DuFs0kr1I9a90va1jqry7Xw4I
        vFWkZ3WUK3srZaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zi_MarUUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: pox130jbwriqqrwthudrp/1tbiQwcKzlc7ZlI9iAAAst
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/5/20 下午9:52, Willem de Bruijn wrote:

> On Fri, May 20, 2022 at 2:40 AM Yun Lu <luyun_611@163.com> wrote:
>> From: luyun <luyun@kylinos.cn>
>>
>> The psock_snd test sends and recievs packets over loopback, but the
>> parameter lo.accept_local is disabled by default, this test will
>> fail with Resource temporarily unavailable:
>> sudo ./psock_snd.sh
>> dgram
>> tx: 128
>> rx: 142
>> ./psock_snd: recv: Resource temporarily unavailable
> I cannot reproduce this failure.
>
> Passes on a machine with accept_local 0.
>
> accept_local is defined as
>
> "
> accept_local - BOOLEAN
>      Accept packets with local source addresses. In combination
>      with suitable routing, this can be used to direct packets
>      between two local interfaces over the wire and have them
>      accepted properly.
> "
I did this test on my system(Centos 8.3 X86_64):

[root@localhost net]# sysctl net.ipv4.conf.lo.accept_local
net.ipv4.conf.lo.accept_local = 0
[root@localhost net]# ./psock_snd -d
tx: 128
rx: 142
./psock_snd: recv: Resource temporarily unavailable
[root@localhost net]# sysctl -w net.ipv4.conf.lo.accept_local=1
net.ipv4.conf.lo.accept_local = 1
[root@localhost net]# ./psock_snd -d
tx: 128
rx: 142
rx: 100
OK

This failure does seem to be related to accept_local.

Also, it's reported on Ubuntu:
https://bugs.launchpad.net/ubuntu-kernel-tests/+bug/1812618

