Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5A2C33E210
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 00:25:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229536AbhCPXYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 19:24:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbhCPXYT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 19:24:19 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7897C06174A;
        Tue, 16 Mar 2021 16:24:18 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id r17so74933448ejy.13;
        Tue, 16 Mar 2021 16:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9OOhgWbqr67LfYXMSnmxTKZM8wBTW3XFbMhBmmpGoQY=;
        b=fYkXsmAGvfeWQg39peggYjDSvx+cD8AScd8R2/tIT0BouooMtLsMsmZsTe92jffS4I
         tFiIIeSxS80hnjMLfPEFxFu7Gou4g9gNvla2861KYAsgOLSvth13jT0VBQub/5PMxLah
         fusCTc+UplJAC5mSlt4XUfi6CJxejywkqL0Vzk/IuKMDXk9uG5CmPp0uhRVg6pWbi3C7
         EUPfnRhXWdoe6js9lIaDvjRG0VQgW9QKqEfhbOfdFc7ArExpnWd3uJwGyRxkcxv0Arlq
         QPdGvgmCC7b+sWgeHxXLqE4yt9M4jGtZXNAdJtI+io+yFSPjFMZPUMctEBtYDkDSJC1t
         jt3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9OOhgWbqr67LfYXMSnmxTKZM8wBTW3XFbMhBmmpGoQY=;
        b=ha5Gi8qYdYJ4b4S5S4/xx5/RvtmLLFK1jpfnBs4cOAntqhvh04nqw8ptezcS3aKxpX
         GzFjWAAwfvK73u71iI1pK1Y51Zz0L96m1m8hNrXfIG5FOLdPchG+5vPLnarVNpmPi3hB
         p7XiOEaQY06lMDR5a5dQUn9SSP+8QM+50+ljZ6EgOnOqT+iAjXmJpZS7oAKbI1QUTdMd
         xIrJ0NFBPdxl5J2lwM62voE3mX2ivzAUCZL9K+hW/zItOGHBI91kcWelzYUQB8oKKOts
         egOWVTZYjfLeEmlUjUJuL8I5LvcR4ndxu6rC+KimJHAnIs6xtOghdfPq7XkWGufj6EYj
         nFAQ==
X-Gm-Message-State: AOAM5305uAkEbZwOyujjG3Wr2iL+pWPJElbI2OvplOsKnS4cEO8DJz1F
        oMG6SAhSvBSC/1ZslqdhDRUayekVXAw=
X-Google-Smtp-Source: ABdhPJxQplHzZrrW6AwrRpcgJ12DXKFWvCJrDgBEXPq2GslgDUTFanpGZwtWHadJVhA+yeERc8eXjg==
X-Received: by 2002:a17:906:8043:: with SMTP id x3mr31743039ejw.149.1615937057480;
        Tue, 16 Mar 2021 16:24:17 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id q16sm4114347edv.61.2021.03.16.16.24.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 16:24:17 -0700 (PDT)
Date:   Wed, 17 Mar 2021 01:24:16 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     davem@davemloft.net, kuba@kernel.org, vladimir.oltean@nxp.com,
        claudiu.manoil@nxp.com, alexandre.belloni@bootlin.com,
        andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 3/3] net: ocelot: Remove ocelot_xfh_get_cpuq
Message-ID: <20210316232416.nlam67bweyfokr6o@skbuf>
References: <20210316201019.3081237-1-horatiu.vultur@microchip.com>
 <20210316201019.3081237-4-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316201019.3081237-4-horatiu.vultur@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 09:10:19PM +0100, Horatiu Vultur wrote:
> Now when extracting frames from CPU the cpuq is not used anymore so
> remove it.
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---

OCELOT_MRP_CPUQ should have disappeared too. Doesn't matter too much
though.

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
