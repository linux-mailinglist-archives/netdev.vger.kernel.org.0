Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9C916A12B2
	for <lists+netdev@lfdr.de>; Thu, 23 Feb 2023 23:17:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbjBWWRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 17:17:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBWWRP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 17:17:15 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF578199F6;
        Thu, 23 Feb 2023 14:17:13 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id p26so10146554wmc.4;
        Thu, 23 Feb 2023 14:17:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gFfTKPYg6yzvz/uG0javvvTTeOWVb383kPmYBlrfVnY=;
        b=oumgOLClFvTU9ahaBvGi3VEqDxg+8KSWIAFuTSwPWyk871p6dKZe4Lb3Zthazck/Xt
         Nayf8ywEU1V40junNI00oWk/LZjLnkdNO194yetVEtTXbvDUr6xC0/uzewDtlBeV+6qO
         6e02g36Xq10jfDXal2LWNd50H1fNUyZqILPeGN/4xAvNmymY5VsGhxbpgX5+30drRhjM
         kBNCSHk5yw8oH3XScZz6FZ1auv12S82UZ/5cArv8etnYd7MLavlbOaudGz8zaBZFwe+X
         yXpZRThH4ycr05yyWqu7CMHUj0YaZ0CGenZcxf+71nkAOkeFUHQ6BaUe8wEUb3tsAV7c
         qZzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gFfTKPYg6yzvz/uG0javvvTTeOWVb383kPmYBlrfVnY=;
        b=L6QAfRvlyRPiVb7hQl6dz3MQSGk3TJDzyPFHpsOeznpf2oq+gHc6xPVDaA75XQmn5s
         mKR8BSDFpOHqxngLU+fBE8EsYcGUKkr18JfQNT4EEfGMkxHXb1QjkUGajHyq49MukXQ7
         a2NEuGTwYOaTZOyK8H/C8gBrdsSOFMOeTglzekNv6PFmi49Ykz2EjNHsKKcmCfsGI1BV
         OXCpyBL0bOXH2ukGWJ+wFktr3w/qlE6rOqiMHVLpVdXChfPbx4NKhCHDmBQ/K0OPLzRP
         LXgY7IfezI64GtDCzui/NyovtcKw6hZC37pAn2V8C0EqE9eI0IgjljEPEWCUonfem2n9
         46IQ==
X-Gm-Message-State: AO0yUKXPCwZRmtTFab6WlPlnt66367rRsJKrSCARuiRtrVNVa1bA0VgO
        b0ll2xKgYyFHB+DdG9yDRqs=
X-Google-Smtp-Source: AK7set/xpJdvWyXupUtx3RxXGPWc7tYcPMG9Aay1kcBBLI7qN8QrdVBlcWTNzxircgBW3itomPH3wQ==
X-Received: by 2002:a05:600c:1e20:b0:3ea:f6c4:5f25 with SMTP id ay32-20020a05600c1e2000b003eaf6c45f25mr549751wmb.36.1677190632020;
        Thu, 23 Feb 2023 14:17:12 -0800 (PST)
Received: from localhost ([2a02:168:633b:1:7c09:9c3b:256e:8ba1])
        by smtp.gmail.com with ESMTPSA id p15-20020a05600c1d8f00b003e20970175dsm634240wms.32.2023.02.23.14.17.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Feb 2023 14:17:11 -0800 (PST)
Date:   Thu, 23 Feb 2023 23:17:10 +0100
From:   =?iso-8859-1?Q?G=FCnther?= Noack <gnoack3000@gmail.com>
To:     Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
Cc:     mic@digikod.net, willemdebruijn.kernel@gmail.com,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, yusongping@huawei.com,
        artem.kuzin@huawei.com
Subject: Re: [PATCH v9 00/12] Network support for Landlock
Message-ID: <Y/fl5iEbkL5Pj5cJ@galopp>
References: <20230116085818.165539-1-konstantin.meskhidze@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230116085818.165539-1-konstantin.meskhidze@huawei.com>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Konstantin!

Sorry for asking such fundamental questions again so late in the review.

After playing with patch V9 with the Go-Landlock library, I'm still
having trouble understanding these questions -- they probably have
good answers, but I also did not see them explained in the
documentation. Maybe it would help to clarify it there?

* What is the use case for permitting processes to connect to a given
  TCP port, but leaving unspecified what the IP address is?

  Example: If a Landlock ruleset permits connecting to TCP port 53,
  that makes it possible to talk to any IP address on the internet (at
  least if the process runs on a normal Linux desktop machine), and we
  can't really control whether that is the system's proper (TCP-)DNS
  server or whether that is an attacker-controlled service for
  accepting leaked secrets from the process...?

  Is the plan that IP address support should be added in a follow-up
  patch?  Will it become part of the landlock_net_service_attr struct?

