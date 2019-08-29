Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD9DEA0EA2
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 02:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbfH2AaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 20:30:00 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:41461 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbfH2A37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 20:29:59 -0400
Received: by mail-ed1-f67.google.com with SMTP id w5so1978959edl.8
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 17:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=ABqqYv/EJP79rddAp3kaLn+kdqDhIPG0VmK8KQ/CWko=;
        b=NkGuqix2BUGQi0p44g6C6u3I6X6lMJTFG1zGDZvKJOBkTVGGlTelT0rTC1rt5U1Kih
         6uBO1kMYn7XyXfqoqdZLiwB82hFnEfPHOiSNIs1ve2T0pEJwpNC+2UIQfu70+U50FZia
         9v0w79wSKED1VzkIB2BkYjEM6K8j7w7YE2d6KhBBgQZP+3oaYH/zubvi+9zXmQlwKWaI
         7pqxTaWH6SDN+8v0oB7dQwtHnwsm+jD/Fp5TlzS6ohJycsOygpOsOvIZfBoHxJEiZDUr
         pR7IgIn5CTcXShXQK+VkydMsqhqGOCz/eJ1sYo0chf8F0cl69hLRbBYSEyYZtLqyClvy
         F0pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=ABqqYv/EJP79rddAp3kaLn+kdqDhIPG0VmK8KQ/CWko=;
        b=eW7JPCxHMmEXE5iHiDH9n1oqbVLlzqB70wcVT2wewunKhuVGuIbpr6Zg6uuB3Mmc8C
         uyCMNrcSXRJV4HW/SA1hS4mre72abnZv2vb/kdoKrVC9ZrEqAXXHKSzgo8t1KVZYb3cu
         LEa4Hxw0I6MrIiAVl5ZeoNoigP+Xi8lL9VAJyC8OFmYiPPIedeNlyj2ZRWK5nMimsOaL
         OpMzIDlTk3JooRRBz9OkrZN+WvcBGjYL2oJlHvtaI2ji6UmCqwaQzggCxc3glEPmdYKg
         O9VEboPDlNlotDBwEEej4Fvbr1/4VDNEz7kMo7AtV9DIILMpbCZrd8WXgKiYCZEggsgY
         SdxA==
X-Gm-Message-State: APjAAAW2v/hIWMa43/NWfTvtvzLXIVmQXFRVwWFmOYxRLxbVv2NoLf9m
        7YYGBks2L/sTxuq58E4PHDSI2Q==
X-Google-Smtp-Source: APXvYqz/mLlvZgSx6ApWhudr8RXP/HK39miTKk+n1hE/evZerYM619Sq9w6sz9FcNk74+m+jJ3fr/Q==
X-Received: by 2002:a17:907:207a:: with SMTP id qp26mr5718366ejb.12.1567038598027;
        Wed, 28 Aug 2019 17:29:58 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id s8sm126520edq.79.2019.08.28.17.29.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Aug 2019 17:29:57 -0700 (PDT)
Date:   Wed, 28 Aug 2019 17:29:34 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Chun-Hao Lin <hau@realtek.com>
Subject: Re: [PATCH net-next v2 6/9] r8169: don't use bit LastFrag in tx
 descriptor after send
Message-ID: <20190828172934.57a2a169@cakuba.netronome.com>
In-Reply-To: <5b4c94bf-4571-7b36-1d83-c169980a6867@gmail.com>
References: <8181244b-24ac-73e2-bac7-d01f644ebb3f@gmail.com>
        <5b4c94bf-4571-7b36-1d83-c169980a6867@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Aug 2019 22:27:30 +0200, Heiner Kallweit wrote:
> On RTL8125 this bit is always cleared after send. Therefore check for
> tx_skb->skb being set what is functionally equivalent.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> ---
>  drivers/net/ethernet/realtek/r8169_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
> index 652bacf62..4489cd9f2 100644
> --- a/drivers/net/ethernet/realtek/r8169_main.c
> +++ b/drivers/net/ethernet/realtek/r8169_main.c
> @@ -5713,7 +5713,7 @@ static void rtl_tx(struct net_device *dev, struct rtl8169_private *tp,
>  
>  		rtl8169_unmap_tx_skb(tp_to_dev(tp), tx_skb,
>  				     tp->TxDescArray + entry);
> -		if (status & LastFrag) {
> +		if (tx_skb->skb) {
>  			pkts_compl++;
>  			bytes_compl += tx_skb->skb->len;
>  			napi_consume_skb(tx_skb->skb, budget);

Hmm.. the dma_rmb() looks a little sus. Honestly I'm unclear on what it
was doing in the first place. READ_ONCE() should've been sufficient..

And it's not obviously clear what does the smp_rmb() at the start of
the function pair with.

But I don't think you're making anything worse here :)
