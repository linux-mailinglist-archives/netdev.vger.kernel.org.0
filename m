Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B089C4DC207
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 09:57:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbiCQI6z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 04:58:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230340AbiCQI6y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 04:58:54 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A5A1CCAC3
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 01:57:38 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id d10so9185071eje.10
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 01:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=IZV5DOXaMBCK1WqYO4leOyigBVsvYn+ptdXXPyZIhWM=;
        b=LBhEVWCr3VYIX8oZnOnGnf4o4J2WHcaNKXshvqkeyhDkH27yDexv8/kyFq7AxZVR0o
         sF55l/ZYgbybYCaTURyx3KRFpjMBU479zToX5ghT8P45PLVMEPxst1e0wbwWHkXSqotL
         aS0CptGgoLxyZ6cLY7x3vWUUOa0Nxrc1rt7ePaYkoI6YybSwpu0cGNxQdTDngMgySrbb
         1fq8olG+RAkRVMLI5/20f8Kpw5b9YuGvPYZ9J4hocMpG/JwodazOImzZn2MFkKvH4ryP
         EMEjFMURbz5tZy7jKDeJX2m1ZHwbynSmCTQKAnDBvgvT1CMhBPpmW5CNrQ0pzSP5Q0Yc
         tTiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IZV5DOXaMBCK1WqYO4leOyigBVsvYn+ptdXXPyZIhWM=;
        b=IZh65FJSKJBT6X4E14uSOkRocoyCt/X/y0KJURo26vbVfem7HJQzBvqafUa75AkDn2
         xaY0VBLaWcF8ug+NxwBH0t3zsDSLb715y7p8PPXzZAcQ9fBOEaUzS36baCz8vPWl5DqV
         dfbZVECG+N9i5TNVCmnHQFZdnA+MiLWSRgwR42ppzeGWvp/QiSHGymICugc56xYjoWWj
         lOAVzZAQNZOrl9YZuAzD9I+7QBk1KXAQHWo1GaIBSTgGQ7AC7Zy9Joxh6UISaPMiYaI6
         EQv+9wGl4uXrrQupcs1wsVUq5kFlXYUTqN3HuXQAIT3iVKkBEEQ6mb1/hlk5SGS3FU/1
         KJzQ==
X-Gm-Message-State: AOAM5311m4fUaywQ5QB8gkM/DLdfFOXV+U5u1iMq+yoSFOCsWC+pYsJP
        OHg7Nwv3Zm5S3mmFZ/7N2BdMwA==
X-Google-Smtp-Source: ABdhPJxtdYfTkcIKxU67mnEWBDliHgh3BMo3c7F67ZYdvBzfH9RtoV11Lw4hIamzG3WAvB0mK8mwsQ==
X-Received: by 2002:a17:907:94cb:b0:6da:8e01:8312 with SMTP id dn11-20020a17090794cb00b006da8e018312mr3166644ejc.7.1647507457445;
        Thu, 17 Mar 2022 01:57:37 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id q7-20020a170906540700b006d5eca5c9cfsm2051537ejo.191.2022.03.17.01.57.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Mar 2022 01:57:37 -0700 (PDT)
Message-ID: <ed581b85-822b-c7bd-b614-fb87e918d314@blackwall.org>
Date:   Thu, 17 Mar 2022 10:57:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v5 net-next 05/15] net: bridge: mst: Notify switchdev
 drivers of VLAN MSTI migrations
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
 <20220316150857.2442916-6-tobias@waldekranz.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220316150857.2442916-6-tobias@waldekranz.com>
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
> Whenever a VLAN moves to a new MSTI, send a switchdev notification so
> that switchdevs can track a bridge's VID to MSTI mappings.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
>  include/net/switchdev.h   |  7 ++++++
>  net/bridge/br_mst.c       | 13 +++++++++++
>  net/bridge/br_switchdev.c | 46 +++++++++++++++++++++++++++++++++++++++
>  3 files changed, 66 insertions(+)
> 

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>


