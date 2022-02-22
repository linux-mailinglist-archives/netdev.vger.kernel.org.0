Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9193D4BF05A
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 05:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240788AbiBVDUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 22:20:47 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241014AbiBVDUo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 22:20:44 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6BEB193F8;
        Mon, 21 Feb 2022 19:20:10 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id c18so15914340ioc.6;
        Mon, 21 Feb 2022 19:20:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=byRYyFHF1RfzOq4HLIneApDEfH4u8IiUuf/rJRXw2TE=;
        b=TJ07BWtF6OCGG5MEaK5reraVvmo57yyHKf2yxmjI9eRrja9HJpCqAp8i3Hpil+raCc
         8x2A/EEjne4doxfSgMAnZkRDTogvda4grCCvc4kMUFh3ZSJAXf5tlxaGbiYgGll9RWjs
         M9A8geSWxEKq7AzJ5MSBB5g1lo/u7uEO2jiZ/AchKD8+4G4uGGZ2Ba4ea87TX7889fqS
         5dd3GTQIKNAaCeu+4Ex7i3imcakT23x9oFmfCJjECz5weZSQvpvitrCGRimV8Xqzkro/
         vLhCCjkMsNphSvXuSShaKqQXcYwlfTIMfIRw5Knd7qjS8MGth/H01vGOAI80nVyr23/S
         jAkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=byRYyFHF1RfzOq4HLIneApDEfH4u8IiUuf/rJRXw2TE=;
        b=VvZZPCPNQgsH2CR2q0p5LyAJEuC/5xqlvLOGYhWoUJRTcPAtvoZN4PHdM1sBFn2COX
         3rl8Vq/4evDOG7f6xDSKkyxGHLlvZg9DgnYUGHwf6mE+nrss0qZO1Gjfpy28ERJDxHsP
         zDqtWXePs/B0jBsMJxuzkVpcXS7xNmTOPzPnTO5RjuXqz0et3bQg8V69TVovPu3hgHxw
         VBEXdJuq8gaZPZ9b2OO1kWbtg67KzafvUFq7uY/EMLTrmhXx2sBIQq3boG+fHAydUtwZ
         puMr9KHpFrTXdU8EuZ3qCP+dTF4Upn7Mo2Z8RnZja48cEyRPDwMMi4amUzoMZmUYNtWN
         P4Iw==
X-Gm-Message-State: AOAM53266iDVNJXLxHubUFhlgX1oxRgdvkwcaqppitlQQ4LHYzuvlVvC
        Hj/RImTYHcX742I7ZtdRSlAL+zPdGwSPyQ==
X-Google-Smtp-Source: ABdhPJyN2Mwd+CudxyzholjEEEfvuTP0QZs8IL1dNYZ66tk1WVh9ViGhrbbkXImRcctbAwcKH8ykAQ==
X-Received: by 2002:a02:bb05:0:b0:314:57b4:6af3 with SMTP id y5-20020a02bb05000000b0031457b46af3mr16831289jan.244.1645500005052;
        Mon, 21 Feb 2022 19:20:05 -0800 (PST)
Received: from ?IPV6:2601:284:8200:b700:fc7f:e53f:676e:280d? ([2601:284:8200:b700:fc7f:e53f:676e:280d])
        by smtp.googlemail.com with ESMTPSA id e6sm8400023ile.49.2022.02.21.19.20.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 19:20:04 -0800 (PST)
Message-ID: <3a81db69-2900-f750-6ac2-d2f4fc710768@gmail.com>
Date:   Mon, 21 Feb 2022 20:20:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.0
Subject: Re: [PATCH net-next v3 1/4] skbuff: introduce kfree_skb_list_reason()
Content-Language: en-US
To:     Dongli Zhang <dongli.zhang@oracle.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rostedt@goodmis.org, mingo@redhat.com, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, imagedong@tencent.com,
        joao.m.martins@oracle.com, joe.jin@oracle.com, edumazet@google.com
References: <20220221053440.7320-1-dongli.zhang@oracle.com>
 <20220221053440.7320-2-dongli.zhang@oracle.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220221053440.7320-2-dongli.zhang@oracle.com>
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

On 2/20/22 10:34 PM, Dongli Zhang wrote:
> This is to introduce kfree_skb_list_reason() to drop a list of sk_buff with
> a specific reason.
> 
> Cc: Joao Martins <joao.m.martins@oracle.com>
> Cc: Joe Jin <joe.jin@oracle.com>
> Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
> ---
>  include/linux/skbuff.h |  2 ++
>  net/core/skbuff.c      | 11 +++++++++--
>  2 files changed, 11 insertions(+), 2 deletions(-)
> 
>

Reviewed-by: David Ahern <dsahern@kernel.org>


