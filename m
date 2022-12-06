Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B29A644FA2
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 00:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbiLFXbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 18:31:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbiLFXbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 18:31:25 -0500
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A34343867
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 15:31:25 -0800 (PST)
Received: by mail-qk1-x733.google.com with SMTP id k3so2447450qki.13
        for <netdev@vger.kernel.org>; Tue, 06 Dec 2022 15:31:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BCSUkUl3qtx2Ug0vdO9kQ6Q3WtijYxxWczDbAdumJqo=;
        b=dy8muhU+bxTzpENQbLD3W/1GFMRViQLHLZYwqzrU0UMTncgGVKdFGKSibU3U5srfgF
         0cNfrhOXVYsLWx5M8jwa+AhAyt2kP1gmAxQo7yWEmeGVBTd6GOBrx2RqzznFmNv36cVV
         YwTFZuFZoEFaMYNKtIkf+UxpoZdnjod+qhbc4P0Qq/ffibT63Z7h0gDKeilDQDi7xa4s
         h+JL7eXrgQtPwbsbcsdrGKizij9Hyd5qnJ5EMbeD2Ech2bJYu8+zfjJs0roIrm/rcq0n
         0NQSkOjI2ovqP0tpt0mU2U2e1CcrFP8bTE+2KOYDaE1WCq272ycoIXX8p5/me85Vvp/L
         OGrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BCSUkUl3qtx2Ug0vdO9kQ6Q3WtijYxxWczDbAdumJqo=;
        b=EvOoiApfM6JNT3s+PhU5JyLypYHCDL916rMd4SlxQ1xn829+hh4AgELeoaPctZz7jX
         jcp24gTfW3+ZOtmN+8mar051Z8yLTglgfwZ4UljWj3CIDeNny0wXdctu38Je6FaQYadE
         ct9mOLWUPXkHwRst0t4hDQNMxn2If0KBpmEAMHGBqIE55/QthYVBbWU2UJ0L5x9lXIev
         MUcCjcTnMvNUGM5bvld9ZwfIDTcyELy2ONNHLIYrm4tblznxZLFbcX2Ebx8ZfjfvmKXd
         18BZulYe400ya2eAwpVigeG36tT2QvMZ2I5jtz0oIHSGX2hJ8ZkUP5tF0NxettIoVAew
         835w==
X-Gm-Message-State: ANoB5pm1D/FJ9ssIKvh5o7V5VJAI3zU+3t8WnkRsDhtgi+K9MtElUcva
        aJS/eREpXlozs5scnRbRfeWqb+eSC+4Kww==
X-Google-Smtp-Source: AA0mqf7GyUjfJpUAGWWT3ETtTvQ1+imiBjxZOEGx13Zg2kHgQ5TvGxExpfxC6cXDPwUpU+QDIi1Kdg==
X-Received: by 2002:ae9:e892:0:b0:6fe:e5da:6029 with SMTP id a140-20020ae9e892000000b006fee5da6029mr618898qkg.188.1670369483888;
        Tue, 06 Dec 2022 15:31:23 -0800 (PST)
Received: from wsfd-netdev15.ntdv.lab.eng.bos.redhat.com (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id i21-20020a05620a405500b006f8665f483fsm16590231qko.85.2022.12.06.15.31.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 15:31:23 -0800 (PST)
From:   Xin Long <lucien.xin@gmail.com>
To:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Oz Shlomo <ozsh@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Eelco Chaudron <echaudro@redhat.com>,
        Aaron Conole <aconole@redhat.com>,
        Saeed Mahameed <saeed@kernel.org>
Subject: [PATCHv3 net-next 4/5] net: sched: update the nat flag for icmp error packets in ct_nat_execute
Date:   Tue,  6 Dec 2022 18:31:15 -0500
Message-Id: <f9122772cc6a1d5ead2a297bdf75287d3bcd27df.1670369327.git.lucien.xin@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1670369327.git.lucien.xin@gmail.com>
References: <cover.1670369327.git.lucien.xin@gmail.com>
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

In ovs_ct_nat_execute(), the packet flow key nat flags are updated
when it processes ICMP(v6) error packets translation successfully.

In ct_nat_execute() when processing ICMP(v6) error packets translation
successfully, it should have done the same in ct_nat_execute() to set
post_ct_s/dnat flag, which will be used to update flow key nat flags
in OVS module later.

Reviewed-by: Saeed Mahameed <saeed@kernel.org>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
---
 net/sched/act_ct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index dd5ae7551956..bb87d1e910ea 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -936,13 +936,13 @@ static int ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,
 	}
 
 	err = nf_nat_packet(ct, ctinfo, hooknum, skb);
+out:
 	if (err == NF_ACCEPT) {
 		if (maniptype == NF_NAT_MANIP_SRC)
 			tc_skb_cb(skb)->post_ct_snat = 1;
 		if (maniptype == NF_NAT_MANIP_DST)
 			tc_skb_cb(skb)->post_ct_dnat = 1;
 	}
-out:
 	return err;
 }
 #endif /* CONFIG_NF_NAT */
-- 
2.31.1

