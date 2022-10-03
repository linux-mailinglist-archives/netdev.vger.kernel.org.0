Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5A055F305B
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 14:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229469AbiJCMey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 08:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiJCMew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 08:34:52 -0400
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7993010566
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 05:34:47 -0700 (PDT)
Received: from fsav311.sakura.ne.jp (fsav311.sakura.ne.jp [153.120.85.142])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 293CYikV093637;
        Mon, 3 Oct 2022 21:34:44 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav311.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav311.sakura.ne.jp);
 Mon, 03 Oct 2022 21:34:44 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav311.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 293CYiqb093633
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 3 Oct 2022 21:34:44 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <4aae5e2b-f4d5-c260-5bf8-435c525f6c97@I-love.SAKURA.ne.jp>
Date:   Mon, 3 Oct 2022 21:34:43 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH] net/ieee802154: reject zero-sized raw_sendmsg()
Content-Language: en-US
To:     patchwork-bot+netdevbpf@kernel.org,
        "David S. Miller" <davem@davemloft.net>
Cc:     alex.aring@gmail.com, stefan@datenfreihafen.org,
        shaozhengchao@huawei.com, ast@kernel.org, sdf@google.com,
        linux-wpan@vger.kernel.org,
        syzbot+5ea725c25d06fb9114c4@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
References: <5e89b653-3fc6-25c5-324b-1b15909c0183@I-love.SAKURA.ne.jp>
 <166480021535.14393.17575492399292423045.git-patchwork-notify@kernel.org>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <166480021535.14393.17575492399292423045.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/10/03 21:30, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This patch was applied to netdev/net.git (master)
> by David S. Miller <davem@davemloft.net>:
> 
> On Sun, 2 Oct 2022 01:43:44 +0900 you wrote:
>> syzbot is hitting skb_assert_len() warning at raw_sendmsg() for ieee802154
>> socket. What commit dc633700f00f726e ("net/af_packet: check len when
>> min_header_len equals to 0") does also applies to ieee802154 socket.
>>
>> Link: https://syzkaller.appspot.com/bug?extid=5ea725c25d06fb9114c4
>> Reported-by: syzbot <syzbot+5ea725c25d06fb9114c4@syzkaller.appspotmail.com>
>> Fixes: fd1894224407c484 ("bpf: Don't redirect packets with invalid pkt_len")
>> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>>
>> [...]
> 
> Here is the summary with links:
>   - net/ieee802154: reject zero-sized raw_sendmsg()
>     https://git.kernel.org/netdev/net/c/3a4d061c699b


Are you sure that returning -EINVAL is OK?

In v2 patch, I changed to return 0, for PF_IEEE802154 socket's zero-sized
raw_sendmsg() request was able to return 0.

> 
> You are awesome, thank you!

