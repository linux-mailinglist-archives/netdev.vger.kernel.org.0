Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E58A01E93AD
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 22:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729297AbgE3Upx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 16:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728999AbgE3Upw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 16:45:52 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30237C03E969
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 13:45:52 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id n5so7556952wmd.0
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 13:45:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UtCp6Vo/jeQEDxPAZl29owacGLR05P5ZUr2g1OMmGyI=;
        b=JgdtUcAm6r9uO2sfO8CD49wXC5be0ayC3QYRMALrOMIBycIdUKbKs4mlLAc1WebsaZ
         MHdGKtCBuxWHkR3hC4I3RRnSgLGEym8k96dVYHr79nNlujj4xln2nFaGIfYybm7slJoP
         kXweK33RrzsK51AX6h8MkxHcdn6CxOBDKeTMHx7AGCicDpve6s7vHVGHbqNZOckl02i5
         7+KICcvxn+bua7IRGRBDuCaxd/ls/bQgKpm1ZHD4a18S1Ybn8a1Nq+U+LxK0Wh6zC6pr
         PlOKh/Hzqizy7bEp8YYlzd1vk1zqhAH3ADQkzlpmz2zCfrsOJDorpukPA7ruGfF03j3v
         agZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UtCp6Vo/jeQEDxPAZl29owacGLR05P5ZUr2g1OMmGyI=;
        b=NU7DuQRwptZT0XTcM2TY+ltwn0k6jq2DsveWcI0rdPuK/EnzDPbprpXhkFe25caGTl
         clE2SAE5INm636OEEDasec+7BNz4QE2cdNDBcNzaQ4JVoh1nLTArwaIEn3MjJxZl3aq9
         l1zGQCXK1RrAjAVnj3odnrcj0TuxfbQMwTo4HN056zyGWKova7rmoiJ3IZ50dL6SbBNt
         Jn6ONxcqzOlwn6a57SKvJNd9HRBSad+oY62FkDKFS43WH10wrGu96z7nGAtQjb4NfYgH
         GkhMhvWcGl1CM5nlW8WZM4l2A9gajdqWK/P3hFC8wEaY64nddHtubVu+XW7Qg01SWOfV
         Ktdg==
X-Gm-Message-State: AOAM531rmDrRoB3KYPHxFXQdEJEhCfTYWxv7ZQ1qKbXJbrAgqQmNW2Eq
        rlcxXqK0HvcVK/pjQJSrubc=
X-Google-Smtp-Source: ABdhPJwSeJZy9i9NEerRg8Ylc5JIjC1OT4l33TlA4jLwlz92lbHZRFYIWTfvDjMO+1GWaeg0joE6kQ==
X-Received: by 2002:a7b:cd04:: with SMTP id f4mr15056972wmj.118.1590871550826;
        Sat, 30 May 2020 13:45:50 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id 30sm15232226wrd.47.2020.05.30.13.45.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2020 13:45:50 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 03/13] net: mscc: ocelot: convert port
 registers to regmap
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        antoine.tenart@bootlin.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, madalin.bucur@oss.nxp.com,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru, broonie@kernel.org
References: <20200530115142.707415-1-olteanv@gmail.com>
 <20200530115142.707415-4-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <237eb0b4-993d-89d5-b389-7f95c56da938@gmail.com>
Date:   Sat, 30 May 2020 13:45:45 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200530115142.707415-4-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/30/2020 4:51 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> At the moment, there are some minimal register differences between
> VSC7514 Ocelot and VSC9959 Felix. To be precise, the PCS1G registers are
> missing from Felix because it was integrated with an NXP PCS.
> 
> But with VSC9953 Seville (not yet introduced), the register differences
> are more pronounced.  The MAC registers are located at different offsets
> within the DEV_GMII target. So we need to refactor the driver to keep a
> regmap even for per-port registers. The callers of the ocelot_port_readl
> and ocelot_port_writel were kept unchanged, only the implementation is
> now more generic.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
