Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4F43F4467
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 06:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbhHWEiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 00:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbhHWEiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 00:38:23 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0ADFC061575;
        Sun, 22 Aug 2021 21:37:36 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id oc2-20020a17090b1c0200b00179e56772d6so7910782pjb.4;
        Sun, 22 Aug 2021 21:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-disposition:content-transfer-encoding;
        bh=u54nPhOEhW1RGHPi+2Fc2Z+a/qgjBmrNadbNxeIbSis=;
        b=QObn9PQRBowrHeJm48tpTRoLkLYYROG+H4dE0zsPOLCazQtxreEK4Tvk8T8QaBByC4
         yqBLdjTy3I+Jdv9QmV9CzdHT9xg8oL2i0uBq4IGjjuGbUM/1bIfF8Syl7ZMOr/5NFnrQ
         HEjKkmWHjs+a7CMvdlHZwBR3WbAIIhfqwOhwCUiuQizuGI9zrBtsMXu17bwZxtV+8zAQ
         tvgw+YpH6ii5+lMqPVHx7DUk89xp28U5mDEprxnTkVu0g1R+RABBf2/5VQBGAibpNKse
         FlkqIZizVIfPtTj5/WZie/00MkpGogtGNvz89ZNIshj7FWV9UtI3+93naEa6D92ckMS4
         OlEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-disposition
         :content-transfer-encoding;
        bh=u54nPhOEhW1RGHPi+2Fc2Z+a/qgjBmrNadbNxeIbSis=;
        b=p/eb8tt08Hip53kYj1ShUidK89fNzomPauLYW/6tV1z6DUoBeqpXCle2Ik5VacSfLW
         cD6Df6VGW+WWL/JvB6NbA6NA8I+0Zqj1IowBZl3q4wIXkH4+G4DccQ5HlrtQvd2KOH63
         6V5UATdWsO80AC50ejhD2rcuN1VJakmmyPIlRmZq6MuLLqhoqmJtchYxggZNGjr+B2X3
         VRA3LK3lQ35zh2A9UcCHnPi3o3zQ7+mhneb2NKVjFyaIiodq2wExDuCL6h880Y18rJzg
         cDvqChhJHtjqkEiyWgvlJYElUeKQFgAx8UowYgWG0oSBSNpP6utAHVo5ldavzwEuNgII
         2xgw==
X-Gm-Message-State: AOAM531zmE6kNSoWiPANpKhjiQ+FC54KVeKetunsvdG/JvTb9pIXxlPv
        AltgDkLXS2hGQ5liuATxgko=
X-Google-Smtp-Source: ABdhPJzxICy3NaChT4pt6b9K0wIft3K0ys+yb4cM7/3xkail5HH05YsvYVoO+3bALcD/yxtoOQdA2g==
X-Received: by 2002:a17:903:2305:b0:12f:6a02:808d with SMTP id d5-20020a170903230500b0012f6a02808dmr20158102plh.75.1629693455494;
        Sun, 22 Aug 2021 21:37:35 -0700 (PDT)
Received: from haswell-ubuntu20.lan ([138.197.212.246])
        by smtp.gmail.com with ESMTPSA id x4sm14417627pff.126.2021.08.22.21.37.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Aug 2021 21:37:34 -0700 (PDT)
From:   DENG Qingfang <dqfext@gmail.com>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, mir@bang-olufsen.dk,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next 4/5] net: dsa: realtek-smi: add rtl8365mb subdriver for RTL8365MB-VC
Date:   Mon, 23 Aug 2021 12:37:25 +0800
Message-Id: <20210823043725.163922-1-dqfext@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210822193145.1312668-5-alvin@pqrs.dk>
References: <20210822193145.1312668-1-alvin@pqrs.dk> <20210822193145.1312668-5-alvin@pqrs.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 22, 2021 at 09:31:42PM +0200, Alvin Šipraga wrote:
> +/* Table LUT (look-up-table) address register */
> +#define RTL8365MB_TABLE_LUT_ADDR_REG			0x0502
> +#define   RTL8365MB_TABLE_LUT_ADDR_ADDRESS2_MASK	0x4000
> +#define   RTL8365MB_TABLE_LUT_ADDR_BUSY_FLAG_MASK	0x2000
> +#define   RTL8365MB_TABLE_LUT_ADDR_HIT_STATUS_MASK	0x1000
> +#define   RTL8365MB_TABLE_LUT_ADDR_TYPE_MASK		0x0800
> +#define   RTL8365MB_TABLE_LUT_ADDR_ADDRESS_MASK		0x07FF

FDB/MDB operations should be possible.

> +/* Port isolation (forwarding mask) registers */
> +#define RTL8365MB_PORT_ISOLATION_REG_BASE		0x08A2
> +#define RTL8365MB_PORT_ISOLATION_REG(_physport) \
> +		(RTL8365MB_PORT_ISOLATION_REG_BASE + (_physport))
> +#define   RTL8365MB_PORT_ISOLATION_MASK			0x07FF

Bridge offload should be implemented with these isolation registers.



FYI:
https://cdn.jsdelivr.net/gh/libc0607/Realtek_switch_hacking@files/Realtek_Unmanaged_Switch_ProgrammingGuide.pdf
