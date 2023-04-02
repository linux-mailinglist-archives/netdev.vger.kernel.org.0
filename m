Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 257006D37F9
	for <lists+netdev@lfdr.de>; Sun,  2 Apr 2023 14:53:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229503AbjDBMxD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Apr 2023 08:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjDBMxD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Apr 2023 08:53:03 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E6CD332
        for <netdev@vger.kernel.org>; Sun,  2 Apr 2023 05:53:01 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id ml21so2844848pjb.4
        for <netdev@vger.kernel.org>; Sun, 02 Apr 2023 05:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680439981; x=1683031981;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FLBlbm1ik13tQkxKTaAUBUOi2Qd2sFXZRUK/1WR4Mfc=;
        b=ZeRFalDdhawXr/3/VQ8zdA6je1yNzylHy01rzCOILqTR9NA0RG9+WZtMD6mItkKulf
         UgPPzzzii3n7Hu4FrtPq+3wAgEk5hXwGkroeFyXay5M5cbtPxLcRhxrStbcqJmspiInH
         KT/IM2TCtHA4YJ8ZX450r1Cywv0bqCNqtuvnmhYuueWFzvLxRpE6JXk3Jv05+Nmnw1BZ
         +QYNw7UpVj4Dn+2+h12Pf7c0ViUav9gJoA9dpXey6de7QUGNg6cX1hxCH5oujnNfxj6/
         1mWiT4uarGPxBBz9x6i7078I6zSoExDwliJOIYREYqwMampoqPF6Rvu+qtsre1+WJKz/
         jILw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680439981; x=1683031981;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FLBlbm1ik13tQkxKTaAUBUOi2Qd2sFXZRUK/1WR4Mfc=;
        b=dYt9fDiak1CmHk0XVDNH+CGtxknaVgRkV+NrIf0w5d3xCR6s8LZnNCr5fDU/V83LLm
         eZeC6OKiMzpvxX2I9Gi39EyS4GpIpaFv3Wnk2KcB2hdInydar0q20R2m5TWGHKtkJmBv
         eWDnAJpyarbfJjrCXKL9F+jqa/BulVX6kSc/SPp9hz5HRidicwXIJfBplbjhXmfsOwcl
         IMadT6WQGNfVGUXJBwZV4JZiHDrYnx5Svy1Re0yN2Re5JbUolLo9da/7ud27YdFBjxub
         V9NW+xnuKOHPFa4CHESLMLKBMaxIye7PQOq2DYWoDcEbE8sORBqrw3M5PlWzceLi+Dnx
         EvNQ==
X-Gm-Message-State: AAQBX9fiLhMYCN720MKp6yhc0LreLIx/5GpLL2VtNijFH/KflFo/9za2
        L8DRwwd6lwmG64kSC9OyJ3F8iEYAa9Y=
X-Google-Smtp-Source: AKy350ZNrcYBR1yJcuuXSNOmkTLpWO7rM8G/7NapgtdBWSfPtxXQO7gBTa2RMCblw/mBJaP53Wijog==
X-Received: by 2002:a17:903:7cc:b0:1a1:97b5:c63e with SMTP id ko12-20020a17090307cc00b001a197b5c63emr32548781plb.38.1680439981169;
        Sun, 02 Apr 2023 05:53:01 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id z7-20020a170902ccc700b0019e30e3068bsm4795295ple.168.2023.04.02.05.52.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Apr 2023 05:53:00 -0700 (PDT)
Message-ID: <bba0d5d3-1d8d-fda7-879e-e86957ef6645@gmail.com>
Date:   Sun, 2 Apr 2023 05:52:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH net-next 4/7] net: move copy_from_user() out of
 net_hwtstamp_validate()
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
 <20230402123755.2592507-5-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230402123755.2592507-5-vladimir.oltean@nxp.com>
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
> The kernel will want to start using the more meaningful struct
> hwtstamp_config pointer in more places, so move the copy_from_user() at
> the beginning of dev_set_hwtstamp() in order to get to that, and pass
> this argument to net_hwtstamp_validate().
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
