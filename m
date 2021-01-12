Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97A6C2F3932
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 19:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392732AbhALSuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 13:50:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392713AbhALSuH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 13:50:07 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C41C061786
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 10:49:26 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id md11so363257pjb.0
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 10:49:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=akAZ7/GTdO4EfKY0FK6iVdgrEiYO0cBkth5hWEa2YpM=;
        b=UFYXObcaTFCDhqv5nhtpj9nctUdg6ZB+TmGZ6u6B59qjXwdN/QP7kmn472iMTsD6dt
         Iwx/eTxMdpyyxAfeujxd1AfARa2V16ZIVZyghhrVQQUVQZLUYRZ5JKlyIUcjqzdUul5T
         0FhBg47fQNpX9k0axvSS4BOT7c7PGH1t+ATjQsg09Qf2SDBbonA4zpzEhPXwMykT8zox
         W28v2w+oPrRlvybtfaFs7sWQt/20XGAgmv3xE1t4FUbalETWaRDf7WrSUZ0kiOmBJgkw
         iW4sFee4T8xkMkPZwHnrnK7bVu0OuMXSbkAHFZ5IxMWWeMMZb1XoFBvFP5wIVfY+anb2
         icFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=akAZ7/GTdO4EfKY0FK6iVdgrEiYO0cBkth5hWEa2YpM=;
        b=GWUK7Nsci++8MFgJYdctDsvUc3HqyNXmCAszLTxMpdFAUEGDllT5iD1lUMWMnDEEDz
         IaNzS14HN1yiHjoazkSAMt/DJVCaLIVcICUMTE6epciq33TMGTLpqBQj8VqcNPSXlDsV
         Q687WOMgA4qA5pEvsUtI5UoASSlt9ktIpNU5etv67hmOlH3n+apmxgRhbsA4IxSoq9aX
         hk7o2OXgCtRXuq2ZJ+t44EO+9Za+8uakiTVPMa09uqipFTY78d2iSTzgVUxlPCf7c+nt
         2DCYG+EL7tvHZaT7+n7rGUkt3aPKiEPBDkVrbeLU2BDbLDJx12kQgh0VOUCD6oFn+kEF
         2ijQ==
X-Gm-Message-State: AOAM531RJHE1OlcEiao34KFfvqMqXqZxLuNAguS9LQFM4kqa9jfb1hWi
        EBsK3bXn8e2vV1EDbTntHXg=
X-Google-Smtp-Source: ABdhPJzlHU7oKrKKA4pbN9Plk3Q2X3CEwJWsgrKiopAXl7yJhw2eQno13lMlUEbfeTVErmXBwPdyqg==
X-Received: by 2002:a17:902:b7c3:b029:da:76bc:2aa9 with SMTP id v3-20020a170902b7c3b02900da76bc2aa9mr481516plz.21.1610477366190;
        Tue, 12 Jan 2021 10:49:26 -0800 (PST)
Received: from [10.67.48.230] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id r67sm3950507pfc.82.2021.01.12.10.49.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jan 2021 10:49:25 -0800 (PST)
Subject: Re: [PATCH net] net: dsa: clear devlink port type before
 unregistering slave netdevs
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Jiri Pirko <jiri@nvidia.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com
References: <20210112004831.3778323-1-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <f2974f4e-41d0-379a-3014-39926cf011a0@gmail.com>
Date:   Tue, 12 Jan 2021 10:49:21 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210112004831.3778323-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/11/21 4:48 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Florian reported a use-after-free bug in devlink_nl_port_fill found with
> KASAN:
> 
> (devlink_nl_port_fill)
> (devlink_port_notify)
> (devlink_port_unregister)
> (dsa_switch_teardown.part.3)
> (dsa_tree_teardown_switches)
> (dsa_unregister_switch)
> (bcm_sf2_sw_remove)
> (platform_remove)
> (device_release_driver_internal)
> (device_links_unbind_consumers)
> (device_release_driver_internal)
> (device_driver_detach)
> (unbind_store)
> 
> Allocated by task 31:
>  alloc_netdev_mqs+0x5c/0x50c
>  dsa_slave_create+0x110/0x9c8
>  dsa_register_switch+0xdb0/0x13a4
>  b53_switch_register+0x47c/0x6dc
>  bcm_sf2_sw_probe+0xaa4/0xc98
>  platform_probe+0x90/0xf4
>  really_probe+0x184/0x728
>  driver_probe_device+0xa4/0x278
>  __device_attach_driver+0xe8/0x148
>  bus_for_each_drv+0x108/0x158
> 
> Freed by task 249:
>  free_netdev+0x170/0x194
>  dsa_slave_destroy+0xac/0xb0
>  dsa_port_teardown.part.2+0xa0/0xb4
>  dsa_tree_teardown_switches+0x50/0xc4
>  dsa_unregister_switch+0x124/0x250
>  bcm_sf2_sw_remove+0x98/0x13c
>  platform_remove+0x44/0x5c
>  device_release_driver_internal+0x150/0x254
>  device_links_unbind_consumers+0xf8/0x12c
>  device_release_driver_internal+0x84/0x254
>  device_driver_detach+0x30/0x34
>  unbind_store+0x90/0x134
> 
> What happens is that devlink_port_unregister emits a netlink
> DEVLINK_CMD_PORT_DEL message which associates the devlink port that is
> getting unregistered with the ifindex of its corresponding net_device.
> Only trouble is, the net_device has already been unregistered.
> 
> It looks like we can stub out the search for a corresponding net_device
> if we clear the devlink_port's type. This looks like a bit of a hack,
> but also seems to be the reason why the devlink_port_type_clear function
> exists in the first place.
> 
> Fixes: 3122433eb533 ("net: dsa: Register devlink ports before calling DSA driver setup()")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Tested-by: Florian fainelli <f.fainelli@gmail.com>
Reported-by: Florian Fainelli <f.fainelli@gmail.com>

Thanks!
-- 
Florian
