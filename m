Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E5F73FB1F7
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 09:34:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234059AbhH3HeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 03:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232321AbhH3HeU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 03:34:20 -0400
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08CFAC061575
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 00:33:27 -0700 (PDT)
Received: by mail-wm1-x330.google.com with SMTP id i3so8113709wmq.3
        for <netdev@vger.kernel.org>; Mon, 30 Aug 2021 00:33:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=BclShfYYdOqAhYouAWe6+YvE1LNWpXyBg2GtzrhC0+s=;
        b=Tpzg0P0+7D5N4hEEyAIed3dAy/YSM9Ia8HdEhGELTEQlCvbTDzRm3NDJ89OhIlAjuQ
         u6SOW6qZk0iGpBUgMHzXOFaJmMQWuKTu7fXErmBL7z9oryxsqYv27NU1we66dI4F6CwO
         xpOA5BiEZNrE2dayYwfdL8C4l0TEeTuwTLiiWt1p7Ilx6RLi8fY5zg4HOpPi7lAPbPK/
         nbs0b8fPzw8IhbSta2sG2hsLYBeq+IBw3qycONMQFmywsrMqJ+GQPe4Eh/DkwSpOKpYK
         wf/OOOS8EpDfrSnomfJSK5c3sy9jtiGiiK6WZj8ENoAlmvIi/ZmrFPslLvPBXbpRmn06
         gg2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=BclShfYYdOqAhYouAWe6+YvE1LNWpXyBg2GtzrhC0+s=;
        b=OpZgc88Y/nYYppsDqjYrCMZSFkU85gjCWWM6j/k3q84Lg6qxCKj71SL8yQ5rMYePuW
         CGWV7bltNvbaUzyzpL2iD/zHOzW4zu+lzN8T0vjGj7aU5aNm614GJi2raAo5JXSOENXd
         ldlPahr/dY7sjdN/Gpsq7igLrsvRxsfomQ7Xcu2/2B3X6Q1848GnNSUraziwWUl3mSoE
         Wq5e/ZtgAbEQfWuHwBLpg1blTMXBtFVQxFyyLaYdI9dRvNk7PpzGmt2am9Hwe3u/48/h
         a88PuaE/+56UEH7iAeoOO3jcFQq9CcJNlclDA8svqSUyRnCs9SHVjZHEfWrLOFb3K4fX
         +zow==
X-Gm-Message-State: AOAM531Vn0YeKugDXwNb/DoMjK96WH/GgcOFfLtVMMw+w3nhHHg0Fhn7
        Y0NdIIDkMyDukRWo61Ub8Zg=
X-Google-Smtp-Source: ABdhPJys+rthvFN859ClwWGSPgodpdecS/P5JEopc6t3hyE/Gd/BRsD7AbXO7zR6hqPN4M97WYUp4Q==
X-Received: by 2002:a05:600c:3554:: with SMTP id i20mr9731118wmq.164.1630308805669;
        Mon, 30 Aug 2021 00:33:25 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id o12sm13614035wmr.2.2021.08.30.00.33.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 00:33:25 -0700 (PDT)
Date:   Mon, 30 Aug 2021 10:33:24 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Mauri Sandberg <sandberg@mailfence.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [PATCH net-next 2/2] net: dsa: rtl8366: Drop custom VLAN set-up
Message-ID: <20210830073324.kye5lhgvsqb6exsn@skbuf>
References: <20210829002601.282521-1-linus.walleij@linaro.org>
 <20210829002601.282521-2-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210829002601.282521-2-linus.walleij@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 29, 2021 at 02:26:01AM +0200, Linus Walleij wrote:
> This hacky default VLAN setup was done in order to direct
> packets to the right ports and provide port isolation, both
> which we now support properly using custom tags and proper
> bridge port isolation.
> 
> We can drop the custom VLAN code and leave all VLAN handling
> alone, as users expect things to be. We can also drop
> ds->configure_vlan_while_not_filtering = false; and let
> the core deal with any VLANs it wants.
> 
> Cc: Vladimir Oltean <olteanv@gmail.com>
> Cc: Alvin Šipraga <alsi@bang-olufsen.dk>
> Cc: Mauri Sandberg <sandberg@mailfence.com>
> Cc: DENG Qingfang <dqfext@gmail.com>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
