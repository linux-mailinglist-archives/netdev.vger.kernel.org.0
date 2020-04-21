Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 757321B2E2E
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 19:20:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729166AbgDURUN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 13:20:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725990AbgDURUM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 13:20:12 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF8F5C061A41
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 10:20:12 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id o185so6526876pgo.3
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 10:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EztEHtjRAB4S1K0s5wqCaG8zoYpD07ZR4lTXa+eaZAM=;
        b=ZEedwnL1yuh0D6mWvmT23hPIcoH0CPLU5fmwKEy71my3sGQX0kALfadCQo55glD21J
         AGBD5GkUfyAvHu0XrT7kObTWIHy9kGs6kwy0m9OVDf9Ls/qmS5eqsFokfq8iLPz/SisD
         qmZpuDwWE6VEw+1OAff52yTvLwTX1yDO/5T065wX6g4clcN+a6AKEMFFT91hW0p1fx5t
         fZ5sfzOCzU4QxgfjdvB4JK/GWTFbzvr7i3BRRwCMzH8gpUexhIkXpNUPSQl6Kq61Ts8W
         7tjJZy2PNSFQoP+sJ8TJAB7D4qOuLEKySIpz75jFTk8FlNyqlHCY1RrDSfuqG6mRX8wb
         tavQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EztEHtjRAB4S1K0s5wqCaG8zoYpD07ZR4lTXa+eaZAM=;
        b=LdclRM94mTMYQYAmjcZkLjeXAsXl8CgEKODVkNYBgSTdEHpdL9HMvj0W3XEywDFanU
         SRem4017HVzLEpgi9eDe0ROww5lENhPM2G++RDVM924WmcD0vKZOdL9HbQ1zlPIyb+uf
         cgd1BraLiSvSQabOZdQfiGBbI1XMj9aAFVHm3cNJD9wM7I+g17XCZ48H0yOacf8SLrbk
         +J2DlF3ojWsWcRWSTaiji+d5qDEhKP7dHT0ItIumOZwuoPCPnjhJBl9rV/7WeZU56GXm
         878McILTO6B7B1fojNNSztGRhr0wL6Gc2KOh+4W2ysFst0XpFq68KNQsBt0eLJaCySqJ
         NFFw==
X-Gm-Message-State: AGi0PuYU46Gxqxebph0vlyHxlpxx6Qkkliu03r7AUCogG3f+wqwYLJOD
        0afcBvi+AzTYs0PAAxGfSi+mWNIe
X-Google-Smtp-Source: APiQypLOtow56P4XPJVBZQT4hsz8jNsEpfS7N9EOoLRQp8vJZbLxc/ihl02QpVQnt5yE1ihtw1zruw==
X-Received: by 2002:a65:4349:: with SMTP id k9mr23273187pgq.424.1587489612041;
        Tue, 21 Apr 2020 10:20:12 -0700 (PDT)
Received: from [10.230.188.26] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s44sm3123944pjc.28.2020.04.21.10.20.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Apr 2020 10:20:11 -0700 (PDT)
Subject: Re: [PATCH v2 net] net: dsa: don't fail to probe if we couldn't set
 the MTU
To:     Vladimir Oltean <olteanv@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com, davem@davemloft.net,
        o.rempel@pengutronix.de
Cc:     netdev@vger.kernel.org
References: <20200421171853.12572-1-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <35b913be-edcf-cf3d-fb79-c69c1aa4ff96@gmail.com>
Date:   Tue, 21 Apr 2020 10:20:10 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200421171853.12572-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/21/2020 10:18 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> There is no reason to fail the probing of the switch if the MTU couldn't
> be configured correctly (either the switch port itself, or the host
> port) for whatever reason. MTU-sized traffic probably won't work, sure,
> but we can still probably limp on and support some form of communication
> anyway, which the users would probably appreciate more.
> 
> Fixes: bfcb813203e6 ("net: dsa: configure the MTU for switch ports")
> Reported-by: Oleksij Rempel <o.rempel@pengutronix.de>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
