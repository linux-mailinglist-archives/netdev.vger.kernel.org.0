Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82BBE5F531B
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 13:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229874AbiJELEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 07:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbiJELEB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 07:04:01 -0400
X-Greylist: delayed 61480 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 05 Oct 2022 04:03:51 PDT
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5B5877EA5;
        Wed,  5 Oct 2022 04:03:51 -0700 (PDT)
Received: from [IPV6:2003:e9:d724:a710:a294:cd8d:ff93:7c57] (p200300e9d724a710a294cd8dff937c57.dip0.t-ipconnect.de [IPv6:2003:e9:d724:a710:a294:cd8d:ff93:7c57])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id C4875C034C;
        Wed,  5 Oct 2022 13:03:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1664967829;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=67gn0Edl0Q7/1KNulPI/FvMfgfPE5WqQrUVHDSvVmOs=;
        b=ELnnhAoU5wfILYXoYmBSHYGBUEFOcOZbGEZ9GWMd1KuuBHs+Im1zztAKoeFlvJNz5bz0Go
        21tx9VPKLb1rAtLAu+sJd8Brnf6Mc1J3OmO2cgUmDXWnVsB9xSD0a1yUaGf4/sf0IfJdhn
        oFmF7n/qkFI84KlGnGFN2G+dy5Sf1pllucn4mXaJaBi8ag+akr8ObY3cevPIARXfeELcWn
        m+mO9kFDtr86RK/nftslHDeT7O5rq8jjCfByPGgB3q5jQ7ySbKO2zJLxPtTSbE2thKEL3C
        AOUZv/QAQ5KO7jxyqFjbeaTCXmQyxO5a0PTZZxj/amNudZTqmO1NFjt3lMr4Zw==
Message-ID: <5a3e81ce-32b4-c610-64e6-6fef62ac9913@datenfreihafen.org>
Date:   Wed, 5 Oct 2022 13:03:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH] net/ieee802154: reject zero-sized raw_sendmsg()
Content-Language: en-US
To:     Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        patchwork-bot+netdevbpf@kernel.org,
        "David S. Miller" <davem@davemloft.net>
Cc:     alex.aring@gmail.com, shaozhengchao@huawei.com, ast@kernel.org,
        sdf@google.com, linux-wpan@vger.kernel.org,
        syzbot+5ea725c25d06fb9114c4@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
References: <5e89b653-3fc6-25c5-324b-1b15909c0183@I-love.SAKURA.ne.jp>
 <166480021535.14393.17575492399292423045.git-patchwork-notify@kernel.org>
 <4aae5e2b-f4d5-c260-5bf8-435c525f6c97@I-love.SAKURA.ne.jp>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <4aae5e2b-f4d5-c260-5bf8-435c525f6c97@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Tetsuo.

On 03.10.22 14:34, Tetsuo Handa wrote:
> On 2022/10/03 21:30, patchwork-bot+netdevbpf@kernel.org wrote:
>> Hello:
>>
>> This patch was applied to netdev/net.git (master)
>> by David S. Miller <davem@davemloft.net>:
>>
>> On Sun, 2 Oct 2022 01:43:44 +0900 you wrote:
>>> syzbot is hitting skb_assert_len() warning at raw_sendmsg() for ieee802154
>>> socket. What commit dc633700f00f726e ("net/af_packet: check len when
>>> min_header_len equals to 0") does also applies to ieee802154 socket.
>>>
>>> Link: https://syzkaller.appspot.com/bug?extid=5ea725c25d06fb9114c4
>>> Reported-by: syzbot <syzbot+5ea725c25d06fb9114c4@syzkaller.appspotmail.com>
>>> Fixes: fd1894224407c484 ("bpf: Don't redirect packets with invalid pkt_len")
>>> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>>>
>>> [...]
>>
>> Here is the summary with links:
>>    - net/ieee802154: reject zero-sized raw_sendmsg()
>>      https://git.kernel.org/netdev/net/c/3a4d061c699b
> 
> 
> Are you sure that returning -EINVAL is OK?
> 
> In v2 patch, I changed to return 0, for PF_IEEE802154 socket's zero-sized
> raw_sendmsg() request was able to return 0.
> 

I pulled in the revert from Alex and your v2 patch into my wpan tree 
now. It will go to net from there.

regards
Stefan Schmidt
