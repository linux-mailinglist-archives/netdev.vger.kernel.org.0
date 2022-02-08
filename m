Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 771034AD04D
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 05:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346761AbiBHEVn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 23:21:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233749AbiBHEVg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 23:21:36 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3B19C0401DC
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 20:21:35 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id y7so7557126plp.2
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 20:21:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=WO5v+QknHvEf4rB56vC0DIek69s7VbIQ7aNap/yEFDQ=;
        b=CWnXzYYo4iV0fkzlAFpzU7wUAv6+ChD04C4jQjUtABrwJ7MZHMV7HXhQ89ZEtOx6rz
         NCh242PTHj/C3Wt1tHTwa8XC5Gw6jKPEmQLaWT2QWVEoT72CgagwIwcZRqHIIBYRtKM7
         yzD9CSYr8FwwoZl31aSg4gQMlXHp5btXD/vLk4JeYcAN8WqxPoJS/5yD9/s8G8DRuyrb
         ANovX1ryb4CiFwJQwP/7QOaNhQgCT2+o+W/sUyRkFppZvy/IhZfaaifNTyDfSLGtM+5f
         rc7G7wWtB83XGzFOfjK+K0poyu521+2iIktH6E3b71zKjhW5Ys0s0kPgd0nRE5v5VdWw
         u0pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WO5v+QknHvEf4rB56vC0DIek69s7VbIQ7aNap/yEFDQ=;
        b=4Fs/MbDpx0EDb3OyVShB98ZDBzkF9VN+mXAE5lK2v4qfpBx7MTdYqmInbhqLGZovKl
         B3rF3P4BWLq3toMPHZ3iOAnckn7UwFpKcatfzoqrh1W2wL7joscph0G3fNiiApvwzhOI
         kc4fVsX8+w84rMakr/BeP6ZoxDIVNNJtpFiquupRzNgwQMD76TmlvWt0wEGbzad/x8Sc
         SXbIkiSr9+rLMTMKNLqx6hZT6FPUM3KuT5o8w1ofwkFps15VJnFIsLtddPqVw5UFuqhV
         Tx9WVLcnjgL7t0jPgJ6Qo7oqn6wbIL8JL8kQVB0aKMy+f/ps0G7z9prA2pzYputkxKK1
         kkBQ==
X-Gm-Message-State: AOAM532vphYR4UUwJalfC7s1tq9LN1FNJM6q0y+zSPGKkgTzbOgTJnBh
        IMJhPsgBshZdJtqhFlJ2mAQ=
X-Google-Smtp-Source: ABdhPJzZFjtJ0nFYwG79N0MehfCP4rmga6s+KfL2VMxMHiRcRoBvJw6arnCEnjIwQBIwWFCDjaxyww==
X-Received: by 2002:a17:902:f68e:: with SMTP id l14mr1549614plg.166.1644294095522;
        Mon, 07 Feb 2022 20:21:35 -0800 (PST)
Received: from [10.0.2.64] ([209.37.97.194])
        by smtp.googlemail.com with ESMTPSA id q2sm14415215pfj.94.2022.02.07.20.21.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 20:21:35 -0800 (PST)
Message-ID: <157bf397-97ea-522f-10c7-77a06be68c62@gmail.com>
Date:   Mon, 7 Feb 2022 20:21:34 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH net-next 06/11] ipv6: change fib6_rules_net_exit() to
 batch mode
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
References: <20220207171756.1304544-1-eric.dumazet@gmail.com>
 <20220207171756.1304544-7-eric.dumazet@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220207171756.1304544-7-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8
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

On 2/7/22 9:17 AM, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> cleanup_net() is competing with other rtnl users.
> 
> fib6_rules_net_exit() seems a good candidate for exit_batch(),
> as this gives chance for cleanup_net() to progress much faster,
> holding rtnl a bit longer.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: David Ahern <dsahern@kernel.org>
> ---
>  net/ipv6/fib6_rules.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


