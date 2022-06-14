Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3168D54BDC3
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 00:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344100AbiFNWgV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 18:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbiFNWgU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 18:36:20 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EBE84F446;
        Tue, 14 Jun 2022 15:36:20 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id y13-20020a17090a154d00b001eaaa3b9b8dso352654pja.2;
        Tue, 14 Jun 2022 15:36:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=iCRqf9cUXGD/wTCU/6Imd8qKcHz2+4H04fjUrasRl3Q=;
        b=dXr0HBARH/IhMAQCJKv5GP/8b08Y0SB7y9aFtTCe0fb0G4y30PWyglmseb299ngDiM
         cnPWKX3tO0YN+LEizKNUAb6YLg9u+Q8jugjiTinGo/NJLmDrHvK8GCygJq7qXH5iOh6/
         ALPNLJHtx9F7bAhO7wEAFYtfZPsJueJFS6cSyORBByLqe6oRMZCEl2xi0gqN3MpzjIN8
         SnKU+eLAEj+x4Q1otFcVNWBcN9/71rA6cWzQp4uDerRoYDbPjyblGJ18SCZvoT/HoXHQ
         Gdq+atH6IeNhy9ngEyOpbc1Q4CEfYaYIbXc/yx/ZBhJBHF7uyIO7zHSOb39Xt6/cLL4C
         ezIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=iCRqf9cUXGD/wTCU/6Imd8qKcHz2+4H04fjUrasRl3Q=;
        b=WwMqkybpTokewLKqSnf2xyiiAsBSkhj+ftLqL/7MqwmdgZZC6Pcc2IVtOGKKgiYRht
         /j/4OF1CGw6AQOQj9HFMCWysAz7Zm8UZwTZHNRsTmv7MgFSB8L0eV5k3WwyQj+zeIGM+
         6uFwJaDDqhecfcF+45GakYOY7WNQDUsKvNWyoqkxV6Jm/FmxNG0y5GZhO32t5kcmZiua
         V6ql+XBya2VUmiPS/Lo1nkEYzJT6rSTE3vVZeNu75fJONEQ8p/KaGMkJ5MAqRQPsQsi0
         B70H/Kj0LJ0+RKb7p5k/Tm5/pi3OVqwWiGyZ/j59dgxsaNJHHMgo+yZ1AmoLntHer2uw
         L8fw==
X-Gm-Message-State: AJIora8HSpvZLOOaiJiX8a5H2sRRsvOxae6UdPRNzSvPKxcUybNcG8JH
        lFyd1Hl/w8PiSjhylt5AYmw=
X-Google-Smtp-Source: AGRyM1veauvE5xHkBIG4jYd5/lRRAunReUDsP8s8Jdo6vfU1q8m9/D0HJO7/fGHR1qQFm6XVLzYNJg==
X-Received: by 2002:a17:902:d143:b0:168:d336:9de6 with SMTP id t3-20020a170902d14300b00168d3369de6mr6292271plt.124.1655246179952;
        Tue, 14 Jun 2022 15:36:19 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id t20-20020a17090a951400b001d903861194sm105946pjo.30.2022.06.14.15.36.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jun 2022 15:36:19 -0700 (PDT)
Message-ID: <21d78f56-77de-ba37-9e07-fabcc2f22e6d@gmail.com>
Date:   Tue, 14 Jun 2022 15:36:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v4 4/6] net: dsa: mt7530: get cpu-port via dp->cpu_dp
 instead of constant
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
 <20220610170541.8643-5-linux@fw-web.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220610170541.8643-5-linux@fw-web.de>
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
> Replace last occurences of hardcoded cpu-port by cpu_dp member of
> dsa_port struct.
> 
> Now the constant can be dropped.
> 
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
