Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07CB251A3EB
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 17:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352271AbiEDPZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 11:25:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352613AbiEDPZh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 11:25:37 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF0946178;
        Wed,  4 May 2022 08:21:48 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id be20so2062938edb.12;
        Wed, 04 May 2022 08:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dcuxN/s/TF+UjXWXLcTcHKDiCpnRwTqpk9ocbRhIwGc=;
        b=KQwyzQb52bLg7yCZAC5vdmlTels11FH3BMnN3OsEVle/iBZbpXoBYEg9dt73Jly5on
         OY/6ku75FiXnmJCWsVbtf+Y+JNchz/f9Hj8TSyx3f3bGAEmcvPDbqfTSLlh64M3Xzqi3
         k5UsA+LdWdlRO5jhTCbKWyL96+rAn95UOIqPTVjsZD9nFiWk1GKrYWcRZMEnGcUIx0ZT
         +JUrRUAE04pKlXizrcb3R+WRNQUljSjiADIHPd/So+K7oqChNITFem+GylwzGphH43g0
         QjhqByqYAeOpPtdkBxqHUOdxpSfuhe7JSpsmkno5SwxUZ2D4yLOmY1eWyV17RgozbWxV
         WmCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dcuxN/s/TF+UjXWXLcTcHKDiCpnRwTqpk9ocbRhIwGc=;
        b=zZWAsNzAYNlagJin2tJO855pLNEz835/sl+9qBexWj2o8tlA22VVIB6sLImo/7CTSS
         N8IDDdrNZha62cvG03MJ8vwxaPkIeTkDWASWm3A1PHUlckU+lTsUObwZ9j2jCbJ06EiP
         UTQbAtqYah6nboAFN6We6GPY9EIuEDOp7v/VBwoFjHMpdnyHdZjwy+1FDjoUN6sqRk0W
         SU9dX4MN/es3ztq1vE4k/rtr9ZKTKWlIVvh9+aH7QfQjJ0obIioqiY3oU9OIJztbpogF
         KOPDvgw9hEUu9+QT2ZB1VZ6OJ31A4ZeJPK3xcnRQZLKMAWFYmVHc0/e0xv8gAoE+Y+OC
         3/rA==
X-Gm-Message-State: AOAM531ZCL+zTxZO8lBQiM3hFyeFPPxmupCI4oE8zGN3kYjN3lj67y/+
        1g6g6aYi4w/33tzOHIDkYx4=
X-Google-Smtp-Source: ABdhPJzVqI1eVM2qoHGN5broejw/H+cnupEB+0ZS0oE2wsW33FaVBX9JMvjSWqGf4SyjU4PBLBhDMw==
X-Received: by 2002:a05:6402:190a:b0:427:efb7:bd81 with SMTP id e10-20020a056402190a00b00427efb7bd81mr7535993edz.63.1651677707090;
        Wed, 04 May 2022 08:21:47 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id zp1-20020a17090684e100b006f3ef214df0sm5802549ejb.86.2022.05.04.08.21.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 08:21:46 -0700 (PDT)
Date:   Wed, 4 May 2022 18:21:44 +0300
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
Subject: Re: [RFC v2 2/4] net: dsa: mt7530: rework mt753[01]_setup
Message-ID: <20220504152144.zqxme7xflv54exaw@skbuf>
References: <20220430130347.15190-1-linux@fw-web.de>
 <20220430130347.15190-3-linux@fw-web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220430130347.15190-3-linux@fw-web.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 30, 2022 at 03:03:45PM +0200, Frank Wunderlich wrote:
> From: Frank Wunderlich <frank-w@public-files.de>
> 
> Enumerate available cpu-ports instead of using hardcoded constant.
> 
> Suggested-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
