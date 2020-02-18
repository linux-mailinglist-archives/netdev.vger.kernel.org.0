Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60ABD16334F
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 21:45:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbgBRUp3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 15:45:29 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:38822 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726749AbgBRUp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 15:45:29 -0500
Received: by mail-wr1-f65.google.com with SMTP id e8so3121938wrm.5
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 12:45:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9ixEW/yQSa0+088NDX2c8r5t4a2xLLaeDIbMmiTykWE=;
        b=lN4TQwKPv6lo4AphhPQK5uxIXGcOYsDV9YuAerTuo8ZRTgXDWY2VlcuABED+zbvxqw
         UyQoP0uKn45dQmokgqnFAAGYd2pnPSZPpyG1+GGwNEdik84IT3QlTC9otwHnd/WAhi1e
         sD0nTtD8hx43eePl9FAVu8asieCOKeTemAnFVs4VvIbL1oaM5MNVVPtMMSlAwdbaQ7wc
         QzjQtIiL7d1hn1EyK37wllSsj3dooIyrGMUegE5DYEEBlq7ymQ8sEHHSC+qpdVHidlEg
         iX/o6QCvs2LWE7HQUrQAzZ8fjynhGLlGsddpXiLe0RsygYbQeE04aQdiGXbdfC4lC6ra
         ZGEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9ixEW/yQSa0+088NDX2c8r5t4a2xLLaeDIbMmiTykWE=;
        b=Lq22/E4NUYyvF1DmD1lC7lys/LUl/KYBGgKLmZjc5O8YunpfBLxORCsUldfWZZ9DKR
         ZAyXq/nJgJNJZY6TnHe2kzrlaGKHEuNHhqZQyzDnOtEBASQVJk/x22X/RRqM3gzMrcmh
         UvX8wU5GVsCGClb0HlA5MNypQap+AQxHUv7XZIhvWVUQW8uMh9DlSIrwBuMZ8q/eVO79
         pGhuPwhT94MFQF+cfesTUhTV5RzlBaXLxwVTmH3BpgK00nLqrqWsZPemAVfu7YT1qbS4
         rmVGekDVOL9yQrGefgtytDTkSZyUSCMiPFp6E7OixzUbFc7BvuHAK4/OPqFShPOpHfBp
         L9lA==
X-Gm-Message-State: APjAAAVGTbHVa/vRR45TkMJlnbfytaelFUnuLeVVannMFTwdhUgwN2om
        FMsLnI5pndmDefbtGO7EvnboWWWk
X-Google-Smtp-Source: APXvYqwtRyg4aPpMPcLanCN/DFMw0UjfWaZhpWBXBlWRDVpl+OwSixawPn4wv1M1SML5FDNJYMLHAg==
X-Received: by 2002:adf:f7c6:: with SMTP id a6mr32518365wrq.164.1582058727599;
        Tue, 18 Feb 2020 12:45:27 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:b126:7979:20d5:8ec3? (p200300EA8F296000B126797920D58EC3.dip0.t-ipconnect.de. [2003:ea:8f29:6000:b126:7979:20d5:8ec3])
        by smtp.googlemail.com with ESMTPSA id s8sm7568811wrt.57.2020.02.18.12.45.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 12:45:27 -0800 (PST)
Subject: Re: [PATCH net-next] phy: avoid unnecessary link-up delay in polling
 mode
To:     Petr Oros <poros@redhat.com>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, ivecera@redhat.com
References: <20200129101308.74185-1-poros@redhat.com>
 <20200218093555.948922-1-poros@redhat.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <6112f44d-488a-0aed-1b60-f8cd1a3ca39e@gmail.com>
Date:   Tue, 18 Feb 2020 21:45:20 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200218093555.948922-1-poros@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18.02.2020 10:35, Petr Oros wrote:
> commit 93c0970493c71f ("net: phy: consider latched link-down status in
> polling mode") removed double-read of latched link-state register for
> polling mode from genphy_update_link(). This added extra ~1s delay into
> sequence link down->up.
> Following scenario:
>  - After boot link goes up
>  - phy_start() is called triggering an aneg restart, hence link goes
>    down and link-down info is latched.
>  - After aneg has finished link goes up. In phy_state_machine is checked
>    link state but it is latched "link is down". The state machine is
>    scheduled after one second and there is detected "link is up". This
>    extra delay can be avoided when we keep link-state register double read
>    in case when link was down previously.
> 
> With this solution we don't miss a link-down event in polling mode and
> link-up is faster.
> 
> Details about this quirky behavior on Realtek phy:
> Without patch:
> T0:    aneg is started, link goes down, link-down status is latched
> T0+3s: state machine runs, up-to-date link-down is read
> T0+4s: state machine runs, aneg is finished (BMSR_ANEGCOMPLETE==1),
>        here i read link-down (BMSR_LSTATUS==0),
> T0+5s: state machine runs, aneg is finished (BMSR_ANEGCOMPLETE==1),
>        up-to-date link-up is read (BMSR_LSTATUS==1),
>        phydev->link goes up, state change PHY_NOLINK to PHY_RUNNING
> 
> With patch:
> T0:    aneg is started, link goes down, link-down status is latched
> T0+3s: state machine runs, up-to-date link-down is read
> T0+4s: state machine runs, aneg is finished (BMSR_ANEGCOMPLETE==1),
>        first BMSR read: BMSR_ANEGCOMPLETE==1 and BMSR_LSTATUS==0,
>        second BMSR read: BMSR_ANEGCOMPLETE==1 and BMSR_LSTATUS==1,
>        phydev->link goes up, state change PHY_NOLINK to PHY_RUNNING
> 
> Signed-off-by: Petr Oros <poros@redhat.com>
> ---
Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>
