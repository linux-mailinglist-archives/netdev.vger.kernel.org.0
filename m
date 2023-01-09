Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD9766214F
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 10:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233827AbjAIJUy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 04:20:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234253AbjAIJUc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 04:20:32 -0500
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF8DF32F
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 01:17:45 -0800 (PST)
Received: by mail-ej1-x636.google.com with SMTP id qk9so18456564ejc.3
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 01:17:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gooddata.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LeOTgenvbkmcRvMT4UZ6wPxbUX/9wsirYPZTEw+d2jg=;
        b=P87r5rwXwY7o3tIlGHN3esQOqJ4O8hUXy4tbiSfvV+g77VRYk/UFXnyN2H0JSrXFaZ
         1ay3hgLsNA8MwFW9v0xQk4+qXCCwBwzXZVlTuBtfyLVKCieT+nsJAe3DyoqmHVeqFoxT
         CDKBx6Wg5L8EJOJmi4YlL4+XXQckVJuZoz/9Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LeOTgenvbkmcRvMT4UZ6wPxbUX/9wsirYPZTEw+d2jg=;
        b=rBq+yABsjZPLOHbkkWzUCPEbBYXZfh1zoPOU69iUSVd6Fw+ZRhNMu7iYoFqP9mgINL
         +HwwcwzZFnoMlohSyH2S1atUsYZogYfdyvqzfmqPWQ7xMz0YG+ZDE//O7yvkBRmg5whS
         GGmyDtMQdw5gM+/UhQBlE2CX+E5oIa7yumfEwrmY0c12hgAnGzHHuKLbBlFFmKSafecz
         sN6MX27rthsaLiOMz1Gggq8xHGy6SYC/1XPcYwbnZnwmDVk8gdP2Q6pbqg9CTKQRFeZz
         O6iHsAEu22P6OE7tllud5kGGBdRKIYsBEmPhw75X1H97yHzF2NhSwgiVtA5fGTv1fWH2
         FZ1g==
X-Gm-Message-State: AFqh2kqgpj4OpezdcZl9gBrhHjscCch8DDyxqLuD3Xe4QvRU6sLsL6cf
        tvC+LBuyv2PJivhN2+mO3K9uajO4J5e71K6HjrTnJQ==
X-Google-Smtp-Source: AMrXdXtYS8N31ZR7tM0udmkekH6MtKeZ5JS2QT+cWxrKzFgVIkymc1KgLL+RNbpg1Fa+uCNHW8gfZglCmxfbpOFtq9s=
X-Received: by 2002:a17:906:910:b0:7c1:136d:b841 with SMTP id
 i16-20020a170906091000b007c1136db841mr4417414ejd.216.1673255864286; Mon, 09
 Jan 2023 01:17:44 -0800 (PST)
MIME-Version: 1.0
References: <CAK8fFZ6A_Gphw_3-QMGKEFQk=sfCw1Qmq0TVZK3rtAi7vb621A@mail.gmail.com>
 <Y7hJJ5hIxDolYIAV@ziepe.ca>
In-Reply-To: <Y7hJJ5hIxDolYIAV@ziepe.ca>
From:   Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
Date:   Mon, 9 Jan 2023 10:17:17 +0100
Message-ID: <CAK8fFZ7P_JmgpZ6DCUUimQ+31GF8E+Cw8Baf1jiVZFwDw=G1+Q@mail.gmail.com>
Subject: Re: Network do not works with linux >= 6.1.2. Issue bisected to
 "425c9bd06b7a70796d880828d15c11321bdfb76d" (RDMA/irdma: Report the correct
 link speed)
To:     Jason Gunthorpe <jgg@ziepe.ca>
Cc:     kamalheib1@gmail.com, shiraz.saleem@intel.com, leon@kernel.org,
        sashal@kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Igor Raits <igor.raits@gooddata.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jason

about:

> We talked about this already - wasn't it on this series?

Nope, we do not talk about this. Shall not be someone else in the
email "TO" section?

Best,
Jaroslav P.


p=C3=A1 6. 1. 2023 v 17:15 odes=C3=ADlatel Jason Gunthorpe <jgg@ziepe.ca> n=
apsal:
>
> On Fri, Jan 06, 2023 at 08:55:29AM +0100, Jaroslav Pulchart wrote:
> > [  257.967099] task:NetworkManager  state:D stack:0     pid:3387
> > ppid:1      flags:0x00004002
> > [  257.975446] Call Trace:
> > [  257.977901]  <TASK>
> > [  257.980004]  __schedule+0x1eb/0x630
> > [  257.983498]  schedule+0x5a/0xd0
> > [  257.986641]  schedule_timeout+0x11d/0x160
> > [  257.990654]  __wait_for_common+0x90/0x1e0
> > [  257.994666]  ? usleep_range_state+0x90/0x90
> > [  257.998854]  __flush_workqueue+0x13a/0x3f0
> > [  258.002955]  ? __kernfs_remove.part.0+0x11e/0x1e0
> > [  258.007661]  ib_cache_cleanup_one+0x1c/0xe0 [ib_core]
> > [  258.012721]  __ib_unregister_device+0x62/0xa0 [ib_core]
> > [  258.017959]  ib_unregister_device+0x22/0x30 [ib_core]
> > [  258.023024]  irdma_remove+0x1a/0x60 [irdma]
> > [  258.027223]  auxiliary_bus_remove+0x18/0x30
> > [  258.031414]  device_release_driver_internal+0x1aa/0x230
> > [  258.036643]  bus_remove_device+0xd8/0x150
> > [  258.040654]  device_del+0x18b/0x3f0
> > [  258.044149]  ice_unplug_aux_dev+0x42/0x60 [ice]
>
> We talked about this already - wasn't it on this series?
>
> Don't hold locks when removing aux devices.
>
> > [  258.048707]  ice_lag_changeupper_event+0x287/0x2a0 [ice]
> > [  258.054038]  ice_lag_event_handler+0x51/0x130 [ice]
> > [  258.058930]  raw_notifier_call_chain+0x41/0x60
> > [  258.063381]  __netdev_upper_dev_link+0x1a0/0x370
> > [  258.068008]  netdev_master_upper_dev_link+0x3d/0x60
> > [  258.072886]  bond_enslave+0xd16/0x16f0 [bonding]
> > [  258.077517]  ? nla_put+0x28/0x40
> > [  258.080756]  do_setlink+0x26c/0xc10
> > [  258.084249]  ? avc_alloc_node+0x27/0x180
> > [  258.088173]  ? __nla_validate_parse+0x141/0x190
> > [  258.092708]  __rtnl_newlink+0x53a/0x620
> > [  258.096549]  rtnl_newlink+0x44/0x70
>
> Especially not the rtnl.
>
> Jason
