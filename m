Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAAFA43D88F
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 03:29:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229784AbhJ1BcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 21:32:11 -0400
Received: from mga06.intel.com ([134.134.136.31]:34992 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229505AbhJ1BcK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 21:32:10 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10150"; a="291138656"
X-IronPort-AV: E=Sophos;i="5.87,188,1631602800"; 
   d="scan'208";a="291138656"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2021 18:29:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,188,1631602800"; 
   d="scan'208";a="447466689"
Received: from gupta-dev2.jf.intel.com (HELO gupta-dev2.localdomain) ([10.54.74.119])
  by orsmga006.jf.intel.com with ESMTP; 27 Oct 2021 18:29:43 -0700
Date:   Wed, 27 Oct 2021 18:32:00 -0700
From:   Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        antonio.gomez.iglesias@intel.com, tony.luck@intel.com,
        dave.hansen@linux.intel.com
Subject: [PATCH ebpf v2 0/2] Unprivileged BPF default
Message-ID: <cover.1635383031.git.pawan.kumar.gupta@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This is a two patch series to make the compile time default of
unprivileged BPF depend on CONFIG_CPU_SPECTRE. First patch makes ARM's
CONFIG_CPU_SPECTRE available for all architectures. The second patch
sets CONFIG_BPF_UNPRIV_DEFAULT_OFF=y by default when
CONFIG_CPU_SPECTRE=y.

v2:
- Generalize ARM's CONFIG_CPU_SPECTRE to be available for all architectures.
- Make CONFIG_BPF_UNPRIV_DEFAULT_OFF depend on CONFIG_CPU_SPECTRE.
- Updated commit message to reflect the dependency on CONFIG_CPU_SPECTRE.
- Add reference to BPF spectre presentation in commit message.

v1: https://lore.kernel.org/all/d37b01e70e65dced2659561ed5bc4b2ed1a50711.1635367330.git.pawan.kumar.gupta@linux.intel.com/

Pawan Gupta (2):
  arch/Kconfig: Make CONFIG_CPU_SPECTRE available for all architectures
  bpf: Make unprivileged bpf depend on CONFIG_CPU_SPECTRE

 arch/Kconfig        | 3 +++
 arch/arm/mm/Kconfig | 3 ---
 arch/x86/Kconfig    | 1 +
 kernel/bpf/Kconfig  | 5 +++++
 4 files changed, 9 insertions(+), 3 deletions(-)

-- 
2.31.1

