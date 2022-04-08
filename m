Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB0A04F98EC
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 17:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237337AbiDHPEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 11:04:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233704AbiDHPEv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 11:04:51 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DD53267AF5;
        Fri,  8 Apr 2022 08:02:47 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id a2so4021412wrh.5;
        Fri, 08 Apr 2022 08:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XWPynbA+VvHB2iSPSS71KhwO0dSYse4f1BplmAMKeV8=;
        b=GML5dlTj2OGqeK3rxya07wSKsMrsHRTrTLqrTmuGhkImcNnQE8PKmuiRWpr3aKxrVs
         lF2Rln8Ai5vMDMBWmU79daQTp527+gQrqCSIlGYqgkwZo5XSziztH88T5gBFjY/xrfL3
         dRUdgCOPuHNfO1IGtlQejFbBEdX3CWH3d1KNAWQKeI4uvQ96DjRWSdeo09AT0+h0dy/4
         6DiNoLnqAk+oeuJC4vDPFW2cOJ0JaojWsbh1U+YaYuQrSNuvTv5bk0LsjmtcuvjhhLk7
         tUCaQG1PTYGY+28udFo/6T5CqrJsrXNjLVmCS7NuI4Q+l5MwdfBAdOebDuYUVcoDv4iP
         Dt1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XWPynbA+VvHB2iSPSS71KhwO0dSYse4f1BplmAMKeV8=;
        b=1ktqk4zqzSg5eZyBMEFoyvt3q4YI0jIXRK9OfaGr+44AfYpbBy9v42bCntYVRvZBm+
         F7fbSwokiqaJ8rE4E0DKApb+2CPnm9x0b2innqpEa4E/hCTY0IbbngJ2ii9raI+1OT7N
         rZj6Q3ae9TB3HzQ7XQVn+J58KxHbUvGWsSq9OnU5oNCqrLHF0fukd6BWFu0dRRXgjsmj
         /toQUX0WBCKJKuJji9ifRjWeOP5R3EnLzzi7NEjwbevcFEmtAN0Wn5jnUEheEj2lJpxP
         PiT6ywDaSdO4WXg/WjNj9RiTJf4d0s+WuzGTJtOGkKfSYGQU3UE0gr7JIt7uqUGy5/Z0
         0tsQ==
X-Gm-Message-State: AOAM5328G9i4+SoO0MNL9eGYtyefc9eNzv5j4z1cs+kBV4IJgFlfbEhF
        hgXMU1iLK8yZLn8PFMknyWh5JjrzpaDhQg==
X-Google-Smtp-Source: ABdhPJwkc85x/7947LZIzx7niHX9hJrt6asWjl+mEuW1s0FlUGdKngYjJ2aIKOeB0cu8Mzsvqt2fUw==
X-Received: by 2002:a5d:588a:0:b0:204:1f46:cf08 with SMTP id n10-20020a5d588a000000b002041f46cf08mr15288625wrf.133.1649430165509;
        Fri, 08 Apr 2022 08:02:45 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id p125-20020a1c2983000000b0038e5ca446bcsm10830627wmp.5.2022.04.08.08.02.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Apr 2022 08:02:45 -0700 (PDT)
Subject: Re: [PATCH] sfc: ef10: Fix assigning negative value to unsigned
 variable
To:     Haowen Bai <baihaowen@meizu.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1649383888-2745-1-git-send-email-baihaowen@meizu.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <e2e85510-f4ad-d983-f76c-b678bc9e397e@gmail.com>
Date:   Fri, 8 Apr 2022 16:02:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <1649383888-2745-1-git-send-email-baihaowen@meizu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08/04/2022 03:11, Haowen Bai wrote:
> fix warning reported by smatch:
> 251 drivers/net/ethernet/sfc/ef10.c:2259 efx_ef10_tx_tso_desc()
> warn: assigning (-208) to unsigned variable 'ip_tot_len'
> 
> Signed-off-by: Haowen Bai <baihaowen@meizu.com>
> ---
>  drivers/net/ethernet/sfc/ef10.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
> index 50d535981a35..1434510dbdc9 100644
> --- a/drivers/net/ethernet/sfc/ef10.c
> +++ b/drivers/net/ethernet/sfc/ef10.c
> @@ -2218,7 +2218,7 @@ int efx_ef10_tx_tso_desc(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
>  	u16 outer_ipv4_id = 0;
>  	struct tcphdr *tcp;
>  	struct iphdr *ip;
> -	u16 ip_tot_len;
> +	s16 ip_tot_len;

The debug-warning on line 2260 relies on this being unsigned; it would
 be preferable to change the assignment on the line above to cast the
 value to u16, or to assign "0x10000 - EFX_TSO2_MAX_HDRLEN", since that
 is the actual semantics of the value.

-ed

>  	u32 seqnum;
>  	u32 mss;
>  
> 

