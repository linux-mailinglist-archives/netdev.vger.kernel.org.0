Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A914E41E320
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 23:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349156AbhI3VSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 17:18:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348216AbhI3VR4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 17:17:56 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B18C6C06176A;
        Thu, 30 Sep 2021 14:16:13 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id u7so6090137pfg.13;
        Thu, 30 Sep 2021 14:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=y1+QhfYHqCs9G09ZlmQx05Mip6CQMVkcAiMVsdJuNeA=;
        b=JkTP0NyR0rfDXoe36FCz+B2FCFlxnnsESsXH/nkwwH76avOzWqTz4kyeIBsru9Y4CL
         Gg/Uw40FbX6Hs7US77/R115tSkwR5LclkIXChzGfNM8BSrY0XUCTGRTslUaj8I9mbw1Q
         Og48KXZoCPyxHyZWA6mTdvN6eae4fqa/euS4VV4uw/8dHWjG0n0Ya/jDw3iCcOqxJ/gj
         rtxk0i9plvmh6viQFOGmIcRSMC5RH+bdjH4o6fNl9ct0QqldDrVK85mkgnmfZIz+rvZ2
         xWzd4icncFRAg9l5ABojVYIzfkyNJDSp8f+O+JDqZdyVoNv1MHwS67OP8wKqBsAuYt/2
         InwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y1+QhfYHqCs9G09ZlmQx05Mip6CQMVkcAiMVsdJuNeA=;
        b=76IzeySnXwBRpI5FbCoNfADayG1C9L7eZJIEKqgJm7CyGCV6HB5lr4jZCItTVrBx5u
         ut/97AYkcHDXcSFv+4RSV2NxilbXUfJu7MTjGTbVeHa6vuzpBTMHgTAo3WGvcdmLA9Qr
         ll8W9mRaxb4PxtE0oqy6PTicoSPUSIJvEeH0Xl1fwriC3PxnX2zNhUlYlbt866YxRw83
         JEqXFsmIB+eKuGZiTUTIcup4f4ythqeZGa1/YPpTr9Zf7eGMe9v5rKLnNrFWs1nkFEGE
         dYfGt9dxCayI1M0BQj7JzAxrFJg9xC/c1XhEteD0yLrcJ1lSy3cs7Bx+gMRW2hxmT4ME
         66kA==
X-Gm-Message-State: AOAM533zQZkpxOB5RqxEuJDaLSQyLIlRVzjjSEeTVanTCV+Cj+Ob4DLP
        7GuRJ346IxdmRyYpGnZpDhCiDEq8hKY=
X-Google-Smtp-Source: ABdhPJwMQp9cfwfgaDJF9p6tsTjsZHv3TtIvOFmC3b764c9NSEor1XNcw5E4Ps2/xzPp6issWC2tKg==
X-Received: by 2002:a63:df06:: with SMTP id u6mr6849753pgg.148.1633036572736;
        Thu, 30 Sep 2021 14:16:12 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id k14sm3953544pgg.92.2021.09.30.14.16.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Sep 2021 14:16:12 -0700 (PDT)
Subject: Re: [PATCH v1 1/2] driver core: fw_devlink: Add support for
 FWNODE_FLAG_BROKEN_PARENT
To:     Saravana Kannan <saravanak@google.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
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
 <cb193c3d-e75d-3b1e-f3f4-0dcd1e982407@gmail.com>
 <CAGETcx_G3haECnv-FS4L16PCmpfbCB3hhqHssT2E8d1fw5D3zw@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <2be871eb-d6e1-965c-d268-dc146bee54d3@gmail.com>
Date:   Thu, 30 Sep 2021 14:16:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CAGETcx_G3haECnv-FS4L16PCmpfbCB3hhqHssT2E8d1fw5D3zw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/30/21 1:14 PM, Saravana Kannan wrote:
> On Thu, Sep 30, 2021 at 1:06 PM Florian Fainelli <f.fainelli@gmail.com> wrote:
>>
>> On 9/30/21 12:48 PM, Saravana Kannan wrote:
>>> On Thu, Sep 30, 2021 at 12:38 PM Andrew Lunn <andrew@lunn.ch> wrote:
>>>>
>>>>> Btw, do we have non-DSA networking devices where fw_devlink=on
>>>>> delaying PHY probes is causing an issue?
>>>>
>>>> I don't know if issues have been reported, but the realtek driver has
>>>> had problems in the past when the generic driver is used. Take a look
>>>> at r8169_mdio_register(), it does something similar to DSA.
>>>
>>> Does it have the issue of having the PHY as its child too and then
>>> depending on it to bind to a driver? I can't tell because I didn't
>>> know how to find that info for a PCI device.
>>
>> Yes, r8169 includes a MDIO bus controller, and the PHY is internal to
>> the Ethernet MAC. These are AFAIR the relevant changes to this discussion:
>>
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=16983507742cbcaa5592af530872a82e82fb9c51
>> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=11287b693d03830010356339e4ceddf47dee34fa
>>
>>
>>>
>>>>
>>>> What is going to make things interesting is that phy_attach_direct()
>>>> is called in two different contexts. During the MAC drivers probe, it
>>>> is O.K. to return EPROBE_DEFER, and let the MAC driver try again
>>>> later, if we know there is a specific PHY driver for it. But when
>>>> called during the MAC drivers open() op, -EPROBE_DEFER is not
>>>> allowed. What to do then is an interesting question.
>>>
>>> Yeah, basically before doing an open() it'll have to call an API to
>>> say "just bind with whatever you got". Or something along those lines.
>>> I already know how to get that to work. I'll send some RFC soonish (I
>>> hope).
>>
>> I don't think this is going to scale, we have dozens and dozens of
>> drivers that connect to the PHY during ndo_open().
> 
> Whichever code calls ->ndo_open() can't that mark all the PHYs that'll
> be used as "needs to be ready now"? In any case, if we can have an API
> that allows a less greedy Generic PHY binding, we could slowly
> transition drivers over or at least move them over as they hit issues
> with Gen PHY. Anyway, I'll think discussing it over code would be
> easier. I'll also have more context as I try to make changes. So,
> let's continue this on my future RFC.

It is the same API that is being used whether you connect to the PHY at
ndo_open() time or whether you do that during the parent's ->probe()
fortunately or unfortunately. Now we could set a flag in either case,
and hope that it addresses both situations?

Being able to be selective about the Ethernet PHY driver is being used
is actually a good idea, there are plenty of systems out there whereby
using the Generic PHY driver will not lead to a functional Ethernet
link, if we could say "I want my dedicated driver, and not Generic PHY"
that would actually help some cases, too.
-- 
Florian
