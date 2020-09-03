Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 034D525C351
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 16:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729371AbgICOtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 10:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729221AbgICOV1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 10:21:27 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C049C061245
        for <netdev@vger.kernel.org>; Thu,  3 Sep 2020 07:21:17 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id 67so2244398pgd.12
        for <netdev@vger.kernel.org>; Thu, 03 Sep 2020 07:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wST4pYUWSqc0gRHAhcv+00u0n9uuPJnIUa6+ZzNGSVM=;
        b=Fx0QB07ky8bbUELrwfh9p5GqvM976k7+YLPBViVW/0x2+LiGoh/n2/pd1BZ+3E/ljN
         pKrsrrCaHUk46nP8Y3895+WSxRKcFkSX+RXqT8GoAx7Yo8+mPxS1XYpSMV8iK1eski8M
         +aKypxvIE2wizO94/nvzXdHcGbEiktndkcMzPHsCSOP3LSVINnIpwmRT4WsGRrLFYYbk
         WMMEU7w2c4/KGM5Vm6PWkKfPGPgQJEJG61uwLyA+NQVSAJZ2KCthjkGeOVSe5NpDY8gf
         tk1Kd2N3hc5ywpffMTNoMd1Dh+KtPYvo/Ma3ROuezPz1/H+x339iiUOX6syGo2hw+gf4
         xMTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wST4pYUWSqc0gRHAhcv+00u0n9uuPJnIUa6+ZzNGSVM=;
        b=obY63IZYy09C5gmecvYJKlOarMKKcdCkfpwzYzmCmfwy/5C0Jq4QVcBvZjrJ3c+1vJ
         rLJ2jZ4aBaeJNZWPHzDk1MDnnIFBm3NRl78DAS9CpZfbCK7q36L8kxJm4jOWMLQGsAfj
         XlzHIE/v6mqFEzap8YjnisWhg3srEO/wj5p9RjEeRH1QkIcI1/Vk0vn5cq2qf4RNdxe4
         i+LfHV2M6a2PDtvt9qmHpCmQa+8oTnzvM/LcEvDIF52hm7hE25VHCJOeGoGYC0WrqB02
         djFWQOJdradWsBEazYCGjsL4mrSDFPFMq9nEP/4J9w1piVA8oAxZzi0BaKPfxBatdqCN
         piig==
X-Gm-Message-State: AOAM530IFbSkds+S2NzuRYF/dDPa1t0hM5yA3WvdHEDALiD+Xz8WWFdb
        UNu5mE+s5Q8g1Dw6GjrmGfc1lnQ8sH0=
X-Google-Smtp-Source: ABdhPJx745VOJummv2/LZtWMkxHeJlDh0DPv5MiiKyTqmflA3ZB4/25vMjWcndjSWkioEMBrOjaveQ==
X-Received: by 2002:a63:ff4e:: with SMTP id s14mr917761pgk.137.1599142875695;
        Thu, 03 Sep 2020 07:21:15 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id v17sm3358705pfn.24.2020.09.03.07.21.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2020 07:21:14 -0700 (PDT)
Subject: Re: [PATCH 1/2] net: dsa: b53: Use dev_{err,info} instead of pr_*
To:     Paul Barker <pbarker@konsulko.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org
References: <20200903112621.379037-1-pbarker@konsulko.com>
 <20200903112621.379037-2-pbarker@konsulko.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <817467ca-d5a1-cb0d-f50c-e4d3700df027@gmail.com>
Date:   Thu, 3 Sep 2020 07:21:13 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200903112621.379037-2-pbarker@konsulko.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/3/2020 4:26 AM, Paul Barker wrote:
> This change allows us to see which device the err or info messages are
> referring to if we have multiple b53 compatible devices on a board.
> 
> As this removes the only pr_*() calls in this file we can drop the
> definition of pr_fmt().
> 
> Signed-off-by: Paul Barker <pbarker@konsulko.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
