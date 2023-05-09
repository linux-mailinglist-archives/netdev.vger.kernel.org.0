Return-Path: <netdev+bounces-1155-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 99CD06FC5C4
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 14:04:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6010E280E0B
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 12:04:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A68B182AA;
	Tue,  9 May 2023 12:03:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D41F171C7
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 12:03:05 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 548CFDC
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 05:03:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683633783;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=phVfwRZ8/EVKTr1sC/M7k87pKle89PDg77IQ7sjzskY=;
	b=QBjGJLzUvi2LcvoyCinOYrYQq3lqnjiQ4gatngznf+0vpTq2w7azy5u4L0kcIhasA0NN+P
	OK43/N+A6pvXRESvlyFd2pY0JSf3iKpy5tvFCEmNldcdEBwCywKJ1tHa62hY+CIJjvVhEe
	gnMeQVKJHouhSnpfyaziSLcZFcFLfxI=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-623-xR33W2e0OxWOpLFANZplUg-1; Tue, 09 May 2023 08:03:00 -0400
X-MC-Unique: xR33W2e0OxWOpLFANZplUg-1
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3064d0b726fso1987332f8f.0
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 05:03:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683633779; x=1686225779;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=phVfwRZ8/EVKTr1sC/M7k87pKle89PDg77IQ7sjzskY=;
        b=HGUtO1qOUlLH88Dlf4yE2Ku/aPECsXGYthJbC05KKuMkcpQ51/vqjsgwM0O9QP+o/v
         RRXE5YXL/W3wG9EOIr1ymw8q7RC6vVKAQQLyfjY86goyffK1H2wWHo/GGAkczJ5xlGy9
         eJKCay7wGQWy+g7v826E58/pKc4Vo95+p45+qqRil8nEJJo5CvuVefPC8ZEmjNaXXFwL
         eecfjdE+eAri/kC4hR+UCjcRQSEJROP+FktdZuRkCM4EDb79box83SSJQubhI0cDjkiU
         6oJR7bflZlgPtjHHLPeVpktjPVSca+viWY0qrG4tCUSkJClsUjdL3BfYZguU4epAvGFP
         gGEw==
X-Gm-Message-State: AC+VfDxzxg0KpKhs2JDdMIHmytgujxwR4kBcO6PhQ0yL7jI8yQpMVKoI
	Pdqkju72/t7hoCfs148tGR0lOIAQ6XybIcPAtANJCbXX48aV290b3oCZr2A6zSrMA+Dgrhyp1wK
	URgDBPq9Jk20C916B
X-Received: by 2002:a05:6000:510:b0:306:2fab:1f81 with SMTP id a16-20020a056000051000b003062fab1f81mr10427048wrf.21.1683633779285;
        Tue, 09 May 2023 05:02:59 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7l2PPRovFyrt17RCorDlvUnSgEiqO1L1oY1hom87xiwkqJs7ByDI52VSRYOR9daUh8l86WIA==
X-Received: by 2002:a05:6000:510:b0:306:2fab:1f81 with SMTP id a16-20020a056000051000b003062fab1f81mr10427006wrf.21.1683633778545;
        Tue, 09 May 2023 05:02:58 -0700 (PDT)
Received: from debian (2a01cb058918ce005a3b5dcb9dbff7d2.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:5a3b:5dcb:9dbf:f7d2])
        by smtp.gmail.com with ESMTPSA id x14-20020adfec0e000000b002ca864b807csm14360308wrn.0.2023.05.09.05.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 05:02:58 -0700 (PDT)
Date: Tue, 9 May 2023 14:02:56 +0200
From: Guillaume Nault <gnault@redhat.com>
To: David Miller <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>
Cc: netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>
Subject: [PATCH net-next 3/4] selftests: fcnal: Test SO_DONTROUTE on UDP
 sockets.
Message-ID: <a98b35c89bcf78535986a1a122542bc008b92c6b.1683626501.git.gnault@redhat.com>
References: <cover.1683626501.git.gnault@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1683626501.git.gnault@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Use nettest -G to test the kernel behaviour with UDP sockets having the
SO_DONTROUTE option. Sending packets to a neighbour (on link) host,
should work. When the host is behind a router, sending should fail.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 tools/testing/selftests/net/fcnal-test.sh | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 1f8939fbb021..23672cba8781 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -1655,6 +1655,27 @@ ipv4_udp_novrf()
 	log_start
 	run_cmd nettest -D -d ${NSA_DEV} -r ${a}
 	log_test_addr ${a} $? 2 "No server, device client, local conn"
+
+	#
+	# Link local connection tests (SO_DONTROUTE).
+	# Connections should succeed only when the remote IP address is
+	# on link (doesn't need to be routed through a gateway).
+	#
+
+	a=${NSB_IP}
+	log_start
+	run_cmd_nsb nettest -D -s &
+	sleep 1
+	run_cmd nettest -D -r ${a} -G
+	log_test_addr ${a} $? 0 "SO_DONTROUTE client"
+
+	a=${NSB_LO_IP}
+	log_start
+	show_hint "Should fail 'Network is unreachable' since server is not on link"
+	run_cmd_nsb nettest -D -s &
+	sleep 1
+	run_cmd nettest -D -r ${a} -G
+	log_test_addr ${a} $? 1 "SO_DONTROUTE client"
 }
 
 ipv4_udp_vrf()
-- 
2.30.2


