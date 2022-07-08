Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00C5556B8AB
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 13:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238028AbiGHLiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 07:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237510AbiGHLiL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 07:38:11 -0400
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDBD0951CF;
        Fri,  8 Jul 2022 04:38:10 -0700 (PDT)
Received: by mail-il1-x12b.google.com with SMTP id n9so8530785ilq.12;
        Fri, 08 Jul 2022 04:38:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=nszoEzYnCxQ1xDNDNvtGrYIcNHRX5TSbVWsgNtzZYhA=;
        b=dKvjhinarA+FocDEae0v2+po7LXoRwU4pY01+kUagQ5SQYb3XXmu3zkzCPOoiQIK6I
         /JOuB/inq9ACoE5FjhLsVyJmuqdG97nxZOul+6cAackx1m82N44sCs/mULzrGat08yv9
         wUXyLH/M2uKfNvDXyes0tu22w4WK797yLHWyVeef0hjRaXeoO2XouqmmKWifJeY19mWR
         LY+h4c85KmZMyQqb3OG1G12IMWa/xrrdfVs4hiyoiFnvwbRxLsbnSpLzTCCrPAXAkFtP
         Zvt2kscGtFJCPLT/DEpLBLt3EQGmiLWOj8c5ITdnyHDMSS+AfdulxIthKL+LXDYS41rB
         ldrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=nszoEzYnCxQ1xDNDNvtGrYIcNHRX5TSbVWsgNtzZYhA=;
        b=G/Ha6+gjAiiFFOwitQyA8+IW9NBHad03OkFpKFnT4CZ30FVS8iocn9zDg6bpjKt7N/
         8XgzcnTV5PxRGApVEYa2PDwXbf4DTtQH9am2NxnFd6wE520y/7XyyyKiszlBjcP1cNrs
         PHO6/Xen4pDCHXD4RLK0vKScdY9k6r4pVKIeHb8KKt3FdMDWA+rne2Tg3ODG5TzmEen4
         TZWhYrMeg9vAFe7iEoBkNjYfTxHEci01512HhLYYeIilzc+5KgdlttyY1txlhalqFMbK
         7x5ogYP5h+5P7aQkkd1lAUJVe12XcEagXYCd1OoSiMZhIXtr3INWhmjzkGIpfLnF0pei
         jovQ==
X-Gm-Message-State: AJIora/wntgZVp1c8zoDsrSCGOv1wI2gdO47cAIWGbNF7oiLFuC9aNQI
        iTssufQ6b3ljfHkOcVEicLQ=
X-Google-Smtp-Source: AGRyM1sNiPet/tVOy6XFSa61R0msl5dFrsxCFuQMc8hx1cl0M2wFvwdfDVlZDWJVEB+BtAPuu3xZXg==
X-Received: by 2002:a05:6e02:1a2f:b0:2dc:31f1:2976 with SMTP id g15-20020a056e021a2f00b002dc31f12976mr1810014ile.179.1657280290036;
        Fri, 08 Jul 2022 04:38:10 -0700 (PDT)
Received: from [192.168.1.145] ([207.188.167.132])
        by smtp.gmail.com with ESMTPSA id k14-20020a0566022a4e00b0067821726c8csm9007770iov.53.2022.07.08.04.38.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jul 2022 04:38:08 -0700 (PDT)
Message-ID: <78beb398-01ed-400e-e79c-0bcdcbc279d0@gmail.com>
Date:   Fri, 8 Jul 2022 13:37:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Biao Huang <biao.huang@mediatek.com>,
        David Miller <davem@davemloft.net>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org, macpaul.lin@mediatek.com
References: <20220708083937.27334-1-biao.huang@mediatek.com>
 <20220708083937.27334-2-biao.huang@mediatek.com>
 <14bf5e6b-4230-fffc-4134-c3015cf4d262@gmail.com>
 <410b8c62ea399b51c11021c4838bd6a62d542703.camel@mediatek.com>
From:   Matthias Brugger <matthias.bgg@gmail.com>
Subject: Re: [PATCH net v3] stmmac: dwmac-mediatek: fix clock issue
In-Reply-To: <410b8c62ea399b51c11021c4838bd6a62d542703.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Biao Huang,

On 08/07/2022 11:46, Biao Huang wrote:
> Dear Mattias,
> 	Thanks for your comments.
> 
> On Fri, 2022-07-08 at 11:22 +0200, Matthias Brugger wrote:
>>
>> On 08/07/2022 10:39, Biao Huang wrote:
>>> Since clocks are handled in mediatek_dwmac_clks_config(),
>>> remove the clocks configuration in init()/exit(), and
>>> invoke mediatek_dwmac_clks_config instead.
>>>
>>> This issue is found in suspend/resume test.
>>>
>>
>> Commit message is rather confusing. Basically you are moving the
>> clock enable
>> into probe instead of init and remove it from exit. That means,
>> clocks get
>> enabled earlier and don't get disabled if the module gets unloaded.
>> That doesn't
>> sound correct, I think we would at least need to disable the clocks
>> in remove
>> function.
> there is pm_runtime support in driver, and clocks will be
> disabled/enabled in stmmac_runtime_suspend/stmmac_runtime_resume.
> 
> stmmac_dvr_probe() invoke pm_runtime_put(device) at the end, and
> disable clocks, but no clock enable at the beginning.
> so vendor's probe entry should enable clocks to ensure normal behavior.
> 
> As to clocks in remove function, we did not test it
> We should implement a vendor specified remove function who will take
> care of clocks rather than invoke stmmac_pltfr_remove directly.
> 
> Anyway, we miss the clock handling case in remove function,
> and will
> test it and feed back.

