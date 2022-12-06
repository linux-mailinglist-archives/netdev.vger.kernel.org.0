Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA11C644E8E
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 23:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbiLFW3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 17:29:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbiLFW3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 17:29:34 -0500
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F7449B4A
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 14:29:33 -0800 (PST)
Received: by mail-qk1-x72b.google.com with SMTP id p18so8755300qkg.2
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 14:29:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HLe6ffY5gxYcvKyBqhCtZmmL/WeRbilOBhFabL1YohY=;
        b=kORrG9PCWwncAART9CZmJsDTpIJug34vmKFrk4gsrBoWdIm93TDHlBKMuIYddHmKLy
         sXy94PD122PovJ7Yuklp/DYekd2LIrgpnuc0nu6JJm1PfPs1Hi2PpSHEtYHup7VWvYAE
         sJ0+FSOa69OVvMujwJTCVvt6tfCJtDF/TS83JiMT+7WvfsqGVArWU6tCC/O+nNsiBZET
         82IEUiu2Z5w4rk28JQCyA50v3DjDOuDActMb4sRl/GVtjgK6LTBLDMKU16kTafUfD3Yb
         88mCCcjAbIp4L6Xod0I6AkTo+7vAuyYjipNmxA9nzbmjHdae7k5icpBchb78ksg0ZG+2
         ttvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HLe6ffY5gxYcvKyBqhCtZmmL/WeRbilOBhFabL1YohY=;
        b=MbNWI9i3Y68cGvoq9aTbaiX8o9binBicH6dnlTzJhS6dbmoFnAJRhudlKXRnMv39UX
         xBlowvICEvO/R6nOXhvq/DEb+FgDqZ0BeiuvSBREOuNM7vur9ZiWJQgL08eww/lqAXAu
         d4UYhOt8+3RIdzaZnJw9jBFwI2xxAUqDWCjC0Qbi0mrc0nrQstD5jKJzHNrBslO2UIb9
         SXtO/9WGABuXAYpMkikpeqfEZyG1+8/RpdCjSajVgPiW8Lr19JVlx1gKO8RrxiHEKcGC
         WmDlI6SNVxovvOsjwpBaNEJzQzfQBNXwl1idCL4eE8k6/lzbTvhu/7MG/tiQRR9o05eT
         pwwQ==
X-Gm-Message-State: ANoB5plj+MmO26u48Grd5dghOG5N5WBSDOV/LAysyG4Rf1g5wqRJhApk
        XEh2Y6sa3rdQW0m8OcDK5rg=
X-Google-Smtp-Source: AA0mqf7ZcJi1AuHu4zEaTClyvRQMW4BXHA6Wks9QkcN9w3gGWYyKGQTsGi905Zu1PnUbLYCVRUpuJQ==
X-Received: by 2002:a05:620a:15d4:b0:6fc:a7df:5f41 with SMTP id o20-20020a05620a15d400b006fca7df5f41mr21030077qkm.694.1670365772844;
        Tue, 06 Dec 2022 14:29:32 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id g9-20020ac80709000000b003a7e8ab2972sm3096702qth.23.2022.12.06.14.29.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Dec 2022 14:29:31 -0800 (PST)
Message-ID: <34b6157e-2d0d-a5b5-bad9-cbb45045e48a@gmail.com>
Date:   Tue, 6 Dec 2022 14:29:28 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH] net: dsa: sja1105: fix memory leak in
 sja1105_setup_devlink_regions()
Content-Language: en-US
To:     Zhengchao Shao <shaozhengchao@huawei.com>, netdev@vger.kernel.org,
        olteanv@gmail.com, andrew@lunn.ch, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com
Cc:     weiyongjun1@huawei.com, yuehaibing@huawei.com
References: <20221205012132.2110979-1-shaozhengchao@huawei.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221205012132.2110979-1-shaozhengchao@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/4/22 17:21, Zhengchao Shao wrote:
> When dsa_devlink_region_create failed in sja1105_setup_devlink_regions(),
> priv->regions is not released.
> 
> Fixes: bf425b82059e ("net: dsa: sja1105: expose static config as devlink region")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

