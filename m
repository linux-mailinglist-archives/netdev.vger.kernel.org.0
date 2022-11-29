Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1873963BC7B
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 10:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230291AbiK2JFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 04:05:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbiK2JFQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 04:05:16 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5979B1DF19
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 01:05:13 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id b2so15835819eja.7
        for <netdev@vger.kernel.org>; Tue, 29 Nov 2022 01:05:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=S4dDXuQb/9gS3+QG+K7HelWUeQONI5mcBzRY/WcY6Vs=;
        b=YjtPdLUTIf4UGVGDEbKcW9QDuW6Zd2pCyfwRDWAHPDbQkgDmrMZZW8WIChN7qk0PxY
         cnoLouUwN0H1vfFW9jItNBQlSy3WO4HhEVafHsBa9cPnKZEplQJHuJ3n1CEzbgiNmWcu
         gnD32LSFHkvBMoz7O/Iweguc+cwnjuaa7n0ldG3xnTuGR16yspHOjGtpJXfjGSJWfAKC
         AYKgJpjQkJOqQzyYw+8wjIgKnol3TnjqavqXHrXhaB1Q3vVqx+ZWjVgUkO/YE8tYLYcc
         JP5prJXba0qQVPCliY5P5EU1iZrygyzNelAYMWkd0QSnf+2/RN/uemhIj+g125Z73CDq
         CrpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S4dDXuQb/9gS3+QG+K7HelWUeQONI5mcBzRY/WcY6Vs=;
        b=eiawA1Nqs1Ee7+HHnO+g+d415JiHywLsTT9Th21xwc0LRyeHwaBHYggvjid3inlpYn
         W2s5/2cJtrFMvw/f/ukufoiMi5eQ5JaohzQrew2moU1VZJEmDr/yiWXOCHDVUhYZzRvW
         KyQfJ0ccBqbPsOYe14OSPJkHJnJ5mC0utghEeN+4ddwHs0BISxwzXbSgt/WBKPWCaKFp
         YODHYPWX79oQs0yNiBTF05A2b0UQTHKlgsrFerX4bBveLF7lBRojKLBUnVqyAOAdz7k0
         kBws9hyFMQx2SgIkxrpKuEp7S1GyfeDJZG5tUEhfIqmdbygmr9lYXQdXNFSIC6hTQZu6
         qmjw==
X-Gm-Message-State: ANoB5pk8+ZmxZOVd5aboa2M7rtgUz9kA/2BYlg+/ylbYKPj3YMYBdtcA
        0kNVx/D5B81JmOnAL15yNvUpwg==
X-Google-Smtp-Source: AA0mqf5B1pbChvVab8IlRFrDm8E5AnncD5GkepTZzRIwWgtQRph91r1WWhKcMFCw1suUHxmxvyr45g==
X-Received: by 2002:a17:906:945a:b0:7a8:3597:34a8 with SMTP id z26-20020a170906945a00b007a8359734a8mr30384758ejx.628.1669712711870;
        Tue, 29 Nov 2022 01:05:11 -0800 (PST)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id z3-20020aa7c643000000b004587f9d3ce8sm6019389edr.56.2022.11.29.01.05.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Nov 2022 01:05:11 -0800 (PST)
Date:   Tue, 29 Nov 2022 10:05:10 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Ido Schimmel <idosch@idosch.org>, Jakub Kicinski <kuba@kernel.org>,
        Yang Yingliang <yangyingliang@huawei.com>,
        netdev@vger.kernel.org, jiri@nvidia.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com
Subject: Re: [PATCH net] net: devlink: fix UAF in
 devlink_compat_running_version()
Message-ID: <Y4XLRuf/Z+U+uhNp@nanopsycho>
References: <405f703b-b97e-afdd-8d5f-48b8f99d045d@huawei.com>
 <Y33OpMvLcAcnJ1oj@unreal>
 <fa1ab2fb-37ce-a810-8a3f-b71d902e8ff0@huawei.com>
 <Y35x9oawn/i+nuV3@shredder>
 <20221123181800.1e41e8c8@kernel.org>
 <Y4R9dT4QXgybUzdO@shredder>
 <Y4SGYr6VBkIMTEpj@nanopsycho>
 <Y4Sgd6fqcfL5c/vg@unreal>
 <Y4S7XENL7TgIEtPA@nanopsycho>
 <Y4XGgDweoWOM/Ppy@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4XGgDweoWOM/Ppy@unreal>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Nov 29, 2022 at 09:44:48AM CET, leon@kernel.org wrote:
