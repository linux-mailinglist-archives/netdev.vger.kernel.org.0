Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E34EA2F1C61
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 18:31:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389562AbhAKRbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 12:31:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732337AbhAKRbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 12:31:07 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A245CC061786
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 09:30:27 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id x12so183696plr.10
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 09:30:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9i6u0oT/bTGBg4/16ZgZkk+ZrjrLLZ7ZoZSczpo4MHs=;
        b=T2fLWZDtwAOf7TCIbaon+EkhBY06/+RyCp0wVSa9oT8i0d4XlouZ+ve6DIbO2gbQcK
         CRm43r0i3dPC8+ZfAkdu4Xtfcrdry/0WrNgDA51lqwp7v3YeSK6Vb75Mwlnjfoy0c0cj
         8oybRj+3+S4Ny9jHAUnYarSK5hFW87ZiQZ+0Q+XlRW0SIlT/Mc2yeYXKPGdChjHtKXEK
         wRf77jtY4pTBk6lkzXcfpWJSK2ospWXf0DVHiE0W1nj3E/G6P/92MQ5rNmA8IIPDEk+f
         ooEqAXo8J+uiKDdmn+BOLya5IAABa995uM4RWTFgVdr0E1wzvQ83l7CifI0NpLAmuJZe
         5rCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=9i6u0oT/bTGBg4/16ZgZkk+ZrjrLLZ7ZoZSczpo4MHs=;
        b=b79OhzL73W4lnnHXXDTpPln+CgNMOQD3rTWDEiKv30I535p/8Kr541I9YfGjLqYKYx
         oeLM6VvBsSI7jyAG217Pg8kDkQJMe9dB/Vtdckkh6fLtDoVHPc8E1qQrWrdDj1pLnRZK
         NVcaSU1qQeYSwn8O0m9MTC9y4h7w/DltbAhsjMNA4tC0P3FEpZDzb1A1V0+Of3VXth8u
         XtAuubp7Hc8ZPXoeSl8vtQPIeKPYerT+Xl1deRNsU7LeCjRYnrsT44wW249hFu4SrLTg
         mK1XVFAvvpV5G/Q1xxyXqJ1SQuRrW6wvqE4JB1LUiCggupqpWE6FWIv8CkEudUHdQqnB
         oyBw==
X-Gm-Message-State: AOAM530i9ddyXzApYDgMwspqcI7r9cksU6fuKLC82BA7XseqkIeKUFic
        yAQBtNfJNs51cFYHrZMYoxo=
X-Google-Smtp-Source: ABdhPJyhw5q1Ofm5xnQGMJJFl8tMgsH84a/l7vkG7zCeiBxRrmP/wn0GiaOxK9Z+QQ/mzQbAQynreg==
X-Received: by 2002:a17:90a:fe8e:: with SMTP id co14mr300331pjb.105.1610386227121;
        Mon, 11 Jan 2021 09:30:27 -0800 (PST)
Received: from [10.67.48.230] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id a19sm202237pfi.130.2021.01.11.09.30.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jan 2021 09:30:26 -0800 (PST)
Subject: Re: [PATCH 4/6] ethernet: stmmac: fix dma physical address of
 descriptor when display ring
To:     Joakim Zhang <qiangqing.zhang@nxp.com>, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-imx@nxp.com
References: <20210111113538.12077-1-qiangqing.zhang@nxp.com>
 <20210111113538.12077-5-qiangqing.zhang@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <e2ff7caa-6af8-49b9-cbf0-82b1e97a15c9@gmail.com>
Date:   Mon, 11 Jan 2021 09:30:23 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210111113538.12077-5-qiangqing.zhang@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/11/21 3:35 AM, Joakim Zhang wrote:
> Driver uses dma_alloc_coherent to allocate dma memory for descriptors,
> dma_alloc_coherent will return both the virtual address and physical
> address. AFAIK, virt_to_phys could not convert virtual address to
> physical address, for which memory is allocated by dma_alloc_coherent.
> 
> Signed-off-by: Joakim Zhang <qiangqing.zhang@nxp.com>
> ---
>  .../ethernet/stmicro/stmmac/dwmac4_descs.c    |  5 +-
>  .../net/ethernet/stmicro/stmmac/enh_desc.c    |  5 +-
>  drivers/net/ethernet/stmicro/stmmac/hwif.h    |  3 +-
>  .../net/ethernet/stmicro/stmmac/norm_desc.c   |  5 +-
>  .../net/ethernet/stmicro/stmmac/stmmac_main.c | 50 ++++++++++++-------
>  5 files changed, 44 insertions(+), 24 deletions(-)
> 
> diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
> index c6540b003b43..8e1ee33ba1e6 100644
> --- a/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
> +++ b/drivers/net/ethernet/stmicro/stmmac/dwmac4_descs.c
> @@ -402,7 +402,8 @@ static void dwmac4_rd_set_tx_ic(struct dma_desc *p)
>  	p->des2 |= cpu_to_le32(TDES2_INTERRUPT_ON_COMPLETION);
>  }
>  
> -static void dwmac4_display_ring(void *head, unsigned int size, bool rx)
> +static void dwmac4_display_ring(void *head, unsigned int size, bool rx,
> +				unsigned int dma_rx_phy, unsigned int desc_size)
>  {
>  	struct dma_desc *p = (struct dma_desc *)head;
>  	int i;
> @@ -411,7 +412,7 @@ static void dwmac4_display_ring(void *head, unsigned int size, bool rx)
>  
>  	for (i = 0; i < size; i++) {
>  		pr_info("%03d [0x%x]: 0x%x 0x%x 0x%x 0x%x\n",
> -			i, (unsigned int)virt_to_phys(p),
> +			i, (unsigned int)(dma_rx_phy + i * desc_size),

This code will probably not work correctly on a machine with physical
addresses greater than 32-bit anyway and the address bits would be
truncated then, cannot you use a phy_addr_t or dma_addr_t and use %pa as
far as the printk format goes?
-- 
Florian
