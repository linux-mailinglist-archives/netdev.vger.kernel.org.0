Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9116639CF99
	for <lists+netdev@lfdr.de>; Sun,  6 Jun 2021 16:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbhFFOlt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 10:41:49 -0400
Received: from mail-wm1-f46.google.com ([209.85.128.46]:53951 "EHLO
        mail-wm1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbhFFOlr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Jun 2021 10:41:47 -0400
Received: by mail-wm1-f46.google.com with SMTP id h3so8294370wmq.3;
        Sun, 06 Jun 2021 07:39:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=SEVMnnp5jdJsfAi2k7Qasv3hIqmGSZ59KOCLXsglWOA=;
        b=BhlhgQ9N06MFmRnop6dpWkPHolaAHbqtg/S1iH7IkTPMYWqV3cuHpOza8s5TPhWn/m
         kacj+V//eT5wfef/cBFWLqJKBeEmIcOKxJC7tRUg53dQSceeYhb9pGDgIYKHPTRjkc3J
         Ri+D49LbinizfAQo5VR8NNyrMD+pNN/kw8x0y3Hik1suuKNLojvUz7e5C3pW/ZVx3wID
         Eg/E02DR5l2fkKqlZpnz/FY30IB5tc3AHSpND3KypkLuGZ4TtJDGDSG4OPeU672Gq/Fe
         ELvi71Cz2ogQqnD591h8eD+Vcgkr/FhAo3GAfjr4LYW8kq+3cu5odsJILUQGSkWJ3mF0
         a9kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=SEVMnnp5jdJsfAi2k7Qasv3hIqmGSZ59KOCLXsglWOA=;
        b=kQqyhoqgElJ2b+2zp4r0S2YR0KErrHXsLkc1IkQuIIn7JIFm779YniG4YspP51d+FL
         cQ0uxQR/1dXh0jy+iGAFhvF6V+S6vImEW22PPBGUudUaulyL3kVkdw9fagFxxK5cTsJV
         zsZbK9Gp/hh59B5D/f+EXi6WRxtwoEIaBCbvaWmZ/0peng8PCsnjLmTCPCJGLeP2+fV7
         h6y7B6Aq8iUS7EUq9ZYYZEqUrIdvKGpeiJK5jF0pZqosSJClaT1cKyxo9wO47ti+a1qf
         qGMLdi6Gd+omFL5bDaquJfaOpV28qVonyWx7wQfm8NTpdMMuspHay7wo9Y3vxDn3vKQl
         K/ug==
X-Gm-Message-State: AOAM530q1PT1EFq6/mvG1vaqW45XoiODsxugLOt9QEKM4dsStLQwIogJ
        ZTAMzM/jRddnuZOXPDoXKvM=
X-Google-Smtp-Source: ABdhPJwO7FetrZnpByd+buizj9rapzo5bXP50YMSXUYMlLCtYO90cuwv/6b2PSRFmQvSgM7IdmwcrQ==
X-Received: by 2002:a05:600c:198c:: with SMTP id t12mr4191738wmq.16.1622990319748;
        Sun, 06 Jun 2021 07:38:39 -0700 (PDT)
Received: from localhost.localdomain (haganm.plus.com. [212.159.108.31])
        by smtp.gmail.com with ESMTPSA id a123sm15383703wmd.2.2021.06.06.07.38.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Jun 2021 07:38:39 -0700 (PDT)
Subject: Re: [PATCH 1/3] net: stmmac: explicitly deassert GMAC_AHB_RESET
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Andy Gross <agross@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>,
        Fugang Duan <fugang.duan@nxp.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
References: <20210605173546.4102455-1-mnhagan88@gmail.com>
 <YLw//XARgqNlRoTB@builder.lan>
From:   Matthew Hagan <mnhagan88@gmail.com>
Message-ID: <a322fc12-b041-5530-0b2a-5bb6a5ca050c@gmail.com>
Date:   Sun, 6 Jun 2021 15:38:37 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <YLw//XARgqNlRoTB@builder.lan>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/06/2021 04:24, Bjorn Andersson wrote:

>> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
>> index 97a1fedcc9ac..d8ae58bdbbe3 100644
>> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
>> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
>> @@ -600,6 +600,13 @@ stmmac_probe_config_dt(struct platform_device *pdev, u8 *mac)
>>  		goto error_hw_init;
>>  	}
>>  
>> +	plat->stmmac_ahb_rst = devm_reset_control_get_optional_shared(
>> +							&pdev->dev, "ahb");
>> +	if (IS_ERR(plat->stmmac_ahb_rst)) {
>> +		ret = plat->stmmac_ahb_rst;
> You need a PTR_ERR() around the plat->stmmac_ahb_rst.

This is giving a warning. Shouldn't v1 be kept as it is here? Please refer
to "net: stmmac: platform: use optional clk/reset get APIs" [1] which
modified error handling for plat->stmmac_rst. PTR_ERR() would then be
called by the parent function on the returned value of ret.

[1]: https://lore.kernel.org/netdev/20201112092606.5173aa6f@xhacker.debian/

Thanks,
Matthew

