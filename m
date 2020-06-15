Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E821F9777
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 14:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730243AbgFOM6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 08:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730071AbgFOM6q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 08:58:46 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 448C0C061A0E;
        Mon, 15 Jun 2020 05:58:46 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id m7so6782517plt.5;
        Mon, 15 Jun 2020 05:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XitcCGm+N2xk+i04pt3A4f+pfim66XLwLBHkrjOHPeA=;
        b=ZVr/Sb7MOhagf/RGhel4f7RhEI8nQ3l15ir4uqZwbq0/IUw01U7/hK4l9O6mmhpaQe
         TH2PvZZczVErnPhIU4XubP9XEwIYH2ymLXfgTeP7G6KctMqFiJ6sdsKv2PuyNRbQTJgk
         tLsUoZ8oj3NvigYd0YXBG+4zd+Esjx5kSTNVNapIuqBF4MlKSdnw/iNqb92Dwki7/8lQ
         EYWHyEuqfGDqxAA1HKxN/Gct2whmlDSnPNCENYujxpSWEHQhKazOeoTeXCOtrx2gO19v
         PuwpM6occwi3z8U1+cXSEccQSqJkzO4ASQSmx/BeL+BrCZF/AI5AUD0yFhc3KkJ/KwCW
         K5pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XitcCGm+N2xk+i04pt3A4f+pfim66XLwLBHkrjOHPeA=;
        b=oDyFk/5kCdpvGvhe6Il5gXrGhTvEPwbD1vQrW1GWVxWVw8Rp/kJ12pXMw+EiFQ2llN
         1JWJDn1BbwQ4CzixBi31S430el6zB6W2/NVA4rl6Br2wSR28/Znath1Frrw2Cfp01p4b
         kvfgLtF6IIqEbFBqe55llEVxeyH0dIIpIeDNJh86++DajgfjOm5rV+Ds1FtQq9yA8zyr
         RSDVtbAQtmaGUNt3Ewer9VU3NwQ+czWiAFTAYDguPq2KqkkQ/6gUSW8Tb+Q1GWOFEt8S
         jci6cT3/dJ/f+sYcHg/PKElvuP59zfcjsUP8aU24G5d1ihMSgbtmLbiqId15jaRqeMcG
         XpuQ==
X-Gm-Message-State: AOAM532fjSM6Ti19Zphl4WFryLIYtWSRmaRnL3vLKrvrwkUHV2SwsTXj
        OFzShTf6UhOl9c6Nm4BLLlU=
X-Google-Smtp-Source: ABdhPJwfxJvN6VGMc2O3Y02pnnTEat36EFoaAi15AnQE+izYbp/GXj23cVtK4kjHmr1rj/U2FhWHcQ==
X-Received: by 2002:a17:90a:ed8f:: with SMTP id k15mr10829721pjy.63.1592225925722;
        Mon, 15 Jun 2020 05:58:45 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id q129sm14496133pfc.60.2020.06.15.05.58.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 05:58:45 -0700 (PDT)
Date:   Mon, 15 Jun 2020 05:58:43 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, vinicius.gomes@intel.com
Subject: Re: [PATCH net] net: dsa: sja1105: fix PTP timestamping with large
 tc-taprio cycles
Message-ID: <20200615125843.GC16362@localhost>
References: <20200614205409.1580736-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200614205409.1580736-1-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 14, 2020 at 11:54:09PM +0300, Vladimir Oltean wrote:
> So fix this case of premature optimization by simply reordering the
> sja1105_ptpegr_ts_poll and the sja1105_ptpclkval_read function calls. It
> turns out that in practice, the 135 ms hard deadline for PTP timestamp
> wraparound is not so hard, since even the most bandwidth-intensive PTP
> profiles, such as 802.1AS-2011, have a sync frame interval of 125 ms.
> So if we couldn't deliver a timestamp in 135 ms (which we can), we're
> toast and have much bigger problems anyway.
> 
> Fixes: 47ed985e97f5 ("net: dsa: sja1105: Add logic for TX timestamping")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

Acked-by: Richard Cochran <richardcochran@gmail.com>
