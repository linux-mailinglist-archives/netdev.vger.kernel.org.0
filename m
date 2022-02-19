Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 701A34BCB0F
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 23:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241225AbiBSWzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 17:55:07 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235536AbiBSWzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 17:55:06 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DFDA3BF80;
        Sat, 19 Feb 2022 14:54:47 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id j3-20020a9d7683000000b005aeed94f4e9so1231601otl.6;
        Sat, 19 Feb 2022 14:54:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=R7Y7RGg/qzx7WEhwYEz0sSKfyOO0hLiZzhIhihySEI4=;
        b=XztjrH+hO1rpoto9JNGNRFZtB/0dXFB28btA04mbnixtwjB1z7wal+a72CXvpSX3MO
         IrreJ3USp80qxF7HT6HKSWVE/tB8jAOiWvtDH8uzHWjgRdVO/o0BKuIyY8sLK9WhY7a5
         XR8AsK3EA6ksYwZVabcUYorkGLPbl9VJgcJpOq0pDczxgDw/OvPU5HIZSJebP7tPc04+
         XTl9lpQNsYIIX2bsUhxaNZCkJ9ZNIsUhows0XFcxnzgdhU0pJhxCSU2AwLE3BqmOKuoF
         fLWoDnwDWdKR7gMhrMWpCEbzFUGcOUM6c6oShbnEOUYZX3TbmFM1iovyICuLzI5cCMfm
         IgUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=R7Y7RGg/qzx7WEhwYEz0sSKfyOO0hLiZzhIhihySEI4=;
        b=mupRnQ8bWwTI+ciz5ilZGi7BFTJoPsTAQNTDM4nH1zfHX6bLqwqq6k9eMoyUSmHyi5
         JfHVzHMQ2BMSVSZHImZKi8S6XpaCrgyqLcKagJKB+PYzXxAc75QB512NJEIE8mHyxvpC
         8tXdUGKsWu5e4lDdwiuapDlAotCMug1Q62fkuj+yNdCJm3djaRez22NCiw+ZQ7/PZe8D
         zyM6o5IyaE5PMu75UjzHus24ChBlOeqwTmHRu363QXd8rsIB0ECC1qyl+U+pg8m33LZU
         ooIUUpq4LsX+QXa5yed+Q2kN4aa9ySiKC9+KaKWQ14lrZH7a9RY/iVyhPasjDCt5Gw4P
         R1uw==
X-Gm-Message-State: AOAM532ydybZZbLWfU/Pkk4RbE0KDUdwXrnedG7Q6RJH5GeXR25cliRc
        RVfI8yggviip8Gcbc9PRYKo=
X-Google-Smtp-Source: ABdhPJy261R/sNdhLo2AKcKlOYMVnTiwa28SFjDj9cxCvVv2nv2uxAynVJz2yrFu/pnQO7rnxqfq6Q==
X-Received: by 2002:a9d:2e6:0:b0:5a3:ccab:78f6 with SMTP id 93-20020a9d02e6000000b005a3ccab78f6mr4552515otl.160.1645311285566;
        Sat, 19 Feb 2022 14:54:45 -0800 (PST)
Received: from ?IPV6:2601:284:8200:b700:75f1:ca3:f2d4:114e? ([2601:284:8200:b700:75f1:ca3:f2d4:114e])
        by smtp.googlemail.com with ESMTPSA id r204sm4263441oih.1.2022.02.19.14.54.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 19 Feb 2022 14:54:45 -0800 (PST)
Message-ID: <29ff2768-ca3f-6a09-1df8-d703f85ecfac@gmail.com>
Date:   Sat, 19 Feb 2022 15:54:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH v2 3/3] net: tun: track dropped skb via kfree_skb_reason()
Content-Language: en-US
To:     Dongli Zhang <dongli.zhang@oracle.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, edumazet@google.com
References: <20220219191246.4749-1-dongli.zhang@oracle.com>
 <20220219191246.4749-4-dongli.zhang@oracle.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220219191246.4749-4-dongli.zhang@oracle.com>
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

On 2/19/22 12:12 PM, Dongli Zhang wrote:
> diff --git a/drivers/net/tun.c b/drivers/net/tun.c
> index aa27268edc5f..ab47a66deb7f 100644
> --- a/drivers/net/tun.c
> +++ b/drivers/net/tun.c
> @@ -1062,13 +1062,16 @@ static netdev_tx_t tun_net_xmit(struct sk_buff *skb, struct net_device *dev)
>  	struct netdev_queue *queue;
>  	struct tun_file *tfile;
>  	int len = skb->len;
> +	int drop_reason;

enum skb_drop_reason

