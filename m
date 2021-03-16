Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B89DE33D13F
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 10:57:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236451AbhCPJ4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 05:56:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236439AbhCPJ4H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 05:56:07 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E372DC06174A;
        Tue, 16 Mar 2021 02:56:06 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id si25so15360245ejb.1;
        Tue, 16 Mar 2021 02:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QYNfh3jaX3N1CtGg7NED72HcSFgmcITNomBhZBJqE/Y=;
        b=uGMvRB1D0xw70y+CqywgeVFN8O2H8SGeov523gtjUoa3d4JflrPmx1ryXrBFlUdjpF
         hacp04N79LXlDGf/LQEJQKlgRado5Q5fS8vPFPDhPT8Ug6WXSqpAOyTVaaVc3bIOk0cX
         ldw1XneeXXuYuimA5flZYweCUnMr6Z36zoHhlsKNvNR4QMUngnYJnU1oqx6/kxLL3vSW
         64cS96xu3+n9VfJB74iIYUjthP83UwHCV6OE6MiAtUSCH91mdEdkT4jFl+QFOlfizyMk
         nk3a7yFivK9qkNFyZlCaN9Hj6kXDEsRgvMH7VbLgwClPp6fhx/HL2O1avjXcAuhjYbCV
         xlgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QYNfh3jaX3N1CtGg7NED72HcSFgmcITNomBhZBJqE/Y=;
        b=TDsZghrfsU8+wVz4oxG5awLixu0uVEeNf1NqFH/s9w68x0CRfxRXpE92h3nU8LeE8m
         u2nt0fkCIqAtRVCdz5OOvV906bffqhqu/Gt2WgXWfV/YF1Cw4XHgFAgXG7P6OQ50wpn4
         mCJDUQsV0DAciXgoCszwBxR4wYqQZa7W93Fz3/rtsgz7poBNp3gybLemciRVknAuKfr5
         FWElAjPxDjwPWTtcCtPUXN7EItLusgckApBMdMeskwocq0CzfNdtrJdxfBOvHdH8o1/F
         B68e3Ali7ComC0yvrZW19bMBa08aEIU5klTe7eIAkD1BhXekpbNcSdkbPKfq1u+ADePY
         2GTQ==
X-Gm-Message-State: AOAM533itW/BFZC7sJH7t6BOB96iwapeepQqqrMdaI1PbqDPA4NC67Pt
        fvpj3k6XIWHFrrRrqcDuZNk=
X-Google-Smtp-Source: ABdhPJzw1VKhJ6YtiLJyj67J0yZSTlZtQfHt+vO+1cr3OxFeMOB954HHMAFSoDcehWnH6I6ZeWT1iw==
X-Received: by 2002:a17:906:5e50:: with SMTP id b16mr29207175eju.272.1615888565730;
        Tue, 16 Mar 2021 02:56:05 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id a26sm10649008edm.15.2021.03.16.02.56.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 02:56:05 -0700 (PDT)
Date:   Tue, 16 Mar 2021 11:56:04 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Frank Wunderlich <frank-w@public-files.de>,
        =?utf-8?B?UmVuw6k=?= van Dorst <opensource@vdorst.com>
Subject: Re: [PATCH net-next] net: dsa: mt7530: support MDB and bridge flag
 operations
Message-ID: <20210316095604.dvg32ia5pfdtpenw@skbuf>
References: <20210315170940.2414854-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210315170940.2414854-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 16, 2021 at 01:09:40AM +0800, DENG Qingfang wrote:
> Support port MDB and bridge flag operations.
> 
> As the hardware can manage multicast forwarding itself, offload_fwd_mark
> can be unconditionally set to true.
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> ---

Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
