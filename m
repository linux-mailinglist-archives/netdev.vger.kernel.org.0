Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A14A96D3830
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 16:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbjDBOAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 10:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjDBOAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 10:00:20 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECE8EBBA9
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 07:00:18 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id w4so25602509plg.9
        for <netdev@vger.kernel.org>; Sun, 02 Apr 2023 07:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680444018; x=1683036018;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6qCLzQviDBPOjzIb4ln4DWukD1gq28YLlh5+Xf3JGBo=;
        b=nSF6N4ze0aL9GyxRncnPDU2jxUDWrrDvpKt9BdguPq1F2pHuBaCJW9VaQnguObjy/n
         1ofSeMWX7f+GabJcxunuJjC4/6wCUM/kyWGnsVVAETmhOLPtb9NNWGnQAMZ0zt9gdiIt
         wJL5eCHxkX9bMqeSdkSo9RIRaCCZfQ7vnGxk2gBozPIa/ZVBx7+aEAO61HZZ21txssX1
         DNR0gR5ghKoDmQ3DJo2JWUo+nK8dcKTYGzSik8kIVMYpGUN/CF2cXWAzdwhdziOJlfCe
         8oceBQ9z4dTgRlub718gwRLyeE94iUK8cGd8v139tt2sd0CtyIqKmVrHrk5xQnxJLgtk
         M1Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680444018; x=1683036018;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6qCLzQviDBPOjzIb4ln4DWukD1gq28YLlh5+Xf3JGBo=;
        b=V196LqonvtskJ6wLP4HDtjI3pEg9rLl3++meopilcTfHZkL4XIUKzQJDPoQOoUkg4C
         gB0oHS6n42Uh521W2H4v74jkGdLz6KsJoFUGWREqMa5LicVga+Yq+eirYu0zKrhufE94
         5xdDuGD1fGEvpeT1LFpccAmlc/56EL4Hgmrnu+k+U5vzm5DkW5fqMf0a3+GJytv9kDIO
         Bi2jaNAOD4jlW5DOiQYPxbgfCk2MwA2l5mPwZ22FjiUpKzZLE+t1gAo1M01unWCowjAV
         wHHv8hnpMxFjIaY1Srm0Gwvp2v59UR5fQonsstnnSJ5Uevjm4oh7qKixa8ywFDG+mBpe
         is2g==
X-Gm-Message-State: AO0yUKUXXCce/WkC0TTWgoKZim3Nozxx1kfynLrs5PU7ssDwrpKbvez9
        PZnFUUaYE2e1/49o/HLMpxVYXe7Vua23vQ==
X-Google-Smtp-Source: AK7set+zpWl+NowPJcXtVWcez3jvN0h7OLaLLqPcul70Ejnm9ROlJIRVTbsmITpka+gWlR3fUq5wpw==
X-Received: by 2002:a05:6a20:9304:b0:d5:8518:1981 with SMTP id r4-20020a056a20930400b000d585181981mr26173162pzh.42.1680444018384;
        Sun, 02 Apr 2023 07:00:18 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id r14-20020a62e40e000000b00627ee6dcb84sm5037055pfh.203.2023.04.02.07.00.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Apr 2023 07:00:17 -0700 (PDT)
Message-ID: <ddab653a-c3f6-9b9f-2cac-ed98594849b5@gmail.com>
Date:   Sun, 2 Apr 2023 07:00:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net-next 0/7] net: phy: smsc: add support for edpd tunable
Content-Language: en-US
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Chris Healy <cphealy@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <17fcccf5-8d81-298e-0671-d543340da105@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <17fcccf5-8d81-298e-0671-d543340da105@gmail.com>
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



On 4/2/2023 2:43 AM, Heiner Kallweit wrote:
> This adds support for the EDPD PHY tunable.
> Per default EDPD is disabled in interrupt mode, the tunable can be used
> to override this, e.g. if the link partner doesn't use EDPD.
> The interval to check for energy can be chosen between 1000ms and
> 2000ms. Note that this value consists of the 1000ms phylib interval
> for state machine runs plus the time to wait for energy being detected.

AFAIR Chris Healy was trying to get something similar done, maybe you 
can CC him on the next version?
-- 
Florian
