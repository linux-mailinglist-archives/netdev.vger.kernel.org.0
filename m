Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4104756A992
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 19:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236154AbiGGR0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 13:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235803AbiGGR0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 13:26:40 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B2E65721F
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 10:26:38 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id y8so18269130eda.3
        for <netdev@vger.kernel.org>; Thu, 07 Jul 2022 10:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:user-agent:in-reply-to:references
         :message-id:mime-version:content-transfer-encoding;
        bh=3LZxcQs9nOMkFoDos2+PgU3t6nZSk06DoiTQtWvijMk=;
        b=wUfdehM4WiupWRrJlT/Hxm6rzZgFZZSVUTcXcsGx5Z6aCq0BRBsQnvHtQValrPkRdT
         Ei0yruYzS+D2av84NoQ+xq3KPhNQLFH9vwI2nbpEj+6ndn1fpaL1Am6ctGiS89Ej1qis
         e6DyqA2NXmDUWlw9lwuHo3iSFGYQVZwsMlTzqJu5ZPnhLN5zK6qpxeWpokt5FE3QgOjB
         aBhMD3AwZ5OGOguAGSguB7t2z7JiQ/VYPt4Ff8IH3z6/olNS2rHzItkgR4PaUvXSkMl6
         xUjEY3/FgLD7k38wfk2c0FQKYUpqjd5cJD0tXbBxdv/gDXJbUIc6GoHuFUZXLwomcu3f
         MJGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:user-agent:in-reply-to
         :references:message-id:mime-version:content-transfer-encoding;
        bh=3LZxcQs9nOMkFoDos2+PgU3t6nZSk06DoiTQtWvijMk=;
        b=oYfobx3T8TylPVH6Z+4R/avV9hLSkGS6Qci6NtcRheipvar6JyHWFua6iWyF4/kmMf
         2OBVlwJsUxc/DBTUGBJEC9KgVewitVx0bqd2qM0qfKgjzo9MF0U4ZzHdWV6P4IXhDKzU
         MgvC3TI6G4WUi815tPSApUlwCH5M09MhZ676daL1jAZOFW/V54HOGZbxaXpmmJHUN29u
         xNEL5UfwBXVpryRDioH0XxsNGO/u02KXWAk6/FA/ueIOVB8psXp8vpxEpz9ydCDQEKJl
         It+zdNpDLT8NfUVEfywYIQAA+SRgAc3DmtVN41IYNAgtVX9Aq8Eifkz9C9WF2sQmBQqe
         W+QQ==
X-Gm-Message-State: AJIora9zFR7oSt8s4W6VYBg5VZHvTmQvQ3mVDg4ZCfXtLMakkMDX1On0
        ZChhWKAMjP4p79FRD4q+dQe1AA==
X-Google-Smtp-Source: AGRyM1u12ybciGXsCapwSAqPM5BzxbOHsPWUV81XgBJottPf//sBeZ4RHpZ67iJUA/HNVpYN0jzC+Q==
X-Received: by 2002:aa7:cc03:0:b0:435:5574:bf30 with SMTP id q3-20020aa7cc03000000b004355574bf30mr62912119edt.15.1657214796964;
        Thu, 07 Jul 2022 10:26:36 -0700 (PDT)
Received: from [127.0.0.1] ([93.123.70.11])
        by smtp.gmail.com with ESMTPSA id k12-20020a17090666cc00b007041e969a8asm19241282ejp.97.2022.07.07.10.26.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Jul 2022 10:26:36 -0700 (PDT)
Date:   Thu, 07 Jul 2022 20:26:33 +0300
From:   Nikolay Aleksandrov <razor@blackwall.org>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Hans Schultz <schultz.hans@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>, Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_V3_net-next_1/4=5D_net=3A_bridge=3A_?= =?US-ASCII?Q?add_fdb_flag_to_extent_locked_port_feature?=
User-Agent: K-9 Mail for Android
In-Reply-To: <20220707171507.pojkwqhwqk5u6mmn@skbuf>
References: <b78fb006-04c4-5a25-7ba5-94428cc9591a@blackwall.org> <86fskyggdo.fsf@gmail.com> <040a1551-2a9f-18d0-9987-f196bb429c1b@blackwall.org> <86v8tu7za3.fsf@gmail.com> <4bf1c80d-0f18-f444-3005-59a45797bcfd@blackwall.org> <20220706181316.r5l5rzjysxow2j7l@skbuf> <7cf30a3e-a562-d582-4391-072a2c98ab05@blackwall.org> <20220706202130.ehzxnnqnduaq3rmt@skbuf> <fe456fb0-4f68-f93e-d4a9-66e3bc56d547@blackwall.org> <37d59561-6ce8-6c5f-5d31-5c37a0a3d231@blackwall.org> <20220707171507.pojkwqhwqk5u6mmn@skbuf>
Message-ID: <01FCBF77-AD39-4A0F-93AC-629E7269D950@blackwall.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7 July 2022 20:15:07 EEST, Vladimir Oltean <olteanv@gmail=2Ecom> wrote:
>Hi Nikolay,
>
>On Thu, Jul 07, 2022 at 05:08:15PM +0300, Nikolay Aleksandrov wrote:
>> On 07/07/2022 00:01, Nikolay Aleksandrov wrote:
>> > On 06/07/2022 23:21, Vladimir Oltean wrote:
>> >> On Wed, Jul 06, 2022 at 10:38:04PM +0300, Nikolay Aleksandrov wrote:
>> [snip]
>> > I already said it's ok to add hard configurable limits if they're don=
e properly performance-wise=2E
>> > Any distribution can choose to set some default limits after the opti=
on exists=2E
>> >=20
>>=20
>> Just fyi, and to avoid duplicate efforts, I already have patches for gl=
obal and per-port software
>> fdb limits that I'll polish and submit soon (depending on time availabi=
lity, of course)=2E If I find
>> more time I might add per-vlan limits as well to the set=2E They use em=
bedded netlink attributes
>> to config and dump, so we can easily extend them later (e=2Eg=2E differ=
ent action on limit hit, limit
>> statistics etc)=2E
>
>So again, to repeat myself, it's nice to have limits on FDB size, but
>those won't fix the software bridges that are now out in the open and
>can't have their configuration scripts changed=2E
>
>I haven't had the time to expand on this in a proper change yet, but I
>was thinking more along the lines of adding an OOM handler with
>register_oom_notifier() in br_fdb_init(), and on OOM, do something, like
>flush the FDB from all bridges=2E There are going to be complications, it
>will schedule switchdev, switchdev is going to allocate memory which
>we're low on, the workqueues aren't created with WQ_MEM_RECLAIM, so this
>isn't necessarily going to be a silver bullet either=2E But this is what
>concerns me the most, the unconfigured bridge killing the kernel so
>easily=2E As you can see, with an OOM handler I'm not so much trying to
>impose a fixed limit on FDB size, but do something sensible such that
>the bridge doesn't contribute to the kernel dying=2E

Hi Vladimir,
Sounds good to me, the fdb limits have come up multiple times in the past =
so I decided=20
to finally add them and build from there, with them configured oom shouldn=
't be hit=2E
These limits have never been present and people are fine (everyone deals w=
ith or leaves it), but I'll be happy to review and ack such changes=2E I ho=
pe you can correlate the oom and the bridge fdbs, not
just blindly flushing as that can be problematic if you plan to have it en=
abled by default=2E

Cheers,
  Nik
