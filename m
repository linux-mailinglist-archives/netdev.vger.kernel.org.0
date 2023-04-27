Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA2976F0112
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 08:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242994AbjD0Gxz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 02:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243076AbjD0Gxy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 02:53:54 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AAC9422B
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 23:53:51 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-94a342f7c4cso1498775166b.0
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 23:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20221208.gappssmtp.com; s=20221208; t=1682578430; x=1685170430;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0Bnn+L98JN/4qM0e+6n+AjRFLAPjUcjxPVKyMKFNko0=;
        b=x+KCZM1mYhkNteSG9XZJVMVIR74VJjHNNbwvscrxLPCuUKv1T2NVXmvn0tM92oZfwU
         UL4fZvgN7URR8n2+hjv9x3vF0QLUGSSEDTCIYGSh5hYAJNbd4jk2hpgjic3Im+yLlc5s
         RGNXSD7vJJ9j9v/Dbhlpv5k+XYTUlCaE4xn7Fk8aSFKrOuQTsGFiaXiMDQ+tkciiumxg
         j+WzmYFWRUrRiAVXYZ4cecBdZf+6XdBCs1v2MoHWlPGskhd+BUntZ1kuAj/BnLAakpPQ
         PG6l8Qaa4fDumGHNgWxywl0ae9qYfD5gQpeO7hzbA98965qBcDJ/BLF8joiLKyJ8grfi
         Hrrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682578430; x=1685170430;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0Bnn+L98JN/4qM0e+6n+AjRFLAPjUcjxPVKyMKFNko0=;
        b=mBH7K5vZWXFl9CF4KrylmzTSlnN5kQ6k0cRl474G5xRbbHs66tQDY3VhpynabqqHQZ
         WlM9ZrGxC2vw/Oq/89q0/MFvRyXZetOckhtPrYDPw6x0UPPuKtRefFFoLVXQd3nUAHY5
         V4ahjblN0YG12Z/Ypz9vvJ6CZFd+YbXaXZ5hy6aNrZicgnTvaEEVbkjn9tggpsLh2ozR
         Recd29LpyEKs6CVKeIH0bLDHcsLDb4NUtTJ9U2R7X5hQuDFBfV29m+fR8pGmEW0j7OwP
         iVUXWer3LVQ5glVoIoqcKs7lPUJCKo/3+skJyHAWW8DQWrYqMl0zZIoqh4PDCsUo93UW
         4m6A==
X-Gm-Message-State: AC+VfDzKauxHBSxGk4DkjTobD1KIWn+h6DbhVGQXHg9oYiyMcP8duMzy
        AaCsMNVrH4gPxfhggfkaxWf2WwvSp/pFXw53R4I=
X-Google-Smtp-Source: ACHHUZ6ISfZV8uSG+2XXTlduM8XRLGWsKZByg3dxWjwS6/5+547JQZK1yIEoAIm2bHeRG3dNPDT7Dw==
X-Received: by 2002:a17:907:8687:b0:94a:5819:5a2b with SMTP id qa7-20020a170907868700b0094a58195a2bmr550910ejc.33.1682578429614;
        Wed, 26 Apr 2023 23:53:49 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id pv4-20020a170907208400b0094f49f58019sm9112667ejb.27.2023.04.26.23.53.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Apr 2023 23:53:49 -0700 (PDT)
Message-ID: <13c54cd1-6fb7-b6b8-79a1-af0a95793700@blackwall.org>
Date:   Thu, 27 Apr 2023 09:53:48 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net] selftests: bonding: delete unnecessary line.
Content-Language: en-US
To:     Liang Li <liali@redhat.com>, netdev@vger.kernel.org
Cc:     j.vosburgh@gmail.com, Hangbin Liu <liuhangbin@gmail.com>
References: <20230427034343.1401883-1-liali@redhat.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230427034343.1401883-1-liali@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/04/2023 06:43, Liang Li wrote:
> "ip link set dev "$devbond1" nomaster"
> This line code in bond-eth-type-change.sh is unnecessary.
> Because $devbond1 was not added to any master device.
> 
> Signed-off-by: Liang Li <liali@redhat.com>
> Acked-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  .../selftests/drivers/net/bonding/bond-eth-type-change.sh        | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/tools/testing/selftests/drivers/net/bonding/bond-eth-type-change.sh b/tools/testing/selftests/drivers/net/bonding/bond-eth-type-change.sh
> index 5cdd22048ba7..862e947e17c7 100755
> --- a/tools/testing/selftests/drivers/net/bonding/bond-eth-type-change.sh
> +++ b/tools/testing/selftests/drivers/net/bonding/bond-eth-type-change.sh
> @@ -53,7 +53,6 @@ bond_test_enslave_type_change()
>  	# restore ARPHRD_ETHER type by enslaving such device
>  	ip link set dev "$devbond2" master "$devbond0"
>  	check_err $? "could not enslave $devbond2 to $devbond0"
> -	ip link set dev "$devbond1" nomaster
>  
>  	bond_check_flags "$devbond0"
>  

I don't think this is -net material. But either way the patch looks good.
