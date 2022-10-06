Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15F195F6E5F
	for <lists+netdev@lfdr.de>; Thu,  6 Oct 2022 21:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232066AbiJFTpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Oct 2022 15:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232064AbiJFTpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Oct 2022 15:45:09 -0400
Received: from mail-oo1-xc2d.google.com (mail-oo1-xc2d.google.com [IPv6:2607:f8b0:4864:20::c2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1845E631D2
        for <netdev@vger.kernel.org>; Thu,  6 Oct 2022 12:45:05 -0700 (PDT)
Received: by mail-oo1-xc2d.google.com with SMTP id g2-20020a4ac4c2000000b0047f703cbe86so2115817ooq.11
        for <netdev@vger.kernel.org>; Thu, 06 Oct 2022 12:45:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=WLUQ2JGMqg3BdFqb+XQqktb1lIsmM6IFAtGL/ZM2SE4=;
        b=hsOn4pQSg1M10idasFSHzM512sETL94YUJZwtpM2OqSM4rqosoFqYfx8CiLJh+xc93
         m2Hr86F65OPDIcyNYvoahV/AK8FKhMj82EGzSIYryhVOiCb4Kvs1rH0T6rrmQkk6HZ9j
         EABIivfUxK1PsejaY7aaxvu8QWVpvieNTwL61kBeuuU8o7Pt0jXXVgBlORO74zYFgdbU
         5HNoBV4j5ZFRy1A1IqV2SKGCi5ExkeM7q3sFXrMN1BRNVdYGMkxYJfTysoPpE7Gne82/
         KzL/ZhN5Yzrqvma30AAR/axSTTgkjiOZercT6ZpLhqYlM1/nG8M1jL3DRtOBr3Q/f8R5
         FUCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WLUQ2JGMqg3BdFqb+XQqktb1lIsmM6IFAtGL/ZM2SE4=;
        b=npMbykalVJ3KuoZypBGIwLhs0izP25AuIkgCsabrW6QUyb/iYjdmDWadRRxY816s4y
         z95HMDeCASDWPVG3G3x3ZMFVDY8YE48P6bbOYSk5ItzPVrh9FcDehL7LI/nEwJLAyFrq
         ytjaPsMs7N8n7HhYk84eW1499loNIEkJJ+ehw2yiOcL1PvRoJ5fo+vpnGupJ0joWWMVJ
         HNUfkgOX56+biBR6XlcxEmGSDMWtKRmCDg+jD+h0yFyQZYPLSNS4B//qNQ84iRe8Ik7T
         KLP0upxl8YWHH+SfCnGdBLQpKQkW6k48zbeq4jZ9S8d5GJ2p6kcVGuby9vGT3g9rnUtb
         KTxw==
X-Gm-Message-State: ACrzQf3cPh/5y05bV2c/lZA4T3knL9r1S9lhhcIJO/HYPm43oqTcSbF5
        6/2N8E++7/ZKpI+Y5w2V0gxEAMH9LZlYZw==
X-Google-Smtp-Source: AMsMyM617KuiHqT6jSi8KXe1aYZ6ZE3uE6FcONrUsjPjwp8BqiyGr/oe4fOW7MZPBZmHgEBMTew+kA==
X-Received: by 2002:a4a:1d84:0:b0:47f:992f:f416 with SMTP id 126-20020a4a1d84000000b0047f992ff416mr508852oog.24.1665085504413;
        Thu, 06 Oct 2022 12:45:04 -0700 (PDT)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id c12-20020a9d784c000000b00655bc32a413sm207602otm.42.2022.10.06.12.45.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Oct 2022 12:45:03 -0700 (PDT)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Ilya Maximets <i.maximets@ovn.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Yi-Hung Wei <yihung.wei@gmail.com>
Subject: [PATCH net] openvswitch: add nf_ct_is_confirmed check before assigning the helper
Date:   Thu,  6 Oct 2022 15:45:02 -0400
Message-Id: <c5c9092a22a2194650222bffaf786902613deb16.1665085502.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A WARN_ON call trace would be triggered when 'ct(commit, alg=helper)'
applies on a confirmed connection:

  WARNING: CPU: 0 PID: 1251 at net/netfilter/nf_conntrack_extend.c:98
  RIP: 0010:nf_ct_ext_add+0x12d/0x150 [nf_conntrack]
  Call Trace:
   <TASK>
   nf_ct_helper_ext_add+0x12/0x60 [nf_conntrack]
   __nf_ct_try_assign_helper+0xc4/0x160 [nf_conntrack]
   __ovs_ct_lookup+0x72e/0x780 [openvswitch]
   ovs_ct_execute+0x1d8/0x920 [openvswitch]
   do_execute_actions+0x4e6/0xb60 [openvswitch]
   ovs_execute_actions+0x60/0x140 [openvswitch]
   ovs_packet_cmd_execute+0x2ad/0x310 [openvswitch]
   genl_family_rcv_msg_doit.isra.15+0x113/0x150
   genl_rcv_msg+0xef/0x1f0

which can be reproduced with these OVS flows:

  table=0, in_port=veth1,tcp,tcp_dst=2121,ct_state=-trk
  actions=ct(commit, table=1)
  table=1, in_port=veth1,tcp,tcp_dst=2121,ct_state=+trk+new
  actions=ct(commit, alg=ftp),normal

The issue was introduced by commit 248d45f1e193 ("openvswitch: Allow
attaching helper in later commit") where it somehow removed the check
of nf_ct_is_confirmed before asigning the helper. This patch is to fix
it by bringing it back.

Fixes: 248d45f1e193 ("openvswitch: Allow attaching helper in later commit")
Reported-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/openvswitch/conntrack.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index 4e70df91d0f2..6862475f0f88 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -1015,7 +1015,8 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
 		 * connections which we will commit, we may need to attach
 		 * the helper here.
 		 */
-		if (info->commit && info->helper && !nfct_help(ct)) {
+		if (!nf_ct_is_confirmed(ct) && info->commit &&
+		    info->helper && !nfct_help(ct)) {
 			int err = __nf_ct_try_assign_helper(ct, info->ct,
 							    GFP_ATOMIC);
 			if (err)
-- 
2.31.1

