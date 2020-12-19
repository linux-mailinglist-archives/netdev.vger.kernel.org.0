Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E28F2DED01
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 05:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726287AbgLSEJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 23:09:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbgLSEJl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 23:09:41 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33524C0617B0
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 20:09:01 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id b8so2482027plx.0
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 20:09:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=wGG38Kja5/WgMptiSooqUeb/MTfXxEtbxP4LBrunFuA=;
        b=VPgFZN3DuXWHs8eJ/r4NBsS+9oVDAxAUlv+w0I0ijiSTEIFVO4C8XcoQvmUAQYAoHy
         zOnsAf0+xvGUDHJ/GllZXkVO9MYa+Du+V5naE0HzlKHgw9vLnwbJSa2ZeoyR3LF0ROo6
         X9vEb3KK99VZnVEGLEZCvBnYeMBVnY0Y/a0idAgZHzoZwbDa5T1gBWMpEX3FHlr+iCoV
         LShyu8/nrRJQ4jxQHrjipRa22YQwwE7KGXKM2ZfEEUMZK7JxvlFZRTlJWhLqv4g8QLvD
         eXlIDB82hCna908lBcFq4jxXh6aEey2XwrHpLiAxWXBmyrcq2Vo7m27PyBYjyQNwQq/8
         O3AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wGG38Kja5/WgMptiSooqUeb/MTfXxEtbxP4LBrunFuA=;
        b=HQFs8xvxTJZj+2BlkijBNufcF9w11Jbu4Y2BwO0OcnAfh5k86KxEmq6URUVPu8p/df
         HAqfggQ+Z6MVoX8un1hWXjMFfGdiks+sLspiDHh2RAJQbJ2iodaBQaVTM5BlSOCSUIH3
         LOw0n3PTmgMgOSZ5MqfmDFgST8rk2JQkAM9OW82hQa0MDRPF8TBcmYsW0FAOzt0NaaTV
         N4sEMH5FqPxEsZjl9SYyqMHHEYYG6VMe2GoNB8JSRop5ncFdtF2BJgOl35VOG0j6GtNZ
         OW11qdodW8C+YIYX4Hp/Om46+opgKsMvkbeR7NOdo3jBhjMC4BQMqFqIkdU+AjZyFibP
         ApRQ==
X-Gm-Message-State: AOAM531gjs012uwO2BDDZ19TlcC+m0a3vurU085XYI9n+pXsNuctM/bb
        zxPWOP+Nt1XbMyeb2Uq8u6CqPefE1eA=
X-Google-Smtp-Source: ABdhPJyk7IDVouIbBkntRcczIMJb32IwAcnOVxgpqWoLppWp7s7wN6j5zrz/lgx6E5ZVnr8QeBtMuA==
X-Received: by 2002:a17:902:ac93:b029:db:c725:e321 with SMTP id h19-20020a170902ac93b02900dbc725e321mr914700plr.41.1608350939658;
        Fri, 18 Dec 2020 20:08:59 -0800 (PST)
Received: from [10.230.29.166] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n195sm10422553pfd.169.2020.12.18.20.08.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Dec 2020 20:08:58 -0800 (PST)
Subject: Re: [RFC PATCH net-next 3/4] net: systemport: use standard netdevice
 notifier to detect DSA presence
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
References: <20201218223852.2717102-1-vladimir.oltean@nxp.com>
 <20201218223852.2717102-4-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <e9f3188d-558c-cb3a-6d5c-17d7d93c5416@gmail.com>
