Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7999162F38
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 20:02:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbgBRTCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 14:02:34 -0500
Received: from mx2.suse.de ([195.135.220.15]:35556 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726283AbgBRTCd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Feb 2020 14:02:33 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 17ADEADAB;
        Tue, 18 Feb 2020 19:02:31 +0000 (UTC)
From:   Michal Rostecki <mrostecki@opensuse.org>
To:     bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH bpf-next 0/6] bpftool: Allow to select sections and filter probes
Date:   Tue, 18 Feb 2020 20:02:17 +0100
Message-Id: <20200218190224.22508-1-mrostecki@opensuse.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch series extend the "bpftool feature" subcommand with the
new positional arguments:

- "section", which allows to select a specific section of probes (i.e.
  "system_config", "program_types", "map_types");
- "filter_in", which allows to select only probes which matches the
  given regex pattern;
- "filter_out", which allows to filter out probes which do not match the
  given regex pattern.

The main motivation behind those changes is ability the fact that some
probes (for example those related to "trace" or "write_user" helpers)
emit dmesg messages which might be confusing for people who are running
on production environments. For details see the Cilium issue[0].

[0] https://github.com/cilium/cilium/issues/10048

Michal Rostecki (6):
  bpftool: Move out sections to separate functions
  bpftool: Allow to select a specific section to probe
  bpftool: Add arguments for filtering in and filtering out probes
  bpftool: Update documentation of "bpftool feature" command
  bpftool: Update bash completion for "bpftool feature" command
  selftests/bpf: Add test for "bpftool feature" command

 .../bpftool/Documentation/bpftool-feature.rst |  37 +-
 tools/bpf/bpftool/bash-completion/bpftool     |  32 +-
 tools/bpf/bpftool/feature.c                   | 592 +++++++++++++-----
 tools/testing/selftests/.gitignore            |   5 +-
 tools/testing/selftests/bpf/Makefile          |   3 +-
 tools/testing/selftests/bpf/test_bpftool.py   | 294 +++++++++
 tools/testing/selftests/bpf/test_bpftool.sh   |   5 +
 7 files changed, 811 insertions(+), 157 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/test_bpftool.py
 create mode 100755 tools/testing/selftests/bpf/test_bpftool.sh

-- 
2.25.0

