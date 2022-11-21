Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3803632D8C
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 20:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbiKUT7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 14:59:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbiKUT7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 14:59:36 -0500
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F354385A
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 11:59:35 -0800 (PST)
Received: by mail-qk1-x733.google.com with SMTP id k4so8798199qkj.8
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 11:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Pdnw7K9TPf+eHf9zGnhvaqIDWZNdcE9UBDMAyL0uyyM=;
        b=qyE/DCJ/oS5pRVr13kZlbaG27J0p/GvxpnZ+iCr974wXVqUhOYcFsqI/fp12aVtv4f
         gYOXL1XKsdiWN2yaD7MPJvplu/ErL8JGVLoZQeRiszxu7553IenWI4v/mHxzhmqVr49K
         bRvrUhe1KgD5QLYakP4/Rbz5j4FH1jIYa/KORe5toveCcXV0AohNa/7/BGN4AP6ecO+P
         H7GfvawT16lNZHAopn5M8Y0O8u13PbsdKgXEEsf2dExA/W63i0pFntUB40AGxib2vfL6
         hqZJfnCiBZD6AgNH+h9sGvKNly0C7rYs/5G6LbIksbrYVYe//lIYLwkM4pdnPIw3d+3K
         kR+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Pdnw7K9TPf+eHf9zGnhvaqIDWZNdcE9UBDMAyL0uyyM=;
        b=VwB65SJDtMLLLwbgJOX2W6nD1xHmTWZmb+NPCjufRX8nU0rUs2mK0oeQVk1nBxpx1z
         uT3e93r938J7PLVxXBVzQRRMLDHes6D3wig3BS7u7tZfxIZiQZtcmEiblcWUpepFt2GP
         DpldRguG9LsOZz2QfTqiRB3tRzu7xpC8o2CVvLhequTVsj3thg3vLniHN6riSW95neJM
         csS9NKtGL5Mv2t6GzvQCrqrL7Ly8B8Tq8xWA8GbBJPXTuatqsKmCKoQTkrE2tPIzxj//
         kBntTjdPTRBFtrSjUtg0SWX7z1ffWcKYfo0aOCfNSg0e9iWcwXAPU0S7c8MYu9i2ySGY
         SYnw==
X-Gm-Message-State: ANoB5plIoZZFRN3mjDDY8PyXXTLNIJTw2nedVKKW4zaCP7ZHyBOpkegb
        BUoWFBUC6EXoVHblNiEx3SU=
X-Google-Smtp-Source: AA0mqf5VBamr9W/G+/61Qv9gH1fuYeE1EknUGg8GoFDrHS/1vNCmxRwdGmj1STu/zxcbpzjVfJC3Ng==
X-Received: by 2002:a05:620a:2b41:b0:6fb:f2dc:eca4 with SMTP id dp1-20020a05620a2b4100b006fbf2dceca4mr4787868qkb.505.1669060774404;
        Mon, 21 Nov 2022 11:59:34 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x13-20020a05620a448d00b006fa4ac86bfbsm8717233qkp.55.2022.11.21.11.59.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Nov 2022 11:59:33 -0800 (PST)
Message-ID: <d3e8166c-632d-7c6c-7aa3-12ecec0bf5a4@gmail.com>
Date:   Mon, 21 Nov 2022 11:59:31 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next 06/17] net: dsa: move headers exported by port.c
 to port.h
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20221121135555.1227271-1-vladimir.oltean@nxp.com>
 <20221121135555.1227271-7-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221121135555.1227271-7-vladimir.oltean@nxp.com>
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

On 11/21/22 05:55, Vladimir Oltean wrote:
> Minimize the use of the bloated dsa_priv.h by moving the prototypes
> exported by port.c to their own header file.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

