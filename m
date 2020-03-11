Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A420181C24
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 16:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729691AbgCKPQo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 11:16:44 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31457 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729408AbgCKPQn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 11:16:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583939801;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=QfJkRFu5RaDXrwZg50JYcxYplBQGbU6H0Jjsn87EwVM=;
        b=VOZBySWdQtpFEYBI1Y0mFvS9ywJwgqhS3d7xJKMtrr8ZptNWaJQdYolLzNjhB6FTZd/Isb
        PU3ImAGsssN6gqLQpLikFFvS3RNmOZbDbC7tdtOCCnspAk9Z9Lg6Av7H/nxsOw29ZADbCX
        9zQ/ShYUEdYTp1uryXIOc/ZsswA0Dcg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-MzNav37cNyKuDgr0Hofi6A-1; Wed, 11 Mar 2020 11:16:40 -0400
X-MC-Unique: MzNav37cNyKuDgr0Hofi6A-1
Received: by mail-wr1-f72.google.com with SMTP id p11so1100024wrn.10
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 08:16:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=QfJkRFu5RaDXrwZg50JYcxYplBQGbU6H0Jjsn87EwVM=;
        b=TwdQvW6rKkua5NJ50ROsaIEeGd9TFBYa9oiQmFy/7T+0cUl65SvZH0jQ1FreXeD2bn
         6QikTAKuXFfUlNKCjD67g4Lbp65BTUkj+9kQabCGQSyu1EM7Bw3fTr0/v9wVWUqnzbEa
         P/Qz4PVTFz52jbLiNwLoPDeJ9HW7IsqIror4nzKll1SdWymNO+fga9QbTpVV9ddxLVzy
         BZ6SPQUvNkiOP/s/fjIIC8Rics92FQvoc6qZC+sWx8mZkxipVix2XYdkuvNXo9SBurlL
         2CbeT7y1YZV71tORtkXTtGwbMSmPz3eDXophJbfPzx/zezY/bYrTT11/LiIeeW10u4Nl
         F16Q==
X-Gm-Message-State: ANhLgQ0Vv4Cqc4b0aSwfKBj2+jxF1jRSwir4X1SU5suWPE0Avnx/p2OG
        5CzDHNUWqAjg52xub6M2b71awXRR4m5jwXzb7mOEDIU7QefwMJXbBwHehB4xGHhudjjLzkJOyo6
        rD9TxFpp9lNWUH9Ar
X-Received: by 2002:a1c:f001:: with SMTP id a1mr4127240wmb.76.1583939798881;
        Wed, 11 Mar 2020 08:16:38 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vtvY56c4GlBVRUX2Mrj3ptywgLr6hWb0bgX5x0BSLPyvQt3Lo3lCfTay/PQFuNZksMxQ1DNVw==
X-Received: by 2002:a1c:f001:: with SMTP id a1mr4127215wmb.76.1583939798598;
        Wed, 11 Mar 2020 08:16:38 -0700 (PDT)
Received: from pc-3.home (2a01cb0585138800b113760e11343d15.ipv6.abo.wanadoo.fr. [2a01:cb05:8513:8800:b113:760e:1134:3d15])
        by smtp.gmail.com with ESMTPSA id z6sm2006437wrp.95.2020.03.11.08.16.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 08:16:37 -0700 (PDT)
Date:   Wed, 11 Mar 2020 16:16:36 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH iproute2] iproute2: fix MPLS label parsing
Message-ID: <13e1c79da12f9c08739e1ba94361d203e2a6627d.1583939416.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The initial value of "label" in parse_mpls() is 0xffffffff. Therefore
we should test for this value, and not 0, to detect if a label has been
provided. The "!label" test not only fails to detect a missing label
parameter, it also prevents the use of the IPv4 explicit NULL label,
which actually equals 0.

Reproducer:
  $ ip link add name dm0 type dummy
  $ tc qdisc add dev dm0 ingress

  $ tc filter add dev dm0 parent ffff: matchall action mpls push
  Error: act_mpls: Label is required for MPLS push.
  We have an error talking to the kernel
  --> Filter was pushed to the kernel, where it got rejected.

  $ tc filter add dev dm0 parent ffff: matchall action mpls push label 0
  Error: argument "label" is required
  --> Label 0 was rejected by iproute2.

Expected result:
  $ tc filter add dev dm0 parent ffff: matchall action mpls push
  Error: argument "label" is required
  --> Filter was directly rejected by iproute2.

  $ tc filter add dev dm0 parent ffff: matchall action mpls push label 0
  --> Filter is accepted.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 tc/m_mpls.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tc/m_mpls.c b/tc/m_mpls.c
index 6f3a39f4..50eba01c 100644
--- a/tc/m_mpls.c
+++ b/tc/m_mpls.c
@@ -156,7 +156,7 @@ static int parse_mpls(struct action_util *a, int *argc_p, char ***argv_p,
 		}
 	}
 
-	if (action == TCA_MPLS_ACT_PUSH && !label)
+	if (action == TCA_MPLS_ACT_PUSH && label == 0xffffffff)
 		missarg("label");
 
 	if (action == TCA_MPLS_ACT_PUSH && proto &&
-- 
2.21.1

