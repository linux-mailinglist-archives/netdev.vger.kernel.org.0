Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F73F5F4A31
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 22:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbiJDUOt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 16:14:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiJDUOr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 16:14:47 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F12B47650
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 13:14:45 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id bq9so23009306wrb.4
        for <netdev@vger.kernel.org>; Tue, 04 Oct 2022 13:14:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date;
        bh=ZMO+zGCi9axNqydmWFrTDYSvOlD2XnFNkyd0Zjhp8CM=;
        b=Wlc3TizQun7piqNHEVpu/vLSA8SxeRko1z0v1m3HBnZuStQN5e2mIbBYp5pTsfGY8H
         LXm7SgpS+DsAqv9+qQqQIEEDQZ3au26E3YawU2DPjX/1YqWtp2t7ssJTXoq5cQ7mZFAl
         MqVr0sTOUsDtJbDVBwlkJznpaQe1NpLO8VfYXjeLiEnUPWUTfkrvuyLDqcn8dDAhbVnV
         KZS1QscvEGONfDupolPGz1KCiACLbqj4ir/kUFr8mbICi7pmQxFmvdycO/LL8wFZhz/V
         IxvAfaRrYqRxyDBGqz7pBQsr7uYBiXfxBgwGCkDqipqn0iHQLa7eJKMjyA9cOCnxdFMp
         ryuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=ZMO+zGCi9axNqydmWFrTDYSvOlD2XnFNkyd0Zjhp8CM=;
        b=HoECsgWjjXANygvssOjSQGwkpULrqrnD/ZSSflwQydVHcg9jxdPFnhI4IYhodgkCMh
         DlwDHbpKtIBLok1xgMcB+akeRyxupUCyK+re0VugqHtLnOWmKFVWKKBPWIWEldiKp0CH
         ANQ9eJQU02y07l8l8NNbtMca4RRvfRvL5iQBGg1Vx13yLF+mBHvfVYDgXbZU+oOaESx5
         1TcLpFSIWMmUUt0NGFecmZHLFa7ggfxRwM89p431xwZbfgY71o1xgkclckd3IO9r4Ll2
         1W4qOONH/xMRBOgXEr4Yl4mTJg+nLstmKRGJ5J/VCl9GkIXBB6fR5USEk/IlaK9LGb3F
         S9yA==
X-Gm-Message-State: ACrzQf2LEE1pmWhug9kq3PJhJcmh3yvwajgMiIehExik29sbaY2jgMW9
        d91KEUAmdtmhk++RtW6cpUY=
X-Google-Smtp-Source: AMsMyM4V5prNZfl4vE3b2pjMmBgaY2+tS6t3+qalGwX6J2coIsi1ZkI/bVXXL6xaRdNjyuZolwgwBQ==
X-Received: by 2002:a5d:52c9:0:b0:22c:c9e0:8547 with SMTP id r9-20020a5d52c9000000b0022cc9e08547mr17016046wrv.3.1664914484254;
        Tue, 04 Oct 2022 13:14:44 -0700 (PDT)
Received: from ?IPV6:2a02:3100:95f8:ae00:d8e8:9bb5:5c3c:3b47? (dynamic-2a02-3100-95f8-ae00-d8e8-9bb5-5c3c-3b47.310.pool.telefonica.de. [2a02:3100:95f8:ae00:d8e8:9bb5:5c3c:3b47])
        by smtp.googlemail.com with ESMTPSA id c10-20020a7bc00a000000b003b49bd61b19sm20078087wmb.15.2022.10.04.13.14.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Oct 2022 13:14:43 -0700 (PDT)
Message-ID: <840eab89-375a-bb28-9937-aeaa17922048@gmail.com>
Date:   Tue, 4 Oct 2022 22:14:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Chunhao Lin <hau@realtek.com>
Cc:     netdev@vger.kernel.org, nic_swsd@realtek.com, kuba@kernel.org,
        grundler@chromium.org
