Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB19A6C82A0
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 17:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231783AbjCXQuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 12:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbjCXQuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 12:50:12 -0400
Received: from mail-oa1-x2b.google.com (mail-oa1-x2b.google.com [IPv6:2001:4860:4864:20::2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49C50132E9;
        Fri, 24 Mar 2023 09:50:11 -0700 (PDT)
Received: by mail-oa1-x2b.google.com with SMTP id 586e51a60fabf-17683b570b8so2286303fac.13;
        Fri, 24 Mar 2023 09:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679676610;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=1DGyIN34KgC0DU/dG7K0bXU7qcx4+HSMWL/GkKHyPhI=;
        b=bVwiBdzRLa1lsfOcclAi6GO+XbR6MVA+A6vuIkAiHb0mxBUtxOM1o+zrR8eExLmPMy
         QU4tTuE9ywhDKtQEbvYF2Fikp0sWcexTw68YVUiO0vwQGyWvABK/Qc5op/kOvpSKUd2e
         VlsVl/ClswPrkfpaj7k+YqIFu496lXYE39yXf1gHk9dHgbk9dDMBYmuEm/wUitBVVd+X
         lKc9DWaeVXTmkPwH1wUc/J3H5VE7UvDnSDdefpnrfjH+9FaMpH/xdjh38E7lXBASsZSI
         iN4Q0YP8WpCt2moeemCX8OJY6fxC5jvC/51XqI9uTZjRbiCh1pUdoV5iKUjd/7aPhNqi
         GhMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679676610;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1DGyIN34KgC0DU/dG7K0bXU7qcx4+HSMWL/GkKHyPhI=;
        b=ye/aOYgfOUUg74ZVhkcgmRwp4cOX39RXtZYKcqRsOa2hPCNzKIa8TkKGBR1vhFTAjo
         QG1iPqG0x6Qw4H3yj9DMwMxrRdYJOubtySFpkgIP+DsZg0ax1KuBz28q6aIcse3OTzcd
         GFedFYWDq8BMQnJKiyiPR33BHgYSp+j8Qg3hJuShQ4jbtQT9Umm/CzBk7U7+t6gT5ZBF
         eIak+najQ/fQF+i+omsHZxkTuUCY6zz2tHxqXJSsjChAv5GYY0acNbwHKIr19e15QbCm
         njtQtMs3BozAlsNIqRlK6++vYGMXnqFp2b9odH1K+vUP6XBvXxSbOhccCVTjHsUPP9fi
         h4Bg==
X-Gm-Message-State: AAQBX9fYCPuNQ+/gRLp7nRuP0dcyN7hSpKgdXaWNqdW+NUzmKcwITs7D
        2+DsTcD/XwfkZ8cCnKafRbg=
X-Google-Smtp-Source: AKy350YegC9Y5rZlLkkMA6KNYBOntyayTAXqWSJGwsQUTpx9mVId6Lbu7ZViY22SLpFM8rSCQ2JFTQ==
X-Received: by 2002:a05:6870:1608:b0:17e:9798:6e34 with SMTP id b8-20020a056870160800b0017e97986e34mr2398934oae.32.1679676610509;
        Fri, 24 Mar 2023 09:50:10 -0700 (PDT)
Received: from [192.168.0.162] ([216.130.59.33])
        by smtp.gmail.com with ESMTPSA id ea43-20020a056870072b00b0017e0c13b29asm2345970oab.36.2023.03.24.09.50.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 09:50:10 -0700 (PDT)
Sender: Larry Finger <larry.finger@gmail.com>
Message-ID: <892fdfe5-ef22-a37a-20bc-912e67d6df4e@lwfinger.net>
Date:   Fri, 24 Mar 2023 11:50:08 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] b43legacy: remove unused freq_r3A_value function
Content-Language: en-US
To:     Tom Rix <trix@redhat.com>, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        nathan@kernel.org, ndesaulniers@google.com
Cc:     linux-wireless@vger.kernel.org, b43-dev@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
References: <20230324135022.2649735-1-trix@redhat.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
In-Reply-To: <20230324135022.2649735-1-trix@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/24/23 08:50, Tom Rix wrote:
> clang with W=1 reports
> drivers/net/wireless/broadcom/b43legacy/radio.c:1713:5: error:
>    unused function 'freq_r3A_value' [-Werror,-Wunused-function]
> u16 freq_r3A_value(u16 frequency)
>      ^
> This function is not used so remove it.
> 
> Signed-off-by: Tom Rix<trix@redhat.com>
> ---
>   drivers/net/wireless/broadcom/b43legacy/radio.c | 17 -----------------
>   1 file changed, 17 deletions(-)

Acked-by: Larry Finger <Larry.Finger@lwfinger.net>

Thanks,

Larry

