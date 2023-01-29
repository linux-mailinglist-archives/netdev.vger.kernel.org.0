Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 271B567FDBF
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 10:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbjA2JJw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 04:09:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbjA2JJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 04:09:50 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBF6A1F5E7
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 01:09:47 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id mc11so1642868ejb.10
        for <netdev@vger.kernel.org>; Sun, 29 Jan 2023 01:09:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ME2PdeGInkXM+3g9j7aQWR1xp7lA94fP3xofwv1Necc=;
        b=77HUeHrM1uiM1r7VcC24466iV7eBJUjFbnVCZ43EG1qSi652M0YPNBGu51BMoN44G9
         JQtFcEn55+C3rZD2DRq2TNQ+KkeMATbVoHXdP4PLvVSQxo3YTu94lXGPsTzYGV2WD0id
         azJkBo4KxDAwQSsY+73bkhFey1xiiz+CnQgi95FVOfXujsh6hgP4J/kDTFNNUp+/ATM6
         pUsZbG3vigaoxQJpV9ODQXi2ddxkzO3SEixGLvMlOK+eweGKJ2v+Iw2Ut4XvltldZo0u
         L44UiNmjTL+44Rim7jOn85a3kw60Pij3uduhj3gSGtVrvi7Ad52nOkHyLLGuBj7p98SU
         m3yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ME2PdeGInkXM+3g9j7aQWR1xp7lA94fP3xofwv1Necc=;
        b=Ndnvlax6CIilORQwXCDM9EEPOT47Dn6YW5tHfO/yUCSa/tmHOFEDWeePW7cu4GQAGd
         92W/ohp+ovDVv8vfOEYjidvN8Cr50+PoweXBlxpGdu7by8HTDIppLeZ11xYiopcm4dCr
         wKiqdR0XQgNFt6XZPBEr1GSLA6kTEjFC7hb92z0THgUKrFyrrfnY0hw7Ih+G4TMkWHEX
         RYvvIWGM/eEezIn7mspeDbrieF7Dl57hiUp563N9mJXRsPyM4WhFQ6qFKbv9Vs0Vmkf7
         jjaZbfD+JakAaUQMLllFIFcoARLUVhaIEknpnr6TqBKYR8fLUlawhrq2+QuwQZbQHeQK
         q0bA==
X-Gm-Message-State: AO0yUKWGEVU7T4yPYp5FNgN/BEEf/5C0IKpR7wHWLKke64697PcWREVr
        Uo1/VtU3JxuHr8V7N5haFo4B+g==
X-Google-Smtp-Source: AK7set93Yo3IZ+0Ty6qfT0TAqNfW/ETT7xdw7JqJC6jBhdknqBHm5DeSfySbmcHCFGeWkPH0jVtc7A==
X-Received: by 2002:a17:906:2409:b0:884:d15e:10f0 with SMTP id z9-20020a170906240900b00884d15e10f0mr3129382eja.23.1674983386309;
        Sun, 29 Jan 2023 01:09:46 -0800 (PST)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id s4-20020a1709062ec400b0087da4172178sm3025054eji.44.2023.01.29.01.09.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Jan 2023 01:09:46 -0800 (PST)
Message-ID: <3430cc65-03f6-c2a7-fd6e-2611f084b434@blackwall.org>
Date:   Sun, 29 Jan 2023 11:09:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH net-next 02/16] net: bridge: Add extack to
 br_multicast_new_port_group()
Content-Language: en-US
To:     Petr Machata <petrm@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, netdev@vger.kernel.org
Cc:     bridge@lists.linux-foundation.org, Ido Schimmel <idosch@nvidia.com>
References: <cover.1674752051.git.petrm@nvidia.com>
 <e22dda1dc7f1211428f6504c86ba2cedb8fdcca0.1674752051.git.petrm@nvidia.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <e22dda1dc7f1211428f6504c86ba2cedb8fdcca0.1674752051.git.petrm@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/01/2023 19:01, Petr Machata wrote:
> Make it possible to set an extack in br_multicast_new_port_group().
> Eventually, this function will check for per-port and per-port-vlan
> MDB maximums, and will use the extack to communicate the reason for
> the bounce.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  net/bridge/br_mdb.c       | 5 +++--
>  net/bridge/br_multicast.c | 5 +++--
>  net/bridge/br_private.h   | 3 ++-
>  3 files changed, 8 insertions(+), 5 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>

