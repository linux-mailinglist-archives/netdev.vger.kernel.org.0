Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 793413A4B35
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 01:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230446AbhFKXan (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 19:30:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230211AbhFKXam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 19:30:42 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5478EC061574;
        Fri, 11 Jun 2021 16:28:44 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id u18so5651619pfk.11;
        Fri, 11 Jun 2021 16:28:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eDxqetJOsrBD5ewe3QZJjoRuGCPW8oOCWhFR2suRXW8=;
        b=ET+ToOrLXWazwCYdNxg0U7f3RzKUdhs2OWfgRMpUc3jHy4zda0zGsxUUwW71oq3KdG
         aTf7vj7ju9tyT9zL6loqt+sCL7fnAUi58H9jfmYB9UKR21ssSHq/QUnzVmFqJWy/0niX
         KaegldZq9nxGuZhHmlTUaCgK0fVvM2B6NxI32P9l8f5FFuZrNNODKzkOMTrvYWYWO6Fi
         /GoRUD6tD4Z2xdAnes10eXNmvzDiIUFkVPEurMRS1KIwV0ANCAoNKXfjKAyZCWSb5et/
         WrHkfBsVK6wFcsC+9FC9dYPQb003KOy7n0fAGsNLE9k44R2ptTct5XA17hS0D4kCSTn7
         aDfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eDxqetJOsrBD5ewe3QZJjoRuGCPW8oOCWhFR2suRXW8=;
        b=AeQUpNxAd7RiG4opJ8c6qpuqPaMRq+Vlh+KG8HvZ8T/jVV6LLsQDcvcpp2xes6pKpa
         ZhcSUZE7m8avqap1p0nJ6Fh7Q5ZkqNMBRCqeYBHn+ng2BHjx3a3bmvJCFKiGAdE+kSXK
         ioZQAFHxLc+3byEYqVVp6NLaanZuOtEBGU2Kh0/iF8ej/26UkdjH9YX6ympT9b2uSBjV
         B8yJGa+R7zr0YnD+WrDmTqUNmLaNM00GiS9um5lSoaHiT9x6blCAcdsj3gJ6oHkdZJE5
         eMWQ+7Ik2pJ6hqHSa0mkPY35fh5SySktbZWMBJlm8FsxrCmCpgw+O9w/BUB8OaMjV0J/
         VoeA==
X-Gm-Message-State: AOAM530opnpJe01awm+2QJi7b5UpYq3t+0JvvfISZHG0hHy3zw4IzasE
        /WXYp/C500sCaSekLVb8PwVPIhrtM48=
X-Google-Smtp-Source: ABdhPJzMWTtC3yT0tZGm0pGjPSjoyXxg2w1nk68NhLIWmzLKofooiSBtJOp9QqTSLtDhlkQNh4G8Sw==
X-Received: by 2002:aa7:8e18:0:b029:2ec:a754:570e with SMTP id c24-20020aa78e180000b02902eca754570emr7943422pfr.38.1623454123902;
        Fri, 11 Jun 2021 16:28:43 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id i8sm6328133pgt.58.2021.06.11.16.28.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Jun 2021 16:28:43 -0700 (PDT)
Subject: Re: [PATCH net-next v4 2/9] net: dsa: microchip: ksz8795: add phylink
 support
To:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>
References: <20210611071527.9333-1-o.rempel@pengutronix.de>
 <20210611071527.9333-3-o.rempel@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <69840790-5d4c-d460-33e6-fbf1e17dd36d@gmail.com>
Date:   Fri, 11 Jun 2021 16:28:40 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210611071527.9333-3-o.rempel@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/11/2021 12:15 AM, Oleksij Rempel wrote:
> From: Michael Grzeschik <m.grzeschik@pengutronix.de>
> 
> This patch adds the phylink support to the ksz8795 driver to provide
> configuration exceptions on quirky KSZ8863 and KSZ8873 ports.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
