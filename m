Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29039632E00
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 21:33:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbiKUUdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 15:33:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiKUUdj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 15:33:39 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97D7F72139
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 12:33:38 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id b11so11440023pjp.2
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 12:33:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dQYDM37WBukwkPmUH60kwot9GOsz3ZGtMxNiCjyRaLQ=;
        b=YrXtdbalNG11MMgxb/hxeQXHnbv9QIHdf88WbchoHReNpBAMvj/70a8BQiFNT/hQx/
         fm47RsY4AwFpUVidLYTDRs4gAdqhwer5rTVDD1TQBzYy5kCzGIfMlT0u8DEVCu5xveZ1
         TpJhcPUtdv8H2BIhd9/icnCqI/ES/SPjdCSl2ESmnu5RmfML3Q1ln85X74l0++UaPxFr
         Oq7pevEE9MKS7da0ZA2cz2LqKWvqAlEIKFGAFYsD4xvHuHj+nR4Fo3G0TH+vv03nT5a6
         CZY4+5OJWJVlbsDvM79ZZUyBhwZzzBzfIW3VAXsZSdkCGpuFnJ3aAYw4MM5SAy2904No
         otsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dQYDM37WBukwkPmUH60kwot9GOsz3ZGtMxNiCjyRaLQ=;
        b=Sk7fWcs8saPRgr64/tB9glC5CDpkmJE7fSiqzefxb9MV4e2Gun0ZFL+n7bjmFFztUu
         oFGqtt9oQBWpQ0fH1FqdIB2HwjpJt13v/uQFk7JWmqhjhm0LEHp2T+iXyziJjVTUVIW3
         zXBgdIFGW9ErR8A7u1xKJJ6XnOVYFGoVHIbvZMuDS0Xr+R8hhtcetw2jZEHGGF64pQ2o
         +FjubcRNUx3Hg4Q5wtKp7TTMhH8wOUdGUKgzv5HLbPS/Knd00dYxwG1V4T5yk2vQ9TWS
         Y0OtIYCR2adFCmX/u86NTBTFinfo65jjRAiZ5QGW4SbhRTH5I/E94pk+W4ifkPY+Aeb7
         MPNw==
X-Gm-Message-State: ANoB5plsrZGUb9Eln3PpdXw7heJsyY6rg3cPb31/27VpKvmnAUI5CWgr
        2md/S3V8Xy2Q0m0M3GjSg2nCP2Db/Nk=
X-Google-Smtp-Source: AA0mqf6ZPmuEFSrSWJOLfCtIN4hVRUu95GgzFeSI5dsW/xr89zn7Z0VtAE49aWZHCGUUVsMqZ52q9w==
X-Received: by 2002:a17:903:1314:b0:17c:73a5:d7a1 with SMTP id iy20-20020a170903131400b0017c73a5d7a1mr1122206plb.37.1669062817944;
        Mon, 21 Nov 2022 12:33:37 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b73-20020a621b4c000000b00562784609fbsm9030573pfb.209.2022.11.21.12.33.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Nov 2022 12:33:37 -0800 (PST)
Message-ID: <c2e1330c-9a7a-18cc-b9ea-33cbcb782a18@gmail.com>
Date:   Mon, 21 Nov 2022 12:33:35 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next 09/17] net: dsa: move tagging protocol code to
 tag.{c,h}
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20221121135555.1227271-1-vladimir.oltean@nxp.com>
 <20221121135555.1227271-10-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221121135555.1227271-10-vladimir.oltean@nxp.com>
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
> It would be nice if tagging protocol drivers could include just the
> header they need, since they are (mostly) data path and isolated from
> most of the other DSA core code does.
> 
> Create a tag.c and a tag.h file which are meant to support tagging
> protocol drivers.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

