Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0229A6D37E9
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 14:47:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230325AbjDBMrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 08:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229719AbjDBMrD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 08:47:03 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F3329EE5
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 05:47:02 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id m16so19340202qvi.12
        for <netdev@vger.kernel.org>; Sun, 02 Apr 2023 05:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680439621; x=1683031621;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PYFxj7RKJRv0+VcaDZJ7DBUNG0DgwXtK588c5GF8los=;
        b=Jm1W2u+5f/qyVFALNhwFqNCxupiMG+Y6P4s1XfVIoJUX99TMUXgbw51pmOsK/bOhOe
         99F++X17Vch3KNmN7UgIqw+kPue9Toi66OTBQ7bF6KSuGBVAt6AhwrAXK10Fx2ExzoQc
         JcvTIaX7RJDbznQJUXtohm+19kJoEDC2tSOubsWXWiENKA5xHBvOxMRrlpKFR65qvd0r
         brQGamKwFI7jmpYtRSdSSkzj/po6CCsJZOvBxgqKQQmwmW7+9WsMSLFg29MLZw+dVucH
         LjFhBUbBxhPBH+2M0JnPwxA3ZlyKoqzfk944abjCOhRKGAQOXbGDTYDFj/N5egOBqw1M
         zskg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680439621; x=1683031621;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PYFxj7RKJRv0+VcaDZJ7DBUNG0DgwXtK588c5GF8los=;
        b=7gP4ycE2p+SiUb5YWnFVxSUnIddGsgN/xn0yiJfh1PmQ75J+nXt/rowekYqOypFTix
         oTZ1p64zCcBY/lDvySNv82H7OtihSE1O5qZPZTq//sWoB99DzoUilow6RcVqYM5+yx6i
         z5GNqu7n5kVn/TKW0P15M+SIeUlRJM04uCkf19nBcOTyEDTik3+9MVWrkZFpSQGznGs6
         CA+x1fVmg4hrVfYtSxNmYeHpBpkx1RxUN2XrR7OUokROb5c4S+eva0pblG4twzczZbOg
         vBEAfQbEGG7b85IzGR822P7bVYXM19AfYSp9sv5ICQX9qApLlOcyOTbuKPWFaLlygLnJ
         +uag==
X-Gm-Message-State: AAQBX9dKHKAbXBVIKixJxmFwzMRJ/M3f0Y2ZyYdFR3J+HEl/CMfp65nB
        VHnQtdLxkfxebvqzINOJgys=
X-Google-Smtp-Source: AKy350Yx8NFbHLsbRyieWdt4P8UtVXCXWSYNW78ntdLMEGEVHppQFku/uHiW+x9r+aQrrsMrGhVPow==
X-Received: by 2002:a05:6214:e67:b0:5ba:852:272c with SMTP id jz7-20020a0562140e6700b005ba0852272cmr46791484qvb.8.1680439621551;
        Sun, 02 Apr 2023 05:47:01 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id oj10-20020a056214440a00b005e3c45c5cbdsm137244qvb.96.2023.04.02.05.46.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Apr 2023 05:46:59 -0700 (PDT)
Message-ID: <5892d30c-0a07-7696-8e67-d5f5a1d77183@gmail.com>
Date:   Sun, 2 Apr 2023 05:46:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net-next 1/7] net: don't abuse "default" case for unknown
 ioctl in dev_ifsioc()
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
 <20230402123755.2592507-2-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230402123755.2592507-2-vladimir.oltean@nxp.com>
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
> The "switch (cmd)" block from dev_ifsioc() gained a bit too much
> unnecessary manual handling of "cmd" in the "default" case, starting
> with the private ioctls.
> 
> Clean that up by using the "ellipsis" gcc extension, adding separate
> cases for the rest of the ioctls, and letting the default case only
> return -EINVAL.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
