Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15A8F6BD9BF
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 21:02:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229974AbjCPUCd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 16:02:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbjCPUCb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 16:02:31 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B5EC6411;
        Thu, 16 Mar 2023 13:02:07 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id 6-20020a17090a190600b00237c5b6ecd7so6606233pjg.4;
        Thu, 16 Mar 2023 13:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678996926;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3v85lyUnzoljLK8R8w//5jRA2xdnyIBE9SdjNCCiLAk=;
        b=FJ1iS8JnAF30M/rsLd5PCgQY9+J4uXaCywnOzzM2QsAlULBfFd5BfmgBOwqSsYxM3D
         fEx59YVoPCNHACnpOarA1IgXrkfDyqlwC+VQqD9AkGOd/d/crGZcbzU8uakKi4h8qF92
         tvGEIxbFQ4hoFMSbRhOKxRS1PS5HuMSpJme1Ssd5/C9nW7ZbMSX0+0t4H60vcsqh8w4S
         8Cc3gqNlYeiSEZzl5KWCRlIoW+WDswiJ2YV2knfHbHf/6KeZ00QLHfzvMuTGNAHPlCvJ
         gHCrBkCqpAihpMoAhUk6okJW+nt7eknsKbjvDX4UlvsY0CUkxCmOJ6yc59Z/FO6qyH4j
         c2xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678996926;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3v85lyUnzoljLK8R8w//5jRA2xdnyIBE9SdjNCCiLAk=;
        b=Urb3RFOfERIyagmKqe9OqiO6MCKk+aF7hz0up8ugjEXrWprWqnkjfXY5FRsaejw9yW
         wbGACRqs8a6OK22J5jFsWA7BsWFhZ8KmjBlK/UZxZvoKlEFfWJGNU7SYpIIUyBN1L6Nh
         Ct603p/gyGJTWMWZESrsmdiebHtIe4JDlyqQy3W6/JBUheQFxmfV7LCcPwpebuMP5yLa
         iRuhb66GYx3+GJZ7Xi9jJZvDffhKmtZRJOIBpI9I82UBKzt9yRTnr3lou/SLgExxCNQt
         bvIF0DxkZXozlUM/RzJsTwauxmNnFbaXaQ4oM02es2G+74sUDnXamQvto6uZqtB+cQ9V
         oo5A==
X-Gm-Message-State: AO0yUKXj8eXFeePoDgPPOnVp/iBMRCMr0SOhFbs6loMDRItZdR9wIow9
        9BnzSoiPtoEuMfFYoFwLp8o=
X-Google-Smtp-Source: AK7set8BNPpFY0/0KxWKbny4Ng8EbO+7wG7IlWoLlr1m/t2pa16HnDcVg91DOpDbVqkRlmXwQwHwkQ==
X-Received: by 2002:a17:90a:19c5:b0:23f:29a:5554 with SMTP id 5-20020a17090a19c500b0023f029a5554mr4684875pjj.48.1678996926407;
        Thu, 16 Mar 2023 13:02:06 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id lw11-20020a17090b180b00b00229b00cc8desm8197919pjb.0.2023.03.16.13.01.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Mar 2023 13:02:05 -0700 (PDT)
Message-ID: <78e0a047-ad0a-2ca6-10f7-9734a191cefd@gmail.com>
Date:   Thu, 16 Mar 2023 13:01:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net v2 1/2] ravb: avoid PHY being resumed when interface
 is not up
Content-Language: en-US
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        netdev@vger.kernel.org
Cc:     linux-renesas-soc@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Michal Kubiak <michal.kubiak@intel.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-kernel@vger.kernel.org
References: <20230315074115.3008-1-wsa+renesas@sang-engineering.com>
 <20230315074115.3008-2-wsa+renesas@sang-engineering.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230315074115.3008-2-wsa+renesas@sang-engineering.com>
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

On 3/15/23 00:41, Wolfram Sang wrote:
> RAVB doesn't need mdiobus suspend/resume, that's why it sets
> 'mac_managed_pm'. However, setting it needs to be moved from init to
> probe, so mdiobus PM functions will really never be called (e.g. when
> the interface is not up yet during suspend/resume).
> 
> Fixes: 4924c0cdce75 ("net: ravb: Fix PHY state warning splat during system resume")
> Suggested-by: Heiner Kallweit <hkallweit1@gmail.com>
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
> Reviewed-by: Michal Kubiak <michal.kubiak@intel.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

This is a pattern that a lot of drivers have, for better or for worse, 
it would be neat if we couldcome up with a common helper that could work 
mostly with OF configurations, what do you think?
-- 
Florian

