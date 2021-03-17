Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD8B433FB4F
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 23:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbhCQWed (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 18:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbhCQWeC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 18:34:02 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0818CC06174A
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 15:34:02 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id x126so2108941pfc.13
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 15:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Tbj4YD58XkKEIproCsueDWo4YXqbr2Mqp00uAtIyi4k=;
        b=BHmrYyshzr40WCAal7moYLdiehJkPLJCJw6g9KtE7QD9lbSkVlKATy9TVZ7TtFkCQu
         3nzqbGhZNsOTVAFVC85vn+Y0a98N7LtaMCpeu8FquEOJ8vckIpyVkTVphA373a2elHHk
         brBtKNeukuozwX9q73nmU/2fHUQ1sPBiiwYPSST17gkFxkgC8keSIHbisdFy6QTYmPlH
         8BwrgUJY1LgsN/tFdpofCpLjUh3b6Lyep3+hMU5XOi4k+fGFhKnl0xt0Cw6mrm5+m2GI
         jGNWahmDOiMOhi6TJvJWn+lMUkNDWsdzVN6sfltyhsltrEzajkYMzTXevBTSdKQ5oDOX
         M7Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Tbj4YD58XkKEIproCsueDWo4YXqbr2Mqp00uAtIyi4k=;
        b=KERpabqamRsDcfZi7XlPUBt0EYh7tagzzJpQfS5792CDrobk+kO2IhviFT42O1+Slg
         mvRF/ePzntPT8364nsI192Hjz7Dmlf01KfFMV1lwQX48k2De+GZgaPpLlci86ZWPUs4D
         M7JB1HC9qgnEHM+M0VV1hxkwPxi9IQPIABQFwEDqxHOXOY3Y3ql/d8E9Rt3cZ6vj1B2z
         PF6N35XIEarKhb30v0XwG52u+JoZG9h9E8WNaXAWpCWKp2HyfVcX28De5KXhrCS2MnUJ
         lOvvw49+oSvJLlZRFRyyvJuY02v2fdAgJ41/P3x0cUk/JqzxtWtsvtRRwbOELLYXBeql
         hd8A==
X-Gm-Message-State: AOAM530gY9H2mPtJ6wUJuzEJqUw91wglpNvjpTjv1jLsIP0HFGPl9DJX
        niYjIEtbaM3ArY10Gd/hPwqHhT/aj6Y=
X-Google-Smtp-Source: ABdhPJzLj11l42XtpvssZj6aixx25c2+bwVhssO/3FIzLvUSdGQ/tGUviVHuEtHrWxWmk4sVd9tpEQ==
X-Received: by 2002:a62:170e:0:b029:1fa:7161:fd71 with SMTP id 14-20020a62170e0000b02901fa7161fd71mr1053104pfx.35.1616020440974;
        Wed, 17 Mar 2021 15:34:00 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id w17sm113358pfu.29.2021.03.17.15.33.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Mar 2021 15:34:00 -0700 (PDT)
Subject: Re: [PATCH net-next 3/5] net: dsa: mv88e6xxx: Flood all traffic
 classes on standalone ports
To:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org
References: <20210315211400.2805330-1-tobias@waldekranz.com>
 <20210315211400.2805330-4-tobias@waldekranz.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <5067b4e1-23fa-5bf2-6101-5f964937be86@gmail.com>
Date:   Wed, 17 Mar 2021 15:33:54 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210315211400.2805330-4-tobias@waldekranz.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/15/2021 2:13 PM, Tobias Waldekranz wrote:
> In accordance with the comment in dsa_port_bridge_leave, standalone
> ports shall be configured to flood all types of traffic. This change
> aligns the mv88e6xxx driver with that policy.
> 
> Previously a standalone port would initially not egress any unknown
> traffic, but after joining and then leaving a bridge, it would.
> 
> This does not matter that much since we only ever send FROM_CPUs on
> standalone ports, but it seems prudent to make sure that the initial
> values match those that are applied after a bridging/unbridging cycle.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
