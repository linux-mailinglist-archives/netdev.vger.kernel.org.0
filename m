Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB5B36D37F5
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 14:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbjDBMwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 08:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjDBMwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 08:52:34 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B40ABB96
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 05:52:33 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id o2so25558563plg.4
        for <netdev@vger.kernel.org>; Sun, 02 Apr 2023 05:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680439953; x=1683031953;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kQ9++zyrRhhTuf/4JMRhNLAOEe0JhXHZ5IYkgJp7C00=;
        b=nY8RRJe/rZVQk0TMBovMa72aAdar9+7Udpb98ie6e4AM2k9l7k0ICuo8t1kwXGfk5Y
         MPRk0UeWFmsMxfRtZ6BPKm6o693lLYVxU3j4QPmQEcFxKMd/RGlcCLlQR+D0xJnLIsof
         /NfCM6HsJNLbOFTUbLN2ythqBqUhodt09PMcSF+NPgR8+FaXdTMqMpkNYygUr5NwpVWr
         hj+KViOCNKNLt5xCu4gC+x6tvEkef/ymMDmFUwP6EM4xvDv49OR0Fxr9ZR+ISsEfnq3t
         Sru7BbBLTY3b84XNchP9JNlYFAixG8cGlwMjAMe7MCN0XERyYxOlq5dhtbXxvlImagMC
         Bx/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680439953; x=1683031953;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kQ9++zyrRhhTuf/4JMRhNLAOEe0JhXHZ5IYkgJp7C00=;
        b=VG+M6UwsbNPIE7LYrOEpmlbRlj1MxBIOGjzuWbgB8mfl1zxxcIG+5LaaJhUNmC/P9k
         sYNY6rPrbHa1S+QWQiPQBOJ7QxtO2LzlIVmY0/X4xfMHp1S/cfFHNUUVeQQyZNcPp1bm
         lTt/7bYDon57nW+asmblUX1hkCj/UbwZMsYKftYCHLV/gSa5I+mlKMttAiP0EE0IzAQ2
         YvBhUy+acJaUbZEINl9usWWg8prbDZpx2q333x1J24tqHzrPGy4KSiNQULMTpK6g5yGu
         zatzS+qy/kAIUu9P03V+FeN6Vb9kyZjOjlfvGgT28rvo1XnG41i1JH6jsNg2/j4ubqui
         upGg==
X-Gm-Message-State: AAQBX9cTho/Iu9cvStha/SIF8IgmuD6Ja9TPcpXTSIC/aj6NWgLPiWTx
        /u+qC/bCGCVp9hYF+bu8Oxj5KP7xEDI=
X-Google-Smtp-Source: AK7set++wPF5xzpGYr9HyDpnqCu9P7hjeetGNoMJ5bz0a/zOadVVxIw/oSfSA7ad3n5FuUgql80Ykw==
X-Received: by 2002:a17:90b:4b09:b0:239:ea16:5b13 with SMTP id lx9-20020a17090b4b0900b00239ea165b13mr37703101pjb.14.1680439952742;
        Sun, 02 Apr 2023 05:52:32 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id 3-20020a17090a174300b0023f545c055bsm7921111pjm.33.2023.04.02.05.52.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Apr 2023 05:52:31 -0700 (PDT)
Message-ID: <915c64ca-bbea-bfe9-3898-cd65791c3e5d@gmail.com>
Date:   Sun, 2 Apr 2023 05:52:29 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net-next 3/7] net: promote SIOCSHWTSTAMP and SIOCGHWTSTAMP
 ioctls to dedicated handlers
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Maxim Georgiev <glipus@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        =?UTF-8?Q?K=c3=b6ry_Maincent?= <kory.maincent@bootlin.com>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>
References: <20230402123755.2592507-1-vladimir.oltean@nxp.com>
 <20230402123755.2592507-4-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230402123755.2592507-4-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/2/2023 5:37 AM, Vladimir Oltean wrote:
> DSA does not want to intercept all ioctls handled by dev_eth_ioctl(),
> only SIOCSHWTSTAMP. This can be seen from commit f685e609a301 ("net:
> dsa: Deny PTP on master if switch supports it"). However, the way in
> which the dsa_ndo_eth_ioctl() is called would suggest otherwise.
> 
> Split the handling of SIOCSHWTSTAMP and SIOCGHWTSTAMP ioctls into
> separate case statements of dev_ifsioc(), and make each one call its own
> sub-function. This also removes the dsa_ndo_eth_ioctl() call from
> dev_eth_ioctl(), which from now on exclusively handles PHY ioctls.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

PS: there could be some interesting use cases with SIO(S|G)MII(REG|PHY) 
to be explored, but not for now.
-- 
Florian
