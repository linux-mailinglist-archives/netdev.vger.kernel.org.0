Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 494BA1AFD01
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 20:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgDSSLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 14:11:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbgDSSLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 14:11:12 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57E97C061A0C
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 11:11:12 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id g13so7249794wrb.8
        for <netdev@vger.kernel.org>; Sun, 19 Apr 2020 11:11:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QH24Qq+Xskcfr6K9mWUZgfebjvcLZYaWh4QReTplnhw=;
        b=IHpQs36wy95y1Bjlb4nt31pMOd+fLJYVwOX0+rh6R1cChQFoW4T5sd4vpDHtfl5wcJ
         pGG6feUYMsla4qBPevRjyFo+aO9CJ125t00E2nkQK4fgkTCDLf74QQLM1d7DDqYXlJLY
         txDTMwzKRmLoY16r56fxEhlFUZRMz1uPUXJeupz+0+DkQXrBS7Wuq7hX5N7jbNipZtfT
         kyL9xhQoJQ69XWwW+3HOUe83xO0vuM5M3SvHAXtBOR+BcBSSp+RRG/8fPmEqoat6/qw7
         KlCBfh1Pru4jljcfVrOCGtysoqk4OrDouJFcRQPn4heB0nK1v1hQQ9LnxW88VIu9QtUc
         iLdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QH24Qq+Xskcfr6K9mWUZgfebjvcLZYaWh4QReTplnhw=;
        b=hKUH0Zlzu10VrX600ANzLZlCFei1Y6Aq3Bbh2/u2LOioBv2xHDRzzNUqM5uoW0iEJj
         ftzFaCd6hBLsidzEFGV37ZmwcTmmuuaw6oYVySMlZzBmPscvDvz5dlOSzO2VwZKu0Jbw
         goph3Dp3sH+arKIacCiqwCAog6wLtoav5J/A+ty0kMxkCaDTAfQlCdRc/qn6K8KeZfxf
         GrnKwhEP+SyuWuzqSUdXqDFCUNgfhydKvaYNAtADyDN3nEFBfcNgdsrgfEzlPDW+GJ5j
         /fYF3Zla4yuf8P59aCTA43yE3cmUNU/nVFQCfprEy79mOxYgONjOO3hklvp5RzFI0I+o
         CfBQ==
X-Gm-Message-State: AGi0PuaNtwmZOUh4JJvfF6KvdPINCxPv1aGXDWH/foW9iMzVq7zL2ZGg
        +3Ezw8PdKN8LfvaInSBMZ2MEu0S7
X-Google-Smtp-Source: APiQypLgGf3Ay3UUf+7HwDbKChSKUG76IxMvw478S08gv2SX32i0owCM9bf5NFdVnbBRzxlt+FnsXg==
X-Received: by 2002:adf:916f:: with SMTP id j102mr14161957wrj.335.1587319870894;
        Sun, 19 Apr 2020 11:11:10 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:39dc:7003:657c:dd6e? (p200300EA8F29600039DC7003657CDD6E.dip0.t-ipconnect.de. [2003:ea:8f29:6000:39dc:7003:657c:dd6e])
        by smtp.googlemail.com with ESMTPSA id a187sm16373394wmh.40.2020.04.19.11.11.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Apr 2020 11:11:10 -0700 (PDT)
Subject: Re: [PATCH net-next 0/4] r8169: improve memory barriers
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <c1df4a9e-6be8-d529-7eb0-ea5bdf2b77ec@gmail.com>
Message-ID: <89304075-b079-2489-070c-5934e1d34e0c@gmail.com>
Date:   Sun, 19 Apr 2020 20:11:06 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <c1df4a9e-6be8-d529-7eb0-ea5bdf2b77ec@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.04.2020 19:38, Heiner Kallweit wrote:
> This series includes improvements for (too heavy) memory barriers.
> Tested on x86-64 with RTL8168g chip version.
> 
> Heiner Kallweit (4):
>   r8169: use smp_store_mb in rtl_tx
>   r8169: change wmb to dma_wmb in rtl8169_start_xmit

I think I'll have to drip this patch from the series. These Realtek
chips are also used on non-x86 platforms, and these platforms may
not be coherent. I'll send a v2.

>   r8169: replace dma_rmb with READ_ONCE in rtl_rx
>   r8169: use WRITE_ONCE instead of dma_wmb in rtl8169_mark_to_asic
> 
>  drivers/net/ethernet/realtek/r8169_main.c | 26 ++++++++---------------
>  1 file changed, 9 insertions(+), 17 deletions(-)
> 

