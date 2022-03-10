Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 073934D4F77
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 17:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241339AbiCJQlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 11:41:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbiCJQlV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 11:41:21 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3EDD85640;
        Thu, 10 Mar 2022 08:40:19 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id v28so8511432ljv.9;
        Thu, 10 Mar 2022 08:40:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=YT9yTXEiAiBIN9Cn05pl2qQma8luZn1G2Do7oW9PCms=;
        b=bo8Lobd/EcTV1dG/y4cycmLtNX/KQExQLyQX+FjhrOYFmGtKa0yzwXeFJRqK1ufRFd
         Y3YAkwuANDJ3OnDNXPJkmPx3lxbpdLkQyRKvhjvo2G2YDGquPshCacr4VmfTt3eB8ngZ
         qAljb48cfBaC/vak1aNAmeTWnbLbXwW+2FJxkRQOZjvaNjP/VewOT4QQdFmUQKgDfL02
         xnvE2WI/IQAeyV5UKLr/qhf8uN1qhOclDQpUMBaQiZiDquMybutJVt2g0WOvbTt78LYg
         MEI4LRI8utkDMpq78tERn9Wc2s0F2JLKxaTobyneji9Sv+jI1Ckh0+4y7yqK81sh5XJF
         6TGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=YT9yTXEiAiBIN9Cn05pl2qQma8luZn1G2Do7oW9PCms=;
        b=QGHV4S71o6N/hYhbWtWY/5MmzdxNtC8hvR8WCMAc2lz252rFNKENQeooh5QCIgRFuW
         XCnovLCEzGEMO/mrmhn6tA980u9Pc1RVoddOpIwXFbPMhdReRyIYISZoiIrB+9ORpYgQ
         /agztuTEmoHgfWAnU6pi1MJEEuVNn7O3MRqK7cFakKlyGgSE/k0AhMQeVh/5+S+KdkJc
         AlJebkaRAHFs/6fxA3OM3scp4v3ON4/X/3Yb02kvB9GGTfIlV0dvBaQ6TRkf06pAvfA9
         IxQPbc2fLJ5ObzhU732YiWsBY7tIV88TNt71Rs7pQBtlOW4M8EPGdG35bxL4QOtdMh3k
         dYag==
X-Gm-Message-State: AOAM5326oQkzM/gHJWqeksWULYaGnqxxjgO5fWRrkV9ZUZqxb5nt43wU
        ZTW5bS5CbVr6J94It1An4kJq7xPxevQK2g==
X-Google-Smtp-Source: ABdhPJyCPyXoh/r+enyGyAfvQ9z9FCZj0GZpV54qd0q1oAvS5PJszPwhO48e2FbGaAuhr7v1u0Ekjg==
X-Received: by 2002:a05:651c:555:b0:247:b105:ff91 with SMTP id q21-20020a05651c055500b00247b105ff91mr3579264ljp.482.1646930418093;
        Thu, 10 Mar 2022 08:40:18 -0800 (PST)
Received: from wse-c0127 ([208.127.141.29])
        by smtp.gmail.com with ESMTPSA id c23-20020a196557000000b004481befdc8bsm1058261lfj.161.2022.03.10.08.40.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 08:40:17 -0800 (PST)
From:   Hans Schultz <schultz.hans@gmail.com>
X-Google-Original-From: Hans Schultz <schultz.hans+netdev@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>,
        Hans Schultz <schultz.hans@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next 3/3] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
In-Reply-To: <20220310160542.dihodbfxnexyjo2d@skbuf>
References: <20220310142320.611738-1-schultz.hans+netdev@gmail.com>
 <20220310142320.611738-4-schultz.hans+netdev@gmail.com>
 <20220310142836.m5onuelv4jej5gvs@skbuf> <865yolg8d7.fsf@gmail.com>
 <20220310150717.h7gaxamvzv47e5zc@skbuf> <86sfrpergs.fsf@gmail.com>
 <20220310160542.dihodbfxnexyjo2d@skbuf>
Date:   Thu, 10 Mar 2022 17:40:15 +0100
Message-ID: <86lexhoj68.fsf@gmail.com>
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

On tor, mar 10, 2022 at 18:05, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Thu, Mar 10, 2022 at 04:51:15PM +0100, Hans Schultz wrote:
>> On tor, mar 10, 2022 at 17:07, Vladimir Oltean <olteanv@gmail.com> wrote:
>> > On Thu, Mar 10, 2022 at 04:00:52PM +0100, Hans Schultz wrote:
>> >> >> +	brport = dsa_port_to_bridge_port(dp);
>> >> >
>> >> > Since this is threaded interrupt context, I suppose it could race with
>> >> > dsa_port_bridge_leave(). So it is best to check whether "brport" is NULL
>> >> > or not.
>> >> >
>> >> Would something like:
>> >> if (dsa_is_unused_port(chip->ds, port))
>> >>         return -ENODATA;
>> >> 
>> >> be appropriate and sufficient for that?
>> >
>> > static inline
>> > struct net_device *dsa_port_to_bridge_port(const struct dsa_port *dp)
>> > {
>> > 	if (!dp->bridge)
>> > 		return NULL;
>> >
>> > 	if (dp->lag)
>> > 		return dp->lag->dev;
>> > 	else if (dp->hsr_dev)
>> > 		return dp->hsr_dev;
>> >
>> > 	return dp->slave;
>> > }
>> >
>> > Notice the "dp->bridge" check. The assignments are in dsa_port_bridge_create()
>> > and in dsa_port_bridge_destroy(). These functions assume rtnl_mutex protection.
>> > The question was how do you serialize with that, and why do you assume
>> > that dsa_port_to_bridge_port() returns non-NULL.
>> >
>> > So no, dsa_is_unused_port() would do absolutely nothing to help.
>> 
>> I was thinking in indirect terms (dangerous I know :-).
>
> Sorry, I don't understand what you mean by "indirect terms". An "unused
> port" is one with 'status = "disabled";' in the device tree. I would
> expect that you don't need to handle FDB entries towards such a port!
>

Right!

> You have a port receiving traffic with an unknown {MAC SA, VID}.
> When the port is configured as locked by the bridge, this traffic will
> generate ATU miss interrupts. These will be handled in an interrupt
> thread that is scheduled to be handled some time in the future.
> In between the moment when the packet is received and the moment when
> the interrupt thread runs, a user could run "ip link set lan0 nomaster".
> Then the interrupt thread would notify the bridge about these entries,
> point during which a bridge port no longer exists => NULL pointer dereference.
> By taking the rtnl_lock() and then checking whether dsa_port_to_bridge_port()
> is NULL, you figure out whether the interrupt handler ran completely
> before dsa_port_bridge_leave(), or completely after dsa_port_bridge_leave().
>
>> 
>> But wrt the nl lock, I wonder when other threads could pull the carpet
>> away under this, and so I might have to wait till after the last call
>> (mv88e6xxx_g1_atu_loadpurge) to free the nl lock?
>
> That might make sense. It means: if the user runs "ip link set lan0 nomaster",
> wait until I've notified the bridge and installed the entry to my own
> ATU, so that they're in sync. Then, del_nbp() -> br_fdb_delete_by_port()
> would come in, find that entry notified by us (I think!) and remove it.
> If you call rtnl_unlock() too early, it might be possible that the ATU
> entry remains lingering (unless I'm missing some subtle implicit
> serialization based on mv88e6xxx_reg_lock() or similar).

I will go with releasing the lock after the last call. I think that
should be okay.
