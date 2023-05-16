Return-Path: <netdev+bounces-2974-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 25756704C5A
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 13:29:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2889B1C20BC7
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 11:29:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F43024EA2;
	Tue, 16 May 2023 11:29:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1418C34CEB
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 11:29:47 +0000 (UTC)
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A43C8A3
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 04:29:45 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 41be03b00d2f7-52c30fa5271so7557297a12.0
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 04:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684236585; x=1686828585;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BfxSqqZmcWgo00eAwnyu/nT8L0b+b+LExJHoS9VvtXs=;
        b=lXbIPCWMYJefcVjM8apHC00s8bvnZC2knfuYEsQbmdpWSnua8hwnT4tTVYZwwOxjz9
         Icmy8GXLmix/Eb4dIhg64JIhbKWyhm+gwYujT5SbrH2hdXBGxZWBseqi3L0IyiqNJjv6
         fWG7aaVvC9Y6nziEC50FzkxqHzjhkP5YIRWJEjsgJUCmXuO3t48616+Fv9G3dhuO7Inm
         TJ3fbxX8gRlGPdOpKw1NnV3YGXMTREZkKBJl561pa1zZie53RuQm2cYDM2kCdRoie4E+
         V+0aWgc0gwg63SYaL6wIsbRJSFvrLVln7/B2yix5m9g1RUd+J4fEBvaYhSsVGYSad8u4
         yKPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684236585; x=1686828585;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BfxSqqZmcWgo00eAwnyu/nT8L0b+b+LExJHoS9VvtXs=;
        b=Aqny3gOee69B6MfWhUBBjVPvveoRhzE7C5+AQRqhdgxF8LBl9oP6dcuEgkTvLs8bLM
         KoLLnfM75pvfgigPW/azhVBOuMpPMFbWbzSMPMVhJ/wAk8B8wJ0gOjI5vrKtTdDWFUE9
         CQ8bLfCkjuf9eE2Y2p0DWoWFfmKafUgv2mJkxGusNWmrBJ+o2MLSV9M+rFMHn94JvClm
         opsAVcsiXSoekZ/wsxhPrmOJsNUyy5H1tlFhgGNmUI94ha7plUmxbnHUu30XDDlCMjNy
         w8nKlh+PVT7XTpzJo8UcnB2HvME1PmEjFE1jRztudPBZYlN6A2Puab0tU+BuqFnggneZ
         LTUw==
X-Gm-Message-State: AC+VfDwMUBGbTa3XXE3CnbLkCG2paqcR2cGrmkHjdAhgO3LMldjyzEgn
	i8bbOZcF825ksd/tp4YHJ8E=
X-Google-Smtp-Source: ACHHUZ4Ifu0XUjFKADfdj2dmIi/PyLJsArJgdzMViM17KNIN0HN5WKQysdvXnvBSXU8ePeZ8ZfiJZg==
X-Received: by 2002:a17:902:f543:b0:1ac:6084:1f4 with SMTP id h3-20020a170902f54300b001ac608401f4mr47440908plf.27.1684236584947;
        Tue, 16 May 2023 04:29:44 -0700 (PDT)
Received: from [192.168.0.4] ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id d10-20020a170902854a00b001a6e5c2ebfesm15262161plo.152.2023.05.16.04.29.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 May 2023 04:29:44 -0700 (PDT)
Message-ID: <41942532-462e-fa1d-d9a4-eeb26abc481f@gmail.com>
Date: Tue, 16 May 2023 20:29:39 +0900
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net] net: fix stack overflow when LRO is disabled for
 virtual interfaces
To: Paolo Abeni <pabeni@redhat.com>, Nikolay Aleksandrov
 <razor@blackwall.org>, davem@davemloft.net, kuba@kernel.org,
 edumazet@google.com, jiri@resnulli.us, j.vosburgh@gmail.com,
 andy@greyhouse.net, netdev@vger.kernel.org
Cc: jarod@redhat.com, wangyufen@huawei.com,
 syzbot+60748c96cf5c6df8e581@syzkaller.appspotmail.com
References: <20230515053740.3065735-1-ap420073@gmail.com>
 <eeff656b-22ac-082d-9b94-62980e806f0f@blackwall.org>
 <52da9cd3-508f-eb7d-98b3-cd777acc90eb@gmail.com>
 <813be3bd0823bac31dc1b018750fad29d794d9c2.camel@redhat.com>
Content-Language: en-US
From: Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <813be3bd0823bac31dc1b018750fad29d794d9c2.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/16/23 17:34, Paolo Abeni wrote:

