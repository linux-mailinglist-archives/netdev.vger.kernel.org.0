Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0C266ACA2
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 17:34:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230061AbjANQeZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Jan 2023 11:34:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbjANQeW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Jan 2023 11:34:22 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7731B558B
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 08:34:20 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id q23-20020a17090a065700b002290913a521so7686225pje.5
        for <netdev@vger.kernel.org>; Sat, 14 Jan 2023 08:34:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=K804Er1Hug6VYY78Fd1n7Xx3E+09FGLTVdZY62LwktE=;
        b=jAhJqitERzgMLXsdOI9XK+VjLpYvJJqj4n7weJvCOSSQQQnuBNktwuS1cvnqPyYMZ4
         A/mb5vYAAYOARy470NmyJNdr3UU5dCbju/iH93ThHATSh29ihHmK4tWGd4K+PatYpSXf
         I8gfCteiTPlZVftkPg0dZ5+E6aBYfWylyO6GrwfZJSURLwLImY1A1r+BkJiZkVBb2+pI
         nuln55CgqfI1KI6WGEZbxJPqsmbGgiJgVmnQkRAZ60H7CCjNjvVfYIQwZNq8kOXwdFj6
         U2BDvblWb4mVUuy9kgis5bPbrGgRLQFtrzY58lfPsx42wXxK48XDvXGJv5aCrlwv15lC
         biPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=K804Er1Hug6VYY78Fd1n7Xx3E+09FGLTVdZY62LwktE=;
        b=b2q1BZXGrhyyfox4PqLytLvxB/MYtDzUTL3R/XO7UjeyaygmtcJxoArNjKHEnQUaVo
         9aLhEmiWVFLpgURmUf+I+OJtFuAEY8VDVEHSK/y1ah0K/wioUs300XmGNq0XAO7w/kum
         0BzN4Erpm0RQRG/8sVPWk8EPStXKATgub9qeHUzkiaVQXEnAQPTs29nG1+ejOVbQYIn9
         OVwUhNC/qUrtBesAcrdLDKLa0FJQUWibkILVRlyfmNYjtbDvQZVdXb5N4Aap9a6Tw7rO
         BiStSacGG53TM7xSDjJVV3rgu8sHBm/Ca6ogvpvBxvJQ36pZ6Dol+wOJgBnCTDoFzIm8
         fJwA==
X-Gm-Message-State: AFqh2korh7DIqyNuTmYEgBWxQT+vABEZUHKC/mkdcwTZzDYgtdOLBthf
        ytq7qjLulIbjmTsinR4h9nNbIbnaMxQ=
X-Google-Smtp-Source: AMrXdXvVhZ3qUJi+RxnvG+ozHBmPM5VbGZDrXE8VYHZlyBlM9gF0LeiAl8Y7M1QtTq2wyqHjJ/koGw==
X-Received: by 2002:a17:90a:e7d0:b0:229:46f0:6f6d with SMTP id kb16-20020a17090ae7d000b0022946f06f6dmr3131836pjb.42.1673714059540;
        Sat, 14 Jan 2023 08:34:19 -0800 (PST)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z7-20020a17090ad78700b002270155254csm11864797pju.24.2023.01.14.08.34.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Jan 2023 08:34:18 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>,
        Markus Mayer <mmayer@broadcom.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: [PATCH ethtool v2 0/3]  Build fixes for older kernel headers and musl
Date:   Sat, 14 Jan 2023 08:34:08 -0800
Message-Id: <20230114163411.3290201-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michal,

These 3 patches fix build issues encountered in the 6.1 release with
either older kernel headers (pre v4.11) or with musl-libc.

In case you want to add a prebuilt toolchain with your release procedure
you can use those binaries:

https://github.com/Broadcom/stbgcc-8.3/releases/tag/stbgcc-8.3-0.4

Changes in v2:

- reworked the first commit to bring in if.h, this is a more invasive
  change but it allows us to drop the ALTIFNAMSIZ override and it might
  be easier to maintain moving forward

- reworked the third commit to avoid using non standard integer types

Florian Fainelli (3):
  uapi: Bring in if.h
  netlink: Fix maybe uninitialized 'meters' variable
  marvell.c: Fix build with musl-libc

 Makefile.am             |   6 +-
 internal.h              |   7 +-
 marvell.c               |  34 ++---
 netlink/parser.c        |   2 +-
 uapi/linux/hdlc/ioctl.h |  94 +++++++++++++
 uapi/linux/if.h         | 296 ++++++++++++++++++++++++++++++++++++++++
 6 files changed, 415 insertions(+), 24 deletions(-)
 create mode 100644 uapi/linux/hdlc/ioctl.h
 create mode 100644 uapi/linux/if.h

-- 
2.25.1

