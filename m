Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBA19E1F31
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 17:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406672AbfJWPYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 11:24:38 -0400
Received: from mail-wm1-f73.google.com ([209.85.128.73]:56514 "EHLO
        mail-wm1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390888AbfJWPYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 11:24:38 -0400
Received: by mail-wm1-f73.google.com with SMTP id l184so6313252wmf.6
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 08:24:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=sl8Rii3oW8FrPppkHNfXTlYWCFHCdXZbJp62ZIanwPg=;
        b=ghJIP1Ctautskm3gCcyff8Fxk9XjUZJnGCzEtm3Rl/xa3OQaA7z8Hj2K2nk/9K0ZVV
         OF+hfWb+AgK9wd8dgydPemrquzm2MQhbeGLmyaDDzkHnJbU6bTw4am6muwzKs1pG0gMl
         ViCBVAS6V8lonROATMQ/xHp4LMBWEuofzZhWqM+57MOvtOV6KIQiMs91jjbuC1SjFMGQ
         TJ/G+y0wWzii5SyCE4xCYBgtIQas6JpF8l6FkKmIrRdoyJTr31mPOxcMkwBwaQ7eOSIi
         WNIVEkpKXUoPyA5U3Rj8yghYjCOUpqT2B9yQusYIqZ18ZfTLxbudeUdV6xgfDpt47nqA
         jmNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=sl8Rii3oW8FrPppkHNfXTlYWCFHCdXZbJp62ZIanwPg=;
        b=Rjfd/bqJoEbm8OSDZeYeT65FDv9zoizAcPUVjN32JQ+MF1DFlR6VSExwdgaozhxcdt
         UW9AB5fwyfRf5tf3EkUFMP2F4wXNb3lJ+m6V1jr8Nkr4zI6iE0W/hU3sZRCFvdeK0V8J
         +D1uUpwwsWiQltZo25DrnLbnyThyFP6wr4N+Lvgkr1mHbv2cdNTy4XJMlRaaNjRDjxj6
         v14RATtH1XKm9aNKlQuYmQECCUEolz712zMDvTIxJ/VbXD/YtXmzCxRSIAwdpO8Qy33x
         dsYQDutn24slH+LiTl5lZfn/rq2JWyF9+nL1oj9DiFaRGE+wXj8kkhd51XHkoS9b3bsO
         4m3w==
X-Gm-Message-State: APjAAAXQRpWIxG/O+JZdd98Tt1q6v4pw9IySBZDBKx+z64XvTvytiMwV
        VjKSHpY66Zvkx5jaTyGfHQoBjmhdYJ0ARbCI
X-Google-Smtp-Source: APXvYqyjuZuZmULkMOG81SOZwdNmn4nrXac1sf+c/F+14+2oEH7lN31t5wlahvJCBOuTrGSQ8vrMv/7kGc0xWT1F
X-Received: by 2002:a5d:4491:: with SMTP id j17mr8733249wrq.46.1571844275774;
 Wed, 23 Oct 2019 08:24:35 -0700 (PDT)
Date:   Wed, 23 Oct 2019 17:24:28 +0200
Message-Id: <cover.1571844200.git.andreyknvl@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
Subject: [PATCH v2 0/3] kcov: collect coverage from usb and vhost
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
        Alexander Potapenko <glider@google.com>,
        Marco Elver <elver@google.com>,
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

Changes v1 -> v2:
- Changed common_handle type back to u64 (to allow extending it in the
  future).
- Reworked kcov_remote_handle() helpers.
- Fixed vhost annotations when CONFIG_KCOV is not enabled.
- Use kcov_disable() instead of kcov_remote_reset() when
  KCOV_REMOTE_ENABLE fails.

Changes RFC v1 -> v1:
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

 Documentation/dev-tools/kcov.rst | 128 +++++++++
 drivers/usb/core/hub.c           |   5 +
 drivers/vhost/vhost.c            |   6 +
 drivers/vhost/vhost.h            |   1 +
 include/linux/kcov.h             |  23 ++
 include/linux/sched.h            |   6 +
 include/uapi/linux/kcov.h        |  25 ++
 kernel/kcov.c                    | 480 ++++++++++++++++++++++++++++---
 8 files changed, 639 insertions(+), 35 deletions(-)

-- 
2.24.0.rc0.303.g954a862665-goog

