Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 707D4221A87
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 05:06:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728057AbgGPDGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 23:06:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726770AbgGPDGR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 23:06:17 -0400
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7E50C061755;
        Wed, 15 Jul 2020 20:06:15 -0700 (PDT)
Received: by mail-ej1-x642.google.com with SMTP id n22so1955618ejy.3;
        Wed, 15 Jul 2020 20:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yQDsOYz1dvFgi775kGKyitJeopMyY0R0FVXEBIxbvLk=;
        b=MkBY8UQ/2RfDFsP+/15qNt/vl5jl4/VAISyY4B7FVuUv0djI+jd8WY2bhsQ88oS6W8
         I54Y9TofPGLt7wo4xjFL82LNBE0pGok/Is4fv04nJOhmjPs4jo8nm9RyyaPTRMgWR/8Q
         dSSuDtCa+sUMCQGhftpkIdvPjezmOKzmvRE4xyLX84iOB5Ri1+RuQH6VAzsZliUBPExI
         Z1ZynN3a4Jow1eW9o2Ehg8m7bE7+n+e9Qi5PfV7CfVq2rJ1UuqZIpI/mK2SpfqzPL0/4
         LytujLrmCm3Ui80yJD0MgqE+a99tUjGlvayYSL3gzHlRiC8iOlpTQlu6K9C+77D1g+lv
         pcgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yQDsOYz1dvFgi775kGKyitJeopMyY0R0FVXEBIxbvLk=;
        b=gTynI6Zj6rDk7mXjp6MmKchxfh56RxBIK1sYohqAtjHPVOEzYpqq24h+C2q4RGxFO1
         vFcttwUXZop0gB8JD0tlxwD/lyF025YCWNnXSNkA/YmfMvZlnXSS6zhpfnngCideTuOl
         8Z7LMzcasEIdGhrB8FijdVQOU/PodIzA2qyWNdvfXWDu8JCz7BU4DuwZb7sIm2kV4CZy
         NCBd2EDdnsVc8HthzQOXQ79MbmNyPudn5VCLD+HevrbMs5xwF72uYgea62RcmCy3fS/J
         Grv+vJhzhRQf06j7nXYuV9s5QT+Tz1tGMEm1fhsZN9PRe2yda5EkxinDl9fP8Z9DWYGJ
         cIww==
X-Gm-Message-State: AOAM531a4Ib+UHkX7dZdeJmOhuiOtzttxRMEGttIZWX7fAjBUHwbNOaC
        WW1vo4MpTLn2OPWF3hobHhZyxqW+
X-Google-Smtp-Source: ABdhPJxNJi7ZFagWNLSMaFWAXrZ4Bb+vx1dUgF/4uhN68rNo4HCj8iUCXgWlOMBoqtlqmlHAagqL2A==
X-Received: by 2002:a17:906:1c05:: with SMTP id k5mr1810965ejg.320.1594868774206;
        Wed, 15 Jul 2020 20:06:14 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id v11sm3730242eja.113.2020.07.15.20.06.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jul 2020 20:06:13 -0700 (PDT)
Subject: Re: [net-next PATCH v7 4/6] net: phy: introduce
 phy_find_by_mdio_handle()
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>
Cc:     netdev@vger.kernel.org, linux.cj@gmail.com,
        linux-acpi@vger.kernel.org
References: <20200715090400.4733-1-calvin.johnson@oss.nxp.com>
 <20200715090400.4733-5-calvin.johnson@oss.nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <0a40b93a-3bbc-2936-75e0-9006067a176a@gmail.com>
Date:   Wed, 15 Jul 2020 20:06:09 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200715090400.4733-5-calvin.johnson@oss.nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/15/2020 2:03 AM, Calvin Johnson wrote:
> The PHYs on an mdiobus are probed and registered using mdiobus_register().
> Later, for connecting these PHYs to MAC, the PHYs registered on the
> mdiobus have to be referenced.
> 
> For each MAC node, a property "mdio-handle" is used to reference the
> MDIO bus on which the PHYs are registered. On getting hold of the MDIO
> bus, use phy_find_by_fwnode() to get the PHY connected to the MAC.
> 
> Introduce fwnode_mdio_find_bus() to find the mii_bus that corresponds
> to given mii_bus fwnode.
> 
> Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
