Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15F0727C231
	for <lists+netdev@lfdr.de>; Tue, 29 Sep 2020 12:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbgI2KRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Sep 2020 06:17:42 -0400
Received: from mx2.suse.de ([195.135.220.15]:60428 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725536AbgI2KRj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Sep 2020 06:17:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2747BAD12;
        Tue, 29 Sep 2020 10:17:38 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id DF10860787; Tue, 29 Sep 2020 12:17:37 +0200 (CEST)
Date:   Tue, 29 Sep 2020 12:17:37 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yonghong Song <yhs@fb.com>
Subject: build failure (BTFIDS) with CONFIG_NET && !CONFIG_INET
Message-ID: <20200929101737.3ufw36bngkmzppqk@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

our builds of s390x for zfcpdump fail since 5.9-rc1 with

    BTFIDS  vmlinux
  FAILED unresolved symbol tcp_timewait_sock
  make[1]: *** [/home/abuild/rpmbuild/BUILD/kernel-zfcpdump-5.9.rc7/linux-5.9-rc7/Makefile:1176: vmlinux] Error 255

I believe this is caused by commit fce557bcef11 ("bpf: Make btf_sock_ids
global") and the problem is caused by a specific configuration which has
CONFIG_NET enabled but CONFIG_INET disabled. IIUC there will be no user
of struct tcp_timewait_sock but btf_ids will try to generate BTF info
for it.

Michal
