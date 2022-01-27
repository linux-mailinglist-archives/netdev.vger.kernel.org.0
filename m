Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D98EE49E5DA
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 16:18:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231308AbiA0PSk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 10:18:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbiA0PSj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 10:18:39 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59AA2C061714;
        Thu, 27 Jan 2022 07:18:39 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id d18so2782253plg.2;
        Thu, 27 Jan 2022 07:18:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=WqIhQEdz48PlWPYyUraILDyAKoqjq+mQzfifZT10HY8=;
        b=FTAtH8zu4qk5Iwj0kA34upNHGn7nBlN5VfBZDPK2TiMz+F55poljgCKMP6Rg03PaIA
         8Yx6mPTUSKA4JQK67VEheb9BZRfpsg2pQ1GUJ35go2jvZni4z4eHHiZtF06ScSJu3V5s
         mQSd/Ku4cMLZEEaNE1soXtFgH0ptTZkUo59Qc6c31wT1TZH/V+xpuft/9KcX28yc5NPF
         XtEB5Pgiri9u8k1sUVJ3wg16e5tHojKPHHN0Zvoe09B8oBDyenyFQOBLGcTj/uu4gDNc
         vwP8TpianrTJPMf16UGduOulZuT2peSWwVYbIg9T6Wcihp0BgEHT/dODjc1x0AVXPx2L
         4wCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=WqIhQEdz48PlWPYyUraILDyAKoqjq+mQzfifZT10HY8=;
        b=m2SGfKzg9htigrQCiCcN1z2fTdOX9fL3EWSc9Wk03u9+0QLFT0XhAiwEioi8v+ZtjI
         jvmtrqWiaYE7FMtyiRFNDw2CODaRWMTRzFsCP9zXfDKhQeiraRynmE7gKYYsxJD/uRng
         v7VSeDu6IHGMWWcZM2x59lrrv27qeK7XHBDAGT03tPFViMLzSqSxQiNm50RltCaLLDt9
         Tv36S8kLcXkl1r7AHryxqMgoEx12ECwH4VtKEQQfNSQkfUGiMWgcSzx0zq8qRTs1aJjz
         v45Tpwtm22WEOpgcHF/4lNQqQ5HwEOBIMuDR4Er4utByvymIPPV2oBuCexesh13hcQYM
         xSZg==
X-Gm-Message-State: AOAM532O4eyUiXA3hBt8kIFyA4jL6J539NpC1viqSU6v/yQvrZIah5xM
        emQYC3+bLTgk5LJz8WJR3YU=
X-Google-Smtp-Source: ABdhPJxGw09dr0rC62QVyGyQBQVqdBg9zRK/3HN7BFS736rW5pJ20vbTyHfMbPW3k18KzI9Kq669iA==
X-Received: by 2002:a17:902:d48e:: with SMTP id c14mr3548243plg.137.1643296718860;
        Thu, 27 Jan 2022 07:18:38 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id j11sm6025265pfu.55.2022.01.27.07.18.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Jan 2022 07:18:38 -0800 (PST)
Date:   Thu, 27 Jan 2022 07:18:36 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, UNGLinuxDriver@microchip.com,
        linux@armlinux.org.uk, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, vladimir.oltean@nxp.com, andrew@lunn.ch
Subject: Re: [PATCH net-next 2/7] net: lan966x: Add registers that are use
 for ptp functionality
Message-ID: <20220127151836.GA20642@hoboy.vegasvil.org>
References: <20220127102333.987195-1-horatiu.vultur@microchip.com>
 <20220127102333.987195-3-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220127102333.987195-3-horatiu.vultur@microchip.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 11:23:28AM +0100, Horatiu Vultur wrote:
> This patch adds the registers that will be used to configure the PHC in
> the HW.

See "This patch" in Documentation/process/submitting-patches.rst

Thanks,
Richard
