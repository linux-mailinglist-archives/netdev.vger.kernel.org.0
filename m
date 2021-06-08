Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 902F23A0237
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 21:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235557AbhFHTCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 15:02:06 -0400
Received: from mail-wm1-f47.google.com ([209.85.128.47]:54024 "EHLO
        mail-wm1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237144AbhFHS75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Jun 2021 14:59:57 -0400
Received: by mail-wm1-f47.google.com with SMTP id h3so2498383wmq.3;
        Tue, 08 Jun 2021 11:58:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=zR+JC/2SzttVA6Wi+7iVGlwak4IerMBJeQ5vLiMBGTE=;
        b=aCAfFsjvN26ao1o5VbYA1hb4S5BPr3VSPmBYi+tPbj+6rNMp+HtfA3naWv3DEkYR8u
         gcoTAeKJl3oWKupFwMct7p1SNfqDPlIHjPdaMbsgh4cBZ9qQozuUoGWeBnhbiyA6+lm9
         2IboWynabOYoqfxcioZtSNb/o6WuSDo2pRGgfpGXBiQBgZlb/2WINKFNdFFQrhfIvyvN
         SVmX8d/BtmV2n30TpS1q9Ak27Lu9/KTYFz9+HDw1wYADWLUkkIvHQ8UTpe2eM0uS+ABP
         AicSK+tPE0hIc5tyaE6g8uBV0vwT5dj3ML0LRh27ZHXjW6StvDCa2Tqi1Ngl2w8jkiqd
         8pSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=zR+JC/2SzttVA6Wi+7iVGlwak4IerMBJeQ5vLiMBGTE=;
        b=fyNrNjV4VzV6cRvF2tFbznGTwDC1BE/98rgVuKCHHz0QteC8bZvyKd6WeZ4mhxEMlJ
         Cd9aqJMCV9S2VXSSEOXGDcntAFOR5OxkkTG37Jmtvg/R3bCwJ0AdLCVo58lMLBb/u92x
         XYNZi3x991VZ847BJhPAts2dpYM4xQwXPMpqk7iKF9eCRBKOfuPyZvDitHBniIYmRLoV
         2PSKLa58f4mDl3zI/vgkLy/feFj/zE2sHTJZHhDSWGQr6HnfsBE558p6P9d2Ivd5SXCn
         2JPwKI6aFI0pBaffrLM0QLk7T8ftPDDlQwPWS5YiFXa2JJPyONzr1xU+mQ9JGFeSGOpf
         +7yQ==
X-Gm-Message-State: AOAM531cl7x+0yNgNFanKGtqTA5qnNkZTG5fftbAAoYbzaG1wF1Z3cyp
        /BC995GxT8GEfKUtuRcjZqZDtJLuj09g9g==
X-Google-Smtp-Source: ABdhPJw4vJl+POy6CcWej23a3H9QQOC6ZezJQemdBY1dxn4yCgZHjAn5j8tYrqgir5u1r4h6c0FEAw==
X-Received: by 2002:a05:600c:8a6:: with SMTP id l38mr23602133wmp.108.1623178623426;
        Tue, 08 Jun 2021 11:57:03 -0700 (PDT)
Received: from localhost.localdomain (haganm.plus.com. [212.159.108.31])
        by smtp.gmail.com with ESMTPSA id q20sm26200223wrf.45.2021.06.08.11.57.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jun 2021 11:57:02 -0700 (PDT)
Subject: Re: [PATCH v2] net: stmmac: explicitly deassert GMAC_AHB_RESET
To:     Philipp Zabel <p.zabel@pengutronix.de>
Cc:     bjorn.andersson@linaro.org,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Wong Vee Khee <vee.khee.wong@linux.intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        "Wong, Vee Khee" <vee.khee.wong@intel.com>,
        Mohammad Athari Bin Ismail <mohammad.athari.ismail@intel.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <3436f8f0-77dc-d4ff-4489-e9294c434a08@gmail.com>
 <20210606103019.2807397-1-mnhagan88@gmail.com>
 <b89d828a08528aaa07e3527d254785f1e40b9bee.camel@pengutronix.de>
From:   Matthew Hagan <mnhagan88@gmail.com>
Message-ID: <c223051b-c11c-3c08-055b-544f9e31cf00@gmail.com>
Date:   Tue, 8 Jun 2021 19:57:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <b89d828a08528aaa07e3527d254785f1e40b9bee.camel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/06/2021 10:45, Philipp Zabel wrote:

> On Sun, 2021-06-06 at 11:30 +0100, Matthew Hagan wrote:
>> We are currently assuming that GMAC_AHB_RESET will already be deasserted
>> by the bootloader. However if this has not been done, probing of the GMAC
>> will fail. To remedy this we must ensure GMAC_AHB_RESET has been deasserted
>> prior to probing.
>>
>> v2 changes:
>>  - remove NULL condition check for stmmac_ahb_rst in stmmac_main.c
>>  - unwrap dev_err() message in stmmac_main.c
>>  - add PTR_ERR() around plat->stmmac_ahb_rst in stmmac_platform.c
>>
>> Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>
>> ---
>>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c     | 4 ++++
>>  drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c | 7 +++++++
>>  include/linux/stmmac.h                                | 1 +
>>  3 files changed, 12 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> index 6d41dd6f9f7a..0d4cb423cbbd 100644
>> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> @@ -6840,6 +6840,10 @@ int stmmac_dvr_probe(struct device *device,
>>  			reset_control_reset(priv->plat->stmmac_rst);
>>  	}
>>  
>> +	ret = reset_control_deassert(priv->plat->stmmac_ahb_rst);
>> +	if (ret == -ENOTSUPP)
>> +		dev_err(priv->device, "unable to bring out of ahb reset\n");
>> +
> I would make this
>
> 	if (ret)
> 		dev_err(priv->device, "unable to bring out of ahb reset: %pe\n", ERR_PTR(ret));

Done.

>
> Also consider asserting the reset again in the remove path. Or is there
> a reason not to?

Don't see any issue doing this. As this is a shared reset, the assert will only occur
when the final GMAC is removed, due to the tracking of deassert_count.

> With that addressed,
>
> Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
>
> regards
> Philipp

Thanks,

Matthew

