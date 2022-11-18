Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D6D362F5CE
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 14:19:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235387AbiKRNTR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 08:19:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233543AbiKRNTP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 08:19:15 -0500
Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2EB43E098
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 05:19:12 -0800 (PST)
Received: from fsav311.sakura.ne.jp (fsav311.sakura.ne.jp [153.120.85.142])
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 2AIDJAFY032072;
        Fri, 18 Nov 2022 22:19:10 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from www262.sakura.ne.jp (202.181.97.72)
 by fsav311.sakura.ne.jp (F-Secure/fsigk_smtp/550/fsav311.sakura.ne.jp);
 Fri, 18 Nov 2022 22:19:10 +0900 (JST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/fsav311.sakura.ne.jp)
Received: from [192.168.1.9] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
        (authenticated bits=0)
        by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 2AIDJAQu032069
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 18 Nov 2022 22:19:10 +0900 (JST)
        (envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <32329c44-1dd6-9ded-3165-811a4e7e0a66@I-love.SAKURA.ne.jp>
Date:   Fri, 18 Nov 2022 22:19:10 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 6.1-rc6] l2tp: call udp_tunnel_encap_enable() and
 sock_release() without sk_callback_lock
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Tom Parkin <tparkin@katalix.com>,
        syzbot <syzbot+703d9e154b3b58277261@syzkaller.appspotmail.com>,
        netdev@vger.kernel.org, syzkaller-bugs@googlegroups.com,
        Haowei Yan <g1042620637@gmail.com>
References: <0000000000004e78ec05eda79749@google.com>
 <00000000000011ec5105edb50386@google.com>
 <c64284f4-2c2a-ecb9-a08e-9e49d49c720b@I-love.SAKURA.ne.jp>
 <CANn89iJq0v5=M7OTPE8WGZ4bNiYzO-KW3E8SRHOzf_q9nHPZEw@mail.gmail.com>
From:   Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <CANn89iJq0v5=M7OTPE8WGZ4bNiYzO-KW3E8SRHOzf_q9nHPZEw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022/11/18 21:36, Eric Dumazet wrote:
> Please look at recent discussion, your patch does not address another
> fundamental problem.
> 
> Also, Jakub was working on a fix already. Perhaps sync with him to
> avoid duplicate work.

I can't afford monitoring all mailing lists. Since a thread at syzkaller-bugs group
did not get that information, I started this work. Please consider including
syzbot+XXXXXXXXXXXXXXXXXXXX@syzkaller.appspotmail.com into the discussions so that
we can google for recent discussions (if any) using mail address as a keyword.

> 
> https://lore.kernel.org/netdev/20221114191619.124659-1-jakub@cloudflare.com/T/
> 
> Thanks.