Date:   Fri, 18 Dec 2020 20:08:56 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201218223852.2717102-4-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/18/2020 2:38 PM, Vladimir Oltean wrote:
> The SYSTEMPORT driver maps each port of the embedded Broadcom DSA switch
> port to a certain queue of the master Ethernet controller. For that it
> currently uses a dedicated notifier infrastructure which was added in
> commit 60724d4bae14 ("net: dsa: Add support for DSA specific notifiers").
> 
> However, since commit 2f1e8ea726e9 ("net: dsa: link interfaces with the
> DSA master to get rid of lockdep warnings"), DSA is actually an upper of
> the Broadcom SYSTEMPORT as far as the netdevice adjacency lists are
> concerned. So naturally, the plain NETDEV_CHANGEUPPER net device notifiers
> are emitted. It looks like there is enough API exposed by DSA to the
> outside world already to make the call_dsa_notifiers API redundant. So
> let's convert its only user to plain netdev notifiers.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

The CHANGEUPPER has a slightly different semantic than the current DSA
notifier, and so events that would look like this during
bcm_sysport_init_tx_ring() (good):

[    6.781064] brcm-systemport 9300000.ethernet eth0: TDMA cfg,
size=256, switch q=0,port=0
[    6.789214] brcm-systemport 9300000.ethernet eth0: TDMA cfg,
size=256, switch q=1,port=0
[    6.797337] brcm-systemport 9300000.ethernet eth0: TDMA cfg,
size=256, switch q=2,port=0
[    6.805464] brcm-systemport 9300000.ethernet eth0: TDMA cfg,
size=256, switch q=3,port=0
[    6.813583] brcm-systemport 9300000.ethernet eth0: TDMA cfg,
size=256, switch q=0,port=1
[    6.821701] brcm-systemport 9300000.ethernet eth0: TDMA cfg,
size=256, switch q=1,port=1
[    6.829819] brcm-systemport 9300000.ethernet eth0: TDMA cfg,
size=256, switch q=2,port=1
[    6.837944] brcm-systemport 9300000.ethernet eth0: TDMA cfg,
size=256, switch q=3,port=1
[    6.846063] brcm-systemport 9300000.ethernet eth0: TDMA cfg,
size=256, switch q=0,port=2
[    6.854183] brcm-systemport 9300000.ethernet eth0: TDMA cfg,
size=256, switch q=1,port=2
[    6.862303] brcm-systemport 9300000.ethernet eth0: TDMA cfg,
size=256, switch q=2,port=2
[    6.870425] brcm-systemport 9300000.ethernet eth0: TDMA cfg,
size=256, switch q=3,port=2
[    6.878544] brcm-systemport 9300000.ethernet eth0: TDMA cfg,
size=256, switch q=0,port=5
[    6.886663] brcm-systemport 9300000.ethernet eth0: TDMA cfg,
size=256, switch q=1,port=5
[    6.894783] brcm-systemport 9300000.ethernet eth0: TDMA cfg,
size=256, switch q=2,port=5
[    6.902906] brcm-systemport 9300000.ethernet eth0: TDMA cfg,
size=256, switch q=3,port=5

now we are getting (bad):

[    6.678157] brcm-systemport 9300000.ethernet eth0: TDMA cfg,
size=256, switch q=0,port=0
[    6.686302] brcm-systemport 9300000.ethernet eth0: TDMA cfg,
size=256, switch q=1,port=0
[    6.694434] brcm-systemport 9300000.ethernet eth0: TDMA cfg,
size=256, switch q=2,port=0
[    6.702554] brcm-systemport 9300000.ethernet eth0: TDMA cfg,
size=256, switch q=3,port=0
[    6.710679] brcm-systemport 9300000.ethernet eth0: TDMA cfg,
size=256, switch q=0,port=0
[    6.718797] brcm-systemport 9300000.ethernet eth0: TDMA cfg,
size=256, switch q=1,port=0
[    6.726914] brcm-systemport 9300000.ethernet eth0: TDMA cfg,
size=256, switch q=2,port=0
[    6.735033] brcm-systemport 9300000.ethernet eth0: TDMA cfg,
size=256, switch q=3,port=0
[    6.743156] brcm-systemport 9300000.ethernet eth0: TDMA cfg,
size=256, switch q=0,port=1
[    6.751275] brcm-systemport 9300000.ethernet eth0: TDMA cfg,
size=256, switch q=1,port=1
[    6.759395] brcm-systemport 9300000.ethernet eth0: TDMA cfg,
size=256, switch q=2,port=1
[    6.767514] brcm-systemport 9300000.ethernet eth0: TDMA cfg,
size=256, switch q=3,port=1
[    6.775636] brcm-systemport 9300000.ethernet eth0: TDMA cfg,
size=256, switch q=0,port=1
[    6.783754] brcm-systemport 9300000.ethernet eth0: TDMA cfg,
size=256, switch q=1,port=1
[    6.791874] brcm-systemport 9300000.ethernet eth0: TDMA cfg,
size=256, switch q=2,port=1
[    6.799992] brcm-systemport 9300000.ethernet eth0: TDMA cfg,
size=256, switch q=3,port=1

Looking further in bcm_sysport_map_queues() we are getting the following:

    6.223042] brcm-systemport 9300000.ethernet eth0: mapping q=0, p=0
[    6.229369] brcm-systemport 9300000.ethernet eth0: mapping q=1, p=0
[    6.235659] brcm-systemport 9300000.ethernet eth0: mapping q=2, p=0
[    6.241945] brcm-systemport 9300000.ethernet eth0: mapping q=3, p=0
[    6.248232] brcm-systemport 9300000.ethernet eth0: mapping q=4, p=0
[    6.254519] brcm-systemport 9300000.ethernet eth0: mapping q=5, p=0
[    6.260805] brcm-systemport 9300000.ethernet eth0: mapping q=6, p=0
[    6.267092] brcm-systemport 9300000.ethernet eth0: mapping q=7, p=0

which means that the call to netif_set_real_num_tx_queues() that is
executed for the SYSTEMPORT Lite is not taking effect because it is
after the register_netdevice(). Insead of using a CHANGEUPPER notifier,
we can use a REGISTER notifier event and doing that works just fine with
the same semantics as the DSA notifier being removed. This incremental
patch on top of your patch works for me (tm):

https://github.com/ffainelli/linux/commit/f5095ab5c1f31db133d62273928b224674626b75

Thanks!
-- 
Florian
