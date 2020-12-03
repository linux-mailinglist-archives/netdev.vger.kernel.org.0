Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB0112CCD6B
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 04:43:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728828AbgLCDnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 22:43:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726938AbgLCDnX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 22:43:23 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73EB8C061A4E
        for <netdev@vger.kernel.org>; Wed,  2 Dec 2020 19:42:43 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id q22so381594pfk.12
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 19:42:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=5yONYZNRF5XoJh3n6zu119emm5To6PBp7rJCOs0a2MI=;
        b=PiiLc3e5PbBRSr+Xjl1bCjkWF94R2DNWBUH1id+tQSEe5G6ANOF0KcAKSCQApAl1p9
         LinNnbKQwcEfyPfs1HFxJdiwhuCf1D1bcwlQl54nY2OuPSwP3HOLW6AyiJpOs0qUXig5
         r+r/VU8SofJLFALsWleNJXtIaESghHzDDfTY7ktX3HR9GEc22HA0GrE42OBQHo3vdbrj
         6yOEiFxm6vV9/WP6APU5ZBUBrC0qTdlueuACnIN4v6U+W8/Sh+d3y5KVGptf2KFJz9W/
         UlPjL4MQO40W6plyFYGkR2egY20KBv1kzS6NrLqsifHnBhPBXlNIo91EHwiBHUsCYZF8
         dyrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5yONYZNRF5XoJh3n6zu119emm5To6PBp7rJCOs0a2MI=;
        b=pCsiUgiPGVCP93zueCZCDj0OCfu2uUjOMaxw3rrfiApb/lgF4rR2vuH8YgkZrh555r
         2TJIqhDSM4KvOWrJnHRS85gLeq9saUV7a1kU4ugvUC4SnTK9GPgUI09FXLZS52nlBzDZ
         o6XF/e0km3ufpurm2P0ncCmu9xUcimZEA/yaidJLFq9MOdBu8byFGPdGeaSrosTC+aGl
         L7if76uKFshJtFIMjy77nFHLo/qm6TwCpe5rxrBZzr2040jD2D8LdmkaKUyxH+udQ4P+
         rT4ctqvcRdo5DtLYNPL0dM6YYl6XIpV0OvBr6SsPeIbvnYS12ERJ54ViT9xfcgqHoskm
         DFoQ==
X-Gm-Message-State: AOAM531QYx1xSF4OaKZ330UbQklvcPk729+HPBDqwmJbKG2H4oggwlrz
        2vJCxx1b2vJmsJ1RUrb58W8oPOcsX1w=
X-Google-Smtp-Source: ABdhPJyFcfU44Gbb/kQYd/ztL8xdYpDElCcIQEIfqxrcy4j564o9a+U7Fxbe4o0oEsjdt8MHM8L3Ig==
X-Received: by 2002:aa7:9387:0:b029:18b:42dd:41c with SMTP id t7-20020aa793870000b029018b42dd041cmr1345986pfe.60.1606966962550;
        Wed, 02 Dec 2020 19:42:42 -0800 (PST)
Received: from [10.230.28.242] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6sm487057pfb.22.2020.12.02.19.42.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Dec 2020 19:42:41 -0800 (PST)
Subject: Re: net: macb: fail when there's no PHY
To:     Grant Edwards <grant.b.edwards@gmail.com>, netdev@vger.kernel.org
References: <20170921195905.GA29873@grante>
 <66c0a032-4d20-69f1-deb4-6c65af6ec740@gmail.com>
 <CAK=1mW6Gti0QpUjirB6PfMCiQvnDjkbb56pVKkQmpCSkRU6wtA@mail.gmail.com>
 <6a9c1d4a-ed73-3074-f9fa-158c697c7bfe@gmail.com> <X8fb4zGoxcS6gFsc@grante>
 <20201202183531.GJ2324545@lunn.ch> <rq8p74$2l0$1@ciao.gmane.io>
 <20201202211134.GM2324545@lunn.ch> <rq9ki2$uqk$1@ciao.gmane.io>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <57728908-1ae3-cbe9-8721-81f06ab688b8@gmail.com>
Date:   Wed, 2 Dec 2020 19:42:40 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <rq9ki2$uqk$1@ciao.gmane.io>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/2/2020 7:03 PM, Grant Edwards wrote:
> On 2020-12-02, Andrew Lunn <andrew@lunn.ch> wrote:
> 
>>>> So it will access the MDIO bus of the PHY that is attached to the
>>>> MAC.
>>>
>>> If that's the case, wouldn't the ioctl() calls "just work" even when
>>> only the fixed-phy mdio bus and fake PHY are declared in the device
>>> tree?
>>
>> The fixed-link PHY is connected to the MAC. So the IOCTL calls will be
>> made to the fixed-link fake MDIO bus.
> 
> Ah! When you said "the PHY that is attached to the MAC" above, I
> thought you meant electrically attached to the MAC via the mdio bus.
> 
> Then how does Forian Fainelli's solution below work? Won't the first
> phy found be the fixed one, and then the ioctl() calls will use the
> fixed-link bus?

You would have to have a local hack that intercepts the macb_ioctl() and
instead of calling phylink_mii_ioctl() it would have to implement a
custom ioctl() that does what drivers/net/phy/phy.c::phy_mii_ioctl does
except the mdiobus should be pointed to the MACB MDIO bus instance and
not be derived from the phy_device instance (because that one points to
the fixed PHY).
-- 
Florian
