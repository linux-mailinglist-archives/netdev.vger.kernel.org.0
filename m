Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4001B48E95A
	for <lists+netdev@lfdr.de>; Fri, 14 Jan 2022 12:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240549AbiANLoG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 06:44:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:46500 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232850AbiANLoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 06:44:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642160643;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=VNic94IxSHz45hWht721ho+r9gYPsH1CdBTdhg8hMEw=;
        b=gigB5MulzS6ZClw7iN9p0DNHyezLW5fiE0Alcl4KSgDMMGBs5Ig77CROQGbTvhyTg0KxzY
        nb6W1SuNtUQPrrKMlWqaeaf0tVGXmwV/t14EM9+Ul+j4bfRmT1UN/zS4mWDi5B+pZd34a9
        CarLAqiYbxr7EHzbU8v4GjYqX9Xfz9E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-606-vTHAC1gNOPWt22kdxLnAsg-1; Fri, 14 Jan 2022 06:43:58 -0500
X-MC-Unique: vTHAC1gNOPWt22kdxLnAsg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56435805733;
        Fri, 14 Jan 2022 11:43:57 +0000 (UTC)
Received: from calimero.vinschen.de (ovpn-112-14.ams2.redhat.com [10.36.112.14])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 739D87B9FC;
        Fri, 14 Jan 2022 11:43:56 +0000 (UTC)
Received: by calimero.vinschen.de (Postfix, from userid 500)
        id AFA0AA80D9B; Fri, 14 Jan 2022 12:43:54 +0100 (CET)
From:   Corinna Vinschen <vinschen@redhat.com>
To:     intel-wired-lan@osuosl.org, netdev@vger.kernel.org,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Lennert Buytenhek <buytenh@wantstofly.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>
Subject: [PATCH 0/2 net-next v2] igb/igc: fix XDP registration
Date:   Fri, 14 Jan 2022 12:43:52 +0100
Message-Id: <20220114114354.1071776-1-vinschen@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the kernel warning "Missing unregister, handled but fix driver"
when running, e.g.,

  $ ethtool -G eth0 rx 1024

on igc.  Remove memset hack from igb and align igb code to igc. 

Corinna Vinschen (2):
  igc: avoid kernel warning when changing RX ring parameters
  igb: refactor XDP registration

 drivers/net/ethernet/intel/igb/igb_ethtool.c |  4 ----
 drivers/net/ethernet/intel/igb/igb_main.c    | 15 +++++++++++----
 drivers/net/ethernet/intel/igc/igc_main.c    | 20 +++++++++++---------
 3 files changed, 22 insertions(+), 17 deletions(-)

-- 
2.27.0

