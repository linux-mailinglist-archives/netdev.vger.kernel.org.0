Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC12696DCC
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 20:25:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbjBNTY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 14:24:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjBNTY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 14:24:57 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A6B81F5E9
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 11:24:55 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id h16so16732288wrz.12
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 11:24:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YxKpNsBmN/4ogSIK2yr1saZw9P+55cCHQ7Lt1xzzu4w=;
        b=Z3GEIZ4LsjL8yqQML7o/wQdGPH/azzzu3tcs4XbizUDnz5e4GkYeBKYL0vpWqnsQl6
         atpNMl+hmaqxzKz0FLlUXul4ahCq6Zm5KYpg3QaeVT3Vx6Q7nHl6Q5uJMXOCbdp3tbll
         K46xcbKMjOQJPAuaGXtxYR1OIJV9R+iZNLFJgmflDoAanviTRx02YWE6ueIOLKIu09Tw
         KqYs/aFCGhKQ6OGay9jQBmRfHhJ3Zz/LLUIlQJwl3KJMoU0NLpZtXgapbY9ZcUB9362j
         9eSGKmwnZK4jRKMyqKQ6jxe/xHtCv9xGp/6f60dckSi8t1a7SXIbbU0Yg06MkdMnzc12
         LFzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YxKpNsBmN/4ogSIK2yr1saZw9P+55cCHQ7Lt1xzzu4w=;
        b=e4dBIjEPWMz3VRTuU7xdjBi5EHhEy1N0J2EbHMbvGvObXKJJ1khNptol3C0ULMi42Q
         Vt+in4OfCtrgufmInGR7jW9EFSAIi8A+HoLeC19w0Botbb5J0bDUSvj2VOuCB9QNvbbR
         KXYF0DnMcFYfrkk4wHelBqg9VaP2B5n5IuNAoQL9jJYSoo0FNT12bSctL0oVsIe7Zat3
         vuivz9KaOpE4u/eXOmG6Sr8GAbKpowtY2GVxRGZaNkfsNBdgl5QXrwo9KwBHSgtKEuGw
         F6Pbh8TCB4WVTqezsCg0IrcBs5Iew1SxOwcNrGRxEGhdXb8SnXCz7tnYq27Knvtzf+G6
         MZPQ==
X-Gm-Message-State: AO0yUKXMuier5CEyKY5ruvzw9ROoHsgTuYPLlBwY1Ho97aGJ6B4iak0S
        TaSynbvdpMZrWbKHjKn+wC0=
X-Google-Smtp-Source: AK7set80fXTW98QVBg+iV5OllQ4fDXbZ1OGBW5WvfCs/Ox5UgZ6qa06P22C2O03YoQPH3xW8Btiqrg==
X-Received: by 2002:a5d:4562:0:b0:2c4:848:bbd4 with SMTP id a2-20020a5d4562000000b002c40848bbd4mr3158250wrc.36.1676402694081;
        Tue, 14 Feb 2023 11:24:54 -0800 (PST)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id n4-20020a5d67c4000000b002c56287bd2csm2658806wrw.114.2023.02.14.11.24.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Feb 2023 11:24:53 -0800 (PST)
Subject: Re: [PATCH net-next v9 1/7] net/sched: cls_api: Support hardware miss
 to tc action
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Oz Shlomo <ozsh@nvidia.com>
Cc:     Paul Blakey <paulb@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Simon Horman <simon.horman@corigine.com>
References: <20230206174403.32733-1-paulb@nvidia.com>
 <20230206174403.32733-2-paulb@nvidia.com>
 <20230210022108.xb5wqqrvpqa5jqcf@t14s.localdomain>
 <5de276c8-c300-dc35-d1a6-3b56a0f754ee@nvidia.com>
 <Y+qE66i7R01QnvNk@t14s.localdomain>
 <a3f14d60-578f-bd00-166d-b8be3de1de20@nvidia.com>
 <8232a755-fea4-6701-badc-a684c5b22b20@nvidia.com>
 <Y+vXhDvkFL3DBqJu@t14s.localdomain>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <c060bf5f-4598-8a12-91d4-6340ecd24e14@gmail.com>
Date:   Tue, 14 Feb 2023 19:24:52 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <Y+vXhDvkFL3DBqJu@t14s.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/02/2023 18:48, Marcelo Ricardo Leitner wrote:
> On Tue, Feb 14, 2023 at 02:31:06PM +0200, Oz Shlomo wrote:
>> Actually, I think the current naming scheme of act_cookie and miss_cookie
>> makes sense.
> 
> Then perhaps,
> act_cookie here -> instance_cookie
> miss_cookie -> config_cookie
> 
> Sorry for the bikeshedding, btw, but these cookies are getting
> confusing. We need them to taste nice :-}

I'm with Oz, keep the current name for act_cookie.

(In my ideal world, it'd just be called cookie, and the existing
 cookie in struct flow_action_entry would be renamed user_cookie.
 Because act_cookie is the same thing conceptually as
 flow_cls_offload.cookie.  Though I wonder if that means it
 belongs in struct flow_offload_action instead?)

-ed
