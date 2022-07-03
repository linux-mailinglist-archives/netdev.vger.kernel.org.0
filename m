Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9845B564701
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 13:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232449AbiGCLQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 07:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbiGCLQC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 07:16:02 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD3095A7
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 04:16:00 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id c65so8277679edf.4
        for <netdev@vger.kernel.org>; Sun, 03 Jul 2022 04:16:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=YoRUeSP3ebnjFeAIU67GCBccqdQApWDMvHE2HTLaJUo=;
        b=Gbo5qNXmX91i895dpUMbfFu7wvhOpsXVCEkwbI4KZbzE0+W4VNcL7VIL5nw/0qxvpw
         KepKHV4FALMjue1oIt2k5YWxgkzvSgnPJ6XArrf5vttuE1sommgqxAfnoRYjEwv0V4aT
         gjHvdWpQ9VlehwtCI7NnxByZu9Zbrxrfv7E6PmwBlFB6Ix7iAj+QT09okdwM4bTdccFA
         k+N1JRBTeyM6B0MO6X3rSMDNDVJZm8pD/END81wOJWTIxhVLc3aJMCEcufsXWx/1UfdH
         Q0F8g80lHnqHsvTdWcI84YxgKbfEg8M3fpdW8bcgoykULLLc2OOG2hJM40ryscNUhQg4
         5L+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=YoRUeSP3ebnjFeAIU67GCBccqdQApWDMvHE2HTLaJUo=;
        b=tFIXp82JkLSFKEuhpmuIrMYOh6xHK/8K1JLhqFaV9lsuXmS+dx8E7smeoDzmWGz4Ol
         LpM5qIg9zMosPUcs5yYk3+ALjzX3JFm6elpLCpbja2tyBqeuiLiBpG4ROw0HNSbuK0Gb
         x9qlGARec0GnD7Aj8CHSscM5Yk5Em0IUMj0AXTddIuPPntsiYEYFT5Jmdpmmup+XwWm4
         0HnjLUYjulg1UyjsJi5QdWAAQrfvXEEXXU6CFHPTNbLS0g86bF/ODKwe9+Ur+UoVdWvl
         kadnMmPMCEzrxWFqodaoqalzbOLKWxB5UWyCQr8gZ3qBcroSzL0ep2CNsmw2OPL6RjbT
         WHvg==
X-Gm-Message-State: AJIora+GmdA5XIXPlc4nTGPux6d9EBhsxfQTbBmSKevmaD0z5vPwlic1
        Ar1olzMdbVq3LUKbSS80FZc=
X-Google-Smtp-Source: AGRyM1szVlonCoFwS6EHKzxezEKRKhKcNsY0sRrqlMixKQOjbAAGBqHP0DIW3jaKzC94oooC2rwx4g==
X-Received: by 2002:a05:6402:1691:b0:43a:db2:a213 with SMTP id a17-20020a056402169100b0043a0db2a213mr686554edv.100.1656846959371;
        Sun, 03 Jul 2022 04:15:59 -0700 (PDT)
Received: from ?IPV6:2a04:241e:502:a09c:14b1:4622:94bc:a331? ([2a04:241e:502:a09c:14b1:4622:94bc:a331])
        by smtp.gmail.com with ESMTPSA id kv8-20020a17090778c800b007094f98788csm6016734ejc.113.2022.07.03.04.15.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Jul 2022 04:15:58 -0700 (PDT)
Message-ID: <a7972939-d017-abac-6bc5-1df52ceb9dfe@gmail.com>
Date:   Sun, 3 Jul 2022 14:15:57 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v3 net-next 1/2] af_unix: Put pathname sockets in the
 global hash table.
Content-Language: en-US
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Sachin Sant <sachinp@linux.ibm.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org
References: <20220702154818.66761-1-kuniyu@amazon.com>
 <20220702154818.66761-2-kuniyu@amazon.com>
From:   Leonard Crestez <cdleonard@gmail.com>
In-Reply-To: <20220702154818.66761-2-kuniyu@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 7/2/22 18:48, Kuniyuki Iwashima wrote:
> Commit cf2f225e2653 ("af_unix: Put a socket into a per-netns hash table.")
> accidentally broke user API for pathname sockets.  A socket was able to
> connect() to a pathname socket whose file was visible even if they were in
> different network namespaces.
> 
> The commit puts all sockets into a per-netns hash table.  As a result,
> connect() to a pathname socket in a different netns fails to find it in the
> caller's per-netns hash table and returns -ECONNREFUSED even when the task
> can view the peer socket file.
> 
> We can reproduce this issue by:
> 
>    Console A:
> 
>      # python3
>      >>> from socket import *
>      >>> s = socket(AF_UNIX, SOCK_STREAM, 0)
>      >>> s.bind('test')
>      >>> s.listen(32)
> 
>    Console B:
> 
>      # ip netns add test
>      # ip netns exec test sh
>      # python3
>      >>> from socket import *
>      >>> s = socket(AF_UNIX, SOCK_STREAM, 0)
>      >>> s.connect('test')
> 
> Note when dumping sockets by sock_diag, procfs, and bpf_iter, they are
> filtered only by netns.  In other words, even if they are visible and
> connect()able, all sockets in different netns are skipped while iterating
> sockets.  Thus, we need a fix only for finding a peer pathname socket.
> 
> This patch adds a global hash table for pathname sockets, links them with
> sk_bind_node, and uses it in unix_find_socket_byinode().  By doing so, we
> can keep sockets in per-netns hash tables and dump them easily.
> 
> Thanks to Sachin Sant and Leonard Crestez for reports, logs and a reproducer.
> 
> Fixes: cf2f225e2653 ("af_unix: Put a socket into a per-netns hash table.")
> Reported-by: Sachin Sant <sachinp@linux.ibm.com>
> Reported-by: Leonard Crestez <cdleonard@gmail.com>
> Tested-by: Sachin Sant <sachinp@linux.ibm.com>
> Tested-by: Nathan Chancellor <nathan@kernel.org>
> Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>

Tested-by: Leonard Crestez <cdleonard@gmail.com>
