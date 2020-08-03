Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FAFD23A186
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 11:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726489AbgHCJGE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 05:06:04 -0400
Received: from forwardcorp1p.mail.yandex.net ([77.88.29.217]:38260 "EHLO
        forwardcorp1p.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725926AbgHCJGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 05:06:03 -0400
Received: from iva8-d077482f1536.qloud-c.yandex.net (iva8-d077482f1536.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:2f26:0:640:d077:482f])
        by forwardcorp1p.mail.yandex.net (Yandex) with ESMTP id 0E51E2E1505;
        Mon,  3 Aug 2020 12:06:01 +0300 (MSK)
Received: from iva8-88b7aa9dc799.qloud-c.yandex.net (iva8-88b7aa9dc799.qloud-c.yandex.net [2a02:6b8:c0c:77a0:0:640:88b7:aa9d])
        by iva8-d077482f1536.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id Zqlc6rgheF-5vt8g8MR;
        Mon, 03 Aug 2020 12:06:00 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1596445560; bh=pjlr5W8lS7atF8l+KwH9T4nrH6vaQVIehueEc9AvO8c=;
        h=Message-Id:Date:Subject:To:From:Cc;
        b=m5SPzPf8BNrBYaDxLP1EDPUns21prv5x9Tq1ZwruZmC6au9QsqSoUsRimy2WelFiN
         DzzR50DEYDh/pOnJhrGDEYxaXUIJsf2ulis2x0UJekdEZpHmOPjnGvGp5g4OVo3c+i
         eOuYJeg2bLDytSuCDxDRrjouJMeoepFs/dOrCwjE=
Authentication-Results: iva8-d077482f1536.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from 178.154.163.76-vpn.dhcp.yndx.net (178.154.163.76-vpn.dhcp.yndx.net [178.154.163.76])
        by iva8-88b7aa9dc799.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id 1ZDFznne1R-5viCXtLm;
        Mon, 03 Aug 2020 12:05:57 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Dmitry Yakunin <zeil@yandex-team.ru>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     eric.dumazet@gmail.com, sdf@google.com
Subject: [PATCH bpf-next v6 0/2] bpf: cgroup skb improvements for bpf_prog_test_run
Date:   Mon,  3 Aug 2020 12:05:43 +0300
Message-Id: <20200803090545.82046-1-zeil@yandex-team.ru>
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

v4:
  - remove cgroup storage related commits for future rework (Daniel Borkmann)

v5:
  - check skb length before access to inet headers (Eric Dumazet)

v6:
  - do not use pskb_may_pull() in skb length checking (Alexei Starovoitov)

Dmitry Yakunin (2):
  bpf: setup socket family and addresses in bpf_prog_test_run_skb
  bpf: allow to specify ifindex for skb in bpf_prog_test_run_skb

 net/bpf/test_run.c                               | 39 ++++++++++++++++++++++--
 tools/testing/selftests/bpf/prog_tests/skb_ctx.c |  5 +++
 2 files changed, 42 insertions(+), 2 deletions(-)

-- 
2.7.4

