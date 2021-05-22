Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E35E138D5F8
	for <lists+netdev@lfdr.de>; Sat, 22 May 2021 15:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbhEVNQK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 May 2021 09:16:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:35202 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230466AbhEVNQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 May 2021 09:16:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621689285;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=txqQXmD7+0ijFry1OcvlQyOzU8fYtGUJM51MuAZnFeA=;
        b=QWTQtQH31c/b5qREYmOa80gcieQKl1tlJpHzLAYnEjMrqrVGQlrkdOhxHA/nMUlSRY8zJy
        oA7BzluiqR2WzPSt9BZPxj98mKBcRQBXewj8cLyjYnnNFbfig9qjz+YEMjl5EBcV7TgeoY
        5qMDgzcE757mWzKqRiyKxjY++ZfOJE8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-452-hesPXpTSMl2JSnjfkwQCFQ-1; Sat, 22 May 2021 09:14:43 -0400
X-MC-Unique: hesPXpTSMl2JSnjfkwQCFQ-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 97A45801107;
        Sat, 22 May 2021 13:14:41 +0000 (UTC)
Received: from dcaratti.station (unknown [10.40.194.65])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6EFD961F20;
        Sat, 22 May 2021 13:14:37 +0000 (UTC)
From:   Davide Caratti <dcaratti@redhat.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH net 0/2] two fixes for the fq_pie scheduler
Date:   Sat, 22 May 2021 15:14:33 +0200
Message-Id: <cover.1621687869.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- patch 1/2 restores the possibility to use 65536 flows with fq_pie,
  preserving the fix for an endless loop in the control plane
- patch 2/2 fixes an OOB access that can be observed in the traffic
  path of fq_pie scheduler, when the classification selects a flow
  beyond the allocated space.


Davide Caratti (2):
  net/sched: fq_pie: re-factor fix for fq_pie endless loop
  net/sched: fq_pie: fix OOB access in the traffic path

 net/sched/sch_fq_pie.c                        | 19 +++++++++++++------
 .../tc-testing/tc-tests/qdiscs/fq_pie.json    |  8 ++++----
 2 files changed, 17 insertions(+), 10 deletions(-)

-- 
2.31.1

