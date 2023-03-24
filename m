Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82F0A6C858B
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 20:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbjCXTEg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 15:04:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231668AbjCXTEX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 15:04:23 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4466921A1D
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 12:03:38 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id l7so2283341qvh.5
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 12:03:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679684617;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ab0uSSIzhr599A7Gcgyko4gM5VEZfTEW6bgi/kmHrKw=;
        b=UdHS1fUHx5o+9HzlhV41CueN7TruJWYYKXxr5Bjy4iU8NoR00doPf2Po/lVz6lkBlh
         1bnBpwxiOBRc+Utyl8Hv4dPm/6z524nSm0+WyQQ3IRl0wTFrqFL1pCDfTAfAyuxJSUnv
         YyvOU3UoX7NXjfWbp8Q1uBJ5AgZPr1ld34J3nV2cXOHj+51YiFFkUPzwgsiusnuFENv+
         Gv0whGmgstcKNl9X1CPwfcXS3C/xxLt0nJobbHD7skrG6o0oPFBaRShFSlY/w1VPO/uL
         5Alcdormpv9w+qGIhkO4YHg7uhUl/7RFw3aoh8miippFQv57ur9WTLGtK57ViwY4KNl3
         LRNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679684617;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ab0uSSIzhr599A7Gcgyko4gM5VEZfTEW6bgi/kmHrKw=;
        b=UPfHKzxme2UZbLdDiQRTkGyhFLJOJg34yB9+Az8AClIUBaQrUQUntbLBvpmc5PwvPc
         yglgcTuW1kzN8rKh2WrjgAeoP7gLVfAClTT5r5vyApsVgUwquYBQ9Ia3O3ZtN7vMnf/E
         M/U3/gVbApGCbIPK67c4PyDs40T54PoeK+RXLznpN/6XgEiDEgQqBBDXlxGtTh1lVrwV
         K1fclRM7tAVRV4DScL/nlGVn4y/8217WYhF/dzOSwkLlU9obRTHSJEZjwXb9FM4pN3g4
         soNQPbqmQXldcfIlAEO6i8iKF+egDdClMnltyIgz0vGCIPQdxcTl34cOcHdWcsFG/iFk
         t6lQ==
X-Gm-Message-State: AAQBX9fM2gUzaNXmbDuxls2OULnGUJK/B/Dp3pz7oWS7NtOAL9EsSitw
        qKL+GSQFLrOR5V1x6FqyaXM=
X-Google-Smtp-Source: AKy350b+ii9ISAYbBXWp7EUlNu2yQkqUKRWRDxO/jUoa7G+fEkm63n7qlel08MMZuo2HzuaUUQ1FMQ==
X-Received: by 2002:a05:6214:d0a:b0:5ac:77ef:f76 with SMTP id 10-20020a0562140d0a00b005ac77ef0f76mr5598724qvh.44.1679684617158;
        Fri, 24 Mar 2023 12:03:37 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id s16-20020ac85290000000b003e38c9a2a22sm3530228qtn.92.2023.03.24.12.03.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Mar 2023 12:03:36 -0700 (PDT)
Message-ID: <c3bc1a7e-b80b-cf04-c925-6893d5ac53ae@gmail.com>
Date:   Fri, 24 Mar 2023 12:03:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next 4/4] net: phy: bcm7xxx: remove getting reference
 clock
Content-Language: en-US
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Broadcom internal kernel review list 
        <bcm-kernel-feedback-list@broadcom.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <0c529488-0fd8-19e1-c5a9-9cf1fab78ed3@gmail.com>
 <8d1e588f-72a4-ffff-f0f3-dbb071838a08@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <8d1e588f-72a4-ffff-f0f3-dbb071838a08@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/24/23 11:05, Heiner Kallweit wrote:
> Now that getting the reference clock has been moved to phylib,
> we can remove it here.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

This is not the reference clock for bcm7xxx this is the SoC internal 
clock that feeds the Soc internal PHY.
-- 
Florian

