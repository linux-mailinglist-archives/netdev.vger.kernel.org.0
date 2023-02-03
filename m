Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB67768A4F2
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 22:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233840AbjBCVv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 16:51:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233817AbjBCVv5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 16:51:57 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91A15A8429;
        Fri,  3 Feb 2023 13:51:56 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id j32-20020a05600c1c2000b003dc4fd6e61dso6942345wms.5;
        Fri, 03 Feb 2023 13:51:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bipQcfxxgHejuf8Mvmt0Oehiv6b0QTtaEvVKGh1al5w=;
        b=UR5pGoQIBPoQMoUsfVzez1iVL+03ECJZOFeQMeWqSw9ysZHfIhjz2/GoLPtPORKdyD
         kjZrF0rjAPYHRSzwTCFQPLB/YkVNouPkxo2nyZhf2D+StDGMANC6Vdr4RKbqe94lZp/G
         IEQZrV/DVZwGMHDgG9Tmd7NNP6C9jfqQSKr+GPeExRZ9TBaItLV4EywgkwP0YKpZQ4Ic
         GOfmhuDO3nMqIppGygCMi8347qW7BGuFkuqDGhwpAHfEAi2NQWo3TaSzec7CZiT1FHgN
         Alln5Qoy891T/2dVSBCAogFDypj9DM+RKhM2sW35fb63qBLK6wOoWDyLlocQ04/B0nAk
         ZS3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bipQcfxxgHejuf8Mvmt0Oehiv6b0QTtaEvVKGh1al5w=;
        b=S4mPnicYtgYS+uFKuMEsb9pj95goZL1AFp7ygdb2uqpuETggLQ5pRyIoe9+u3r3vKz
         DJ0cd2Swim43Hg1p5PiNN8Y+8KWeb1Ry/1rI5rmqfPn5NPAaAkHPyhYS4qlWgdRkjm+p
         yCShlM95l59gn7ZT8dX3f6jSAcMz00mddlYZuLKkXt1b/Roh2CrHf1ZeLj2oGOKMvJkO
         GhXIByWnzJTqGwYflrEJ8dgDmqQVIkyXihViIyaNP93tOVRiY4SKrrmc+ZjxTj7J7xc3
         sXEFR7egI07BTlB4jXzX06k7ZYgAjwi6YambcY+PqOdGJL66qK84PFXB2YJvYg1hGUXj
         BSLw==
X-Gm-Message-State: AO0yUKXosrxtyxgQqMvTHi2iAzKxIj1Cud+N0jzVDK51CFUYhI2XBFh+
        7u2p9a3q7PGHD1alms15Z60=
X-Google-Smtp-Source: AK7set9qtv0vcegLPmhzyEhGngSRE68XavVQ16mxDVL3f7zdabhOU9eMvM9mXSjnxhEqd4oMKvNpLA==
X-Received: by 2002:a05:600c:2110:b0:3dc:5093:3457 with SMTP id u16-20020a05600c211000b003dc50933457mr10778847wml.10.1675461113943;
        Fri, 03 Feb 2023 13:51:53 -0800 (PST)
Received: from skbuf ([188.26.57.116])
        by smtp.gmail.com with ESMTPSA id a6-20020a05600c068600b003dc3d9fb09asm3615409wmn.47.2023.02.03.13.51.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 13:51:53 -0800 (PST)
Date:   Fri, 3 Feb 2023 23:51:50 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Jianhui Zhao <zhaojh329@gmail.com>,
        =?utf-8?B?QmrDuHJu?= Mork <bjorn@mork.no>
Subject: Re: [PATCH 1/9] net: ethernet: mtk_eth_soc: add support for MT7981
 SoC
Message-ID: <20230203215150.k2txv7trkwgmz6vr@skbuf>
References: <cover.1675407169.git.daniel@makrotopia.org>
 <301fa3e888d686283090d58a060579d8c2a5bebb.1675407169.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <301fa3e888d686283090d58a060579d8c2a5bebb.1675407169.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 03, 2023 at 07:00:21AM +0000, Daniel Golle wrote:
> The MediaTek MT7981 SoC comes two 1G/2.5G SGMII, just like MT7986.

comes /with/ two 1G/2.5G SGMII /ports/
