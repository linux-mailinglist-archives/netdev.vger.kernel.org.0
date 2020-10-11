Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B1228A503
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 04:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730348AbgJKC24 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 22:28:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726473AbgJKC2z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 22:28:55 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3610C0613D0;
        Sat, 10 Oct 2020 19:28:55 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id x13so7690690pfa.9;
        Sat, 10 Oct 2020 19:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=abrGFb5Z0J48VjjKlVpgG6k2o9tGWZkHPGQ3DWMV9Co=;
        b=qFjiDRMriXa/bKyFAAUp9AoNztar2N21yLRIQOvBC7CZMu+Uz0hVfNGYMWse/fNZT9
         4wGRRIEMTIdB7nD5/b8mqMEohziget2goubz3kGKYr4VM4yxEVr7S5kBdF+RYIHGEgLa
         5Iy9lZVdv829aDY/zhim2puVp+yFPwkLE6YOhne21L9djr2RUeZuBgfPXQwBQBAVGhdP
         lRODxNfI4KRrOUu/BtzDsdts9zaJ2whYXAQk9HTEZ5Jnr7f5g1hvwJMp7pl0w3e0TTUL
         d2pANmlNRqGnOtGP1QM2BJvbd6vPP1qy1bxT5tNG9+QQxGcSf9UV0007YheOBHEZkn6x
         SPdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=abrGFb5Z0J48VjjKlVpgG6k2o9tGWZkHPGQ3DWMV9Co=;
        b=eOid30DpmFWToXci2zFjszbFzJ/8GjvpDhvgzA6dPvnOcA55+0bDHb6HSJFgLrewhJ
         rr5b3onUy98+e3KFGeCWFnLfUZTLJk/33fyuS+d4fyz7UVXmr3Sdu2JxFuqF5whtaTa2
         N0nhjmjV/ou4jaF1Xwr5VOynchE4RdYlMbd1ubnAh4/1gyfwdOV7FH5oKcp5O6o1Kv8n
         nDUYL3dAcCrL9TTccxOHwsLW7/h/UO6E0k/69KEuF53WVE+z0aWqkDmUSgEu3E06zL/R
         f3AcyXX+mp4bLaJS4oNGU4C61g2XkYKNi5pY8OKoE0nV5Hc0DPOu6FZSTU0cRmmZMOhS
         q68A==
X-Gm-Message-State: AOAM530b8636UB3/8YrRGTKbkqksMwTKb70bjmVuW19r8XrWZdHupmpl
        Uyb6DT3iUzHzNLOWOvlmLPY=
X-Google-Smtp-Source: ABdhPJxKpN9puFqVmtWPSWskekDRrRKyjO+qi7DcM2EOGfVNcg1h7/YT2hszcJ7N8YfB3UNh78cKLQ==
X-Received: by 2002:a65:53cc:: with SMTP id z12mr9071134pgr.333.1602383334387;
        Sat, 10 Oct 2020 19:28:54 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id o23sm17936124pjw.32.2020.10.10.19.28.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Oct 2020 19:28:53 -0700 (PDT)
To:     Kurt Kanzenbach <kurt@kmk-computers.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, kurt@linutronix.de
References: <20201010164627.9309-1-kurt@kmk-computers.de>
 <20201010164627.9309-2-kurt@kmk-computers.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next 1/2] dt-bindings: net: dsa: b53: Add YAML
 bindings
Message-ID: <3249c764-ec4a-26be-a52d-e9e85f3162ea@gmail.com>
Date:   Sat, 10 Oct 2020 19:28:51 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201010164627.9309-2-kurt@kmk-computers.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/10/2020 9:46 AM, Kurt Kanzenbach wrote:
> Convert the b53 DSA device tree bindings to YAML in order to allow
> for automatic checking and such.
> 
> Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Kurt Kanzenbach <kurt@kmk-computers.de>

Thanks for making this change, there are quite a few warnings that are 
going to show up because the binding was defined in a way that it would 
define chip compatible strings, which not all DTS files are using. I 
don't know if Rob would be comfortable with taking this until we resolve 
all warnings first.
-- 
Florian
