Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D60A12ED076
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 14:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728411AbhAGNQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 08:16:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728088AbhAGNQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 08:16:43 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F178C0612F4
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 05:16:01 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id ga15so9655714ejb.4
        for <netdev@vger.kernel.org>; Thu, 07 Jan 2021 05:16:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JfkvmCFs3W/VNw/Qfhaa4/5mzwHO0EiDklMuBt017hY=;
        b=aoW0rSnu+HOvymb4kuJkqE1rCJzHG3hlhQQa8v83ZQfLYJ0sbs7IFgppqmARsSdTuy
         SMrzcUCL58NSxF1j501lr/IaJPBbTowcAwD3jU4yLumL5hLrp8mh5CEjVn0dzoyaoeBW
         P1t0NYqn4rGyxjDHE2wcLR5v641roJRnYiPK9FDjLeyZSkamChJCwwKsrFjjfs14m66d
         luLbaCqIplCExZNt45UFZNnB/qYhQBtc7g950FwyNBOBNqitFCQmrhFxuE5fbnXaMtUW
         XMIhM+f92HKbcngfr+e7EqGvUkWG/AGcaPGk0fRb7NhfuG6iBRQxnFgVO56uu2ga6YRA
         cSjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JfkvmCFs3W/VNw/Qfhaa4/5mzwHO0EiDklMuBt017hY=;
        b=o2lTxezm9gCfpocnHokLXsVS7ytR72R2T388Kyb1jIiwZyg4lnpdw1Ra+Q09d74RxQ
         qpt2OyL1jpos7TNUo4hUE2NpWrs5otF3o+cffBFLfPCQcTFq9me6i0Rp07MAGqlOLhSq
         WFZftERmaKvI5a8fAi+gFhmY2CBdCjZgcCAhQre2gE8iX29aknw1ZZW4iH0Sw1Gmqx3m
         EiWntnnL46IauKXyxGTnx7ddqP4zxgcImn5SUJblzBrYFv/+sm7ixUrhgVRwT7qLq6ff
         uqsYsPTcNKI1tgKmHtMT13j4DhQRkxwSy4PP5VtWfzcILj0xVYh9ITvmZ3h2YmucLmRm
         v8HA==
X-Gm-Message-State: AOAM531meD3ZFLKv5wYi/7+4jviHMF8ZWS9LoUBZqz8GWggfIzyd2O3P
        vQR3wWWw5eeqzIhYgNXfbtE=
X-Google-Smtp-Source: ABdhPJzf7bBBO82ho9ejOrNPZoWrhF0eP5vbic2jLLff3ic3qePAwijCXNCCoNVWHdCU5ykMe9826Q==
X-Received: by 2002:a17:906:1199:: with SMTP id n25mr6102489eja.293.1610025360142;
        Thu, 07 Jan 2021 05:16:00 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id t26sm2464383eji.22.2021.01.07.05.15.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 05:15:59 -0800 (PST)
Date:   Thu, 7 Jan 2021 15:15:58 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     kernel test robot <lkp@intel.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, kbuild-all@lists.01.org,
        clang-built-linux@googlegroups.com, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [PATCH v3 net-next 08/12] net: make dev_get_stats return void
Message-ID: <20210107131558.lcmuhqymqvtos2d6@skbuf>
References: <20210107094951.1772183-9-olteanv@gmail.com>
 <202101072035.p3B0IIfz-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202101072035.p3B0IIfz-lkp@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 07, 2021 at 09:01:03PM +0800, kernel test robot wrote:
> Hi Vladimir,
> 
> I love your patch! Yet something to improve:

These are not scheduled to run on RFC series, are they?
This report came within 3 hours of me posting an identical version to
the RFC series from two days ago:
https://patchwork.kernel.org/project/netdevbpf/patch/20210105185902.3922928-9-olteanv@gmail.com/