>On Mon, Nov 28, 2022 at 02:52:00PM +0100, Jiri Pirko wrote:
>> Mon, Nov 28, 2022 at 12:50:15PM CET, leon@kernel.org wrote:
>> >On Mon, Nov 28, 2022 at 10:58:58AM +0100, Jiri Pirko wrote:
>> >> Mon, Nov 28, 2022 at 10:20:53AM CET, idosch@idosch.org wrote:
>> >> >On Wed, Nov 23, 2022 at 06:18:00PM -0800, Jakub Kicinski wrote:
>> >> >> On Wed, 23 Nov 2022 21:18:14 +0200 Ido Schimmel wrote:
>> >> >> > > I used the fix code proposed by Jakub, but it didn't work correctly, so
>> >> >> > > I tried to correct and improve it, and need some devlink helper.
>> >> >> > > 
>> >> >> > > Anyway, it is a nsim problem, if we want fix this without touch devlink,
>> >> >> > > I think we can add a 'registered' field in struct nsim_dev, and it can be
>> >> >> > > checked in nsim_get_devlink_port() like this:  
>> >> >> > 
>> >> >> > I read the discussion and it's not clear to me why this is a netdevsim
>> >> >> > specific problem. The fundamental problem seems to be that it is
>> >> >> > possible to hold a reference on a devlink instance before it's
>> >> >> > registered and that devlink_free() will free the instance regardless of
>> >> >> > its current reference count because it expects devlink_unregister() to
>> >> >> > block. In this case, the instance was never registered, so
>> >> >> > devlink_unregister() is not called.
>> >> >> > 
>> >> >> > ethtool was able to get a reference on the devlink instance before it
>> >> >> > was registered because netdevsim registers its netdevs before
>> >> >> > registering its devlink instance. However, netdevsim is not the only one
>> >> >> > doing this: funeth, ice, prestera, mlx4, mlxsw, nfp and potentially
>> >> >> > others do the same thing.
>> >> >> > 
>> >> >> > When you think about it, it's strange that it's even possible for
>> >> >> > ethtool to reach the driver when the netdev used in the request is long
>> >> >> > gone, but it's not holding a reference on the netdev (it's holding a
>> >> >> > reference on the devlink instance instead) and
>> >> >> > devlink_compat_running_version() is called without RTNL.
>> >> >> 
>> >> >> Indeed. We did a bit of a flip-flop with the devlink locking rules
>> >> >> and the fact that the instance is reachable before it is registered 
>> >> >> is a leftover from a previous restructuring :(
>> >> >> 
>> >> >> Hence my preference to get rid of the ordering at the driver level 
>> >> >> than to try to patch it up in the code. Dunno if that's convincing.
>> >> >
>> >> >I don't have a good solution, but changing all the drivers to register
>> >> >their netdevs after the devlink instance is going to be quite painful
>> >> >and too big for 'net'. I feel like the main motivation for this is the
>> >> >ethtool compat stuff, which is not very convincing IMO. I'm quite happy
>> >> >with the current flow where drivers call devlink_register() at the end
>> >> >of their probe.
>> >> >
>> >> >Regarding a solution for the current crash, assuming we agree it's not a
>> >> >netdevsim specific problem, I think the current fix [1] is OK. Note that
>> >> >while it fixes the crash, it potentially creates other (less severe)
>> >> >problems. After user space receives RTM_NEWLINK notification it will
>> >> >need to wait for a certain period of time before issuing
>> >> >'ETHTOOL_GDRVINFO' as otherwise it will not get the firmware version. I
>> >> >guess it's not a big deal for drivers that only register one netdev
>> >> >since they will very quickly follow with devlink_register(), but the
>> >> >race window is larger for drivers that need to register many netdevs,
>> >> >for either physical switch or eswitch ports.
>> >> >
>> >> >Long term, we either need to find a way to make the ethtool compat stuff
>> >> >work correctly or just get rid of it and have affected drivers implement
>> >> >the relevant ethtool operations instead of relying on devlink.
>> >> >
>> >> >[1] https://lore.kernel.org/netdev/20221122121048.776643-1-yangyingliang@huawei.com/
>> >> 
>> >> I just had a call with Ido. We both think that this might be a good
>> >> solution for -net to avoid the use after free.
>> >> 
>> >> For net-next, we eventually should change driver init flows to register
>> >> devlink instance first and only after that register devlink_port and
>> >> related netdevice. The ordering is important for the userspace app. For
>> >> example the init flow:
>> >> <- RTnetlink new netdev event
>> >> app sees devlink_port handle in IFLA_DEVLINK_PORT
>> >> -> query devlink instance using this handle
>> >> <- ENODEV
>> >> 
>> >> The instance is not registered yet.
>> >
>> >This is supposed to be handled by devlink_notify_register() which sends
>> >"delayed" notifications after devlink_register() is called.
>> >
>> >Unless something is broken, the scenario above shouldn't happen.
>> 
>> Nope, RTnetlink message for new netdev is not handled by that. It is
>> sent right away.
>
>And why don't you fix your new commit dca56c3038c3 ("net: expose devlink port over rtnetlink")
>to do not return devlink instance unless it is registered?
>
>Why is it correct to expose devlink port with not ready to use devlink
>instance?

It is not, but:
Devlink port which is "parent" of the netdev is registered. The netdev
is created with devlink_port registered and that it guaranteed to not
change during netdev lifetime. Therefore, it would be weird to have 2
RTnetlink events:
1. event of netdev being created without devlink port
2. event of netdev with devlink port
If that is what you suggest.

I'm working on a patchset that is making sure that the flow is always
1) devlink_register & netlink event
2) devlink_port_register & netlink event
3) netdev_register & netlink event

Always the same. That means during init, during reload, during port
split.