References: <20221004081037.34064-1-hau@realtek.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net] r8169: fix rtl8125b dmar pte write access not set
 error
In-Reply-To: <20221004081037.34064-1-hau@realtek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04.10.2022 10:10, Chunhao Lin wrote:
> When close device, rx will be enabled if wol is enabeld. When open device
> it will cause rx to dma to wrong address after pci_set_master().
> 
Hi Hau,

I never experienced this problem. Is it an edge case that can occur under
specific circumstances?

> In this patch, driver will disable tx/rx when close device. If wol is
> eanbled only enable rx filter and disable rxdv_gate to let hardware
> can receive packet to fifo but not to dma it.
> 
> Fixes: 120068481405 ("r8169: fix failing WoL")
> Signed-off-by: Chunhao Lin <hau@realtek.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index 1b7fdb4f056b..c09cfbe1d3f0 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -2239,6 +2239,9 @@ static void rtl_wol_enable_rx(struct rtl8169_private *tp)
>  	if (tp->mac_version >= RTL_GIGA_MAC_VER_25)
>  		RTL_W32(tp, RxConfig, RTL_R32(tp, RxConfig) |
>  			AcceptBroadcast | AcceptMulticast | AcceptMyPhys);
> +
> +	if (tp->mac_version >= RTL_GIGA_MAC_VER_40)
> +		RTL_W32(tp, MISC, RTL_R32(tp, MISC) & ~RXDV_GATED_EN);

In the commit title you reference RTL8125b only, but the actual change
affects all chip versions from RTL8168g. So either title or patch need to be
adjusted. Is the actual issue restricted to RTL8125b (hw issue?) or can it
occur on all chip versions that use RXDV_GATED_EN?

>  }
>  
>  static void rtl_prepare_power_down(struct rtl8169_private *tp)
> @@ -3981,7 +3984,7 @@ static void rtl8169_tx_clear(struct rtl8169_private *tp)
>  	netdev_reset_queue(tp->dev);
>  }
>  
> -static void rtl8169_cleanup(struct rtl8169_private *tp, bool going_down)
> +static void rtl8169_cleanup(struct rtl8169_private *tp)
>  {
>  	napi_disable(&tp->napi);
>  
> @@ -3993,9 +3996,6 @@ static void rtl8169_cleanup(struct rtl8169_private *tp, bool going_down)
>  
>  	rtl_rx_close(tp);
>  
> -	if (going_down && tp->dev->wol_enabled)
> -		goto no_reset;
> -

Here you change the behavior for various other chip versions too. This should not be done
in a fix, even if it should be safe.

>  	switch (tp->mac_version) {
>  	case RTL_GIGA_MAC_VER_28:
>  	case RTL_GIGA_MAC_VER_31:
> @@ -4016,7 +4016,7 @@ static void rtl8169_cleanup(struct rtl8169_private *tp, bool going_down)
>  	}
>  
>  	rtl_hw_reset(tp);
> -no_reset:
> +
>  	rtl8169_tx_clear(tp);
>  	rtl8169_init_ring_indexes(tp);
>  }
> @@ -4027,7 +4027,7 @@ static void rtl_reset_work(struct rtl8169_private *tp)
>  
>  	netif_stop_queue(tp->dev);
>  
> -	rtl8169_cleanup(tp, false);
> +	rtl8169_cleanup(tp);
>  
>  	for (i = 0; i < NUM_RX_DESC; i++)
>  		rtl8169_mark_to_asic(tp->RxDescArray + i);
> @@ -4715,7 +4715,7 @@ static void rtl8169_down(struct rtl8169_private *tp)
>  	pci_clear_master(tp->pci_dev);
>  	rtl_pci_commit(tp);
>  
> -	rtl8169_cleanup(tp, true);
> +	rtl8169_cleanup(tp);
>  	rtl_disable_exit_l1(tp);
>  	rtl_prepare_power_down(tp);
>  }

