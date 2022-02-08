Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90A5D4ACF2A
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 03:50:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346116AbiBHCtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 21:49:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238186AbiBHCtI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 21:49:08 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EA88C061355
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 18:49:08 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id u130so16412887pfc.2
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 18:49:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=/g5X7x+Y37vmO5/K0hZfQ2FtK0pElMwxoTXp91GMfAU=;
        b=WteB6HHm0shpkwyZlmo0AZcnVW1tsGw1UA3i4RNeBLFjmmZhyBsHl1FD8q2Zvo7g6L
         U8AwGTAh7q1BcC2ndl4HPhquVMc/dZc2RkCezOrKhDziWzF5m+sYNpav99AE4f8WnpR/
         Ey8I7V8kjs0mJ/1c2JyyszF+fB9SMyxMHATVq6xrTGQ5CADKHE93OhgIeF9u+GbQ7bz6
         LNlm7lo4cunyv7mvtMdnpQTTw8kwqA69ScCJOotlwebDL51mNmcHz7OQ6ISk5LF1hSP2
         MH01di5TJzTnexSYa1qYmVjCaIQyVFnIkii8WftmjS96LfdTIlZRIM7KeAYCAEdQInHo
         jSFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/g5X7x+Y37vmO5/K0hZfQ2FtK0pElMwxoTXp91GMfAU=;
        b=Z2j8+0kExKWO/0yXecQ7qXf9XhWzDDrA3hcqS+f1U4j/KQh9Bja3OW8+DrZ6SioLxn
         p6BEstABSiI83VpNcJkIAD55Lv4kHMlRltBmrS3iiY17ugmLEHDwHlvGB+HRfoqLwoY5
         R2XNTPMIzdzKC1QejXm89NdiRQKeDzvQvfoV+ws4ssIaP6A4qWQf5Hg0yf0TBHG0AxIC
         IsmGFd3fp3l58DhnF8W7plcgM2d26dE3xCAtVlbOeemtsCStfjVVwG0gicZ/lcPs1+cL
         KD7V45+boTIWxylaHseyRmGiPUInkBy5A5q4kCFTdfRqHFZMSQYCA8QV+6XWmVPRu6Ez
         Gm6w==
X-Gm-Message-State: AOAM533EJHn2BlbCmKVyz8UZpNQjcwDQzvZX0KQiW9zWDELOxzXBPJGl
        MViwuWLbKx6uANFV8W4XTTM=
X-Google-Smtp-Source: ABdhPJxhH3tUO5Rs3OoEb9IF3jUjk9Ab0YW3o2yw2VqGRuLkn+3L033QdXTXhlWhfxijipsIFNVyPg==
X-Received: by 2002:a63:6984:: with SMTP id e126mr1896716pgc.520.1644288547855;
        Mon, 07 Feb 2022 18:49:07 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id q2sm14173130pfj.94.2022.02.07.18.49.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 18:49:07 -0800 (PST)
Message-ID: <64b70058-f823-131f-9926-ee36cac69105@gmail.com>
Date:   Mon, 7 Feb 2022 18:49:05 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH net 6/7] net: dsa: mt7530: fix kernel bug in
 mdiobus_free() when unbinding
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        Oleksij Rempel <linux@rempel-privat.de>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Rafael Richter <rafael.richter@gin.de>,
        Daniel Klauer <daniel.klauer@gin.de>
References: <20220207161553.579933-1-vladimir.oltean@nxp.com>
 <20220207161553.579933-7-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220207161553.579933-7-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/7/2022 8:15 AM, Vladimir Oltean wrote:
> Nobody in this driver calls mdiobus_unregister(), which is necessary if
> mdiobus_register() completes successfully. So if the devres callbacks
> that free the mdiobus get invoked (this is the case when unbinding the
> driver), mdiobus_free() will BUG if the mdiobus is still registered,
> which it is.
> 
> My speculation is that this is due to the fact that prior to commit
> ac3a68d56651 ("net: phy: don't abuse devres in devm_mdiobus_register()")
> from June 2020, _devm_mdiobus_free() used to call mdiobus_unregister().
> But at the time that the mt7530 support was introduced in May 2021, the
> API was already changed. It's therefore likely that the blamed patch was
> developed on an older tree, and incorrectly adapted to net-next. This
> makes the Fixes: tag correct.
> 
> Fix the problem by using the devres variant of mdiobus_register.
> 
> Fixes: ba751e28d442 ("net: dsa: mt7530: add interrupt support")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
