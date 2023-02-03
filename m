Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ADA968A62A
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 23:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233050AbjBCW1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 17:27:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbjBCW1B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 17:27:01 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B7598C1C9;
        Fri,  3 Feb 2023 14:27:00 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id o36so4925364wms.1;
        Fri, 03 Feb 2023 14:27:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jurn9Xl39+lOyl7ynfR7764vZm+bPZub6GwDaU1WTio=;
        b=iYjzenTqutnchFRPKwX069Lo8OCMSAnSdKZhm8TuPGub/Mba05GXm13GEKbRQgP+/D
         gZQxqDAgqnPxtgms2QnozyCRD0AgKFsW6Eeu0TPie6OTGD29BNa6rrb8rLxMFPnlEh3Y
         YaDk37QDaMw+TP4pM+Zx4pnANzFBahhNxXLTb4uxnwk3npOuCmzczbkLMCtWiLEKbqV0
         /qxbig3R9W3uWHethRwpNlDzpznirjDBeXR12KKYu1o9GJWhHzODazGUZzA4Z/hoeV4E
         UcMHRz4axOnpAu4AJ583f5G9JXE0uOVCiqkvnMU8lT9ME5ww6hnjiDwlXZWUdnFX9CSd
         nEJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jurn9Xl39+lOyl7ynfR7764vZm+bPZub6GwDaU1WTio=;
        b=3Uo9fPlj3EZInfmGZBJTyNojemPMJOw68NqR2jlRGExwvw5yZQfzss5IeUnhG5Wryy
         bc3Ibb8StSxu7ttXRbOzqM9kzG6PT7cPZp8ttr0mEZU1ylPPiXt6jcT4pInskkmIaULC
         QUERC5dKPogh5vIcFGt7IkD3xTzmRzq8hnvvpT0JLVv3+yE6vOhHNb5rry2qGOFf+ZEm
         Law61D7lA2FwoCnKo0qDHcU93hdCY86KgCnJcWJTJTquTtxPht6DSMkYie+0ibqtqbSx
         W5EgfozT2hw7b7r7+w1wszU5qZuZLiZ6KXK2tMQHjITHA1kFSylhZCMaIbJbj0ZJG3rn
         IyYQ==
X-Gm-Message-State: AO0yUKXb9yXmrAS7WOwQgtbgAonmra9X9Ri/m3vtMEjw7m/jBr4zxbcd
        6qJ6tOviHLVzePDt7jylFq4=
X-Google-Smtp-Source: AK7set/ZNS0u1GzxheAwHXQZQ/S4Daj7aBkBSdtH4UG7XIyINkTzXTlsjMBri8WQnjjawyjOJz8GYg==
X-Received: by 2002:a05:600c:1f10:b0:3db:742:cfe9 with SMTP id bd16-20020a05600c1f1000b003db0742cfe9mr11765807wmb.34.1675463219130;
        Fri, 03 Feb 2023 14:26:59 -0800 (PST)
Received: from skbuf ([188.26.57.116])
        by smtp.gmail.com with ESMTPSA id o2-20020a05600002c200b002bde537721dsm3017536wry.20.2023.02.03.14.26.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 14:26:58 -0800 (PST)
Date:   Sat, 4 Feb 2023 00:26:55 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
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
        Jianhui Zhao <zhaojh329@gmail.com>,
        =?utf-8?B?QmrDuHJu?= Mork <bjorn@mork.no>
Subject: Re: [PATCH 2/9] net: ethernet: mtk_eth_soc: set MDIO bus clock
 frequency
Message-ID: <20230203222655.gjfasxbw2je3r5pz@skbuf>
References: <cover.1675407169.git.daniel@makrotopia.org>
 <cover.1675407169.git.daniel@makrotopia.org>
 <a613b66b4872b5f3f09544138d03d5326a8f6f8b.1675407169.git.daniel@makrotopia.org>
 <a613b66b4872b5f3f09544138d03d5326a8f6f8b.1675407169.git.daniel@makrotopia.org>
 <20230203214844.jqvhcdyuvrjf5dxg@skbuf>
 <Y92Hc++jn6M6AIBQ@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y92Hc++jn6M6AIBQ@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 03, 2023 at 11:15:15PM +0100, Andrew Lunn wrote:
> > Checking for valid range? There should also probably be a dt-bindings
> > patch for this.
> 
> This is a common mdio property in mdio.yaml. So there should not be
> any need for a driver specific dt-binding.

I meant it would probably be informative if the dt schema for this MDIO
controller had a "default: $val", "minimum: $val" and "maximum: $val".
