Return-Path: <netdev+bounces-3415-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D9D8D706F6C
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 19:29:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9562A28153A
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 17:28:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9294831135;
	Wed, 17 May 2023 17:28:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 877B4442F
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 17:28:57 +0000 (UTC)
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A238BAD15
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 10:28:37 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-643846c006fso1007898b3a.0
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 10:28:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684344516; x=1686936516;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bNvuFg66sXQPK3EOVLXGTm61/pJNdTk0+xYlKhnjKTU=;
        b=IxBm8jnw2xqLa4R0eFNGBW0J8tbO0cjNpcOwglDA/S1x2ef2tEZtaeFziKw/r3Nvvk
         or36mfisZfcU2VRonAMvbYhdtRxqZu461Ydv9XhYtSxzqm3VdIiMOCiqD57pfDuMnady
         I+Hz1QyQbbEhGRNqZBvJGftI5ZNQJE5xr9rnRUhhqbJYKgwd1LX++gQjRi9xScoHl5S2
         YDP6gzB/K+Bv5dEFONUmb8vK1tP0IQD+1XGqesAVsDKV277H3/WLt/uPLzcfATbIe95u
         kHFb5RrE5dcXjN6I3NEbJWG6Mf2AoS7XoFvLGYRL6vn1aB52HHTyORJrScXYQrosNATV
         5ezQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684344516; x=1686936516;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bNvuFg66sXQPK3EOVLXGTm61/pJNdTk0+xYlKhnjKTU=;
        b=Fk1MWlZxU7ZJRq7/at4tpyWlv+QiC5WI5hyVdHOgUXPNmY1ME6jxBguWXnFeGwUQAn
         5AsbT1OKD4NFE4ZamHD6espuRyEJUTyGox0WgxbkuS1mLdrlXYUcDAcIgNi394L6iofg
         iwzUd30tcaaalV3zorOM6qoP60iWmkUL/D4wlsox2+EfH8a6liOfnpYTG6XndZBm1i5/
         pXWgS6l2VsOmRh/IHtlfHXbo1kztnmTUjvh0Q73fgDsjt3oUjCDOxHnhYY6pEiTeeh9e
         w8/NSmarDnDlhq5mGOXxsXCdlwGEW+OxQkWvwXLoNBCYtkX9bMbmVtrN1m1/wLI2sm27
         0l/g==
X-Gm-Message-State: AC+VfDyO5b1Z+4/g35xpj/Jn47h1mU1NuvB85GzGESRgcy8kcrSZvoAY
	dPUxmqB5PGagHZ+7aiDdgdk=
X-Google-Smtp-Source: ACHHUZ54D9X0zf41gtp3JHHGQkL13mS3Vy7UXfVtXa1vNzlHzDgvDRp3PY4/rpo0VqOqh8VyDroocA==
X-Received: by 2002:a05:6a00:1486:b0:64a:fa71:a990 with SMTP id v6-20020a056a00148600b0064afa71a990mr589384pfu.25.1684344515608;
        Wed, 17 May 2023 10:28:35 -0700 (PDT)
Received: from [192.168.0.4] ([182.213.254.91])
        by smtp.gmail.com with ESMTPSA id d9-20020aa78e49000000b0064afac8d6c7sm8447011pfr.175.2023.05.17.10.28.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 May 2023 10:28:35 -0700 (PDT)
Message-ID: <6701e21c-a430-6309-bc13-dcff529d8ab5@gmail.com>
Date: Thu, 18 May 2023 02:28:29 +0900
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH net v2] net: fix stack overflow when LRO is disabled for
 virtual interfaces
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
 jiri@resnulli.us, j.vosburgh@gmail.com, andy@greyhouse.net,
 netdev@vger.kernel.org, jarod@redhat.com, razor@blackwall.org,
 simon.horman@corigine.com, wangyufen@huawei.com,
 syzbot+60748c96cf5c6df8e581@syzkaller.appspotmail.com
References: <20230517143010.3596250-1-ap420073@gmail.com>
 <20230517091511.30cc0803@kernel.org>
Content-Language: en-US
From: Taehee Yoo <ap420073@gmail.com>
In-Reply-To: <20230517091511.30cc0803@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 5/18/23 01:15, Jakub Kicinski wrote:

Hi Jakub,
Thank you so much for the review!

 > On Wed, 17 May 2023 14:30:10 +0000 Taehee Yoo wrote:
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
 >
 > Why doesn't the (already synchronized) upper not skip the update?

The skipping logic of this is existing in the netdev_sync_lower_features().
The purpose of this is to synchronize the lower interfaces, not the 
upper interface.
Actually, there is no upper-only synchronization logic.

Both bonding and team interfaces rely on notification mechanisms to work 
their own logic such as synchronization.
The notification is a broadcasting mechanism.
So, both lower and upper receive this event, and it works its own 
notification handling.
But the notification mechanism currently doesn't have options such as 
filtering and these interfaces receive this event with updated feature 
flags.
So, the upper interface can't distinguish whether the received event is 
the first event or duplicated event.

 >
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
 >> In order to fix it, the notifier_ctx member of bonding/team is 
introduced.
 >

Thank you so much!
Taehee Yoo

