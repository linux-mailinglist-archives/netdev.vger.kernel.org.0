Return-Path: <netdev+bounces-2556-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8054A702805
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 11:13:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 446062811DE
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 09:13:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80AC08BFC;
	Mon, 15 May 2023 09:13:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E41CA92D
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 09:13:17 +0000 (UTC)
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1F03AB8
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 02:12:58 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 41be03b00d2f7-53063897412so5150937a12.0
        for <netdev@vger.kernel.org>; Mon, 15 May 2023 02:12:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684141978; x=1686733978;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9oc1Fsf2vA8ydGoDt7QAfTSLvQVD6GiPLNbjp0Zno0Y=;
        b=r1EQ/Y3atxSqeWoLMmNCzZN0+L+Jfv/iB+vihlj2BVmIs/v8IX+oQrTvsUKtfLZYQi
         iFASIbuiZOSBXNUycQbFFhUEyV0l3vKU1bD3dC5sVPvvcUIs7wHULUuORkpdn6jAoW1R
         QqENKbpUMUO6uTti1Ynaast8YQttCTVRsoKRWNBmh/39o1YVrpWuXiJ9cKLC1nppSrt0
         Lm8nu5nd6dR3otF0dAxxlz40FMWFi5Y24xtEFGiHEvtOBE7MR+V+ezIpg7E37p/SQqUw
         j+DmqUW84B7cMI2d3Yo0ctUzgcAeuiG6ZrAakulZRJtsHAHi6A6gZvXnXRJz646WUnJx
         X5fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684141978; x=1686733978;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9oc1Fsf2vA8ydGoDt7QAfTSLvQVD6GiPLNbjp0Zno0Y=;
        b=IIlWD2sA3fKS48ZFfAha2XZKATsu3hgXxVuKNk01kh0vbkLueeokOgtsxk9rCPQTEo
         mlnaevnulHChJDai0rl+/o4U1xUnhno0H0soClaIevmJnhzzABBzNH9bGpnZyewfYU5a
         BDb3S8Ofa1BgrKr04lx3cgoowkgWQ2I1ykLDV0lq2uCroXaZC6+8YAz5Pzbk8hCLJIPk
         LPPJMC39BieUGRiZQspysx6z0GH97DRXXFPVI6UlewLMvWnhPxSEN2Lfl7txq0hMPXmB
         K9TCHBavdpl3YYNGrLKZVUsWTSe6YcYb5GQL50KWQMbnR6wVX+Ij/qdUxRlpUQsjX9yk
         W5+A==
X-Gm-Message-State: AC+VfDwLyq0UkXPknihpUz9JLpB2z5l+63BI5FSEbxZynF67KKZVlKpR
	Q9GK3418apsW5wArK0fcVvY=
X-Google-Smtp-Source: ACHHUZ7QyvpW75EdUOxlEq/pNatZry6pEL47uncfwBMuwRY8jYcItR8CvcMqJeGwTCIDsYd3yqvcCQ==
X-Received: by 2002:a17:902:ec92:b0:1ac:aba5:7885 with SMTP id x18-20020a170902ec9200b001acaba57885mr24108956plg.47.1684141977726;
        Mon, 15 May 2023 02:12:57 -0700 (PDT)
Received: from [192.168.0.4] ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id i12-20020a17090332cc00b001aaf5dcd762sm12909696plr.214.2023.05.15.02.12.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 May 2023 02:12:57 -0700 (PDT)
Message-ID: <52da9cd3-508f-eb7d-98b3-cd777acc90eb@gmail.com>
Date: Mon, 15 May 2023 18:12:52 +0900
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net] net: fix stack overflow when LRO is disabled for
 virtual interfaces
To: Nikolay Aleksandrov <razor@blackwall.org>, davem@davemloft.net,
 kuba@kernel.org, pabeni@redhat.com, edumazet@google.com, jiri@resnulli.us,
 j.vosburgh@gmail.com, andy@greyhouse.net, netdev@vger.kernel.org
Cc: jarod@redhat.com, wangyufen@huawei.com,
 syzbot+60748c96cf5c6df8e581@syzkaller.appspotmail.com
References: <20230515053740.3065735-1-ap420073@gmail.com>
 <eeff656b-22ac-082d-9b94-62980e806f0f@blackwall.org>
