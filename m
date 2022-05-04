Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A65D451A3E2
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 17:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352315AbiEDP0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 11:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352277AbiEDPZ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 11:25:57 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94FCA44A0A;
        Wed,  4 May 2022 08:22:19 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id g20so2084189edw.6;
        Wed, 04 May 2022 08:22:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xTYBUgx4sIq3qSVsjgl0przbRExfOFSCf3/4HQ5y1Uc=;
        b=Tg8Bx/C6xSkcoO2dnyBeqWLtw2X4t7JrowzuBljo19KkSRX3m38bUXkupa3z1LKIYj
         lDc8dTcPIaGDiX8W5KxFNIyHS5gvtVITsZz5B0sxg6t6qFqj8XmvaUZKitBipDise3vG
         zloRxSRT4SrmBSzVIvtpBZBpluOGNuOOCbkwR9MDxZxTkD56RomzQqgffTRXpUBZ8ege
         EWkhyLiMvel0CWoo7osXQxbTKp1qYa/QYtC3hy4j59fctlVsilNKhTrkP7lM+JRKigJF
         OGROArQqHuYpH/tamBr4G2HaA24v8QKypOjDCBqglcJNUxpg+C9EJEyksuZJ2hV58FKV
         GXRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xTYBUgx4sIq3qSVsjgl0przbRExfOFSCf3/4HQ5y1Uc=;
        b=QugPl+C3f4g+5G2jM56uheT6bO7KCnQQ3w7t18r9bE57umqx0TlWvBnwzKgVH+i8rW
         KPTr/kh52aAFgzTq3bYVh9GiexH2cV0TdH9kRD8nZmhbeyxk4QzQDMkOIKaE5rYSjTrD
         p/W4bg3IprGBCgLmWccyJ9J07EaH5fszUHiY2W0TR0HvBiKonAEfKCDOT4AcuBaU6jNS
         kvD2iXkmQJ1N/QjSNvPMIgnfdFv1gZYr0RwVDbOlpSC/Bzzo61CzA7Iayd6GnE0nTzpE
         hwpUEMGmsn1jQ4Gq99RKs7WuSzGZ2sfCrPutDpp4E9oErp00Sbkwhiv/C5CpsJ4gKLX5
         6VAw==
X-Gm-Message-State: AOAM533LN8jm7ASmmOGpgbMNcklzBGXHsVDjdKA7tUURkJdSUKV4Wvg0
        wtMtJA8FTP+ohzRvOZs8MtY=
X-Google-Smtp-Source: ABdhPJwQSHC3W2lpy/MOReI9kMJhEDuuR09hgP0Zb7GTtVs88FaRrxHsHhn/RqOQZsC5VpzSXtF99w==
X-Received: by 2002:a05:6402:12cd:b0:426:16f:c135 with SMTP id k13-20020a05640212cd00b00426016fc135mr23796449edx.297.1651677738235;
        Wed, 04 May 2022 08:22:18 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id jx4-20020a170907760400b006f3ef214da3sm5739421ejc.9.2022.05.04.08.22.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 08:22:17 -0700 (PDT)
Date:   Wed, 4 May 2022 18:22:16 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Frank Wunderlich <linux@fw-web.de>
Cc:     linux-mediatek@lists.infradead.org,
        linux-rockchip@lists.infradead.org,
        Frank Wunderlich <frank-w@public-files.de>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC v2 3/4] net: dsa: mt7530: get cpu-port via dp->cpu_dp
 instead of constant
Message-ID: <20220504152216.747ckl3km7vbep4s@skbuf>
References: <20220430130347.15190-1-linux@fw-web.de>
 <20220430130347.15190-4-linux@fw-web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220430130347.15190-4-linux@fw-web.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 30, 2022 at 03:03:46PM +0200, Frank Wunderlich wrote:
> From: Frank Wunderlich <frank-w@public-files.de>
> 
> Replace last occurences of hardcoded cpu-port by cpu_dp member of
> dsa_port struct.
> 
> Now the constant can be dropped.
> 
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
