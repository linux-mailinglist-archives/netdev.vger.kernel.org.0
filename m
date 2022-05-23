Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3390A531829
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 22:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbiEWS2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 14:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245120AbiEWS0h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 14:26:37 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E69666FAB
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 11:02:06 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id d3so10345709ilr.10
        for <netdev@vger.kernel.org>; Mon, 23 May 2022 11:02:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=sy3QR4zyk+R77Hw76GpfK+HF51n89f59J8W2dYGPYco=;
        b=O0F8N6lmHv4FCTLzcTSgIZeVzzhPQskuJQrn06dqhOomIwqmuDn5DC0CefWX5Lra8Y
         Ga7vixS8zEI74dqPaiuGB3FVOcKkdqPW2u+fncvTBF4jFAc7KvoMAlO1l4Wsib7+oOSc
         Rlm9I+vzhrBdUsw8FFbIw4k2kR919sNRPiwsNejCqHORXZH41A4pZt5PlTQ+PkBZ4ZW6
         uSjKE4Sv/FEbf/gsuwdfsjlOQzyFtYSmulIJ4mdVru3+B8oeGaX70jl/SKaaJyJqkrbC
         Ss8rNIpy5HKk0TQ9+4Di77Q5hj9TxhgtvCa2xtF8H3s9JVoURD5v8KIbgwiY+u3CjxUR
         pnvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sy3QR4zyk+R77Hw76GpfK+HF51n89f59J8W2dYGPYco=;
        b=a6CMo1CAulqVI49J0oPFN4NKYJsnJzt2dYn2PpTaksnRoz1h5XOKDgqcCyslhIqjap
         VHlo4t5fjNcAYhZ12kjhySwY417KvovBWCf6jhioXQrEN1/PyAuBgaiKkzaotwUv+7lU
         qJq58nj0VlRtPVyE9MgeowOfl4C8IJ7BAWkFiHysGFcuHPMfI7xKpkkUeAJr6SdWJuDf
         tFRmckFqVM3rAcNF9V2STT3HH2xcnkTB+MOw/kX7UXYn3OOY7Umhx8pvVSud0efD/hdN
         JFu/uqCCF4AW5iKuU/+SRq6temrs81BW4N8JTrV1Ck1YJn0SnPobLR5vvw0ki87TSgvR
         V93w==
X-Gm-Message-State: AOAM530QrN+3Y00wbE1ihrgjsB1cRLNgARjrZ7F0/77quaWLzL3wY8vM
        KIOAWHSBMEvBGRcmDjWPSAMbjNAimYM=
X-Google-Smtp-Source: ABdhPJx4yHZV4Y1wiYMdQ1AmXc1XpJRewt/l1eRwt2RMJW6Pjgh6C3qnAhQplWjyJrY3oWt31MEyIA==
X-Received: by 2002:a65:6a05:0:b0:3db:27cb:9123 with SMTP id m5-20020a656a05000000b003db27cb9123mr20794982pgu.497.1653328825211;
        Mon, 23 May 2022 11:00:25 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id q1-20020aa78421000000b0050dc76281e1sm7478405pfn.187.2022.05.23.11.00.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 May 2022 11:00:24 -0700 (PDT)
Message-ID: <c8bfef0e-57d5-96a7-bd14-12faa8cd384b@gmail.com>
Date:   Mon, 23 May 2022 11:00:21 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [RFC PATCH net-next 07/12] net: dsa: all DSA masters must be down
 when changing the tagging protocol
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?UTF-8?Q?Marek_Beh=c3=ban?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Colin Foster <colin.foster@in-advantage.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Frank Wunderlich <frank-w@public-files.de>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20220523104256.3556016-1-olteanv@gmail.com>
 <20220523104256.3556016-8-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220523104256.3556016-8-olteanv@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/23/22 03:42, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The fact that the tagging protocol is set and queried from the
> /sys/class/net/<dsa-master>/dsa/tagging file is a bit of a quirk from
> the single CPU port days which isn't aging very well now that DSA can
> have more than a single CPU port. This is because the tagging protocol
> is a switch property, yet in the presence of multiple CPU ports it can
> be queried and set from multiple sysfs files, all of which are handled
> by the same implementation.
> 
> The current logic ensures that the net device whose sysfs file we're
> changing the tagging protocol through must be down. That net device is
> the DSA master, and this is fine for single DSA master / CPU port setups.
> 
> But exactly because the tagging protocol is per switch [ tree, in fact ]
> and not per DSA master, this isn't fine any longer with multiple CPU
> ports, and we must iterate through the tree and find all DSA masters,
> and make sure that all of them are down.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
