Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 653F64CA035
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 10:02:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238235AbiCBJDH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 04:03:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240287AbiCBJCw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 04:02:52 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 743BF55778
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 01:02:06 -0800 (PST)
Received: from mail-ej1-f72.google.com (mail-ej1-f72.google.com [209.85.218.72])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 14DAE3F601
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 09:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1646211725;
        bh=QomJQWW60aqn1xXIxjief+NBzPEOH/rYFFdaJYWt+s4=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=GJ6NdQcWAVYFcbQpC3Agg0k5lMqTM1E6Q3ORheN9MLZ5VD2xPQ1KhHNHxLEeUXkDt
         GY3q674e1Qff+gX9+u7BK14W+D1O/suFDQcDIaP2Cf804ahdBvC1o7W3PBMpsl+blw
         3uOrKQ+SB9tqLcZhDX4F+QaMT51JWhYawABMNb1K4GZ46Ugyq4kM9RogF8a3Ysw9+j
         LVO6FzvVaDvCpwlk8dnKxK2TNdPuZ3QdGl9K50k7QmJ9znEcMNCA8N2GfqCEacGhWc
         BnSnij6Nz9szZRzsnskQFNGVax5a3ajwErS13d6Ofkj7g8DNz7NMTgWGsPJsxTovox
         cUt/ozfUVcheQ==
Received: by mail-ej1-f72.google.com with SMTP id h22-20020a1709060f5600b006b11a2d3dcfso657087ejj.4
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 01:02:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QomJQWW60aqn1xXIxjief+NBzPEOH/rYFFdaJYWt+s4=;
        b=i6dmhOh5SDqW8csoj2BqyITZeOC5ddhwkENJJ/7hR0n+iuwjqYIuvXWE017WqPQZQ+
         4JxKsJ2INHlnEXVntIFtJjtP7sLbpPuyH8gGqVD8sBamI4F4muuJ6XPd7hCYOpuh+7B9
         sUQgdM3oJrwHnTmoX+wMAjolZBhMaNAGfdwlvSemeSwYZQA4wPhKWSxKU0M7awmaMGKB
         8CzyWfMnOvWAmkI1tFHEZoPhoUkybTCTiOlrmSQPyWMihfAHQ4TZFALHAM1PoTKYr7Br
         Me+58CpfvyinbnYvMIzknq2Xobh1JKv/VPKThYv+S4MwvHvWs7UHT74tcKJm/4ZQS4eB
         l8hw==
X-Gm-Message-State: AOAM531ejrYUoUReo4biC3hmMpqlxkTzy1jPnYdUrh2WBZaaQqXJof+n
        0nM8BX6HxKLPGjQMXFDQSRepOvtojHWYRbcgKRArWnL39VmdKy7cxKzmEDjy61/H675gGbKmZeb
        MlExdLiJhleauWKSBXm5rsGKBr7vA51UI3g==
X-Received: by 2002:a17:906:7c42:b0:6d6:da70:dfa with SMTP id g2-20020a1709067c4200b006d6da700dfamr7551681ejp.3.1646211722899;
        Wed, 02 Mar 2022 01:02:02 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxB8h5Khsmb0o4uGkd20hFjWEdLrBYDH9t8++iQordOX9aac8E/3A12jDV+2SCfpofPNHHf1A==
X-Received: by 2002:a17:906:7c42:b0:6d6:da70:dfa with SMTP id g2-20020a1709067c4200b006d6da700dfamr7551669ejp.3.1646211722655;
        Wed, 02 Mar 2022 01:02:02 -0800 (PST)
Received: from [192.168.0.136] (xdsl-188-155-181-108.adslplus.ch. [188.155.181.108])
        by smtp.gmail.com with ESMTPSA id i21-20020a1709061cd500b006da62ab503csm394763ejh.157.2022.03.02.01.02.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 01:02:02 -0800 (PST)
Message-ID: <8ac6925c-e855-fe43-21cf-6701172c003b@canonical.com>
Date:   Wed, 2 Mar 2022 10:02:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH V2] net/nfc/nci: fix infoleak in struct
 nci_set_config_param
Content-Language: en-US
To:     cgel.zte@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Minghao Chi (CGEL ZTE)" <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
References: <20220302033307.2054766-1-chi.minghao@zte.com.cn>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <20220302033307.2054766-1-chi.minghao@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/03/2022 04:33, cgel.zte@gmail.com wrote:
> From: "Minghao Chi (CGEL ZTE)" <chi.minghao@zte.com.cn>
> 
> On 64-bit systems, struct nci_set_config_param has
> an added padding of 7 bytes between struct members
> id and len. Even though all struct members are initialized,
> the 7-byte hole will contain data from the kernel stack.
> This patch zeroes out struct nci_set_config_param before
> usage, preventing infoleaks to userspace.
> 
> v1->v2:
>   -Modify the title.
>   -Add explanatory information.

Changelog goes below ---.

> Reported-by: Zeal Robot <zealci@zte.com.cn>

Why do you ignore the comment about missing report?

> Signed-off-by: Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>
> ---
>  net/nfc/nci/core.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
> index d2537383a3e8..32be42be1152 100644
> --- a/net/nfc/nci/core.c
> +++ b/net/nfc/nci/core.c
> @@ -641,6 +641,7 @@ int nci_set_config(struct nci_dev *ndev, __u8 id, size_t len, const __u8 *val)
>  	if (!val || !len)
>  		return 0;
>  
> +	memset(&param, 0x0, sizeof(param));

You ignored the comment here as well. That's not how a v2 should be
sent...  if you don't agree with comments, we need to keep discussing.

>  	param.id = id;
>  	param.len = len;
>  	param.val = val;


Best regards,
Krzysztof