* Given the list of obscure network protocols listed in the socket(2)
  man page, I find it slightly weird to have rules for the use of TCP,
  but to leave less prominent protocols unrestricted.

  For example, a process with an enabled Landlock network ruleset may
  connect only to certain TCP ports, but at the same time it can
  happily use Bluetooth/CAN bus/DECnet/IPX or other protocols?

  I'm mentioning these more obscure protocols, because I doubt that
  Landlock will grow more sophisticated support for them anytime soon,
  so maybe the best option would be to just make it possible to
  disable these?  Is that also part of the plan?

  (I think there would be a lot of value in restricting network
  access, even when it's done very broadly.  There are many programs
  that don't need network at all, and among those that do need
  network, most only require IP networking.

  Btw, the argument for more broad disabling of network access was
  already made at https://cr.yp.to/unix/disablenetwork.html in the
  past.)

* This one is more of an implementation question: I don't understand
  why we are storing the networking rules in the same RB tree as the
  file system rules. - It looks a bit like "YAGNI" to me...?

  Would it be more efficient to keep the file system rules in the
  existing RB tree, and store the networking rules *separately* next
  to it in a different RB tree, or even in a more optimized data
  structure? In pseudocode:

    struct fast_lookup_int_set bind_tcp_ports;
    struct fast_lookup_int_set connect_tcp_ports;
    struct landlock_rb_tree fs_rules;

  It seems that there should be a data structure that supports this
  well and which uses the fact that we only need to store small
  integers?

Thanks,
–Günther

P.S.: Apologies if some of it was discussed previously. I did my best
to catch up on previous threads, but it's long, and it's possible that
I missed parts of the discussion.

On Mon, Jan 16, 2023 at 04:58:06PM +0800, Konstantin Meskhidze wrote:
> Hi,
> This is a new V9 patch related to Landlock LSM network confinement.
> It is based on the landlock's -next branch on top of v6.2-rc3 kernel version:
> https://git.kernel.org/pub/scm/linux/kernel/git/mic/linux.git/log/?h=next
> 
> It brings refactoring of previous patch version V8.
> Mostly there are fixes of logic and typos, adding new tests.
> 
> All test were run in QEMU evironment and compiled with
>  -static flag.
>  1. network_test: 32/32 tests passed.
>  2. base_test: 7/7 tests passed.
>  3. fs_test: 78/78 tests passed.
>  4. ptrace_test: 8/8 tests passed.
> 
> Previous versions:
> v8: https://lore.kernel.org/linux-security-module/20221021152644.155136-1-konstantin.meskhidze@huawei.com/
> v7: https://lore.kernel.org/linux-security-module/20220829170401.834298-1-konstantin.meskhidze@huawei.com/
> v6: https://lore.kernel.org/linux-security-module/20220621082313.3330667-1-konstantin.meskhidze@huawei.com/
> v5: https://lore.kernel.org/linux-security-module/20220516152038.39594-1-konstantin.meskhidze@huawei.com
> v4: https://lore.kernel.org/linux-security-module/20220309134459.6448-1-konstantin.meskhidze@huawei.com/
> v3: https://lore.kernel.org/linux-security-module/20220124080215.265538-1-konstantin.meskhidze@huawei.com/
> v2: https://lore.kernel.org/linux-security-module/20211228115212.703084-1-konstantin.meskhidze@huawei.com/
> v1: https://lore.kernel.org/linux-security-module/20211210072123.386713-1-konstantin.meskhidze@huawei.com/
> 
> Konstantin Meskhidze (11):
>   landlock: Make ruleset's access masks more generic
>   landlock: Refactor landlock_find_rule/insert_rule
>   landlock: Refactor merge/inherit_ruleset functions
>   landlock: Move and rename umask_layers() and init_layer_masks()
>   landlock: Refactor _unmask_layers() and _init_layer_masks()
>   landlock: Refactor landlock_add_rule() syscall
>   landlock: Add network rules and TCP hooks support
>   selftests/landlock: Share enforce_ruleset()
>   selftests/landlock: Add 10 new test suites dedicated to network
>   samples/landlock: Add network demo
>   landlock: Document Landlock's network support
> 
> Mickaël Salaün (1):
>   landlock: Allow filesystem layout changes for domains without such
>     rule type
> 
>  Documentation/userspace-api/landlock.rst     |   72 +-
>  include/uapi/linux/landlock.h                |   49 +
>  samples/landlock/sandboxer.c                 |  131 +-
>  security/landlock/Kconfig                    |    1 +
>  security/landlock/Makefile                   |    2 +
>  security/landlock/fs.c                       |  255 ++--
>  security/landlock/limits.h                   |    7 +-
>  security/landlock/net.c                      |  200 +++
>  security/landlock/net.h                      |   26 +
>  security/landlock/ruleset.c                  |  409 +++++--
>  security/landlock/ruleset.h                  |  185 ++-
>  security/landlock/setup.c                    |    2 +
>  security/landlock/syscalls.c                 |  165 ++-
>  tools/testing/selftests/landlock/base_test.c |    2 +-
>  tools/testing/selftests/landlock/common.h    |   10 +
>  tools/testing/selftests/landlock/config      |    4 +
>  tools/testing/selftests/landlock/fs_test.c   |   75 +-
>  tools/testing/selftests/landlock/net_test.c  | 1157 ++++++++++++++++++
>  18 files changed, 2398 insertions(+), 354 deletions(-)
>  create mode 100644 security/landlock/net.c
>  create mode 100644 security/landlock/net.h
>  create mode 100644 tools/testing/selftests/landlock/net_test.c
> 
> -- 
> 2.25.1
> 
