Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A7C94B7ADE
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 23:59:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244724AbiBOW7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 17:59:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241127AbiBOW7f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 17:59:35 -0500
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B036EE869D
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 14:59:22 -0800 (PST)
Received: by mail-qv1-xf31.google.com with SMTP id a28so541079qvb.10
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 14:59:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r4BHXymhnvl997ulfsVmgLjkglNJ0u4kfuYSFJ4ruYY=;
        b=PKhOaO4Cch/tvG8OIDRTAonhQakY83bAEHVHzCFxDnW8ddfDRI6qCZqqrINAOpGsto
         HFkSk3m8R1kYrTCg+9MUgPjhrs0V9ckQPrqxBHo8dC9JeghDwXaxQgbYmrcxLYz6V3rv
         yzTowvCa08FpvhlieOU+Qq1Dk/qzU7niH5ALw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=r4BHXymhnvl997ulfsVmgLjkglNJ0u4kfuYSFJ4ruYY=;
        b=OcHwE09RsgXLDK5iuu+aQLfmTiKwM4DzYOri4NFBO93xsjgvaUKe1/TDFAIYYVGzPL
         1ECCJX8v8UoyodnhTmqMuCIFxTeTdOJdZnQXZE/BzF1aBvHscP27XyIAqMNoaoadtJID
         QtDj1Df9jroiJ/2TdX/EdHq+z2oc2c0r7ThHkPkBZQtd2afE+4rtXWOSBcRdCDLAu8Dg
         ptgGdWuwW3xXXAKo25Z1dCBrgbybIPLWsjqs5Ha3BMovhbHtCiEJGAuvBDIoJ0u9k/rO
         R59TTJ/yPTkmxXEaW5IU3qdhqRWl1yM+y5lVDoDeJ0ETqGZ45PDDsYYNyPf8dtHncEua
         XDsw==
X-Gm-Message-State: AOAM533h7MfzDorBJH9roNDIXBqJglg59cRT0OgAnScYfXoMF04gKefs
        ZYirRZGOCVxuMN11gZFrlWkCgRMwgzCogK/GOuvLhR32FstuanZSqTcmGW95rnijiCrqhpJXxft
        EtMTB+Kj6q+OI7E/7MwdclI6V6xAEnY04xUG3H+vlrFdXxLpdU1A9Wz1zDSfPGoci6h1/5A==
X-Google-Smtp-Source: ABdhPJyOwP2RYGT/sBkEVyiMgsBkhszMjjUQ6leZJ4jnmmA/6BtISErQgVTz+3g0U6WK9R6qIC3qag==
X-Received: by 2002:a05:6214:2504:b0:42d:7b1a:8dd1 with SMTP id gf4-20020a056214250400b0042d7b1a8dd1mr213392qvb.8.1644965959324;
        Tue, 15 Feb 2022 14:59:19 -0800 (PST)
Received: from localhost.localdomain ([181.136.110.101])
        by smtp.gmail.com with ESMTPSA id w19sm15520021qkp.6.2022.02.15.14.59.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Feb 2022 14:59:18 -0800 (PST)
From:   =?UTF-8?q?Mauricio=20V=C3=A1squez?= <mauricio@kinvolk.io>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Subject: [PATCH bpf-next v7 0/7] libbpf: Implement BTFGen
Date:   Tue, 15 Feb 2022 17:58:49 -0500
Message-Id: <20220215225856.671072-1-mauricio@kinvolk.io>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CO-RE requires to have BTF information describing the kernel types in
order to perform the relocations. This is usually provided by the kernel
itself when it's configured with CONFIG_DEBUG_INFO_BTF. However, this
configuration is not enabled in all the distributions and it's not
available on kernels before 5.12.

It's possible to use CO-RE in kernels without CONFIG_DEBUG_INFO_BTF
support by providing the BTF information from an external source.
BTFHub[0] contains BTF files to each released kernel not supporting BTF,
for the most popular distributions.

Providing this BTF file for a given kernel has some challenges:
1. Each BTF file is a few MBs big, then it's not possible to ship the
eBPF program with all the BTF files needed to run in different kernels.
(The BTF files will be in the order of GBs if you want to support a high
number of kernels)
2. Downloading the BTF file for the current kernel at runtime delays the
start of the program and it's not always possible to reach an external
host to download such a file.

