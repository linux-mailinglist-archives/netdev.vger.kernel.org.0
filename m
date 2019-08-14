Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C3688DC41
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 19:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728883AbfHNRtk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 13:49:40 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37050 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728219AbfHNRtj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 13:49:39 -0400
Received: by mail-pf1-f195.google.com with SMTP id 129so7094523pfa.4;
        Wed, 14 Aug 2019 10:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=polbAliNun9QdIzqZGyPgJpDTQQfZuizGyPW1Qhvc5s=;
        b=LaKDsTvgihEKNjw4bt5zJVzofPKhzwzlJ9som/wZ7oS4O+Ohvp93iUee85ZshVGdKt
         8e/GP7XZpFl9MJSWPKjhrHSsiAGYxdb9mGAazfPW9SG2fsetu4cUV/ziqnnO0cg2LAGl
         vJfq3+pL2+icqLDJV5VgINPUBGKM8XLrcelrJgnuTaix91mZ38sSAyevelC3Gn7M7Bm/
         Gt2IrbrL5+anIX1ekV4F77gWS4ivGd5E3/BfbHfRzZ5DkJb2EkNs+/2wNZT/QZvC0N2U
         jitJvkbLExn3PcRx9TrFBzJqeylXTMKGC+MEBv6zkQC3D4sF7O1I+r52NmXjsEAjCysR
         o7pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=polbAliNun9QdIzqZGyPgJpDTQQfZuizGyPW1Qhvc5s=;
        b=S3UcwBXrMjezGjWhkalJzdSPJSpQKSiXhbbZJNW6Wl3hrQqsvugJ+WUwFFQaLN3mMA
         CsqgxzKoiMNDP9ZScPnioL7GRd7JjBU7Qfgy8ecBjjXR8M2HSObhVqAdtg7gg+ROl73F
         //sP4vsfReYRyqIhPjfHaJRhySvrH007SHTkQ8JoRkdnyJwiKXGC1Zx/UMXZWohaDEv5
         RaJJj+AiWsVuCOoY/TPBO8usPdL8Iq6/8DtD6lisbMZMKmTyzW0qpCS6g/tM3bS6Kklz
         RYQD7nOBnZjgF7WnXvY756Koi3Qg4CdMMRuQK07AuZRucm1U+1PZXX6TmUFspIY3vjQf
         RRRA==
X-Gm-Message-State: APjAAAVh1f7m8Rk6PMY+vA5UjSXrH1Q4PPH9j7J/OHF60PyMSeREM7S0
        lCz2e6JEsYJNX0aCelX4zhI=
X-Google-Smtp-Source: APXvYqwgFXmxttQFX0GjRAMZC8I7f+mxUrhOF4jKhcs2MDOOksRm5PoqTETD62tejsAHLur6UfDtxw==
X-Received: by 2002:a17:90a:eb05:: with SMTP id j5mr891060pjz.102.1565804979039;
        Wed, 14 Aug 2019 10:49:39 -0700 (PDT)
Received: from [10.69.78.41] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a5sm434562pjs.31.2019.08.14.10.49.35
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 10:49:38 -0700 (PDT)
Subject: Re: [PATCH v4 04/14] net: phy: adin: add {write,read}_mmd hooks
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, robh+dt@kernel.org, mark.rutland@arm.com,
        hkallweit1@gmail.com, andrew@lunn.ch
References: <20190812112350.15242-1-alexandru.ardelean@analog.com>
 <20190812112350.15242-5-alexandru.ardelean@analog.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <31a0cd12-8a0e-5c50-6cc4-043cb8950352@gmail.com>
Date:   Wed, 14 Aug 2019 10:49:32 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190812112350.15242-5-alexandru.ardelean@analog.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/12/2019 4:23 AM, Alexandru Ardelean wrote:
> Both ADIN1200 & ADIN1300 support Clause 45 access for some registers.
> The Extended Management Interface (EMI) registers are accessible via both
> Clause 45 (at register MDIO_MMD_VEND1) and using Clause 22.
> 
> The Clause 22 access for MMD regs differs from the standard one defined by
> 802.3. The ADIN PHYs  use registers ExtRegPtr (0x0010) and ExtRegData
> (0x0011) to access Clause 45 & EMI registers.
> 
> The indirect access is done via the following mechanism (for both R/W):
> 1. Write the address of the register in the ExtRegPtr
> 2. Read/write the value of the register via reg ExtRegData
> 
> This mechanism is needed to manage configuration of chip settings and to
> access EEE registers via Clause 22.
> 
> Since Clause 45 access will likely never be used, it is not implemented via
> this hook.
> 
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
