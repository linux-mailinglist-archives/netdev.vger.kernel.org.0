Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C4D92E6D8C
	for <lists+netdev@lfdr.de>; Tue, 29 Dec 2020 04:18:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727244AbgL2DSC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Dec 2020 22:18:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbgL2DSB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Dec 2020 22:18:01 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B212CC0613D6;
        Mon, 28 Dec 2020 19:17:21 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id y8so6575986plp.8;
        Mon, 28 Dec 2020 19:17:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HpIe+WD+dLX+XhZ/PLItxMChRoXXp5y6JT3dnQCX16I=;
        b=eZt0aT1suyUKVjn7E9aNZU/+zwAc+fQNVjM15EAAm6otBIr9ge7/7xGvPMotHiuuCX
         uSgTchOa5XgZInl9Qc27N0dY2cxs2Cf6gDDER9T0pDBajIGazR+rElLtUnS7S65r5xk2
         GRZ4kLHlJIfJiFKVxkLzxIWwffgRBditb4Ad9cKUv/6TTo9fNNTlkuunDp0jTELRi+Qz
         +mPyzopRoMImqGpDlihBucl4PmDjqpsetnjREy0OE4AW6nf37WGHCW+BzuPT978pN8Zj
         LL0IlGF8XXqqxd54Vwq53ZddMaGU6krlgy/nJ3PzMDK4EtMZu1yMoB/bRXvOV5+qLKIc
         XhsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HpIe+WD+dLX+XhZ/PLItxMChRoXXp5y6JT3dnQCX16I=;
        b=O73/RUwf4fCl6IAU582XjxyKxSmsx6m6UM1XgPP8wu7xRsmqgcM3A7eLhXUQ9SwqEg
         SJCsk8hpkyVtykSSOfw/7hcIWwPdQUyGemESqMLG4MIRjL95rcQyG2P94wTNZGGCPLZ4
         Um2RkS8gryN3t58GoRkGBCfnx05GrqRtCGY1W4T6JoraR2u2tMnkaQeFpI0dKQPVUzKh
         B4Kk24vAzMsQ90FolEXDCosiQDfExN685U2e89lmKVtXc12KA9S3f7o3dPZ0dIb1hddp
         XPm1Rg/nKTIAT9TCtDYIgrUmVyPuntvGVJfR0rtHpyTretGs5oVtwWBQfaNLr6eINF+Q
         OJeg==
X-Gm-Message-State: AOAM533SW2qNG2XM3hxt1i7SCvnUIsZ0uIInAkfHq/BUq3v7hy7VM5k2
        9aD87geIpXz9CoRjbHi2nHdwFwreXF4=
X-Google-Smtp-Source: ABdhPJyzf8c691eftcVFlQ7m/GD11ZtJjJhSlp6erG/Lnp+d4loQrwgH0aZprws8tpF58+ejtI5i0w==
X-Received: by 2002:a17:90a:cb8d:: with SMTP id a13mr1950080pju.155.1609211840895;
        Mon, 28 Dec 2020 19:17:20 -0800 (PST)
Received: from [10.230.29.27] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z23sm37105562pfn.202.2020.12.28.19.17.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Dec 2020 19:17:19 -0800 (PST)
Subject: Re: [PATCH net-next v2 6/6] bcm63xx_enet: improve rx loop
To:     Sieng Piaw Liew <liew.s.piaw@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20201224142421.32350-1-liew.s.piaw@gmail.com>
 <20201224142421.32350-7-liew.s.piaw@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7393e13a-5735-19a5-71f7-b370bdb9b39b@gmail.com>
Date:   Mon, 28 Dec 2020 19:17:12 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201224142421.32350-7-liew.s.piaw@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/24/2020 6:24 AM, Sieng Piaw Liew wrote:
> Use existing rx processed count to track against budget, thereby making
> budget decrement operation redundant.
> 
> rx_desc_count can be calculated outside the rx loop, making the loop a
> bit smaller.
> 
> Signed-off-by: Sieng Piaw Liew <liew.s.piaw@gmail.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
