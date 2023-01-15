Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4457566B22E
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 16:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231460AbjAOPln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 10:41:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230354AbjAOPlk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 10:41:40 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E078459D6
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 07:41:39 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id n85so4944907iod.7
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 07:41:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=99MhMRd3nL6lWtq5N+A549Zl5bqPIUvrIwuP6tP6AX8=;
        b=MsmdkMMsDBtAyZsjhylP/qbnPPj25YSITu9Qn1PXQInIQCKWuwgVNGbJDUIQy3AcOJ
         0GZdpJtmihp5iySjFtY+3EN6CfSKJo/XcQ6dXqXYgf+6wOG4l15+MGgZsLy8QTnnJC2R
         I2WtLOYUGrF4fpjag79mWolpeltmsduhlU+s9mEWzb5qlEzEs7kHqjIz3PjOnQ8O2a1Z
         LVlF5A9RwxYyRQuDUkD3+BhA1JUGrjMfuWuRHcReMLUtzRUlJOb0b/a7VrMpVUvYHu3w
         qfdwYXHwIcS7fpJRf/pPUpBtKCxDGQPEjTA1BV2sLrfE1y1QfMkFSKQBRCnLcpeSMUFi
         +oLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=99MhMRd3nL6lWtq5N+A549Zl5bqPIUvrIwuP6tP6AX8=;
        b=a3liAjny7UIeG2tb71k4Bj+Yrxg+GTkUNC9Azqr/ZgNQe2IS1/x4gnfYGSadwrW4Vg
         645TIRvmraXNxuBZ13E5569u8M697E8Q9YbMa7kwtg+jzK/n2Lz4ogAiBXzclX+p8SWP
         y60uFIG+GnRBms5r9MhCGchdz8I8xXgarbps9z7favYVX+ywLglOllWjrIUf55/xwv7w
         FkzTr6Fju0fsrJhU0XVPeHQ3qg7QQl29/2/7ThV2pYxQk4fpVTmwRanz35eCSCbcedRk
         B4mrjxYsjO3lHkLsenWUaecvIZeI0X0q8U0uaSqj7g1Cui1xSdvzwb2AV+VKTc7yWaE8
         rh7Q==
X-Gm-Message-State: AFqh2kqNOjRj3O0AQd/ZOwFp61TYOGLkAOKB5E4aZvlzRhENPSIVLccx
        TXhU21UOZW3n1KNqiLhml4M=
X-Google-Smtp-Source: AMrXdXvSLRnKFubqs9kJaUdynzwlqFKxxlQ2cB9aw4EBzO/ajbDOPv+6kzL4vUpn/kp6kOrD9fAbyQ==
X-Received: by 2002:a6b:fa0e:0:b0:704:a04e:9856 with SMTP id p14-20020a6bfa0e000000b00704a04e9856mr4247747ioh.4.1673797299280;
        Sun, 15 Jan 2023 07:41:39 -0800 (PST)
Received: from ?IPV6:2601:284:8200:b700:7de9:438a:dc6b:e300? ([2601:284:8200:b700:7de9:438a:dc6b:e300])
        by smtp.googlemail.com with ESMTPSA id f16-20020a05660215d000b006dfbd35e995sm8919067iow.21.2023.01.15.07.41.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Jan 2023 07:41:38 -0800 (PST)
Message-ID: <b0a1bebc-7d44-05bc-347c-94da4cf2ef27@gmail.com>
Date:   Sun, 15 Jan 2023 08:41:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 09/10] netfilter: get ipv6 pktlen properly in
 length_mt6
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
References: <cover.1673666803.git.lucien.xin@gmail.com>
 <de91843a7f59feb065475ca82be22c275bede3df.1673666803.git.lucien.xin@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <de91843a7f59feb065475ca82be22c275bede3df.1673666803.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/13/23 8:31 PM, Xin Long wrote:
> For IPv6 jumbogram packets, the packet size is bigger than 65535,
> it's not right to get it from payload_len and save it to an u16
> variable.
> 
> This patch only fixes it for IPv6 BIG TCP packets, so instead of
> parsing IPV6_TLV_JUMBO exthdr, which is quite some work, it only
> gets the pktlen via 'skb->len - skb_network_offset(skb)' when
> skb_is_gso_v6() and saves it to an u32 variable, similar to IPv4
> BIG TCP packets.
> 
> This fix will also help us add selftest for IPv6 BIG TCP in the
> following patch.
> 

If this is a bug fix for the existing IPv6 support, send it outside of
this set for -net.

