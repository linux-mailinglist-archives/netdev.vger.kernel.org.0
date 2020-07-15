Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4731022158C
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 21:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgGOTvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 15:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726661AbgGOTvt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 15:51:49 -0400
Received: from forwardcorp1j.mail.yandex.net (forwardcorp1j.mail.yandex.net [IPv6:2a02:6b8:0:1619::183])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A28C061755;
        Wed, 15 Jul 2020 12:51:49 -0700 (PDT)
Received: from sas1-ec30c78b6c5b.qloud-c.yandex.net (sas1-ec30c78b6c5b.qloud-c.yandex.net [IPv6:2a02:6b8:c14:2704:0:640:ec30:c78b])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id 30B1F2E136F;
        Wed, 15 Jul 2020 22:51:45 +0300 (MSK)
Received: from sas2-32987e004045.qloud-c.yandex.net (sas2-32987e004045.qloud-c.yandex.net [2a02:6b8:c08:b889:0:640:3298:7e00])
        by sas1-ec30c78b6c5b.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id sD3rcpQHM6-phsKMj3E;
        Wed, 15 Jul 2020 22:51:45 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1594842705; bh=daxBHMcK5rtz7A+97AJsSnaeW/8sYa7HolZemtA0Hxc=;
        h=Message-Id:Date:Subject:To:From:Cc;
        b=yYBP7FKTyA0a1FS+8Eeo9mT8h89WdKWpxmQ0GDNfPA/d8M9EUd32aQPeiViihd+Ju
         UX/ajoULrlyTvdRYUi/wc1zp3qDF4hUQRomlXH95vBtthJfVCQ83IWG8bEgmpSCQfi
         E+tNP8ySIXAcfH9LqxTIiS+xq/ZB1kpCdvcuEGmo=
Authentication-Results: sas1-ec30c78b6c5b.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from 37.9.121.196-vpn.dhcp.yndx.net (37.9.121.196-vpn.dhcp.yndx.net [37.9.121.196])
        by sas2-32987e004045.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id kLmvqU3zdD-phiKeQal;
        Wed, 15 Jul 2020 22:51:43 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Dmitry Yakunin <zeil@yandex-team.ru>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     sdf@google.com
Subject: [PATCH bpf-next v3 0/4] bpf: cgroup skb improvements for bpf_prog_test_run
Date:   Wed, 15 Jul 2020 22:51:28 +0300
Message-Id: <20200715195132.4286-1-zeil@yandex-team.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset contains some improvements for testing cgroup/skb programs
through BPF_PROG_TEST_RUN command.

v2:
  - fix build without CONFIG_CGROUP_BPF (kernel test robot <lkp@intel.com>)

v3:
  - fix build without CONFIG_IPV6 (kernel test robot <lkp@intel.com>)

Dmitry Yakunin (4):
  bpf: setup socket family and addresses in bpf_prog_test_run_skb
  bpf: allow to specify ifindex for skb in bpf_prog_test_run_skb
  bpf: export some cgroup storages allocation helpers for reusing
  bpf: try to use existing cgroup storage in bpf_prog_test_run_skb

 include/linux/bpf-cgroup.h                         |  36 +++++++
 kernel/bpf/cgroup.c                                |  25 -----
 net/bpf/test_run.c                                 | 113 ++++++++++++++++++---
 .../selftests/bpf/prog_tests/cgroup_skb_prog_run.c |  78 ++++++++++++++
 tools/testing/selftests/bpf/prog_tests/skb_ctx.c   |   5 +
 5 files changed, 217 insertions(+), 40 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_skb_prog_run.c

-- 
2.7.4

