Return-Path: <netdev+bounces-1334-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3826C6FD699
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 08:11:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B1482813F6
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 06:11:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CECEF568C;
	Wed, 10 May 2023 06:11:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A8919918
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 06:11:48 +0000 (UTC)
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1ED89B0
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 23:11:44 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id 5b1f17b1804b1-3f42c865534so14315305e9.2
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 23:11:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1683699103; x=1686291103;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6i0PMJItVOSE+atKqxWmIhjkSinnarAoOBf0GiTMhk0=;
        b=NwkJ6GO7ILlv0uo4OR367sQ2zTmqAWA97ogybK8zqiu6Vcpw5MzGCZPe8LhX+h0WqN
         kZ83wGF1ON37XfK+/1KRu14h3+yRMXE3CThrGGYTX7whC3VFR+qVU3I+onJJeBVc6FAS
         fD0MSnbngpkA44Ow/CqlSDeeHR/GgAENi1tYdXD8uE85snDRVV8ST66UA+aDFXv3fVIk
         NDkkrV0zjwXlNRrJwvYVRQAYxGHUDQiqtzugWEiY9wMZhvDB/1QoWqKl1t0hbazCWnrE
         AfL2aqrDihB892jJ6irHxIAp1oiXKuj6tsCTCCQIScrpI8LrwiyrLGZfAgyYBwFeAjZw
         9hhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683699103; x=1686291103;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6i0PMJItVOSE+atKqxWmIhjkSinnarAoOBf0GiTMhk0=;
        b=PKE0rPOR8Fg6ZBal4CzhL21yeL0mngggSIhS5atbSb5j4QTwg0NKx9ysj8HLcBMD+S
         5AY1b4SOVTdt2jcY/kqqfWUfP4r/QGOF3vzamtdNyPT8aEGSBtc2GqRaEr+IAlu4MKZf
         PjJBU2ewddLukjTpcH4nXtaZjvOp4AAydsOqg44RZkVcNHd0LqEpk3XouQ6z67r07mnH
         eWIVm+9SNcFSENiZZBIzkk21jXdh8vW4LmKY4bgzZlZqW5aybUd3HysWLuD3AFRyWPRv
         Uz00i4wXEmelSJd3Hl5QM0D95t/REY1Ht5/BFGkUzeStCG6k4BqdCFhJxr4hhi70tyId
         IUxg==
X-Gm-Message-State: AC+VfDy6x8iKFpDtDfPc0Mj7Z+U2kpRrN/MjkuFcojdec2irlA0noCgE
	w1guYeUQ7UiCPVo6EQVFSx7GGAnAXY+ouIKaSkjaOg==
X-Google-Smtp-Source: ACHHUZ45UtEOFsegAlrsbPoxyr/NoCojVn0j91p1JqkwexdiyrSGvK+rU+EB4gJjxZo9HrIuqtkKuA==
X-Received: by 2002:a5d:6751:0:b0:307:7c2d:dc80 with SMTP id l17-20020a5d6751000000b003077c2ddc80mr11486944wrw.34.1683699103097;
        Tue, 09 May 2023 23:11:43 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id y18-20020a5d6212000000b0030796e103a1sm8033353wru.5.2023.05.09.23.11.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 23:11:42 -0700 (PDT)
Date: Wed, 10 May 2023 08:11:41 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, pabeni@redhat.com, davem@davemloft.net,
	edumazet@google.com, jacob.e.keller@intel.com, saeedm@nvidia.com,
	moshe@nvidia.com
Subject: Re: [patch net 3/3] devlink: fix a deadlock with nested instances
 during namespace remove
Message-ID: <ZFs1nezX0OiDg/1g@nanopsycho>
References: <20230509100939.760867-1-jiri@resnulli.us>
 <20230509202444.30436b9f@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509202444.30436b9f@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Wed, May 10, 2023 at 05:24:44AM CEST, kuba@kernel.org wrote:
>On Tue,  9 May 2023 12:09:36 +0200 Jiri Pirko wrote:
>> The commit 565b4824c39f ("devlink: change port event netdev notifier
>> from per-net to global") changed original per-net notifier to be global
>> which fixed the issue of non-receiving events of netdev uninit if that
>> moved to a different namespace. That worked fine in -net tree.
>> 
>> However, later on when commit ee75f1fc44dd ("net/mlx5e: Create
>> separate devlink instance for ethernet auxiliary device") and
>> commit 72ed5d5624af ("net/mlx5: Suspend auxiliary devices only in
>> case of PCI device suspend") were merged, a deadlock was introduced
>> when removing a namespace with devlink instance with another nested
>> instance.
>> 
>> Here there is the bad flow example resulting in deadlock with mlx5:
>> net_cleanup_work -> cleanup_net (takes down_read(&pernet_ops_rwsem) ->
>> devlink_pernet_pre_exit() -> devlink_reload() ->
>> mlx5_devlink_reload_down() -> mlx5_unload_one_devl_locked() ->
>> mlx5_detach_device() -> del_adev() -> mlx5e_remove() ->
>> mlx5e_destroy_devlink() -> devlink_free() ->
>> unregister_netdevice_notifier() (takes down_write(&pernet_ops_rwsem)
>
>Why don't we have a single, static notifier for all of devlink?
>Why the per device/per port notifiers?
>
>We have the devlink port pointer in struct net_device, resolving from
>a global event to the correct devlink instance is trivial.

Okay, that might work. Let me explore that.

