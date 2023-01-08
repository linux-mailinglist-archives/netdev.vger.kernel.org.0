Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB2A766164A
	for <lists+netdev@lfdr.de>; Sun,  8 Jan 2023 16:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232699AbjAHPqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Jan 2023 10:46:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231551AbjAHPqk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Jan 2023 10:46:40 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E94FD15
        for <netdev@vger.kernel.org>; Sun,  8 Jan 2023 07:45:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673192747;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/njgGAVUPtXskzk1vLp20oMLbjhp3j4lH68KrNnwBwM=;
        b=a3MPBrpgvYrkl6d8DVZosiG1s5kGeSfiglquozlpt6lnuEre6jPkM9SXVj2/KiE9Fq2zPq
        ahI514v+SR/OJFJtOJr581AXBSMdntZm26mGtClOCOMgzRRyyXYTc5UKHQIrpxw8TC4BDY
        N7n8/CakdY3uAkH3bbEHBQBY9SNOy4A=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-348-w_Cq_kWpNAC4_t9a4Kc50g-1; Sun, 08 Jan 2023 10:45:46 -0500
X-MC-Unique: w_Cq_kWpNAC4_t9a4Kc50g-1
Received: by mail-qk1-f199.google.com with SMTP id l16-20020a05620a28d000b00704af700820so4797794qkp.5
        for <netdev@vger.kernel.org>; Sun, 08 Jan 2023 07:45:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/njgGAVUPtXskzk1vLp20oMLbjhp3j4lH68KrNnwBwM=;
        b=slhA07FcuxHP5t+Yc7/hciZDPlbnliYPS/oDNPE4DAPN93tISFc2enP6HAuxPPMPgA
         iXupDr8XOaHWcF8vqZMUY7wgzwm6gmwmD52qSmFGGAD/SZS3oZQ4iBY67FA/R7b0SAIO
         cU7YhOkQ8LSWp8fiarR90x+RVnZ7sob40W5KZRHvWdhjTi9sGwu7nin5YUsklybOHCbx
         dQuTvzGlyEauMqnzAGKDe+9kEYQoGnw4uT95+gcqDDfUbk+R6WzCsevAszVB6C8K573Q
         69cExp3DMqOSUq4iiu4xNk11UxtyHLCwV0EPhQmGDwOp2lGVhKMuEFbMFOacPCg+Sv53
         ky4Q==
X-Gm-Message-State: AFqh2krfOMjotQO0ahmV9CgONYbsSugSLaBs/O1F8QcTd9oGkd5uTcQS
        FeiZs1U+Q01GuZXYrThKuYHlFQUx1CZnkF2LWywA3pb7qYv0keUlvvafQb+jyYRFc34njgmZW4a
        DpBlHfjE8gV3rpGww
X-Received: by 2002:a05:622a:4205:b0:3a5:3cb5:2485 with SMTP id cp5-20020a05622a420500b003a53cb52485mr84046994qtb.0.1673192745856;
        Sun, 08 Jan 2023 07:45:45 -0800 (PST)
X-Google-Smtp-Source: AMrXdXuv3RaKjIAXyDmemvxrKDMHR6xY19k16gFK4eI7Ku+wXBfLOlr7Kg8h3uL3/4j8pVvZ0zSyLA==
X-Received: by 2002:a05:622a:4205:b0:3a5:3cb5:2485 with SMTP id cp5-20020a05622a420500b003a53cb52485mr84046980qtb.0.1673192745636;
        Sun, 08 Jan 2023 07:45:45 -0800 (PST)
Received: from debian (2a01cb058918ce0098fed9113971adae.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:98fe:d911:3971:adae])
        by smtp.gmail.com with ESMTPSA id fz18-20020a05622a5a9200b003a591194221sm3385902qtb.7.2023.01.08.07.45.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Jan 2023 07:45:45 -0800 (PST)
Date:   Sun, 8 Jan 2023 16:45:41 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        Matthias May <matthias.may@westermo.com>,
        linux-kselftest@vger.kernel.org,
        Mirsad Goran Todorovac <mirsad.todorovac@alu.unizg.hr>
Subject: [PATCH net 1/3] selftests/net: l2_tos_ttl_inherit.sh: Set IPv6
 addresses with "nodad".
Message-ID: <1c40c3a46ec30731d45fbc7b33d71e8c711e310a.1673191942.git.gnault@redhat.com>
References: <cover.1673191942.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1673191942.git.gnault@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ping command can run before DAD completes. In that case, ping may
fail and break the selftest.

We don't need DAD here since we're working on isolated device pairs.

Fixes: b690842d12fd ("selftests/net: test l2 tunnel TOS/TTL inheriting")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 tools/testing/selftests/net/l2_tos_ttl_inherit.sh | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/net/l2_tos_ttl_inherit.sh b/tools/testing/selftests/net/l2_tos_ttl_inherit.sh
index dca1e6f777a8..e2574b08eabc 100755
--- a/tools/testing/selftests/net/l2_tos_ttl_inherit.sh
+++ b/tools/testing/selftests/net/l2_tos_ttl_inherit.sh
@@ -137,8 +137,8 @@ setup() {
 		if [ "$type" = "gre" ]; then
 			type="ip6gretap"
 		fi
-		ip addr add fdd1:ced0:5d88:3fce::1/64 dev veth0
-		$ns ip addr add fdd1:ced0:5d88:3fce::2/64 dev veth1
+		ip addr add fdd1:ced0:5d88:3fce::1/64 dev veth0 nodad
+		$ns ip addr add fdd1:ced0:5d88:3fce::2/64 dev veth1 nodad
 		ip link add name tep0 type $type $local_addr1 \
 		remote fdd1:ced0:5d88:3fce::2 tos $test_tos ttl $test_ttl \
 		$vxlan $geneve
@@ -170,8 +170,8 @@ setup() {
 		ip addr add 198.19.0.1/24 brd + dev ${parent}0
 		$ns ip addr add 198.19.0.2/24 brd + dev ${parent}1
 	elif [ "$inner" = "6" ]; then
-		ip addr add fdd4:96cf:4eae:443b::1/64 dev ${parent}0
-		$ns ip addr add fdd4:96cf:4eae:443b::2/64 dev ${parent}1
+		ip addr add fdd4:96cf:4eae:443b::1/64 dev ${parent}0 nodad
+		$ns ip addr add fdd4:96cf:4eae:443b::2/64 dev ${parent}1 nodad
 	fi
 }
 
-- 
2.30.2

