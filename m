Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DD76202CE2
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 23:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730745AbgFUVIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 17:08:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730740AbgFUVIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Jun 2020 17:08:39 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30CDEC061794
        for <netdev@vger.kernel.org>; Sun, 21 Jun 2020 14:08:39 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id p5so14222756ile.6
        for <netdev@vger.kernel.org>; Sun, 21 Jun 2020 14:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PUpgez5n1uJ5A98sqtbdivcviX4gWvHaItB3V9krZKA=;
        b=e9NvqjCR12XLMUYPK1TQkPf8V/TEFCOWukIa57tO2AHHnWw5z65isyTNr0Ix0yEy4Z
         q5GmbACkH8qlz/XPPWEpLUVDietOaQG1wRCK8F8jccOx0Fn87ReSiZ07H0toz2rW4ptx
         loQ4BInzU2O/OmaTZwW3Jzgx1ZbyLNC5h272zAAV8DonjMcsGvjXcd/ssg7WJGyj06s9
         Bx6TzfEZnv6G5hFbre0ZMEfzGBiWFeg+EaNc6qfoKD2S9hFwR6R2JH8apuquSZ0MvM84
         e37xoY6HTz09Wttfi0YLrcpwK3my3hZHeqWMP+qpq+C4jdFeapQCjhJ3WKUpI5tshVj/
         ygbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PUpgez5n1uJ5A98sqtbdivcviX4gWvHaItB3V9krZKA=;
        b=lEtHoVRMg/KjXEZfi8BPISE7MLzkG1ERgOFBOl3L0LaAg8AUiD2Elm0VkyVvJ8mdqq
         zkGruYcxrjBvYraSEmWLe5t91w0WLdTyZcwWO1UJl1aibpCXKqh9i5cHu8/wJzAQw4lr
         lETYiu+SRQhbR+CGtdsTb49yeJ/fDr9PHD6m/LO7ROzT7KfF9X2AiEDVpqBI/bACzWLZ
         w8IKSsy6wDf88sHSUJKKUpEuLrL8k7oZU1FJ2OHPM8EqeVWFivtSFKe1F4iDnsd78xfo
         1M7+eVEupHLSuty490vxc+VI89OwfTPJFBn7MAWC9sbsEhszJ0OZ/Wre2yyMewKKEBUO
         +PCA==
X-Gm-Message-State: AOAM5320vZVcA7tf8ITN8zWRNByyHc6D3PbHIlKVc8xAAcXox2rmFQlR
        rNnPo3RxHPYeGOg4rq7pdHdp+KnP
X-Google-Smtp-Source: ABdhPJw1XLi9iaCnOaJiruSBX+ZF6mt9ot20a055COc+6HAF9htBL74mpfdUgbRJgpD9Bg7E6DtoMg==
X-Received: by 2002:a92:1946:: with SMTP id e6mr6596285ilm.170.1592773718440;
        Sun, 21 Jun 2020 14:08:38 -0700 (PDT)
Received: from [192.168.1.2] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.googlemail.com with ESMTPSA id 17sm2501029iln.22.2020.06.21.14.08.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Jun 2020 14:08:37 -0700 (PDT)
Subject: Re: secondary CPU port facing switch does not come up/online
To:     vtol@gmx.net, netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>, marek.behun@nic.cz
References: <d47ad9bb-280b-1c9c-a245-0aebd689ccf5@gmx.net>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 a9BQwACgnzGuH1BVeT2J0Ra+ZYgkx7DaPR0=
Message-ID: <8f29251c-d572-f37f-3678-85b68889fd61@gmail.com>
Date:   Sun, 21 Jun 2020 14:08:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <d47ad9bb-280b-1c9c-a245-0aebd689ccf5@gmx.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 2020-06-21 à 13:24, ѽ҉ᶬḳ℠ a écrit :
> {"kernel":"5.4.46","hostname":"OpenWrt","system":"ARMv7 Processor rev 1
> (v7l)","model":"Turris
> Omnia","board_name":"cznic,turris-omnia","release":{"distribution":"OpenWrt","version":"SNAPSHOT","revision":"r13600-9a477b833a","target":"mvebu/cortexa9","description":"OpenWrt
> SNAPSHOT r13600-9a477b833a"}}
> _____
> 
> With the below cited DT both CPU ports facing the node's build-in switch
> are brought online at boot time with kernel 4.14 but since having
> switched to kernel 5.4 only one CPU port gets online. It is as if the
> kernel discards the presence of the secondary CPU port. Kernel log only
> prints for the offline port just a single entry:
> 
> mvneta f1070000.ethernet eth0: Using hardware mac address
> 
> Swapping eth1 to port6 and eth0 to port6 then eth0 is brought online but
> eth1 is not. Removing port5 then the port6 listed port is brought
> up/online.
> 
> Once the node is booted the offline port can brought up with ip l set
> up. This seems like a regression bug in between the kernel versions.

There can only be one CPU port at a time active right now, so I am not
sure why it even worked with kernel 4.14. Could you please share kernel
logs and the output of ip link show in both working/non-working cases?

> 
> ____
> DT
> 
> cpu_port5: ports@5 {
>     reg = <5>;
>     label = "cpu";
>     ethernet = <&eth1>;
> 
>     fixed-link {
>         speed = <1000>;
>         full-duplex;
>     };
> };
> 
> cpu_port6: ports@6 {
>     reg = <6>;
>     label = "cpu";
>     ethernet = <&eth0>;
> 
>     fixed-link {
>         speed = <1000>;
>         full-duplex;
>     };
> };
> ------------
> kconf
> 
> CONFIG_MTD_NAND_MARVELL=y
> # CONFIG_PATA_MARVELL is not set
> CONFIG_NET_VENDOR_MARVELL=y
> CONFIG_MARVELL_PHY=y
> # CONFIG_MARVELL_10G_PHY is not set
> # CONFIG_WLAN_VENDOR_MARVELL is not set
> CONFIG_CRYPTO_DEV_MARVELL_CESA=y


-- 
Florian
