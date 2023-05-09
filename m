Return-Path: <netdev+bounces-1178-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CC5756FC81E
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 15:40:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 041871C20B56
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 13:40:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCF1A182DE;
	Tue,  9 May 2023 13:40:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAF986116
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 13:40:11 +0000 (UTC)
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C6CF35A6
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 06:40:04 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id 2adb3069b0e04-4efd6e26585so6653801e87.1
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 06:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20221208.gappssmtp.com; s=20221208; t=1683639602; x=1686231602;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JIEpxHdtSB7XFnSmwk8dj3t75wt5MVWkqRu9IFJ82E8=;
        b=R5hLS3b+kFbDU0ao2WziLYm3WCaIG52Lbai3BhnYTJEXZfuIGUwDz3EvujXQT/ArzR
         Gyg8bln4ZWifYguJ+OyEYFIHt2zmn7sSnrvtbLdr/X0Tjvs1yZ8wbHxJZK2wAMqqaSWA
         Yfj6lyiJw7GrM1bi9xU7kpsDlOpQEi7hu0bUhP5k/bEn1S5sajuFvXs627balNw8mA8e
         EReOwOXADxRQ5J9sVP8OT84eZU6FDC9g5WX9oIrAvVUebtThOHpymatLbq5wi3jKSTcH
         tCroEPWGljJ1AfCqiPbdM/ifL5D6smFFSAkj5SFNyPAgqloCSfI7dffCk6Kgt3yk/n34
         eqmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683639602; x=1686231602;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JIEpxHdtSB7XFnSmwk8dj3t75wt5MVWkqRu9IFJ82E8=;
        b=kGqrwCtWQ35vdamYr95gpRqApAvJhOoF8QzCKyLYHZfRpFNF8fmPMIe/EYzJJbaQNs
         jTpnuLktoV3wHL6oBWqjytHRNjhvL5CtW1CkdNhoLD1bZsbWcrtL7yJsCzapkIYekiaH
         wJaDF4eAX5CIFHTKtNwbL2NeZ542E8f296C6i/panBLiPGa3XkK7fy2aRpzGySTVC6pf
         QIgzDQs+cL7MXYaUBEpTFHDTh5D9g7ciuRmUutKuRhPodL0YIdqIu0iWe+y9OPyX1RNo
         0LMiVUB+yK1kD+ZWUip6/+udaQJbWcnjCSrUL2BtZwyoQ1Wln944eHsybrz1sDoewMPe
         Idow==
X-Gm-Message-State: AC+VfDyfnH6eUuN0XeI3ZaGffW4qmQHhMZU1eoCoJ27ZQ4tLNwJ2TapI
	B6/DtALnClfZJLU+XNk3tj0Rvg==
X-Google-Smtp-Source: ACHHUZ6h+si+2vzTWaS+lBEyNUbJ41GBoARIEqCc/I60aCj6DsVVa1/FOLOxoodk6G8ACcLD5jA5GQ==
X-Received: by 2002:ac2:55a8:0:b0:4ed:c17c:16e5 with SMTP id y8-20020ac255a8000000b004edc17c16e5mr876233lfg.17.1683639602255;
        Tue, 09 May 2023 06:40:02 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id c2-20020a197602000000b004d023090504sm350197lff.84.2023.05.09.06.40.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 06:40:01 -0700 (PDT)
Date: Tue, 9 May 2023 15:40:00 +0200
From: Jiri Pirko <jiri@resnulli.us>
To: Vadim Fedorenko <vadfed@meta.com>
Cc: Jakub Kicinski <kuba@kernel.org>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Jonathan Lemon <jonathan.lemon@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Milena Olech <milena.olech@intel.com>,
	Michal Michalik <michal.michalik@intel.com>,
	linux-arm-kernel@lists.infradead.org,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>, poros@redhat.com,
	mschmidt@redhat.com, netdev@vger.kernel.org,
	linux-clk@vger.kernel.org
Subject: Re: [RFC PATCH v7 2/8] dpll: Add DPLL framework base functions
Message-ID: <ZFpNMAUkKbl7SFoV@nanopsycho>
References: <20230428002009.2948020-1-vadfed@meta.com>
 <20230428002009.2948020-3-vadfed@meta.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230428002009.2948020-3-vadfed@meta.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Fri, Apr 28, 2023 at 02:20:03AM CEST, vadfed@meta.com wrote:
