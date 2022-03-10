Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC5534D4AEF
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 15:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243823AbiCJOcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 09:32:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245709AbiCJOau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 09:30:50 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A032186424;
        Thu, 10 Mar 2022 06:26:44 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id w12so9704546lfr.9;
        Thu, 10 Mar 2022 06:26:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=aOR4hwC/LyUI0jjOxT3n02PFkMoRNv160vr8ERq5R5M=;
        b=TLmdcYdLOXvPkXN9lzSvK+qd50RETYsuhCjwfouchXQvEMmBtGFGKFXlQFT4XjefXR
         IQpovEbCoHIfttXXAA94M4q+vbatxV4BvpyFSYobDNDTViPh9MJjXheBb8evLNaGNm1N
         Qt7uCkdRljkUOSX6YC2pU8n8/BAYdqs7DYr+zsNr9lpo3xRnPLrgyog6EaFrsar6ZIQH
         n5kCTBiudP3pCaM9NEIejnj+QRgKJ+A0lu1kRzusD+MnB/Mgagj3RBbpz+XxMO4ZIv+M
         m5Zgv+01Urk72PAF+/yLNKdKG/tzpq8FKZzguQVsG6ppY0IDGKafSCGU7k5wsZLvNrUm
         SYQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=aOR4hwC/LyUI0jjOxT3n02PFkMoRNv160vr8ERq5R5M=;
        b=jK6euDb5RPMd94Ctr8s1DfQHnUfxfXDM5PiqQSZjnDwuRAvJpOmAYEeqglc8lQDzZ4
         I5yAQxe324xn4X8AlmNib/2FzbDVRIVGjn863tBXM4TxUMEppV+CNn43244t+9zmhT2X
         zQD2zcN92pXx3QwLHld/Bj1P95zqfaebxJqBrofxKTRFXJD6uO5m+FSpy8YgD5Bj960v
         phMN4nfGJsoGxKIfHwXHeFA4MU3VnXQBEKiHz3iQi8CpoOLhV7fq3ozaOl8ldvcmiO9c
         dv7U65L8S2BeCg8uU4O2vlXaTj5QkwkYm/Fgd91MZOhWhpsqpU7JbCA9A4+stH0cMiIC
         HtCw==
X-Gm-Message-State: AOAM532xfK5afSvdwDgyNbZagrIhe/uBNFEFGcpgstXpByvAwaqChlQq
        0U7hbSF/LKR3ZN1S/C0MsYA=
X-Google-Smtp-Source: ABdhPJxdb48xfM1I6A57NBB+0VE33vTP/hLoecV0tRu2EiQR4i3oGYbQDIazvv4DmJhtp+HspEJ/lQ==
X-Received: by 2002:a05:6512:3ba6:b0:448:23de:ca79 with SMTP id g38-20020a0565123ba600b0044823deca79mr3227383lfv.400.1646922400073;
        Thu, 10 Mar 2022 06:26:40 -0800 (PST)
Received: from wse-c0127 ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id r22-20020a2e9956000000b00247f5d1c457sm1090247ljj.126.2022.03.10.06.26.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 06:26:39 -0800 (PST)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     Nikolay Aleksandrov <razor@blackwall.org>,
        Hans Schultz <schultz.hans@gmail.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH iproute2-next 0/3] Extend locked port feature with FDB
 locked flag (MAC-Auth/MAB)
In-Reply-To: <7ed798dd-49c1-171b-4b72-4e2b2c9c660d@blackwall.org>
References: <20220310133617.575673-1-schultz.hans+netdev@gmail.com>
 <7ed798dd-49c1-171b-4b72-4e2b2c9c660d@blackwall.org>
Date:   Thu, 10 Mar 2022 15:26:36 +0100
Message-ID: <86y21hc28z.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On tor, mar 10, 2022 at 16:18, Nikolay Aleksandrov <razor@blackwall.org> wrote:
> On 10/03/2022 15:36, Hans Schultz wrote:
>> This patch set extends the locked port feature for devices
>> that are behind a locked port, but do not have the ability to
>> authorize themselves as a supplicant using IEEE 802.1X.
>> Such devices can be printers, meters or anything related to
>> fixed installations. Instead of 802.1X authorization, devices
>> can get access based on their MAC addresses being whitelisted.
>> 
>> For an authorization daemon to detect that a device is trying
>> to get access through a locked port, the bridge will add the
>> MAC address of the device to the FDB with a locked flag to it.
>> Thus the authorization daemon can catch the FDB add event and
>> check if the MAC address is in the whitelist and if so replace
>> the FDB entry without the locked flag enabled, and thus open
>> the port for the device.
>> 
>> This feature is known as MAC-Auth or MAC Authentication Bypass
>> (MAB) in Cisco terminology, where the full MAB concept involves
>> additional Cisco infrastructure for authorization. There is no
>> real authentication process, as the MAC address of the device
>> is the only input the authorization daemon, in the general
>> case, has to base the decision if to unlock the port or not.
>> 
>> With this patch set, an implementation of the offloaded case is
>> supplied for the mv88e6xxx driver. When a packet ingresses on
>> a locked port, an ATU miss violation event will occur. When
>> handling such ATU miss violation interrupts, the MAC address of
>> the device is added to the FDB with a zero destination port
>> vector (DPV) and the MAC address is communicated through the
>> switchdev layer to the bridge, so that a FDB entry with the
>> locked flag enabled can be added.
>> 
>> Hans Schultz (3):
>>    net: bridge: add fdb flag to extent locked port feature
>>    net: switchdev: add support for offloading of fdb locked flag
>>    net: dsa: mv88e6xxx: mac-auth/MAB implementation
>> 
>>   drivers/net/dsa/mv88e6xxx/Makefile            |  1 +
>>   drivers/net/dsa/mv88e6xxx/chip.c              | 10 +--
>>   drivers/net/dsa/mv88e6xxx/chip.h              |  5 ++
>>   drivers/net/dsa/mv88e6xxx/global1.h           |  1 +
>>   drivers/net/dsa/mv88e6xxx/global1_atu.c       | 29 +++++++-
>>   .../net/dsa/mv88e6xxx/mv88e6xxx_switchdev.c   | 67 +++++++++++++++++++
>>   .../net/dsa/mv88e6xxx/mv88e6xxx_switchdev.h   | 20 ++++++
>>   drivers/net/dsa/mv88e6xxx/port.c              | 11 +++
>>   drivers/net/dsa/mv88e6xxx/port.h              |  1 +
>>   include/net/switchdev.h                       |  3 +-
>>   include/uapi/linux/neighbour.h                |  1 +
>>   net/bridge/br.c                               |  3 +-
>>   net/bridge/br_fdb.c                           | 13 +++-
>>   net/bridge/br_input.c                         | 11 ++-
>>   net/bridge/br_private.h                       |  5 +-
>>   15 files changed, 167 insertions(+), 14 deletions(-)
>>   create mode 100644 drivers/net/dsa/mv88e6xxx/mv88e6xxx_switchdev.c
>>   create mode 100644 drivers/net/dsa/mv88e6xxx/mv88e6xxx_switchdev.h
>> 
>
> This doesn't look like an iproute2 patch-set. I think you've messed the target
> in the subject.

Sorry, complete bummer!
I have resent it with the correct header.
