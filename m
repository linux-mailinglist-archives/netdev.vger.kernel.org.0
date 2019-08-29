Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34BFDA177A
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 12:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727688AbfH2K5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 06:57:02 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51963 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727123AbfH2K5B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 06:57:01 -0400
Received: by mail-wm1-f65.google.com with SMTP id k1so3234062wmi.1
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 03:57:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=V48A0d02O6Zz1PNIZqcK4fmc9jSgKnu0iuclFkazHTM=;
        b=szNMJLYMtcVYjo6S4+ThfKliFq245mqyL3fCf8Xq1tmQyNaTMIkGJ44SN4T3a9Ts28
         30ym1t/4vNXyDDp43RyTj5Rkuxi447a7mgE8jhXLCPhhAOjI6+cWSNn5KuSk7scLU+lF
         1FEp8w8e3a6qf7OY76rXtlAB2t+AAB9jc12faO8lHLdhV7uOMxTPyjvVefaN5HonJY+6
         /4CHwjzXjfW9NUM/7NrQo7gnoPUl2ZKEEMQW92iCeZuP9xDxFB70VtOEcnE5QYnJ0NEI
         MUWYPpUr+5YPyKPzq8JWH3EJQe1IrS1EeYK8l0dTBhT12w6BbyPdvK92DLuLAPYT1DRX
         B3Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=V48A0d02O6Zz1PNIZqcK4fmc9jSgKnu0iuclFkazHTM=;
        b=MDUoYASTb1mfVL3C0aMrnyf9JSXf7gtL0dgiSU6v4vUHPrAHGSTTYvrfrEZA8AdZSN
         eUiDHBoWxjnteisUR/4S3qAWKFJzvN1o9uJtRgSp6z9Y8Ln0VUuGCdh6yG8TYzIPBOad
         v1s2/ViNGvRBFk49k+pn+GcT7+7Zo3Sttr3oqgMn/cTEvG9INFe0kXp6TiSETuauzb9e
         1nnaXTW4Y3zM2kpBo0GS8k5jb4Ii227bPbsddTMKu9XdgKhHY+wvU1dnJNPSYAuIbG1D
         0Ph26q68kaeNK6teHHWB2SLwDSsYfH/tT4PdL76GhrYrPUY009u0LjiVqmXOi6caEJ0p
         zwNQ==
X-Gm-Message-State: APjAAAVzcMfAc7NLGLp90Hm+dAZb384Pd2aU+bisZiQkpoONbcrU5WYq
        ByEWL7aKEdYyrRUvC5rrVtQZxw==
X-Google-Smtp-Source: APXvYqww27sgIBuv7JIwIuZkS5SCLc+TbWa0N8DnpGZwDPmOJkiHy9A/sbxGzPquNpN8qb/JrcfSRw==
X-Received: by 2002:a1c:7ed7:: with SMTP id z206mr4769098wmc.124.1567076220190;
        Thu, 29 Aug 2019 03:57:00 -0700 (PDT)
Received: from cbtest32.netronome.com ([217.38.71.146])
        by smtp.gmail.com with ESMTPSA id j18sm2091938wrr.20.2019.08.29.03.56.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 03:56:59 -0700 (PDT)
From:   Quentin Monnet <quentin.monnet@netronome.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        oss-drivers@netronome.com,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: [PATCH bpf-next 0/3] tools: bpftool: improve bpftool build experience
Date:   Thu, 29 Aug 2019 11:56:42 +0100
Message-Id: <20190829105645.12285-1-quentin.monnet@netronome.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,
This set attempts to make it easier to build bpftool, in particular when
passing a specific output directory. This is a follow-up to the
conversation held last month by Lorenz, Ilya and Jakub [0].

The first patch is a minor fix to bpftool's Makefile, regarding the
retrieval of kernel version (which currently prints a non-relevant make
warning on some invocations).

Second patch improves the Makefile commands to support more "make"
invocations, or to fix building with custom output directory. On Jakub's
suggestion, a script is also added to BPF selftests in order to keep track
of the supported build variants.

At last, third patch is a sligthly modified version of Ilya's fix regarding
libbpf.a appearing twice on the linking command for bpftool.

[0] https://lore.kernel.org/bpf/CACAyw9-CWRHVH3TJ=Tke2x8YiLsH47sLCijdp=V+5M836R9aAA@mail.gmail.com/

Cc: Lorenz Bauer <lmb@cloudflare.com>
Cc: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Jakub Kicinski <jakub.kicinski@netronome.com>

Quentin Monnet (3):
  tools: bpftool: ignore make built-in rules for getting kernel version
  tools: bpftool: improve and check builds for different make
    invocations
  tools: bpftool: do not link twice against libbpf.a in Makefile

 tools/bpf/bpftool/Makefile                    |  18 ++-
 tools/testing/selftests/bpf/Makefile          |   3 +-
 .../selftests/bpf/test_bpftool_build.sh       | 137 ++++++++++++++++++
 3 files changed, 149 insertions(+), 9 deletions(-)
 create mode 100755 tools/testing/selftests/bpf/test_bpftool_build.sh

-- 
2.17.1

