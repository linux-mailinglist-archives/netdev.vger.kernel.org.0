Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE4692E0F7E
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 21:49:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbgLVUrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 15:47:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbgLVUrj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 15:47:39 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0944FC0613D3;
        Tue, 22 Dec 2020 12:46:59 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id i24so14185366edj.8;
        Tue, 22 Dec 2020 12:46:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=e7CXBCcrPKIQsc3r8jYzWjstSIIKZ5ePIODHJXTON8o=;
        b=PgLKPYpZotcmlM54p4+vEvRXDPGAM4sLUieycdmuLoGsRbJQSiQz5tuXYNnwDHhWSC
         mk6stdUrbkJUPukEz1Vmc7RLimb2bEfXVifjKhB4GEvdDHjLIAfsnmO2aA/fvemnFfd7
         Igvz92uupbPZT3YbiYnlsUzFNWYOMe/Q1iHM8nFj0YbCHXn+bJeCPJjePUHJd/AcVEw7
         tSh3f8KBNQcEUJPju252bFTbSMgwV9hx0DNTsM1umQ5J/Qv/2indThVo9SqufA705+c4
         OfZoBp3YjRxZkB3fe+C3t3OLHu9oLdQsdYzTwT97fFAqg6fN3MotjtjSDvHrq3vX9PL5
         ePaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=e7CXBCcrPKIQsc3r8jYzWjstSIIKZ5ePIODHJXTON8o=;
        b=VR2xsBwzmoy9RDJFcovU7I3+YjXInYECPMVlkzHFcslnZhDNHIUP6EC2x/Ski8yznY
         RmLkwn68m7D0KuPIC6RTqDbUgrRd/u4NEGeQf2ZTpqEP+as587KQB2XOj0ip7A/OJWpf
         JtAaR/tvcCcm3eMUNIy2el9GgD5npyh4JeGYbJf+B+pSz1qPP3BrJp0e4ved+HeXpnr6
         NiQgABzmH0Hb1h7WW3WLT87gn1NTNFz6vPjeJvRfhqVSkg2cN4SdC2pl7zw2tfv89LCI
         v6wr/n4A+mdgInbRdJQyAhFtQm3XHSFmgfasATkNH878FYDhB0t6nVWrLJubeB0rjqxM
         vMtQ==
X-Gm-Message-State: AOAM5319E45EUIQk2agtU4YjlZERTQ7DiG2DPeF91Ym7+Q+oU99DN5nA
        Os+56dcrKqHarVxAvVm9X21FoSMMSTQ=
X-Google-Smtp-Source: ABdhPJzdZW1LjSMBcunMTun0V0jqEQJGgdpP+1uUJK5SmYQ6MR8bNwz0NDm+Za4eCy48lbT+riDXDA==
X-Received: by 2002:a05:6402:45:: with SMTP id f5mr21793304edu.273.1608670017538;
        Tue, 22 Dec 2020 12:46:57 -0800 (PST)
Received: from ?IPv6:2003:ea:8f06:5500:dc3c:aa51:b1e8:8e1d? (p200300ea8f065500dc3caa51b1e88e1d.dip0.t-ipconnect.de. [2003:ea:8f06:5500:dc3c:aa51:b1e8:8e1d])
        by smtp.googlemail.com with ESMTPSA id v18sm29819463edx.30.2020.12.22.12.46.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Dec 2020 12:46:56 -0800 (PST)
Subject: Re: [Aspeed, v2 2/2] net: ftgmac100: Change the order of getting MAC
 address
To:     Hongwei Zhang <hongweiz@ami.com>, linux-aspeed@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, openbmc@lists.ozlabs.org,
        Jakub Kicinski <kuba@kernel.org>,
        David S Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>
References: <20201221205157.31501-2-hongweiz@ami.com>
 <20201222201437.5588-3-hongweiz@ami.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <96c355a2-ab7e-3cf0-57e7-16369da78035@gmail.com>
Date:   Tue, 22 Dec 2020 21:46:52 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201222201437.5588-3-hongweiz@ami.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22.12.2020 21:14, Hongwei Zhang wrote:
> Dear Reviewer,
> 
> Use native MAC address is preferred over other choices, thus change the order
> of reading MAC address, try to read it from MAC chip first, if it's not
>  availabe, then try to read it from device tree.
> 
> 
> Hi Heiner,
> 
>> From:	Heiner Kallweit <hkallweit1@gmail.com>
>> Sent:	Monday, December 21, 2020 4:37 PM
>>> Change the order of reading MAC address, try to read it from MAC chip 
>>> first, if it's not availabe, then try to read it from device tree.
>>>
>> This commit message leaves a number of questions. It seems the change isn't related at all to the 
>> change that it's supposed to fix.
>>
>> - What is the issue that you're trying to fix?
>> - And what is wrong with the original change?
> 
> There is no bug or something wrong with the original code. This patch is for
> improving the code. We thought if the native MAC address is available, then
> it's preferred over MAC address from dts (assuming both sources are available).
> 
> One possible scenario, a MAC address is set in dts and the BMC image is 
> compiled and loaded into more than one platform, then the platforms will
> have network issue due to the same MAC address they read.
> 

Typically the DTS MAC address is overwritten by the boot loader, e.g. uboot.
And the boot loader can read it from chip registers. There are more drivers
trying to read the MAC address from DTS first. Eventually, I think, the code
here will read the same MAC address from chip registers as uboot did before.

> Thanks for your review, I've update the patch to fix the comments.
>>
>>> Fixes: 35c54922dc97 ("ARM: dts: tacoma: Add reserved memory for 
>>> ramoops")
>>> Signed-off-by: Hongwei Zhang <hongweiz@ami.com>
>>> ---
>>>  drivers/net/ethernet/faraday/ftgmac100.c | 22 +++++++++++++---------
>>>  1 file changed, 13 insertions(+), 9 deletions(-)
> 
> --Hongwei
> 

