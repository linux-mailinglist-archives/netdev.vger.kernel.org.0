Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 621FD41E286
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 22:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbhI3UIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 16:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229745AbhI3UIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 16:08:39 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE34DC06176A;
        Thu, 30 Sep 2021 13:06:56 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id w14so5999500pfu.2;
        Thu, 30 Sep 2021 13:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tTFNeDhUCqsCQPdfmfobEGyhRBcv+rXikwCLY2+HbPM=;
        b=Ncjj/E2NpB7nXKDshwW4YIDuCFe21MWKjsu2RmuxKIdP1bO701qaUF+os6g8/gXlMx
         BHJpq7BKrJkYUheUKfP3UTJw5dtUHweBgMUx5x/23SUyVf2nK2EGAWiTZh0qzV7U81wu
         Z6QfSASf/+ylVX9vTa79DA2Zpv5pegleRjPmr7gVOOHR5yZUKssVwSHVbsnCv79xLZyW
         FB4QKhHeY8kWwxEbaXIznTyldDNtQGLc9/IBjRUQPn/p+tQJoAVVEIpb93HMZJrqqVPg
         g9k3L9n5ZUJ8XZPcm+pPFymKDPrH8JSXgkT79/P25Qi5ihydDB1535AzhJwjboWi+9Mk
         s8PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tTFNeDhUCqsCQPdfmfobEGyhRBcv+rXikwCLY2+HbPM=;
        b=MGvbaHeABYHGnUYVFABkFuKfm4CGYLO28xWdty5V5HvcU58NMKkyt2jbBgk5L8DSsI
         1/uUo+8QN1Uyo3cm8AbdK9jV91DQ7NmrL7hTvKWrKx0AoARKaDcfI0G4qO3cVuAX9mld
         xCdxrF2LsjD3oni8umL/ma8CCw5d6d48eFIzkBp0Pr16W5RwLDijlOVAqbI4GNF/xmPt
         IUOwypudB8nt891CBIUlKXdn9cbm9rECMM4HLXT/SdJJfKMJW566qgFZrWK1cVGtlX/r
         o6CBhZmOj53gYYqyjTo36XxVzE8k6z9ky3a1olmhNAbYFN2hIafnfxWeOU8CM/fGt2fN
         9tmA==
X-Gm-Message-State: AOAM533h4T2T7d7pPEXOv+kZGxyTP7gNRQO0IlwjhtsBPFFSg+MGHmk4
        mrMLqnBtwupXWvlpScBYwtmoE4jkf+I=
X-Google-Smtp-Source: ABdhPJyv4s1LC/IRx8+kWuRXtSflmg9oBrLauRKqyXMKoHCCNIYuumroV6vVvJ8yjYRjxnCvTmYCcQ==
X-Received: by 2002:a63:9a01:: with SMTP id o1mr6420594pge.441.1633032415775;
        Thu, 30 Sep 2021 13:06:55 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id r2sm4026192pgn.8.2021.09.30.13.06.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Sep 2021 13:06:54 -0700 (PDT)
Subject: Re: [PATCH v1 1/2] driver core: fw_devlink: Add support for
 FWNODE_FLAG_BROKEN_PARENT
To:     Saravana Kannan <saravanak@google.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Alvin Sipraga <ALSI@bang-olufsen.dk>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
References: <YS4rw7NQcpRmkO/K@lunn.ch>
 <CAGETcx_QPh=ppHzBdM2_TYZz3o+O7Ab9-JSY52Yz1--iLnykxA@mail.gmail.com>
 <YS6nxLp5TYCK+mJP@lunn.ch>
 <CAGETcx90dOkw+Yp5ZRNqQq2Ny_ToOKvGJNpvyRohaRQi=SQxhw@mail.gmail.com>
 <YS608fdIhH4+qJsn@lunn.ch> <20210831231804.zozyenear45ljemd@skbuf>
 <CAGETcx8MXzFhhxom3u2MXw8XA-uUtm9XGEbYNobfr+Ptq5+fVQ@mail.gmail.com>
 <20210930134343.ztq3hgianm34dvqb@skbuf> <YVXDAQc6RMvDjjFu@lunn.ch>
 <CAGETcx8emDg1rojU=_rrQJ3ezpx=wTukFdbBV-uXiu1EQ87=wQ@mail.gmail.com>
 <YVYSMMMkmHQn6n2+@lunn.ch>
 <CAGETcx-L7zhfd72+aRmapb=nAbbFGR5NX0aFK-V9K1WT4ubohA@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <cb193c3d-e75d-3b1e-f3f4-0dcd1e982407@gmail.com>
Date:   Thu, 30 Sep 2021 13:06:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CAGETcx-L7zhfd72+aRmapb=nAbbFGR5NX0aFK-V9K1WT4ubohA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/30/21 12:48 PM, Saravana Kannan wrote:
> On Thu, Sep 30, 2021 at 12:38 PM Andrew Lunn <andrew@lunn.ch> wrote:
>>
>>> Btw, do we have non-DSA networking devices where fw_devlink=on
>>> delaying PHY probes is causing an issue?
>>
>> I don't know if issues have been reported, but the realtek driver has
>> had problems in the past when the generic driver is used. Take a look
>> at r8169_mdio_register(), it does something similar to DSA.
> 
> Does it have the issue of having the PHY as its child too and then
> depending on it to bind to a driver? I can't tell because I didn't
> know how to find that info for a PCI device.

Yes, r8169 includes a MDIO bus controller, and the PHY is internal to
the Ethernet MAC. These are AFAIR the relevant changes to this discussion:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=16983507742cbcaa5592af530872a82e82fb9c51
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=11287b693d03830010356339e4ceddf47dee34fa


> 
>>
>> What is going to make things interesting is that phy_attach_direct()
>> is called in two different contexts. During the MAC drivers probe, it
>> is O.K. to return EPROBE_DEFER, and let the MAC driver try again
>> later, if we know there is a specific PHY driver for it. But when
>> called during the MAC drivers open() op, -EPROBE_DEFER is not
>> allowed. What to do then is an interesting question.
> 
> Yeah, basically before doing an open() it'll have to call an API to
> say "just bind with whatever you got". Or something along those lines.
> I already know how to get that to work. I'll send some RFC soonish (I
> hope).

I don't think this is going to scale, we have dozens and dozens of
drivers that connect to the PHY during ndo_open(). It is not realistic
to audit them all, just like the opposite case where the drivers do
probe MDIO/PHY during their .probe() call is not realistic either.
-- 
Florian
