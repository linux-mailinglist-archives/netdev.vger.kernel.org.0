Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD4E164B78F
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 15:38:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235644AbiLMOic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 09:38:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235968AbiLMOib (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 09:38:31 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63CE110F
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 06:38:30 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id z4so3477968ljq.6
        for <netdev@vger.kernel.org>; Tue, 13 Dec 2022 06:38:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9DSRAfj/GeVhhsDJc81FoIFPM4IbRGLXxfzj+j+loV8=;
        b=p3j5uxJGjCNMXZT1RH56Y2EcdlxPvDcj/hXFtCFJLsk9ghFEc1AgeBk997yKYlVhZE
         mslk8Itj4osgQhT7dgENbmYwgfjQ3uLkqPQLzw60uslPT9PMeLsqW7A69t9esyCx1Pm9
         XYNLVucGbbGSFsIbYvbBG+Fnqs1CPgkhNxR84JLrWYa7f73WFpIbpViowgdfuTAoM6lq
         QHJsnnfZUjnKC8z0eaSAb6tNWHOf9GYJaDOQTXSg0hsIp5rO2ZSLeXYDgjL5NiQo3qdo
         hRJOUPKiwRZHA6GWpGyNEsSAVfwdHGeNCKjr+ZDAWL0ad0Qf1QXcFPeFYCOsFrbo0TyO
         iHqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9DSRAfj/GeVhhsDJc81FoIFPM4IbRGLXxfzj+j+loV8=;
        b=gxzdgtiRx+veP2P8AMCU5mj04Y6yJ1bzC80UQBzAwnFjJCdBuPRsCksrAcke7j3/Ps
         Xf0lJ6CLgWdy9mJQf+emU//tb/vu035gvczWqks4eCuNTDHpLvTJ+WRKFk0ntbZwThxt
         DxNgZ4pXYW3ggBfbzMCzJQWZhYfkhg3wAokJsUT12LdOAKnXfCC2CPLZBNOgyRHxdiyl
         51JuoqtlkOysekwKPXB9FBy+Xy0BiGxw4TcfUOW+MEDxuiLlQ1rAVmLU4NCWcAQdnZcz
         MCvkpJkyGh2jsByz6p0X9Sy5pdBt/v8iaRXg5Al9Ifan+eeoLJjzrwjxpPDlEY3379vU
         ZGNg==
X-Gm-Message-State: ANoB5pm6oMG2ZJYx58t1t/PqNP30BERgfjqSTOLolk4J7byBeWsCnObP
        8B3c2ZJ14EbyCYhvUcliZ/5ziF8jSHOnLsyU
X-Google-Smtp-Source: AA0mqf7CDNjP9IoJ/TrrzZHhBbFOccumWeoc55pEm9lMjL1McOtVjaNdmQpiHGOTHDVclHD8LVQOJw==
X-Received: by 2002:a2e:9184:0:b0:27a:129f:770e with SMTP id f4-20020a2e9184000000b0027a129f770emr4621385ljg.5.1670942308754;
        Tue, 13 Dec 2022 06:38:28 -0800 (PST)
Received: from [192.168.0.20] (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id f27-20020a05651c02db00b00279a5869476sm284255ljo.6.2022.12.13.06.38.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Dec 2022 06:38:28 -0800 (PST)
Message-ID: <decda09c-34ed-ce22-13c4-2f12085e99bd@linaro.org>
Date:   Tue, 13 Dec 2022 15:38:27 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH net v2] nfc: pn533: Clear nfc_target before being used
Content-Language: en-US
To:     Minsuk Kang <linuxlovemin@yonsei.ac.kr>, netdev@vger.kernel.org
Cc:     linma@zju.edu.cn, davem@davemloft.net, sameo@linux.intel.com,
        linville@tuxdriver.com, dokyungs@yonsei.ac.kr,
        jisoo.jang@yonsei.ac.kr
References: <20221213142746.108647-1-linuxlovemin@yonsei.ac.kr>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20221213142746.108647-1-linuxlovemin@yonsei.ac.kr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/12/2022 15:27, Minsuk Kang wrote:
> Fix a slab-out-of-bounds read that occurs in nla_put() called from
> nfc_genl_send_target() when target->sensb_res_len, which is duplicated
> from an nfc_target in pn533, is too large as the nfc_target is not
> properly initialized and retains garbage values. Clear nfc_targets with
> memset() before they are used.
> 
> Found by a modified version of syzkaller.
> 
> BUG: KASAN: slab-out-of-bounds in nla_put
> Call Trace:
>  memcpy
>  nla_put
>  nfc_genl_dump_targets
>  genl_lock_dumpit
>  netlink_dump
>  __netlink_dump_start
>  genl_family_rcv_msg_dumpit
>  genl_rcv_msg
>  netlink_rcv_skb
>  genl_rcv
>  netlink_unicast
>  netlink_sendmsg
>  sock_sendmsg
>  ____sys_sendmsg
>  ___sys_sendmsg
>  __sys_sendmsg
>  do_syscall_64
> 
> Fixes: 673088fb42d0 ("NFC: pn533: Send ATR_REQ directly for active device detection")
> Fixes: 361f3cb7f9cf ("NFC: DEP link hook implementation for pn533")
> Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

How did it happen? From where did you get it?

> Signed-off-by: Minsuk Kang <linuxlovemin@yonsei.ac.kr>
> ---
> v1->v2:
>   Clear another nfc_target in pn533_in_dep_link_up_complete()
>   Fix the commit message
> 


Best regards,
Krzysztof

