Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BDDC1F6063
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 05:15:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726418AbgFKDPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Jun 2020 23:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726279AbgFKDPY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Jun 2020 23:15:24 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15580C08C5C1;
        Wed, 10 Jun 2020 20:15:24 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id s10so1924710pgm.0;
        Wed, 10 Jun 2020 20:15:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ieezdRHhcmgP1Eab+GDG9Fm8oNf2bUgXlbKCTMG/yA8=;
        b=UD3fllUhYn3n2k1bBAgag3980r5AE0luNBIYgI96Hv0pWE5Xs6Tf4JDXBl/nBs/LGx
         uEpi9JOXwAzQzG8jlmxoxWSBddRc57ri6XT9w0dpkeQ7RqzeR48Jm9xLKdmTGK8APkdT
         xncomGVnVpGqDB/HP4GJjDdcblz1cxGpy8fz6LRPc5MiuFH9EJs7bmWqIiY3ODGMmMw3
         o6ZtxpvcpYQIi1syzFTQJxejHh7t5AnvbRBiCQZFYzDQH7KY0EIlAyFs/NF+wKJJj/4w
         KxR3q6eV5CZSeBmWUX5hM9Jz5+clOYl2fL64f0gzaCDKrukwDkPT6t3/rS9mCes0IbKS
         CZgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ieezdRHhcmgP1Eab+GDG9Fm8oNf2bUgXlbKCTMG/yA8=;
        b=tSG1cOeQIdCa723rMNSn8xmJkoA1h3oDcwI5mua2yOZ2zz4dF4g1Fe8/Dhrgow0d/n
         oIMSuJDl4C5SVBebPtAKwcc3D8fgxbaM1h328fPlYO8qJjrJnPtofDDN3bi1UJQZRBXf
         SyXhf+XerwAClDvsvz2TJuNyLhtVtnwkEWL/oPjUIQHubZiW1bLmhIfH2lCFmgoqP8Ez
         e+akOomw1+fu70MskMMZwJJiKYI5n9NnEmBKB9o7Rw3vOCYLJ3U8EcSKgw00N5x1nu4h
         p5hzB7frZRFcdKJ8Bp1GQBDEcmffLzYa1byrfNANmLSufeLfN9mYGAzVY0Jr4XjEtTO3
         7UUg==
X-Gm-Message-State: AOAM531Bt/VRR0FLDLuG+9VnYOnlD3Novg2GnPAN8UXmYWqjET2alMGD
        qk1Uqkh6015dcIQzvS2HA2Ay1zIl
X-Google-Smtp-Source: ABdhPJxQ80OnCFFcFDNJ34AiR5BcgKnrhflKWecBBb6VQ0x9wc8yKiOCFdCbWTIcEnp0SlaffUGdZA==
X-Received: by 2002:aa7:9a9c:: with SMTP id w28mr5012925pfi.295.1591845323100;
        Wed, 10 Jun 2020 20:15:23 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id hi19sm997035pjb.49.2020.06.10.20.15.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Jun 2020 20:15:22 -0700 (PDT)
Subject: Re: [PATCH 1/2] net: dsa: qca8k: Switch to PHYLINK instead of PHYLIB
To:     Jonathan McDowell <noodles@earth.li>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1591816172.git.noodles@earth.li>
 <78519bc421a1cb7000a68d05e43c4208b26f37e5.1591816172.git.noodles@earth.li>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c5257ff7-0d0c-82a0-47ee-671692991a09@gmail.com>
Date:   Wed, 10 Jun 2020 20:15:20 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <78519bc421a1cb7000a68d05e43c4208b26f37e5.1591816172.git.noodles@earth.li>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/10/2020 12:14 PM, Jonathan McDowell wrote:
> Update the driver to use the new PHYLINK callbacks, removing the
> legacy adjust_link callback.
> 
> Signed-off-by: Jonathan McDowell <noodles@earth.li>

This looks reasonable to me, Russell would be the person you want to get
an Acked-by/Reviewed-by tag from.
-- 
Florian
