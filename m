Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7038F5F56C1
	for <lists+netdev@lfdr.de>; Wed,  5 Oct 2022 16:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbiJEOxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Oct 2022 10:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiJEOxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Oct 2022 10:53:06 -0400
Received: from proxima.lasnet.de (proxima.lasnet.de [IPv6:2a01:4f8:121:31eb:3::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1299F39BA3;
        Wed,  5 Oct 2022 07:53:05 -0700 (PDT)
Received: from [IPV6:2003:e9:d724:a76b:99bd:9507:55e0:d439] (p200300e9d724a76b99bd950755e0d439.dip0.t-ipconnect.de [IPv6:2003:e9:d724:a76b:99bd:9507:55e0:d439])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: stefan@datenfreihafen.org)
        by proxima.lasnet.de (Postfix) with ESMTPSA id BD0E5C034C;
        Wed,  5 Oct 2022 16:53:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=datenfreihafen.org;
        s=2021; t=1664981583;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pt0zhfgS5qs+aVmr37oKMneCBk+J0tB9uEZlqrTMhWc=;
        b=Woaw/7eIrWqKVPbcz+xtUjt1fnlyRBjU6qwXIupP+s+7Td6t/Fteu2oIjL3ozTQhGpn6JR
        peRiJuRXECOKRZOk8VTSsAyiUx1oExEiWRKHMQUEcZ9K6PG7IWLb0FrHI6W5XmA6EzsKo/
        QrCRQZX6Lkowgk2YellnWbSzE4rGHtbYeO8sRhsRFyRC0ByPKmIdfXHoc6rd1lu7YR6n5p
        iG0zcUyRK8MfMZ4xqdF/mbl4pL7deYmkkim/jCwW1WjtEDdt1puSiUJxSig7kfUXu0e01g
        NtYUv54tyjhGyDFlZW5jl+9ltL7Gc5oaAsteNB3ci+bAhL8I3GEFImD00cGfEA==
Message-ID: <5568f032-27f3-42c1-80b2-16b80bf55abd@datenfreihafen.org>
Date:   Wed, 5 Oct 2022 16:53:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH] net/ieee802154: reject zero-sized raw_sendmsg()
Content-Language: en-US
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        patchwork-bot+netdevbpf@kernel.org,
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
 <1c374e71-f56e-540e-35d0-e6e82a4dc0e3@datenfreihafen.org>
 <CAK-6q+iqPFxrM7qdmi4xcF8e+2mgqXT9otEwRA+Vh-JfRQ18Wg@mail.gmail.com>
From:   Stefan Schmidt <stefan@datenfreihafen.org>
In-Reply-To: <CAK-6q+iqPFxrM7qdmi4xcF8e+2mgqXT9otEwRA+Vh-JfRQ18Wg@mail.gmail.com>
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

Hello.

On 05.10.22 03:49, Alexander Aring wrote:
> Hi,
> 
> On Tue, Oct 4, 2022 at 1:59 PM Stefan Schmidt <stefan@datenfreihafen.org> wrote:
>>
>> Hello.
>>
>> On 04.10.22 00:29, Alexander Aring wrote:
>>> pull request to net. For netdev maintainers, please don't apply wpan
>>> patches. Stefan and I will care about it.
>>
>> Keep in mind that Dave and Jakub do this to help us out because we are
>> sometimes slow on applying patches and getting them to net. Normally
>> this is all fine for clear fixes.
>>
> 
> If we move getting patches for wpan to net then we should move it
> completely to that behaviour and not having a mixed setup which does
> not work, or it works and hope we don't have conflicts and if we have
> conflicts we need to fix them when doing the pull-request that the
> next instance has no conflicts because they touched maybe the same
> code area.

I do disagree on this. I think there is no need to have it fixed to one 
way or another (net OR wpan). It has been working fine with this mixed 
approach for quite a long time. The current issue with v1 being applied 
instead of v2 is something that could have happened to us when applying 
to wpan as easily.

If we are quick enough to ack/apply patches hitting the list (1-2 days) 
its unlikely any of them will be applied to net. Dave and Jakub simply 
help us to make sure nothing falls through the cracks.

> I think a) would be the fastest way here and I just sent something.

I applied the two patches earlier today and just send out a pull request 
for net with them.

regards
Stefan Schmidt
