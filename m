Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D69726A71B
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 13:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387582AbfGPLNU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 07:13:20 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40755 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387532AbfGPLNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 07:13:20 -0400
Received: by mail-pf1-f195.google.com with SMTP id p184so8951172pfp.7
        for <netdev@vger.kernel.org>; Tue, 16 Jul 2019 04:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=l8lUDijBiyY5cnjhjm2bVu88mH5lRLrGchTwxKmKfRM=;
        b=n+WcafFy/24JXY2LfhO+hw1ngbjN1W/bcJu99Sy2jNXlHMVIp+hq+Kw0Z8D3nCpVu3
         p615sFT47ypPa/pyRofK9aC5YX4c9pUMTqeia6e2T3YfaHhYc+/Qt/zfpomkHJCaqUIs
         Wa3K+jFwzvvLdB4h0f0p454uZScZX3rew/arPvBW6/L4VybGE25GvXdNvixCxHe4AZIL
         b0bAxU83fAlmu7KERFHiUOtHyA3bG7H+ByV4pFA9tuojhnFXGGBzvpkK7kPhO+KCbAEm
         5fcmvjoiCZmwESd8VfOcMHf0txSN7uCQOGKcgWmHgCdDKMFNNj5ed8K2ZlMvVyPzifGd
         Fkbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=l8lUDijBiyY5cnjhjm2bVu88mH5lRLrGchTwxKmKfRM=;
        b=SXR3FQWSEq1tXk89Xy58LvZjJwejBSbXyPsWMPo1YC09ngFo+PL6za97WewYBG2FY/
         /hv7oaewXtBlG2yHTeNTFKZhhyaokswxVD00rc4GsKPl7JDBZGFyRsd8T4Vz6NA/SS3e
         Erz0Rs71WspKgGV/WtCIp6ZSS63jfxNm/VFQMsqp790cIbl58vPkwPrebTFTDDQ8PPol
         H2bMGLm2DYJHH/rHvZJopwPKsthwEWUPXKrWkUYdU4qA8FMxiGJO7iIKoCF9KB8Yy74J
         k44AEIErOGoWkw5yiis8OKxEigXfXesILs7d+S+N1hAXitpB8X//lrucQkpiNPH/qLLe
         Az9Q==
X-Gm-Message-State: APjAAAV9wAhunkS8JEgHYv15AxMdkzh+PfiQWSvfggpA0yz00MPfp3HJ
        S7O3sgAaK+F2h/8V3By1uKUV6Q==
X-Google-Smtp-Source: APXvYqx2luVpK2SH0RmMNrxXQpvln9vKdfadl33zXwjMdrs+FXh/PcBB7WUo0CD3twBTUWfaiHb80g==
X-Received: by 2002:a63:e356:: with SMTP id o22mr32978109pgj.150.1563275599407;
        Tue, 16 Jul 2019 04:13:19 -0700 (PDT)
Received: from localhost.localdomain (li1433-81.members.linode.com. [45.33.106.81])
        by smtp.gmail.com with ESMTPSA id 21sm19324907pjh.25.2019.07.16.04.13.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 16 Jul 2019 04:13:18 -0700 (PDT)
From:   Leo Yan <leo.yan@linaro.org>
To:     Russell King <linux@armlinux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Justin He <Justin.He@arm.com>
Cc:     Leo Yan <leo.yan@linaro.org>
Subject: [PATCH 0/2] arm/arm64: Add support for function error injection
Date:   Tue, 16 Jul 2019 19:12:59 +0800
Message-Id: <20190716111301.1855-1-leo.yan@linaro.org>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This small patch set is to add support for function error injection;
this can be used to eanble more advanced debugging feature, e.g.
CONFIG_BPF_KPROBE_OVERRIDE.

I only tested the first patch on arm64 platform Juno-r2 with below
steps; the second patch is for arm arch, but I absent the platform
for the testing so only pass compilation.

- Enable kernel configuration:
  CONFIG_BPF_KPROBE_OVERRIDE
  CONFIG_BTRFS_FS
  CONFIG_BPF_EVENTS=y
  CONFIG_KPROBES=y
  CONFIG_KPROBE_EVENTS=y
  CONFIG_BPF_KPROBE_OVERRIDE=y
- Build samples/bpf on Juno-r2 board with Debian rootFS:
  # cd $kernel
  # make headers_install
  # make samples/bpf/ LLC=llc-7 CLANG=clang-7
- Run the sample tracex7:
  # ./tracex7 /dev/sdb1
  [ 1975.211781] BTRFS error (device (efault)): open_ctree failed
  mount: /mnt/linux-kernel/linux-cs-dev/samples/bpf/tmpmnt: mount(2) system call failed: Cannot allocate memory.


Leo Yan (2):
  arm64: Add support for function error injection
  arm: Add support for function error injection

 arch/arm/Kconfig                         |  1 +
 arch/arm/include/asm/error-injection.h   | 13 +++++++++++++
 arch/arm/include/asm/ptrace.h            |  5 +++++
 arch/arm/lib/Makefile                    |  2 ++
 arch/arm/lib/error-inject.c              | 19 +++++++++++++++++++
 arch/arm64/Kconfig                       |  1 +
 arch/arm64/include/asm/error-injection.h | 13 +++++++++++++
 arch/arm64/include/asm/ptrace.h          |  5 +++++
 arch/arm64/lib/Makefile                  |  2 ++
 arch/arm64/lib/error-inject.c            | 19 +++++++++++++++++++
 10 files changed, 80 insertions(+)
 create mode 100644 arch/arm/include/asm/error-injection.h
 create mode 100644 arch/arm/lib/error-inject.c
 create mode 100644 arch/arm64/include/asm/error-injection.h
 create mode 100644 arch/arm64/lib/error-inject.c

-- 
2.17.1

