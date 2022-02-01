Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E52134A6698
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 21:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233207AbiBAU4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 15:56:52 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58270 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236893AbiBAU4w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 15:56:52 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8DC086170B;
        Tue,  1 Feb 2022 20:56:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F67FC340EB;
        Tue,  1 Feb 2022 20:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643749011;
        bh=YNLaFGpLiYW1mW5iigIdq1hinXTGB9hBww4Mtt3ZsLI=;
        h=From:To:Cc:Subject:Date:From;
        b=mzFEXTHE68CCzVTIyf9bOLQRdGLMgzDH6ikuwLs8IZdl453QF50KFPaB6E5LwtUCw
         V05i3JC0ATUAp70WYnUpt6K2t9ULV3JPpSYvfdL4Rv0U0wuBH9SAh8R1eQi5IevQH/
         0FUU/v2QCnrwp/rglruujQN94bHD5YgLrNUwhLYeVJPrgGPhAKSzvsgKOL2CeiGjb+
         y1zsJw7urffKklQ3MZhOk0/5MhsXuvqMKsC/+jOmSV0YVW/ZlDmnhjJvEyKFyojBHS
         TEQTHwxMEtY+BYzvcmxkNs2Bk/KOivuZtLDzY6pBzqVJeGfGKAM63uUxiRED3ELYXe
         DGBcsx8ZPAYdQ==
From:   Nathan Chancellor <nathan@kernel.org>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Martin KaFai Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev,
        Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH bpf-next 0/5] Allow CONFIG_DEBUG_INFO_DWARF5=y + CONFIG_DEBUG_INFO_BTF=y
Date:   Tue,  1 Feb 2022 13:56:19 -0700
Message-Id: <20220201205624.652313-1-nathan@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

This series allows CONFIG_DEBUG_INFO_DWARF5 to be selected with
CONFIG_DEBUG_INFO_BTF=y by checking the pahole version.

The first four patches add CONFIG_PAHOLE_VERSION and
scripts/pahole-version.sh to clean up all the places that pahole's
version is transformed into a 3-digit form.

The fourth patch adds a PAHOLE_VERSION dependency to DEBUG_INFO_DWARF5
so that there are no build errors when it is selected with
DEBUG_INFO_BTF.

I build tested Fedora's aarch64 and x86_64 config with ToT clang 14.0.0
and GCC 11 with CONFIG_DEBUG_INFO_DWARF5 enabled with both pahole 1.21
and 1.23.

Nathan Chancellor (5):
  MAINTAINERS: Add scripts/pahole-flags.sh to BPF section
  kbuild: Add CONFIG_PAHOLE_VERSION
  scripts/pahole-flags.sh: Use pahole-version.sh
  lib/Kconfig.debug: Use CONFIG_PAHOLE_VERSION
  lib/Kconfig.debug: Allow BTF + DWARF5 with pahole 1.21+

 MAINTAINERS               |  2 ++
 init/Kconfig              |  4 ++++
 lib/Kconfig.debug         |  6 +++---
 scripts/pahole-flags.sh   |  2 +-
 scripts/pahole-version.sh | 13 +++++++++++++
 5 files changed, 23 insertions(+), 4 deletions(-)
 create mode 100755 scripts/pahole-version.sh


base-commit: 533de4aea6a91eb670ff8ff2b082bb34f2c5d6ab
-- 
2.35.1

