Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82D66640462
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 11:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233161AbiLBKSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 05:18:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232841AbiLBKSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 05:18:44 -0500
Received: from mail.nfschina.com (unknown [124.16.136.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C53788DBD0;
        Fri,  2 Dec 2022 02:18:42 -0800 (PST)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 9F8871E80D27;
        Fri,  2 Dec 2022 18:14:37 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 0MNc3Rl89av0; Fri,  2 Dec 2022 18:14:34 +0800 (CST)
Received: from [172.30.38.124] (unknown [180.167.10.98])
        (Authenticated sender: liqiong@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id 465691E80CCF;
        Fri,  2 Dec 2022 18:14:34 +0800 (CST)
Subject: Re: [PATCH] ipvs: initialize 'ret' variable in do_ip_vs_set_ctl()
To:     Dan Carpenter <error27@gmail.com>,
        Peilin Ye <yepeilin.cs@gmail.com>
Cc:     Simon Horman <horms@verge.net.au>, Julian Anastasov <ja@ssi.bg>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvs-devel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        coreteam@netfilter.org, Yu Zhe <yuzhe@nfschina.com>
References: <20221202032511.1435-1-liqiong@nfschina.com>
 <Y4nORiViTw0XlU2a@kadam>
From:   liqiong <liqiong@nfschina.com>
Message-ID: <9bc0af1a-3cf0-de4e-7073-0f7895b7f6eb@nfschina.com>
Date:   Fri, 2 Dec 2022 18:18:37 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <Y4nORiViTw0XlU2a@kadam>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,MAY_BE_FORGED,
        NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



在 2022年12月02日 18:07, Dan Carpenter 写道:
> On Fri, Dec 02, 2022 at 11:25:11AM +0800, Li Qiong wrote:
>> The 'ret' should need to be initialized to 0, in case
>> return a uninitialized value because no default process
>> for "switch (cmd)".
>>
>> Signed-off-by: Li Qiong <liqiong@nfschina.com>
> If this is a real bug, then it needs a fixes tag.  The fixes tag helps
> us know whether to back port or not and it also helps in reviewing the
> patch.  Also get_maintainer.pl will CC the person who introduced the
> bug so they can review it.  They are normally the best person to review
> their own code.
>
> Here it would be:
> Fixes: c5a8a8498eed ("ipvs: Fix uninit-value in do_ip_vs_set_ctl()")
>
> Which is strange...  Also it suggest that the correct value is -EINVAL
> and not 0.
>
> The thing about uninitialized variable bugs is that Smatch and Clang
> both warn about them so they tend to get reported pretty quick.
> Apparently neither Nathan nor I sent forwarded this static checker
> warning.  :/
>
> regards,
> dan carpenter

It is not a real bug,   I  use tool (eg: smatch, sparse) to audit the code,  got this warning and check it,
found may be a real problem.
