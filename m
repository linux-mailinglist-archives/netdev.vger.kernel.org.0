Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F4262F3940
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 19:53:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392228AbhALSwW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 13:52:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729923AbhALSwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 13:52:22 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6B37C06179F
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 10:51:41 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id b5so2274253pjk.2
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 10:51:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KxyvncnFFLYrPx0BX76P5pV/cZOWEiLtYBHcOaz1hSw=;
        b=JA2SF/4XLli96KUHirqvoVobTryAQejNxhkL5lUj0lkFWDwxfjOn5b7I5wEWncIlCx
         58pzJR8SyQ5vX/7UpRHX//1pBgv2N9TuiP49VnR5lPNyOATmvU+AKkuAIvivD+R8Kmh7
         /X/tAWGaeKHrKd+NRctAyGtHHuWU3u6dyYrIfLKD6Hz5a5p7dw9oBN38T7XHIOsNwgUq
         lD2ckZP87saHbhUbhKMlyCjgGWtkLdiGGVAEhJsQqJ9243421UvotmiSz4SgPGS4YxiT
         pz8TtIC8+NY9DXr6nF8DQ/8SP2fugg4VBNkXsi7+hdiycmUmkITRBxGsHJcOgra2QDOB
         Xl9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=KxyvncnFFLYrPx0BX76P5pV/cZOWEiLtYBHcOaz1hSw=;
        b=i9Y+CTXP3Qei08rbBRdX0jLf377mW8z1ZnIu6x2JD/Hponp6EAeNCdUyWCPFTUg6pQ
         EFLTddsMxN/meNl884i//0KAEnXBCzc/IRqwpv0ZirTjNJmfrlWnuqiSBPJEZFUPmOBM
         Gv1YFW02a9j5aSnbndJIm1ikM3YHIqmwQ6wnd/BgZJCYUjiKBP8ZWR+MdrAkYH1zJrvt
         jOcmCb6zMTIL/fgwXJU6IuhLTwLeDaxGngeJcQaBvIVhK06iZKfvN0BOFglUsYjat9QC
         vBCSl9ThZHeyTxnOrb6gd2iVezJ9nWDOLfFUd/NXFiwdxpJohxNPIuLqiQkpN9aBl/+O
         OnmA==
X-Gm-Message-State: AOAM533g+s/2zDfVdc+Dli4XbLxvvZgx/wjQsv5KXHexX7fiKhtQwo43
        Q4nkXPh45ufsp9MPTq3M+vk=
X-Google-Smtp-Source: ABdhPJyyZJjhmiYj7wqZFxQwoGpjlTWKtsTgu7rNPxKL20vWw6yhAnY9fCUNNvVEjnZo9o3cbGQmHg==
X-Received: by 2002:a17:902:7b84:b029:da:60e0:9d38 with SMTP id w4-20020a1709027b84b02900da60e09d38mr535918pll.55.1610477501455;
        Tue, 12 Jan 2021 10:51:41 -0800 (PST)
Received: from [10.67.48.230] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x6sm3960001pfq.57.2021.01.12.10.51.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Jan 2021 10:51:40 -0800 (PST)
Subject: Re: [PATCH net] net: dsa: unbind all switches from tree when DSA
 master unbinds
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com
References: <20210111230943.3701806-1-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <6d6cc153-85ca-62c8-8d9c-4f4c6a325e91@gmail.com>
Date:   Tue, 12 Jan 2021 10:51:39 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210111230943.3701806-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/11/21 3:09 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Currently the following happens when a DSA master driver unbinds while
> there are DSA switches attached to it:
> 
> $ echo 0000:00:00.5 > /sys/bus/pci/drivers/mscc_felix/unbind
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 392 at net/core/dev.c:9507
> Call trace:
>  rollback_registered_many+0x5fc/0x688
>  unregister_netdevice_queue+0x98/0x120
>  dsa_slave_destroy+0x4c/0x88
>  dsa_port_teardown.part.16+0x78/0xb0
>  dsa_tree_teardown_switches+0x58/0xc0
>  dsa_unregister_switch+0x104/0x1b8
>  felix_pci_remove+0x24/0x48
>  pci_device_remove+0x48/0xf0
>  device_release_driver_internal+0x118/0x1e8
>  device_driver_detach+0x28/0x38
>  unbind_store+0xd0/0x100
> 
> Located at the above location is this WARN_ON:
> 
> 	/* Notifier chain MUST detach us all upper devices. */
> 	WARN_ON(netdev_has_any_upper_dev(dev));
> 
> Other stacked interfaces, like VLAN, do indeed listen for
> NETDEV_UNREGISTER on the real_dev and also unregister themselves at that
> time, which is clearly the behavior that rollback_registered_many
> expects. But DSA interfaces are not VLAN. They have backing hardware
> (platform devices, PCI devices, MDIO, SPI etc) which have a life cycle
> of their own and we can't just trigger an unregister from the DSA
> framework when we receive a netdev notifier that the master unregisters.
> 
> Luckily, there is something we can do, and that is to inform the driver
> core that we have a runtime dependency to the DSA master interface's
> device, and create a device link where that is the supplier and we are
> the consumer. Having this device link will make the DSA switch unbind
> before the DSA master unbinds, which is enough to avoid the WARN_ON from
> rollback_registered_many.
> 
> Note that even before the blamed commit, DSA did nothing intelligent
> when the master interface got unregistered either. See the discussion
> here:
> https://lore.kernel.org/netdev/20200505210253.20311-1-f.fainelli@gmail.com/
> But this time, at least the WARN_ON is loud enough that the
> upper_dev_link commit can be blamed.
> 
> The advantage with this approach vs dev_hold(master) in the attached
> link is that the latter is not meant for long term reference counting.
> With dev_hold, the only thing that will happen is that when the user
> attempts an unbind of the DSA master, netdev_wait_allrefs will keep
> waiting and waiting, due to DSA keeping the refcount forever. DSA would
> not access freed memory corresponding to the master interface, but the
> unbind would still result in a freeze. Whereas with device links,
> graceful teardown is ensured. It even works with cascaded DSA trees.
> 
> $ echo 0000:00:00.2 > /sys/bus/pci/drivers/fsl_enetc/unbind
> [ 1818.797546] device swp0 left promiscuous mode
> [ 1819.301112] sja1105 spi2.0: Link is Down
> [ 1819.307981] DSA: tree 1 torn down
> [ 1819.312408] device eno2 left promiscuous mode
> [ 1819.656803] mscc_felix 0000:00:00.5: Link is Down
> [ 1819.667194] DSA: tree 0 torn down
> [ 1819.711557] fsl_enetc 0000:00:00.2 eno2: Link is Down
> 
> This approach allows us to keep the DSA framework absolutely unchanged,
> and the driver core will just know to unbind us first when the master
> goes away - as opposed to the large (and probably impossible) rework
> required if attempting to listen for NETDEV_UNREGISTER.
> 
> As per the documentation at Documentation/driver-api/device_link.rst,
> specifying the DL_FLAG_AUTOREMOVE_CONSUMER flag causes the device link
> to be automatically purged when the consumer fails to probe or later
> unbinds. So we don't need to keep the consumer_link variable in struct
> dsa_switch.
> 
> Fixes: 2f1e8ea726e9 ("net: dsa: link interfaces with the DSA master to get rid of lockdep warnings")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Tested-by: Florian Fainelli <f.fainelli@gmail.com>

Thanks!
-- 
Florian
