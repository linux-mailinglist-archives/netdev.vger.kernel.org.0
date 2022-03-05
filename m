Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3CFF4CE663
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 19:14:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232161AbiCESOv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 13:14:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231990AbiCESOu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 13:14:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 57E4E6D4DB
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 10:14:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646504039;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=TQ/PmDy/wAuYSRhPMWBzjgjzADBCIpXP0+QPOpZXWOA=;
        b=BIOWRZ3p+8OPbDI/1Ap0jy8Av6aUHsF+MmDs1hqPlQ0+xvWWU1bgJ3lUcmsffqnxrODSAZ
        +xczlOnKSnyOiIC+HeqWUCniCJk2IJShp2FxxLDEegFq15B4tweluMB3msH2yJpYRvppIq
        RelQ0QU/9y1m8rDADMypjdoersFJtEo=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-375-Yrtztn2xO7iVlCFP2i0NEw-1; Sat, 05 Mar 2022 13:13:58 -0500
X-MC-Unique: Yrtztn2xO7iVlCFP2i0NEw-1
Received: by mail-qk1-f200.google.com with SMTP id f17-20020a05620a069100b0060dfbbb52cfso8147734qkh.1
        for <netdev@vger.kernel.org>; Sat, 05 Mar 2022 10:13:58 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TQ/PmDy/wAuYSRhPMWBzjgjzADBCIpXP0+QPOpZXWOA=;
        b=DMLS0ej6v2iljEOxStNk1hZcLfxH0M8qiD6En8eNjz9sjZp7vEBlju3Ah9Pz2X37ZA
         T0fIMeHO2My2A7T60APjRAWN0i7IlZBMysBADmc0hvm361N5X86oHGLoUTElOmvFiSpX
         DgfrhYw5iIkJ4zqo3ryVOGPBWo9m//cDZ2UIwC1IL6ot1y9y0RDK6qHcM+8wT3jutxUL
         KOjUcmvBeOz7zeYWIo0nl49631zDfucek3LOw8kKsUL12RDlDvv28mAkCsqVZtDrTdCy
         umuh1qa59OohyrmD7olvhCLBmsd+4pyD61t9AhCM6o62BLxOx6fJyPwZdzyWlYDD/545
         BqJg==
X-Gm-Message-State: AOAM530/dYtYPhkAgppP+8ejD8veMfzl/vuCt9s7mQTqED7x0uijNIlt
        CmjWHW+G2lIDS8UNuS1FY0EyfKGJrcWhZLKScgpdLa5chCqQcikDf6DAi2xmLslfkhCrbxjquI/
        0vFqExeJb5o9XQKcZ
X-Received: by 2002:a37:55c2:0:b0:479:8293:d7d0 with SMTP id j185-20020a3755c2000000b004798293d7d0mr2560806qkb.182.1646504036864;
        Sat, 05 Mar 2022 10:13:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz/MM0HeyZ0Th4tenJoq2/b1En2hM1Tyt/SzPGuspo4wRFFLCKSYHG4o9YEfNHsPP4FSG4HKQ==
X-Received: by 2002:a37:55c2:0:b0:479:8293:d7d0 with SMTP id j185-20020a3755c2000000b004798293d7d0mr2560793qkb.182.1646504036653;
        Sat, 05 Mar 2022 10:13:56 -0800 (PST)
Received: from localhost.localdomain.com (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id w20-20020a05622a135400b002dd9806d532sm5376407qtk.54.2022.03.05.10.13.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Mar 2022 10:13:56 -0800 (PST)
From:   trix@redhat.com
To:     davem@davemloft.net, kuba@kernel.org, nathan@kernel.org,
        ndesaulniers@google.com, idosch@nvidia.com, petrm@nvidia.com,
        edumazet@google.com, avagin@gmail.com, yajun.deng@linux.dev,
        johannes.berg@intel.com, cong.wang@bytedance.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, Tom Rix <trix@redhat.com>
Subject: [PATCH] net: rtnetlink: fix error handling in rtnl_fill_statsinfo()
Date:   Sat,  5 Mar 2022 10:13:46 -0800
Message-Id: <20220305181346.697365-1-trix@redhat.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

The clang static analyzer reports this issue
rtnetlink.c:5481:2: warning: Undefined or garbage
  value returned to caller
  return err;
  ^~~~~~~~~~

There is a function level err variable, in the
list_for_each_entry_rcu block there is a shadow
err.  Remove the shadow.

In the same block, the call to nla_nest_start_noflag()
can fail without setting an err.  Set the err
to -EMSGSIZE.

Fixes: 216e690631f5 ("net: rtnetlink: rtnl_fill_statsinfo(): Permit non-EMSGSIZE error returns")
Signed-off-by: Tom Rix <trix@redhat.com>
---
 net/core/rtnetlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index a66b6761b88b1..a759f9e0a8476 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -5440,12 +5440,12 @@ static int rtnl_fill_statsinfo(struct sk_buff *skb, struct net_device *dev,
 		list_for_each_entry_rcu(af_ops, &rtnl_af_ops, list) {
 			if (af_ops->fill_stats_af) {
 				struct nlattr *af;
-				int err;
 
 				af = nla_nest_start_noflag(skb,
 							   af_ops->family);
 				if (!af) {
 					rcu_read_unlock();
+					err = -EMSGSIZE;
 					goto nla_put_failure;
 				}
 				err = af_ops->fill_stats_af(skb, dev);
-- 
2.26.3

