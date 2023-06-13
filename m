Return-Path: <netdev+bounces-10320-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C881672DDC8
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 11:35:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 15D461C20A61
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 09:35:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E75027737;
	Tue, 13 Jun 2023 09:35:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 024ED2415C
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 09:35:08 +0000 (UTC)
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D176E7A
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 02:35:06 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-977c8423dccso1303975666b.1
        for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 02:35:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686648905; x=1689240905;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bloGu9ewtvvsr2osqWNd6EAxXe6SondJz3C1P8CL5EU=;
        b=aPTORHw5FXt4AX8MjWIYPIefhemhNsTYUPzWkx3QMOdFEkqJbB/aMBgz3qXHi3ezz/
         8CSDV1qM1OUrr5dtV3FwdJisP7Nh8cgDxOVKzjnkXv0c5HwabpRXU+Uv/JL8vSo3vYL7
         HKM9LQZRwwjkwmGUy2VM6Sd9EF5VjacxihmXbHPdJVl0V5k1RYjfnHb58H0bbV+lScl9
         aWEn2sMeab8lGRTas/Sn94/Pu0n7C6tuz/s47N8XrZc+j7fuk/k5LqcUNW0YGnrCJCDK
         PUFcxnU4ylXMBgiX5HO8cR4bmAV6z4YHglu2o57pMJtyqgRLzpMj5jGXpxWa1E3UQHs1
         fZIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686648905; x=1689240905;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bloGu9ewtvvsr2osqWNd6EAxXe6SondJz3C1P8CL5EU=;
        b=HoE9HOF/Ce4nOkOENigZQBy1R7n/vo3mbTmeDofIqgVT9ejX8Yx/JEz7z0QfwpW2HA
         0AXJ2C/yH5Pjv45K9lZWMDDThzCkWH2FJZy1Vm3caomGMXfXy729+EG1AtNCX4csLcrC
         4WSDD5/rjRfupXP8fTre1yZ3ywHdjcl+fBb0QGzFJZMP0hw6c5d3LegguSKf2l/rfgbX
         EfPLXn9EKAOoEnpS/iQOemPs8cigvkbMRlBux0nzHKdQ03ufqkHUS+hv+Lh/htCJrxzh
         BucV374Tr2memyepKNFEnvize0Y8Mqxeg3InyjrKL+scRf/CWn9WNLjdtWpJUIH3EPlK
         4SkA==
X-Gm-Message-State: AC+VfDxm3bnhDQwwP4ENikEeJYTHIl8UW7d4VepQJowqaZu9UIC776er
	EjFjiCJ1nW5JnJaD6hrcuf8=
X-Google-Smtp-Source: ACHHUZ6VEpU05w2lFjaJ+7pQz3i86+AuBVnW1iFx5rH+n21TiI+b6h+nFsmHvyfjVVZAs6MuzUnj5A==
X-Received: by 2002:a17:907:16a7:b0:977:d660:c5aa with SMTP id hc39-20020a17090716a700b00977d660c5aamr13758652ejc.31.1686648904523;
        Tue, 13 Jun 2023 02:35:04 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id e26-20020a170906045a00b0096fc35ca733sm6337543eja.41.2023.06.13.02.35.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jun 2023 02:35:04 -0700 (PDT)
Date: Tue, 13 Jun 2023 12:35:01 +0300
From: Vladimir Oltean <olteanv@gmail.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Asmaa Mnebhi <asmaa@nvidia.com>, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	netdev@vger.kernel.org, cai.huoqing@linux.dev, brgl@bgdev.pl,
	chenhao288@hisilicon.com, huangguangbin2@huawei.com,
	David Thompson <davthompson@nvidia.com>
Subject: Re: [PATCH net v2 1/1] mlxbf_gige: Fix kernel panic at shutdown
Message-ID: <20230613093501.46x4rvyhhyx5wo3b@skbuf>
References: <ZIcC2Y+HHHR+7QYq@boxer>
 <20230612115925.GR12152@unreal>
 <20230612123718.u6cfggybbtx4owbq@skbuf>
 <20230612131707.GS12152@unreal>
 <20230612132841.xcrlmfhzhu5qazgk@skbuf>
 <20230612133853.GT12152@unreal>
 <20230612140521.tzhgliaok5u3q67o@skbuf>
 <20230613071959.GU12152@unreal>
 <20230613083002.pjzsno2tzbewej7o@skbuf>
 <20230613090920.GW12152@unreal>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230613090920.GW12152@unreal>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 12:09:20PM +0300, Leon Romanovsky wrote:
> On Tue, Jun 13, 2023 at 11:30:02AM +0300, Vladimir Oltean wrote:
> > On Tue, Jun 13, 2023 at 10:19:59AM +0300, Leon Romanovsky wrote:
> > > But once child finishes device_shutdown(), it will be removed from devices_kset
> > > list and dev->driver should be NULL at that point for the child.
> > 
> > What piece of code would make dev->driver be NULL for devices that have
> > been shut down by device_shutdown()?
> 
> You are right here and I'm wrong on that point, dev->driver is set to
> NULL in all other places where the device is going to be reused and not
> in device_shutdown().
> 
> Unfortunately, it doesn't change a lot in our conversation, as device_shutdown()
> is very specific call which is called in two flows: kernel_halt() and kernel_restart().
> 
> In both flows, it is end game.
> 
> Thanks

Except for the fact that, as mentioned in my first reply to this thread,
bus drivers may implement .shutdown() the same way as .remove(), so in
that case, someone *will* unbind the drivers from those child devices,
*after* .shutdown() was called on the child - and if the child device
driver isn't prepared to handle that, it can dereference NULL pointers
and bye bye reboot - the kernel hangs.

Not really sure where you're aiming with your replies at this stage.

