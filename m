Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1336686A67
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 16:32:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231778AbjBAPc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 10:32:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232272AbjBAPc0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 10:32:26 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 348694955E
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 07:31:59 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id i17so7872621ils.11
        for <netdev@vger.kernel.org>; Wed, 01 Feb 2023 07:31:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GbF7lkvZ4Amm8xxdiv/QzWo0x6sQSM68u7fXySJZPv0=;
        b=jfk9r6XLBke3cnm5+mWKI3ZNfEWW8fli/5XK+3gMZM/L1fi4Dtxck9BmIdloF1ClgH
         dFC264x5ihI1VNtbYxDtMoSBQKS/UdYqWOAbVYVQZOzcM0XQwxI4cVNX5v3xqAnladMj
         ft9yCeOA1/yvw5RnHLGunxvw6csCgkgFIFAMahtsCMaN+dLKIlBZuJbj483mfeHiUTQX
         b2Jlq6D+a2LnwFJku8dWHeV+r0uGIQcXzWGNJA864nMjUw9QNMsaoyNv1J3TQhqgBa10
         /269vVZZrysZLFcsqAmq03SVXiphri9T+2rJicKsU2LwPxkqN9d9Pz2j0jzNLGM7KiZ7
         QyfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GbF7lkvZ4Amm8xxdiv/QzWo0x6sQSM68u7fXySJZPv0=;
        b=5F5SD+Su2J7wDQWIji/sXzOWuKTOYorP49j28uhgmJIGT/Ro/Jg+SWly9yhlSRO0WU
         Z6k4rIj22hNV2ZITwNiCbbYJXg2HKU9Jt4GPlfbJuRe4/WOVsLgePjohJQQ5A6Ri6vw4
         00YJZaqrKkyE3A3ttq9u1dPsy/DAgSk/SC/6yMOh3FvXIDxiF/x3Wc40ENXHkMgzRPY8
         M1PDqFu8h76XvsNZzydTt+KkjdtokkM22agl1i6qn2QFZjXGOeYPamQ0NZaJ3xquzk4P
         oxtLGKjHgDvuboObvUy02MydXrr2JRsCd2Bk4lPwyhVDkIu/i+msWR9XQnGAxaTZcT90
         Qz8Q==
X-Gm-Message-State: AO0yUKVDzObKvj6+6WMzHaunxjMYl8vv7yBtUuNrbxc0hEVdRU40Q0qs
        R5ww6vunnG54RDy56vk57lTVxwjhyFvvpg==
X-Google-Smtp-Source: AK7set/DkHh6eU9hUqN2r8LBZvYyrbO1L2yxrIdf+10vJ8qUB+Fj0U02i28mnFMHxEg45P95sZldjg==
X-Received: by 2002:a05:6e02:1a06:b0:310:c066:6052 with SMTP id s6-20020a056e021a0600b00310c0666052mr2398516ild.9.1675265518548;
        Wed, 01 Feb 2023 07:31:58 -0800 (PST)
Received: from ?IPV6:2601:282:800:7ed0:1dfd:95ca:34d0:dedb? ([2601:282:800:7ed0:1dfd:95ca:34d0:dedb])
        by smtp.googlemail.com with ESMTPSA id h36-20020a05663833a400b003b09a205870sm3014663jav.137.2023.02.01.07.31.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Feb 2023 07:31:57 -0800 (PST)
Message-ID: <9a5634cc-47a2-57fe-4129-cfa6a61d9094@gmail.com>
Date:   Wed, 1 Feb 2023 08:31:56 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCHv4 net-next 01/10] net: add a couple of helpers for iph
 tot_len
Content-Language: en-US
To:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Mahesh Bandewar <maheshb@google.com>,
        Paul Moore <paul@paul-moore.com>,
        Guillaume Nault <gnault@redhat.com>
References: <cover.1674921359.git.lucien.xin@gmail.com>
 <9a810d8265b12d95e6effff76e2ec722f283b094.1674921359.git.lucien.xin@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <9a810d8265b12d95e6effff76e2ec722f283b094.1674921359.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/28/23 8:58 AM, Xin Long wrote:
> This patch adds three APIs to replace the iph->tot_len setting
> and getting in all places where IPv4 BIG TCP packets may reach,
> they will be used in the following patches.
> 
> Note that iph_totlen() will be used when iph is not in linear
> data of the skb.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  include/linux/ip.h  | 21 +++++++++++++++++++++
>  include/net/route.h |  3 ---
>  2 files changed, 21 insertions(+), 3 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


