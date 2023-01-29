Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 529F467FE0A
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 11:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234827AbjA2KJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 05:09:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbjA2KJF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 05:09:05 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 924EA22785
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 02:09:04 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id y11so8366954edd.6
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 02:09:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3NvzYniCjUdMvNLayLfXu1w44hZFmfdEq8cdlL/KaMc=;
        b=oWv2J6p4QX5lN/Lfv1wTpQskHVa3yKBDoOKnyIy9dS93hwW4eMp/iXjePewFqcCHmh
         pRlGBzQX8f2/88ao1YuDUJyr+phImdkiyGcXbq4pbs4GUVqNI4BPPvwlSPYprrQVHJi0
         y8S/9+IG0uSYdajht1k2wtdlaIDQR6KwvCzFX0Y+3Z0AsjSldAaYFtG13z7z3d/PFPJa
         xi3LLe9vRZAR1SQWTPna13qMH/LSWNgYrktpNGpfhjbkRXpkat6oDi/RTOtxwLioRGsF
         kIRWQ+n22wDbIpRBJ/JVY8L/LrmiHeNsP1Olub4Os3WORCbjA++JdYfdMR9qLpgKTyUJ
         Oa5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3NvzYniCjUdMvNLayLfXu1w44hZFmfdEq8cdlL/KaMc=;
        b=1YVYod2I9ywlhOOTddEAB0foBWyg/B3FLXfvV1VdWvFO79WBETbmq+4IL5ZQaFOvzE
         U9XTCnu/Vh7+05Pwh2arplxZIsSRd4UFmPnVSr4Fzq08Hvz9nDegKlMkfpey7TymPJtR
         jZXuHZ8x5KlI0I8w//j99mZ6+QXdjezASRbLRqZS/V7ahcUqj5t1hc2hPUI0+smGS+VU
         Ic+PcMqyuUWrSrNGSA47iMrk/TrIpBo5n/T2UnkcnpyrjNzFd3qIpqrhg2+8n7xnh3rL
         9GzyE6syCvhbYli9KE/qMlxwn78X82t6G4BCPnepibThU57FDc79uKtSC+A/xlA3Qe+w
         QtTQ==
X-Gm-Message-State: AFqh2koGml4TVoAqoG8+tqd1Z8mQ80uUwR0rbfDZwnAG7n5/BNhQHrtG
        7l8qD6fpVlyB/J2tjUYb32Dqjg==
X-Google-Smtp-Source: AMrXdXuweoKw++GbL9hgqCMc192lijw6eV171Rgzfqt8dV1jPHfC8wyeoQqmjDDDJm2iS5Vt3df5ZA==
X-Received: by 2002:a05:6402:528b:b0:49e:28c1:9375 with SMTP id en11-20020a056402528b00b0049e28c19375mr49520076edb.10.1674986943085;
        Sun, 29 Jan 2023 02:09:03 -0800 (PST)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id n6-20020aa7d046000000b004a245d70f17sm59592edo.54.2023.01.29.02.09.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Jan 2023 02:09:02 -0800 (PST)
Message-ID: <bc462159-78bc-fe7e-2f58-9e02ccefdd54@blackwall.org>
Date:   Sun, 29 Jan 2023 12:09:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH net-next 10/16] selftests: forwarding: bridge_mdb: Fix a
 typo
Content-Language: en-US
To:     Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, netdev@vger.kernel.org
Cc:     bridge@lists.linux-foundation.org, Ido Schimmel <idosch@nvidia.com>
References: <cover.1674752051.git.petrm@nvidia.com>
 <064ee17ac1c20603b3530a23e0ca533d57450cfc.1674752051.git.petrm@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <064ee17ac1c20603b3530a23e0ca533d57450cfc.1674752051.git.petrm@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/01/2023 19:01, Petr Machata wrote:
> Add the letter missing from the word "INCLUDE".
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  tools/testing/selftests/net/forwarding/bridge_mdb.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/net/forwarding/bridge_mdb.sh b/tools/testing/selftests/net/forwarding/bridge_mdb.sh
> index 51f2b0d77067..4e16677f02ba 100755
> --- a/tools/testing/selftests/net/forwarding/bridge_mdb.sh
> +++ b/tools/testing/selftests/net/forwarding/bridge_mdb.sh
> @@ -1054,7 +1054,7 @@ ctrl_igmpv3_is_in_test()
>  
>  	bridge mdb del dev br0 port $swp1 grp 239.1.1.1 vid 10
>  
> -	log_test "IGMPv3 MODE_IS_INCLUE tests"
> +	log_test "IGMPv3 MODE_IS_INCLUDE tests"
>  }
>  
>  ctrl_mldv2_is_in_test()


Oops :)

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>

