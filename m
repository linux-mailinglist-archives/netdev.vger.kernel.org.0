Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 232BE2A8793
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 20:51:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731558AbgKETvT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 14:51:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbgKETvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 14:51:19 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 198F7C0613CF;
        Thu,  5 Nov 2020 11:51:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=XCsDHHO5VOEHUh0n+b5M65aKyZ5mhjBsqMF0vPg4hZg=; b=j/0wl9mrrHD++pLsMprcgvrMUE
        chUkp1FLIzNk7SA1VUXr+VB/9PpdFx5swnvFbGkaXuM36WisxRNCnkp8/Aw7aQwjHkF/NPkZBXm3M
        RfPSkAIOEH4U7zVup3Y/7au5NbfteqC3edFUZOTx2ZWHNmupz82bSEfXiWmy0pDjrzGxq11SRHSaG
        KVnI97slTf1ERfVX/jv6CRI7YTu/PDGNcswDTJYxu3khkTgdWl+WnLfqspFhuphy0iZmHexYkhjgk
        IgL04lEj4yoH5UhNj2LT7AKSO8BZTR/976tdd1cFXj4DuPfjfJgYYZviPRAnGa21hl7kzWRrnI7vf
        pa3cGzyA==;
Received: from [2601:1c0:6280:3f0::60d5] (helo=smtpauth.infradead.org)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kalHu-0002xZ-6M; Thu, 05 Nov 2020 19:51:14 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        kernel test robot <lkp@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH] bpf: BPF_PRELOAD depends on BPF_SYSCALL
Date:   Thu,  5 Nov 2020 11:51:09 -0800
Message-Id: <20201105195109.26232-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix build error when BPF_SYSCALL is not set/enabled but BPF_PRELOAD is
by making BPF_PRELOAD depend on BPF_SYSCALL.

ERROR: modpost: "bpf_preload_ops" [kernel/bpf/preload/bpf_preload.ko] undefined!

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: netdev@vger.kernel.org
Cc: bpf@vger.kernel.org
---
 kernel/bpf/preload/Kconfig |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20201105.orig/kernel/bpf/preload/Kconfig
+++ linux-next-20201105/kernel/bpf/preload/Kconfig
@@ -6,6 +6,7 @@ config USERMODE_DRIVER
 menuconfig BPF_PRELOAD
 	bool "Preload BPF file system with kernel specific program and map iterators"
 	depends on BPF
+	depends on BPF_SYSCALL
 	# The dependency on !COMPILE_TEST prevents it from being enabled
 	# in allmodconfig or allyesconfig configurations
 	depends on !COMPILE_TEST
