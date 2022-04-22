Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32D9050BD4C
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 18:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449755AbiDVQob (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 12:44:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236728AbiDVQoa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 12:44:30 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E8F05EDF6
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 09:41:36 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id x191so7754998pgd.4
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 09:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=b7pO7MQ/LH9Dqrpim5bYE/szTyD/7bvOrj7rBrBirSs=;
        b=VSTfwy3aDXf77KDWcEFvQ2tsWKySs69eGd1NxBX1laNL+1TN41CfBr5WrtdaxOB3ZD
         Q/gT5NjozhkDa1ramtIa89nx6lUnUxEGIJx3g+V6nP57lKlTNrZ3D0P4ZAlpCm6Vpt0E
         gyktrzCHNy6z09bnpthzngHS9qI5y0PUPTvt3kIukQcq31ElPWMuwOeThCiUTAI2Me+t
         ZYAnfntLVHvWhFSFLcDX8d0k1hwENvB88rNOrAfA2N9MIn+TpBVZND+nGYhDJjB301VO
         ap1G1fS3tGvsum0zxzpxPGfO+a7kf8zuoM8m8+ZICsqSH3LYK1ZgYd1FNCXiP/c02lHk
         1ICw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=b7pO7MQ/LH9Dqrpim5bYE/szTyD/7bvOrj7rBrBirSs=;
        b=GU49bxIuloyKRGyWFCczkROIxqDfVmf9Q3z/CIEj0tHAPsfE7KBqxvic0HO+X1RNAf
         w2KZed0cgyyfOACUboKpX/jeYJ84VvsPalZXbC6qavbuUTGSAN8FAFW4ixkNAbYXzLvZ
         jl7b9FKVOnzq2IOnLEJs02KEzJ6YP9K0FlS2CFPzlcRMolX5RaVpa1Dm/FZkNXpWnK6I
         8b5tDZ4z0+83T2/41fXtx5MVmga3BpDsE0ddUvIDit5432sc/aTJNPenZMMN0E+q3Meo
         QVgCeFq0DrD0uWbEtcviSQkfkPm15FtTPCio1xMDJuUWYfrz2gpfApe7Ppaxyx5Maxwn
         KQ5g==
X-Gm-Message-State: AOAM530OGDxTjLfPxGH0B4DZq8bb+dtHIqo8q8f1OJ58pnkhDSVwX3NL
        MdWOv/SV41FauEyQEpf+Sa4=
X-Google-Smtp-Source: ABdhPJy7jgxRqZoXyKMVLWPBqcsxOU2I3oe7tem/UOBkPP6dV/+Uu70KDXftWFuM0oCTBMy0IQPlsA==
X-Received: by 2002:a05:6a00:228c:b0:50c:6a9a:a325 with SMTP id f12-20020a056a00228c00b0050c6a9aa325mr5611409pfe.79.1650645696084;
        Fri, 22 Apr 2022 09:41:36 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id y5-20020a17090a390500b001cd4989ff50sm6688131pjb.23.2022.04.22.09.41.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Apr 2022 09:41:35 -0700 (PDT)
Message-ID: <c4d4a178-0cc4-8580-146f-b19334d9bb36@gmail.com>
Date:   Fri, 22 Apr 2022 09:41:33 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH RFC net-next v2] net: dsa: b53: convert to phylink_pcs
Content-Language: en-US
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <E1ndrr8-005FbQ-F7@rmk-PC.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <E1ndrr8-005FbQ-F7@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/11/22 04:05, Russell King (Oracle) wrote:
> Convert B53 to use phylink_pcs for the serdes rather than hooking it
> into the MAC-layer callbacks.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Tested-by: Florian Fainelli <f.fainelli@gmail.com>
Fixes: 81c1681cbb9f ("net: dsa: b53: mark as non-legacy")

Thanks Russell!
-- 
Florian
