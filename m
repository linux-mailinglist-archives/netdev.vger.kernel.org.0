Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DEC767C4C0
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 08:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234351AbjAZHOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 02:14:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233849AbjAZHOh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 02:14:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41BFA611E7
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 23:14:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE420B81D04
        for <netdev@vger.kernel.org>; Thu, 26 Jan 2023 07:14:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49198C4339B;
        Thu, 26 Jan 2023 07:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674717272;
        bh=2v2ehF/GUzsLBPSHt6k3jtHFUCcCxDMV6SB/D/C9tUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KFzxP/mfhxjCCVyXkkjWdrf9sHCj4tyTwlN/C+B3IgqVGDpjFej/7TYe1DTN39y7V
         m4KfRAX70JPfIgOEX50djCJ0jvyPDg+kUTvJP4uL0XBvNapDXJl568eKVTIXs+UfDe
         dEs+35tve7/krkbjEqThCHNucHLlsdCHlE4dXdgGGNEwtlWSqVcIaopLo4/wmTUc3K
         nw9AD/v4vgw4kFVe41PQZotIEYLM9vdf5J4BM8bpM3lpJkgFx89IX/jVDDjClXaZ67
         IxTlovSIQJ6RjPfnJFqKZR8nTU6L12yOF+uj+Ik3Se4LRdvL8W5T17bvXTEyW3gX6/
         Yuf3OpQUfKg+Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>, imagedong@tencent.com
Subject: [PATCH net-next 09/11] net: skbuff: drop the linux/splice.h include
Date:   Wed, 25 Jan 2023 23:14:22 -0800
Message-Id: <20230126071424.1250056-10-kuba@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230126071424.1250056-1-kuba@kernel.org>
References: <20230126071424.1250056-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

splice.h is included since commit a60e3cc7c929 ("net: make
skb_splice_bits more configureable") but really even then
all we needed is some forward declarations. Most of that
code is now gone, and remaining has fwd declarations.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
CC: imagedong@tencent.com
---
 include/linux/skbuff.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index a1978adc5644..c6fd5d5b50e0 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -29,7 +29,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/netdev_features.h>
 #include <net/flow_dissector.h>
-#include <linux/splice.h>
 #include <linux/in6.h>
 #include <linux/if_packet.h>
 #include <linux/llist.h>
-- 
2.39.1

