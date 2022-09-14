Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 076F75B8DCB
	for <lists+netdev@lfdr.de>; Wed, 14 Sep 2022 19:05:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbiINRE5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 14 Sep 2022 13:04:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbiINREz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Sep 2022 13:04:55 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD7F212A99
        for <netdev@vger.kernel.org>; Wed, 14 Sep 2022 10:04:49 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-85-MYrKGFVTNIup7RnVPrXKQg-1; Wed, 14 Sep 2022 13:04:42 -0400
X-MC-Unique: MYrKGFVTNIup7RnVPrXKQg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9919838149AE;
        Wed, 14 Sep 2022 17:04:41 +0000 (UTC)
Received: from hog.localdomain (unknown [10.40.195.234])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 97CC31121314;
        Wed, 14 Sep 2022 17:04:40 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     steffen.klassert@secunet.com, Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH ipsec-next 0/7] xfrm: add netlink extack for state creation
Date:   Wed, 14 Sep 2022 19:03:59 +0200
Message-Id: <cover.1663103634.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252; x-default=true
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the second part of my work adding extended acks to XFRM, now
taking care of state creation. Policies were handled in the previous
series [1].
To keep this series at a reasonable size, x->type->init_state will be
handled separately.

[1] https://lkml.kernel.org/r/cover.1661162395.git.sd@queasysnail.net

Sabrina Dubroca (7):
  xfrm: add extack support to verify_newsa_info
  xfrm: add extack to verify_replay
  xfrm: add extack to verify_one_alg, verify_auth_trunc, verify_aead
  xfrm: add extack support to xfrm_dev_state_add
  xfrm: add extack to attach_*
  xfrm: add extack to __xfrm_init_state
  xfrm: add extack support to xfrm_init_replay

 include/net/xfrm.h     |  10 +-
 net/xfrm/xfrm_device.c |  20 +++-
 net/xfrm/xfrm_replay.c |  10 +-
 net/xfrm/xfrm_state.c  |  28 ++++--
 net/xfrm/xfrm_user.c   | 209 +++++++++++++++++++++++++++++------------
 5 files changed, 196 insertions(+), 81 deletions(-)

-- 
2.37.3

