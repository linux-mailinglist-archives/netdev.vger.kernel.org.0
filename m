Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A66B38F7FD
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 04:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhEYCRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 22:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbhEYCRy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 22:17:54 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D319C061574
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 19:16:24 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id x18so18088982pfi.9
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 19:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VbQyeD2rfzrDjeYxWSiaTv3+Ipqor8eVxJIRKw45D/0=;
        b=HpYgPlXLGYWiP/ve1L/XtWIhkdcVFpYQocrhrqwyJDwqHd74/Ld+gB7M0zzTSAVAcX
         6KT4Q+sA6LoLHkoNGnVvcE2IQLteSH2HOGPmWPQ6y+gM4nnX4SUY1Fy3GONnjaIo9QhC
         hKeG0hZixrFiry7FsAbmiwFJh2I8CAw1RWVaUrqN6v541GlmB4b+Rd0JfjXB0cz5qCL6
         Po5Jf/4kK4OV5iXaYw4Z8VtGyFhjdqgY6Z8CiFUUwx4QZYxk8Bec0CaAVejrVb5NswUg
         vn+ZvcsYU4CAiDYfMkfT8iMJkD8hNDgM1yM3VzE39pbJTu2+nSj4s0RbLXFDcJqNSYuw
         x7gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VbQyeD2rfzrDjeYxWSiaTv3+Ipqor8eVxJIRKw45D/0=;
        b=g8EQS3YyQZJnI/oKqPZhlQJv+1mbWl7Ak1kTOGJtaqLqQgdER7mBO4Huv11K+tR/tW
         6fYOH6XV2JisGL/f3CjH6COuNPLW9a/FFMJtOqwZbRLJMFNL0yCcGOqTibv/XDnVGo7R
         t9ayV10/FjEHA2Jvhzzfh1mHlyGVGiu/Cwh1vYhq3mYYmInc1qOsh6Yt0i3+6iwv3J78
         GtK6b1I2bgxrqnDXK/6OL2qFHoRsyRxjh57mnj1U5mDdr5Aug3h5VRrzWawQKbWYi55d
         kKvnT8eT+Kq1Hp8Cqa+RquXKCCbkPu48Ra6V2r/qwm0ff8DRIvwgdOisqbj3bWLCSl7/
         h7DQ==
X-Gm-Message-State: AOAM532DZLo4Pm2mTra7iH3mwMqw3ZIf/GP7Bsj4ypXkm3mufEvJmY0E
        QsO0nrxDbBUW+y7F/Gl6Vy8=
X-Google-Smtp-Source: ABdhPJxnl78CJdyjh4DcnAG9aGRLAHCQuLielVb+eJrEJapc1xWJ8VQB07WKmA76XvVjnROC8pNhpA==
X-Received: by 2002:a63:d218:: with SMTP id a24mr16481896pgg.345.1621908983878;
        Mon, 24 May 2021 19:16:23 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id bb18sm572050pjb.44.2021.05.24.19.16.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 19:16:23 -0700 (PDT)
Subject: Re: [PATCH net-next 02/13] net: dsa: sja1105: allow SGMII PCS
 configuration to be per port
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210524232214.1378937-1-olteanv@gmail.com>
 <20210524232214.1378937-3-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c2364571-dff9-2654-5160-a37d9f48ba9b@gmail.com>
Date:   Mon, 24 May 2021 19:16:20 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210524232214.1378937-3-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/24/2021 4:22 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The SJA1105 R and S switches have 1 SGMII port (port 4). Because there
> is only one such port, there is no "port" parameter in the configuration
> code for the SGMII PCS.
> 
> However, the SJA1110 can have up to 4 SGMII ports, each with its own
> SGMII register map. So we need to generalize the logic.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
[snip]
>  
> -	if (sja1105_supports_sgmii(priv, SJA1105_SGMII_PORT)) {
> -		bool an_enabled = !!(bmcr & BMCR_ANENABLE);
> +		if (!sja1105_supports_sgmii(priv, i))
> +			continue;
> +
> +		an_enabled = !!(bmcr[i] & BMCR_ANENABLE);

Nit you could have a temporary bmcr variable here in the loop which
aliases bmcr[i] just for the sake of reducing the diff to review.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
