Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9829F625591
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 09:44:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233250AbiKKIop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 03:44:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbiKKIon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 03:44:43 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E6D077202;
        Fri, 11 Nov 2022 00:44:42 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id o4so5555631wrq.6;
        Fri, 11 Nov 2022 00:44:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=v4c1vWTv1GfIFv4FejqWxX3mxKdVbbgHYO6F6Nc9yOY=;
        b=EafFpKN2+LMnRJJXIorUl5YAPj/pbU3D42b4GqlqWPqxYqkvYzTMNs937HOW6b5wm1
         FXKusGms/isQXr9V0h/XUesFhud1SlSsTCqiaXFa23eMG2gDVoC34Y2vmHcLVmpNB99+
         tuOMhSg9ELl3wVJigGWzscLAjCJCHFl8E/4qVnP57yPkULYF2EGaRLym02/uTi0t3oJJ
         dnfh8r+AzgaOT9JEYKn/UWTr7ILs/I2URyb3bauINGYDlbpUCa0KwkfeemqByic1Srl6
         GyfYOwStnEC4mpbzMfcxw5JOEkg5qz9kBf3ZX0Pw8vTxRYn2SZeY12tePzuYtXvnB3Iz
         g9nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v4c1vWTv1GfIFv4FejqWxX3mxKdVbbgHYO6F6Nc9yOY=;
        b=XKtZbMGAePqssiiIibebvFiEggLi9nRmorMmf38riqi05wRliX0cswU5XGucHNjnsA
         /z/8qnB7UjZgl52ugBp5/iqLDHlbTDWHGQYiYNhuqFKHEAGVULbFvPQdTMV9sB4i/xp+
         OmvagEDgSeJxtUgu4pnm2vW0bTveUgDIsDkWgC5YRPqtQIDs1i7QG12AZrypNjwAn2YC
         tVkd6673HIypuLOzNALNmI0/jwUQDp6Tt4fZ3LpwnnBaefSXE+WdXIECgj255tkI26up
         pFq4zGHcvDBD3pQtR3FGJAMR6WZD6OCmvb/3kF8b6CFEK+ztFfQugObBzef+CZgXvn5O
         RY9w==
X-Gm-Message-State: ANoB5pmhGfvLjHdpWASy6sXLovshI7lMlSo0q7m+/0hEMHekkV2jsHCi
        ntAg1bsvqbERclHsE0XhtaU=
X-Google-Smtp-Source: AA0mqf5a0ZFm7qyv5Y27nujbB0ybS2Cgt6RYgcSeHFFMzInDq7yW17Vrlc/b7wm+2kvtSDbTLGvOYg==
X-Received: by 2002:adf:eb45:0:b0:22c:deef:de9e with SMTP id u5-20020adfeb45000000b0022cdeefde9emr596861wrn.333.1668156280853;
        Fri, 11 Nov 2022 00:44:40 -0800 (PST)
Received: from [192.168.1.131] ([207.188.167.132])
        by smtp.gmail.com with ESMTPSA id az9-20020adfe189000000b002367ad808a9sm1337674wrb.30.2022.11.11.00.44.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Nov 2022 00:44:39 -0800 (PST)
Message-ID: <eb1ac3e7-8652-6690-0f86-b46b6a1e0cb8@gmail.com>
Date:   Fri, 11 Nov 2022 09:44:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH v4 net-next 0/8] introduce WED RX support to MT7986 SoC
Content-Language: en-US
To:     patchwork-bot+netdevbpf@kernel.org,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, nbd@nbd.name, john@phrozen.org,
        sean.wang@mediatek.com, Mark-MC.Lee@mediatek.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-mediatek@lists.infradead.org,
        lorenzo.bianconi@redhat.com, Bo.Jiao@mediatek.com,
        sujuan.chen@mediatek.com, ryder.Lee@mediatek.com,
        evelyn.tsai@mediatek.com, devicetree@vger.kernel.org,
        robh+dt@kernel.org, daniel@makrotopia.org,
        krzysztof.kozlowski+dt@linaro.org,
        angelogioacchino.delregno@collabora.com
References: <cover.1667687249.git.lorenzo@kernel.org>
 <166815481641.32563.14048666303133746703.git-patchwork-notify@kernel.org>
From:   Matthias Brugger <matthias.bgg@gmail.com>
In-Reply-To: <166815481641.32563.14048666303133746703.git-patchwork-notify@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On 11/11/2022 09:20, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This series was applied to netdev/net-next.git (master)
> by David S. Miller <davem@davemloft.net>:
> 
> On Sat,  5 Nov 2022 23:36:15 +0100 you wrote:
>> Similar to TX counterpart available on MT7622 and MT7986, introduce
>> RX Wireless Ethernet Dispatch available on MT7986 SoC in order to
>> offload traffic received by wlan nic to the wired interfaces (lan/wan).
>>
>> Changes since v3:
>> - remove reset property in ethsys dts node
>> - rely on readx_poll_timeout in wo mcu code
>> - fix typos
>> - move wo-ccif binding in soc folder
>> - use reserved-memory for wo-dlm
>> - improve wo-ccif binding
>>
>> [...]
> 
> Here is the summary with links:
>    - [v4,net-next,1/8] arm64: dts: mediatek: mt7986: add support for RX Wireless Ethernet Dispatch
>      https://git.kernel.org/netdev/net-next/c/eed4f1ddad8c

As I mentioned in the series, DTS changes should go through my tree to avoid 
merge conflicts. Please let me know if you drop the patch and I'll take it then.

Regards,
Matthias

>    - [v4,net-next,2/8] dt-bindings: net: mediatek: add WED RX binding for MT7986 eth driver
>      https://git.kernel.org/netdev/net-next/c/ceb82ac2e745
>    - [v4,net-next,3/8] net: ethernet: mtk_wed: introduce wed mcu support
>      https://git.kernel.org/netdev/net-next/c/cc514101a97e
>    - [v4,net-next,4/8] net: ethernet: mtk_wed: introduce wed wo support
>      https://git.kernel.org/netdev/net-next/c/799684448e3e
>    - [v4,net-next,5/8] net: ethernet: mtk_wed: rename tx_wdma array in rx_wdma
>      https://git.kernel.org/netdev/net-next/c/084d60ce0c6c
>    - [v4,net-next,6/8] net: ethernet: mtk_wed: add configure wed wo support
>      https://git.kernel.org/netdev/net-next/c/4c5de09eb0d0
>    - [v4,net-next,7/8] net: ethernet: mtk_wed: add rx mib counters
>      https://git.kernel.org/netdev/net-next/c/51ef685584e2
>    - [v4,net-next,8/8] MAINTAINERS: update MEDIATEK ETHERNET entry
>      https://git.kernel.org/netdev/net-next/c/90050f80509c
> 
> You are awesome, thank you!
