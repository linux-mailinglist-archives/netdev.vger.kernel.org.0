Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8892246E4C8
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 10:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235480AbhLIJGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 04:06:32 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:39470 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231602AbhLIJGc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Dec 2021 04:06:32 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0V-2Ao2S_1639040577;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V-2Ao2S_1639040577)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 09 Dec 2021 17:02:57 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH bpf-next 0/2] Introduce TCP_ULP option for bpf_{set,get}sockopt
Date:   Thu,  9 Dec 2021 17:02:49 +0800
Message-Id: <20211209090250.73927-1-tonylu@linux.alibaba.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set introduces a new option TCP_ULP for bpf_{set,get}sockopt
helper. The bpf prog can set and get TCP_ULP sock option on demand.

With this, the bpf prog can set TCP_ULP based on strategies when socket
create or other's socket hook point. For example, the bpf prog can
control which socket should use tls or smc (WIP) ULP modules without
modifying the applications.

Patch 1 replaces if statement with switch to make it easy to extend.

Patch 2 introduces TCP_ULP sock option.

Tony Lu (2):
  bpf: Use switch statement in _bpf_setsockopt
  bpf: Introduce TCP_ULP option for bpf_{set,get}sockopt

 include/uapi/linux/bpf.h       |   3 +-
 net/core/filter.c              | 180 ++++++++++++++++++---------------
 tools/include/uapi/linux/bpf.h |   3 +-
 3 files changed, 104 insertions(+), 82 deletions(-)

-- 
2.32.0.3.g01195cf9f

