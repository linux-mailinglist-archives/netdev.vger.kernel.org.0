Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0C825F490E
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 20:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229526AbiJDSJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 14:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiJDSJE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 14:09:04 -0400
X-Greylist: delayed 593 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 04 Oct 2022 11:09:02 PDT
Received: from proxima.lasnet.de (proxima.lasnet.de [78.47.171.185])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EAE053D3F;
        Tue,  4 Oct 2022 11:09:02 -0700 (PDT)
Received: from [IPV6:2003:e9:d724:a710:a294:cd8d:ff93:7c57] (p200300e9d724a710a294cd8dff937c57.dip0.t-ipconnect.de [IPv6:2003:e9:d724:a710:a294:cd8d:ff93:7c57])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id C78CEC025B;
        Tue,  4 Oct 2022 19:59:05 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1664906346;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=wcQMljzpOOiSlN6HV+EDTFylwRneGnH0ZIB/FLIMNIU=;
        b=wtsmL4wq9w1ltQUAsLgeYQAz3E+qfsChB9tQ3cAxw9jZ+mWQJBgJk87KbtRX1bJ3pWo1EH
        jdLZYLfg0uzKFwPlHeNrRAYYNwKD0JSleavzEuULYd2AnigWFCfVq1+3GYtF2Tw0Xz0ARv
        kasuCWiyQ2twKaFcXDtigbkqNnRiq1e2sOLtWX8UWUIZR8Bte7sdEXTIp3ESsCnMpd8bvf
        1h6yJdxC/6/9DH4KX8sYEnDmtfQypGiZi8EYjkCPYX3UD23LVs9kSowng3hF2Zw5+sCwMj
        DCrJiaanoqeV/s9GdW2EJfTyckYcHVRPST6BFjqeu+65lgIHdnQAZ0OkY2bPNw==
Message-ID: <1c374e71-f56e-540e-35d0-e6e82a4dc0e3@datenfreihafen.org>
Date:   Tue, 4 Oct 2022 19:59:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH] net/ieee802154: reject zero-sized raw_sendmsg()
Content-Language: en-US
To:     Alexander Aring <aahringo@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     patchwork-bot+netdevbpf@kernel.org,
        "David S. Miller" <davem@davemloft.net>, alex.aring@gmail.com,
        shaozhengchao@huawei.com, ast@kernel.org, sdf@google.com,
        linux-wpan@vger.kernel.org,
        syzbot+5ea725c25d06fb9114c4@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
References: <5e89b653-3fc6-25c5-324b-1b15909c0183@I-love.SAKURA.ne.jp>
 <166480021535.14393.17575492399292423045.git-patchwork-notify@kernel.org>
 <4aae5e2b-f4d5-c260-5bf8-435c525f6c97@I-love.SAKURA.ne.jp>
 <CAK-6q+g7JQZkRJhp6qv_H9xGfD4DWnaChmQ7OaWJs3CAjfMnpA@mail.gmail.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <CAK-6q+g7JQZkRJhp6qv_H9xGfD4DWnaChmQ7OaWJs3CAjfMnpA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.

On 04.10.22 00:29, Alexander Aring wrote:
> Hi,
> 
> On Mon, Oct 3, 2022 at 8:35 AM Tetsuo Handa
> <penguin-kernel@i-love.sakura.ne.jp> wrote:
>>
>> On 2022/10/03 21:30, patchwork-bot+netdevbpf@kernel.org wrote:
>>> Hello:
>>>
>>> This patch was applied to netdev/net.git (master)
>>> by David S. Miller <davem@davemloft.net>:
>>>
>>> On Sun, 2 Oct 2022 01:43:44 +0900 you wrote:
>>>> syzbot is hitting skb_assert_len() warning at raw_sendmsg() for ieee802154
>>>> socket. What commit dc633700f00f726e ("net/af_packet: check len when
>>>> min_header_len equals to 0") does also applies to ieee802154 socket.
>>>>
>>>> Link: https://syzkaller.appspot.com/bug?extid=5ea725c25d06fb9114c4
>>>> Reported-by: syzbot <syzbot+5ea725c25d06fb9114c4@syzkaller.appspotmail.com>
>>>> Fixes: fd1894224407c484 ("bpf: Don't redirect packets with invalid pkt_len")
>>>> Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
>>>>
>>>> [...]
>>>
>>> Here is the summary with links:
>>>    - net/ieee802154: reject zero-sized raw_sendmsg()
>>>      https://git.kernel.org/netdev/net/c/3a4d061c699b
>>
>>
>> Are you sure that returning -EINVAL is OK?
>>
>> In v2 patch, I changed to return 0, for PF_IEEE802154 socket's zero-sized
>> raw_sendmsg() request was able to return 0.
> 
> I currently try to get access to kernel.org wpan repositories and try
> to rebase/apply your v2 on it. 

This will only work once I merged net into wpan. Which I normally do 
only after a pull request to avoid merge requests being created.

We have two options here a) reverting this patch and applying v2 of it 
b) Tetsu sending an incremental patch on top of the applied one to come 
to the same state as after v2.


Then it should be fixed in the next
> pull request to net. For netdev maintainers, please don't apply wpan
> patches. Stefan and I will care about it.

Keep in mind that Dave and Jakub do this to help us out because we are 
sometimes slow on applying patches and getting them to net. Normally 
this is all fine for clear fixes.

For -next material I agree this should only go through the wpan-next 
tree for us to coordinate, but for the occasional fix its often faster 
if it hits net directly. Normally I don't mind that. In this case v2 was 
overlooked. But this is easily rectified with either of the two options 
mentioned above.

regards
Stefan Schmidt
