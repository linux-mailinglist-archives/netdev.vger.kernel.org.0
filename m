Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7392A58D653
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 11:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239377AbiHIJUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 05:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238994AbiHIJUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 05:20:15 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DAA3ECE0
        for <netdev@vger.kernel.org>; Tue,  9 Aug 2022 02:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660036813;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=1coLnly0rTmWr54Er5fgKDUFfL/WOaU2v71xFze/5mk=;
        b=I7Q2/tGPiIwAGKbNKCGYXU54Kezqh3SMc0E/ny/7Q5pkC/cTsbP905+xNbgAWt7r0ZjXSy
        Df95NaI7B6gwRNi+h9E1mlDOBPf65Jw0KiBKjCPkoDVsco/qCkjzIhmibRYndgo5GFMAfT
        8L3bwnYTelf7ib+52L1NLE9B/6fhtIo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-59-WghWEG6hMfaJQ-N_nv3kgg-1; Tue, 09 Aug 2022 05:20:08 -0400
X-MC-Unique: WghWEG6hMfaJQ-N_nv3kgg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 021728037B3;
        Tue,  9 Aug 2022 09:20:08 +0000 (UTC)
Received: from ihuguet-laptop.redhat.com (unknown [10.39.193.75])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1CD3C40C1288;
        Tue,  9 Aug 2022 09:20:04 +0000 (UTC)
From:   =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
To:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        =?UTF-8?q?=C3=8D=C3=B1igo=20Huguet?= <ihuguet@redhat.com>
Subject: [PATCH net-next 0/3] sfc: add support for PTP over IPv6 and 802.3
Date:   Tue,  9 Aug 2022 11:19:59 +0200
Message-Id: <20220809092002.17571-1-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Most recent cards (8000 series and newer) had enough hardware support
for this, but it was not enabled in the driver. The transmission of PTP
packets over these protocols was already added in commit bd4a2697e5e2
("sfc: use hardware tx timestamps for more than PTP"), but receiving
them was already unsupported so synchronization didn't happen.

These patches add support for timestamping received packets over
IPv6/UPD and IEEE802.3.

Íñigo Huguet (3):
  sfc: allow more flexible way of adding filters for PTP
  sfc: support PTP over IPv6/UDP
  sfc: support PTP over Ethernet

 drivers/net/ethernet/sfc/filter.h |  22 +++++
 drivers/net/ethernet/sfc/ptp.c    | 132 ++++++++++++++++++++----------
 2 files changed, 110 insertions(+), 44 deletions(-)

-- 
2.34.1

