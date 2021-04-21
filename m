Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E653B3672AF
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 20:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245258AbhDUSiE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 14:38:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238217AbhDUSiD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 14:38:03 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B733C06174A;
        Wed, 21 Apr 2021 11:37:29 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id b17so30739457pgh.7;
        Wed, 21 Apr 2021 11:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MLDIrCj7VcFwbIVWMo51IqYk0C1IXr6JWZJILf65wHI=;
        b=R+8SE6DM5G2LQqi0iv5Kh5rhcyMnQJmfwZeU0TDOqOKK+7bTroWXF7uhlgp4sbno+J
         fjFXEvDENYIk4pBX/DEMjZHmCSJmFSBfnK0/MtDaKYk/rVxZTX1Lh6rV432gL45gQT6p
         4RREJS7Iwfh5pFLlpMB8kuZAUPm4AO7vaJVezyRoY72DRNeY2qZn8HiYs8rxiaEdMuaW
         EC8XCM8EosDiS+zQcWQwVZoZAN7Swx5Jb3t/ZJ7L6naLuNjzUY+UuPQLas+P/S0Hfxje
         k1K8TYmVWGDA6xmIIF3oKS+MYzMd6YV8U9xC97ht7NtMuuVg5H6v+z1XL8VaXkDzpozj
         RB8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MLDIrCj7VcFwbIVWMo51IqYk0C1IXr6JWZJILf65wHI=;
        b=qAG9vAavIp8r0zG5AXAwS5s/Jqz9LvPd7X7qM934kWRPk9/XIIje1QUJOSy3f9feAh
         I5DlV7JAQUGWC8ssCuf1M5xGuWz5i4FcE0h1hUmAD7tFavR7Z2MYNsuQpU/hSRWSqu22
         LlGmFrWNjW/twaPPYttjI1qCcg7WSdnpIXIy9Lj1nLfTtzwpzZ7rdD74GcfIdeqluDIQ
         1Sbaba4hvZNwdzIUP9nYihBQLRMzISyqBAqHXXSSmDHzvjXbrFjfWrhiiYGVcucwHZRZ
         pSNBR/xudAZdSx9NudYjF3EldO4IlY5RU1VWdQXE9KY5kJB2Cd66bNOVXDvuJMgb+MGh
         aRQA==
X-Gm-Message-State: AOAM530VlYRzw/2FrfVjNJW11ztxQziqGuZlq/8RMRsbMGzVwCNq4NPw
        BA5S+dTDQD7B87kLuyDTM5ZiTVnBLxc=
X-Google-Smtp-Source: ABdhPJzel96ytZea4aYbQ9qXrLxaZk/FNCgluBRgKdCBizEwZAVvk0qX/WJNExEW8+NcC8kwX1wEow==
X-Received: by 2002:a63:5466:: with SMTP id e38mr23035417pgm.172.1619030248495;
        Wed, 21 Apr 2021 11:37:28 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f3sm117847pgg.70.2021.04.21.11.37.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Apr 2021 11:37:27 -0700 (PDT)
Subject: Re: net: bridge: propagate error code and extack from
 br_mc_disabled_update
To:     Christian Borntraeger <borntraeger@de.ibm.com>, olteanv@gmail.com
Cc:     andrew@lunn.ch, davem@davemloft.net, idosch@idosch.org,
        jiri@resnulli.us, kuba@kernel.org, netdev@vger.kernel.org,
        nikolay@nvidia.com, roopa@nvidia.com, vladimir.oltean@nxp.com,
        linux-next@vger.kernel.org, kvm list <kvm@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>
References: <20210414192257.1954575-1-olteanv@gmail.com>
 <20210421181808.5210-1-borntraeger@de.ibm.com>
 <cfc19833-01ec-08ea-881d-4101780d1d86@de.ibm.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <3993fbf8-b409-f88f-c573-bf5b8f418a88@gmail.com>
Date:   Wed, 21 Apr 2021 11:37:25 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <cfc19833-01ec-08ea-881d-4101780d1d86@de.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/21/2021 11:35 AM, Christian Borntraeger wrote:
> 
> 
> On 21.04.21 20:18, Christian Borntraeger wrote:
>> Whatever version landed in next, according to bisect this broke
>> libvirt/kvms use of bridges:
>>
>>
>> # virsh start s31128001
>> error: Failed to start domain 's31128001'
>> error: Unable to add bridge virbr1 port vnet0: Operation not supported
>>
>> # grep vnet0 /var/log/libvirt/libvirtd.log
>>
>> 2021-04-21 07:43:09.453+0000: 2460: info : virNetDevTapCreate:240 :
>> created device: 'vnet0'
>> 2021-04-21 07:43:09.453+0000: 2460: debug :
>> virNetDevSetMACInternal:287 : SIOCSIFHWADDR vnet0
>> MAC=fe:bb:83:28:01:02 - Success
>> 2021-04-21 07:43:09.453+0000: 2460: error : virNetDevBridgeAddPort:633
>> : Unable to add bridge virbr1 port vnet0: Operation not supported
>> 2021-04-21 07:43:09.466+0000: 2543: debug : udevHandleOneDevice:1695 :
>> udev action: 'add': /sys/devices/virtual/net/vnet0
>>
>> Christian
>>
> 
> For reference:
> 
> ae1ea84b33dab45c7b6c1754231ebda5959b504c is the first bad commit
> commit ae1ea84b33dab45c7b6c1754231ebda5959b504c
> Author: Florian Fainelli <f.fainelli@gmail.com>
> Date:   Wed Apr 14 22:22:57 2021 +0300
> 
>    net: bridge: propagate error code and extack from br_mc_disabled_update
>       Some Ethernet switches might only be able to support disabling
> multicast
>    snooping globally, which is an issue for example when several bridges
>    span the same physical device and request contradictory settings.
>       Propagate the return value of br_mc_disabled_update() such that this
>    limitation is transmitted correctly to user-space.
>       Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>    Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
>    Signed-off-by: David S. Miller <davem@davemloft.net>
> 
> net/bridge/br_multicast.c | 28 +++++++++++++++++++++-------
> net/bridge/br_netlink.c   |  4 +++-
> net/bridge/br_private.h   |  3 ++-
> net/bridge/br_sysfs_br.c  |  8 +-------
> 4 files changed, 27 insertions(+), 16 deletions(-)
> 
> not sure if it matters this is on s390.
> A simple reproducer is virt-install, e.g.
> virt-install --name test --disk size=12 --memory=2048 --vcpus=2
> --location
> http://ports.ubuntu.com/ubuntu-ports/dists/bionic/main/installer-s390x/

Thanks, I will kick off a reproducer and let you know.
-- 
Florian
