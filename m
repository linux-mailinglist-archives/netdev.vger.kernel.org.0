Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C440219622
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 04:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726245AbgGICSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 22:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbgGICSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 22:18:50 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC3E3C061A0B
        for <netdev@vger.kernel.org>; Wed,  8 Jul 2020 19:18:50 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id cm21so405759pjb.3
        for <netdev@vger.kernel.org>; Wed, 08 Jul 2020 19:18:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zCl+baPXI8kohW7ilikGmY0qav3TozsBIOv71gmZwCQ=;
        b=rIKbvRZh2lLri1VkzNPbTJ5bKGctn6azrwQCu74tt0DR30ugy+fWgGgAOKteaT4/aZ
         nRWaFcpbQBzFekFpZ2oJ6L0CzYk8MlQr8ZqPXNi9xyJ05OP+/jiulnY7x8yV7wQqBx/Y
         IE6SxqwB3a0wEpns45l6LXsrlYlcQ5SRnMYgA9pmJuXYA2Nlyd8NBZJoUpbTFuwbqU5e
         avBAA0Z1Wi0RcKmYDowfXD9hrnjTaZior5ZeZujDHGPyGfZqjKJw8AsthJUKSS2FQ0IJ
         nexDTgP8QvAIanmiS9cI4gyQVGZoXRlKN74kz6dItvw/sXM6dhQPP70TFQ4L6bl5/a+W
         RLOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zCl+baPXI8kohW7ilikGmY0qav3TozsBIOv71gmZwCQ=;
        b=eUXx5lT743LlTNm37Ob8+kUVtlQg1nj1RiBGhs6yln9pjono01pttDkS/gVLMR3DWC
         u+NAuBjJWY49YLromWjiM18H158BSV5lo0wH7t6V3m+bTRqak3RBXg7RfAbCy7raxtzD
         qkpK9ud/VJ1sEQ+QwZIFt0ZWwHZp3asre6GnqTsa4Brk6Eh3BnoWp+9lTeeZIvPOAG4g
         YABDLv30D031sw6SrtKdyhWIBdMwg7MP/K3r6LkAlbNh4fhpbiB4f5SLougv5fPm6Mmv
         c+1aq3Ghk4/ArezXmmeABMUAWrYVBdoaMPd7xlTxtp3BZSOJuRsIGs7to6AuNOb7FDve
         MDpQ==
X-Gm-Message-State: AOAM531+tHWyN841nF9AQ4U9TAHrCy/K4LNENxU61ta7hcDl9LbQ86IP
        SfV/4/PuRmj26U3pD/I8Vh4=
X-Google-Smtp-Source: ABdhPJwzw2VD1grsRpt5XGqFRlGani8hpPJiO4kYMSmScrByhiBqiSp0lPHXb+cmNJvpBIRdYiby4w==
X-Received: by 2002:a17:902:bd46:: with SMTP id b6mr52647388plx.287.1594261130292;
        Wed, 08 Jul 2020 19:18:50 -0700 (PDT)
Received: from ?IPv6:2001:470:67:5b9:5dec:e971:4cde:a128? ([2001:470:67:5b9:5dec:e971:4cde:a128])
        by smtp.gmail.com with ESMTPSA id z62sm921246pfb.47.2020.07.08.19.18.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Jul 2020 19:18:49 -0700 (PDT)
Subject: Re: [net-next PATCH 2/3 v1] net: dsa: rtl8366: Fix VLAN set-up
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Mauri Sandberg <sandberg@mailfence.com>
References: <20200708204456.1365855-1-linus.walleij@linaro.org>
 <20200708204456.1365855-3-linus.walleij@linaro.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c30321cf-6a7d-03bc-7fa3-9dbba0d84249@gmail.com>
Date:   Wed, 8 Jul 2020 19:18:48 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200708204456.1365855-3-linus.walleij@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/8/2020 1:44 PM, Linus Walleij wrote:
> Alter the rtl8366_vlan_add() to call rtl8366_set_vlan()
> inside the loop that goes over all VIDs since we now
> properly support calling that function more than once.
> Augment the loop to postincrement as this is more
> intuitive.
> 
> The loop moved past the last VID but called
> rtl8366_set_vlan() with the port number instead of
> the VID, assuming a 1-to-1 correspondence between
> ports and VIDs. This was also a bug.
> 
> Cc: DENG Qingfang <dqfext@gmail.com>
> Cc: Mauri Sandberg <sandberg@mailfence.com>
> Fixes: d8652956cf37 ("net: dsa: realtek-smi: Add Realtek SMI driver")
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
