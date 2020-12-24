Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A20C52E28D8
	for <lists+netdev@lfdr.de>; Thu, 24 Dec 2020 22:25:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728932AbgLXVWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Dec 2020 16:22:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728829AbgLXVWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Dec 2020 16:22:21 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B20AEC061573;
        Thu, 24 Dec 2020 13:21:40 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id m5so1697886pjv.5;
        Thu, 24 Dec 2020 13:21:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mJV5/ZNJMl37LkuPhM/bYdGnn5sTPLpvGos4VVzjWj4=;
        b=FZJ0wxSvZiakp8qbzmH519JkKOoQ1zUNDqHJAPmDCP1J3SM2Xrm33Gkn5+PyWaOH6p
         88imIKvB5JEZSRBea/C0KB3R9ZstiHQtAucrsS7AsgdgPa1RTMA0MN3nX6o4vheN5K2H
         uw3len2wfoVJXh7mJoMlqZ1VVaNlu6KP9sAEWDDEjuMuKlxhNbwTZCH7ZihsjYC7oFpd
         AfLdi7oprN+xJ/pufXCjthF7TiCL0SUbiZsaKecUXfUiizzPdT5NfAleiQy0tkJdsLgc
         2xvj9I+Y8zLPQLJ6gcbfByJGRKWWDriQcboOJZmBBQL/tc3ukdLM4/5mz9Vk6jrXW2zc
         MHPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=mJV5/ZNJMl37LkuPhM/bYdGnn5sTPLpvGos4VVzjWj4=;
        b=PEOJjGnG9ftUByEWnjC4hMiYrW7wrgZ90GBCD1xGkr22saqOvPQASIv8jnsiSb8fNr
         0OqWrmiuYo6mZMdpO2n2HtLa/rFZC84MG0q8c7sF0IiL25m6vzQZWxx3+MI2dVDG2T6z
         ThFoh1LLLvlalWxhXwoUbo7rXAF5vigqWYmQdkBE0vb79meWkWf/iv7joJvk8cb8bXfF
         cRpauPCiKPCm9vVLKN4SkfVTXWdkt1OQAsb8N7gTNetDbRwRRu/i5FCJikX/QSY4zKOg
         SgGz/iBhRUVMMJRK5BpNs/96BICtlwY3PWinfoH9lnbFvsNdizJcLV56HH0DZ3u7gqXw
         It+g==
X-Gm-Message-State: AOAM533jvEYGDbN7g523Buog2Bz23nAwrgoL+DnNXwvyR4zWnmbwYH1P
        PKu9iauQEUuScUkMCVES0wI=
X-Google-Smtp-Source: ABdhPJz/kdUz85L7TKJToYZf1ZNwZsCV5u8BIcRcrT2oGwbfABYsCIy/nGaZ1i89RUMbZWCYErFSDQ==
X-Received: by 2002:a17:90a:9707:: with SMTP id x7mr5967332pjo.72.1608844900203;
        Thu, 24 Dec 2020 13:21:40 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id q15sm15875424pgk.11.2020.12.24.13.21.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Dec 2020 13:21:39 -0800 (PST)
Date:   Thu, 24 Dec 2020 13:21:36 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>
Subject: Re: [PATCH net] net: ethernet: ti: cpts: fix ethtool output when no
 ptp_clock registered
Message-ID: <20201224212136.GB1229@hoboy.vegasvil.org>
References: <20201224162405.28032-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201224162405.28032-1-grygorii.strashko@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 24, 2020 at 06:24:05PM +0200, Grygorii Strashko wrote:
> The CPTS driver registers PTP PHC clock when first netif is going up and
> unregister it when all netif are down. Now ethtool will show:
>  - PTP PHC clock index 0 after boot until first netif is up;
>  - the last assigned PTP PHC clock index even if PTP PHC clock is not
> registered any more after all netifs are down.
> 
> This patch ensures that -1 is returned by ethtool when PTP PHC clock is not
> registered any more.
> 
> Fixes: 8a2c9a5ab4b9 ("net: ethernet: ti: cpts: rework initialization/deinitialization")
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
