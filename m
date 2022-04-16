Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDE350380F
	for <lists+netdev@lfdr.de>; Sat, 16 Apr 2022 21:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232906AbiDPTnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Apr 2022 15:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232907AbiDPTnN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Apr 2022 15:43:13 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 471FC33A37
        for <netdev@vger.kernel.org>; Sat, 16 Apr 2022 12:40:41 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id j8-20020a17090a060800b001cd4fb60dccso10906955pjj.2
        for <netdev@vger.kernel.org>; Sat, 16 Apr 2022 12:40:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=NKb5Y3Uk/HFO/PmfN09xsIBX8sb9ivnN7BMJ4T5K3Yc=;
        b=frdMxC6C1Q5c+ym/j33wqxbos/WasWbgN1T2A+x1Hp8FQt46JcLmcmjpz6whbc+RF+
         D930TSyR+hp5r0N1xZ5HtGMJITG8PGt92kyi2RunbzHPJ6iuSixqLZdQy8eJzmI9GYvz
         GRFYH0J4vkeAA8liu9EIAGrbcIfO6ATl9BF77xKAIQTtznS3I03v3RjiFEYlQT1Y/OBb
         Venr/LShu/k/O0ZMDKHlJCrfs29JrhXqre3vq+MkedPt88PFF5UdX6PSmQR6fpJ7iKct
         iTzBDQs8Ewb+dCYAXc4MpTk0UR30T0M0p9/WK13niJVlrV82gbRnE18qMlVdPtHVIG7U
         TyAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=NKb5Y3Uk/HFO/PmfN09xsIBX8sb9ivnN7BMJ4T5K3Yc=;
        b=798DgNck/akPO00mhSfLcyNLhHLG8uAyDbrcQLCUCdzQAfGbpeu4fPZulRRqQbxjzz
         HWcf5W3zWua6NTRBHNVZv3D17SzXcEYQC8UTM9ZqKVpTgoEdVBvaDrbxWCbnQrQPmyIe
         rpCPrC/MOfKKIftLMOYkqTXcSuFUmBMJ7+slpXDdzGMKB4u/zEx/LBeL38O7ZTrPidso
         A5uinQ+iwjpKcI1qYpkR8my+d+TB0fwc5Q3PliePyRcHh+lZLb7/SLtOOx8Nt1/KlOmk
         CiJ5d5wYKMpl0LtK8AzihhpwtBdO4ybPce1/AvXmxeoBQd7XoCDLSfjf8jTgpM6aoOl8
         0jyA==
X-Gm-Message-State: AOAM530ZjQvYAfSZQOzI3T2Yg4mNiHbuFHmbK3ThDDwnJ12Gz4yTAxAl
        zQSIAOnNjHAZmdr+8avvMK8=
X-Google-Smtp-Source: ABdhPJxJAPTJhVl4IO3pO74eOzfaY+pYuXtSxBZTRheUWqESXUAgRYcLCXNXQYbFD+WNwQZsn8v/sQ==
X-Received: by 2002:a17:902:d344:b0:158:4bd9:34a7 with SMTP id l4-20020a170902d34400b001584bd934a7mr4697808plk.22.1650138040550;
        Sat, 16 Apr 2022 12:40:40 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id v18-20020a17090a899200b001d22f3fe3e2sm2805290pjn.35.2022.04.16.12.40.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Apr 2022 12:40:39 -0700 (PDT)
Message-ID: <7c67ed7c-7ee6-c095-e9c6-5a5ad36e8840@gmail.com>
Date:   Sat, 16 Apr 2022 12:40:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH net] net: dsa: hellcreek: Calculate checksums in tagger
Content-Language: en-US
To:     Kurt Kanzenbach <kurt@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
References: <20220415103320.90657-1-kurt@linutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220415103320.90657-1-kurt@linutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/15/2022 3:33 AM, Kurt Kanzenbach wrote:
> In case the checksum calculation is offloaded to the DSA master network
> interface, it will include the switch trailing tag. As soon as the switch strips
> that tag on egress, the calculated checksum is wrong.
> 
> Therefore, add the checksum calculation to the tagger (if required) before
> adding the switch tag. This way, the hellcreek code works with all DSA master
> interfaces regardless of their declared feature set.
> 
> Fixes: 01ef09caad66 ("net: dsa: Add tag handling for Hirschmann Hellcreek switches")
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
