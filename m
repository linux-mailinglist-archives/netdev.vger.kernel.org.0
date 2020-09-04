Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F68425D02D
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 06:04:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726251AbgIDEEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 00:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbgIDEEO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 00:04:14 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2885C061244;
        Thu,  3 Sep 2020 21:04:13 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id m5so3649121pgj.9;
        Thu, 03 Sep 2020 21:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4TCgYr5ncOjL+8eCE97Mxvf9/nlILupNJJJIRFrFPFw=;
        b=iJ7e2l0kpSaubm6rNet1cEma2crCXb5n1BZmK2vWNwNjtDExxl4oypxJ4+NGXhKfTx
         I4cM1ODTkWKoywWzJZN1o0n5W5Cn7Y18C5yj3eqHVL8Ic9DSd3cP8AslHlPVsBosTjRI
         J+Bq7CoFxuqiBiuk+sZpuyhz3j0xMHzOz+i+ZCo2Br7/iKcVDFW0fHxWYWWX6bwZUGS3
         FU33fbT5KLTMgA1yTOkpvpXNdDfyh+N7reglegYeqe1uk8LREWpLK9DWyyoM2IurqFvs
         FklKHKam4Rkql9yJ5L7uo4yboCPkii6/B41AWGxNCXqFOF9r2eIjB90OCemAv+Ptvlbh
         d+3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4TCgYr5ncOjL+8eCE97Mxvf9/nlILupNJJJIRFrFPFw=;
        b=e6suy8K4RfzJ/VnpJWYyH4q3+bDzswQmmO9lY30JLaGV+1FUozP9C0AfFpa8GPM7WB
         WBTaysjNNjQXLjBJy/xznw7QnhOAdAc1aLV777EvIDjljjIAeZ3v/hQpJdHo1ehqGOZF
         owlvFhWz6W6jBsTHfxAifytkaqfeWD6HxnVsrwqL7uDnx4wdMdaZK+S9/1afZLwgzWqC
         G0unUPkd0v7mYvvj6O0wKdIm9F7IPwC7NNrggi46qjkOOoVUe1lYQ5DNkRI2mQi07bzM
         J+OClm5S2q+I8a9b0ZMSWG4Oj+rG+XmauCbok9zOz6t2OEMXNMsh2WzSJzIt5FGXpbrR
         Gz2A==
X-Gm-Message-State: AOAM532+3j9qYlLJWO7Kti2ybw5hbYaA/lM9nxU6V2C73dGeqt27/J+6
        j9JDOhKR7GT+F6MiWPMJIh8=
X-Google-Smtp-Source: ABdhPJxHw1Z+bTsmuQRlhAKQ79sZNlRFyo7Y4G4qgoPJmPxXqEeY/KJflmEw43bSJSSmP3lZjsUBow==
X-Received: by 2002:a63:60e:: with SMTP id 14mr5582133pgg.343.1599192253444;
        Thu, 03 Sep 2020 21:04:13 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y3sm3991853pjg.8.2020.09.03.21.04.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2020 21:04:12 -0700 (PDT)
Subject: Re: [PATCH net-next 0/3] net: phy: Support enabling clocks prior to
 bus probe
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, adam.rudzinski@arf.net.pl, m.felsch@pengutronix.de,
        hkallweit1@gmail.com, richard.leitner@skidata.com,
        zhengdejin5@gmail.com, devicetree@vger.kernel.org,
        kernel@pengutronix.de, kuba@kernel.org, robh+dt@kernel.org
References: <20200903043947.3272453-1-f.fainelli@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <cc6fc0f6-d4ae-9fa1-052d-6ab8e00ab32f@gmail.com>
Date:   Thu, 3 Sep 2020 21:04:11 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200903043947.3272453-1-f.fainelli@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/2/2020 9:39 PM, Florian Fainelli wrote:
> Hi all,
> 
> This patch series takes care of enabling the Ethernet PHY clocks in
> DT-based systems (we have no way to do it for ACPI, and ACPI would
> likely keep all of this hardware enabled anyway).
> 
> Please test on your respective platforms, mine still seems to have
> a race condition that I am tracking down as it looks like we are not
> waiting long enough post clock enable.
> 
> The check on the clock reference count is necessary to avoid an
> artificial bump of the clock reference count and to support the unbind
> -> bind of the PHY driver. We could solve it in different ways.
> 
> Comments and test results welcome!

Andrew, while we figure out a proper way to support this with the Linux 
device driver model, would you be opposed in a single patch to 
drivers/net/mdio/mdio-bcm-unimac.c which takes care of enabling the 
PHY's clock during bus->reset just for the sake of getting those systems 
to work, and later on we move over to the pre-probe mechanism?

That would allow me to continue working with upstream kernels on these 
systems without carrying a big pile of patches.
-- 
Florian
