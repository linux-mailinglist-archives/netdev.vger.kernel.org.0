Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F76C21DF95
	for <lists+netdev@lfdr.de>; Mon, 13 Jul 2020 20:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726382AbgGMSZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 14:25:33 -0400
Received: from forwardcorp1j.mail.yandex.net ([5.45.199.163]:40932 "EHLO
        forwardcorp1j.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726309AbgGMSZd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 14:25:33 -0400
Received: from iva8-d077482f1536.qloud-c.yandex.net (iva8-d077482f1536.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:2f26:0:640:d077:482f])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id 9EAED2E0984;
        Mon, 13 Jul 2020 21:25:31 +0300 (MSK)
Received: from iva8-88b7aa9dc799.qloud-c.yandex.net (iva8-88b7aa9dc799.qloud-c.yandex.net [2a02:6b8:c0c:77a0:0:640:88b7:aa9d])
        by iva8-d077482f1536.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id fr2UuDZV57-PUs0jRjP;
        Mon, 13 Jul 2020 21:25:31 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1594664731; bh=v7lg0o87U8C7fJJeFSu+XJfpDqpasHnjUT4svRHz0uw=;
        h=Message-Id:Date:Subject:To:From:Cc;
        b=hyLnuVUWie1vdCUw2Gn/amVW2JEBoxXJ70NtBGv6scIC8Zc/YDyfjDMIeP0Wm/yK7
         4EGwcy0UIxtzNbq97pTj9oMipcIup0pBRC4HTQ0QKIRiFo2VBXp8vVAZDkkH99/XMH
         WIsm8sixiFI4HQHWYQ4fsop3V9hHDVsxMgK1zMQo=
Authentication-Results: iva8-d077482f1536.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from 37.9.72.97-iva.dhcp.yndx.net (37.9.72.97-iva.dhcp.yndx.net [37.9.72.97])
        by iva8-88b7aa9dc799.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id liA4tjrt5e-PUjqjisx;
        Mon, 13 Jul 2020 21:25:30 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Dmitry Yakunin <zeil@yandex-team.ru>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     sdf@google.com
Subject: [PATCH bpf-next 0/4] bpf: cgroup skb improvements for bpf_prog_test_run
Date:   Mon, 13 Jul 2020 21:25:16 +0300
Message-Id: <20200713182520.97606-1-zeil@yandex-team.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset contains some improvements for testing cgroup/skb programs
through BPF_PROG_TEST_RUN command.

Dmitry Yakunin (4):
  bpf: setup socket family and addresses in bpf_prog_test_run_skb
  bpf: allow to specify ifindex for skb in bpf_prog_test_run_skb
  bpf: export some cgroup storages allocation helpers for reusing
  bpf: try to use existing cgroup storage in bpf_prog_test_run_skb

 include/linux/bpf-cgroup.h                         |  27 ++++++
 kernel/bpf/cgroup.c                                |  25 -----
 net/bpf/test_run.c                                 | 102 ++++++++++++++++++---
 .../selftests/bpf/prog_tests/cgroup_skb_prog_run.c |  78 ++++++++++++++++
 tools/testing/selftests/bpf/prog_tests/skb_ctx.c   |   5 +
 5 files changed, 197 insertions(+), 40 deletions(-)
 create mode 100644 tools/testing/selftests/bpf/prog_tests/cgroup_skb_prog_run.c

-- 
2.7.4

