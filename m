Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48FCE52FC35
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 13:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352751AbiEULsU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 May 2022 07:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231287AbiEULsS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 May 2022 07:48:18 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DECE75F27C;
        Sat, 21 May 2022 04:48:17 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id w3so2690133plp.13;
        Sat, 21 May 2022 04:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=BgikS+FD68kYSqbiCR2/IjVUgexnyJ8rdyhsXWcQ0aM=;
        b=oq34Liz3tSGXMGm2kchBFttiAM3MqDkP08MsKHpP8RCQzUouVCmf+H7ognvcHXnD9x
         ymQ5IGkE45KIvift7C4nO8UvyWM8AUOkwUOvoy44YB/ha6DOkDEPStmFkr8aG3D81Hf+
         x0OP0MqLiKTk6UqXjw4ex+vMawVZotF4651ACiwRga4BGnn9oSwztPhPPCqg/dgz3/st
         q33heDOOVH46XxRY5frTdOzhWos0+Fv6Hdh5aEfh/koKVWx1xHGdeAYiMsg8ENExotot
         cW5aNyuq8VzgrAMXUpeqIK1AGDurKspCWZ+3L73o/0Y1rlNZK74oJuGBC+e8c/3qOegs
         OKeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=BgikS+FD68kYSqbiCR2/IjVUgexnyJ8rdyhsXWcQ0aM=;
        b=nUG9oNyjO45R/M1XSVP+gtU2WYGIIteV94M1CSWWjXxxfEuLj8pn+Jzs5MGjfsn4DK
         llBnm3M/WXtTvOl3s0osxpfeSuhn+HWycNrz8KDgetoi+Klaj14YvFh574iW+MWj5rGy
         VJVXzcsF3JDkypkL8LZvQr1xXn7x8PL819qmZzPM2VRP53MEi/475Mzwwia7Od8WUG1Q
         plsis+oVgm1SAJTYQkoPrKyGKT1tcmWIQttc186J22ro20P7vbo5J9S9KQ3JPW3JvTjh
         bwnvIfO8yUxS0n7sMyVjhuFnW2pymYtyftWVINm08B7GTywGzrfhpGaGgybVyTcnlmG4
         XXvg==
X-Gm-Message-State: AOAM533u6yH5rPzueWZX4eg3FjuQfwY7AZsijLTR8IU9mUqLsPNCiflE
        0A++Up0MxA06STh/ZvfKPGtpfqGSBwS+wnjG6A==
X-Google-Smtp-Source: ABdhPJw4CoC+4YnPx9paZUF1NjvKVL9vT95MwMy2+cmxzWTEI2uG3jXylRkYQEBDHuyrhoKNdhBBS01EBIzuaZDy4NI=
X-Received: by 2002:a17:90b:2318:b0:1df:af66:1e8 with SMTP id
 mt24-20020a17090b231800b001dfaf6601e8mr15887140pjb.240.1653133697418; Sat, 21
 May 2022 04:48:17 -0700 (PDT)
MIME-Version: 1.0
From:   Zheyu Ma <zheyuma97@gmail.com>
Date:   Sat, 21 May 2022 19:48:06 +0800
Message-ID: <CAMhUBjmfenZo5c3Tn5NJ-mMvKhig=Rf0H24zgKK51QsgmJcK1Q@mail.gmail.com>
Subject: [BUG] atm: idt77252: Found a bug when removing the module
To:     3chas3@gmail.com
Cc:     linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

I found a bug in the driver idt77252, when removing the module, I got
the following flaw:

[   14.576507] BUG: KASAN: use-after-free in
idt77252_interrupt+0xfde/0x13c0 [idt77252]
[   14.576980] Read of size 8 at addr ffff88800a428008 by task modprobe/292
[   14.578516] Call Trace:
[   14.580577]  idt77252_interrupt+0xfde/0x13c0 [idt77252]

The bug occurs in line 2770, I guess that the reason is that the
driver free the irq too late.

Zheyu Ma
