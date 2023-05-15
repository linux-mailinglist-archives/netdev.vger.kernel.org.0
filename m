Return-Path: <netdev+bounces-2507-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 18133702486
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 08:24:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B4E161C2094F
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 06:24:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1B305225;
	Mon, 15 May 2023 06:24:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B544223D5
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 06:24:27 +0000 (UTC)
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EFAAFC
	for <netdev@vger.kernel.org>; Sun, 14 May 2023 23:24:18 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id 4fb4d7f45d1cf-50bceaf07b8so22488219a12.3
        for <netdev@vger.kernel.org>; Sun, 14 May 2023 23:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20221208.gappssmtp.com; s=20221208; t=1684131856; x=1686723856;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AlGd8Y2526aXfQSeNLRdc/Yk4Nx8zQxyZKpB/XCu50U=;
        b=pzTXC4mPBEFgockDzB41xH6dVKhCVTufUUzM/fFPC3ggPDQAW8R3Y7INT90hslPi6a
         mUDVRAdF1mOLy10Q6mgDDjJuDFLWiCW233zX2CebLLRkTCuzDVpdvs1yHx8kPrf4Mb4/
         u77ocFO2xc+dIJVcpZMKAK6ptVRFulWcNvHelHtaViXNYGraEZCGZg3KoefI+Mw8pSxq
         ABNRx2KNbkOM9Rdm3qYxGn5RvX0PzijbrZ1WJjVRUsHBMGHywTs8cZ6kBB4P+il0aq9N
         gzw0hiurVJ8mKSGFTHJiwwbpb8lQQTeQNODL9kr0sC5kU04OUGHzgRdz6eCuAVwvWl46
         mtoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684131856; x=1686723856;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AlGd8Y2526aXfQSeNLRdc/Yk4Nx8zQxyZKpB/XCu50U=;
        b=ZmrZXdWAPnpQfNW7aFEOX50zNTC7v/sxYHOQrPxWOPJqU3a7j/Nx5Tdz20JxHdQ9kA
         JOeXnmhCWx23M7tGbPHZBQUBhT9TB3wuH6kVJzozalrKgfZsjd1i77AWvIyQMg/7dRI4
         Rc+rLNUDDCeBkw7MPcfkbOUPZL9QNuVPUtIwMyQHQ4T/E4w4ZQmnUXbSpU4CR6DfJoLb
         kHBwF6so9M88yJdydC01rL5UvXXucJ3ky63bzbh0nJUmp6uB6yjiX+96WECYMOBfBXlH
         XQXj8ixWBjfUPwdu2v/lBSLeQiJi3eLCIVT9ZiX3pLLwguFaki9RI+nZYUzIheQZFPYe
         wCVQ==
X-Gm-Message-State: AC+VfDwLvMFSUI8ApibCdbbTICxHtmoTkA40Ed/mpCnTgMazAGI3HSar
	6NlB7PsTMrkFrd0hf2rgG8p2lw==
X-Google-Smtp-Source: ACHHUZ5Ml7zP7k3FAM1esmHpTO9994nBGpTR4CkZaldQAicfUEtMO9pfCswuezUQBOBatFx0GiMXaw==
X-Received: by 2002:aa7:c603:0:b0:50d:e0d8:cf31 with SMTP id h3-20020aa7c603000000b0050de0d8cf31mr11812601edq.21.1684131856309;
        Sun, 14 May 2023 23:24:16 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id s15-20020a056402164f00b0050d56dffc93sm7015907edx.12.2023.05.14.23.24.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 14 May 2023 23:24:15 -0700 (PDT)
Message-ID: <eeff656b-22ac-082d-9b94-62980e806f0f@blackwall.org>
Date: Mon, 15 May 2023 09:24:14 +0300
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
Content-Language: en-US
To: Taehee Yoo <ap420073@gmail.com>, davem@davemloft.net, kuba@kernel.org,
 pabeni@redhat.com, edumazet@google.com, jiri@resnulli.us,
 j.vosburgh@gmail.com, andy@greyhouse.net, netdev@vger.kernel.org
Cc: jarod@redhat.com, wangyufen@huawei.com,
 syzbot+60748c96cf5c6df8e581@syzkaller.appspotmail.com
References: <20230515053740.3065735-1-ap420073@gmail.com>
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230515053740.3065735-1-ap420073@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 15/05/2023 08:37, Taehee Yoo wrote:
> When the virtual interface's feature is updated, it synchronizes the
> updated feature for its own lower interface.
> This propagation logic should be worked as the iteration, not recursively.
> But it works recursively due to the netdev notification unexpectedly.
> This problem occurs when it disables LRO only for the team and bonding
> interface type.
> 
>        team0
>          |
>   +------+------+-----+-----+
>   |      |      |     |     |
> team1  team2  team3  ...  team200
> 
> If team0's LRO feature is updated, it generates the NETDEV_FEAT_CHANGE
> event to its own lower interfaces(team1 ~ team200).
> It is worked by netdev_sync_lower_features().
> So, the NETDEV_FEAT_CHANGE notification logic of each lower interface
> work iteratively.
> But generated NETDEV_FEAT_CHANGE event is also sent to the upper
> interface too.
> upper interface(team0) generates the NETDEV_FEAT_CHANGE event for its own
> lower interfaces again.
> lower and upper interfaces receive this event and generate this
> event again and again.
> So, the stack overflow occurs.
> 
> But it is not the infinite loop issue.
> Because the netdev_sync_lower_features() updates features before
> generating the NETDEV_FEAT_CHANGE event.
> Already synchronized lower interfaces skip notification logic.
> So, it is just the problem that iteration logic is changed to the
> recursive unexpectedly due to the notification mechanism.
> 
> Reproducer:
> 
> ip link add team0 type team
> ethtool -K team0 lro on
> for i in {1..200}
> do
>         ip link add team$i master team0 type team
>         ethtool -K team$i lro on
> done
> 
> ethtool -K team0 lro off
> 
> In order to fix it, the priv_notifier_ctx net_device member is introduced.
> This variable can be used by each interface in its own way in the
> notification context. The bonding and team interface is going to use it
> to avoid duplicated NETDEV_FEAT_CHANGE event handling.
> 
> Reported-by: syzbot+60748c96cf5c6df8e581@syzkaller.appspotmail.com
> Fixes: fd867d51f889 ("net/core: generic support for disabling netdev features down stack")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> ---
>  drivers/net/bonding/bond_main.c | 6 +++++-
>  drivers/net/team/team.c         | 6 +++++-
>  include/linux/netdevice.h       | 1 +
>  net/core/dev.c                  | 2 ++
>  4 files changed, 13 insertions(+), 2 deletions(-)
> 

Since you're syncing to lower devices, can't you check if the event source device
is lower to the current one (i.e. reverse propagation has happened) in the affected
drivers ? Adding a new struct netdevice member just for this seems unnecessary to me.
Especially for a setup like a bond of bonds or a team of teams, these are corner case
setups that shouldn't exist in general. :)

Cheers,
 Nik


