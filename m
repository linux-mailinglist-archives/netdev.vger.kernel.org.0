Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61462467E39
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 20:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382866AbhLCTbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 14:31:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353754AbhLCTbs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 14:31:48 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 890F8C061751
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 11:28:24 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id j11so4062464pgs.2
        for <netdev@vger.kernel.org>; Fri, 03 Dec 2021 11:28:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5S5853k42uXZjV8eaZIJnApuzbcHKh8Czh7npFjs4G0=;
        b=kILReFYj6I116+O2qox3nb29Phg5Eh+N9EaJ2BlmtUYgZw+GOLK51PpLs2ypJrbYSZ
         3aCc2/A+lEpoTTBw5DkrR2HoHAGXkwihHUtL/ifHag8/h9G4H+kYsQDMlQcpToGU/2mN
         tyORCq7OPrEXFRhe8kFw6q838XBp4lvL3xwDmVaoYGzr+iCqS38gu12yJoqS9Fbid696
         AOkO3WK3BN3oIeKhZc/W4KKFwUL87Y+WPMU7Inj7wbeH95WJRvonnaOK3Zl19oUogk3P
         j2cmLadeM5otmVMZwoLfYWTCA/xMTq8c1W99j9rTnv0LKKySbaW2uS2InRKG3zlyvjVF
         ppUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5S5853k42uXZjV8eaZIJnApuzbcHKh8Czh7npFjs4G0=;
        b=OAjZ/aXRja7/DdqTuMecBXpthCwl/01SPvZUr+A89wKL6+QfygHb9EsP0Eia8r80oT
         ZcjWQmGwec0JkDzgmMP/EgV++QWKkKuXRwrNTWqWGxcelfGXnIDhD/oRVtQ1++0cwWJm
         PfY7t5NAAnqRATnzvVivFjSWDow1szFQHJ2Kzi2euH0q2Vf3srTG/sWyVGU+VeHOftYF
         BpqWeCylJ23rfuNu5UKa0bVUFv3NWIKks0NHwKKIuZKz78cZgNNk6y7COnQl2oW3hiCh
         SSyT3K+4SaV6WSzOE9al95hJf/UtLkCN9L5M0sJwgznYFKA39KxF80D636TTMB374Egg
         jlsA==
X-Gm-Message-State: AOAM531gE/HyRS/zLO7VQiheYBTLwP+0vAq42z8afaI3ZEJHFmW6oyh7
        7TX2tKV/UVKsCo7Apt2AzgY=
X-Google-Smtp-Source: ABdhPJxFaDo9qEIkxJaib0UqJswia5AZVex/vBEC4BOc53TtTEwwfS9LbDu5+OmSn5pmtazocd/nKA==
X-Received: by 2002:a63:4e1c:: with SMTP id c28mr2966693pgb.318.1638559704078;
        Fri, 03 Dec 2021 11:28:24 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b1sm3124879pgk.37.2021.12.03.11.28.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Dec 2021 11:28:23 -0800 (PST)
Subject: Re: [PATCH RFC net-next 00/12] Allow DSA drivers to set all phylink
 capabilities
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        George McCollister <george.mccollister@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
References: <YZ56WapOaVpUbRuT@shell.armlinux.org.uk>
 <YapCthCbtjXpab6v@shell.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <0e6553bb-e188-d7aa-7e58-2c872faa41df@gmail.com>
Date:   Fri, 3 Dec 2021 11:28:22 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YapCthCbtjXpab6v@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/3/21 8:15 AM, Russell King (Oracle) wrote:
> On Wed, Nov 24, 2021 at 05:46:01PM +0000, Russell King (Oracle) wrote:
>> During the last cycle, I introduced a phylink_get_interfaces() method
>> for DSA drivers to be able to fill out the supported_interfaces member
>> of phylink_config. However, further phylink development allowing the
>> validation hook to be greatly simplified became possible when a bitmask
>> of MAC capabilities is used along with the supported_interfaces bitmap.
> ...
> 
> Hi all,
> 
> Patches 1 through 3, 6 and 8 have been merged, the rest have not.
> Getting patches 4, 5, 7, 10 and 12 tested and reviewed would be great
> please. These are ar9331, bcm_sf2, ksz8795, qca8k and xrs700x. Thanks!

Do you have a re-based version that does not conflict with what is
currently in net-next?
-- 
Florian
