Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA0BA8613B
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 13:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731555AbfHHL5o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 07:57:44 -0400
Received: from www62.your-server.de ([213.133.104.62]:33374 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728289AbfHHL5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 07:57:43 -0400
Received: from [2a02:120b:2c12:c120:71a0:62dd:894c:fd0e] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hvh2z-0001kI-SY; Thu, 08 Aug 2019 13:57:34 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, m@lambda.lt,
        edumazet@google.com, ast@kernel.org, willemb@google.com,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH net v2 0/2] Fix collisions in socket cookie generation
Date:   Thu,  8 Aug 2019 13:57:24 +0200
Message-Id: <20190808115726.31703-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25535/Thu Aug  8 10:18:42 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change makes the socket cookie generator as a global counter
instead of per netns in order to fix cookie collisions for BPF use
cases we ran into. See main patch #1 for more details.

Given the change is small/trivial and fixes an issue we're seeing
my preference would be net tree (though it cleanly applies to
net-next as well). Went for net tree instead of bpf tree here given
the main change is in net/core/sock_diag.c, but either way would be
fine with me.

Thanks a lot!

v1 -> v2:
  - Fix up commit description in patch #1, thanks Eric!

Daniel Borkmann (2):
  sock: make cookie generation global instead of per netns
  bpf: sync bpf.h to tools infrastructure

 include/net/net_namespace.h    |  1 -
 include/uapi/linux/bpf.h       |  4 ++--
 net/core/sock_diag.c           |  3 ++-
 tools/include/uapi/linux/bpf.h | 11 +++++++----
 4 files changed, 11 insertions(+), 8 deletions(-)

-- 
2.17.1