Hi Paolo,
Thank you so much for the review!

 > On Mon, 2023-05-15 at 18:12 +0900, Taehee Yoo wrote:
 >> On 5/15/23 15:24, Nikolay Aleksandrov wrote:
 >>   > On 15/05/2023 08:37, Taehee Yoo wrote:
 >>   >> When the virtual interface's feature is updated, it 
synchronizes the
 >>   >> updated feature for its own lower interface.
 >>   >> This propagation logic should be worked as the iteration, not
 >> recursively.
 >>   >> But it works recursively due to the netdev notification 
unexpectedly.
 >>   >> This problem occurs when it disables LRO only for the team and 
bonding
 >>   >> interface type.
 >>   >>
 >>   >>         team0
 >>   >>           |
 >>   >>    +------+------+-----+-----+
 >>   >>    |      |      |     |     |
 >>   >> team1  team2  team3  ...  team200
 >>   >>
 >>   >> If team0's LRO feature is updated, it generates the 
NETDEV_FEAT_CHANGE
 >>   >> event to its own lower interfaces(team1 ~ team200).
 >>   >> It is worked by netdev_sync_lower_features().
 >>   >> So, the NETDEV_FEAT_CHANGE notification logic of each lower 
interface
 >>   >> work iteratively.
 >>   >> But generated NETDEV_FEAT_CHANGE event is also sent to the upper
 >>   >> interface too.
 >>   >> upper interface(team0) generates the NETDEV_FEAT_CHANGE event for
 >> its own
 >>   >> lower interfaces again.
 >>   >> lower and upper interfaces receive this event and generate this
 >>   >> event again and again.
 >>   >> So, the stack overflow occurs.
 >>   >>
 >>   >> But it is not the infinite loop issue.
 >>   >> Because the netdev_sync_lower_features() updates features before
 >>   >> generating the NETDEV_FEAT_CHANGE event.
 >>   >> Already synchronized lower interfaces skip notification logic.
 >>   >> So, it is just the problem that iteration logic is changed to the
 >>   >> recursive unexpectedly due to the notification mechanism.
 >>   >>
 >>   >> Reproducer:
 >>   >>
 >>   >> ip link add team0 type team
 >>   >> ethtool -K team0 lro on
 >>   >> for i in {1..200}
 >>   >> do
 >>   >>          ip link add team$i master team0 type team
 >>   >>          ethtool -K team$i lro on
 >>   >> done
 >>   >>
 >>   >> ethtool -K team0 lro off
 >>   >>
 >>   >> In order to fix it, the priv_notifier_ctx net_device member is
 >> introduced.
 >>   >> This variable can be used by each interface in its own way in the
 >>   >> notification context. The bonding and team interface is going 
to use it
 >>   >> to avoid duplicated NETDEV_FEAT_CHANGE event handling.
 >>   >>
 >>   >> Reported-by: syzbot+60748c96cf5c6df8e581@syzkaller.appspotmail.com
 >>   >> Fixes: fd867d51f889 ("net/core: generic support for disabling 
netdev
 >> features down stack")
 >>   >> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
 >>   >> ---
 >>   >>   drivers/net/bonding/bond_main.c | 6 +++++-
 >>   >>   drivers/net/team/team.c         | 6 +++++-
 >>   >>   include/linux/netdevice.h       | 1 +
 >>   >>   net/core/dev.c                  | 2 ++
 >>   >>   4 files changed, 13 insertions(+), 2 deletions(-)
 >>   >>
 >>   >
 >>   > Since you're syncing to lower devices, can't you check if the event
 >> source device
 >>   > is lower to the current one (i.e. reverse propagation has happened)
 >> in the affected
 >>   > drivers ? Adding a new struct netdevice member just for this seems
 >> unnecessary to me.
 >>   > Especially for a setup like a bond of bonds or a team of teams, 
these
 >> are corner case
 >>   > setups that shouldn't exist in general. :)
 >>   >
 >>
 >> I agree that this new variable is unnecessary right now.
 >> I tried to avoid introducing new variables, but unfortunately, I
 >> couldn't find a solution to detect duplicated notification events.
 >>
 >> The reason why I introduced the new member of the net_device is that I
 >> thought there might be similar problems in the future such as mtu.
 >> so, I hoped that it can be used as a general variable to avoid similar
 >> problems.
 >> But I really agree that this new variable is over-spec.
 >> So, adding a new boolean variable into the struct bonding and team, not
 >> net_device would be reasonable if I can't find a proper solution.
 >
 > I think adding a bool variable to bonding/team priv would be better, as
 > it looks like the issues is specific to such kind of devices.
 >

Thanks, I will add a bool variable to the bonding and team struct in the v2.

Thank you so much!
Taehee Yoo

 > Thanks!
 >
 > Paolo
 >

