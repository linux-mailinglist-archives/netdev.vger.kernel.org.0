Return-Path: <netdev+bounces-3379-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BB8B2706C0C
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 17:03:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 49AD2280EB9
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 15:03:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86D377490;
	Wed, 17 May 2023 15:03:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 753FB5CBA
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 15:03:43 +0000 (UTC)
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D348688
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 08:03:08 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-965e93f915aso159901966b.2
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 08:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20221208.gappssmtp.com; s=20221208; t=1684335732; x=1686927732;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KpMPmFJQJcizASSbwxpQaestxBgMOrvZ82xKYjbxyxs=;
        b=WbIJ0XHfZzb/1E2BTZcLdGoQl5EiHuqcs9gwO94aiD0kZ1Hv3bLcjqDt/YTFzUyXw6
         qDabvFmZtbJiHqADfrCG09uqbS1uuDYfe80UA5tRXT7dhONW8ECYIJr6R2+JgehFCScA
         giQRti/4c7vvWCGeHif0JGEkf4cDUNq56a7lmtbdXRMS2CTkQUKwrVnQC5esmMXfVVIg
         zRDoeincUELfyWvf3Stk95ku/+RMKrTtj6udAMvL0CEqW/Gb+BpGFALgqnrQDi4Epx2W
         HJy+gb8b9jT6mLk9vYXjU4b8XMful0itjroMYQL5t6ISnhTLh0lUn0XxeTR5+R+oBprA
         bPug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684335732; x=1686927732;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KpMPmFJQJcizASSbwxpQaestxBgMOrvZ82xKYjbxyxs=;
        b=cYtjBmhRZTP9HJSt5WNNzSU5FbRYsgZhcKs1/9o4y8P+7pTm4BMiSLiURKiFAU6Nms
         MqLx8a7BiM2kjQRWrPeJVs6xFjTJ4i3cm+EPw9YIXvy/3EH0HeIWIfDe4HsUIqpbCwsw
         w804/q5I6fyOEufsY8/YlyhI21jYJ3q84i3xKWBd+/MwpdixoZTK98zXXumbcVGt6epM
         vEQVDKArujpqCx5jPzBMAVxmeyxAoe+KAvXNZ/HyRWZRslU9nVmoUxlXqINZPe2vrXqS
         LZ8oQLIjiUzZsJsmiV00mH4BR2QkPnb3C61CHIN+ks6Z2vQzylk15iO1eL/0qDsIRCt/
         WN4g==
X-Gm-Message-State: AC+VfDyOR4WD0n4MN1CtDjvKTV3fTN42SKjLP6W0M5DNyZWAiuGQAKxV
	9SlWswSn3IaxaY4YtbXjUuzprQ==
X-Google-Smtp-Source: ACHHUZ6x6KqojxF+MVAVDwLjqcdM5fmlTNxRJBrHaEB6TII+DDFN40cAq1v8WtsJuHkA0y65OPv9FA==
X-Received: by 2002:a17:907:94c3:b0:969:e7da:fca0 with SMTP id dn3-20020a17090794c300b00969e7dafca0mr30244836ejc.8.1684335732221;
        Wed, 17 May 2023 08:02:12 -0700 (PDT)
Received: from [192.168.0.161] (62-73-72-43.ip.btc-net.bg. [62.73.72.43])
        by smtp.gmail.com with ESMTPSA id hy25-20020a1709068a7900b0096607baaf19sm12406288ejc.101.2023.05.17.08.02.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 May 2023 08:02:11 -0700 (PDT)
Message-ID: <1d5cd2bd-ed2a-0457-7fb8-1b876a68b451@blackwall.org>
Date: Wed, 17 May 2023 18:02:10 +0300
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH net v2] net: fix stack overflow when LRO is disabled for
 virtual interfaces
To: Taehee Yoo <ap420073@gmail.com>, davem@davemloft.net, kuba@kernel.org,
 pabeni@redhat.com, edumazet@google.com, jiri@resnulli.us,
 j.vosburgh@gmail.com, andy@greyhouse.net, netdev@vger.kernel.org
Cc: jarod@redhat.com, simon.horman@corigine.com, wangyufen@huawei.com,
 syzbot+60748c96cf5c6df8e581@syzkaller.appspotmail.com
References: <20230517143010.3596250-1-ap420073@gmail.com>
Content-Language: en-US
From: Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20230517143010.3596250-1-ap420073@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 17/05/2023 17:30, Taehee Yoo wrote:
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
> In order to fix it, the notifier_ctx member of bonding/team is introduced.
> 
> Reported-by: syzbot+60748c96cf5c6df8e581@syzkaller.appspotmail.com
> Fixes: fd867d51f889 ("net/core: generic support for disabling netdev features down stack")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> ---
> 
> v2:
>  - Add new member to struct bonding/team instead of the net_device.
> 
>  drivers/net/bonding/bond_main.c | 8 +++++++-
>  drivers/net/team/team.c         | 7 ++++++-
>  include/linux/if_team.h         | 1 +
>  include/net/bonding.h           | 1 +
>  4 files changed, 15 insertions(+), 2 deletions(-)
> 
LGTM
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>



