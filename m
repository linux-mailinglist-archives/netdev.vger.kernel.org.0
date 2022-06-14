Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF1B54BDC0
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 00:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345665AbiFNWew (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 18:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231542AbiFNWew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 18:34:52 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B064D61A;
        Tue, 14 Jun 2022 15:34:50 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id g16-20020a17090a7d1000b001ea9f820449so350665pjl.5;
        Tue, 14 Jun 2022 15:34:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=AHmm98PAzPcJptU2nMgRv/dq7HuAyrlYg6vwIKYPXjA=;
        b=EVNEZd6o3bpvxYSFtFISdR9FG0168s4U0mz6ypOOJp99KiPoh9Ik/oZ+zIH3YUQnQ2
         HrLxu1Giim5FZGhqPLXL1rHISZdFRouO9OtygCS6VSiunI9tDUdPmn0m24L9MmwXzu/j
         KKNxIRlyokhcdqHq/190VDPEBsYt9a9HA8rLwuOC3I/KPwrPeCzRGuV4OCfN3xsv2HTk
         3usgarfpE6/+sGxJyaVyfingn3erRrmcX78ZcUX56lKkhOVREgGEatdxuQzuaaWVhmr+
         GvbPnDykhxVOgptRVZZnEjSXobDOW6H8uZ+Dc+sRRS/+eK4TEVX6cK2Jt0EiNNTGzQhW
         /t9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=AHmm98PAzPcJptU2nMgRv/dq7HuAyrlYg6vwIKYPXjA=;
        b=Rn61eGFwW7oUqoY2g1GcCCXjWRO6/y1B4D5JbEfhgCIfIHzq2To6F7nzFzknrrKJlP
         g2Uc4G6ICI35JVpDEXa2LK01Ml+CucTlggfNWCkUH2n3ztXXQrpaOkmhU1IGHoCsAL7Z
         +qL41H+Qf6Fo8tWbDaUrBIPmOeX3hJbd4Y4UcccOYfbVShvs47Y4NOKBCn66HoEidux6
         2eifm9kJZGptDbey5AIGn6F7VO6fXmgVPJcZBwYQKmw1TVw4z3kILrjoY5V7xIFJhKp9
         Y//p8Tdexa4UW9rcjZK7JdQ60YloYCsvnqzJfEE9y/+h2MzFLzEKs/IrqwTlgayLn4O6
         H+Tg==
X-Gm-Message-State: AJIora+SA92VzIZvbUgKd15eozaluN1iCJFJ2jxF8Tux/Fw6POcPuDgn
        ktC7Tu5ClSxkrqGI83sOQhQ=
X-Google-Smtp-Source: AGRyM1vSg0Mq52lrM13IeIik3eO1LGcurCS+YdMXofPrDxWGFdT/IKpkZVfHH2wr8mkFmN+be5zWIw==
X-Received: by 2002:a17:90b:3b45:b0:1e8:8688:219d with SMTP id ot5-20020a17090b3b4500b001e88688219dmr6695879pjb.231.1655246090167;
        Tue, 14 Jun 2022 15:34:50 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id q21-20020a170902edd500b0016797c33b6csm7736666plk.116.2022.06.14.15.34.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 15:34:49 -0700 (PDT)
Message-ID: <749728f6-fe32-bf3f-e71b-020e58a4cde1@gmail.com>
Date:   Tue, 14 Jun 2022 15:34:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v4 2/6] net: dsa: mt7530: rework mt7530_hw_vlan_{add,del}
Content-Language: en-US
To:     Frank Wunderlich <linux@fw-web.de>,
        linux-rockchip@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Cc:     Frank Wunderlich <frank-w@public-files.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Greg Ungerer <gerg@kernel.org>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
References: <20220610170541.8643-1-linux@fw-web.de>
 <20220610170541.8643-3-linux@fw-web.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220610170541.8643-3-linux@fw-web.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/10/22 10:05, Frank Wunderlich wrote:
> From: Frank Wunderlich <frank-w@public-files.de>
> 
> Rework vlan_add/vlan_del functions in preparation for dynamic cpu port.
> 
> Currently BIT(MT7530_CPU_PORT) is added to new_members, even though
> mt7530_port_vlan_add() will be called on the CPU port too.
> 
> Let DSA core decide when to call port_vlan_add for the CPU port, rather
> than doing it implicitly.
> 
> We can do autonomous forwarding in a certain VLAN, but not add br0 to that
> VLAN and avoid flooding the CPU with those packets, if software knows it
> doesn't need to process them.
> 
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
