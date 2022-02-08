Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FB804AD053
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 05:24:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346871AbiBHEYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 23:24:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346914AbiBHEYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 23:24:51 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41E9C0401DC
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 20:24:50 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id m7so15011834pjk.0
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 20:24:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=WuuKwP0gNbquZGhuPG3i3NLPQcjGwiraNBzBgxwQBgU=;
        b=DCubD2fvc8bDWaoNLVFQbF/CYT74cBdT/jW0TKuMimfa62Z1UlMgsTjLDwzEmpxtUO
         +SNNiX37D3DDgkmpwb/ztNaKOW/cBHqHOmZR7G0AgiObm+LxdWazW1P4tS87KXWuZRWG
         +HOm6QGgvmp7LQ1tSE/3wFywvTcTS6/JrcccOWUjJymL9QgJsgSUxMscYUPjp6juIjF1
         QCSJa7yB2wUvB3gmDq/P9MxZWnf0kVb6bfyzD89aWvMcQUnbChs9dy5dBFI7WX1/L2xS
         LlFZLboyBVLvXGMFWoKtCFLS7X3K/YJf9uKn3ZnlBOmrIKouhlXexD571Db4w0fur7m0
         byyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=WuuKwP0gNbquZGhuPG3i3NLPQcjGwiraNBzBgxwQBgU=;
        b=eOKlNG5paM9nXV5mwbEbfj/vmcQSFyBU1il5r4IJokRlsCVrnZ/+XUypngf7gGinJL
         bD0HlkKHnRIvaduoR3051DH5zQARuLHN3ui0+vyjcImpkl0fvbCiQX13qBHG5MWNj5sK
         Gcta5ZvIX1XBY3UCQ9tk1oCZkfeN/DIIajRVdAkJEoyVEqdgcY0bftyB4SmEVo2HPC3Q
         xskVRj7fap9UXyV4Cxq5oVj1ffqiZZj0FOOZq+4/Aa4tCu8YXaklPC/1iv9iOX4XGwpP
         58MHzLS+MDqlR8gV+mVXjqKlIH7ITwwkL2LkMaJxXepT2L/W95GzLQlnqBV5NfIzhKgC
         LBGg==
X-Gm-Message-State: AOAM5314IUPRgoiHTLd8uktQDkZw56wwBNd811iSTjYcwZBytx5lVRsD
        25Im6XIdiqcYMii86O2jqjE=
X-Google-Smtp-Source: ABdhPJxSfyCeq0m+n5zGMdaWVfZJ3sA/A8OiojeQkpZrlJ6f3F6bVM4D7SX7tDIFqBCZCXS1pOFvzg==
X-Received: by 2002:a17:90b:2252:: with SMTP id hk18mr2421650pjb.183.1644294290361;
        Mon, 07 Feb 2022 20:24:50 -0800 (PST)
Received: from [10.0.2.64] ([209.37.97.194])
        by smtp.googlemail.com with ESMTPSA id oa5sm940958pjb.0.2022.02.07.20.24.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 20:24:49 -0800 (PST)
Message-ID: <c5cf5df5-a37e-2c34-f5c6-b34cc91cf911@gmail.com>
Date:   Mon, 7 Feb 2022 20:24:48 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH net-next 08/11] ipmr: introduce ipmr_net_exit_batch()
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
References: <20220207171756.1304544-1-eric.dumazet@gmail.com>
 <20220207171756.1304544-9-eric.dumazet@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220207171756.1304544-9-eric.dumazet@gmail.com>
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
> Avoiding to acquire rtnl for each netns before calling
> ipmr_rules_exit() gives chance for cleanup_net()
> to progress much faster, holding rtnl a bit longer.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: David Ahern <dsahern@kernel.org>
> ---
>  net/ipv4/ipmr.c | 20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


