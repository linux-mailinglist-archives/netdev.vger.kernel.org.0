Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 558CE18FFC9
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 21:48:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgCWUs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 16:48:56 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:60942 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727101AbgCWUsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 16:48:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584996534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=J8GBJrmynL3sFQZ6PZZq1e3DQg4qaD9hya+bPOkskNo=;
        b=XHi30JCR1olo3wRB6heWUkO4bLqSQl2cgnOnZR4LsyxWJe2+UpSbmtSAWDKLkXzXjnoR/Y
        U+6WlIlzGvx3RC+OO2wr/SvzLt30BLqkkbIprsz7LhGlPxuMHm8aquXjk9zvlw6oGyqF8S
        781AcvTt+L0JI33O80PorghYL5JJ10M=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-375-VMwzAXnUNjKyU8a0S2ppoA-1; Mon, 23 Mar 2020 16:48:53 -0400
X-MC-Unique: VMwzAXnUNjKyU8a0S2ppoA-1
Received: by mail-wm1-f72.google.com with SMTP id m4so504037wme.0
        for <netdev@vger.kernel.org>; Mon, 23 Mar 2020 13:48:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=J8GBJrmynL3sFQZ6PZZq1e3DQg4qaD9hya+bPOkskNo=;
        b=rm9irV4/7AmBzCeXxm8LWKQvDzbr1mGAjkO9moNGly7TUeT1lpowNl5QbzlJtNDPCi
         pubYp7HPqVFBhk6cRXu52SgyILIuekcllfDnRQNRw/6it+6DiBzLpcAD9Twn7falcYk5
         72SYM7k6mKu0UYewVZEBcLcKVKTQechd/Xj+Rkve4IIAlcPGMHtAFGIsQpN2JLcccrSJ
         JtpfIE/wTrs+PWPSJNakH2ldNWwn1ivKLDsfZZRaHM4Pvq+0Fb+aMU7Z/a6fH5PNzKyn
         lRm5jLlR5UnBwm2d2FCOrFcwntMwpLz+hAFHV0QXgBMgX5NZ1U00LWQQnM+9hdUMQBcp
         YkPQ==
X-Gm-Message-State: ANhLgQ0+nr66bToM3bmf/ZFmc8er0yNIfVFan0N/omjbZsbFS+WCwMzZ
        8qoC7Pio28z9NRz1ZloG3y9CMNhvGv2Ep8BnAed4Jp64eTtV87aC5Fcphl6h5Av++qKeCG5PL8R
        JDT9xJVDb9VW+p7iw
X-Received: by 2002:adf:8b1b:: with SMTP id n27mr31840002wra.349.1584996531928;
        Mon, 23 Mar 2020 13:48:51 -0700 (PDT)
X-Google-Smtp-Source: ADFU+vuFi2m1LfcaXUrU/gldwuT2pBbK8k4lrH0v3ay125V26Ga92TUppZgLp5VtX5U2EDCmObrT1g==
X-Received: by 2002:adf:8b1b:: with SMTP id n27mr31839991wra.349.1584996531771;
        Mon, 23 Mar 2020 13:48:51 -0700 (PDT)
Received: from pc-3.home (2a01cb0585138800b113760e11343d15.ipv6.abo.wanadoo.fr. [2a01:cb05:8513:8800:b113:760e:1134:3d15])
        by smtp.gmail.com with ESMTPSA id g127sm1100342wmf.10.2020.03.23.13.48.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Mar 2020 13:48:51 -0700 (PDT)
Date:   Mon, 23 Mar 2020 21:48:49 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: [PATCH net-next 2/4] cls_flower: Add extack support for mpls options
Message-ID: <6a3a85b072832c1f8d83f3a4aba759f5f3a8777d.1584995986.git.gnault@redhat.com>
References: <cover.1584995986.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1584995986.git.gnault@redhat.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pass extack down to fl_set_key_mpls() and set message on error.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 net/sched/cls_flower.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/net/sched/cls_flower.c b/net/sched/cls_flower.c
index 258dc45ab7e3..544cc7b490a3 100644
--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -766,7 +766,8 @@ static int fl_set_key_port_range(struct nlattr **tb, struct fl_flow_key *key,
 
 static int fl_set_key_mpls(struct nlattr **tb,
 			   struct flow_dissector_key_mpls *key_val,
-			   struct flow_dissector_key_mpls *key_mask)
+			   struct flow_dissector_key_mpls *key_mask,
+			   struct netlink_ext_ack *extack)
 {
 	if (tb[TCA_FLOWER_KEY_MPLS_TTL]) {
 		key_val->mpls_ttl = nla_get_u8(tb[TCA_FLOWER_KEY_MPLS_TTL]);
@@ -775,24 +776,36 @@ static int fl_set_key_mpls(struct nlattr **tb,
 	if (tb[TCA_FLOWER_KEY_MPLS_BOS]) {
 		u8 bos = nla_get_u8(tb[TCA_FLOWER_KEY_MPLS_BOS]);
 
-		if (bos & ~MPLS_BOS_MASK)
+		if (bos & ~MPLS_BOS_MASK) {
+			NL_SET_ERR_MSG_ATTR(extack,
+					    tb[TCA_FLOWER_KEY_MPLS_BOS],
+					    "Bottom Of Stack (BOS) must be 0 or 1");
 			return -EINVAL;
+		}
 		key_val->mpls_bos = bos;
 		key_mask->mpls_bos = MPLS_BOS_MASK;
 	}
 	if (tb[TCA_FLOWER_KEY_MPLS_TC]) {
 		u8 tc = nla_get_u8(tb[TCA_FLOWER_KEY_MPLS_TC]);
 
-		if (tc & ~MPLS_TC_MASK)
+		if (tc & ~MPLS_TC_MASK) {
+			NL_SET_ERR_MSG_ATTR(extack,
+					    tb[TCA_FLOWER_KEY_MPLS_TC],
+					    "Traffic Class (TC) must be between 0 and 7");
 			return -EINVAL;
+		}
 		key_val->mpls_tc = tc;
 		key_mask->mpls_tc = MPLS_TC_MASK;
 	}
 	if (tb[TCA_FLOWER_KEY_MPLS_LABEL]) {
 		u32 label = nla_get_u32(tb[TCA_FLOWER_KEY_MPLS_LABEL]);
 
-		if (label & ~MPLS_LABEL_MASK)
+		if (label & ~MPLS_LABEL_MASK) {
+			NL_SET_ERR_MSG_ATTR(extack,
+					    tb[TCA_FLOWER_KEY_MPLS_LABEL],
+					    "Label must be between 0 and 1048575");
 			return -EINVAL;
+		}
 		key_val->mpls_label = label;
 		key_mask->mpls_label = MPLS_LABEL_MASK;
 	}
@@ -1364,7 +1377,7 @@ static int fl_set_key(struct net *net, struct nlattr **tb,
 			       sizeof(key->icmp.code));
 	} else if (key->basic.n_proto == htons(ETH_P_MPLS_UC) ||
 		   key->basic.n_proto == htons(ETH_P_MPLS_MC)) {
-		ret = fl_set_key_mpls(tb, &key->mpls, &mask->mpls);
+		ret = fl_set_key_mpls(tb, &key->mpls, &mask->mpls, extack);
 		if (ret)
 			return ret;
 	} else if (key->basic.n_proto == htons(ETH_P_ARP) ||
-- 
2.21.1

