Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9665F686A69
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 16:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231685AbjBAPcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 10:32:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232065AbjBAPca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 10:32:30 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D53B7165F
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 07:32:19 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id x6so895454ilv.7
        for <netdev@vger.kernel.org>; Wed, 01 Feb 2023 07:32:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0w306TBl9xojTD4+m6lXN95NIPdV0ni21/XD11jDBRs=;
        b=iZzyxeLp6jmZ5AFbGy2eZaRgcQabfYK84x/o5usDsl8BM/A63emii1CVt4U9AsoLgh
         XSFAC+Il9xWIA1w8qRDGrwBxIWhO90geEjJMXjY0vDac78MiouyV9L6QN5oeTsDEVxgx
         xaLZ+Uj3+uJEd+lxDHMipy3TjxPcuMWdulMYRWrLWiwCkPeGR65eK4G1I6eotF3ybOpp
         tPQtefoPYsyI5Rmdro7cIoL9n9xFjSUxDaDoYrzFO27juPwhA5HXDinCkOLOfVgc9UKM
         9hXPTdlvOyIxZ8M/3XGsYb+Z2qZv9ByXFNuiMnMXelqnNEVRY+VZ6KATJMeNo5l8/oSz
         XwBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0w306TBl9xojTD4+m6lXN95NIPdV0ni21/XD11jDBRs=;
        b=WGT7jPO7+gNKknp+rQ1UMVB7bPkjAkt6iyijEcQcM047Dc7XRWuB++h4hD78ekOMrp
         VxmVGSLMWlfQZH7Veb2TrqSeRjG8gjvXpXZJ2ytBQF7BcoW8Wv7b/gNXXqM3o+7w0oWt
         Hr+f2q5l7okGn32ETE0uxI94JPBPjldJNS7V6Jdu4nSfBYWh2ceQPXzvPg+hgjMxrHSh
         0vwgeqhgynsq/zjxpzCxxUhFNU6HYxh9waJXBI8NdnhNeI5xmpoSLMB1Vp5kQEVN2inT
         hWOVNRB1hb4c/nLfwFNOM/g9iYC7/faq9Dv6g2+CsPnSMp/HPABcvSd0BbwelwhR4Ac/
         tGPw==
X-Gm-Message-State: AO0yUKUnlw+ucrwNh0k0ajSsjNAJ5KMs3+oLnNhN1KIWnxbH5ofwlNv4
        ZgyNAgpXH6lWTn932TA6AoM=
X-Google-Smtp-Source: AK7set9SLKO5+nsbf70hDJoRvTOgsYXFczpLvo9T9XnfYjUHJwD9MX5W55GlrJK6mUXGxDi5fJ2TQA==
X-Received: by 2002:a05:6e02:1ba7:b0:310:c2d5:dfd5 with SMTP id n7-20020a056e021ba700b00310c2d5dfd5mr2463191ili.17.1675265538404;
        Wed, 01 Feb 2023 07:32:18 -0800 (PST)
Received: from ?IPV6:2601:282:800:7ed0:1dfd:95ca:34d0:dedb? ([2601:282:800:7ed0:1dfd:95ca:34d0:dedb])
        by smtp.googlemail.com with ESMTPSA id y4-20020a056638038400b003a7cadffda7sm6112126jap.2.2023.02.01.07.32.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Feb 2023 07:32:17 -0800 (PST)
Message-ID: <8e84db42-0774-43ed-9293-e80297ece7b4@gmail.com>
Date:   Wed, 1 Feb 2023 08:32:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCHv4 net-next 08/10] packet: add TP_STATUS_GSO_TCP for
 tp_status
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
 <0436a569c630a93e7abeedaa7ceccfc369f73c39.1674921359.git.lucien.xin@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <0436a569c630a93e7abeedaa7ceccfc369f73c39.1674921359.git.lucien.xin@gmail.com>
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
> Introduce TP_STATUS_GSO_TCP tp_status flag to tell the af_packet user
> that this is a TCP GSO packet. When parsing IPv4 BIG TCP packets in
> tcpdump/libpcap, it can use tp_len as the IPv4 packet len when this
> flag is set, as iph tot_len is set to 0 for IPv4 BIG TCP packets.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> ---
>  include/uapi/linux/if_packet.h | 1 +
>  net/packet/af_packet.c         | 4 ++++
>  2 files changed, 5 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


