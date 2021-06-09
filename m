Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E78473A1B70
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 19:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbhFIRGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 13:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230269AbhFIRGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 13:06:19 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCEFFC061574;
        Wed,  9 Jun 2021 10:04:24 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id d184so4512349wmd.0;
        Wed, 09 Jun 2021 10:04:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6QfIQHwzg/7IShZMfhouk9LnwLLhs4CzqBe/BY4XNbU=;
        b=TToWUV1rJ0PZeAd3lp9HotZuGi2mDF1fOl7h43kHaeutXNvVySGWB9CsN4YmcdvGdL
         4CZs3n9UQJmzo3zU5klFCfVLWT56zh+V21iik4Txz4SjmVJBVfG7OftATfGk3BWy7KSX
         Dbb0PpEmSTI+X9RWox8iYiCg7Rklp0bN99tY4/KoaRphbzgkQ2GeL7ZM40boMxCKsrz6
         +BbdnLkvHtMJ1Q9m228DhICEVQH2AC+YvCTkcNzwlnSe0JWY+9AcY4l9TpI+lH8HBDSh
         L66HEvkeH+wsP5zpPkYtVfykoWPaG+uYU8TRUU3QuXwwMt0uXtLPcwCtg2mwoIVS9rgK
         zzhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6QfIQHwzg/7IShZMfhouk9LnwLLhs4CzqBe/BY4XNbU=;
        b=e8PUknUfoCFoaafAfIYSJIuLqpxWbuQJ15IA6uqZ3f6eDy+sBOEnsTFyKB9dLPMlgN
         JpwF5ICVsO0Q+dDuFgAFKmpR6L/0a81Yq1AMGU35ylzWo1ud2cyobeN8/JIPE80DI6to
         zH8djDeL916CtnpkPMmxSGlS17hld+pO0m8QyNv/LNlsIp7RyaxeJsHTrlbYpiudP+OU
         yC57qadIzU9cqvlGapRNkdJMesCmLcLuSWMjzEnCJTrCXer7pct29xPiPf4gpfCfX5Ql
         hhK4wTUzGUr+luTm86aCOZYxEmFNtjfyi+ftWk7s3Totc5KPPJBY1lqayFL9hMr3nKPd
         faAw==
X-Gm-Message-State: AOAM531rhio/ZcYl9rBC3nR/6VEoLG4KXu3vHoBgF9qRJFZGjeH6SfuG
        4M1t5Bp5VDHvOh7wv9V5qKStHI25T8s=
X-Google-Smtp-Source: ABdhPJy++xDr23fH9a8DmUwPgXGBDLEAdw7TfKhGfKm709u9iBONdwDk1Xl6nJtXKsrOtvNY42B7rA==
X-Received: by 2002:a7b:c192:: with SMTP id y18mr10896660wmi.65.1623258263211;
        Wed, 09 Jun 2021 10:04:23 -0700 (PDT)
Received: from [192.168.181.98] (171.251.23.93.rev.sfr.net. [93.23.251.171])
        by smtp.gmail.com with ESMTPSA id k36sm322188wms.30.2021.06.09.10.04.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Jun 2021 10:04:22 -0700 (PDT)
Subject: Re: [PATCH v7 bpf-next 00/11] Socket migration for SO_REUSEPORT.
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>, ycheng@google.com
Cc:     andrii@kernel.org, ast@kernel.org, benh@amazon.com,
        bpf@vger.kernel.org, daniel@iogearbox.net, davem@davemloft.net,
        edumazet@google.com, kafai@fb.com, kuba@kernel.org,
        kuni1840@gmail.com, linux-kernel@vger.kernel.org,
        ncardwell@google.com, netdev@vger.kernel.org
References: <CAK6E8=cgFKuGecTzSCSQ8z3YJ_163C0uwO9yRvfDSE7vOe9mJA@mail.gmail.com>
 <20210609003434.49627-1-kuniyu@amazon.co.jp>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <b8379382-1ac9-6ac9-0cb1-d413c73b18ac@gmail.com>
Date:   Wed, 9 Jun 2021 19:04:19 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210609003434.49627-1-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/9/21 2:34 AM, Kuniyuki Iwashima wrote:


> 
> For now, I would like to wait for Eric's review.
> 

I have been busy these days, I will review your patches by tomorrow.

