Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C464C1E4A34
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 18:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390187AbgE0Qba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 12:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387775AbgE0Qba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 12:31:30 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2EACC05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 09:31:29 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id k26so3249589wmi.4
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 09:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nBh/Ia9jh4jLsRMZyRjdIme4U07yQwrpYnN+s44vNc8=;
        b=A876hG43hVF9wzLNSrqGPfLoCGyedoitveW6KNuM9A5bZzMEdK3LN7xOm7OWCkNv8L
         EzNKL9zsjJZc/9PX4N1w5Fu82t3uK1DIWJnP2kbjyUaUmbCdMrpD4zMrWnN3YAxXPmw2
         MyHuIOYioHL4+MVghcUMrBt68a5s4GWJViegVpDT8tDWrd4H96ps7H6d47SvFcQlZQsd
         6RaspCSlmPGOhYcoAzlyWi8f+6BMMRlHV9mvpc+KzSNvdWjPDt/g2xDJJ6iyejOuR80S
         y8MOW0bybLWatsD7LWVZtCuSsQvgwe1/hjjcXWUoUJ7JzPFtMbHIe03/TNY2VMA5RWM0
         ftdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nBh/Ia9jh4jLsRMZyRjdIme4U07yQwrpYnN+s44vNc8=;
        b=MW4NqjvMbEFCj8MuJeLY1ZEBT+Y4u2LY+3vFvBtTj6Zmo+qDk13j/pSQoINwpMjdSt
         s+fGICuxOtffht3PpCzUDHYZt0r0Db5LhgD9x6hX/DpjTMZLbDwJlP5vnKjno3wprUsu
         xRr7cUJVmqJdeNhRozTO5O3yWqLbbEUkPqeEgsJrzUU3qWHxgG8I4Qw8vM8wxinS3MGi
         7fA1E/978nnO2EcpmQafzFx2qUuolunB1VCsXL/A5JSRmevXWHtMtjGEzAtCWJbhtjQb
         Y14M/a++pJqfaxinXcA1KEXokAYXNvZJfc9GLK31BkyeSaFJn1GHmY8XOM7TwuL837zo
         W0tQ==
X-Gm-Message-State: AOAM530EEiHh2RkShjAyvlIJ/VO3rwSHPFM0ziuNIzzTkf1qOPSDa5Ff
        xw7Nh1xvPqZdFv/SHhLdMfqbuAKT
X-Google-Smtp-Source: ABdhPJymQnMUOGshMZFSEYGdn3JMFRQ5pWzrpz0iplPzLOm75Qc9IfG94vdqCekx1Axhb96QN95QMQ==
X-Received: by 2002:a7b:cb4e:: with SMTP id v14mr5457716wmj.54.1590597088034;
        Wed, 27 May 2020 09:31:28 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id x18sm2022084wmc.0.2020.05.27.09.31.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2020 09:31:27 -0700 (PDT)
Subject: Re: [PATCH RFC v2 2/9] net: phy: clean up PHY ID reading
To:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>, netdev@vger.kernel.org
References: <20200527103318.GK1551@shell.armlinux.org.uk>
 <E1jdtNf-00083L-EJ@rmk-PC.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <9767e673-f38a-837f-f515-f79df59dfb0e@gmail.com>
Date:   Wed, 27 May 2020 09:31:24 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <E1jdtNf-00083L-EJ@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/27/2020 3:33 AM, Russell King wrote:
> Rearrange the code to read the PHY IDs, so we don't call get_phy_id()
> only to immediately call get_phy_c45_ids().  Move that logic into
> get_phy_device(), which results in better readability.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
