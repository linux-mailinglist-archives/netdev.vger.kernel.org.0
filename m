Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A16DB6CC044
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 15:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbjC1NLb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 09:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232943AbjC1NLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 09:11:24 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF359D;
        Tue, 28 Mar 2023 06:11:02 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id C97D51F8B8;
        Tue, 28 Mar 2023 13:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1680009055; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
        bh=Nw57r4ThzP515ds3lDpYM7Hl3NRvlAaDQvtIsIkfIz8=;
        b=U8xR4NYPd2oP+KbbTf12uNbuGqeSVqFfLMHH0GBM/KMkNT3J5snWac7d4OGQTjxYnVFdPQ
        RbPIwQRUfohMt2xNvpyu01g7plm7JWEbOl+56ODRgJkUR0QROehYIJ6SiuguGF05Xwdqu1
        GKSMTzHmwsnosUyZOYm29qhE/zMEgVw=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 38C4F1390D;
        Tue, 28 Mar 2023 13:10:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Hvl+DF/nImQ1TQAAMHmgww
        (envelope-from <jgross@suse.com>); Tue, 28 Mar 2023 13:10:55 +0000
From:   Juergen Gross <jgross@suse.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Juergen Gross <jgross@suse.com>, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        xen-devel@lists.xenproject.org, stable@vger.kernel.org
Subject: [PATCH v2 0/3] xen/netback: fix issue introduced recently
Date:   Tue, 28 Mar 2023 15:10:44 +0200
Message-Id: <20230328131047.2440-1-jgross@suse.com>
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
a test which isn't needed. The third patch is making error messages
more uniform.

Changes in V2:
- add patch 3
- comment addressed (patch 1)


Juergen Gross (3):
  xen/netback: don't do grant copy across page boundary
  xen/netback: remove not needed test in xenvif_tx_build_gops()
  xen/netback: use same error messages for same errors

 drivers/net/xen-netback/common.h  |  2 +-
 drivers/net/xen-netback/netback.c | 37 ++++++++++++++++++++++---------
 2 files changed, 28 insertions(+), 11 deletions(-)

-- 
2.35.3

