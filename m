Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57C51543B4B
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 20:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235464AbiFHSR1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 14:17:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235102AbiFHSPG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 14:15:06 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 046A3F66
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 11:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654712103;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=KtTqOFBPhNUiDjjBagEddu+2OQP4Rt1P8k3OOPYqKPg=;
        b=a2z061XQ8wPSwZMPhgxTVyauQSj4Dl6HSuYvVuPFbAooht7OWCfBcmzk9sVMfe8dS63nvm
        Ia5+FFV46l868W3v/a2BHJdhseBKDN5kxrFEPtfyF7Tqjon1R3c12hVALTClrUiDRnBO8U
        FB3O/qQSX0xELSKfQ6BbvjDbeJ7yxt8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-453-0F20A9oZNfi5ZphfQ3Hvsw-1; Wed, 08 Jun 2022 14:15:01 -0400
X-MC-Unique: 0F20A9oZNfi5ZphfQ3Hvsw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 866FF811E75
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 18:15:01 +0000 (UTC)
Received: from jtoppins.rdu.csb (unknown [10.22.16.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 67E3F492CA3;
        Wed,  8 Jun 2022 18:15:01 +0000 (UTC)
From:   Jonathan Toppins <jtoppins@redhat.com>
To:     netdev@vger.kernel.org
Cc:     jtoppins@redhat.com
Subject: [net-next v2 0/2] bonding: netlink errors and cleanup
Date:   Wed,  8 Jun 2022 14:14:55 -0400
Message-Id: <cover.1654711315.git.jtoppins@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first patch attempts to set helpful error messages when
configuring bonds via netlink. The second patch removes redundant
init code for RLB mode which is already done in bond_open.

v2:
 * rebased to latest net-next
 * fixed kernel doc header for __bond_opt_set

Jonathan Toppins (2):
  bonding: netlink error message support for options
  bonding: cleanup bond_create

 drivers/net/bonding/bond_main.c    |  24 ++-----
 drivers/net/bonding/bond_netlink.c | 101 +++++++++++++++++++----------
 drivers/net/bonding/bond_options.c |  32 +++++++--
 include/net/bond_options.h         |   3 +-
 4 files changed, 101 insertions(+), 59 deletions(-)

-- 
2.27.0

