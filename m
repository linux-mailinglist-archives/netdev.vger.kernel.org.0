Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5AC9685DB2
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 04:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbjBADHz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 22:07:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbjBADHt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 22:07:49 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDA0283F7
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 19:07:47 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id k13so17189438plg.0
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 19:07:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:subject:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Er4Yght1xi+5+mJgB7Cn//y79ZqsVY/jIjJJJ+J+ljY=;
        b=6aVhHAz01UQrvLjyVPV5EXdcIVvQR7uvcSCyIkZYHipRpK2P44AHNps8eQZ2CQA1Z2
         GlcFqEiJ3JdTVrBweb7RkWnFFEgiaKa7U3b3BI4KIe/G07Zu+UhSPYY9vkXyvMGFN99O
         hofpKM0SkhkZCR9bb2dlfkHO4sucB2HlW/Tt0EQ16Ab7k/7xD69vjGAU9vse3Qzaeskj
         ag+TceCWZd7BG0YQlszdvTQbFkCbhBgAvkQq1aZH6gswaB/hYUVcVKFQdLmE32ZvqKaZ
         Vi6JDrYW9I6p8Irq1wdgciVPyTHaUnHJqUGF6OOEtRT8aVkKXiqw7Nh0RkmYyUh32q+H
         2Mmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:subject:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Er4Yght1xi+5+mJgB7Cn//y79ZqsVY/jIjJJJ+J+ljY=;
        b=v93zBSo2t6VS8VaRQbMG/ec0JwsCeH/sEIHDX8TDNqxby/k4gtmAVn14yp7hEs0v4u
         a8qCBbOVJmmZx9Nuim9cmsvAiWe9OZiiyQUiHXkoD1Czi8NkuQL6uoCEEZCFdayUMZae
         IQ/6Fdi0HFmxRvj1B24qzUQGgHdEAKgSBoMeFjkOWEFiQbrKSbqDELJrXQrp558H1+V0
         CYJ7KZv0InqIfQVOY/2mG88EtFu3Pr1ZhqK50C/AiaYemNZ3IPbSCMHuAyahCzh91p1r
         ZLwlcv0/20uAmu18LDTqXLPcEJ4R5xmuiAtuxVJE0W+LIEp/D0NGffS9KHhXflxPhm4b
         H+Eg==
X-Gm-Message-State: AO0yUKXtK/m2lQagm4OUeV9r+pPRxlv3OY2h41uvPDj0CxwCVCMhd7w7
        PD4DY+9pZPWhKgedPjGZBD+14cE7c06Bx13t/V0=
X-Google-Smtp-Source: AK7set95THLxKN+a9/1kubrkd3QRmwOH1mMhWyxp+m1WBCtTrspcgTW7LB5wN9EDPWywPNFmZHvjqg==
X-Received: by 2002:a17:902:e881:b0:198:a49b:9f3b with SMTP id w1-20020a170902e88100b00198a49b9f3bmr1432167plg.22.1675220867005;
        Tue, 31 Jan 2023 19:07:47 -0800 (PST)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id bc11-20020a170902930b00b001960096d28asm10471558plb.27.2023.01.31.19.07.46
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Jan 2023 19:07:46 -0800 (PST)
Date:   Tue, 31 Jan 2023 19:07:45 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: Fw: [Bug 216986] New: sendmsg returns EINVAL when neighbor table is
 full
Message-ID: <20230131190745.6dbca9a3@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Begin forwarded message:

Date: Wed, 01 Feb 2023 02:21:14 +0000
From: bugzilla-daemon@kernel.org
To: stephen@networkplumber.org
Subject: [Bug 216986] New: sendmsg returns EINVAL when neighbor table is fu=
ll


https://bugzilla.kernel.org/show_bug.cgi?id=3D216986

            Bug ID: 216986
           Summary: sendmsg returns EINVAL when neighbor table is full
           Product: Networking
           Version: 2.5
    Kernel Version: 5.2.60
          Hardware: All
                OS: Linux
              Tree: Mainline
            Status: NEW
          Severity: normal
          Priority: P1
         Component: IPV4
          Assignee: stephen@networkplumber.org
          Reporter: singhpra@juniper.net
        Regression: No

On one of our linux boxes, we happen to hit the
net.ipv4.neigh.default.gc_thresh3
limit and saw "neighbour: arp_cache: neighbor table overflow! ".

Subsequent to this, we saw EINVAL error for some of the applications that w=
ere
trying to do a sendmsg. The applications treats the EINVAL error as fatal
(especially when sendmsg was working with the same set of ARGS earlier on t=
he
system).

The question here is should the kernel neighbor table state result in an er=
ror
like EINVAL for the application where the arguments provided by the applica=
tion
looks valid and have been working so far. Is there any other reason that
justifies the EINVAL returned for this case by kernel?

Looking further into the code it seems like in the function ip_finish_outpu=
t2,
even on the latest kernel, post the checks for neighbor entry, the status of
ip_neigh_for_gw for error is not used, which in this case would be ENOBUFS =
and
I would think could also be a possible alternative to return here instead of
EINVAL at the end of the function.=20

ip_finish_output2:
        neigh =3D ip_neigh_for_gw(rt, skb, &is_v6gw); =20
                    if (!IS_ERR(neigh)) {
                   =E2=80=A6
               }                                                           =
    =20
        =3D=3D>perhaps can return this neigh if IS_ERR is true =20
        net_dbg_ratelimited("%s: No header cache and no neighbour!\n",
                                                                 __func__);
        kfree_skb_reason(skb, SKB_DROP_REASON_NEIGH_CREATEFAIL);
        return -EINVAL;=3D=3D> here


___neigh_create:
        n =3D neigh_alloc(tbl, dev, flags, exempt_from_gc);
        trace_neigh_create(tbl, dev, pkey, n, exempt_from_gc);
        if (!n) {
                rc =3D ERR_PTR(-ENOBUFS); =3D=3D> returns ENOBUFS
                goto out;
        }

--=20
You may reply to this email to add a comment.

You are receiving this mail because:
You are the assignee for the bug.
