Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D413F599E0B
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 17:21:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348861AbiHSPMB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 11:12:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348395AbiHSPL7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 11:11:59 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECBA5F9941
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 08:11:57 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id 53-20020a9d0838000000b006371d896343so3239686oty.10
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 08:11:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc;
        bh=2/+tSwVoxYD5mGtzoDZi9962hqCacE6DQbGmTFIPrRk=;
        b=D+ymZKYdpbZncdZOkvo3xbXLK145kxGbKeNUHhpLL9idg5m3neG3/eAmifHMXzMTnU
         Vtv6cxnFN3wMonDIqxYvTHJzsfWTknzDhKgKDq/rnzkdZdnDeucYXFnrX3mSmsY3Hq4n
         kvS+1Ktd2ikT9zBxqY1Lai+32s5D+SvfPHRgXI9XOwHtde7sYG7cNBh/2Q6lM2R4Eww9
         wTnYJLo6ryp3Y//uOt0V/r/bUrxMCQ6CIYpAeLoD90Om6zdlC+uOqQWHMw4pwynrXxIT
         TBGsM+VsIPZweC03BwnrKyiOb4Iajrv33VAGduCbMczbBmVKVy+fDgK2bUWN7w/KrXSM
         hZqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc;
        bh=2/+tSwVoxYD5mGtzoDZi9962hqCacE6DQbGmTFIPrRk=;
        b=05J0+1xKARY3wp44Iovi/zhjHvHI0srGalf5Epn8qdNHMC4j+yTr5mmI+zPjqeEr2Z
         jEWrWZAR1Y1oPAulaj0hM/gKlIdybOrIHuM4qF62uDwytO8w2kf8xVQkXr2VO4GyRVhZ
         VQhY+XHoyRMLP8y5EgRAmnZJVK5Ad5zFZLGs75jHY9fZh1pnKHjG4OXzX0XQLZzwmjAK
         A24C6y2rQNZ3Fej8cumAJd1PTDT/Efc+X8KuJZJO/NzUMTjHdtnS18+7snfmAKgo0H6b
         3M5hxMjlHxr9SWdCxIZKz6k+ie60pBbLoNQ1YyjMQURngtICro/AbwQZkrfU7fHIWiDS
         87bw==
X-Gm-Message-State: ACgBeo2u005YOCqia8SLU7wXeh/f63+VZdvYgfugn56XACgBAyhkTXIZ
        Naz0HvtZYXVgYabLIGySbmLDsTGD4IhWvbmn9Qg=
X-Google-Smtp-Source: AA6agR6zLF5rXTkbaxD1EEagnq6KCS3lSvUXh+PWsKeP348YJSvIqKPPm5Q/e1EeK/GUJAtvPfOgMBjXpPsD3JGmjRs=
X-Received: by 2002:a05:6830:6986:b0:61c:fd55:5b64 with SMTP id
 cy6-20020a056830698600b0061cfd555b64mr3068692otb.92.1660921917276; Fri, 19
 Aug 2022 08:11:57 -0700 (PDT)
MIME-Version: 1.0
From:   Sergei Antonov <saproj@gmail.com>
Date:   Fri, 19 Aug 2022 18:11:46 +0300
Message-ID: <CABikg9wx7vB5eRDAYtvAm7fprJ09Ta27a4ZazC=NX5K4wn6pWA@mail.gmail.com>
Subject: mv88e6060: NULL dereference in dsa_slave_changeupper()
To:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!
I am using the current netdev/net.git kernel. My DSA is mv88e6060
(CONFIG_NET_DSA_MV88E6060).
These two commands cause a crash:
~ # brctl addbr mybridge
~ # brctl addif mybridge lan2

Unable to handle kernel NULL pointer dereference at virtual address 00000000
[00000000] *pgd=2b7b83102b7b831, *pte=c2b7b000, *ppte=c086b6f4
Internal error: Oops: 17 [#1] PREEMPT ARM
CPU: 0 PID: 70 Comm: brctl Not tainted 6.0.0-rc1+ #102
Hardware name: Generic DT based system
PC is at dsa_slave_changeupper+0x5c/0x158

 dsa_slave_changeupper from raw_notifier_call_chain+0x38/0x6c
 raw_notifier_call_chain from __netdev_upper_dev_link+0x198/0x3b4
 __netdev_upper_dev_link from netdev_master_upper_dev_link+0x50/0x78
 netdev_master_upper_dev_link from br_add_if+0x430/0x7f4
 br_add_if from br_ioctl_stub+0x170/0x530
 br_ioctl_stub from br_ioctl_call+0x54/0x7c
 br_ioctl_call from dev_ifsioc+0x4e0/0x6bc
 dev_ifsioc from dev_ioctl+0x2f8/0x758
 dev_ioctl from sock_ioctl+0x5f0/0x674
 sock_ioctl from sys_ioctl+0x518/0xe40
 sys_ioctl from ret_fast_syscall+0x0/0x1c

The reason is that extack is NULL in dsa_slave_changeupper(). Does
mv88e6060 driver support bridges at all? Anyway, it does not justify
the crash.
Below is "ip a" output. Tell me if anything else is needed.

1: lo: <LOOPBACK> mtu 65536 qdisc noop qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast qlen 1000
    link/ether 00:90:e8:00:10:03 brd ff:ff:ff:ff:ff:ff
    inet6 fe80::290:e8ff:fe00:1003/64 scope link
       valid_lft forever preferred_lft forever
3: lan2@eth0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc
noqueue qlen 1000
    link/ether 00:90:e8:00:10:03 brd ff:ff:ff:ff:ff:ff
    inet 192.168.0.254/24 scope global lan2
       valid_lft forever preferred_lft forever
4: lan3@eth0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc
noqueue qlen 1000
    link/ether 00:90:e8:00:10:03 brd ff:ff:ff:ff:ff:ff
    inet 192.168.1.254/24 scope global lan3
       valid_lft forever preferred_lft forever
5: lan1@eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue qlen 1000
    link/ether 00:90:e8:00:10:03 brd ff:ff:ff:ff:ff:ff
    inet 192.168.127.254/24 scope global lan1
       valid_lft forever preferred_lft forever
    inet6 fe80::290:e8ff:fe00:1003/64 scope link
       valid_lft forever preferred_lft forever
