Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46ED16BF17A
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 20:11:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbjCQTLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 15:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjCQTLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 15:11:40 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93172D7C20;
        Fri, 17 Mar 2023 12:11:38 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id y4so24304144edo.2;
        Fri, 17 Mar 2023 12:11:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679080297;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=60jQnIE0z011E/nipdT9TDjgG3QEglLPRrgCcdTJhoY=;
        b=DYa3zsqMdFZuMiXOQ6WQDG/9EKJwwIgjrHQRcM+EoRU3W9Fc9szFxjb4zMzw+i0a7m
         R5RFGCKL2niB9EBYc/U2WkiqgNWOJsWIpa4e+ijptGZY2QQ0+m3nLlKy6Q7OzWBuEAtI
         NE1Oa+B/Tdtc+E+Oh14lTLaVc+X9tpXe3NF89FCYkMBsF/WhD/WVxEzMOfvIGwcnyRrS
         xAaZyph0BZUIHVORDzNmUEPSu9SzncnxEFHLZPz+GZEFIxO1vcdgvz3B5Nz8EOStHkX2
         TB0fqSYsWm1erZazH2zqKMcOZO4aR6z8bs/fRN6/pmjzzNk4UhSy/wvWre/tL8CsnvKI
         iISQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679080297;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=60jQnIE0z011E/nipdT9TDjgG3QEglLPRrgCcdTJhoY=;
        b=G/sGwWFW1C8OnBIiApRFiQVgj2uNbvTzrTR2BPhlFCQWHd4oQ9VhQpdNRjt76Kpiyi
         Po85+673mxF2P/ir3R2qcazemmdokAgrGd0gxtBWXs2KpAHy48/ZVSg5rOONsltMDZc4
         UnjqSErstfSZyLBz1SQ78f4AIbKsDracdmNrH8eecm52IsmD60d8umaBc/PDnMOuIWDK
         uLw4x2keXOboI8B5glsLnH9H/05ZhIX5i1BF/RlnIV7E2d8Bae2FEbbox5RS3eP6Olnb
         /sKu8ONLjysrg7ZbUpQUk/YSEsQ/BnPn+u7+ZMP30PpR2WdIPJLBd2euV1Q5bdufAmUb
         6h5w==
X-Gm-Message-State: AO0yUKVQaO8CBUL/A6Ia9KheyiqPpVrR1IrRfE5/1r7taDemWEoSsVes
        1BhYTca+tSd9qeIRKD+9hl8=
X-Google-Smtp-Source: AK7set9CcKyskSm7Jc8DN3kRofSMf7p7wWmS8YCYA9/7+SS4ML0cq+imGn8XHOXsRcMo8Z4AwyOCjQ==
X-Received: by 2002:a17:906:bc8c:b0:86a:316:d107 with SMTP id lv12-20020a170906bc8c00b0086a0316d107mr350662ejb.72.1679080296986;
        Fri, 17 Mar 2023 12:11:36 -0700 (PDT)
Received: from shift (p5b0d7c06.dip0.t-ipconnect.de. [91.13.124.6])
        by smtp.gmail.com with ESMTPSA id t23-20020a1709063e5700b00930b13f6abdsm1290540eji.98.2023.03.17.12.11.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 12:11:36 -0700 (PDT)
Received: from localhost ([127.0.0.1])
        by shift with esmtp (Exim 4.96)
        (envelope-from <chunkeey@gmail.com>)
        id 1pdFTQ-00052U-1u;
        Fri, 17 Mar 2023 20:11:36 +0100
Message-ID: <03e1c436-f2c4-f227-0cd9-ea12afbda1fc@gmail.com>
Date:   Fri, 17 Mar 2023 20:11:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH][next] wifi: carl9170: Replace fake flex-array with
 flexible-array member
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <ZBSl2M+aGIO1fnuG@work>
Content-Language: de-DE
From:   Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <ZBSl2M+aGIO1fnuG@work>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/17/23 18:39, Gustavo A. R. Silva wrote:
> Zero-length arrays as fake flexible arrays are deprecated and we are
> moving towards adopting C99 flexible-array members instead.
> 
> Address the following warnings found with GCC-13 and
> -fstrict-flex-arrays=3 enabled:
> drivers/net/wireless/ath/carl9170/tx.c:702:61: warning: array subscript i is outside array bounds of ‘const struct _carl9170_tx_status[0]’ [-Warray-bounds=]
> drivers/net/wireless/ath/carl9170/tx.c:701:65: warning: array subscript i is outside array bounds of ‘const struct _carl9170_tx_status[0]’ [-Warray-bounds=]
> 
> This helps with the ongoing efforts to tighten the FORTIFY_SOURCE
> routines on memcpy() and help us make progress towards globally
> enabling -fstrict-flex-arrays=3 [1].
> 
> Link: https://github.com/KSPP/linux/issues/21
> Link: https://github.com/KSPP/linux/issues/267
> Link: https://gcc.gnu.org/pipermail/gcc-patches/2022-October/602902.html [1]
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Acked-by: Christian Lamparter <chunkeey@gmail.com>

FYI: Also uploaded that patch to carl9170fw.git.

Cheers,
Christian

