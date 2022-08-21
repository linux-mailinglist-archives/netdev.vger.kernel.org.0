Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2785D59B435
	for <lists+netdev@lfdr.de>; Sun, 21 Aug 2022 16:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbiHUODK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 10:03:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230358AbiHUOCD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 10:02:03 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81EB124BE4
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 07:01:41 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id 53-20020a9d0838000000b006371d896343so6065550oty.10
        for <netdev@vger.kernel.org>; Sun, 21 Aug 2022 07:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=RBzz9ook3CxkmN+i7NJFHi4ltlWp3FC8on11UsLFVM4=;
        b=Oc8jvwgAQFMPg7FGaghmra66lmGKJfztCVFxan4uO0xpaLs8QWUJuKTlgJotKrObMB
         rBadOWQ4DzBqPPez61WrKCzh7tDlUIXqTfNk8eoxN92e4r36wcifxJ52c/hTgrsHowOn
         cLXkXmmXxBOu+Y+03IBJXWGDfxLp67UvsHPSOGyKSE4YNjxH5Ty6gynWjKEAu/zJHkLk
         1NWQLaKMKHNR4kIV2/+fKo0iiAXYSBawqhYLeG0oi0tDBiqNrFBv84JR35RVjQXjjcA+
         6HtOQTf5GKrqJZ8Ukbfqwjn15lJM3X8bxUDDCNFVbj7ySFBhN1fBHPNrFGm1ZATnjI8k
         aBEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=RBzz9ook3CxkmN+i7NJFHi4ltlWp3FC8on11UsLFVM4=;
        b=d4osR6GvD9rEtbYwTMnWXF0yWcTRtZ8xw55tBV8cV+W+HhMePrmg8Bp526zTmgRLiZ
         AOXTZ6txhq9kj/1A95DZtprDEOHhgdVHnaQTwWwDa43LKUHymeulif0m/nNnBNHxgYZK
         VMbe1JeVfHUlQj/HagUcQ3j14NjSDRnng3kXkwgy/eaDb977kn/B7n6Xn1xyznTp10Sz
         4/5UPepYhiGa03PVycoLyJ988aj7dUDcKUBj5kYbk0O7J4udxhpDPvh+p7aCpdmzp1X1
         JJ7wFOAIiDlpn2kU2wHJAEMrBQLU8D4ZeNBqH9BXy4yIUg+XryJVVL20k02lQvLcUXos
         DZwA==
X-Gm-Message-State: ACgBeo0RWLuC3P6QZhovwBtgY5mVYVa+5cydOs37HbMtLNyFFZSi8O//
        aJMSdiWtkB6X74uAScB4RmZ/NKo+8/jAqMUcQ4Y=
X-Google-Smtp-Source: AA6agR47xq+/HW3/ZBeey25cKtKTZp8dT+5qAqtRWSI7WtkTYNHghrQte0pFAlOrReA7dsLzB2jGuQsXZziCojd2uM8=
X-Received: by 2002:a05:6830:2014:b0:639:2b01:7dac with SMTP id
 e20-20020a056830201400b006392b017dacmr459331otp.168.1661090500828; Sun, 21
 Aug 2022 07:01:40 -0700 (PDT)
MIME-Version: 1.0
References: <20220819173925.3581871-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220819173925.3581871-1-vladimir.oltean@nxp.com>
From:   Sergei Antonov <saproj@gmail.com>
Date:   Sun, 21 Aug 2022 17:01:29 +0300
Message-ID: <CABikg9w5B4QDssS9sHZ_a3w1G-oeQQTkegyxK-hcgTHB-3155g@mail.gmail.com>
Subject: Re: [PATCH net] net: dsa: don't dereference NULL extack in dsa_slave_changeupper()
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
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

On Fri, 19 Aug 2022 at 20:39, Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>
> When a driver returns -EOPNOTSUPP in dsa_port_bridge_join() but failed
> to provide a reason for it, DSA attempts to set the extack to say that
> software fallback will kick in.
>
> The problem is, when we use brctl and the legacy bridge ioctls, the
> extack will be NULL, and DSA dereferences it in the process of setting
> it.
>
> Sergei Antonov proves this using the following stack trace:
>
> Unable to handle kernel NULL pointer dereference at virtual address 00000000
> PC is at dsa_slave_changeupper+0x5c/0x158
>
>  dsa_slave_changeupper from raw_notifier_call_chain+0x38/0x6c
>  raw_notifier_call_chain from __netdev_upper_dev_link+0x198/0x3b4
>  __netdev_upper_dev_link from netdev_master_upper_dev_link+0x50/0x78
>  netdev_master_upper_dev_link from br_add_if+0x430/0x7f4
>  br_add_if from br_ioctl_stub+0x170/0x530
>  br_ioctl_stub from br_ioctl_call+0x54/0x7c
>  br_ioctl_call from dev_ifsioc+0x4e0/0x6bc
>  dev_ifsioc from dev_ioctl+0x2f8/0x758
>  dev_ioctl from sock_ioctl+0x5f0/0x674
>  sock_ioctl from sys_ioctl+0x518/0xe40
>  sys_ioctl from ret_fast_syscall+0x0/0x1c
>
> Fix the problem by only overriding the extack if non-NULL.
>
> Fixes: 1c6e8088d9a7 ("net: dsa: allow port_bridge_join() to override extack message")
> Link: https://lore.kernel.org/netdev/CABikg9wx7vB5eRDAYtvAm7fprJ09Ta27a4ZazC=NX5K4wn6pWA@mail.gmail.com/
> Reported-by: Sergei Antonov <saproj@gmail.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Tested-by: Sergei Antonov <saproj@gmail.com>
