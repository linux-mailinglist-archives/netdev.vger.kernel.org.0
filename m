Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD3A759FFCE
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 18:51:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238310AbiHXQvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 12:51:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237544AbiHXQvB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 12:51:01 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D743F1CC
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 09:51:00 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id r14-20020a17090a4dce00b001faa76931beso2248367pjl.1
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 09:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=message-id:date:subject:cc:to:from:from:to:cc;
        bh=xtVDowaN914RxHCs7M0KKGDdhcAlUUWQxfHYo8mUrzc=;
        b=f/io1pyJ6ZeLjdPqLls/kolPUwhm2c5GVvfYkO1zDzQQFTnzd7TcvjkggKXEPq8sT5
         rUFbiVH1Z6bYfRn8vUUwFa9XuBqy3sHg6Sk/z3bMB8ezbAkJyx+YGeli9hbyz0ZcVvA9
         +PNkcKd2BygfM/SvVJa+YoulcxM1soH7UOBtYV4Piluo2MX0Ww7H120e6AC60C+xV3IG
         x/3gx6WRPoicga7Immt33O0trjpCPwlnyvg7rsbtgcNi4wQbJLTkLS5S+ZStf2FHb41s
         Xwe2jCePFo0TkUR8fdvCxIp+99gj22yEOVgrAzQ4w7koF6NcTfC11iwWcBteBPD18DWj
         FtLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=xtVDowaN914RxHCs7M0KKGDdhcAlUUWQxfHYo8mUrzc=;
        b=wobJrWa55qAPWWYZ9wu8JzMF7ZS6eJYfAPGNHhUat6EGu59rS1z+2aNmDJaFj0J8oH
         gsRqrLw5wUJUShqHFdzTRpA+yGMFmXblrD/EbiyohdHYWNgzkFqnQlznf1ylM7qBYQui
         nGOHzOVUKpYvRq8eqyAdw6krviBEx3ZIgTPeNpY3lIwb3AsLTD6BvJBWMUpUP9MYRoAk
         KIw+xcRg9477jVphXHPYlH7DeQTPqVETiVRE8dMf0AjpJdm5uVq/riSvWun3XWRVEYMq
         WIb/aOkAfV042nW3YK6F67nksFjRoav3lcKUOKJbWYfVf1nSk9QOCS6wUxrQC/1kwaIZ
         JVYw==
X-Gm-Message-State: ACgBeo0j8pHof126Rj1gBEGXvOYR5E+UwJLhHwyXcI58nYpMIxgSdWUJ
        ZKYP9v8jvoqu1CqVGJQtCUvfrA==
X-Google-Smtp-Source: AA6agR6YA/KWpKGkF5tntrWhSR7g9Xc/OG+4VQOW8Umm3k1XmhaLI/v6NsWny/v8DWxp2BceFFxlcA==
X-Received: by 2002:a17:903:110c:b0:172:6a39:436b with SMTP id n12-20020a170903110c00b001726a39436bmr29049779plh.131.1661359859998;
        Wed, 24 Aug 2022 09:50:59 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id a68-20020a621a47000000b005366280c39fsm8960349pfa.140.2022.08.24.09.50.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 09:50:59 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Cc:     drivers@pensando.io, mohamed@pensando.io,
        Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net 0/3] ionic: bug fixes
Date:   Wed, 24 Aug 2022 09:50:48 -0700
Message-Id: <20220824165051.6185-1-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are a couple of maintenance bug fixes for the Pensando ionic
networking driver.

Mohamed takes care of a "plays well with others" issue where the
VF spec is a bit vague on VF mac addresses, but certain customers
have come to expect behavior based on other vendor drivers.

Shannon addresses a couple of corner cases seen in internal
stress testing.

R Mohamed Shah (1):
  ionic: VF initial random MAC address if no assigned mac

Shannon Nelson (2):
  ionic: clear broken state on generation change
  ionic: fix up issues with handling EAGAIN on FW cmds

 .../net/ethernet/pensando/ionic/ionic_lif.c   | 95 ++++++++++++++++++-
 .../net/ethernet/pensando/ionic/ionic_main.c  |  4 +-
 2 files changed, 93 insertions(+), 6 deletions(-)

-- 
2.17.1

