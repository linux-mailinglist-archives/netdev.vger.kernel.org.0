Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C73DB224EAF
	for <lists+netdev@lfdr.de>; Sun, 19 Jul 2020 04:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbgGSCRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 22:17:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726284AbgGSCRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jul 2020 22:17:01 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B18C0619D2;
        Sat, 18 Jul 2020 19:17:01 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 207so7310481pfu.3;
        Sat, 18 Jul 2020 19:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QM6lwvVyYd4T8B0+uW+YnPRkMUj3R5Nyhyg6SYyEzuk=;
        b=hIpg0Ll9yZxRGxf6GH8H2E/zPabJqjA8GQJcWAXolZaWgCWxG73f4X1hCu6XLjkdVN
         W3EOLpvWvbPvEdTwe5uTSz/u/bGGt9g7OTPpCw9tMGvMsapnOgDqT4aoWs+a/P4O1+6D
         DQQ0xIBwNnhWdFTylqNZFGZrNRcDeo9hpYvfKaMXvSmHbukEdqF0xkBWzUMJwAqbl7wT
         8ESYZutpwtwMaTi8f2fPHr0E5AMVemklvnRLmWozkNXOCVpiDS/rr4snQcvRC+J/rg8b
         whFmrLQNS7ylBReNWjBYB+EQjbgHu+QSiQbXah5FOU5X+HU4IL9Q5zvBvzPtOwOIgOHz
         rCIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QM6lwvVyYd4T8B0+uW+YnPRkMUj3R5Nyhyg6SYyEzuk=;
        b=cT2ytzC5OOt1PW5fopUjbhn2IlUnj2Uw86Z8nyailw6J3Bnv2iU4TrU4WpMGtllWG8
         +dRV/hnmH0VSQVMvgAtS7+ng2RUKbu1Xy0au0gqTbkMhxkSgJlBvvOMPRMgnXegIgxM8
         btaGbPQO0WmWe1BgskpmXMvlFC6VHFU0FUOL3E1l2qRaw1lKJxhjaVqL91/i1xMQfCUs
         GaefG2JYm2WSDrA+P6DvR/RQ0vIkcLlwUZpuNpmH51/zDrs/7/jFNMY+EzB0fv7PqY9Z
         Ryl1chspSo8U+N3Cc8FYilLOQDduHGKIn29WeugIDASjzSfWXLdHljAzEAnUj8Rj6zM0
         rWgA==
X-Gm-Message-State: AOAM531XUOrxiWhoAAkRqQuuClHqw11DDig0wZRQ7SdSSwz2As50HYHG
        Opy9tUgEVsikQPP6nn3+hlNJzmrY
X-Google-Smtp-Source: ABdhPJzEVypf4YCwvhByvDVA676j0GBMtNyQSzchcKBsvcNQ+Ikfqzm8fiYPDq4RZFbZc/Rl6vNgpQ==
X-Received: by 2002:a63:3cc:: with SMTP id 195mr13628525pgd.296.1595125020975;
        Sat, 18 Jul 2020 19:17:00 -0700 (PDT)
Received: from octofox.hsd1.ca.comcast.net ([2601:641:400:e00:19b7:f650:7bbe:a7fb])
        by smtp.gmail.com with ESMTPSA id a68sm6891159pje.35.2020.07.18.19.17.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2020 19:17:00 -0700 (PDT)
From:   Max Filippov <jcmvbkbc@gmail.com>
To:     linux-xtensa@linux-xtensa.org
Cc:     Chris Zankel <chris@zankel.net>, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 0/3] xtensa: add seccomp support
Date:   Sat, 18 Jul 2020 19:16:51 -0700
Message-Id: <20200719021654.25922-1-jcmvbkbc@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

this series adds support for seccomp filter on xtensa and updates
selftests/seccomp.

Max Filippov (3):
  xtensa: expose syscall through user_pt_regs
  xtensa: add seccomp support
  selftests/seccomp: add xtensa support

 .../seccomp/seccomp-filter/arch-support.txt      |  2 +-
 arch/xtensa/Kconfig                              | 15 +++++++++++++++
 arch/xtensa/include/asm/Kbuild                   |  1 +
 arch/xtensa/include/asm/thread_info.h            |  5 ++++-
 arch/xtensa/include/uapi/asm/ptrace.h            |  3 ++-
 arch/xtensa/kernel/ptrace.c                      |  8 +++++++-
 tools/testing/selftests/seccomp/seccomp_bpf.c    | 16 +++++++++++++++-
 7 files changed, 45 insertions(+), 5 deletions(-)

-- 
2.20.1

