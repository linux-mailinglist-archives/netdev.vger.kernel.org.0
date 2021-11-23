Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7C645AC05
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 20:07:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236823AbhKWTK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 14:10:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235934AbhKWTK5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 14:10:57 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66182C061714;
        Tue, 23 Nov 2021 11:07:49 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id g18so218206pfk.5;
        Tue, 23 Nov 2021 11:07:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UvbPdUMKD8CTuv9S60ws2yBM73A71Bgq/3okLSu4+nk=;
        b=l+LmivlR+K9IqwQK9J7arDIbo8UH5rjVuZMlPacJZCvrV+t0isI2wftH4C1nkFvPOB
         vescVJgbZQatlAI8alSvD8M9CriczazLeG0MRwdQMmncE/THqMwzw8z5WkWDdOa1YQXM
         /RhhDkkirnc+MYFtK2B+hDi8f8hSbtsBFbSNgypgWduRZoCOgcd24tsmxsg51GpFNXeH
         2u/io/HQ+lJT5Nm8w/Otc58V1eEvbnMc0OkksPbVQqVA9t6D72+u9mlH//KIxsnxuuZR
         FkSuRwljxF5yvhZuj5KdgflgK/Xnx2CXTiBULTBFr9dUKYRbhnjptg0WreqTW+KUQjFj
         FBOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UvbPdUMKD8CTuv9S60ws2yBM73A71Bgq/3okLSu4+nk=;
        b=B7agHYHhzLFe51NdcNG89bK65k719hGp+54EQmufFvPyWuDFzKMbwLbVr1K5uA06LJ
         S5KQPGYlimkev35Ua5/Okh3+DPTP9WLY1Ay77AM2YME7nC2jsGik2BAjru0xcOmlHPSA
         xrL4ILNs7TrexxHQKQp8/OG9+RUyjaYQ57Q2Pc00oye9d4f4tHwxB8rc4CbXxejyqcGE
         gOHzp37/olCANv385hW6vhCD/gNjuN5IBNikmSIsNXvn1KdocnnMganWW50imqa3Ct7D
         dLEx+R8iNvyw9su6pdFpeUiykE9j1Eml4UKgMm9UrXyEdbBMDDApWRuHjnaEIN3n+PVQ
         sZcw==
X-Gm-Message-State: AOAM531/pggi2vOr+7CyCM3C6pdKbFdD0C/bsscYq1KGb9JebKZc8Feu
        Ukr+Q1iYe538roSos2svy/VnfZPaxL4=
X-Google-Smtp-Source: ABdhPJz3e+H7RJHCzPLVX7oe38urHquxkNzFGSPjh2hOyyaYVVBsFNIi/OC7sCLHsCsQJyC1aSPVaA==
X-Received: by 2002:a63:de48:: with SMTP id y8mr5380299pgi.255.1637694468999;
        Tue, 23 Nov 2021 11:07:48 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ep15sm2779936pjb.3.2021.11.23.11.07.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Nov 2021 11:07:48 -0800 (PST)
Subject: Re: [net-next PATCH] net: dsa: qca8k: fix warning in LAG feature
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kernel test robot <lkp@intel.com>
References: <20211123154446.31019-1-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f1b12353-907f-a7fd-7b1d-d3ed90df3a8e@gmail.com>
Date:   Tue, 23 Nov 2021 11:07:46 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211123154446.31019-1-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/23/21 7:44 AM, Ansuel Smith wrote:
> Fix warning reported by bot.
> Make sure hash is init to 0 and fix wrong logic for hash_type in
> qca8k_lag_can_offload.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Fixes: def975307c01 ("net: dsa: qca8k: add LAG support")
-- 
Florian
