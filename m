Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAFEA640189
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 09:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232565AbiLBIGv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 03:06:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232075AbiLBIGt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 03:06:49 -0500
Received: from mail.nfschina.com (unknown [124.16.136.209])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E8B8D2B184;
        Fri,  2 Dec 2022 00:06:47 -0800 (PST)
Received: from localhost (unknown [127.0.0.1])
        by mail.nfschina.com (Postfix) with ESMTP id 207C71E80D27;
        Fri,  2 Dec 2022 16:02:43 +0800 (CST)
X-Virus-Scanned: amavisd-new at test.com
Received: from mail.nfschina.com ([127.0.0.1])
        by localhost (mail.nfschina.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id DhQTXNaVJn90; Fri,  2 Dec 2022 16:02:40 +0800 (CST)
Received: from [172.30.38.124] (unknown [180.167.10.98])
        (Authenticated sender: liqiong@nfschina.com)
        by mail.nfschina.com (Postfix) with ESMTPA id EE53C1E80CCF;
        Fri,  2 Dec 2022 16:02:39 +0800 (CST)
Subject: Re: [PATCH] netfilter: initialize 'ret' variable
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, coreteam@netfilter.org,
        Yu Zhe <yuzhe@nfschina.com>
References: <20221202070331.10865-1-liqiong@nfschina.com>
 <Y4mljMYvNh7zHlOh@ZenIV>
From:   liqiong <liqiong@nfschina.com>
Message-ID: <533ef392-5b77-9939-a961-872467d49cc3@nfschina.com>
Date:   Fri, 2 Dec 2022 16:06:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <Y4mljMYvNh7zHlOh@ZenIV>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On Fri, Dec 02, 2022 at 03:03:31PM +0800, Li Qiong wrote:
>> The 'ret' should need to be initialized to 0, in case
>> return a uninitialized value.
> Why is 0 the right value?  And which case would it be?
> We clearly need to know that to figure out which return
> value would be correct for it...
Hi, 
here is a case:
for (i = 0; i < e->num_hook_entries; i++) {
    ret = e->hooks[i].hook(e->hooks[i].priv, skb, state);
    if (ret != NF_ACCEPT)
        return ret;
    ....
}
I am not sure if  0 (NF_DROP) is the best value, but It's better to  initialize  a value.

