Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 314242624B7
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 04:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728463AbgIICCh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 22:02:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726489AbgIICCg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 22:02:36 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C6FC061573;
        Tue,  8 Sep 2020 19:02:35 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id l191so896164pgd.5;
        Tue, 08 Sep 2020 19:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FENKYd7gG4l5D+EsL5UZvuCgItXppeJ5z3Kb6CaxrH8=;
        b=O1lpFdjxh59Bfoqb4FlBwn6Dq8U+SMXbBqWRISScyc0DsUGCl7mzw+lRNFSn/FjIlG
         ii/khcfQDcJQ3AEnU3tOPQug2ocN4rJFdU26wmFcoz02sESMoM0BZxp1qrwWxpzqvtYP
         /BkF/UYfK+eDvrwiqe4nXXixI3AwvkXAax/Et61PnZhopn8y4YXcRojv5oW05r/RNR9U
         zx0Mfgvc/KdakH/ILNzOrjzZjSnWotu5+zJgAW5T6GCxo0rAJCkP1pAQ3EIL9cYTTotY
         zXgTf+LZgMMYQ48zRcLn4EK6H/DriBZsLp67rRs+CrCmcJnmNObVyH3DCzcn83eg39Iq
         mRAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FENKYd7gG4l5D+EsL5UZvuCgItXppeJ5z3Kb6CaxrH8=;
        b=maADnsyXOHCEo9AcuGjl9ceVW0BGfx7n8NTwP7RGMhOsGMiE4mbcAQqO6MZRkLue8G
         SbfZ1LFNeMKalv0k7sXNUtr10akpV/Uf4pjD/kWLu/fMxJjewoYM3X8uejyrUdc4q81v
         BSsOX26+FRZykPx6HygDFn1rCgd+qQpXCT6ZOZboZU1A3YTcCXVudwMtgq1kb3HIkup8
         cVF0xtkGVj9rkvs1qHNoYyU0ZcBJJaYF56VG6a4QFIJXmwFFA0MO1Hp54HRIJQe8cg4u
         q73QBfMt6PiTX3Ab2GFDDMtTAxDrSjpZaUhSyiLpgsikb0JL1GvfYS/Apsj9Pb9cZ8ZK
         OmMg==
X-Gm-Message-State: AOAM530ZJzoePbiKdwgZ1McG5mRdKHJhCEFFX8D4mBLWR8e5XddVc9eS
        pOnAnHJJDrX9CcZJd4RK79nx3Q6WGDw=
X-Google-Smtp-Source: ABdhPJw/1cqx6OjdcI8CknXPtkM8JS/MdJCmpABG15hyBrGljmto6uylclSImDOH5Shs55OS7cP0qQ==
X-Received: by 2002:a17:902:b409:b029:d0:cbe1:e771 with SMTP id x9-20020a170902b409b02900d0cbe1e771mr1933870plr.24.1599616954743;
        Tue, 08 Sep 2020 19:02:34 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d1sm398792pjs.17.2020.09.08.19.02.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 19:02:34 -0700 (PDT)
Subject: Re: [PATCH v2 4/5] net: phy: smsc: LAN8710/20: add phy refclk in
 support
To:     Marco Felsch <m.felsch@pengutronix.de>, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, zhengdejin5@gmail.com,
        richard.leitner@skidata.com
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de,
        devicetree@vger.kernel.org
References: <20200908112520.3439-1-m.felsch@pengutronix.de>
 <20200908112520.3439-5-m.felsch@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <3fc73707-1cff-f42f-c96d-dc522bef61e5@gmail.com>
Date:   Tue, 8 Sep 2020 19:02:32 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <20200908112520.3439-5-m.felsch@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/8/2020 4:25 AM, Marco Felsch wrote:
> Add support to specify the clock provider for the phy refclk and don't
> rely on 'magic' host clock setup. Commit [1] tried to address this by
> introducing a flag and fixing the corresponding host. But this commit
> breaks the IRQ support since the irq setup during .config_intr() is
> thrown away because the reset comes from the side without respecting the
> current phy-state within the phy-state-machine. Furthermore the commit
> fixed the problem only for FEC based hosts other hosts acting like the
> FEC are not covered.
> 
> This commit goes the other way around to address the bug fixed by [1].
> Instead of resetting the device from the side every time the refclk gets
> (re-)enabled it requests and enables the clock till the device gets
> removed. The phy is still rest but now within the phylib and  with
> respect to the phy-state-machine.

s/rest/reset/
s/phy/PHY/
s/phy-state-machine/PHY library state machine/

(this applies to patch #5 as well)

With those things corrected:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
