Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9504D3A8EAB
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 04:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231931AbhFPCGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 22:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230454AbhFPCGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 22:06:00 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC745C061574;
        Tue, 15 Jun 2021 19:03:54 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id e7so312854plj.7;
        Tue, 15 Jun 2021 19:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nMnafqegrZqlVFj1W+3RSJkSG4+dh74QBTuWYe1HvcE=;
        b=Cr9fkf3SZP7v+Oix+yOuEMo1hKMslJX1yPstp73diKGXP02rtDAMCsRkadI7CN56bd
         L/RWa5aj0E9FJm8Ehy/qtQDWL1iz8K8493k5nCcxGbbVkZuvooE37EZ3PxgEqaCMOH+K
         aXn5ACkA0AFz/JVp71dURgkdDCN0qxWIPmuyCAb9y8D0JjLbkAURnnT3p1tNk1AQrg0A
         geN/IoRdzOkhfzQggJhwXDO2Mm4KK+4VQiAcjFGlxlcTqXvp7igGt2BH7iNAHWDPrrR+
         vylLzXcDftf4A/IM4JzRpxD0vS4EcQqXi54ATA6ae/+tXDdtN1VieJ0Liaf74/19FBBf
         sq8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nMnafqegrZqlVFj1W+3RSJkSG4+dh74QBTuWYe1HvcE=;
        b=Aph1a/Zi8/NG+ee6EkJ/k6JKmVMSK4kRtqUynsUaEcvWQ2438UlRXQW/PtZsrzkXXH
         qH19tHLDLK9IdDqRPu2pX8HUoIIdZctgr6nvyLQZRQwD2yiitufbr8mPdZrPW4pY1h0D
         /KQf3yD+oz1QdQF6mu10ATVAmSj+Mbp4H5ql3MgeUpA598ifOVvXi4fFAU/5iZwSyfIq
         ch9u8Y+uxbVYW7iekpCTqkmZdMh+oMGnmCrYyI8BcX23HwzLTM9d0NKIyBEVyzhhhqio
         pMjl3xBLtMC8LW/c3RVvQS4S7AAqOb7kFonTIBvbGtTKtIAIebk1ihDsG8L3zfk3WSFA
         Zuug==
X-Gm-Message-State: AOAM533LS+urGoyGjpxS8tn3d0xQxDmJl4Jm2iQeOaRXgBcBH2HBd8SI
        EmhH1/Ixvn+xg7qDxzPIuZexwFIyQIc=
X-Google-Smtp-Source: ABdhPJy2iU1c4LahzH+50JktjQr9wrcHzucEJ/mLkfAJaXg01L0cJgcftWPgJvzhuN4HB6c3QQnPrA==
X-Received: by 2002:a17:90a:6b01:: with SMTP id v1mr2404174pjj.10.1623809030048;
        Tue, 15 Jun 2021 19:03:50 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id t143sm389828pgb.93.2021.06.15.19.03.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jun 2021 19:03:49 -0700 (PDT)
Subject: Re: [PATCH net-next v2] net: dsa: xrs700x: forward HSR supervision
 frames
To:     George McCollister <george.mccollister@gmail.com>,
        netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
References: <20210616013903.41564-1-george.mccollister@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <11321e78-2245-376b-28df-7e33b1ad8e8d@gmail.com>
Date:   Tue, 15 Jun 2021 19:03:45 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210616013903.41564-1-george.mccollister@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/15/2021 6:39 PM, George McCollister wrote:
> Forward supervision frames between redunant HSR ports. This was broken
> in the last commit.
> 
> Fixes: 1a42624aecba ("net: dsa: xrs700x: allow HSR/PRP supervision dupes for node_table")
> Signed-off-by: George McCollister <george.mccollister@gmail.com>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
