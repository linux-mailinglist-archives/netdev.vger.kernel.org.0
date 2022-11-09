Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23AD3623362
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 20:24:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbiKITYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 14:24:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiKITYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 14:24:12 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1332F8;
        Wed,  9 Nov 2022 11:24:10 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id v1so27364902wrt.11;
        Wed, 09 Nov 2022 11:24:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XRA7BydosCdosjY1YO5sYEuynxlsLpkwh6SYG10sx5o=;
        b=OE9Dw/3uiBKy1HlagUkB3k11IsK3YuB16znKDC00qGcN4Thq8oUD76xIdMeQ6tWcz4
         c+DotAF3gSO9W751xIXQ4Nph318YrSwEBjdY4AVhR6IORpzGhqqU1RGjWKCUSlzP177E
         ioXA4g1LKb6xVnlWNlwVxQe8IfdKP4g3eortYsoJlkko62EqF8ls45MsiwL3aECV2bgq
         j2JKpXwlMgpp0co+RX4yiRdHZsLDbzPWimFm4sTg6qRsEIdVPC9kvWvn87hBV/m4KumN
         6LOOgP37Po7fHF6r6TaP0wLiPJrJufSRdQc5t+vGEjBo5XAu/q012xBMNwlMnf0BlGZy
         cLqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XRA7BydosCdosjY1YO5sYEuynxlsLpkwh6SYG10sx5o=;
        b=o6ptnWdMMtJjiQPBwFowmx174cl1S+2ul1vlA0+EzIm5kyIt0BTPpXXC7du0Wk7huH
         I3plhzsNDpWv4SmG2KPlFOkx17B/IsNYy46wKqlYciivmw5N87bYNEL0HBaGukN0Q23L
         EHO7RBbm3wcXP5RHQDT8nXgF0IQDbDItdCI21PTUNeuqv/09Iv1wr4+SGBtcQaGw0Y5m
         b+X13utM1aFVtXOQwLFsxGBPVNKwaDor8mfo48v6kXJLih2RcMaifq9IH6sImxG21d++
         /RkgtT1dumSZj8cie3kh9Yzz1ntueqWvHcEddMfYXfZQlTQ7SFwpB+xkuZMLqh2NP/07
         IuNQ==
X-Gm-Message-State: ANoB5pl81TheRyNEgdcX5N2N5o8gJiPIjcDlrswolgrl/Xws+7N8B9cp
        hbngJPBEBlMCPRWpmhYDc2s=
X-Google-Smtp-Source: AA0mqf5G8yBaQyvCa9MqPd7AmO+prUuzB07VMpWvCjTLuwDl1dNiCeYebL+Vfoc9dsk+87FAhw7GNA==
X-Received: by 2002:a5d:48d2:0:b0:23d:b167:4547 with SMTP id p18-20020a5d48d2000000b0023db1674547mr14894693wrs.659.1668021849003;
        Wed, 09 Nov 2022 11:24:09 -0800 (PST)
Received: from [192.168.1.131] ([207.188.167.132])
        by smtp.gmail.com with ESMTPSA id bk28-20020a0560001d9c00b002365b759b65sm14174395wrb.86.2022.11.09.11.24.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 11:24:07 -0800 (PST)
Message-ID: <f1a5c144-1d16-a65e-f629-c9d13946377a@gmail.com>
Date:   Wed, 9 Nov 2022 20:24:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.1
Subject: Re: [PATCH v4 net-next 0/8] introduce WED RX support to MT7986 SoC
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        nbd@nbd.name, john@phrozen.org, sean.wang@mediatek.com,
        Mark-MC.Lee@mediatek.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, linux-mediatek@lists.infradead.org,
        Bo.Jiao@mediatek.com, sujuan.chen@mediatek.com,
        ryder.Lee@mediatek.com, evelyn.tsai@mediatek.com,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        daniel@makrotopia.org, krzysztof.kozlowski+dt@linaro.org,
        angelogioacchino.delregno@collabora.com, kvalo@kernel.org
References: <cover.1667687249.git.lorenzo@kernel.org>
 <Y2vBTBUw47sshA+E@localhost.localdomain> <20221109110538.431355ba@kernel.org>
From:   Matthias Brugger <matthias.bgg@gmail.com>
In-Reply-To: <20221109110538.431355ba@kernel.org>
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



On 09/11/2022 20:05, Jakub Kicinski wrote:
> On Wed, 9 Nov 2022 16:03:40 +0100 Lorenzo Bianconi wrote:
>> I noticed today the series state is 'Awaiting Upstream'. I am wondering if
>> this series is expected to go through a different tree, e.g. wireless one
>> (adding Kalle in cc). In this particular case the series changes only
>> the mtk ethernet driver and mt76 is built since we modify a common include (but
>> there are no changes in mt76). My personal opinion is this series is suited to
>> go through net-next tree but I would be fine even if it goes through Kalle's
>> one. Any opinions?
> 
> Works either way, we'll see what Kalle says.
> Let me bring it back to Under review in the meantime.
> 
> While I have you - no acks for the bindings yet? On previous versions?

Please beware that the first patch should go through my tree. Let me know when 
things got merged and I'll take it.

Regards,
Matthias
