Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0EB6593123
	for <lists+netdev@lfdr.de>; Mon, 15 Aug 2022 16:59:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242627AbiHOO6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 10:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242201AbiHOO5r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 10:57:47 -0400
Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 750881F2CD
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 07:57:45 -0700 (PDT)
Received: (wp-smtpd smtp.wp.pl 14328 invoked from network); 15 Aug 2022 16:57:42 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1660575462; bh=ZUSvVpgY85aUwoJT/VD92DZwtlhEXu1oicdr14fi0zU=;
          h=From:To:Subject;
          b=VhKSeIN2cSZTxgb63u3nfIzRa++3ftlaaW15BOboxYlAjbgVkEa8O8/wqUQYkIf6+
           CVrSsvkXAJfJUzJqxrfxTeGXpTTIzH00wEZalsDMQWOmzY6D4YVmddm4V/P+ZvSmU2
           Z4B8AiJGS1hgbunvOE1KYswyLvTkiCiMT3GE8EZU=
Received: from ip-137-21.ds.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.21])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <hauke@hauke-m.de>; 15 Aug 2022 16:57:42 +0200
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     hauke@hauke-m.de, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, olek2@wp.pl,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net v2 0/3] net: lantiq_xrx200: fix errors under memory pressure
Date:   Mon, 15 Aug 2022 16:57:37 +0200
Message-Id: <20220815145740.12075-1-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: 955d87834941e9400fd02a20d217498d
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [IbMk]                               
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series fixes issues that can occur in the driver under memory pressure.
Situations when the system cannot allocate memory are rare, so the mentioned bugs
have been fixed recently. The patches have been tested on a BT Home router with the
Lantiq xRX200 chipset.

Changelog:

  v2:
  - the second patch has been changed, so that under memory pressure situation
    the driver will not receive packets indefinitely regardless of the NAPI budget,
  - the third patch has been added.

Aleksander Jan Bajkowski (3):
  net: lantiq_xrx200: confirm skb is allocated before using
  net: lantiq_xrx200: fix lock under memory pressure
  net: lantiq_xrx200: restore buffer if memory allocation failed

 drivers/net/ethernet/lantiq_xrx200.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

-- 
2.30.2

