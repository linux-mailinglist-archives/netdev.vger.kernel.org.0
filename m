Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC3A269DE7C
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 12:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233236AbjBULJQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 06:09:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233042AbjBULJK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 06:09:10 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 141BF234F2;
        Tue, 21 Feb 2023 03:09:09 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id p26so2941872wmc.4;
        Tue, 21 Feb 2023 03:09:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iThIJGodelQYw+cBMMU26iDdz39i/5SCqo2oCBZ5ynM=;
        b=Farv/5km9wLXWnKi4MPy+TnsNvwdZej7gY+uIy3+ZSG0220g1pFf4qjsXqSMNgpagb
         693ppglWV08C0tlDP9oFFdN/IjewDPieco4hCH5cSN5Yi7ZWNgAZH52WE1Yn2ik/7aGy
         kg8baLXO5G6DTwGxohEIZGcAmc+tYQHGxWOcCzWVf9TtKLv+qts0e9S3NFylgo2zpMjb
         ZXrVbgw95kd8glTIbByTV2d/w6x8VFRlh4QK8/c/wqbnrlwAR4C3+/9jyEi4IJfLXvR0
         4hq5EX4sXCtHjz7crBq8IGOoH1SoQv/8y8pmCB349KYGdQ8UL/0c/fSSijBXXLLUqgIO
         Fkkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iThIJGodelQYw+cBMMU26iDdz39i/5SCqo2oCBZ5ynM=;
        b=3kfCwAtcJXE5hAOquNxCyDAYW9QyYYXPkSdwUU0B11+3tYorFj/E9gpFVWy7VEZ1Ca
         gAs4nJ27bkZmxLHEzQIe45VZXNaDHOw/BPwuKh2sucpNvkhhEFQPgU5peJXcklr0begl
         EmfCVdQwf9Vv5E+4iKOp/d03DldYI6aRyG2tWSp9tOQ7Gq4uzP0yPEjVrWPK2dTl61nH
         77rQh177Pm1aH9ChvMJrIeIW41EWdvma1XkNsjH8Nh2/XVncG+w3QEqDeZJjOQBiNw1F
         kdRAC6FiwyLRk3mZ2qNYDDsjA3+8sr/Ob92YLieiwEg70KfDltD5kSwNXS2XILnGnieg
         1cHg==
X-Gm-Message-State: AO0yUKULqMEVN1NdKvI3i7DbqrATcj69771/QpWbuNE780t4Nx1pZ4me
        Dk465+9gIur60UDxnvISvQU=
X-Google-Smtp-Source: AK7set+YeeGH9/Ccy4GOTtLCCd2PrCtSR0scMmbrtOZp78/SlpZN+1pX/O6x60gSGs/reDF/jRyKEg==
X-Received: by 2002:a05:600c:a296:b0:3dc:5b79:2dbb with SMTP id hu22-20020a05600ca29600b003dc5b792dbbmr3405391wmb.25.1676977747327;
        Tue, 21 Feb 2023 03:09:07 -0800 (PST)
Received: from ?IPV6:2a01:c22:6e4d:5f00:c8b7:365d:f8a9:9c38? (dynamic-2a01-0c22-6e4d-5f00-c8b7-365d-f8a9-9c38.c22.pool.telefonica.de. [2a01:c22:6e4d:5f00:c8b7:365d:f8a9:9c38])
        by smtp.googlemail.com with ESMTPSA id l37-20020a05600c1d2500b003db0ad636d1sm15900976wms.28.2023.02.21.03.09.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Feb 2023 03:09:06 -0800 (PST)
Message-ID: <b2bae4bb-0dbe-be80-3849-f46395c05cd2@gmail.com>
Date:   Tue, 21 Feb 2023 12:08:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v8 RESEND 6/6] r8169: Disable ASPM while doing NAPI poll
Content-Language: en-US
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>, nic_swsd@realtek.com,
        bhelgaas@google.com
Cc:     koba.ko@canonical.com, acelan.kao@canonical.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, sathyanarayanan.kuppuswamy@linux.intel.com,
        vidyas@nvidia.com, rafael.j.wysocki@intel.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
References: <20230221023849.1906728-1-kai.heng.feng@canonical.com>
 <20230221023849.1906728-7-kai.heng.feng@canonical.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <20230221023849.1906728-7-kai.heng.feng@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21.02.2023 03:38, Kai-Heng Feng wrote:
> NAPI poll of Realtek NICs don't seem to perform well ASPM is enabled.
> The vendor driver uses a mechanism called "dynamic ASPM" to toggle ASPM
> based on the packet number in given time period.
> 
> Instead of implementing "dynamic ASPM", use a more straightforward way
> by disabling ASPM during NAPI poll, as a similar approach was
> implemented to solve slow performance on Realtek wireless NIC, see
> commit 24f5e38a13b5 ("rtw88: Disable PCIe ASPM while doing NAPI poll on
> 8821CE").
> 
> Since NAPI poll should be handled as fast as possible, also remove the
> delay in rtl_hw_aspm_clkreq_enable() which was added by commit
> 94235460f9ea ("r8169: Align ASPM/CLKREQ setting function with vendor
> driver").
> 
> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
> ---
> v8:
>  - New patch.
> 
>  drivers/net/ethernet/realtek/r8169_main.c | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index 897f90b48bba6..4d4a802346ae3 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -2711,8 +2711,6 @@ static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
>  		RTL_W8(tp, Config2, RTL_R8(tp, Config2) & ~ClkReqEn);
>  		RTL_W8(tp, Config5, RTL_R8(tp, Config5) & ~ASPM_en);
>  	}
> -
> -	udelay(10);
>  }
>  
>  static void rtl_set_fifo_size(struct rtl8169_private *tp, u16 rx_stat,
> @@ -4577,6 +4575,12 @@ static int rtl8169_poll(struct napi_struct *napi, int budget)
>  	struct net_device *dev = tp->dev;
>  	int work_done;
>  
> +	if (tp->aspm_manageable) {
> +		rtl_unlock_config_regs(tp);

NAPI poll runs in softirq context (except for threaded NAPI).
Therefore you should use a spinlock instead of a mutex.

> +		rtl_hw_aspm_clkreq_enable(tp, false);
> +		rtl_lock_config_regs(tp);
> +	}
> +
>  	rtl_tx(dev, tp, budget);
>  
>  	work_done = rtl_rx(dev, tp, budget);
> @@ -4584,6 +4588,12 @@ static int rtl8169_poll(struct napi_struct *napi, int budget)
>  	if (work_done < budget && napi_complete_done(napi, work_done))
>  		rtl_irq_enable(tp);
>  
> +	if (tp->aspm_manageable) {
> +		rtl_unlock_config_regs(tp);
> +		rtl_hw_aspm_clkreq_enable(tp, true);
> +		rtl_lock_config_regs(tp);

Why not moving lock/unlock into rtl_hw_aspm_clkreq_enable()?

> +	}
> +
>  	return work_done;
>  }
>  

