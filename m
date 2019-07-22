Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0526FDA0
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 12:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729587AbfGVKSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 06:18:37 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:39645 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729238AbfGVKSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 06:18:36 -0400
Received: by mail-wm1-f68.google.com with SMTP id u25so24372361wmc.4
        for <netdev@vger.kernel.org>; Mon, 22 Jul 2019 03:18:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+GcrJc5mWQ55cEUCcfbBZGMvLQ78HJvPwtodMDzyle8=;
        b=G/KTQPys8CcucScPfqsgmQtz62QdZqLEo1kJwQNA+4eLiF2asiNiddgtT/h14Ix94U
         /CdTawyAL79G+1ILA0FvrmO8i2FryDf4LH9+Yj6o4XGqgEMRSjeMmCPzYQxKNpoZorLo
         z+SV+ac1Cei6AWdxZ6IceFB28kHbysTzIUNOHaUoxyQYbqkiAlOpN1troV3WXeI636me
         pZqpRxgTA+gDotUsJGcbBrxF3vsWRMbB6fLgmFb0seU6n83Fjiw5lyPCsGhKFl5VBVtA
         j6RauOuX7Z0lH14cBe9PTdWl14HxQfSyO24r5I9K866EX/AQa4BQydrhG1rhbyb9i/j+
         VvTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+GcrJc5mWQ55cEUCcfbBZGMvLQ78HJvPwtodMDzyle8=;
        b=CZLn2ikzBARA11NKEt9qQhrMmwcg1ofw92HOlL5jvZfYn/B2tw4td4fkpo31Hr7Ul+
         cTtvTniuaESx97w7+EHuXcNdS3LemK+VGYyk8PeMgILL88EpfCOSrfUZ8xt419ZaALTS
         tWkPa1VU670tanhCI+oJr8hvtVyRTdO2bwkAdtk0+sbsMYUU5tHiqJ6ESAHvBDxlXEpS
         ytf4P5vJyjTPbb/11ER3uqauO4vbKE3WuVKRBTQx+P6ZnSn8w4y7a8dCxQf06eNfivr1
         PZ7jYUgnjuiJLW/tteC8BZ2HkJJOQnfsyRdV3JrVMgPUMivc6cDob1+96st9rZ30PcS9
         t/Mg==
X-Gm-Message-State: APjAAAUwiS2F/jkw+0PYYWVyr3oyNXs8GnCPyH3opu/CRVxxSqDhYNmv
        5MyWlUGuQH9Cg4Ke7zL4eZpSdw==
X-Google-Smtp-Source: APXvYqwWpeo4gQ4edBUy9N5k3STiDsB6fnGJqOqO58p5YopawrIHfEaaX/V07cjOuiVOf8ftj5mijg==
X-Received: by 2002:a7b:cc97:: with SMTP id p23mr64661606wma.120.1563790714647;
        Mon, 22 Jul 2019 03:18:34 -0700 (PDT)
Received: from apalos (athedsl-373703.home.otenet.gr. [79.131.11.197])
        by smtp.gmail.com with ESMTPSA id f17sm34005987wmf.27.2019.07.22.03.18.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Jul 2019 03:18:33 -0700 (PDT)
Date:   Mon, 22 Jul 2019 13:18:30 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     Jon Hunter <jonathanh@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        Chen-Yu Tsai <wens@csie.org>,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH net-next 3/3] net: stmmac: Introducing support for Page
 Pool
Message-ID: <20190722101830.GA24948@apalos>
References: <cover.1562149883.git.joabreu@synopsys.com>
 <1b254bb7fc6044c5e6e2fdd9e00088d1d13a808b.1562149883.git.joabreu@synopsys.com>
 <29dcc161-f7c8-026e-c3cc-5adb04df128c@nvidia.com>
 <BN8PR12MB32661E919A8DEBC7095BAA12D3C80@BN8PR12MB3266.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN8PR12MB32661E919A8DEBC7095BAA12D3C80@BN8PR12MB3266.namprd12.prod.outlook.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 18, 2019 at 07:48:04AM +0000, Jose Abreu wrote:
> From: Jon Hunter <jonathanh@nvidia.com>
> Date: Jul/17/2019, 19:58:53 (UTC+00:00)
> 
> > Let me know if you have any thoughts.
> 
> Can you try attached patch ?
> 

The log says  someone calls panic() right?
Can we trye and figure were that happens during the stmmac init phase?

Thanks
/Ilias

