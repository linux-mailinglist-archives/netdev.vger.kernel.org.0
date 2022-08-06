Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25F6F58B3D9
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 06:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237015AbiHFEnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Aug 2022 00:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiHFEna (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Aug 2022 00:43:30 -0400
Received: from mail-pj1-x104a.google.com (mail-pj1-x104a.google.com [IPv6:2607:f8b0:4864:20::104a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB36C12D2B
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 21:43:29 -0700 (PDT)
Received: by mail-pj1-x104a.google.com with SMTP id lp15-20020a17090b4a8f00b001f50db32814so5298536pjb.0
        for <netdev@vger.kernel.org>; Fri, 05 Aug 2022 21:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=sgNw4ppnbFNmP14bxP0aHq3Spm/ekEGP+6Imp9WW/28=;
        b=XTx+z1+lS+TqlQzpru5oZf6TDk+4EKVdLzJxu2pOKydbu71c7saunwsuWc/CLEjgep
         WndpvbYnZweKhS77LdT/hlJoKDliB/cw/FfoCc7fTovR+LeuXrsTOSQUpFDSnqbGG4Vp
         pyZCX/ue5657DNLQ1zoqQQrMfDldMh5aGkquQ56g/R0TMgWLzKXIAKBK9up6o9oBCJF0
         Af3DoFZC/HdZw40FexUEIncLOBNTeNyT9xVn1x3HIWYAufZF5edxLOgiF+/MQSfB0zqo
         yAyKi46qK/fgTC5JmsT91LW597A2coDm8xhkwo8VxvB0QopDlxheI1Gsevy4YUo0tOiY
         R+mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=sgNw4ppnbFNmP14bxP0aHq3Spm/ekEGP+6Imp9WW/28=;
        b=mtTWDoPWq/lVO1lqA0FcRCclycYdxSWl4qWR/HwA2vBKhMbsSR4KPbhN9pmuksco8k
         lWDyYV80X7OInKsLDXm2ZkSgk/U1M0IVaobHILEscvVcRbkx8drwwLK5cvld7fTWaInI
         S5ZZhPVhYkhP/gM/EPRLinyM9KT/mZfAUuA6AOI48Jb3i1hSoTp5ZhtadQqHxM2ibkT0
         7bxTRz6Yp6ueR3OweKd8352BDby2bXivsE1NJLKCh1L3oM8pDkVRFO0Zjwoci3Be8M/I
         DYATi5ZGZfwkTR1iZ034f3inVGeY4UkLsg8HDaTRwzo6qWG4Lf6YfcFDrkATRYMIWWtP
         iUDQ==
X-Gm-Message-State: ACgBeo0/pCVqb1DCq+eKrNE01ldvBZ8opPYmcEZOFVt3O3w+sofVdoMV
        JSzGwiNT8nFmq2AGJtdRPcvhs4KIA4IlzuTTcL6WGB6ZNjEnDe7raIpKS9GTmatxlCFjp0s5blg
        lGFAyrayQ4Kux+3EGZtZt0ounGN3LtaC+Tn2f0XLm4pYqHIIsvHDSWYoiIszax0/XdHnRyx69KU
        +J4A==
X-Google-Smtp-Source: AA6agR6if4Pi0sDTOKM+YV3ZIoSfhYxs/+UFHsBH6S1FlhjySQkajCkK8J/Jtq7YeFZqDw0g2jVMxeEg8fXTsqnSRjQ=
X-Received: from obsessiveorange-c1.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3039])
 (user=benedictwong job=sendgmr) by 2002:a17:902:6ac5:b0:16d:1664:39c9 with
 SMTP id i5-20020a1709026ac500b0016d166439c9mr9561237plt.104.1659761009090;
 Fri, 05 Aug 2022 21:43:29 -0700 (PDT)
Reply-To: Benedict Wong <benedictwong@google.com>
Date:   Sat,  6 Aug 2022 04:43:06 +0000
In-Reply-To: <20220806044307.4007851-1-benedictwong@google.com>
Message-Id: <20220806044307.4007851-2-benedictwong@google.com>
Mime-Version: 1.0
References: <20220806044307.4007851-1-benedictwong@google.com>
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [RFC ipsec 1/2] xfrm: Check policy for nested XFRM packets in xfrm_input
From:   Benedict Wong <benedictwong@google.com>
To:     netdev@vger.kernel.org
Cc:     nharold@google.com, benedictwong@google.com, lorenzo@google.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change ensures that all nested XFRM packets have their policy
checked before decryption of the next layer, so that policies are
verified at each intermediate step of the decryption process.

This is necessary especially for nested tunnels, as the IP addresses,
protocol and ports may all change, thus not matching the previous
policies. In order to ensure that packets match the relevant inbound
templates, the xfrm_policy_check should be done before handing off to
the inner XFRM protocol to decrypt and decapsulate.

Test: Tested against Android Kernel Unit Tests
Signed-off-by: Benedict Wong <benedictwong@google.com>
Change-Id: I20c5abf39512d7f6cf438c0921a78a84e281b4e9
---
 net/xfrm/xfrm_input.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 144238a50f3d..b24df8a44585 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -585,6 +585,13 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 			goto drop;
 		}
 
+		// If nested tunnel, check outer states before context is lost.
+		if (x->outer_mode.flags & XFRM_MODE_FLAG_TUNNEL
+				&& sp->len > 0
+				&& !xfrm_policy_check(NULL, XFRM_POLICY_IN, skb, family)) {
+			goto drop;
+		}
+
 		skb->mark = xfrm_smark_get(skb->mark, x);
 
 		sp->xvec[sp->len++] = x;
-- 
2.37.1.559.g78731f0fdb-goog