Providing the BTF file with the information about all the data types of
the kernel for running an eBPF program is an overkill in many of the
cases. Usually the eBPF programs access only some kernel fields.

This series implements BTFGen support in bpftool. This idea was
discussed during the "Towards truly portable eBPF"[1] presentation at
Linux Plumbers 2021.

There is a good example[2] on how to use BTFGen and BTFHub together
to generate multiple BTF files, to each existing/supported kernel,
tailored to one application. For example: a complex bpf object might
support nearly 400 kernels by having BTF files summing only 1.5 MB.

[0]: https://github.com/aquasecurity/btfhub/
[1]: https://www.youtube.com/watch?v=igJLKyP1lFk&t=2418s
[2]: https://github.com/aquasecurity/btfhub/tree/main/tools

Changelog:
v6 > v7:
- use array instead of hashmap to store ids
- use btf__add_{struct,union}() instead of memcpy()
- don't use fixed path for testing BTF file
- update example to use DECLARE_LIBBPF_OPTS()

v5 > v6:
- use BTF structure to store used member/types instead of hashmaps
- remove support for input/output folders
- remove bpf_core_{created,free}_cand_cache()
- reorganize commits to avoid having unused static functions
- remove usage of libbpf_get_error()
- fix some errno propagation issues
- do not record full types for type-based relocations
- add support for BTF_KIND_FUNC_PROTO
- implement tests based on core_reloc ones

v4 > v5:
- move some checks before invoking prog->obj->gen_loader
- use p_info() instead of printf()
- improve command output
- fix issue with record_relo_core()
- implement bash completion
- write man page
- implement some tests

v3 > v4:
- parse BTF and BTF.ext sections in bpftool and use
  bpf_core_calc_relo_insn() directly
- expose less internal details from libbpf to bpftool
- implement support for enum-based relocations
- split commits in a more granular way

v2 > v3:
- expose internal libbpf APIs to bpftool instead
- implement btfgen in bpftool
- drop btf__raw_data() from libbpf

v1 > v2:
- introduce bpf_object__prepare() and ‘record_core_relos’ to expose
  CO-RE relocations instead of bpf_object__reloc_info_gen()
- rename btf__save_to_file() to btf__raw_data()

v1: https://lore.kernel.org/bpf/20211027203727.208847-1-mauricio@kinvolk.io/
v2: https://lore.kernel.org/bpf/20211116164208.164245-1-mauricio@kinvolk.io/
v3: https://lore.kernel.org/bpf/20211217185654.311609-1-mauricio@kinvolk.io/
v4: https://lore.kernel.org/bpf/20220112142709.102423-1-mauricio@kinvolk.io/
v5: https://lore.kernel.org/bpf/20220128223312.1253169-1-mauricio@kinvolk.io/
v6: https://lore.kernel.org/bpf/20220209222646.348365-1-mauricio@kinvolk.io/

Mauricio Vásquez (6):
  libbpf: split bpf_core_apply_relo()
  libbpf: Expose bpf_core_{add,free}_cands() to bpftool
  bpftool: Add gen min_core_btf command
  bpftool: Implement "gen min_core_btf" logic
  bpftool: Implement btfgen_get_btf()
  selftests/bpf: Test "bpftool gen min_core_btf"

Rafael David Tinoco (1):
  bpftool: gen min_core_btf explanation and examples

 kernel/bpf/btf.c                              |  13 +-
 .../bpf/bpftool/Documentation/bpftool-gen.rst |  91 +++
 tools/bpf/bpftool/Makefile                    |   8 +-
 tools/bpf/bpftool/bash-completion/bpftool     |   6 +-
 tools/bpf/bpftool/gen.c                       | 591 +++++++++++++++++-
 tools/lib/bpf/libbpf.c                        |  88 +--
 tools/lib/bpf/libbpf_internal.h               |   9 +
 tools/lib/bpf/relo_core.c                     |  79 +--
 tools/lib/bpf/relo_core.h                     |  42 +-
 .../selftests/bpf/prog_tests/core_reloc.c     |  50 +-
 10 files changed, 864 insertions(+), 113 deletions(-)

-- 
2.25.1

