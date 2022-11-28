Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5918E63A585
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 10:59:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbiK1J7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 04:59:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiK1J7F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 04:59:05 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08409193F8
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 01:59:02 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id n21so24371001ejb.9
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 01:59:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/T7pB1cnfJAtXQqy8EcD0bKoSYTzM4KdGxhTY18LWmU=;
        b=vrVfj3va9J1WBs+uU7RRfe9iB5Xjl2LQvQBnWvenYcxzBCT67fjGhHw606Hcahe3Zf
         44IAySp8pejiMDvQCwi9GyQPr8ONMLi4ZJP7CKKsA2aWys1ujOgqLXE/AZW7jh9nSkGG
         p2Tyh+BE8ufgjDGkh2lrTnFBO2jZgIBqj7HMyei58hJiNO3JK991BPe/otZfnpvVSbD4
         LW4wVuI+i+NxF0qRkxILf8+gmijzNDq3xnfZdSv+3Td+pGh7aEkhEwCB8f0E8QNr/zY0
         cXH12UyOj+f93pV5RefgPjtY6iSINMnKEUsvSpvQMruTgLbUXSmpnl7TJf3ghajyQ+NL
         A5NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/T7pB1cnfJAtXQqy8EcD0bKoSYTzM4KdGxhTY18LWmU=;
        b=gzw8x0+oJTgRQfp3F5tMtJpMCn1OxU0JiXKBCUPQB2HjSBT10RLmPWBuNp2bwpV/IH
         wOoce8dqBWGUYPb5yhmikB4d/z41Vj1AfCDR3z/fyuECWRn0hJzN1khQtXkH+mK56DDm
         /EojoyJvw3JAGiIr3CKy03+kXQHdMY+uRCKLVOJAOrdeZFs6WOA0lllhRrmpbuIPLFtk
         JBIbBLfWfRvvBHnpGOAUr4E6XjhJcFCGJQAYEJtgb78DQ7dp7doXnpKILeuD7+4WVhoi
         E8uPz+15k4xdKgz15d7pRn4ci/nr5TdQwlbq5k9HB5mWq8pFeVHWYeV8OEQlqehaU1gI
         BIEw==
X-Gm-Message-State: ANoB5pnFIOAgC21o3p2h95hORTw14LZpUIbHzX/SCvWi+Frdz4aPvdGn
        mtrsUD7OrYwIJIH+QXu2o0xUkiF9DH7R4X7aKng=
X-Google-Smtp-Source: AA0mqf5dcyBE43jH9JcHuhOunV494g83+g652m1elQw205hJx6VQazAw1BkpgrxuJDWgwjAHkd2ZNA==
X-Received: by 2002:a17:906:4717:b0:7b9:f0ae:f492 with SMTP id y23-20020a170906471700b007b9f0aef492mr20993807ejq.559.1669629540467;
        Mon, 28 Nov 2022 01:59:00 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id b9-20020a1709064d4900b007ae10525550sm4751523ejv.47.2022.11.28.01.58.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Nov 2022 01:58:59 -0800 (PST)
Date:   Mon, 28 Nov 2022 10:58:58 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Leon Romanovsky <leon@kernel.org>, netdev@vger.kernel.org,
        jiri@nvidia.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
Subject: Re: [PATCH net] net: devlink: fix UAF in
 devlink_compat_running_version()
Message-ID: <Y4SGYr6VBkIMTEpj@nanopsycho>
References: <Y3zdaX1I0Y8rdSLn@unreal>
 <e311b567-8130-15de-8dbb-06878339c523@huawei.com>
 <Y30dPRzO045Od2FA@unreal>
 <20221122122740.4b10d67d@kernel.org>
 <405f703b-b97e-afdd-8d5f-48b8f99d045d@huawei.com>
 <Y33OpMvLcAcnJ1oj@unreal>
 <fa1ab2fb-37ce-a810-8a3f-b71d902e8ff0@huawei.com>
 <Y35x9oawn/i+nuV3@shredder>
 <20221123181800.1e41e8c8@kernel.org>
 <Y4R9dT4QXgybUzdO@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4R9dT4QXgybUzdO@shredder>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Nov 28, 2022 at 10:20:53AM CET, idosch@idosch.org wrote:
