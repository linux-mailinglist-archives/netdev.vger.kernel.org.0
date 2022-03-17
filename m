Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B75574DC234
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 10:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231648AbiCQJCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 05:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231586AbiCQJCk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 05:02:40 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81C4E1D08CB
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 02:01:24 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id bg10so9265334ejb.4
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 02:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Vhmaa8dvAWAF7hhtVerRMIY5hbJUzuvuMcKyuTSFTwg=;
        b=78YceMwTeAnCsJX1c/l4aRdsPn2rkY4Ej3QmSbpqhb5TZWTH8ViYLss/o47dggaWBB
         8Cq3ytvuEIm3eG0HwDRs1eZEPWddjcoQSsiuQ1izCrxzc14/dIVyxYGcBO23FMg961M8
         5H7Dv2ySLSpgGD0fkCQSc7e9IkkdujC3nrkcFu/UDWdlvDT0QVLM3lhK7NjIyRYqdqmJ
         b4asp0Vq7xwTU3ge/5S0G/gPuIMxk7pu1sxsNO2eF74epze+2Vrh1MVSX1q0d44mnJ82
         rPWQMfaUwUu8MHGhxMwvnnCiWq5QfEwA9QFjZ2Vtn+ZhtKxWnlY/r2N3LrGZOjaysGnt
         BhfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Vhmaa8dvAWAF7hhtVerRMIY5hbJUzuvuMcKyuTSFTwg=;
        b=k3V3UxTTkAPYZYuK6W55rd0D+cZL5PHk0w+7LbIxMzZDEmWqVEnh6q86LLyvZcLpDM
         9xp/T5uSzaTs7zMUW2lS2hYSyWcZunQxcD32xHL5RJgmF83LKQ41jgm6mS0sxII7xBnO
         exKNaBCUQfAh7USIfZAJzPgaLu/o7yTOCJcROMo9dqmI2Z5RaIwO0ZHGqnB5TL8D/oY8
         3FEIpaWql4JySPYJrB48chFYN6+MmPwnACmh3SVHFZ2u85Nv/LANPTU5hRTo0mSCrAJs
         MQpUy2a4S/03OYjY32nZOGo5LTanlvAHZjPB7DuNrKff6QhNzgmOsYDj08werGV1VMUM
         flDA==
X-Gm-Message-State: AOAM532xAACwE+7zGizZe4mmyJl04DkXcuHFJQV3aEVYYyl584OAaO8q
        i3gTEUAgbRgfhZrSPapPNzH6XQ==
X-Google-Smtp-Source: ABdhPJz5wwFFPWZiqC4nPeTrGUb1a5X0B8ku5ObeLhn2reQ2g3kLcviCNUKQ6pdcAOPpsEMmpauk5Q==
X-Received: by 2002:a17:906:3144:b0:6ce:de5d:5e3b with SMTP id e4-20020a170906314400b006cede5d5e3bmr3366414eje.689.1647507683061;
        Thu, 17 Mar 2022 02:01:23 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id dn4-20020a17090794c400b006dbec4f4acbsm2061440ejc.6.2022.03.17.02.01.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Mar 2022 02:01:22 -0700 (PDT)
Message-ID: <4e09ab7d-95eb-7114-97cd-1e389c948a9e@blackwall.org>
Date:   Thu, 17 Mar 2022 11:01:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v5 net-next 08/15] net: bridge: mst: Add helper to check
 if MST is enabled
Content-Language: en-US
To:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Russell King <linux@armlinux.org.uk>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Cooper Lees <me@cooperlees.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
References: <20220316150857.2442916-1-tobias@waldekranz.com>
 <20220316150857.2442916-9-tobias@waldekranz.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220316150857.2442916-9-tobias@waldekranz.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/03/2022 17:08, Tobias Waldekranz wrote:
> This is useful for switchdev drivers that might want to refuse to join
> a bridge where MST is enabled, if the hardware can't support it.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
>  include/linux/if_bridge.h | 6 ++++++
>  net/bridge/br_mst.c       | 9 +++++++++
>  2 files changed, 15 insertions(+)
> 

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>

