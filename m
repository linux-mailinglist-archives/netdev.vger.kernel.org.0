Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EF816D37FE
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 14:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbjDBM5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 08:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjDBM5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 08:57:10 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1892E10240
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 05:57:10 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id ja10so25553979plb.5
        for <netdev@vger.kernel.org>; Sun, 02 Apr 2023 05:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680440229; x=1683032229;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2pAlCAf059CgZgOpuxw1yYn7DIaTur1GCLUV8oQqV70=;
        b=MySSDLxZcgDgxKeb10052hd4MiE0ihbD6VxNEbhc63gItWLmEibTmD496JMcdaONBu
         5/+4ju1XCV2EMD6PDkDcbXibFcSDX3fcgK0RKwFgn5rtHb2uHxty7OsRUtzx14JcK2tO
         YhBmoBrfudTTU//0sCOFsDt9+wMoWRwKbR2IqrIHsAdVPsBefar4s1OA+itFLFL0pFBg
         ajGMUU4RpDV/OdpklhdJv6DjeBqLzqS8C4jz1OU/42/1qajXk2Vr1JMLjOo/o2YL3EW0
         zJCfSnPYXzTZkqXpvEbJ1PGHyJQEbIzlVEedyoKCMGqGoBF3fxl4d+STYZqF+lm3nXx2
         MEFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680440229; x=1683032229;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2pAlCAf059CgZgOpuxw1yYn7DIaTur1GCLUV8oQqV70=;
        b=QrQFH0EW1iWfOlIJ1oz4TUQwMVHIk29AXD8T0A7c9HUmvf7D1IzTZwoGUls+jBemMG
         Cu6fxu1kjzrMbzNmfd7IwYaZ/HuawS31Q4alVbzsA0MQrsYXkwYt/2yS+yaYGTqnPrYy
         P4Bd/ykYlliiDDT6URvyiRZoJjRAWUFUuNhP2UsC5GpKqP58iaf1Z1bRUL40WEEeJ8+8
         sh7L6UaFjDNfPk9uSob204t/UdOrA5Pgkz0KQdp/mCZfspC3TmD00zZCf5lb2+mPAfRw
         wFeQZhbzSYcKjxJiOAeo25bRtr0VCEF9gIGoOafAx4jo34fUoKbgLXoNYIM/rQf4yX7p
         CiSA==
X-Gm-Message-State: AO0yUKWtwqqBm5m19oXvM+D72VxPKf4N6yCGbC4xK8pmY7UoM45qZlXa
        W02GTi6tUKWZVQ51qn5EBiX9I6zLgDw=
X-Google-Smtp-Source: AK7set9qeTWOo/Ftid3VlRuEgf1olvfyerzRTl+NqRJh1QMth3h8tKFgUZ6WYDiY9P2IwvCU7jCoZw==
X-Received: by 2002:a05:6a20:b2f:b0:da:3903:f5e7 with SMTP id x47-20020a056a200b2f00b000da3903f5e7mr27613786pzf.0.1680440229492;
        Sun, 02 Apr 2023 05:57:09 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id v12-20020aa7808c000000b006254794d5b2sm5191229pff.94.2023.04.02.05.57.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Apr 2023 05:57:08 -0700 (PDT)
Message-ID: <531f7c0b-e453-5b5e-6230-5915b12e8a19@gmail.com>
Date:   Sun, 2 Apr 2023 05:57:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net-next 5/7] net: add struct kernel_hwtstamp_config and
 make net_hwtstamp_validate() use it
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
 <20230402123755.2592507-6-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230402123755.2592507-6-vladimir.oltean@nxp.com>
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
> Jakub Kicinski suggested that we may want to add new UAPI for
> controlling hardware timestamping through netlink in the future, and in
> that case, we will be limited to the struct hwtstamp_config that is
> currently passed in fixed binary format through the SIOCGHWTSTAMP and
> SIOCSHWTSTAMP ioctls. It would be good if new kernel code already
> started operating on an extensible kernel variant of that structure,
> similar in concept to struct kernel_ethtool_coalesce vs struct
> ethtool_coalesce.
> 
> Since struct hwtstamp_config is in include/uapi/linux/net_tstamp.h, here
> we introduce include/linux/net_tstamp.h which shadows that other header,
> but also includes it, so that existing includers of this header work as
> before. In addition to that, we add the definition for the kernel-only
> structure, and a helper which translates all fields by manual copying.
> I am doing a manual copy in order to not force the alignment (or type)
> of the fields of struct kernel_hwtstamp_config to be the same as of
> struct hwtstamp_config, even though now, they are the same.
> 
> Link: https://lore.kernel.org/netdev/20230330223519.36ce7d23@kernel.org/
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
