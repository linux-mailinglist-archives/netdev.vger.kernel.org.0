Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E09157DEA4
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 11:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236304AbiGVJ3t convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 22 Jul 2022 05:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236538AbiGVJ2t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 05:28:49 -0400
Received: from us-smtp-delivery-44.mimecast.com (us-smtp-delivery-44.mimecast.com [207.211.30.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 85DCFCE50E
        for <netdev@vger.kernel.org>; Fri, 22 Jul 2022 02:18:02 -0700 (PDT)
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-659-o7fhMaXRPsGuuCCm_8OPGg-1; Fri, 22 Jul 2022 05:16:46 -0400
X-MC-Unique: o7fhMaXRPsGuuCCm_8OPGg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E29511019C8E;
        Fri, 22 Jul 2022 09:16:45 +0000 (UTC)
Received: from hog.localdomain (unknown [10.39.194.156])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DFE182166B26;
        Fri, 22 Jul 2022 09:16:44 +0000 (UTC)
From:   Sabrina Dubroca <sd@queasysnail.net>
To:     netdev@vger.kernel.org
Cc:     Era Mayflower <mayflowerera@gmail.com>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: [PATCH net 0/4] macsec: fix config issues
Date:   Fri, 22 Jul 2022 11:16:26 +0200
Message-Id: <cover.1656519221.git.sd@queasysnail.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.6
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: queasysnail.net
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=WINDOWS-1252; x-default=true
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The patch adding netlink support for XPN (commit 48ef50fa866a
("macsec: Netlink support of XPN cipher suites (IEEE 802.1AEbw)"))
introduced several issues, including a kernel panic reported at [1].

Reproducing those bugs with upstream iproute is limited, since iproute
doesn't currently support XPN. I'm also working on this.

[1] https://bugzilla.kernel.org/show_bug.cgi?id=208315

Sabrina Dubroca (4):
  macsec: fix NULL deref in macsec_add_rxsa
  macsec: fix error message in macsec_add_rxsa and _txsa
  macsec: limit replay window size with XPN
  macsec: always read MACSEC_SA_ATTR_PN as a u64

 drivers/net/macsec.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

-- 
2.36.1

