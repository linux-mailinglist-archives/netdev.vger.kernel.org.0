Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D395A4A62AD
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 18:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241521AbiBARkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 12:40:16 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54568 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233255AbiBARkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 12:40:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643737215;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=ghdV4c06hG1RAsae/AvPlycwKm6jozOy2iveBFu5C94=;
        b=R0Qzc7bVyEKdYgDstDqSOpV8vc1Y0e4P8/w4XX9c8IeoZ2EYjKWQQLXwA7jhjJgrw59wt4
        XvwQG1UrnneGHM/Oa2syHUBKnYIxYS6p6gJqVkbJqlZ6EoukGYCMYLiOKWIb+JHvi/ZJw3
        DaN34VCALXTSUYlrGmtgFj3mcbsiFzY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-382-bzqKz0aIMnCCnTM93B50aA-1; Tue, 01 Feb 2022 12:40:12 -0500
X-MC-Unique: bzqKz0aIMnCCnTM93B50aA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4215B81F031;
        Tue,  1 Feb 2022 17:39:52 +0000 (UTC)
Received: from tc2.redhat.com (unknown [10.39.195.81])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 10C64D1908;
        Tue,  1 Feb 2022 17:39:50 +0000 (UTC)
From:   Andrea Claudi <aclaudi@redhat.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com,
        markzhang@nvidia.com, leonro@nvidia.com
Subject: [PATCH iproute2 0/3] some memory leak fixes
Date:   Tue,  1 Feb 2022 18:39:23 +0100
Message-Id: <cover.1643736038.git.aclaudi@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes some memory leaks related to the usage of the
get_task_name() function from lib/fs.c.

Patch 3/3 addresses a coverity warning related to this memory leak,
making the code a bit more readable by humans and coverity.

Andrea Claudi (3):
  lib/fs: fix memory leak in get_task_name()
  rdma: stat: fix memory leak in res_counter_line()
  rdma: RES_PID and RES_KERN_NAME are alternatives to each other

 lib/fs.c        | 10 +++++--
 rdma/res-cmid.c | 10 +++----
 rdma/res-cq.c   |  9 +++---
 rdma/res-ctx.c  |  9 +++---
 rdma/res-mr.c   |  8 ++---
 rdma/res-pd.c   |  9 +++---
 rdma/res-qp.c   |  9 +++---
 rdma/res-srq.c  | 10 +++----
 rdma/stat.c     | 79 ++++++++++++++++++++++++++++++++-----------------
 9 files changed, 88 insertions(+), 65 deletions(-)

-- 
2.34.1

