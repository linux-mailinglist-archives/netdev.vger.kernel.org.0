Return-Path: <netdev+bounces-2897-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CF8B0704769
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 10:09:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CDFB51C20D5B
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 08:09:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B757200B2;
	Tue, 16 May 2023 08:09:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10502168CA
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 08:09:26 +0000 (UTC)
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 628083C03
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 01:09:24 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f415a90215so112447085e9.0
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 01:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1684224563; x=1686816563;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=b+0QPiOe7gh1nY8JICd/L6loWbsY2JuNb1Q92guRyV8=;
        b=3OwusxiC+rYPYx8Hv/LVzud9Psu5C2D0LbP1sV8fg2NEKFwVOguEx/JDQboTEILym1
         a0XjqWEFALwbRV+I48gLGvYAB9cq08mZ1RUvudI5MBSCpXEdxkF6jiApJogeMzymtSJq
         pPWSirUNfnRptY9/iNUHb+X5LzammxpDLr6ODClbPnatEVSL8dP5Qjo/BscQ29/AdMe2
         6N7zzkUDZMojW43w/qY0iFvwQKxwwfg+5RGPmLMsEX79SBYAZfHgcUtb9c1+YsgYbMYB
         d1UY8B1bZIIbuSerxiyrHGDl1SzrOb2JPfEcJBXXm4s+v8CGn/8n6al4V6QoCVE2t2OU
         z9BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684224563; x=1686816563;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b+0QPiOe7gh1nY8JICd/L6loWbsY2JuNb1Q92guRyV8=;
        b=GCOsTfBBAMN0+6t7Ywe1rKF4unJi7UeWrvksGaahSE8LKphnicnvD1ikpsLim+O4lh
         QRm5JL0Z0BV8ko0j4Vlv8Vu5CyCo0hstMkelmm+fjFlKD9IDNpc56K3xxempOJ0qQbt4
         qy3sqTqydHiBLztG7CXQ2Z/l2HNw52rVgkP2Prjuh3IxqYO62Cih1Y4RkRtONc4sgkcH
         8E7/HEn64vpvas5LfEW6AOT/UA7HAR9UN4eHiw5NFUZXBdv4/r7wk0g5GLiF5hckEJuG
         zoV/i7pA/wSR4E6X/3Y9tYGztZZLdpGvL0R7IFV8oTw1qYJmBu7UrIJdxpO7J6uOqrQD
         Sa1A==
X-Gm-Message-State: AC+VfDxEqeLhmhOhtlNaPLIw/YmNV3LBEtfMgs4HHS4Vsyx/KzhsmVqg
	0iIYdoPG6gd/XQ8pQ10vZf/TCA==
X-Google-Smtp-Source: ACHHUZ57oh46c/BRv/QygIEqEOSk+h5DEoyXSsz9VPw8Wna9IiVLuamys+ckgDr8Yyvrkgy2y0Tguw==
X-Received: by 2002:adf:fdcc:0:b0:307:7e68:3a47 with SMTP id i12-20020adffdcc000000b003077e683a47mr24072923wrs.37.1684224562760;
        Tue, 16 May 2023 01:09:22 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id l2-20020a5d4802000000b003047dc162f7sm1660041wrq.67.2023.05.16.01.09.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 May 2023 01:09:22 -0700 (PDT)
Date: Tue, 16 May 2023 10:09:21 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Ido Schimmel <idosch@nvidia.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com, simon.horman@corigine.com,
	m.szyprowski@samsung.com
Subject: Re: [PATCH net] devlink: Fix crash with CONFIG_NET_NS=n
Message-ID: <ZGM6Mekf53HTY+p9@nanopsycho>
References: <20230515162925.1144416-1-idosch@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230515162925.1144416-1-idosch@nvidia.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Mon, May 15, 2023 at 06:29:25PM CEST, idosch@nvidia.com wrote:
>'__net_initdata' becomes a no-op with CONFIG_NET_NS=y, but when this
>option is disabled it becomes '__initdata', which means the data can be
>freed after the initialization phase. This annotation is obviously
>incorrect for the devlink net device notifier block which is still
>registered after the initialization phase [1].
>
>Fix this crash by removing the '__net_initdata' annotation.
>
>[1]
>general protection fault, probably for non-canonical address 0xcccccccccccccccc: 0000 [#1] PREEMPT SMP
>CPU: 3 PID: 117 Comm: (udev-worker) Not tainted 6.4.0-rc1-custom-gdf0acdc59b09 #64
>Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-1.fc37 04/01/2014
>RIP: 0010:notifier_call_chain+0x58/0xc0
>[...]
>Call Trace:
> <TASK>
> dev_set_mac_address+0x85/0x120
> dev_set_mac_address_user+0x30/0x50
> do_setlink+0x219/0x1270
> rtnl_setlink+0xf7/0x1a0
> rtnetlink_rcv_msg+0x142/0x390
> netlink_rcv_skb+0x58/0x100
> netlink_unicast+0x188/0x270
> netlink_sendmsg+0x214/0x470
> __sys_sendto+0x12f/0x1a0
> __x64_sys_sendto+0x24/0x30
> do_syscall_64+0x38/0x80
> entry_SYSCALL_64_after_hwframe+0x63/0xcd
>
>Fixes: e93c9378e33f ("devlink: change per-devlink netdev notifier to static one")
>Reported-by: Marek Szyprowski <m.szyprowski@samsung.com>
>Closes: https://lore.kernel.org/netdev/600ddf9e-589a-2aa0-7b69-a438f833ca10@samsung.com/
>Tested-by: Marek Szyprowski <m.szyprowski@samsung.com>
>Signed-off-by: Ido Schimmel <idosch@nvidia.com>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>

Thanks!

