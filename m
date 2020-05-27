Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E72691E4A5C
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 18:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391272AbgE0QgU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 12:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391268AbgE0QgT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 12:36:19 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53236C05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 09:36:18 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id u12so24748wmd.3
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 09:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0NWW/CEvDxLfZnB+izTChTpw7MIrZliYj5q9t0Yca3w=;
        b=Hakzv4t6yCXF5jpZtMEc7uzwqLvjKsjhEQ3N9/t0mkIJh+49czS30TDgMJ4R0IbZ+W
         LENUXexlzg/xpOpea+p7O5rGKQltqzXKdUkcVR54DWEMRvRAkK1xLHtdOefrDeO7xMLR
         BIZXp00POtz3P8+Xs22qVbyJnWZFx/88VfqiN11QRADFBtsfyznFbNHRU/RqJaVw6Y+T
         BWB3kmFR07LHwDNb6lLsHLRgfaKYorM/lnuvRPd/a4jF2mKqEvfM9dJejQ4mJ/YebrPq
         XgyxEudFPOSD46H39xlDpyHxPSAi3MWIoY5839qCYpZcKzmbOz0SU7bLAMqIeY0VOTgb
         rCSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0NWW/CEvDxLfZnB+izTChTpw7MIrZliYj5q9t0Yca3w=;
        b=Q1F511a+lwEPYVpiBdUnxTqGmTkyt4LtXMuho9LC9ZpdTt5wvX1+Wyk5vR65Y2XATI
         hatDW8h9vLkdff7KR4VWGOK5ogeqnJfCvpcM4xqTwxmjLdbBPK8r90WiXbJasxwi1oRB
         IwGZl2DRoMr240PnI4YS1giQqaJ3vVCJVW5HvT5jWj+I72t11DAclJLq/scNnxz7Fqg+
         ALEAzgjNDdWoGsNFmE4kLhdsQuBHsvW3x7OyOhlTkIgy5Xq/gB1ASU+tjar9Ht7YKxZq
         FX7EC64CLiIAxDDg4Sq3gulUOArojZHasAnL0mJCsOJcPZo8kVkh9dse9NKHtt2kMZTt
         XtKQ==
X-Gm-Message-State: AOAM531OTCi+GuuCOpi79yRnz2LnHM1eeHOXdKun36etkJgD68+X4ulV
        I1+2pX6qXrD60NgoLObJhLk70z1y
X-Google-Smtp-Source: ABdhPJz/eIBbNKQ74FfEcb9x6s1LnuLDeTBTE5BJD9Ye1aJW6HJA+sxFAzW/o9Y1YSqQ9AeTEMU+PA==
X-Received: by 2002:a05:600c:4410:: with SMTP id u16mr4981748wmn.88.1590597376622;
        Wed, 27 May 2020 09:36:16 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 23sm3109806wmg.10.2020.05.27.09.36.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2020 09:36:16 -0700 (PDT)
Subject: Re: [PATCH RFC v2 8/9] net: phy: split devices_in_package
To:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>, netdev@vger.kernel.org
References: <20200527103318.GK1551@shell.armlinux.org.uk>
 <E1jdtOA-00084K-4D@rmk-PC.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7d09eb17-f368-c499-e4bf-bf51474beb1f@gmail.com>
Date:   Wed, 27 May 2020 09:36:13 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <E1jdtOA-00084K-4D@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/27/2020 3:34 AM, Russell King wrote:
> We have two competing requirements for the devices_in_package field.
> We want to use it as a bit array indicating which MMDs are present, but
> we also want to know if the Clause 22 registers are present.
> 
> Since "devices in package" is a term used in the 802.3 specification,
> keep this as the as-specified values read from the PHY, and introduce
> a new member "mmds_present" to indicate which MMDs are actually
> present in the PHY, derived from the "devices in package" value.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
