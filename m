Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA99C550C57
	for <lists+netdev@lfdr.de>; Sun, 19 Jun 2022 19:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234832AbiFSRVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jun 2022 13:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbiFSRVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jun 2022 13:21:33 -0400
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FAE86402
        for <netdev@vger.kernel.org>; Sun, 19 Jun 2022 10:21:31 -0700 (PDT)
Received: by mail-ed1-f46.google.com with SMTP id ej4so8210590edb.7
        for <netdev@vger.kernel.org>; Sun, 19 Jun 2022 10:21:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=8OEmoALXGQ6gYPbOaeoT7+PSThSt+jrIA/QdzsylFIs=;
        b=bpNPMSKBDlTuHgVCrJhMf4JwFc5kwqh9k2WKDw6OSsM/M6jji0OyUcyf/amQ3Q8pjq
         sheV+YQ1DnyFsAGzgR9f6T3VBx2JQEEAFZtQZKqD5mLZ+eXayaflFsJH09D7JqencX+i
         SUjKMKHx2qVl2/1GH4c09qP00IcBgMryzTznhPR79tjTHTmYX0PYCumspdt7DlVEwN+C
         /2cHuxGe6w/GwjYb7ahuN/2yjWI6E4aeJ1Rm/4pHKF6YmcakI00SW1NGoqSbmCv+Ur2g
         u2Kg1vnJOzvOMNehgiYNWTcn6L3/k86YiYL2e31LEbGSrbY9ULneKlpdNMTchjrnEetP
         tYeA==
X-Gm-Message-State: AJIora8afaufbiV4mk+NIpi+UQoyJPaw8uI1zydB2+/rwJgpZi5bc21k
        WWG+W1BdfLV7CuyDFvUBqQhXC8yWWa/oP/g0+d0r2sLn9DY=
X-Google-Smtp-Source: AGRyM1uOUisMoOVAfK+ySsDJRxjPhx0UH0yrFpqMn3K82mAJii5Jog8rKX8NSrA8GDn90/ImfAcdsAptlD1xBrKRX7A=
X-Received: by 2002:a05:6402:270a:b0:431:43f6:1e02 with SMTP id
 y10-20020a056402270a00b0043143f61e02mr24918862edd.317.1655659290100; Sun, 19
 Jun 2022 10:21:30 -0700 (PDT)
MIME-Version: 1.0
From:   "G.R." <firemeteor@ustc.edu>
Date:   Mon, 20 Jun 2022 01:21:18 +0800
Message-ID: <CAKhsbWZyBjB0OnPioRo76YGYZp1Ecxx+JO+06ZZcwZ0sy1EJ5A@mail.gmail.com>
Subject: Connectx-3 SR-IOV PF does not forward unicast packet when put into a
 bridge with mlx4_en 4.0.0 driver
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tariq,

I run into a potential mlx4 driver issue and find your name in the
maintainer list.
I summarized my setup and problem in a forum post [1] but found a
workaround later.
The workaround is simply switching to the ofed driver version 4.9-4.1.7.
The problem for me is that the ofed support for Connectx-3 is stuck at
v4.9 which in turn got stuck at Debian 10.0 with kernel version 4.19
while I'm already on Debian 11.2 with 5.10.
I'm writing to ask if this should be considered as a feature
separation between the ofed version and the kernel shipped version?
Or simply a bug that can be fixed -- seems that the SR-IOV feature is
otherwise working fine with the kernel shipped version?

I really wish I can use the kernel shipped version since it's
guaranteed to be available.
I really don't want to be locked on the ofed version which appears to
be gradually dropping support to old NIC models and is lagging behind
with distro support ...

Thanks,
Timothy

[1] https://forums.servethehome.com/index.php?threads/question-is-sr-iov-enabled-nic-supposed-to-forward-packet-in-linux-bridge-connectx-3-nic-problem.36751/
PS: have no idea if the netdev list only accept email from
subscribers. Hope this works...
