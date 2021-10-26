Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDFA43AC32
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 08:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbhJZGUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 02:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbhJZGUs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 02:20:48 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8063AC061745
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 23:18:25 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id g184so13124149pgc.6
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 23:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=tFnMSq8dN0GzE1EOXCfbwf1JAT/rnF5zi7oAyrddMpM=;
        b=Z58eBGCXQLG/GSAUBcjQZnrnNk+WYz/lfaOCtx8PbPaF41kk2381W7rElVwc2TD2Va
         1zGlk2za9QxK3jLj1B0N6qGtDNGQSJ80NiepwKJbt7CzWcAQYx21FAk1VmY0KKSMgEzW
         0RsZo8DKJ9oB0FaVb1buAOLtRaKKq4siZhAnOb4QpBxFSOGkMhJH40HLygEPLtSAK/Ym
         4l2NFZO0gGhSzesbDVT3v7z22WUaPHclTsF8gIf7LAhoq0gApxMsLHCclBHnaao1snDI
         oMHVgEZHk6jXB778S1VbWTo7utnpDBnwcbdiF7FoUH8WpE31ZKg57lGwzH+9rgM00p5T
         Jklg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tFnMSq8dN0GzE1EOXCfbwf1JAT/rnF5zi7oAyrddMpM=;
        b=nR+L3qoTDjC/VDnI0zoZYDkEekaFX4wVCC/f5rY58iysyCS3fU0b2S6pUv/uN5sHnI
         RCxlRjXbBdsPCTR4DBacnHWp9SGOrUZJGzcyLkmDFI+VXk5iIXIQBokltFaE40jIX1tw
         H2j+Bt5cZBY/SnTWZO6gF1zt1w6tzJBeX2RdD5lGSgSjhtA9uFeTPKJztcdDfOLHi6sS
         3Z9RVKNgjW20+/XkGWYHPkyigt6XSeRk1EoXcyBzmMDb3urss7S5RGmINJ199FP0k4gc
         mxQQibkftfrcb80qzkINJ6rf7dsMKBdJtIAMSB3PICiitfW5S9N+k7HdSSfxfCQqvbyY
         rocQ==
X-Gm-Message-State: AOAM533cEe63B0nBn/PjNv98QC1904apYAVwhmYUlFAsE8c3kMst1jtk
        g6G4thhN7fOTs2DShJBaR5NdxD4jOiHLcw==
X-Google-Smtp-Source: ABdhPJxIgfjhFaLOhSA7AUU0/GBJUMrfCPVGYmWP2Hw8GPWnyHmfT8WrDOIJQZT3XnvVG8V74/4Usw==
X-Received: by 2002:a65:530d:: with SMTP id m13mr17390683pgq.128.1635229104645;
        Mon, 25 Oct 2021 23:18:24 -0700 (PDT)
Received: from [192.168.0.4] ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id u10sm6499268pfk.211.2021.10.25.23.18.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 23:18:24 -0700 (PDT)
Subject: Re: [PATCH net-next v2] amt: add initial driver for Automatic
 Multicast Tunneling (AMT)
To:     davem@davemloft.net, kuba@kernel.org, dsahern@kernel.org,
        netdev@vger.kernel.org
References: <20211026053648.2050-1-ap420073@gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Message-ID: <27b7e0f2-af30-b4f1-a3b4-efccf7bbb9a2@gmail.com>
Date:   Tue, 26 Oct 2021 15:18:21 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211026053648.2050-1-ap420073@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/26/21 2:36 PM, Taehee Yoo wrote:
> This is an implementation of AMT(Automatic Multicast Tunneling), RFC 7450.
> https://datatracker.ietf.org/doc/html/rfc7450
> 
> This implementation supports IGMPv2, IGMPv3, MLDv1, MLDv2, and IPv4
> underlay.

I will send v3 patch due to warning.
https://patchwork.hopto.org/static/nipa/570103/12583891/build_32bit/summary

Sorry for the noise.
Taehee