>On Wed, Nov 23, 2022 at 06:18:00PM -0800, Jakub Kicinski wrote:
>> On Wed, 23 Nov 2022 21:18:14 +0200 Ido Schimmel wrote:
>> > > I used the fix code proposed by Jakub, but it didn't work correctly, so
>> > > I tried to correct and improve it, and need some devlink helper.
>> > > 
>> > > Anyway, it is a nsim problem, if we want fix this without touch devlink,
>> > > I think we can add a 'registered' field in struct nsim_dev, and it can be
>> > > checked in nsim_get_devlink_port() like this:  
>> > 
>> > I read the discussion and it's not clear to me why this is a netdevsim
>> > specific problem. The fundamental problem seems to be that it is
>> > possible to hold a reference on a devlink instance before it's
>> > registered and that devlink_free() will free the instance regardless of
>> > its current reference count because it expects devlink_unregister() to
>> > block. In this case, the instance was never registered, so
>> > devlink_unregister() is not called.
>> > 
>> > ethtool was able to get a reference on the devlink instance before it
>> > was registered because netdevsim registers its netdevs before
>> > registering its devlink instance. However, netdevsim is not the only one
>> > doing this: funeth, ice, prestera, mlx4, mlxsw, nfp and potentially
>> > others do the same thing.
>> > 
>> > When you think about it, it's strange that it's even possible for
>> > ethtool to reach the driver when the netdev used in the request is long
>> > gone, but it's not holding a reference on the netdev (it's holding a
>> > reference on the devlink instance instead) and
>> > devlink_compat_running_version() is called without RTNL.
>> 
>> Indeed. We did a bit of a flip-flop with the devlink locking rules
>> and the fact that the instance is reachable before it is registered 
>> is a leftover from a previous restructuring :(
>> 
>> Hence my preference to get rid of the ordering at the driver level 
>> than to try to patch it up in the code. Dunno if that's convincing.
>
>I don't have a good solution, but changing all the drivers to register
>their netdevs after the devlink instance is going to be quite painful
>and too big for 'net'. I feel like the main motivation for this is the
>ethtool compat stuff, which is not very convincing IMO. I'm quite happy
>with the current flow where drivers call devlink_register() at the end
>of their probe.
>
>Regarding a solution for the current crash, assuming we agree it's not a
>netdevsim specific problem, I think the current fix [1] is OK. Note that
>while it fixes the crash, it potentially creates other (less severe)
>problems. After user space receives RTM_NEWLINK notification it will
>need to wait for a certain period of time before issuing
>'ETHTOOL_GDRVINFO' as otherwise it will not get the firmware version. I
>guess it's not a big deal for drivers that only register one netdev
>since they will very quickly follow with devlink_register(), but the
>race window is larger for drivers that need to register many netdevs,
>for either physical switch or eswitch ports.
>
>Long term, we either need to find a way to make the ethtool compat stuff
>work correctly or just get rid of it and have affected drivers implement
>the relevant ethtool operations instead of relying on devlink.
>
>[1] https://lore.kernel.org/netdev/20221122121048.776643-1-yangyingliang@huawei.com/

I just had a call with Ido. We both think that this might be a good
solution for -net to avoid the use after free.

For net-next, we eventually should change driver init flows to register
devlink instance first and only after that register devlink_port and
related netdevice. The ordering is important for the userspace app. For
example the init flow:
<- RTnetlink new netdev event
app sees devlink_port handle in IFLA_DEVLINK_PORT
-> query devlink instance using this handle
<- ENODEV

The instance is not registered yet.

So we need to make sure all devlink_port_register() calls are happening
after devlink_register(). This is aligned with the original flow before
devlink_register() was moved by Leon. Also it is aligned with devlink
reload and devlink port split flows.