>From: Vadim Fedorenko <vadim.fedorenko@linux.dev>
>

[...]

>+int dpll_pre_dumpit(struct netlink_callback *cb)
>+{
>+	mutex_lock(&dpll_xa_lock);

Did you test this?

I'm gettting following deadlock warning:

[  280.899789] ======================================================
[  280.900458] WARNING: possible circular locking dependency detected
[  280.901126] 6.3.0jiri+ #4 Tainted: G             L    
[  280.901702] ------------------------------------------------------
[  280.902378] python3/1058 is trying to acquire lock:
[  280.902934] ffff88811571ae88 (nlk_cb_mutex-GENERIC){+.+.}-{3:3}, at: netlink_dump+0x4a/0x400
[  280.903869] 
               but task is already holding lock:
[  280.904559] ffffffff827d1c68 (dpll_xa_lock){+.+.}-{3:3}, at: dpll_pin_pre_dumpit+0x13/0x20
[  280.905464] 
               which lock already depends on the new lock.

[  280.906414] 
               the existing dependency chain (in reverse order) is:
[  280.907141] 
               -> #1 (dpll_xa_lock){+.+.}-{3:3}:
[  280.907711]        __mutex_lock+0x91/0xbb0
[  280.908116]        dpll_pin_pre_dumpit+0x13/0x20
[  280.908553]        genl_start+0xc6/0x150
[  280.908940]        __netlink_dump_start+0x158/0x230
[  280.909399]        genl_family_rcv_msg_dumpit+0xf9/0x110
[  280.909894]        genl_rcv_msg+0x115/0x290
[  280.910302]        netlink_rcv_skb+0x54/0x100
[  280.910726]        genl_rcv+0x24/0x40
[  280.911106]        netlink_unicast+0x182/0x260
[  280.911547]        netlink_sendmsg+0x242/0x4b0
[  280.911984]        sock_sendmsg+0x38/0x60
[  280.912384]        __sys_sendto+0xeb/0x130
[  280.912797]        __x64_sys_sendto+0x20/0x30
[  280.913227]        do_syscall_64+0x3c/0x80
[  280.913639]        entry_SYSCALL_64_after_hwframe+0x46/0xb0
[  280.914156] 
               -> #0 (nlk_cb_mutex-GENERIC){+.+.}-{3:3}:
[  280.914809]        __lock_acquire+0x1165/0x26b0
[  280.915254]        lock_acquire+0xce/0x2b0
[  280.915665]        __mutex_lock+0x91/0xbb0
[  280.916080]        netlink_dump+0x4a/0x400
[  280.916488]        __netlink_dump_start+0x188/0x230
[  280.916953]        genl_family_rcv_msg_dumpit+0xf9/0x110
[  280.917448]        genl_rcv_msg+0x115/0x290
[  280.917863]        netlink_rcv_skb+0x54/0x100
[  280.918301]        genl_rcv+0x24/0x40
[  280.918686]        netlink_unicast+0x182/0x260
[  280.919129]        netlink_sendmsg+0x242/0x4b0
[  280.919569]        sock_sendmsg+0x38/0x60
[  280.919969]        __sys_sendto+0xeb/0x130
[  280.920377]        __x64_sys_sendto+0x20/0x30
[  280.920808]        do_syscall_64+0x3c/0x80
[  280.921220]        entry_SYSCALL_64_after_hwframe+0x46/0xb0
[  280.921730] 
               other info that might help us debug this:

[  280.922513]  Possible unsafe locking scenario:

[  280.923095]        CPU0                    CPU1
[  280.923541]        ----                    ----
[  280.923976]   lock(dpll_xa_lock);
[  280.924329]                                lock(nlk_cb_mutex-GENERIC);
[  280.924916]                                lock(dpll_xa_lock);
[  280.925454]   lock(nlk_cb_mutex-GENERIC);
[  280.925858] 
                *** DEADLOCK ***

[  280.926488] 2 locks held by python3/1058:
[  280.926891]  #0: ffffffff827e2430 (cb_lock){++++}-{3:3}, at: genl_rcv+0x15/0x40
[  280.927585]  #1: ffffffff827d1c68 (dpll_xa_lock){+.+.}-{3:3}, at: dpll_pin_pre_dumpit+0x13/0x20
[  280.928385] 
               stack backtrace:
[  280.928853] CPU: 8 PID: 1058 Comm: python3 Tainted: G             L     6.3.0jiri+ #4
[  280.929586] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
[  280.930558] Call Trace:
[  280.930849]  <TASK>
[  280.931117]  dump_stack_lvl+0x58/0xb0
[  280.931500]  check_noncircular+0x11b/0x130
[  280.931916]  ? kernel_text_address+0x109/0x110
[  280.932353]  __lock_acquire+0x1165/0x26b0
[  280.932759]  lock_acquire+0xce/0x2b0
[  280.933130]  ? netlink_dump+0x4a/0x400
[  280.933517]  __mutex_lock+0x91/0xbb0
[  280.933885]  ? netlink_dump+0x4a/0x400
[  280.934269]  ? netlink_dump+0x4a/0x400
[  280.934662]  ? netlink_dump+0x4a/0x400
[  280.935054]  netlink_dump+0x4a/0x400
[  280.935426]  __netlink_dump_start+0x188/0x230
[  280.935857]  genl_family_rcv_msg_dumpit+0xf9/0x110
[  280.936321]  ? genl_family_rcv_msg_attrs_parse.constprop.0+0xe0/0xe0
[  280.936887]  ? dpll_nl_pin_get_doit+0x100/0x100
[  280.937324]  ? genl_lock_dumpit+0x50/0x50
[  280.937729]  genl_rcv_msg+0x115/0x290
[  280.938109]  ? dpll_pin_post_doit+0x20/0x20
[  280.938526]  ? dpll_nl_pin_get_doit+0x100/0x100
[  280.938966]  ? dpll_pin_pre_dumpit+0x20/0x20
[  280.939390]  ? genl_family_rcv_msg_doit.isra.0+0x110/0x110
[  280.939904]  netlink_rcv_skb+0x54/0x100
[  280.940296]  genl_rcv+0x24/0x40
[  280.940636]  netlink_unicast+0x182/0x260
[  280.941034]  netlink_sendmsg+0x242/0x4b0
[  280.941439]  sock_sendmsg+0x38/0x60
[  280.941804]  ? sockfd_lookup_light+0x12/0x70
[  280.942230]  __sys_sendto+0xeb/0x130
[  280.942616]  ? mntput_no_expire+0x7e/0x490
[  280.943038]  ? proc_nr_files+0x30/0x30
[  280.943425]  __x64_sys_sendto+0x20/0x30
[  280.943817]  do_syscall_64+0x3c/0x80
[  280.944194]  entry_SYSCALL_64_after_hwframe+0x46/0xb0
[  280.944674] RIP: 0033:0x7f252fd132b0
[  280.945042] Code: c0 ff ff ff ff eb b8 0f 1f 00 f3 0f 1e fa 41 89 ca 64 8b 04 25 18 00 00 00 85 c0 75 1d 45 31 c9 45 31 c0 b8 2c 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 68 c3 0f 1f 80 00 00 00 00 41 54 48 83 ec 20
[  280.946622] RSP: 002b:00007ffdbd9335d8 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
[  280.947328] RAX: ffffffffffffffda RBX: 00007ffdbd933688 RCX: 00007f252fd132b0
[  280.947962] RDX: 0000000000000014 RSI: 00007f252ede65d0 RDI: 0000000000000003
[  280.948594] RBP: 00007f252f806da0 R08: 0000000000000000 R09: 0000000000000000
[  280.949229] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[  280.949858] R13: ffffffffc4653600 R14: 0000000000000001 R15: 00007f252f74d147
[  280.950494]  </TASK>

Problem is that in __netlink_dump_start() you take dpll_xa_lock
(in control->start(cb)) while holding nlk->cb_mutex, then you unlock
the nlk->cb_mutex and take it again in netlink_dump().
I hear "Chiquitita" from the distance :)

[...]

