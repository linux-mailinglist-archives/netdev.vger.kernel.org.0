Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00FEB510251
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 17:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352670AbiDZP7a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 11:59:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352653AbiDZP70 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 11:59:26 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C27AA31923;
        Tue, 26 Apr 2022 08:56:18 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id p6so2732632plf.9;
        Tue, 26 Apr 2022 08:56:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=gKqBWnCkDhPa/9nmFO0gA+P1ct06PRzyrAfrgkwdtZQ=;
        b=cdtB0ZKQh5fHXEtqwKZRdRpRpNlc2FA7fzabvWnVsZEh471IpBAHTzhJ0Hmz6aKWju
         iGjJYFQtjxcn2O+CnbAXLs21Io7RfvyAqUieYCysQE9eqKrhLrmTs6IgnPQ05LEoKoSa
         mGb/AaJ1wjDcALrwlcoyeqSGW0PSQBfyDAaV1hi6bDju+mYxVqgE6lxoKN62zd+fJ9O4
         iPU8jjQWHVocjekVmqX3dSl1+stabdTaARusTK8LuCUIxqsZKdGbEIM3iIEtAtkwquPR
         jtRMz31oDlntY4KAFFP2KyW7KzMcwE3W55d28blpe24GvF4APEchTykTMObnsJMELQls
         A2bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gKqBWnCkDhPa/9nmFO0gA+P1ct06PRzyrAfrgkwdtZQ=;
        b=qZj1ifVy0FsD1vYvhdqHtKsrdZ5SuWmt1ip2Octc+2GCWLQamdvjaH0V5N6/qhhslo
         r3m7MVf8iOd99VwXtEGNYDOjdVsOfPy96OYl4d1JwgDQ67jrqGJO5FKRgq1CgBIaSo3Z
         JuFo9YUdUpDhNjkCJjZxhx2p1UD5r0k7UenX6gny9GlreRKICCBAWauATFEEbesDkhvu
         HuQ4JQqtfmzWuRk+5mpl3vzHfbMPUANzHByao5wyn+YEOFGUGQHKBReXxZbbqYHE6Ld2
         booYhHmnB0FZ4y2J1TtbzsliJujkVIk6oanwh5lcUQbJkydajikAYpwLMMs86du5Nui2
         nbBw==
X-Gm-Message-State: AOAM532rPcpED6pwSg2fqIly9p6Sm8spHHaoiZddnSI/GLFFv7dkKE4o
        cg+dluXXv6NlwVofBgY6bhI=
X-Google-Smtp-Source: ABdhPJyqc/8SuGr06eAq/HSXJtEMhzP9i+HVQg66AphhwWBy205v6vp9EPzuIdT3+m0E5GQumrVzcQ==
X-Received: by 2002:a17:90b:1251:b0:1d7:f7ae:9f1 with SMTP id gx17-20020a17090b125100b001d7f7ae09f1mr26323671pjb.65.1650988578270;
        Tue, 26 Apr 2022 08:56:18 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id v18-20020a62c312000000b0050d56ae29d4sm3246368pfg.29.2022.04.26.08.56.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Apr 2022 08:56:17 -0700 (PDT)
Message-ID: <944ffc2f-9f5a-a008-95b8-6812d5895b6d@gmail.com>
Date:   Tue, 26 Apr 2022 08:56:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: Aw: Re: [RFC v1 2/3] net: dsa: mt753x: make CPU-Port dynamic
Content-Language: en-US
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     Frank Wunderlich <linux@fw-web.de>,
        linux-mediatek@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220426134924.30372-1-linux@fw-web.de>
 <20220426134924.30372-3-linux@fw-web.de>
 <046a334b-d972-6ab9-5127-f845cef72751@gmail.com>
 <trinity-5fd6da8c-15f6-488d-a332-0ce7625f41e0-1650988498781@3c-app-gmx-bs69>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <trinity-5fd6da8c-15f6-488d-a332-0ce7625f41e0-1650988498781@3c-app-gmx-bs69>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/26/22 08:54, Frank Wunderlich wrote:
> Hi
> 
> thanks for fast review.
> 
>> Gesendet: Dienstag, 26. April 2022 um 17:45 Uhr
>> Von: "Florian Fainelli" <f.fainelli@gmail.com>
>> On 4/26/22 06:49, Frank Wunderlich wrote:
>>> From: Frank Wunderlich <frank-w@public-files.de>
> 
>>> @@ -1190,8 +1191,8 @@ mt7530_port_bridge_join(struct dsa_switch *ds, int port,
>>>    			struct netlink_ext_ack *extack)
>>>    {
>>>    	struct dsa_port *dp = dsa_to_port(ds, port), *other_dp;
>>> -	u32 port_bitmap = BIT(MT7530_CPU_PORT);
>>>    	struct mt7530_priv *priv = ds->priv;
>>> +	u32 port_bitmap = BIT(priv->cpu_port);
>>
>> No need to re-order these two lines.
> 
> imho it is needed as i now access priv-struct now ;) which is not available at the "old" position

My bad, yes, I was concerned with preserving the reserve christmas tree 
style, never mind.
-- 
Florian
