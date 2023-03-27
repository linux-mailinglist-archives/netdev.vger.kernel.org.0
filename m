Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D89A6C9E25
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 10:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233286AbjC0Iks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 04:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233082AbjC0Ikd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 04:40:33 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3617A6A42;
        Mon, 27 Mar 2023 01:36:51 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 1ABE321AB2;
        Mon, 27 Mar 2023 08:36:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1679906209; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=v6oIQCvPsK0b+etSaaLmHyST9of/SZHXfQgb0QAgenE=;
        b=Oi3uElNpMUuOMeDRymfgAwa5c2IqAibwS3mTpkTLizw999HdkXOS1GW5XUH67WRrnwYWOU
        nLAcy9zmDB1SV1j49URJEljBGckKUPgkvNJ7DHnQ4UkIdIFCMAfCoO/3Xl0gi6AjTx2bfZ
        UEV7dQkypnhgOwx26R9vDO7b/jyncC0=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id B2EA313329;
        Mon, 27 Mar 2023 08:36:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id g+hAKqBVIWShSAAAMHmgww
        (envelope-from <jgross@suse.com>); Mon, 27 Mar 2023 08:36:48 +0000
From:   Juergen Gross <jgross@suse.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        xen-devel@lists.xenproject.org, stable@vger.kernel.org
Subject: [PATCH 0/2] xen/netback: fix issue introduced recently
Date:   Mon, 27 Mar 2023 10:36:44 +0200
Message-Id: <20230327083646.18690-1-jgross@suse.com>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The fix for XSA-423 introduced a bug which resulted in loss of network
connection in some configurations.

The first patch is fixing the issue, while the second one is removing
a test which isn't needed.

Juergen Gross (2):
  xen/netback: don't do grant copy across page boundary
  xen/netback: remove not needed test in xenvif_tx_build_gops()

 drivers/net/xen-netback/common.h  |  2 +-
 drivers/net/xen-netback/netback.c | 29 +++++++++++++++++++++++------
 2 files changed, 24 insertions(+), 7 deletions(-)

-- 
2.35.3