Content-Language: en-US
From: Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <eeff656b-22ac-082d-9b94-62980e806f0f@blackwall.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 5/15/23 15:24, Nikolay Aleksandrov wrote:

Hi Nikolay,
Thank you so much for the review!

 > On 15/05/2023 08:37, Taehee Yoo wrote:
 >> When the virtual interface's feature is updated, it synchronizes the
 >> updated feature for its own lower interface.
 >> This propagation logic should be worked as the iteration, not 
recursively.
 >> But it works recursively due to the netdev notification unexpectedly.
 >> This problem occurs when it disables LRO only for the team and bonding
 >> interface type.
 >>
 >>         team0
 >>           |
 >>    +------+------+-----+-----+
 >>    |      |      |     |     |
 >> team1  team2  team3  ...  team200
 >>
 >> If team0's LRO feature is updated, it generates the NETDEV_FEAT_CHANGE
 >> event to its own lower interfaces(team1 ~ team200).
 >> It is worked by netdev_sync_lower_features().
 >> So, the NETDEV_FEAT_CHANGE notification logic of each lower interface
 >> work iteratively.
 >> But generated NETDEV_FEAT_CHANGE event is also sent to the upper
 >> interface too.
 >> upper interface(team0) generates the NETDEV_FEAT_CHANGE event for 
its own
 >> lower interfaces again.
 >> lower and upper interfaces receive this event and generate this
 >> event again and again.
 >> So, the stack overflow occurs.
 >>
 >> But it is not the infinite loop issue.
 >> Because the netdev_sync_lower_features() updates features before
 >> generating the NETDEV_FEAT_CHANGE event.
 >> Already synchronized lower interfaces skip notification logic.
 >> So, it is just the problem that iteration logic is changed to the
 >> recursive unexpectedly due to the notification mechanism.
 >>
 >> Reproducer:
 >>
 >> ip link add team0 type team
 >> ethtool -K team0 lro on
 >> for i in {1..200}
 >> do
 >>          ip link add team$i master team0 type team
 >>          ethtool -K team$i lro on
 >> done
 >>
 >> ethtool -K team0 lro off
 >>
 >> In order to fix it, the priv_notifier_ctx net_device member is 
introduced.
 >> This variable can be used by each interface in its own way in the
 >> notification context. The bonding and team interface is going to use it
 >> to avoid duplicated NETDEV_FEAT_CHANGE event handling.
 >>
 >> Reported-by: syzbot+60748c96cf5c6df8e581@syzkaller.appspotmail.com
 >> Fixes: fd867d51f889 ("net/core: generic support for disabling netdev 
features down stack")
 >> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
 >> ---
 >>   drivers/net/bonding/bond_main.c | 6 +++++-
 >>   drivers/net/team/team.c         | 6 +++++-
 >>   include/linux/netdevice.h       | 1 +
 >>   net/core/dev.c                  | 2 ++
 >>   4 files changed, 13 insertions(+), 2 deletions(-)
 >>
 >
 > Since you're syncing to lower devices, can't you check if the event 
source device
 > is lower to the current one (i.e. reverse propagation has happened) 
in the affected
 > drivers ? Adding a new struct netdevice member just for this seems 
unnecessary to me.
 > Especially for a setup like a bond of bonds or a team of teams, these 
are corner case
 > setups that shouldn't exist in general. :)
 >

I agree that this new variable is unnecessary right now.
I tried to avoid introducing new variables, but unfortunately, I 
couldn't find a solution to detect duplicated notification events.

The reason why I introduced the new member of the net_device is that I 
thought there might be similar problems in the future such as mtu.
so, I hoped that it can be used as a general variable to avoid similar 
problems.
But I really agree that this new variable is over-spec.
So, adding a new boolean variable into the struct bonding and team, not 
net_device would be reasonable if I can't find a proper solution.

Yes, the above interface graph is not a real-world case.
The purpose of the above is just to trigger stack overflow problems for 
anyone with just copy-and-paste to make it easy for testing.
It can't reproduce this problem with LRO non-support virtual interfaces 
such as dummy, VLAN, and others.
we can reproduce this problem with a team and bonding interface, so I 
used team over team as a reproducer.

I will send a v2 patch after trying to find better solution for days, 
which would not introduce the new member of net_device.
If I can't find it, v2 would introduce a new member into struct bonding 
and struct team.
Of course, any ideas are welcome!

Thank you so much!
Taehee Yoo

 > Cheers,
 >   Nik
 >

