Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E77B6E29AB
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 19:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbjDNRuO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Apr 2023 13:50:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229802AbjDNRuO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Apr 2023 13:50:14 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44C021FE2
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 10:50:13 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id oo30so4525288qvb.12
        for <netdev@vger.kernel.org>; Fri, 14 Apr 2023 10:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681494612; x=1684086612;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Rq+VpTXwF0j0tPREsbNl2SWjes36JpiC6uuoOwlgixQ=;
        b=I0GX5RZFcQ9F//YSvDVSVfYgAfuAM9UgqtqQZNsI+D/P+bVZvXVxKPIFfLcP1h5G83
         LKZL1TLzSyksXYraYyNxeTGLa0lyapmNSbwhaKoONyvRaOfBGOqTVksPSKHvOoYuo857
         Uy/Mi4D56zN2ZMWIwqmWndPvbN1KzGHO5ZU4kEimfkLUUjRyb8QGvlCAaq1zhjWGvs3L
         hFbkXFaxnNuK0+7bHWKLvY0mm7NiLNnMiNcgXL2q25lHjpadwzhByvk6rX5RMxP/8dXN
         RTHg2lJhlAd+XqmRxK2QFgFSrFFuvnD+mj13WTZpy8Xq/mySO8K22yI9ogw8DGmyhpcz
         la4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681494612; x=1684086612;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Rq+VpTXwF0j0tPREsbNl2SWjes36JpiC6uuoOwlgixQ=;
        b=RqLKuGSFE48rO7m2A4B26LDDgeQXypmJvSN6Ke6uCoWuJk/wRIU+MvnhsWTKOgsYJW
         TjQ9RNNAEKTg8vreGlfQEQc4qvlPmjSpxLgvaQacZmwzVvhncVWnNhiOlur20g6zgTwo
         UPNDFCPYf1KjTgEwu0EpfI3iRQv+0iZw4nw4jqiUubrSNK7O6VNg0pm18UQcR+kuKOft
         CdrisI9PQ9BuOU5Kwy7IvT9o8mY+ZI3GrVZ4dlIhMetogh7JQKIfrJs6BgIoUd0K6ch+
         H0YLCTVLdJqXopZyHGF88AABa+g11gtXrDnKLzigaCg2x5IVm3FiKiLLqgxQ9MMSvADX
         G8Xw==
X-Gm-Message-State: AAQBX9fubVobUyr6EKqYxIWow7ryIQjlFZzW22M+2/qJTdLNRnzIBULG
        +V4IFBdCiAff+PFAwlxS6b0=
X-Google-Smtp-Source: AKy350aWqSPETMyUkBS+YAe+72SzWsAWhN8MthJHluG3WCzZpbu5aMxp4dZrdWLfVMZXfKeIqeeLBw==
X-Received: by 2002:a05:6214:5019:b0:5ee:4503:24f5 with SMTP id jo25-20020a056214501900b005ee450324f5mr5867893qvb.21.1681494612259;
        Fri, 14 Apr 2023 10:50:12 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id lv4-20020a056214578400b005dd8b9345ecsm1246982qvb.132.2023.04.14.10.50.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Apr 2023 10:50:11 -0700 (PDT)
Message-ID: <741012bd-70f7-63df-8d2a-37f713a587d1@gmail.com>
Date:   Fri, 14 Apr 2023 10:50:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net-next 5/5] net: skbuff: hide nf_trace and ipvs_property
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        pablo@netfilter.org, fw@strlen.de
References: <20230414160105.172125-1-kuba@kernel.org>
 <20230414160105.172125-6-kuba@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230414160105.172125-6-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/14/23 09:01, Jakub Kicinski wrote:
> Accesses to nf_trace and ipvs_property are already wrapped
> by ifdefs where necessary. Don't allocate the bits for those
> fields at all if possible.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: pablo@netfilter.org
> CC: fw@strlen.de
> ---
>   include/linux/skbuff.h | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
> index 543f7ae9f09f..7b43d5a03613 100644
> --- a/include/linux/skbuff.h
> +++ b/include/linux/skbuff.h
> @@ -966,8 +966,12 @@ struct sk_buff {
>   	__u8			ndisc_nodetype:2;
>   #endif
>   
> +#if IS_ENABLED(CONFIG_IP_VS)
>   	__u8			ipvs_property:1;
> +#endif
> +#if IS_ENABLED(CONFIG_NETFILTER_XT_TARGET_TRACE) || defined(CONFIG_NF_TABLES)

Should that be IS_ENABLED(CONFIG_NT_TABLES) given it can be tristate?

>   	__u8			nf_trace:1;
> +#endif
>   #ifdef CONFIG_NET_SWITCHDEV
>   	__u8			offload_fwd_mark:1;
>   	__u8			offload_l3_fwd_mark:1;

-- 
Florian

