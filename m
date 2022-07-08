Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D743F56B52B
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 11:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237761AbiGHJP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 05:15:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237473AbiGHJPz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 05:15:55 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6666321E28;
        Fri,  8 Jul 2022 02:15:54 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id fd6so26134633edb.5;
        Fri, 08 Jul 2022 02:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wHmLJrl8JY97pnJUtLPIqF5xTBqgcIZw7/C7kgtVgmQ=;
        b=XW4JdvdoO4/ukQzjguzcwAFZARJjsB7wnX/kVEl/FoFJqcjoxjFBmJU3E+DKU5yjcI
         uS8+U2O1U+Wd/Shh2mWrWXeFj6aejm2IuOFAEpdlLwgBMUpEwYa/Ha+rHVfVdUye7MbU
         yp/UwGkIAThZZnoo7vBAbi0ayyqjTVt9hjHj14puCSQ+fKIvqOL8rLkPjYtyrU6t387T
         XCnDs5ii8osrZSMqQ9LnOXS+iEHQwbT/b3jKW7d5qhTH9WOJcoQWa/G9zK4Le7UUYjHl
         j5tNxVmKwJdKvM60nRbTBAkbnO72NjcW1jKsCFgoaI6sZRgW/qBhaxDWlrD35wKjfRcO
         LVPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wHmLJrl8JY97pnJUtLPIqF5xTBqgcIZw7/C7kgtVgmQ=;
        b=o1g+JJ9Q/ZlsRrZ0Nf2Y6cL7bSkpYva37gIW8o0hCavwUPGGctzoX0jNvyxKRWZuYN
         qYMN1raIs8KAljsylvXYbTRo7di4U+oO+Ji5e92u1UlHc+l2jUsqGZjXYCaRimThpt2V
         Bum0bA/xiQKlO2jkv81xeHXJo/f++pNPI4ynr7C7V3H5tIUQzjjFxHLnaq1xrmq/A3O+
         kRv6+1H5IFW/Z3WJ4lHTkdghwWX9tVbYFMASvIS2G+PE88q4l24I4DolHmqLMVcnSCN0
         HsCUrAzhEMZGRzCc8Fa8qIHRsdDlWYGaNzirLiW4gdaIep6YYfSaeSsSsWt7vxRTF8Vc
         sS4A==
X-Gm-Message-State: AJIora/0m8VTipuLkS36zj6VufhvxiTuKVcgXMgFApcPQJeOFn3Ac9v4
        n+evMfgscOT0VABmCDYoxiCEJAoLM4pAhQ==
X-Google-Smtp-Source: AGRyM1skmIdMzLZUsxTOPXC0kET1dz3xxxMCUtpXOANF3SanR+/KfstqosHOYFDOwfKcyGqUrBuw8A==
X-Received: by 2002:a05:6402:f08:b0:43a:b202:1f63 with SMTP id i8-20020a0564020f0800b0043ab2021f63mr207749eda.207.1657271752890;
        Fri, 08 Jul 2022 02:15:52 -0700 (PDT)
Received: from skbuf ([188.25.231.143])
        by smtp.gmail.com with ESMTPSA id q25-20020a17090676d900b0072ab06bf296sm8523911ejn.23.2022.07.08.02.15.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 02:15:52 -0700 (PDT)
Date:   Fri, 8 Jul 2022 12:15:50 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@kapio-technology.com
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
Message-ID: <20220708091550.2qcu3tyqkhgiudjg@skbuf>
References: <20220707152930.1789437-1-netdev@kapio-technology.com>
 <20220707152930.1789437-4-netdev@kapio-technology.com>
 <20220708084904.33otb6x256huddps@skbuf>
 <e6f418705e19df370c8d644993aa9a6f@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6f418705e19df370c8d644993aa9a6f@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 08, 2022 at 11:06:24AM +0200, netdev@kapio-technology.com wrote:
> On 2022-07-08 10:49, Vladimir Oltean wrote:
> > Hi Hans,
> > 
> > On Thu, Jul 07, 2022 at 05:29:27PM +0200, Hans Schultz wrote:
> > > Ignore locked fdb entries coming in on all drivers.
> > > 
> > > Signed-off-by: Hans Schultz <netdev@kapio-technology.com>
> > > ---
> > 
> > A good patch should have a reason for the change in the commit message.
> > This has no reason because there is no reason.
> > 
> > Think about it, you've said it yourself in patch 1:
> > 
> > | Only the kernel can set this FDB entry flag, while userspace can read
> > | the flag and remove it by replacing or deleting the FDB entry.
> > 
> > So if user space will never add locked FDB entries to the bridge,
> > then FDB entries with is_locked=true are never transported using
> > SWITCHDEV_FDB_ADD_TO_DEVICE to drivers, and so, there is no reason at
> > all to pass is_locked to drivers, just for them to ignore something that
> > won't appear.
> 
> Correct me if I am wrong, but since the bridge can add locked entries, and
> the ensuring fdb update will create a SWITCHDEV_FDB_ADD_TO_DEVICE, those
> entries
> should reach the driver. The policy to ignore those in the driver can be
> seen as either the right thing to do, or not yet implemented.
> 
> I remember Ido wrote at a point that the scheme they use is to trap various
> packets to the CPU and let the bridge add the locked entry, which I then
> understand is sent to the driver with a SWITCHDEV_FDB_ADD_TO_DEVICE event.

Well, yes, but if I'm correct, the bridge right now can't create locked
FDB entries, so is_locked will always be false in the ADD_TO_DEVICE
direction.

When the possibility for it to be true will exist, _all_ switchdev
drivers will need to be updated to ignore that (mlxsw, cpss, ocelot,
rocker, prestera, etc etc), not just DSA. And you don't need to
propagate the is_locked flag to all individual DSA sub-drivers when none
care about is_locked in the ADD_TO_DEVICE direction, you can just ignore
within DSA until needed otherwise.

> > 
> > You just need this for SWITCHDEV_FDB_ADD_TO_BRIDGE, so please keep it
> > only in those code paths, and remove it from net/dsa/slave.c as well.
> > 
> > >  drivers/net/dsa/b53/b53_common.c       | 5 +++++
> > >  drivers/net/dsa/b53/b53_priv.h         | 1 +
> > >  drivers/net/dsa/hirschmann/hellcreek.c | 5 +++++
> > >  drivers/net/dsa/lan9303-core.c         | 5 +++++
> > >  drivers/net/dsa/lantiq_gswip.c         | 5 +++++
> > >  drivers/net/dsa/microchip/ksz9477.c    | 5 +++++
> > >  drivers/net/dsa/mt7530.c               | 5 +++++
> > >  drivers/net/dsa/mv88e6xxx/chip.c       | 5 +++++
> > >  drivers/net/dsa/ocelot/felix.c         | 5 +++++
> > >  drivers/net/dsa/qca8k.c                | 5 +++++
> > >  drivers/net/dsa/sja1105/sja1105_main.c | 5 +++++
> > >  include/net/dsa.h                      | 1 +
> > >  net/dsa/switch.c                       | 4 ++--
> > >  13 files changed, 54 insertions(+), 2 deletions(-)
