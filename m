Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCF2B4D4ADC
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 15:55:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242985AbiCJOVZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 09:21:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245057AbiCJOUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 09:20:22 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD51B0D16
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 06:18:50 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id r22so7927868ljd.4
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 06:18:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=eWVv6eZyJg/+eUaoLT3dUwImTgfJSRuKymGltshbh80=;
        b=t7ALIPtw3FdXJEbivsDE3RXilGcI4LV6NZYNfsWaSRTH6omQWzDYIA0tmwsHGbNr67
         egYoSkwO7q3t/m4u4zyTsFoeR+4oUxKD1s8HksaEci2TecLoN7NXYq6TtsnOG+DTMvpo
         SIaK3KH3enNAKLMC9xa73KIHTlJwf57TUmKQlQ4GbDIVJK8Pr5NXSosQe83VUu4dtNE7
         d3VZAKYTFYs9mrBebIuNxsc0ZQ4lLxALwlq39XFyL7Yle7Pnq0VhyjD3aFcATyqFdKvE
         kx6MQ7Bv3ASpRIzZfoV9FBhel6UcyaZ6z1FEWcIFVNTc6Zo4Cn9xtaP9u/7A6VJAuVFe
         xIug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=eWVv6eZyJg/+eUaoLT3dUwImTgfJSRuKymGltshbh80=;
        b=DIPSydNLzwGrn9nXbVri0olDJ3GzVEzDAaKrbaejPIaixOLJ8febX5C6GaccAU/fJv
         j2mb4XNYpZX1KXIrtHm4k3a1uMfvY9MP34e7OBSBGi3Om74tcxk+Qz24ofMrG25LSS0C
         bFaVbXAL7T3f5qHYJFkXQ4rwfvSf0hRYSQYy/StpP4mYzwwhElY7bNsoKsTfHU3O6s26
         7+mTfs/DfHy5ggmC4wRkKR3Si5J0yG/mfdMVx9cmtRWRAumBNrzwAjvTEOH+THnu0mHM
         0DK1j9BWngzQrlP36UWzLG/l+Fw5KqtBBsR+5S23UxVPLghVXb4ibuN3FAPB6xmAUd8c
         fsOw==
X-Gm-Message-State: AOAM5335o+ibKfo03dHfMuoXhMAcrKCh0hT+CygoXzk4KZ5CckcUTnHp
        4r1FC8Fo2pC0dLT5sBnUhpESIg==
X-Google-Smtp-Source: ABdhPJxwinz6PetJ7dJRMmCVaeTN7Ts24q7yumXDa7xtozCjI+p6OkvWdIt8sgLgi3gI8hBYO12QAQ==
X-Received: by 2002:a2e:2f0e:0:b0:246:1a59:8f04 with SMTP id v14-20020a2e2f0e000000b002461a598f04mr3253760ljv.409.1646921928481;
        Thu, 10 Mar 2022 06:18:48 -0800 (PST)
Received: from [192.168.51.243] ([78.128.78.220])
        by smtp.gmail.com with ESMTPSA id bt23-20020a056512261700b00443e7fa1c26sm1000809lfb.261.2022.03.10.06.18.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 06:18:48 -0800 (PST)
Message-ID: <7ed798dd-49c1-171b-4b72-4e2b2c9c660d@blackwall.org>
Date:   Thu, 10 Mar 2022 16:18:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH iproute2-next 0/3] Extend locked port feature with FDB
 locked flag (MAC-Auth/MAB)
Content-Language: en-US
To:     Hans Schultz <schultz.hans@gmail.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Hans Schultz <schultz.hans+netdev@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org
References: <20220310133617.575673-1-schultz.hans+netdev@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220310133617.575673-1-schultz.hans+netdev@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/03/2022 15:36, Hans Schultz wrote:
> This patch set extends the locked port feature for devices
> that are behind a locked port, but do not have the ability to
> authorize themselves as a supplicant using IEEE 802.1X.
> Such devices can be printers, meters or anything related to
> fixed installations. Instead of 802.1X authorization, devices
> can get access based on their MAC addresses being whitelisted.
> 
> For an authorization daemon to detect that a device is trying
> to get access through a locked port, the bridge will add the
> MAC address of the device to the FDB with a locked flag to it.
> Thus the authorization daemon can catch the FDB add event and
> check if the MAC address is in the whitelist and if so replace
> the FDB entry without the locked flag enabled, and thus open
> the port for the device.
> 
> This feature is known as MAC-Auth or MAC Authentication Bypass
> (MAB) in Cisco terminology, where the full MAB concept involves
> additional Cisco infrastructure for authorization. There is no
> real authentication process, as the MAC address of the device
> is the only input the authorization daemon, in the general
> case, has to base the decision if to unlock the port or not.
> 
> With this patch set, an implementation of the offloaded case is
> supplied for the mv88e6xxx driver. When a packet ingresses on
> a locked port, an ATU miss violation event will occur. When
> handling such ATU miss violation interrupts, the MAC address of
> the device is added to the FDB with a zero destination port
> vector (DPV) and the MAC address is communicated through the
> switchdev layer to the bridge, so that a FDB entry with the
> locked flag enabled can be added.
> 
> Hans Schultz (3):
>    net: bridge: add fdb flag to extent locked port feature
>    net: switchdev: add support for offloading of fdb locked flag
>    net: dsa: mv88e6xxx: mac-auth/MAB implementation
> 
>   drivers/net/dsa/mv88e6xxx/Makefile            |  1 +
>   drivers/net/dsa/mv88e6xxx/chip.c              | 10 +--
>   drivers/net/dsa/mv88e6xxx/chip.h              |  5 ++
>   drivers/net/dsa/mv88e6xxx/global1.h           |  1 +
>   drivers/net/dsa/mv88e6xxx/global1_atu.c       | 29 +++++++-
>   .../net/dsa/mv88e6xxx/mv88e6xxx_switchdev.c   | 67 +++++++++++++++++++
>   .../net/dsa/mv88e6xxx/mv88e6xxx_switchdev.h   | 20 ++++++
>   drivers/net/dsa/mv88e6xxx/port.c              | 11 +++
>   drivers/net/dsa/mv88e6xxx/port.h              |  1 +
>   include/net/switchdev.h                       |  3 +-
>   include/uapi/linux/neighbour.h                |  1 +
>   net/bridge/br.c                               |  3 +-
>   net/bridge/br_fdb.c                           | 13 +++-
>   net/bridge/br_input.c                         | 11 ++-
>   net/bridge/br_private.h                       |  5 +-
>   15 files changed, 167 insertions(+), 14 deletions(-)
>   create mode 100644 drivers/net/dsa/mv88e6xxx/mv88e6xxx_switchdev.c
>   create mode 100644 drivers/net/dsa/mv88e6xxx/mv88e6xxx_switchdev.h
> 

This doesn't look like an iproute2 patch-set. I think you've messed the target
in the subject.

