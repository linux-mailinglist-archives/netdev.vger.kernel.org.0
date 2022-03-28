Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8424E8D89
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 07:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238116AbiC1Fng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 01:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231955AbiC1Fnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 01:43:33 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A83A3122A
        for <netdev@vger.kernel.org>; Sun, 27 Mar 2022 22:41:54 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id q19so11423423pgm.6
        for <netdev@vger.kernel.org>; Sun, 27 Mar 2022 22:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y8kAp00QLV7xO8m2VG6MkDSs9FsqMJapRolUTt2Mc0U=;
        b=oLc6cy6N8Ye/+bbKML/AmUJCSjJIz8++r6t53T/Lk/BsnCvY565Wmdk3jPOkSoSJyj
         uRJxzFfeM6XjEEM0hQ20N8BUERNNzLzVuh/eO0oHX8cADV7yas1dcaWakWNQ+bmY1win
         gfo0kV6dusfC79bBmewjHt/ZBnB/cBol24/Wbao12sfedpBAqzF2INSry+a2pMHK1+Mt
         nB1bL3X2Xf6UcewlZn7MVJ2I3yjQETPoLqzxU1c0C3QQhSAG0tEs0alzOuFKZrKWXABN
         hCh7YbtKJiejkBU35SPPRocpSsNbW+Zpvgx6Xk84haE/H2hG9lUGUq0K1wAKM6hY0J2g
         kimg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Y8kAp00QLV7xO8m2VG6MkDSs9FsqMJapRolUTt2Mc0U=;
        b=nS0Nfxyyu/OxeqCyR2cVXppAyATWN5Tmx1cnS/DTui3rAruX9szBioJ6/9biTsdOhU
         FvurHtZuULEDd3OBvOxr/ueiLs+dPC8Bgycnw5shjFKBj68OLKeHcbL1maBh98lacM2C
         2FOjh35hIIwY8iknUQsSnCTMkY3GSMYoZBBJ/YwaO93DvOGmL7AISxgKVP8fkNcdBlwh
         UpKiTf1ABtwFp95a5mEGC/S84g40Lb6OlRPfw+PaRQLG66fIDsUjHXFD1V5APoat+whK
         hKj7W6MdpS7ZXt4WYuwWxDcrn1aTWUDI7e2I+bClGHPRog6vNoI43zt/T6asL7vaFlVo
         QkSw==
X-Gm-Message-State: AOAM532xYGcbHk9TizS6wQ3XhkqWxINgzjDt88A6wwbZ1IKgST6BFkP/
        odUXJTU0GWxAi7cYn5rjPXYqufGoRXVpkA==
X-Google-Smtp-Source: ABdhPJyhbLaHc17cyvtAE31t6ESoLNQAgMo+KogYfUHyeUDWRtxuvzUcCepJkrOkYTEHNW4EkOHJkg==
X-Received: by 2002:a63:7945:0:b0:398:19c4:14d3 with SMTP id u66-20020a637945000000b0039819c414d3mr8116287pgc.20.1648446113683;
        Sun, 27 Mar 2022 22:41:53 -0700 (PDT)
Received: from martin-ubuntu ([136.185.150.175])
        by smtp.gmail.com with ESMTPSA id i9-20020a17090a2a0900b001c6e540fb6asm13430851pjd.13.2022.03.27.22.41.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 27 Mar 2022 22:41:53 -0700 (PDT)
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     pshelar@ovn.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Cc:     Martin Varghese <martin.varghese@nokia.com>
Subject: [PATCH net] openvswitch: Fixed nd target mask field in the flow dump.
Date:   Mon, 28 Mar 2022 11:11:48 +0530
Message-Id: <20220328054148.3057-1-martinvarghesenokia@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Varghese <martin.varghese@nokia.com>

IPv6 nd target mask was not getting populated in flow dump.

In the function __ovs_nla_put_key the icmp code mask field was checked
instead of icmp code key field to classify the flow as neighbour discovery.

ufid:bdfbe3e5-60c2-43b0-a5ff-dfcac1c37328, recirc_id(0),dp_hash(0/0),
skb_priority(0/0),in_port(ovs-nm1),skb_mark(0/0),ct_state(0/0),
ct_zone(0/0),ct_mark(0/0),ct_label(0/0),
eth(src=00:00:00:00:00:00/00:00:00:00:00:00,
dst=00:00:00:00:00:00/00:00:00:00:00:00),
eth_type(0x86dd),
ipv6(src=::/::,dst=::/::,label=0/0,proto=58,tclass=0/0,hlimit=0/0,frag=no),
icmpv6(type=135,code=0),
nd(target=2001::2/::,
sll=00:00:00:00:00:00/00:00:00:00:00:00,
tll=00:00:00:00:00:00/00:00:00:00:00:00),
packets:10, bytes:860, used:0.504s, dp:ovs, actions:ovs-nm2

Fixes: e64457191a25 (openvswitch: Restructure datapath.c and flow.c)
Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
---
 net/openvswitch/flow_netlink.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/openvswitch/flow_netlink.c b/net/openvswitch/flow_netlink.c
index fd1f809e9bc1..0d677c9c2c80 100644
--- a/net/openvswitch/flow_netlink.c
+++ b/net/openvswitch/flow_netlink.c
@@ -2201,8 +2201,8 @@ static int __ovs_nla_put_key(const struct sw_flow_key *swkey,
 			icmpv6_key->icmpv6_type = ntohs(output->tp.src);
 			icmpv6_key->icmpv6_code = ntohs(output->tp.dst);
 
-			if (icmpv6_key->icmpv6_type == NDISC_NEIGHBOUR_SOLICITATION ||
-			    icmpv6_key->icmpv6_type == NDISC_NEIGHBOUR_ADVERTISEMENT) {
+			if (swkey->tp.src == htons(NDISC_NEIGHBOUR_SOLICITATION) ||
+			    swkey->tp.src == htons(NDISC_NEIGHBOUR_ADVERTISEMENT)) {
 				struct ovs_key_nd *nd_key;
 
 				nla = nla_reserve(skb, OVS_KEY_ATTR_ND, sizeof(*nd_key));
-- 
2.18.2

