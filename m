Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3AA522A2B9
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 00:54:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732711AbgGVWyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 18:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729198AbgGVWyf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 18:54:35 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB7DC0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 15:54:35 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id o2so3489587wmh.2
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 15:54:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XNPnTzo3blFH15pI28E+lW2upB3Tc2XsH5nZ2kuCq+o=;
        b=NAE+Vv81WGyB9akNTvy0rgsphI5DZbocS3P+nnh2pzYfspv/khv/Bp4BNfmNA+khnD
         UiCg0AMkrQPuaP/VZJrdgMgx8UodX3IKgQfAoWlKJTacz3yAIKZo0ztl6XTF1FOtakI8
         qAlTHfhvDYZbLGncYJLMH8wFWeFDC8HkF87VXmTm2u2sXvjmUp4WkWO/kn3bnPv332mx
         frMrV2DcGvCg9Q/99b/6thPyKNZXvw9ofMPjSQT6ZfC74w1ufURtn5lAjxprg4zPkaAo
         EmCVgVmufeNOG6T8ohwYol8pkwVGT4dL0mZj9OZknz2BwayIktZQ2+GwdZ9jcF9LrMeS
         vPPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=XNPnTzo3blFH15pI28E+lW2upB3Tc2XsH5nZ2kuCq+o=;
        b=gCRQ3uDYfdFAvKpTZ6xposBdbeTbL2wBkWS2sMNpIQfTiClR5sePEWbSoQ4CCvHrkW
         Zl2/9kozxGge6evoUd9A5NGS5wQvmdFO96DMYvA9g8AcfWHBoWZwcjtRBTW/bthwIyie
         ilAy86a3Z256EzsyItn2bcYfLPlIdKNX2vrmKL5yF4zn1D1ClcH7hX5uuJVWQEJB4kGe
         S9ndxrP1dKPqNopgiAOV1CBQPMAhwJL/9V76JOJfqNsToA7Cbc2JsPqY2hnd0W6mft5W
         WjJPPlTl/l2mXcbC8cVLezZxzPxSzQItoyxVydZfeY5kpjRJunHz/4pM77eXrXlnT6uw
         90Iw==
X-Gm-Message-State: AOAM533pUEXBGne63bjox8SLIDEKhWskKhS/KqeQT40OkT4aGG4P9Ba+
        MAZcNyQo2XyZyh6g+Axp0vE=
X-Google-Smtp-Source: ABdhPJzdH4el7uo0eeoQT0N5zfdEYB9f9Fz/r5bGFJROeejRiRX9VXiPk1WmggivKfCh8FhxUKuWZw==
X-Received: by 2002:a1c:6106:: with SMTP id v6mr1487697wmb.178.1595458473989;
        Wed, 22 Jul 2020 15:54:33 -0700 (PDT)
Received: from [10.67.50.75] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id y77sm1254594wmd.36.2020.07.22.15.54.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2020 15:54:33 -0700 (PDT)
Subject: Re: [PATCH net-next] net: dsa: stop overriding master's
 ndo_get_phys_port_name
To:     Vladimir Oltean <olteanv@gmail.com>, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, jiri@mellanox.com,
        edumazet@google.com, ap420073@gmail.com, xiyou.wangcong@gmail.com,
        maximmi@mellanox.com, mkubecek@suse.cz, richardcochran@gmail.com
References: <20200722224312.2719813-1-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <a6856cd0-f790-42fa-b99c-fd6ba0408cc0@gmail.com>
Date:   Wed, 22 Jul 2020 15:54:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200722224312.2719813-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/22/20 3:43 PM, Vladimir Oltean wrote:
> The purpose of this override is to give the user an indication of what
> the number of the CPU port is (in DSA, the CPU port is a hardware
> implementation detail and not a network interface capable of traffic).
> 
> However, it has always failed (by design) at providing this information
> to the user in a reliable fashion.
> 
> Prior to commit 3369afba1e46 ("net: Call into DSA netdevice_ops
> wrappers"), the behavior was to only override this callback if it was
> not provided by the DSA master.
> 
> That was its first failure: if the DSA master itself was a DSA port or a
> switchdev, then the user would not see the number of the CPU port in
> /sys/class/net/eth0/phys_port_name, but the number of the DSA master
> port within its respective physical switch.
> 
> But that was actually ok in a way. The commit mentioned above changed
> that behavior, and now overrides the master's ndo_get_phys_port_name
> unconditionally. That comes with problems of its own, which are worse in
> a way.
> 
> The idea is that it's typical for switchdev users to have udev rules for
> consistent interface naming. These are based, among other things, on
> the phys_port_name attribute. If we let the DSA switch at the bottom
> to start randomly overriding ndo_get_phys_port_name with its own CPU
> port, we basically lose any predictability in interface naming, or even
> uniqueness, for that matter.
> 
> So, there are reasons to let DSA override the master's callback (to
> provide a consistent interface, a number which has a clear meaning and
> must not be interpreted according to context), and there are reasons to
> not let DSA override it (it breaks udev matching for the DSA master).
> 
> But, there is an alternative method for users to retrieve the number of
> the CPU port of each DSA switch in the system:
> 
>   $ devlink port
>   pci/0000:00:00.5/0: type eth netdev swp0 flavour physical port 0
>   pci/0000:00:00.5/2: type eth netdev swp2 flavour physical port 2
>   pci/0000:00:00.5/4: type notset flavour cpu port 4
>   spi/spi2.0/0: type eth netdev sw0p0 flavour physical port 0
>   spi/spi2.0/1: type eth netdev sw0p1 flavour physical port 1
>   spi/spi2.0/2: type eth netdev sw0p2 flavour physical port 2
>   spi/spi2.0/4: type notset flavour cpu port 4
>   spi/spi2.1/0: type eth netdev sw1p0 flavour physical port 0
>   spi/spi2.1/1: type eth netdev sw1p1 flavour physical port 1
>   spi/spi2.1/2: type eth netdev sw1p2 flavour physical port 2
>   spi/spi2.1/3: type eth netdev sw1p3 flavour physical port 3
>   spi/spi2.1/4: type notset flavour cpu port 4
> 
> So remove this duplicated, unreliable and troublesome method. From this
> patch on, the phys_port_name attribute of the DSA master will only
> contain information about itself (if at all). If the users need reliable
> information about the CPU port they're probably using devlink anyway.
> 
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Acked-by: florian Fainelli <f.fainelli@gmail.com>

Thanks
-- 
Florian
