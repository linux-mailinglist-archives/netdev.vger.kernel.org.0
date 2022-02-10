Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9A64B1485
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 18:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245332AbiBJRrr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 12:47:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245319AbiBJRrq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 12:47:46 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4E00F03
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 09:47:47 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id t14-20020a17090a3e4e00b001b8f6032d96so6301661pjm.2
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 09:47:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ZJEQBQRP6bltFXYj/G96h0h/Mma0Mm+XIOqj7ftdsEM=;
        b=JO7I/oMvSc/x4KxlkDAgiN5EiR+YuIAsOW1XMK82bT0YjdEGL5w1AtMRYZRYINWZuV
         f2BF4LzY38834DgATwI7bhNDc/V4XmMB+Cfnf/wW/wG6trmolMP+J2WDU0OJzEf8IfZ8
         zazzm1pPMZYTzpGqJ4vnGG4TRyVvgSYqJ1hIShvau+VyaodQEUQ6aWhFzR3uZOSBgV1/
         PZYTpDq9RAULTKcZZC2XXTcus8DUGQmmRl0Lvze6XMxj/ihD/vh5D/5yYyr3RrxMuNgc
         GqZB82sr8H4ndlkAnWRCGt5eDeyi5GL8iXsUbh2sKRNnPusNnofbEoQKdnu3OLwLR9wU
         EzNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZJEQBQRP6bltFXYj/G96h0h/Mma0Mm+XIOqj7ftdsEM=;
        b=LyoKurqhTMhqsqo5ST/bQlyfj6XQkM/68btSgrxAOzXu16sz5P3CfeWNYPQGU1OZEx
         CD6E1ggl1a0sdRvRJxlazCTc03Z+F2YoMS90SDgfON+7wl3Nq71jKVepjFnJVzWiA+t/
         D+LlIUKjl8B84LCeQAEU5FMlG9F0vjvQ5Kw/Oa4VPQzOHzK70mUZGlLY4/3xCZoWm5m2
         fv5O2DDt+/PKUWKYe3z0O9j5faTk5FPdD6NUw3jag8nAhCP6y/u+5alhe4y9QUQKA/bi
         1dvqDs5BgqL/tthFTbCRrkstVECbgbo+8sznP8WVSdez4KlrOXyxTgKdSTTCJC6609JX
         MCGQ==
X-Gm-Message-State: AOAM531NSLnTlwP2Ne8CIrs7SuxmR8NJ8OuthEoHFTJAWlN3+EzZKBj+
        EOn+Iwa0HCvbA//o8CznafS/EyIRx3s=
X-Google-Smtp-Source: ABdhPJzDnb88rzVFSQLQDGWnDUUoZd0Rtymoqwd3e/J2Q2K1JGqMyIQlP1080XucqwjCBX2EX/DGDA==
X-Received: by 2002:a17:902:b215:: with SMTP id t21mr8324299plr.69.1644515267373;
        Thu, 10 Feb 2022 09:47:47 -0800 (PST)
Received: from [192.168.86.21] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id f16sm23052676pfd.118.2022.02.10.09.47.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Feb 2022 09:47:46 -0800 (PST)
Message-ID: <b147e095-4c02-61a0-4cca-18c570eb7d9e@gmail.com>
Date:   Thu, 10 Feb 2022 09:47:44 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 net-next] net: hsr: fix suspicious usage in
 hsr_node_get_first()
Content-Language: en-US
To:     Juhee Kang <claudiajkang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Cc:     ennoerlangen@gmail.com, george.mccollister@gmail.com,
        olteanv@gmail.com, marco.wenzel@a-eberle.de,
        syzbot+f0eb4f3876de066b128c@syzkaller.appspotmail.com
References: <20220210162346.6676-1-claudiajkang@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <20220210162346.6676-1-claudiajkang@gmail.com>
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


On 2/10/22 08:23, Juhee Kang wrote:
> Currently, to dereference hlist_node which is result of hlist_first_rcu(),
> rcu_dereference() is used. But, suspicious RCU warnings occur because
> the caller doesn't acquire RCU. So it was solved by adding rcu_read_lock().
>
> The kernel test robot reports:
>      [   53.750001][ T3597] =============================
>      [   53.754849][ T3597] WARNING: suspicious RCU usage
>      [   53.759833][ T3597] 5.17.0-rc2-syzkaller-00903-g45230829827b #0 Not tainted
>      [   53.766947][ T3597] -----------------------------
>      [   53.771840][ T3597] net/hsr/hsr_framereg.c:34 suspicious rcu_dereference_check() usage!
>      [   53.780129][ T3597] other info that might help us debug this:
>      [   53.790594][ T3597] rcu_scheduler_active = 2, debug_locks = 1
>      [   53.798896][ T3597] 2 locks held by syz-executor.0/3597:


Please include whole stack.


>
> Fixes: 4acc45db7115 ("net: hsr: use hlist_head instead of list_head for mac addresses")
> Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
> Reported-by: syzbot+f0eb4f3876de066b128c@syzkaller.appspotmail.com
> Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
> ---
> v2:
>   - rebase current net-next tree
>
>   net/hsr/hsr_framereg.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/net/hsr/hsr_framereg.c b/net/hsr/hsr_framereg.c
> index b3c6ffa1894d..92abdf855327 100644
> --- a/net/hsr/hsr_framereg.c
> +++ b/net/hsr/hsr_framereg.c
> @@ -31,7 +31,10 @@ struct hsr_node *hsr_node_get_first(struct hlist_head *head)
>   {
>   	struct hlist_node *first;
>   
> +	rcu_read_lock();
>   	first = rcu_dereference(hlist_first_rcu(head));
> +	rcu_read_unlock();
> +
>   	if (first)
>   		return hlist_entry(first, struct hsr_node, mac_list);
>   


This is not fixing anything, just silence the warning.


