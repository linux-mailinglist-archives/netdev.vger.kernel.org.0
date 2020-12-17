Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 265322DCAE7
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 03:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbgLQCOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 21:14:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727073AbgLQCOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 21:14:50 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEDF5C061794
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 18:14:09 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id b5so3163158pjk.2
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 18:14:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eWkkJ2JLd8x2IZKlOPuQU5buDtXm7ilXoF54qeZ5Llc=;
        b=XbPyxnYVzdunEv3uojruLqt39LNb4y7wj/Vw30fKdDI0d+H8gtnsOaBRGtq2M0Qrfa
         3uR7PpuZQU+ATGP7G2ZljkHO0eHTD+sokBeVq5yfqT2Cu4QJTc3tynMRTbagzAhPDbCU
         i/lEvhKBA0qFS2WjACJLG8ZChE7666uJEF6I+cvlTCwZva+0nWZ9SUcyp4cEi9MrZPnc
         gz3scDmArUpjJXpbdmZeFAJTpO44/44dauBUopXBHlQypgS5w6XESRLvdhp+FaunZy1m
         ox4PYIGLZp5QQT/GJtgntUxRC1Fg/+5BbQwlxImhis7fRLV3VyU0oWoFbMKONajQSS2U
         Kvyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eWkkJ2JLd8x2IZKlOPuQU5buDtXm7ilXoF54qeZ5Llc=;
        b=BBegzFZe4c/3vZQR/jDXGVMQGYWbFXB3porKYj3Xi6n0vsfSI+qWuMI+8x3v38n3uY
         ak3XQFH3R7zcr9+xN9E+Rn4IsZauoN45hUoSF2xFYiIWqpKq7wMKb6qIKLmJ6Lv/lY9i
         WVbXPsJ/BA93IbdCeNnCTIeKiIe3KLLIWcxGo3JC0JJAaeuIkrw1i+0xoHSm9FmrFDkU
         P1mY3/b4Jk6tUQ9ubsncmLeBqfHWG71e2/n+chmjZ9hSAgoCyJDg3c92JHOtAvmGTree
         ixN2bKoAUjon2NQoAySBJNfN4U9h7mZOaHjgHotuKvq341fnTBcJj3cYZIIQvjTObW23
         i1kQ==
X-Gm-Message-State: AOAM5334q0NR1ITUxilST9CUJ6CeTaDoDIj4scknl0dNl8Atzwg9LO03
        CgknKcyQft05xyzAJZoWYQQ=
X-Google-Smtp-Source: ABdhPJxf+f4+e2ydcyC8IRceTPVPKMwQYxqbi2SFM0L5KbPhiDB/Yu5d6m/F81e3PlobRr7aHutpMA==
X-Received: by 2002:a17:902:167:b029:d8:cfe5:bdee with SMTP id 94-20020a1709020167b02900d8cfe5bdeemr34169511plb.11.1608171249457;
        Wed, 16 Dec 2020 18:14:09 -0800 (PST)
Received: from [10.230.29.166] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v17sm4140975pga.58.2020.12.16.18.14.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Dec 2020 18:14:08 -0800 (PST)
Subject: Re: [RFC PATCH net-next 1/9] net: switchdev: remove the transaction
 structure from port object notifiers
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>
References: <20201217015822.826304-1-vladimir.oltean@nxp.com>
 <20201217015822.826304-2-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <1644d807-eaea-3fde-0cea-cf0e9210272c@gmail.com>
Date:   Wed, 16 Dec 2020 18:14:05 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201217015822.826304-2-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/16/2020 5:58 PM, Vladimir Oltean wrote:
> Since the introduction of the switchdev API, port objects were
> transmitted to drivers for offloading using a two-step transactional
> model, with a prepare phase that was supposed to catch all errors, and a
> commit phase that was supposed to never fail.
> 
> Some classes of failures can never be avoided, like hardware access, or
> memory allocation. In the latter case, merely attempting to move the
> memory allocation to the preparation phase makes it impossible to avoid
> memory leaks, since commit 91cf8eceffc1 ("switchdev: Remove unused
> transaction item queue") which has removed the unused mechanism of
> passing on the allocated memory between one phase and another.
> 
> It is time we admit that separating the preparation from the commit
> phase is something that is best left for the driver to decide, and not
> something that should be baked into the API, especially since there are
> no switchdev callers that depend on this.
> 
> This patch removes the struct switchdev_trans member from switchdev port
> object notifier structures, and converts drivers to not look at this
> member.
> 
> Where driver conversion is trivial (like in the case of the Marvell
> Prestera driver, NXP DPAA2 switch, TI CPSW, and Rocker drivers), it is
> done in this patch.
> 
> Where driver conversion needs more attention (DSA, Mellanox Spectrum),
> the conversion is left for subsequent patches and here we only fake the
> prepare/commit phases at a lower level, just not in the switchdev
> notifier itself.
> 
> Where the code has a natural structure that is best left alone as a
> preparation and a commit phase (as in the case of the Ocelot switch),
> that structure is left in place, just made to not depend upon the
> switchdev transactional model.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
