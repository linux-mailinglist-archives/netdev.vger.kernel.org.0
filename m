Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4531450765F
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 19:19:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245118AbiDSRVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 13:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237020AbiDSRVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 13:21:45 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 78C8935DEC
        for <netdev@vger.kernel.org>; Tue, 19 Apr 2022 10:19:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650388741;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=eVdLWTfbtNBd3TEFtmiqkLvoxJk9+8k+wCtc4CdxD5E=;
        b=Y92TitcqnP9UAuM04iQb4pwolqI104sVaAp7JsO9eVwD7/FknBTjBC70BCs3ZGUktsAuZM
        IbL8tzAHMNff4K+iJvFdgHdzWo+O4FTwDXB9Ve9fk3ouKeyFCKe95TpbGbpU07A7NS89hi
        rrpHH743GGmwACFdxXWLK/BXKLhHrVE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-395-GJBA5tKkMsaDCTq-yAF2UA-1; Tue, 19 Apr 2022 13:18:59 -0400
X-MC-Unique: GJBA5tKkMsaDCTq-yAF2UA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8E4631802A1B;
        Tue, 19 Apr 2022 17:18:45 +0000 (UTC)
Received: from gerbillo.redhat.com (unknown [10.39.193.165])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CE50640146E;
        Tue, 19 Apr 2022 17:18:44 +0000 (UTC)
From:   Paolo Abeni <pabeni@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Eric Dumazet <eric.dumazet@gmail.com>, mptcp@lists.linux.dev
Subject: [RFC PATCH 0/2] mptcp: never shrink offered window
Date:   Tue, 19 Apr 2022 19:18:22 +0200
Message-Id: <cover.1650386197.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There patches are part of a somewhat largish series to implement
more strict RFC compliance for the MPTCP-level congestion window
handling, solving some tput instability issues.

The obtain the above we need to modify an existing MPTCP hook,
touching the TCP code (in patch 1/2), ence the RFC.

The later patch demonstrates the actual usage of such hook.

Paolo Abeni (2):
  tcp: allow MPTCP to update the announced window.
  mptcp: never shrink offered window

 include/net/mptcp.h   |  2 +-
 net/ipv4/tcp_output.c | 14 ++++++-----
 net/mptcp/options.c   | 54 ++++++++++++++++++++++++++++++++++++-------
 3 files changed, 55 insertions(+), 15 deletions(-)

-- 
2.35.1

