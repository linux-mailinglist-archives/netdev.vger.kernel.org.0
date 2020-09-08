Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8164B260934
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 06:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbgIHEJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 00:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbgIHEJj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 00:09:39 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A32C061573
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 21:09:37 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id np15so8138167pjb.0
        for <netdev@vger.kernel.org>; Mon, 07 Sep 2020 21:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kx2GUHIjfvLte1HEtTymBNaGeIbgSLQLs6MgLGPG/z0=;
        b=c9xL5MRsa7QmfQy3npoqqs1llepyXKgNvzuIRPHTqgtYvnljjzh4w99Fm4gEviAbnr
         ANJxabETPgdujerJ1RRQn0VP32ypsubldFE+kVk+1A96L766+jLdc4HyGD0QZIrYBc7Q
         RoKPfMQxjmlhldoLMrHCrtuZ0qnEHmHpk2KZypQfxZvJwvHrl3kCqFYqtjcn/LJMUmWL
         0XMCmFq0PaLngrJngJkUgP37j+cwka5Gc+YvE8kpNcaK0sQZBNrTP78A6vXfLxeY5XEw
         7ZMuypzcns0UN5lZcnt8bUf6irNInShRBwemVDncx2FObfmR4tTsxXArfNtl/HrCZEqg
         jSYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kx2GUHIjfvLte1HEtTymBNaGeIbgSLQLs6MgLGPG/z0=;
        b=AXObclFDwtiVTWJuVp/nBKnSQuV/3Yz+ldijBXd/NCxkwJHDoKwqaHD3WVezrFf2TK
         SA7w+tuW0Her5Sq5BB7KB2WbUpR06qypt/MGzyMRRjtEiqdh0+5HF0r4RHegZjLDOCE/
         hFP3nzXw+phc9NYVa6Ap9AIUN3CknPEAtxr/mldRSODtC+K1TNs2O203T/4fgWQdhMCM
         nByG5PEDMaT5damHSmSrvzIWBMF6yA9wwwADlldShQo9GimS81aBUMiqhxVtw9CFRMKK
         P2NId6wsiXL8bpbP2XveO1WLqcEk+JGIrQTYf1kmKj/zGZg1PDYW6KSCJHqdQKADtxsy
         e+HQ==
X-Gm-Message-State: AOAM530uTpVZwm74ArVTJHk1/cme7SXeHCLobK+DesdVwtRNTDOFmtbu
        TGk7NrEFOCm/SpR8Fg7tZuG6rJrzs9s=
X-Google-Smtp-Source: ABdhPJwy/YDndszyb0lWlhgxLTQtSWkpdm90HHL5nMN6r0GDLhLfDSGcBGd9cwG7hnES4t57Fv9xTA==
X-Received: by 2002:a17:90a:e984:: with SMTP id v4mr2176499pjy.202.1599538174140;
        Mon, 07 Sep 2020 21:09:34 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id s187sm16528945pfc.134.2020.09.07.21.09.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2020 21:09:33 -0700 (PDT)
Subject: Re: [PATCH v2 4/4] net: dsa: microchip: Implement recommended reset
 timing
To:     Paul Barker <pbarker@konsulko.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <20200907101208.1223-1-pbarker@konsulko.com>
 <20200907101208.1223-5-pbarker@konsulko.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b32b9e5b-90d7-55f4-37e5-ec97c59bfba1@gmail.com>
Date:   Mon, 7 Sep 2020 21:09:32 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200907101208.1223-5-pbarker@konsulko.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/7/2020 3:12 AM, Paul Barker wrote:
> The datasheet for the ksz9893 and ksz9477 switches recommend waiting at
> least 100us after the de-assertion of reset before trying to program the
> device through any interface.
> 
> Also switch the existing msleep() call to usleep_range() as recommended
> in Documentation/timers/timers-howto.rst. The 2ms range used here is
> somewhat arbitrary, as long as the reset is asserted for at least 10ms
> we should be ok.
> 
> Signed-off-by: Paul Barker <pbarker@konsulko.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
