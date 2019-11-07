Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9873AF2DFF
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 13:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388178AbfKGMO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 07:14:57 -0500
Received: from relay.sw.ru ([185.231.240.75]:59014 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726810AbfKGMO5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 07:14:57 -0500
Received: from [172.16.24.104] (helo=localhost.localdomain)
        by relay.sw.ru with esmtp (Exim 4.92.3)
        (envelope-from <ktkhai@virtuozzo.com>)
        id 1iSggF-0004uq-4a; Thu, 07 Nov 2019 15:14:27 +0300
Subject: [PATCH 0/2] unix: Show number of scm files in fdinfo
From:   Kirill Tkhai <ktkhai@virtuozzo.com>
To:     davem@davemloft.net, pankaj.laxminarayan.bharadiya@intel.com,
        keescook@chromium.org, viro@zeniv.linux.org.uk, hare@suse.com,
        tglx@linutronix.de, ktkhai@virtuozzo.com, edumazet@google.com,
        arnd@arndb.de, axboe@kernel.dk, netdev@vger.kernel.org
Date:   Thu, 07 Nov 2019 15:14:15 +0300
Message-ID: <157312863230.4594.18421480718399996953.stgit@localhost.localdomain>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Unix sockets like a block box. You never know what is pending there:
there may be a file descriptor holding a mount or a block device,
or there may be whole universes with namespaces, sockets with receive
queues full of sockets etc.

The patchset makes number of pending scm files be visible in fdinfo.
This may be useful to determine, that socket should be investigated
or which task should be killed to put reference counter on a resourse.

---

Kirill Tkhai (2):
      net: Allow to show socket-specific information in /proc/[pid]/fdinfo/[fd]
      unix: Show number of pending scm files of receive queue in fdinfo


 include/linux/net.h   |    1 +
 include/net/af_unix.h |    5 ++++
 net/socket.c          |   12 +++++++++++
 net/unix/af_unix.c    |   56 +++++++++++++++++++++++++++++++++++++++++++++----
 4 files changed, 69 insertions(+), 5 deletions(-)

--
Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>

