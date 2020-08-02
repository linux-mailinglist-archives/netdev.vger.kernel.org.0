Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F6F5239C26
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 23:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727884AbgHBVax (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 17:30:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726058AbgHBVax (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 17:30:53 -0400
X-Greylist: delayed 11041 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 02 Aug 2020 14:30:52 PDT
Received: from forwardcorp1o.mail.yandex.net (forwardcorp1o.mail.yandex.net [IPv6:2a02:6b8:0:1a2d::193])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B4DC06174A;
        Sun,  2 Aug 2020 14:30:52 -0700 (PDT)
Received: from vla1-fdfb804fb3f3.qloud-c.yandex.net (vla1-fdfb804fb3f3.qloud-c.yandex.net [IPv6:2a02:6b8:c0d:3199:0:640:fdfb:804f])
        by forwardcorp1o.mail.yandex.net (Yandex) with ESMTP id 88AAC2E1152;
        Mon,  3 Aug 2020 00:30:50 +0300 (MSK)
Received: from vla5-58875c36c028.qloud-c.yandex.net (vla5-58875c36c028.qloud-c.yandex.net [2a02:6b8:c18:340b:0:640:5887:5c36])
        by vla1-fdfb804fb3f3.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id 6xhlazmgPp-UnqCw5id;
        Mon, 03 Aug 2020 00:30:50 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1596403850; bh=ObsxtpBpLiYuccIbdhQ1rnyp2HZ4ag8aOz1RnWYbONQ=;
        h=Message-Id:Date:Subject:To:From:Cc;
        b=V1qqbFA8ZFnPlE3cDKzGbMSSD6GtcieUESmhF2MZ2xmAkOD3xnpr1de7vCa3M87M0
         WNOVievKugvKB9B6Ze4rDcJtpsTOwUwhrD9bRHNYInrOXB1DJaqHmHmewR+V68lgyX
         LVS6EJ5gX5hHd+YiZJo1KpwrrcCmj9pF+5Ve9uBI=
Authentication-Results: vla1-fdfb804fb3f3.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from unknown (unknown [178.154.141.161])
        by vla5-58875c36c028.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id CwYyvqXlFC-UljmVPAw;
        Mon, 03 Aug 2020 00:30:48 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Dmitry Yakunin <zeil@yandex-team.ru>
To:     alexei.starovoitov@gmail.com, daniel@iogearbox.net,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     sdf@google.com
Subject: [PATCH bpf-next v4 0/2] bpf: cgroup skb improvements for bpf_prog_test_run
Date:   Mon,  3 Aug 2020 00:30:24 +0300
Message-Id: <20200802213026.78731-1-zeil@yandex-team.ru>
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

Dmitry Yakunin (2):
  bpf: setup socket family and addresses in bpf_prog_test_run_skb
  bpf: allow to specify ifindex for skb in bpf_prog_test_run_skb

 net/bpf/test_run.c                               | 39 ++++++++++++++++++++++--
 tools/testing/selftests/bpf/prog_tests/skb_ctx.c |  5 +++
 2 files changed, 42 insertions(+), 2 deletions(-)

-- 
2.7.4

