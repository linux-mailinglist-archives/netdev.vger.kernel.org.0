Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAA4B1AF50D
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 23:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728083AbgDRVGw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 17:06:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbgDRVGw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 17:06:52 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53363C061A0C
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 14:06:52 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id n24so2400984plp.13
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 14:06:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zRZfqiakDagBCF9kbLEbFozlewruphq0HY99sL8hnVk=;
        b=H4vewU+xp5GHp1fsi1/0++wtYki0niR8KUGrysV2Zim9xsTMfzSo8xAKbO/bXIBeOC
         XZyRHzuDbz3k0O3fwgLaFZFXSyjlGfF3IR8/zcLc3nEMa0jRlbtA2CByCZHT7yDx0Cnj
         B8L40O4EO9HJLNjWmvn7GGn5PkUsfc2L60lcjrpl9+HiFAexvIERh7iuPBhY2xX1UmUd
         9gnGF4b9h1Meh/WQ1KBFAyULbiHVouR/wj/rafdVx7wHuSuTDUdlbV2UvY/VZ+MbG0nq
         a5RoAd74Wyf1qn8MoBOVdw27dO46hSea7oBYX6GaqOB4ImzALx3hhNxvNhwJsXDP6Y/g
         A56g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zRZfqiakDagBCF9kbLEbFozlewruphq0HY99sL8hnVk=;
        b=HShzR4mG94Fg+Fy1a0dLfmG2aalJ1X34SAEsaOgENQixVgrH22VL5Jtl+IPUTZ9mqm
         AZsttC97udNc6yDlyfmN0borPDQbGm5ZmRdF9HAwo92uZVvuR+ruJByhSTWANxZ5poMJ
         ZYNhtgqqVcNaEwoc4BYWYb/Pr5DgLvdW9TuFISwgcS6HLUVX8eCIQDvWpiiAvl7b0G1Z
         9QcXnh8NLfkB+L8Pej58t/rTTBwF5TleZshWiqjMjqK/nZSENAsDSK+xj1SQzyMAh6fo
         GsbRZS6kLYWEnVbOEQyeaTfegDJMtRgpc8WowvBUrBP8n0MpmdGz4lwOr3l9IthTt3D0
         QqPw==
X-Gm-Message-State: AGi0PuZKgr6/eglpBN54AfBRhyeM0CyyHwaLYCeQh8o60jGt1WuQQ7gj
        Xi4QsC1XNtO+jOuT5f3mPo0=
X-Google-Smtp-Source: APiQypJF9pB31+958aWAT33oIvVwNXB6F4KZgEEZqoIRFIRKzbIAjU8ENezSEsBs8WZ7TMe6m303iA==
X-Received: by 2002:a17:90a:8415:: with SMTP id j21mr10929882pjn.12.1587244011755;
        Sat, 18 Apr 2020 14:06:51 -0700 (PDT)
Received: from [10.230.188.26] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x13sm1169567pgh.63.2020.04.18.14.06.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Apr 2020 14:06:51 -0700 (PDT)
Subject: Re: [PATCH net-next v2 1/3] net: ethernet: fec: Replace interrupt
 driven MDIO with polled IO
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>, fugang.duan@nxp.com,
        Chris Heally <cphealy@gmail.com>
References: <20200418000355.804617-1-andrew@lunn.ch>
 <20200418000355.804617-2-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d64d4d6e-3ee4-c192-e2cf-4487b4143263@gmail.com>
Date:   Sat, 18 Apr 2020 14:06:44 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200418000355.804617-2-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/17/2020 5:03 PM, Andrew Lunn wrote:
> Measurements of the MDIO bus have shown that driving the MDIO bus
> using interrupts is slow. Back to back MDIO transactions take about
> 90uS, with 25uS spent performing the transaction, and the remainder of
> the time the bus is idle.
> 
> Replacing the completion interrupt with polled IO results in back to
> back transactions of 40uS. The polling loop waiting for the hardware
> to complete the transaction takes around 27uS. Which suggests
> interrupt handling has an overhead of 50uS, and polled IO nearly
> halves this overhead, and doubles the MDIO performance.
> 
> Suggested-by: Chris Heally <cphealy@gmail.com>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

You should support both modes and let an user decide whether they want 
to use interrupts or polling mode by specifying or omitting the 
'interrupts' property in their Device Tree.
-- 
Florian
