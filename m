Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F724591FA0
	for <lists+netdev@lfdr.de>; Sun, 14 Aug 2022 13:28:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbiHNL2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Aug 2022 07:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiHNL2M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Aug 2022 07:28:12 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF8E820BF5
        for <netdev@vger.kernel.org>; Sun, 14 Aug 2022 04:28:11 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id d1so3731296qvs.0
        for <netdev@vger.kernel.org>; Sun, 14 Aug 2022 04:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=jgSpr/OWE3HldXbKhd9zqtDt4AkKNg24We7/vDrM14k=;
        b=dn+UymxdVD8DJ1nX1cX+3YYfFNl5uVkEgDLfsRWEgTruhuEmSU3JG6e+NSwkFH/2y7
         KrpyqdrQRImpimsWplWBJzTf78xoca1FUr7HVYUY6zQoQhlDEnKwyresIcEYWfycq6f4
         JaEaG64+asTxU4FS9l2Q4blgyaV69nolVHogjlCsFhHfVUf9c8uk5w4yLz3YCsPACW9x
         cAHL83xJMLQSZvKx7KuPpRKLYHm2SrPWHTt2u55b9QK72c+wgZNeiQEWnBL0e1+0Anty
         vW6smy9AVCm1lOxtln6vQ5pfd8y23TJnXOdySrpRnZm0HmpoHnvcp9D+tD+qLZVVzM95
         1dNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=jgSpr/OWE3HldXbKhd9zqtDt4AkKNg24We7/vDrM14k=;
        b=w7+LPLoj9rH4Y81pVJDYpxdQ8Mog2RBz27f9V0ompAeXlGyOo/6Axc8Ey9HWayfKuR
         o1P9SU2646RNLBztIeiXhLaNkg13kHm02TCJ06o2gbHyVM5jp4WsZyfx/EMpc8fkkG1B
         QpK0eIZMyHxbRZ2IQfEXVBemd9gNljWLDLvCPP6GT5Ro6DEo546+Ub3cnn7Omc5c8QGN
         5q1EPrqHCS2zrvaMkjGJIfIF6+PAQInl5MMJMQTKe7VhHwy8hiC1GHafopKPnowHkimx
         +P3j2IE566nWqc13y5lP1ElgABWS63fibAiexch6cbBheR1goY66RKzS0/XvkGH06gjD
         DQZg==
X-Gm-Message-State: ACgBeo2S2W+mTBXigNhGj6G6XJjqJdTSw+7cp6Rpilhd1jcN1Ksf1u05
        oKsEV7tnZ3+rp/VXByfNBsFetg==
X-Google-Smtp-Source: AA6agR7PRa0f3y4QZ+m99GB2+U1wkEC4RKPC0CFsety+4LJE8zDC4pjo86l0cE6n5MyHrt6IcP3geQ==
X-Received: by 2002:a05:6214:5287:b0:476:7938:5b76 with SMTP id kj7-20020a056214528700b0047679385b76mr9974780qvb.131.1660476490753;
        Sun, 14 Aug 2022 04:28:10 -0700 (PDT)
Received: from localhost.localdomain (bras-base-kntaon1617w-grc-28-184-148-47-103.dsl.bell.ca. [184.148.47.103])
        by smtp.gmail.com with ESMTPSA id r23-20020ae9d617000000b006af1f0af045sm6279599qkk.107.2022.08.14.04.28.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Aug 2022 04:28:10 -0700 (PDT)
From:   Jamal Hadi Salim <jhs@mojatatu.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        kuznet@ms2.inr.ac.ru, cascardo@canonical.com,
        linux-distros@vs.openwall.org, security@kernel.org,
        stephen@networkplumber.org, dsahern@gmail.com,
        gregkh@linuxfoundation.org, Jamal Hadi Salim <jhs@mojatatu.com>
Subject: [PATCH net 1/1] net_sched: cls_route: disallow handle of 0
Date:   Sun, 14 Aug 2022 11:27:58 +0000
Message-Id: <20220814112758.3088655-1-jhs@mojatatu.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Follows up on:
https://lore.kernel.org/all/20220809170518.164662-1-cascardo@canonical.com/

handle of 0 implies from/to of universe realm which is not very
sensible.

Lets see what this patch will do:
$sudo tc qdisc add dev $DEV root handle 1:0 prio

//lets manufacture a way to insert handle of 0
$sudo tc filter add dev $DEV parent 1:0 protocol ip prio 100 \
route to 0 from 0 classid 1:10 action ok

//gets rejected...
Error: handle of 0 is not valid.
We have an error talking to the kernel, -1

//lets create a legit entry..
sudo tc filter add dev $DEV parent 1:0 protocol ip prio 100 route from 10 \
classid 1:10 action ok

//what did the kernel insert?
$sudo tc filter ls dev $DEV parent 1:0
filter protocol ip pref 100 route chain 0
filter protocol ip pref 100 route chain 0 fh 0x000a8000 flowid 1:10 from 10
	action order 1: gact action pass
	 random type none pass val 0
	 index 1 ref 1 bind 1

//Lets try to replace that legit entry with a handle of 0
$ sudo tc filter replace dev $DEV parent 1:0 protocol ip prio 100 \
handle 0x000a8000 route to 0 from 0 classid 1:10 action drop

Error: Replacing with handle of 0 is invalid.
We have an error talking to the kernel, -1

And last, lets run Cascardo's POC:
$ ./poc
0
0
-22
-22
-22

Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
---
 net/sched/cls_route.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/net/sched/cls_route.c b/net/sched/cls_route.c
index 3f935cbbaff6..48712bc51bda 100644
--- a/net/sched/cls_route.c
+++ b/net/sched/cls_route.c
@@ -424,6 +424,11 @@ static int route4_set_parms(struct net *net, struct tcf_proto *tp,
 			return -EINVAL;
 	}
 
+	if (!nhandle) {
+		NL_SET_ERR_MSG(extack, "Replacing with handle of 0 is invalid");
+		return -EINVAL;
+	}
+
 	h1 = to_hash(nhandle);
 	b = rtnl_dereference(head->table[h1]);
 	if (!b) {
@@ -477,6 +482,11 @@ static int route4_change(struct net *net, struct sk_buff *in_skb,
 	int err;
 	bool new = true;
 
+	if (!handle) {
+		NL_SET_ERR_MSG(extack, "Creating with handle of 0 is invalid");
+		return -EINVAL;
+	}
+
 	if (opt == NULL)
 		return handle ? -EINVAL : 0;
 
-- 
2.25.1

