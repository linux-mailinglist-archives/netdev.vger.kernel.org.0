Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B4963FA065
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 22:14:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231395AbhH0UOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 16:14:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbhH0UOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Aug 2021 16:14:50 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C57AFC0613D9
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 13:14:00 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id ia27so16284358ejc.10
        for <netdev@vger.kernel.org>; Fri, 27 Aug 2021 13:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TNksXacY6Mqc1TyLj74Ce75dqEeJv5WxkuyR43T+epA=;
        b=UD93HRHIbqt1m1YL1CXhnpF2ak/8kW5ExetB7fypIbAAIO63CZU3DWz6lk3xa8J1ws
         8odOV0eVUkxHXsXVNYuBdd5oCngfuzW7BF8Fjgq9AfT4QHZL2x3guTN6sEbOBE98kGPq
         e9623WFgzxd5Gemi1l0hI/h2qUqCfhIKvLlm0QNCcjQfAavptUtF4OX/HYlQWOiveuPs
         ksRtDH20sLOHtHXcXFeINEqqRNs4Qzim8UyCq7nIZ/PCRizhWY22INEd2TxTbIstNTKd
         BowlqNlSpM65BwnbXL5ZR6Q1AUfpozE7OM5kyWvARS7dLoodDDjUPVF09I2chBKFjllG
         VH0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TNksXacY6Mqc1TyLj74Ce75dqEeJv5WxkuyR43T+epA=;
        b=Eajeyh7bruDPcZCnkpq2QKOeQefltb56FnPHjbr8gDrK9GuihC/pjkMhNr6nOHvVGD
         QrF2C0UsvXJTCH1sIJQJK3BARkJDRg6OUcQJYq8uc/m+AraokyxFDmhQLYrnrNVqFOjH
         qq91CY7kK4z32KBrC3Zot8qkz2dmi7VCYgbejriuvHt/VsVnBtqoy35xI0KSx7BPIri9
         ityqVLtLuAqzDm5tLwbzoDHWlSSeFCcNJBc/4fRMWeAIuIgfLqbHO6ctHbM+pDDF7WFb
         YB1S6s/uT9QNgtatFZmFwPdyGBq71xaxuGhtt/A2p+s3PvE2M12FcDtVBuHs8u3o7ubv
         ArEg==
X-Gm-Message-State: AOAM531B4gSXcDqve/RZRjGfUEid7LQTBy2nbfq2WJY6WbAIw8Zzsi/k
        MaNJbKNupBIfmg/wF7c27HwKyg9pUnQ=
X-Google-Smtp-Source: ABdhPJxhjcJ3WC7IbYzBV2vtQMs8e/5ZdLPT3wnpqoSK2+7DPsHoxmMm11h81+tH47484lFCAwViaw==
X-Received: by 2002:a17:906:1806:: with SMTP id v6mr11710726eje.420.1630095239407;
        Fri, 27 Aug 2021 13:13:59 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id b15sm3298316ejq.83.2021.08.27.13.13.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 13:13:58 -0700 (PDT)
Date:   Fri, 27 Aug 2021 23:13:57 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: stop calling
 irq_domain_add_simple with the reg_lock held
Message-ID: <20210827201357.awjqqeyjpgqtlq3b@skbuf>
References: <20210827180101.2330929-1-vladimir.oltean@nxp.com>
 <YSkwOWoynVOs5i8n@lunn.ch>
 <20210827184525.p44pir5or4h5nwgk@skbuf>
 <YSlFPhtmcI116ciO@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YSlFPhtmcI116ciO@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 27, 2021 at 10:04:14PM +0200, Andrew Lunn wrote:
> > Ok, retarget to "net-next"?
>
> I would prefer to wait until you have finished your testing and have
> something which builds upon it. If its not broken, don't fix it...

So I'm not actually sure why lockdep only catches it when I move that
code around. Anyways, there might not be anything that builds upon it,
but I see the change as an improvement to the consistency of the locking
order anyway, regardless of whether an automated validator catches it or
not? I mean, extrapolating a bit, would you take rtnl_lock while you
already hold reg_lock, even if only at probe time where there is no
practical possibility to deadlock since the rtnl_lock would have nothing
to do with mv88e6xxx netdevs?
