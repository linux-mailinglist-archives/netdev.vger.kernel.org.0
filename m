Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3792056B4C2
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 10:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237638AbiGHItL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 04:49:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237336AbiGHItJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 04:49:09 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2276F7B369;
        Fri,  8 Jul 2022 01:49:08 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id ez10so6422308ejc.13;
        Fri, 08 Jul 2022 01:49:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9d07Y8B9hW/YK4FdVwqna0EC5kCeABlM1GESgsdV3qE=;
        b=gHiNAIzwdN+JoHOkRq1S10c9X8e7xkFXbnXduv9//hQbLAE2ZUtsAVfggdlFAg4wUu
         6/CE6XPRQu1qfoMQJpFEUw6B1Gw1T2fmrzkr8Q47dVmmniPm21DvCE0uVqaXUhrVlms2
         oGakDf2RW5pztTCtvTDSr5QeOYmASWFF0sHlK+xxTfO3EM6NcjrnlnaZwreqrvWJaFbm
         5+sm2eZr4BrNevPHorokPFNHQJLcFdq5cELRn8RBvnp8CulnRjCfinXbSd4cepmU6NkM
         +tnVjqI42b5ZUHwYMIXnvz6hTg5ZNmJ8AnSU1hIbMAzd87LyWZR+gaEw/37RkDmLcpq7
         69zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9d07Y8B9hW/YK4FdVwqna0EC5kCeABlM1GESgsdV3qE=;
        b=0aQDLPZ8gdC8vqEE6818m+uw3TL9n7V7w74sSHmnIaLH6nOwdm8XFz6j3cny5Y3VIF
         b9Kg6aUpa5O1wzSTzM7aJBm8Z8C/k9b6hNG+NyRek2cIcgVdohAV0YEzQc8MfsajutqT
         J8w7A0MjzOYjjVcMEjtguafD4GDoiEv1FvTBWYW1Rj5RenbkzcEehjctNhJhtjyKn+ei
         SSgoYmvRbiVof2y04EXc+1KnNcKf7+1xcRGIo+stuMWJd3zbfiqU/5bbfgA2zsrd5PHm
         p0Z6YZA6M/T7ZLzvr0IZAoYVZ1rxrDO5fPLUzhXw19H/spS+jnlYKeqx4A6vkZuyQcFo
         7T7A==
X-Gm-Message-State: AJIora+anqclScxEx6NPr1AcH2b60BzsAJfle3KZbL7VcMYb7fP0YCzz
        5W2YxLKq+bkBUwpi6XLgPQbwnOb1TeRq2Q==
X-Google-Smtp-Source: AGRyM1vGQ+JxnW1/f9ERcoeH3wHX7kTQAW2ACV5QEuHg+XAeS3YAK+b1gKaR6BVkpav8213+/dv1dA==
X-Received: by 2002:a17:907:1c09:b0:726:b834:1a21 with SMTP id nc9-20020a1709071c0900b00726b8341a21mr2375623ejc.518.1657270146684;
        Fri, 08 Jul 2022 01:49:06 -0700 (PDT)
Received: from skbuf ([188.25.231.143])
        by smtp.gmail.com with ESMTPSA id 9-20020a170906210900b0072af56103casm3847130ejt.220.2022.07.08.01.49.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 01:49:06 -0700 (PDT)
Date:   Fri, 8 Jul 2022 11:49:04 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Hans Schultz <netdev@kapio-technology.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v4 net-next 3/6] drivers: net: dsa: add locked fdb entry
 flag to drivers
Message-ID: <20220708084904.33otb6x256huddps@skbuf>
References: <20220707152930.1789437-1-netdev@kapio-technology.com>
 <20220707152930.1789437-4-netdev@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220707152930.1789437-4-netdev@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hans,

On Thu, Jul 07, 2022 at 05:29:27PM +0200, Hans Schultz wrote:
> Ignore locked fdb entries coming in on all drivers.
> 
> Signed-off-by: Hans Schultz <netdev@kapio-technology.com>
> ---

A good patch should have a reason for the change in the commit message.
This has no reason because there is no reason.

Think about it, you've said it yourself in patch 1:

| Only the kernel can set this FDB entry flag, while userspace can read
| the flag and remove it by replacing or deleting the FDB entry.

So if user space will never add locked FDB entries to the bridge,
then FDB entries with is_locked=true are never transported using
SWITCHDEV_FDB_ADD_TO_DEVICE to drivers, and so, there is no reason at
all to pass is_locked to drivers, just for them to ignore something that
won't appear.

You just need this for SWITCHDEV_FDB_ADD_TO_BRIDGE, so please keep it
only in those code paths, and remove it from net/dsa/slave.c as well.

>  drivers/net/dsa/b53/b53_common.c       | 5 +++++
>  drivers/net/dsa/b53/b53_priv.h         | 1 +
>  drivers/net/dsa/hirschmann/hellcreek.c | 5 +++++
>  drivers/net/dsa/lan9303-core.c         | 5 +++++
>  drivers/net/dsa/lantiq_gswip.c         | 5 +++++
>  drivers/net/dsa/microchip/ksz9477.c    | 5 +++++
>  drivers/net/dsa/mt7530.c               | 5 +++++
>  drivers/net/dsa/mv88e6xxx/chip.c       | 5 +++++
>  drivers/net/dsa/ocelot/felix.c         | 5 +++++
>  drivers/net/dsa/qca8k.c                | 5 +++++
>  drivers/net/dsa/sja1105/sja1105_main.c | 5 +++++
>  include/net/dsa.h                      | 1 +
>  net/dsa/switch.c                       | 4 ++--
>  13 files changed, 54 insertions(+), 2 deletions(-)
