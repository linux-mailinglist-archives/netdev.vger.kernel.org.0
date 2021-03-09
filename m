Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5203033214C
	for <lists+netdev@lfdr.de>; Tue,  9 Mar 2021 09:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229878AbhCIIro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 03:47:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbhCIIrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 03:47:25 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9A64C06174A;
        Tue,  9 Mar 2021 00:47:24 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id f22-20020a7bc8d60000b029010c024a1407so5415454wml.2;
        Tue, 09 Mar 2021 00:47:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=E/qC93H1VKIcOpONCXw0j09lcc/QSRmlE9p3bZVUefw=;
        b=fiKmb5g0Z5SGOMa0LPeQ81SmBRAlTWrElJIvybbqqmAR+i35I5YKVAAtqi1gVudueD
         D5BoQWxWc/FzZrifuuigrxm3YLxasz5tKEXsOWKXN6kO/OvhX5ci+nbCGDT25rpilSR7
         6FkmMThnXVikLZUxZPRAfNyQeW0x8IMlOl9dxBSgIp6SMOiAt6f6lbz/T4K9qY+Dv+ur
         JZitQyU1imU/I9pUl1nfQaSTNNgzLyq0Td1Rq3OWsaUAVoOU9KTcyzNAWxxWXvT//6QH
         NeucJ3aSly1TFjmOlTYgXdrjsVaiqpGNej7qzWlh9i/dRkrtJ9rjcj1dWvwMsLrFdgI4
         iBhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E/qC93H1VKIcOpONCXw0j09lcc/QSRmlE9p3bZVUefw=;
        b=jGiByirlshlZj1DpuMxZtiQr944YUCuWcDWNWWJ4ae9BVkNHOxvhMPkNPwiq8HDihG
         AuQ5d5pmLbqGb+EaIJ/+e75lciLGA/BD8SsahzFckmOeWOxYL+NMK+zWVQT0GQMwoNr9
         8sZECXTBHFPiXMWIlco0DjAuAmxDJrIxSlisSfphyK+qLVPmxqsSL8hc/5P3SxU3yEmX
         2zmQi8c1+NxZRz8IlULwruuzQi7xBmHMpTmF3GS6B1N38BUhWtb6iCe2Phuj4LeHXxem
         q+2jvDK8bSYv208pSakoZDxzgj5o524atbxsQYSJc10ztkJTNdyzriIFmx5Cl8oifQKx
         QWoQ==
X-Gm-Message-State: AOAM531X433sPC4CkYJnj6REWGvpHb5CcRd2K2A13AgaS8wS2dJy3sRb
        AhLsnVf69KA5L6vFpCN9JkTU+UV60WnqXA==
X-Google-Smtp-Source: ABdhPJxS2SrhPNQGuPYDsLL1YqtQ/t+Pfq2hyPBVoFNZvOxr6NeOfOlW3oki+p9KPoXQNn2lr1FPGg==
X-Received: by 2002:a1c:7704:: with SMTP id t4mr2714928wmi.159.1615279643089;
        Tue, 09 Mar 2021 00:47:23 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:bb00:346e:564c:5089:1548? (p200300ea8f1fbb00346e564c50891548.dip0.t-ipconnect.de. [2003:ea:8f1f:bb00:346e:564c:5089:1548])
        by smtp.googlemail.com with ESMTPSA id s9sm2955290wmh.31.2021.03.09.00.47.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Mar 2021 00:47:22 -0800 (PST)
Subject: Re: [PATCH] net: netlink: fix error return code of
 netlink_proto_init()
To:     Jia-Ju Bai <baijiaju1990@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        marcelo.leitner@gmail.com, mkubecek@suse.cz, jbi.octave@gmail.com,
        yangyingliang@huawei.com, 0x7f454c46@gmail.com,
        rdunlap@infradead.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
References: <20210309083356.24083-1-baijiaju1990@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <1ca491b5-1c65-6dee-1f8c-d86006714b51@gmail.com>
Date:   Tue, 9 Mar 2021 09:47:12 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210309083356.24083-1-baijiaju1990@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09.03.2021 09:33, Jia-Ju Bai wrote:
> When kcalloc() returns NULL to nl_table, no error return code of
> netlink_proto_init() is assigned.
> To fix this bug, err is assigned with -ENOMEM in this case.
> 

Didn't we talk enough about your incorrect patches yesterday?
This one is incorrect again. panic() never returns.
Stop sending patches until you understand the code you're changing!


> Fixes: fab2caf62ed0 ("[NETLINK]: Call panic if nl_table allocation fails")
> Reported-by: TOTE Robot <oslab@tsinghua.edu.cn>
> Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
> ---
>  net/netlink/af_netlink.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
> index dd488938447f..9ab66cfb1037 100644
> --- a/net/netlink/af_netlink.c
> +++ b/net/netlink/af_netlink.c
> @@ -2880,8 +2880,10 @@ static int __init netlink_proto_init(void)
>  	BUILD_BUG_ON(sizeof(struct netlink_skb_parms) > sizeof_field(struct sk_buff, cb));
>  
>  	nl_table = kcalloc(MAX_LINKS, sizeof(*nl_table), GFP_KERNEL);
> -	if (!nl_table)
> +	if (!nl_table) {
> +		err = -ENOMEM;
>  		goto panic;
> +	}
>  
>  	for (i = 0; i < MAX_LINKS; i++) {
>  		if (rhashtable_init(&nl_table[i].hash,
> 