Right, sorry I'm not familiar with the stmmac driver stack, yes suspend/resume 
is fine. Thanks for clarification.

stmmac_pltfr_remove will disable stmmac_clk and pclk but not the rest of the 
clocks. So I think you will need to have specific remove function to disable them.

>>
>> I suppose that suspend calls exit and that there was a problem when
>> we disable
>> the clocks there. Is this a HW issue that has no other possible fix?
> Not a HW issue. suspend/resume will disable/enable clocks by invoking
> stmmac_pltfr_noirq_suspend/stmmac_pltfr_noirq_resume -->
> pm_runtime_force_suspend/pm_runtime_force_resume-->
> mediatek_dwmac_clks_config, so old clock handling in init/exit is no
> longer a proper choice.
> 

Got it, thanks for clarification.

Best regards,
Matthias

> Best Regards!
> Biao
> 
>>
>> Regards,
>> Matthias
>>
>>> Fixes: 3186bdad97d5 ("stmmac: dwmac-mediatek: add platform level
>>> clocks management")
>>> Signed-off-by: Biao Huang <biao.huang@mediatek.com>
>>> ---
>>>    .../ethernet/stmicro/stmmac/dwmac-mediatek.c  | 36 +++++---------
>>> -----
>>>    1 file changed, 9 insertions(+), 27 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
>>> b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
>>> index 6ff88df58767..e86f3e125cb4 100644
>>> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
>>> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-mediatek.c
>>> @@ -576,32 +576,7 @@ static int mediatek_dwmac_init(struct
>>> platform_device *pdev, void *priv)
>>>    		}
>>>    	}
>>>    
>>> -	ret = clk_bulk_prepare_enable(variant->num_clks, plat->clks);
>>> -	if (ret) {
>>> -		dev_err(plat->dev, "failed to enable clks, err = %d\n",
>>> ret);
>>> -		return ret;
>>> -	}
>>> -
>>> -	ret = clk_prepare_enable(plat->rmii_internal_clk);
>>> -	if (ret) {
>>> -		dev_err(plat->dev, "failed to enable rmii internal clk,
>>> err = %d\n", ret);
>>> -		goto err_clk;
>>> -	}
>>> -
>>>    	return 0;
>>> -
>>> -err_clk:
>>> -	clk_bulk_disable_unprepare(variant->num_clks, plat->clks);
>>> -	return ret;
>>> -}
>>> -
>>> -static void mediatek_dwmac_exit(struct platform_device *pdev, void
>>> *priv)
>>> -{
>>> -	struct mediatek_dwmac_plat_data *plat = priv;
>>> -	const struct mediatek_dwmac_variant *variant = plat->variant;
>>> -
>>> -	clk_disable_unprepare(plat->rmii_internal_clk);
>>> -	clk_bulk_disable_unprepare(variant->num_clks, plat->clks);
>>>    }
>>>    
>>>    static int mediatek_dwmac_clks_config(void *priv, bool enabled)
>>> @@ -643,7 +618,6 @@ static int mediatek_dwmac_common_data(struct
>>> platform_device *pdev,
>>>    	plat->addr64 = priv_plat->variant->dma_bit_mask;
>>>    	plat->bsp_priv = priv_plat;
>>>    	plat->init = mediatek_dwmac_init;
>>> -	plat->exit = mediatek_dwmac_exit;
>>>    	plat->clks_config = mediatek_dwmac_clks_config;
>>>    	if (priv_plat->variant->dwmac_fix_mac_speed)
>>>    		plat->fix_mac_speed = priv_plat->variant-
>>>> dwmac_fix_mac_speed;
>>> @@ -712,13 +686,21 @@ static int mediatek_dwmac_probe(struct
>>> platform_device *pdev)
>>>    	mediatek_dwmac_common_data(pdev, plat_dat, priv_plat);
>>>    	mediatek_dwmac_init(pdev, priv_plat);
>>>    
>>> +	ret = mediatek_dwmac_clks_config(priv_plat, true);
>>> +	if (ret)
>>> +		return ret;
>>> +
>>>    	ret = stmmac_dvr_probe(&pdev->dev, plat_dat, &stmmac_res);
>>>    	if (ret) {
>>>    		stmmac_remove_config_dt(pdev, plat_dat);
>>> -		return ret;
>>> +		goto err_drv_probe;
>>>    	}
>>>    
>>>    	return 0;
>>> +
>>> +err_drv_probe:
>>> +	mediatek_dwmac_clks_config(priv_plat, false);
>>> +	return ret;
>>>    }
>>>    
>>>    static const struct of_device_id mediatek_dwmac_match[] = {
> 
