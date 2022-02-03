Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4DD54A87FA
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 16:49:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351956AbiBCPsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 10:48:40 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:28170 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238679AbiBCPsj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 10:48:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643903319;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=cScamWd1dQm3BRNz//Q/DNoSm+/XY+0Vn5ed6VkR6Uk=;
        b=XBy/gvJQlq92etqd+9m5F/mjBPTV3ZgvYdMCwEFXTHWreRdvbPH5HN5C6NfCYjkn6Q5V+V
        nnwcvEz4n+UWSycGoeZGwLsTa4zvS4Z2zDXd98v4MEJY9FvZh4aFlkaO4w08p0k7nX0JkY
        khy2DTmmlEJBRNcRqVTU9e+1WWfLzjg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-413-IZLgoaosPuKlh_Zd3sEgGA-1; Thu, 03 Feb 2022 10:48:36 -0500
X-MC-Unique: IZLgoaosPuKlh_Zd3sEgGA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AAB971091DA0;
        Thu,  3 Feb 2022 15:48:34 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.193.191])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 346CF10841E4;
        Thu,  3 Feb 2022 15:48:33 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net-next 0/3] gro: some minor optimization
Date:   Thu,  3 Feb 2022 16:48:20 +0100
Message-Id: <cover.1643902526.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series collects a few small optimization for the GRO engine.
I measure a 10% performance improvements in micro-benchmarks
around dev_gro_receive(), but deltas are within noise range in tput
tests.

Still with big TCP coming every cycle saved from the GRO engine will
count - I hope ;)

The only change from the RFC is in patch 2, as per Alexander feedback

Paolo Abeni (3):
  net: gro: avoid re-computing truesize twice on recycle
  net: gro: minor optimization for dev_gro_receive()
  net: gro: register gso and gro offload on separate lists

 include/linux/netdevice.h |   3 +-
 include/net/gro.h         |  52 +++++++++---------
 net/core/gro.c            | 109 +++++++++++++++++++++-----------------
 3 files changed, 91 insertions(+), 73 deletions(-)

-- 
2.34.1

