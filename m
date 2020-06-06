Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95BBD1F06BC
	for <lists+netdev@lfdr.de>; Sat,  6 Jun 2020 15:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726504AbgFFNYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jun 2020 09:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbgFFNYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jun 2020 09:24:34 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB0BDC03E96A
        for <netdev@vger.kernel.org>; Sat,  6 Jun 2020 06:24:33 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id c8so13499895iob.6
        for <netdev@vger.kernel.org>; Sat, 06 Jun 2020 06:24:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=4kHz6DIcE9s1bm/+u+Nln01YonlT3quEnpLnCSk6xZ8=;
        b=VMZUrL9UBIol/2UIzAaK/2J4+g83iX6OJ9o0FDgX7J2xMBwlPi+oJkxTM2Ts4IKEYo
         zoldWnyEqyyz8QtsSN87k7nZMJH3LATdLvbJ7nnwThKR0q1VAn/lBGGbETX7O5Nn/iVh
         Wqk5fXmtSKoyllT7TTvmwlTy66Dh8U0jhLE6AkUH5DlEcq8XlmIrizymlBqflmA11AIf
         m5qWVtqLm2k5Ilqn0h/fB5wVZ5FZ/6UTGtxZAzR6K0bkx6+w1Y+2kBdVjfNKK2IoVFkH
         Osb8qvc5ItHhxr1WzOBRl6dwhxhNHRoOiKpc8uw3ArqVMd9dcWnnFfFX+dV4AYE7i1PY
         qGTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=4kHz6DIcE9s1bm/+u+Nln01YonlT3quEnpLnCSk6xZ8=;
        b=H67WW7voXJ8a5j+nG+htD0StVOaiJSV18V42rBs9sKPk/BRShkezH8O//G5ohadEph
         oB5nB9dCYDvyYaF8csqqSZ3BkfmYTop6gHrU4U63AgtIgLuD2CYv1lbVgIdy+RQ1K5c7
         7wGwtgTX2ppJm0s6YHkp1tNhwm5lE931oSiQpBMd7zOvnKI08GItwWRnyPKhvm0pjpoQ
         gcwMDafbnHTGyDzRXNZuTd7WF6Yc4R2xVA/Z24vHtyJ4PL/TC6g2LEH0efe+Wuu111tn
         IGZ+xiOgdCy3PRmbt7jC0o82+gRIOeBSfFFSJqXyR9sDyVT8Ow0/bxut3kElY6eVXaok
         SFBA==
X-Gm-Message-State: AOAM533tKZf5P0krU+Lf8V4lqep/kAeYbsd1sMO/UvakzBy9eM08McUr
        h9IDBa8okZ8EQJLUT95CeTG+vBLnhSlOmL6UaxQ6oRH3
X-Google-Smtp-Source: ABdhPJz8EuRPWHwAFLHchaI71DofS9PicmHc45OG2lTbc/KY46QT0TnUc1+FSvz5xxQbEG/WTwMPsDJrFM+a6AD6hdA=
X-Received: by 2002:a6b:6709:: with SMTP id b9mr13285725ioc.108.1591449873069;
 Sat, 06 Jun 2020 06:24:33 -0700 (PDT)
MIME-Version: 1.0
From:   Heiko Thiery <heiko.thiery@gmail.com>
Date:   Sat, 6 Jun 2020 15:24:22 +0200
Message-ID: <CAEyMn7a5SwQtMxrrJ-C0Jy6THZcCCPXp5ouC+jRLH4ySK-8p_A@mail.gmail.com>
Subject: ethtool build failure
To:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael et all,

I'm digging in the reason for a failure when building ethtool with
buildroot [1].

I see the following error:
---
data/buildroot/buildroot-test/instance-0/output/host/bin/i686-linux-gcc
-DHAVE_CONFIG_H -I.  -I./uapi  -D_LARGEFILE_SOURCE
-D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -Wall -D_LARGEFILE_SOURCE
-D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64  -Os   -static -c -o
netlink/desc-rtnl.o netlink/desc-rtnl.c
In file included from ./uapi/linux/ethtool_netlink.h:12,
                 from netlink/desc-ethtool.c:7:
./uapi/linux/ethtool.h:1294:19: warning: implicit declaration of
function '__KERNEL_DIV_ROUND_UP' [-Wimplicit-function-declaration]
  __u32 queue_mask[__KERNEL_DIV_ROUND_UP(MAX_NUM_QUEUE, 32)];
                   ^~~~~~~~~~~~~~~~~~~~~
./uapi/linux/ethtool.h:1294:8: error: variably modified 'queue_mask'
at file scope
  __u32 queue_mask[__KERNEL_DIV_ROUND_UP(MAX_NUM_QUEUE, 32)];
        ^~~~~~~~~~
---

The problems seems to be injected by the "warning: implicit
declaration of function".

When I move the __KERNEL_DIV_ROUND_UP macro right beside usage in
"uapi/linux/ethtool.h" the failure is gone.

---
diff --git a/uapi/linux/ethtool.h b/uapi/linux/ethtool.h
index d3dcb45..6710fa0 100644
--- a/uapi/linux/ethtool.h
+++ b/uapi/linux/ethtool.h
@@ -1288,6 +1288,11 @@ enum ethtool_sfeatures_retval_bits {
  * @queue_mask: Bitmap of the queues which sub command apply to
  * @data: A complete command structure following for each of the
queues addressed
  */
+/* ethtool.h epxects __KERNEL_DIV_ROUND_UP to be defined by <linux/kernel.h> */
+#include <linux/kernel.h>
+#ifndef __KERNEL_DIV_ROUND_UP
+#define __KERNEL_DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
+#endif
 struct ethtool_per_queue_op {
        __u32   cmd;
        __u32   sub_command;
---

Has anyone an idea what goes wrong?

[1] http://autobuild.buildroot.net/results/23dffe2f9766c12badb6e42bf3f0356c6df0cbfb/build-end.log

-- 
Thanks,
Heiko
