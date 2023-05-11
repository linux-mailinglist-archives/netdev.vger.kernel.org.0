Return-Path: <netdev+bounces-1937-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 868E06FFAD8
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 21:50:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 43E562818CC
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 19:50:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0565A946C;
	Thu, 11 May 2023 19:50:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B14206B0
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 19:50:36 +0000 (UTC)
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9F93D041;
	Thu, 11 May 2023 12:50:18 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id a640c23a62f3a-9659f452148so1616556466b.1;
        Thu, 11 May 2023 12:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683834597; x=1686426597;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=49+wF3dhiJ5ry2Q356rv8LAmJkXZ30kFszS6vJAnNZs=;
        b=g0LA4OoUg3kQOmMAzBOrSwRBOXXIKInTZnHL0lTfR77a7OyJ/NCj4+fk7crY2JRd/5
         4YSVadRTFFlwhBIRQfrIx0cxfx6CDFJ7EiPuFtKhkwVU2Xyk9qH+Pq50Z80rMCgZkHMT
         /VdV7VsTCoPJID8JrTJOPMj6XksVZJLigx9HNpdXlBKIbzQAgPymTETRQC0kwnRKxrVZ
         tttHHS1qYpUoJgIXUs7ne7JH50GlNC4qcRlfUqfV97K6m197dbKU1yYADReh01GPNlK6
         BHinkNX1wMW7X1/tpu8bGP+WdFexL0r2PQyBcDlHlLKsDM6aS+fmFpMefpDAJNCvs1+o
         E7+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683834597; x=1686426597;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=49+wF3dhiJ5ry2Q356rv8LAmJkXZ30kFszS6vJAnNZs=;
        b=bjF7HEZu4lqIxPsuv3sOUh8Dw+qz7u7rB+LycCioFTxD0vW8wcywpHcONCp3Yyql2g
         Jff7ZxSLPcGsuxQPutGtAmjoz28XIXQuKCy9FUD1kc29aEoceivFoM7APjcrsIfJL+vM
         tsIMmNLzbiQKzE5h9xfm3iPsYI0VLlPJrtQ7P5uJlWIYenSqoilmhopLtkSQ9gQssJFj
         dKR617AfqHawZ8JJ22NDBirUtXyA2zzGTWiINb7QztHkL1OBNqPIVxosJzbO04iR0npM
         sc7x5hVWSY48HJlOX2zXfT6j0+IZgWWuBUH9pHYinUODb/oQSfXvPs3wiC6GqVZhgPb+
         /2FA==
X-Gm-Message-State: AC+VfDx2KRecoUcevOm3XuTC+FyiFFwXgwcCYKESPS/uwA0nkT4XbyhP
	ds44xghP7ON5HbbQk8a90No=
X-Google-Smtp-Source: ACHHUZ5OPPbd7yz9fMwLSwXmpWJ8icV82cKE5yuc6idjNH+I+rZ24nf5enOSgo65ZAWuwzP8Nvtzug==
X-Received: by 2002:a17:906:58cd:b0:966:350f:f42d with SMTP id e13-20020a17090658cd00b00966350ff42dmr19047994ejs.23.1683834597092;
        Thu, 11 May 2023 12:49:57 -0700 (PDT)
Received: from ?IPV6:2a01:c23:c58e:b900:c905:524d:7524:40e1? (dynamic-2a01-0c23-c58e-b900-c905-524d-7524-40e1.c23.pool.telefonica.de. [2a01:c23:c58e:b900:c905:524d:7524:40e1])
        by smtp.googlemail.com with ESMTPSA id n5-20020a1709065da500b0096616adc0d5sm4432982ejv.104.2023.05.11.12.49.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 May 2023 12:49:56 -0700 (PDT)
Message-ID: <98b3b70a-86c0-78c0-b734-0764bb5a21fc@gmail.com>
Date: Thu, 11 May 2023 21:49:52 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 14/17] r8169: Use pcie_lnkctl_clear_and_set() for changing
 LNKCTL
To: =?UTF-8?Q?Ilpo_J=c3=a4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 linux-pci@vger.kernel.org, Bjorn Helgaas <helgaas@kernel.org>,
 Rob Herring <robh@kernel.org>, Lorenzo Pieralisi
 <lorenzo.pieralisi@arm.com>, =?UTF-8?Q?Krzysztof_Wilczy=c5=84ski?=
 <kw@linux.com>, Lukas Wunner <lukas@wunner.de>, nic_swsd@realtek.com,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230511131441.45704-1-ilpo.jarvinen@linux.intel.com>
 <20230511131441.45704-15-ilpo.jarvinen@linux.intel.com>
Content-Language: en-US
From: Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <20230511131441.45704-15-ilpo.jarvinen@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 11.05.2023 15:14, Ilpo Järvinen wrote:
> Don't assume that only the driver would be accessing LNKCTL. ASPM
> policy changes can trigger write to LNKCTL outside of driver's control.
> 
> Use pcie_lnkctl_clear_and_set() which does proper locking to avoid
> losing concurrent updates to the register value.
> 

Wouldn't it be more appropriate to add proper locking to the
underlying pcie_capability_clear_and_set_word()?


> Suggested-by: Lukas Wunner <lukas@wunner.de>
> Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index a7e376e7e689..c0294a833681 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -2686,14 +2686,12 @@ static void __rtl_ephy_init(struct rtl8169_private *tp,
>  
>  static void rtl_disable_clock_request(struct rtl8169_private *tp)
>  {
> -	pcie_capability_clear_word(tp->pci_dev, PCI_EXP_LNKCTL,
> -				   PCI_EXP_LNKCTL_CLKREQ_EN);
> +	pcie_lnkctl_clear_and_set(tp->pci_dev, PCI_EXP_LNKCTL_CLKREQ_EN, 0);
>  }
>  
>  static void rtl_enable_clock_request(struct rtl8169_private *tp)
>  {
> -	pcie_capability_set_word(tp->pci_dev, PCI_EXP_LNKCTL,
> -				 PCI_EXP_LNKCTL_CLKREQ_EN);
> +	pcie_lnkctl_clear_and_set(tp->pci_dev, 0, PCI_EXP_LNKCTL_CLKREQ_EN);
>  }
>  
>  static void rtl_pcie_state_l2l3_disable(struct rtl8169_private *tp)


