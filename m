Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 41BDB2C8A2
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 16:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727729AbfE1OY7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 10:24:59 -0400
Received: from xavier.telenet-ops.be ([195.130.132.52]:37098 "EHLO
        xavier.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727619AbfE1OYo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 10:24:44 -0400
Received: from ramsan ([84.194.111.163])
        by xavier.telenet-ops.be with bizsmtp
        id HqQS2000K3XaVaC01qQSyc; Tue, 28 May 2019 16:24:42 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1hVd1e-00058F-2p; Tue, 28 May 2019 16:24:26 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1hVd1e-00057M-0A; Tue, 28 May 2019 16:24:26 +0200
From:   Geert Uytterhoeven <geert@linux-m68k.org>
To:     Igor Konopko <igor.j.konopko@intel.com>,
        David Howells <dhowells@redhat.com>,
        "Mohit P . Tahiliani" <tahiliani@nitk.edu.in>,
        Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Eran Ben Elisha <eranbe@mellanox.com>,
        Matias Bjorling <mb@lightnvm.io>,
        Jiri Pirko <jiri@mellanox.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Clemens Ladisch <clemens@ladisch.de>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, Joe Perches <joe@perches.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Dan Carpenter <dan.carpenter@oracle.com>
Cc:     linux-block@vger.kernel.org, netdev@vger.kernel.org,
        linux-afs@lists.infradead.org, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 0/5] Assorted fixes discovered with gcc 4.1
Date:   Tue, 28 May 2019 16:24:19 +0200
Message-Id: <20190528142424.19626-1-geert@linux-m68k.org>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

	Hi all,

Ever since commit cafa0010cd51fb71 ("Raise the minimum required gcc
version to 4.6"), I felt bored when looking at my test build logs, as I
was no longer discovering many real issues.  Hence I started wondering
if the modern gcc versions are really catching these classes of bugs
caught before with gcc 4.1, or if they just go undetected.

I reverted some changes and applied some fixes, which allowed me to
compile most of the kernel with gcc 4.1 again.  I built an
m68k/allmodconfig kernel, looked at all new warnings, and fixed the ones
that are not false positives.  The result is a patch series of 5
patches, of which one or two fix real bugs.

Thanks for your comments, and for applying where appropriate!

Geert Uytterhoeven (5):
  lightnvm: Fix uninitialized pointer in nvm_remove_tgt()
  rxrpc: Fix uninitialized error code in rxrpc_send_data_packet()
  net: sched: pie: Use ULL suffix for 64-bit constant
  ALSA: fireface: Use ULL suffixes for 64-bit constants
  [RFC] devlink: Fix uninitialized error code in
    devlink_fmsg_prepare_skb()

 drivers/lightnvm/core.c                      |  2 +-
 net/core/devlink.c                           |  2 +-
 net/rxrpc/output.c                           |  4 +++-
 net/sched/sch_pie.c                          |  2 +-
 sound/firewire/fireface/ff-protocol-latter.c | 10 +++++-----
 5 files changed, 11 insertions(+), 9 deletions(-)

-- 
2.17.1

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
