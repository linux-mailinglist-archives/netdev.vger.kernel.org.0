Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86892632D86
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 20:57:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231753AbiKUT5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 14:57:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231760AbiKUT53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 14:57:29 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA1C10A6
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 11:57:28 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id fz10so7992655qtb.3
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 11:57:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CxxM7q6OfXuayT1DsSA5vJaF7P199d2EF+5ZGhX+F2g=;
        b=A/X2wkkiOnbdqci3SdQqRYYQgraRovU7+Lp3GSMT9nANXG/cbatX3GSgStoaCYlSZy
         hhzcvgTFxHtJ/8KqRgHoRDlW9R7XJojcaBhhcj+52DSQhyELZLtVosppVHU39fP1tb4u
         M8L0GdMjWCavAvlcPNeQAIpn6XMFdNCoukHtjuQlz8QqWaJHDDuvPQtPNs1KQwrN6KH0
         HMVM68EBoBLQTUlVjmMuii6WNBZVAhkjC8rQ8hmoGN1DBcet1nRIczlHjXvTj2KaBjTN
         XeVEv5bQWCIxzTrncalLk3tpH6rxMkz90koI0lvmgILceZBwSp+cxRqDwz8BpiE61LsS
         fdZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CxxM7q6OfXuayT1DsSA5vJaF7P199d2EF+5ZGhX+F2g=;
        b=CTv6YU5gNwaKRPT4hziXMIwhNlwYS4vAy7qcF9uBaDmYPsCtvuYDsk5rcuS+kVNsuM
         yKU4SNlG6zmH/nioBMouqIFM8gfTJI039JA1hp8vwHU8Nz6WK1acnnwCRimekTus1NrD
         I+78FMmyUN+PS6cT/+3v7pnGrn/4E5ruRPZOmrBIMoSf5AjpawGwrkJ+wCRQjh1yFABz
         017re4gjKvLTfDRlRx/EdvuOt5bJe3wg7Pg6uo3dK0rrxXdVkn1k2XacpIQxYm3Vaofq
         yUOfGWjYxaMNVBr1nc4IJ2Z9F0lHI+mJqt8mbSQhTnvgjeBSJ3oFzwkpK1+Zzz9rR//9
         4IZg==
X-Gm-Message-State: ANoB5pmJVZGeN/OXM8OrBWHwNgZSl+/0RoR/Hwit1rdXMGiZ0pSL1lZ0
        3Qa/LcIRjInZ8BjCouvFON4=
X-Google-Smtp-Source: AA0mqf5g/s61Al8v+hHJK+4WDivB5TV6g3WbXT7yF97qHIOyZy1ybHBIOkWdjOwWQ0c7RD9LeKalTA==
X-Received: by 2002:ac8:4906:0:b0:399:7cda:9ad2 with SMTP id e6-20020ac84906000000b003997cda9ad2mr19113643qtq.485.1669060647430;
        Mon, 21 Nov 2022 11:57:27 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u20-20020a05620a0c5400b006cf8fc6e922sm8790516qki.119.2022.11.21.11.57.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Nov 2022 11:57:26 -0800 (PST)
Message-ID: <12ab5022-d993-0276-c85e-4aeb69261ec2@gmail.com>
Date:   Mon, 21 Nov 2022 11:57:24 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next 03/17] net: dsa: move bulk of devlink code to
 devlink.{c,h}
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20221121135555.1227271-1-vladimir.oltean@nxp.com>
 <20221121135555.1227271-4-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221121135555.1227271-4-vladimir.oltean@nxp.com>
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
> dsa.c and dsa2.c are bloated with too much off-topic code. Identify all
> code related to devlink and move it to a new devlink.c file.
> 
> Steer clear of the dsa_priv.h dumping ground antipattern and create a
> dedicated devlink.h for it, which will be included only by the C files
> which need it. Usage of dsa_priv.h will be minimized in later patches.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

