Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C32AE0982
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 18:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389518AbfJVQql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 12:46:41 -0400
Received: from mail-wr1-f73.google.com ([209.85.221.73]:47113 "EHLO
        mail-wr1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389034AbfJVQql (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 12:46:41 -0400
Received: by mail-wr1-f73.google.com with SMTP id 92so4103764wro.14
        for <netdev@vger.kernel.org>; Tue, 22 Oct 2019 09:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=FxzIQyDunHtVBZCVK6ttUg3oB9s0DEBjz5E3R+aCqJU=;
        b=bwG8FsZzFAPaLXF+EeN/hUCP9Ctc2PqOreWk2uXXPC1rx7igFgoYTwQmMPUoum8kN2
         BCDHyY+9Y3k4GDqLnxZX4DJeS4dHVZz2+0dRswv3cdpUzr/TwgGbwwFH8QyCXUgUjuhZ
         Nks82aX0zUMLehsuEDOPYo2bHPgtiRFXEe4h7LU+Z1NBLKnIwZRQ2yBDEq33H4IQb/8R
         eNidmD5c9kaZE2RILTyQvcpk2qanv245jpGAsz/TPPZSFFwDGPHmUQKp1M3LWnrLJXq7
         NuTimyO/udpVPVqtAL1NOviEG57gds0FKsZoYgaXz6fcekzuyx53kphtB0HI5IqkuVvQ
         aoDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=FxzIQyDunHtVBZCVK6ttUg3oB9s0DEBjz5E3R+aCqJU=;
        b=MdbhY7x9thXx3uMdifYur+MhDxNXYshFy91a1ZS2UsIcPtwF/+NnM+Z2vT+lY/Xt7/
         tOzBgfllAUjbZDb5njgjvwI1MPdSh9IK6L9G/m6SPTDWXRHDFwh73oSvrrkg8SDVj/O4
         DIMpg2Q00iCCMnzHo/3u+7HbOKMeKJdAPltAO4aOOjS0CBJTVnvQnat3OvL6XKqT/3Gv
         mNbLJxunirJAJiX2gRrM6vT8NHBMu/5w3ix42RA78XUzu7OmMgD0GBfVfdd0tU8CfVLK
         LFJj6vEyl6aFO/1tY7+/+6IUI/KOdNsmOTLP5XgUgqNer1ROWkogjdQJnJeXDYYQC8Lj
         +log==
X-Gm-Message-State: APjAAAUOxeFxBxHuTrffFChwU9Kmyj7SCYaTnCJdpW4bPb/yikxecHUO
        J1k1tXIhG9RI1FUmxXvDDe/ZPe+6KwiZRyGb
X-Google-Smtp-Source: APXvYqzw4xdCDUIijFFJk3ia1kfm+QpMoPGMUaeGlY+KJBFhy0thno5gFZaPKu1JXCicdUguQwe6wX+B/HIHHpRY
X-Received: by 2002:a5d:4644:: with SMTP id j4mr944846wrs.355.1571762797288;
 Tue, 22 Oct 2019 09:46:37 -0700 (PDT)
Date:   Tue, 22 Oct 2019 18:46:30 +0200
Message-Id: <cover.1571762488.git.andreyknvl@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
Subject: [PATCH 0/3] kcov: collect coverage from usb and vhost
From:   Andrey Konovalov <andreyknvl@google.com>
To:     linux-usb@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Windsor <dwindsor@gmail.com>,
        Elena Reshetova <elena.reshetova@intel.com>,
        Anders Roxell <anders.roxell@linaro.org>,
        Andrey Konovalov <andreyknvl@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset extends kcov to allow collecting coverage from the USB
subsystem and vhost workers. See the first patch description for details
about the kcov extension. The other two patches apply this kcov extension
to USB and vhost.

These patches have been used to enable coverage-guided USB fuzzing with
syzkaller for the last few years, see the details here:

https://github.com/google/syzkaller/blob/master/docs/linux/external_fuzzing_usb.md

This patchset has been pushed to the public Linux kernel Gerrit instance:

https://linux-review.googlesource.com/c/linux/kernel/git/torvalds/linux/+/1524

Changes from RFC v1:
- Remove unnecessary #ifdef's from drivers/vhost/vhost.c.
- Reset t->kcov when area allocation fails in kcov_remote_start().
- Use struct_size to calculate array size in kcov_ioctl().
- Add a limit on area_size in kcov_remote_arg.
- Added kcov_disable() helper.
- Changed encoding of kcov remote handle ids, see the documentation.
- Added a comment reference for kcov_sequence task_struct field.
- Change common_handle type to u32.
- Add checks for handle validity into kcov_ioctl_locked() and
    kcov_remote_start().
- Updated documentation to reflect the changes.

Andrey Konovalov (3):
  kcov: remote coverage support
  usb, kcov: collect coverage from hub_event
  vhost, kcov: collect coverage from vhost_worker

 Documentation/dev-tools/kcov.rst | 120 ++++++++
 drivers/usb/core/hub.c           |   5 +
 drivers/vhost/vhost.c            |   6 +
 drivers/vhost/vhost.h            |   1 +
 include/linux/kcov.h             |   6 +
 include/linux/sched.h            |   6 +
 include/uapi/linux/kcov.h        |  20 ++
 kernel/kcov.c                    | 464 ++++++++++++++++++++++++++++---
 8 files changed, 593 insertions(+), 35 deletions(-)

-- 
2.23.0.866.gb869b98d4c-goog

