Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3B173D3173
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 03:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233145AbhGWBQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 21:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233181AbhGWBQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 21:16:21 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD660C061575;
        Thu, 22 Jul 2021 18:56:54 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id j1so87387pjv.3;
        Thu, 22 Jul 2021 18:56:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SaBBsKSooT2THR7y3tZObTkjeHzlpmexL9S+wtcTGhQ=;
        b=FUbGZwJtHW4O2yNb1uVTI+lh+tiBZK7uYBio8dHZXTdbrbvjQnwS4BNuQPispCwqcQ
         fTk8CAL1fVmgu4EiV5HFxooTv4nkOTCaIIpG/mB67hkEXgIVJpF5lz+d7ca+7uvnPpH8
         9sO5wp/vC9gJm8ooQ4HlvgWyoaGKuUYlvmncf0SijGDIe9t9xueqSCnxki8rHzIlAcP0
         ohy5PcJp8y3chnx1h9BvYHSqa2tuo6DP+tM+mcKlBT5ODf302z09Nig1YQBCkwDEuAFP
         GcPZc8IESZjUXuBcJvkxH41GaAx4FwoziqOBiK54ULOLh0/LUvHacPUjDU1MzKW0LCFN
         jGIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SaBBsKSooT2THR7y3tZObTkjeHzlpmexL9S+wtcTGhQ=;
        b=Z03fxbVBga2Z5bR+dwZQxVrpk9UTvm/82h7Prp4FCJfLBG5xJT6BktxA7c26uQKTxN
         FNfvdGqhg5kZRcBzfLPOcthUJNcWHYdU72QrU4tr/jo1SZ/f94fry0ntySpUZeFNQFEq
         v3wHffvMXqf550FpYx80VzHT4yH6k+NOSvAiX59uDXYz76rgQNdh2Iw3N6JJA47fpBm9
         TbQbWwMrOptq3juFuweU94DIfplXKlwkNn4D4LPUgA5SifTAr7u0JjlsMlnNXfWZtqdx
         qFgdpIIleiuHnCxUmWii8EEFPYfYi0qtmyWl/ccUqSf+glexqVmBDd+NVM5ahsWRdNJK
         MoNQ==
X-Gm-Message-State: AOAM532hgIWPzSjAdAU+74n9fn/3KRlOsR/9nFQ5HV9NTMF5PA1+J6st
        SRXKjOGAj4oaBtkbe4LxJ3kOz6tcjLU=
X-Google-Smtp-Source: ABdhPJw0PlLazqVOuRIrX3AdjVLAy3M1PNyOSeiuaRdDzwxOUaeaSPe557GCVnkQfQ2bm7JFsRN73g==
X-Received: by 2002:a17:90a:e2c5:: with SMTP id fr5mr2547763pjb.34.1627005413959;
        Thu, 22 Jul 2021 18:56:53 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id f3sm26870776pjt.19.2021.07.22.18.56.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Jul 2021 18:56:53 -0700 (PDT)
Subject: Re: [PATCH net backport to 4.14,4.19,5.4] net: bcmgenet: ensure
 EXT_ENERGY_DET_MASK is clear
To:     Doug Berger <opendmb@gmail.com>, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210723001509.3274508-1-opendmb@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5f9ebe21-3d66-f439-f591-8c0b1fd0b534@gmail.com>
Date:   Thu, 22 Jul 2021 18:56:48 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210723001509.3274508-1-opendmb@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/22/2021 5:15 PM, Doug Berger wrote:
> [ Upstream commit 5a3c680aa2c12c90c44af383fe6882a39875ab81 ]
> 
> Setting the EXT_ENERGY_DET_MASK bit allows the port energy detection
> logic of the internal PHY to prevent the system from sleeping. Some
> internal PHYs will report that energy is detected when the network
> interface is closed which can prevent the system from going to sleep
> if WoL is enabled when the interface is brought down.
> 
> Since the driver does not support waking the system on this logic,
> this commit clears the bit whenever the internal PHY is powered up
> and the other logic for manipulating the bit is removed since it
> serves no useful function.
> 
> Fixes: 1c1008c793fa ("net: bcmgenet: add main driver file")
> Signed-off-by: Doug Berger <opendmb@gmail.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
