Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3534069B3D0
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 21:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229779AbjBQUYU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 15:24:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbjBQUYQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 15:24:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C602DE68
        for <netdev@vger.kernel.org>; Fri, 17 Feb 2023 12:23:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676665403;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=K5ZI+v0i1F3Jsex79dfpMaH/+vxYNgDnwx9OoQIYq98=;
        b=ZLOBb6EG6EYeEC3RZqQ9umXIzXLcT/TZ7oZy50wE+J59T/FPgo6GQJPasCWX4dF2xYNiZ4
        J1Oz9fyaEgDtn2Km+FzfnSUzmqGTV3ktFEC9llXqnDLYhMagIqrjhdnEmObOTlqLKDymwQ
        kQG7kkh8kDBWvawFI7FYMXhmqhNFh/U=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-207-n1rRrwfrOIicTKJRtp8qxw-1; Fri, 17 Feb 2023 15:23:17 -0500
X-MC-Unique: n1rRrwfrOIicTKJRtp8qxw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 062C11C0515F;
        Fri, 17 Feb 2023 20:23:17 +0000 (UTC)
Received: from thuth.com (unknown [10.39.192.11])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 352D7C15BA0;
        Fri, 17 Feb 2023 20:23:15 +0000 (UTC)
From:   Thomas Huth <thuth@redhat.com>
To:     linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Cc:     linux-arch@vger.kernel.org, Chas Williams <3chas3@gmail.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH 0/4] Remove #ifdef CONFIG_* from uapi headers (2023 edition)
Date:   Fri, 17 Feb 2023 21:22:57 +0100
Message-Id: <20230217202301.436895-1-thuth@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

uapi headers should not use the kernel-internal CONFIG switches.
Palmer Dabbelt sent some patches to clean this up a couple of years
ago, but unfortunately some of those patches never got merged.
So here's a rebased version of those patches - since they are rather
trivial, I hope it's OK for everybody if they could go through Arnd's
"generic include/asm header files" branch?

Palmer Dabbelt (4):
  Move COMPAT_ATM_ADDPARTY to net/atm/svc.c
  Move ep_take_care_of_epollwakeup() to fs/eventpoll.c
  Move bp_type_idx to include/linux/hw_breakpoint.h
  Move USE_WCACHING to drivers/block/pktcdvd.c

 drivers/block/pktcdvd.c                  | 11 +++++++++++
 fs/eventpoll.c                           | 13 +++++++++++++
 include/linux/hw_breakpoint.h            | 10 ++++++++++
 include/uapi/linux/atmdev.h              |  4 ----
 include/uapi/linux/eventpoll.h           | 12 ------------
 include/uapi/linux/hw_breakpoint.h       | 10 ----------
 include/uapi/linux/pktcdvd.h             | 11 -----------
 net/atm/svc.c                            |  5 +++++
 tools/include/uapi/linux/hw_breakpoint.h | 10 ----------
 9 files changed, 39 insertions(+), 47 deletions(-)

-- 
2.31.1

