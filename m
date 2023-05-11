Return-Path: <netdev+bounces-1851-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2613D6FF4B3
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 16:41:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D6ED6281879
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 14:41:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3183D372;
	Thu, 11 May 2023 14:39:58 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2591C20F3
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 14:39:58 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16EA132AB
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 07:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683815991;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZOwKO+nSihscajbsF1ZZgeSFKg4ceOoF1DHSWFSqCrA=;
	b=OKvETkp2Oa3OhpnUz3iQbE7lj2WVmqU4LoMctHt0MNyWcbRF78vV8I4D38fnqZ39GPPsRJ
	nLsTinB1hrk8aFUqsBnJOlmirU9ipkFilJ3mERU60eKZDkJptJZ8T99sg6erNiGutRZtvB
	BgFBWfHig8MRbOgDBSf93K6PzCEG6Yk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-136-W3-4GVA9NTScGlzi6EOxPg-1; Thu, 11 May 2023 10:39:50 -0400
X-MC-Unique: W3-4GVA9NTScGlzi6EOxPg-1
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-3f315735edeso188928355e9.1
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 07:39:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683815989; x=1686407989;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZOwKO+nSihscajbsF1ZZgeSFKg4ceOoF1DHSWFSqCrA=;
        b=FV0g4ihsawuiKQEJWwcu1bYosMbG3GQhA1DFqXVOXjDXkrZz4XnCh91Gc3lBSPUZv6
         9TpTtIdN9T7hwKQZDJPxyxeF+SbIuAd73ymynygbHDmEq0SCfrFGXchk7uO2z4W5BSes
         iSr0T6W90UYQkimmbL+xBS1OazObZeP71o1k59nfkOrkbn40r0efbYSdp7kYl9jmVZvo
         F8a5GOL/rCjsFpRn4B5WdcC9wKwuB9hhGOgeQuvf6Z/R0WO3BgwOxZoJpalAov7EWO3j
         I+uiUINHaN+0ndIIT7M8AmEqtoblhdLZUaKdM0yDeCvAXaMoqNllWrViRLcETaRBa3+C
         9WXg==
X-Gm-Message-State: AC+VfDxnI2InMpSK7YaNAdkb+ujaLwX52hGLCOK59F7cz0t5X2Fi5z4X
	1GlM7fQuT+kNzV/BP52vc4gpql002DH+4IJHQ/S+LP5aqPqo3JBWTcXRJENj30+qqXDo+kmB5sI
	zPaYlp+tfvApRlI6k
X-Received: by 2002:adf:feca:0:b0:2fb:92c7:b169 with SMTP id q10-20020adffeca000000b002fb92c7b169mr18949552wrs.10.1683815989323;
        Thu, 11 May 2023 07:39:49 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4UtaD4tXuSOvbvua6VaEz8ogxG+hbyKuMBWMbz7iHOjTktxBJ0JWXyhFlMAtmNAcT9zMvk/A==
X-Received: by 2002:adf:feca:0:b0:2fb:92c7:b169 with SMTP id q10-20020adffeca000000b002fb92c7b169mr18949542wrs.10.1683815989144;
        Thu, 11 May 2023 07:39:49 -0700 (PDT)
Received: from debian (2a01cb058918ce00af30fd5ba5292148.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:af30:fd5b:a529:2148])
        by smtp.gmail.com with ESMTPSA id f5-20020a1c6a05000000b003f4266965fbsm11529199wmc.5.2023.05.11.07.39.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 07:39:48 -0700 (PDT)
Date: Thu, 11 May 2023 16:39:46 +0200
From: Guillaume Nault <gnault@redhat.com>
To: David Miller <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>
Cc: netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>
Subject: [PATCH v2 net-next 4/4] selftests: fcnal: Test SO_DONTROUTE on raw
 and ping sockets.
Message-ID: <f3af7d329b439264cf16c63482679c7648ce35ba.1683814269.git.gnault@redhat.com>
References: <cover.1683814269.git.gnault@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1683814269.git.gnault@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Use ping -r to test the kernel behaviour with raw and ping sockets
having the SO_DONTROUTE option.

Since ipv4_ping_novrf() is called with different values of
net.ipv4.ping_group_range, then it tests both raw and ping sockets
(ping uses ping sockets if its user ID belongs to ping_group_range
and raw sockets otherwise).

With both socket types, sending packets to a neighbour (on link) host,
should work. When the host is behind a router, sending should fail.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 tools/testing/selftests/net/fcnal-test.sh | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 08b4b96cbd63..05b5c4af7a08 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -584,6 +584,20 @@ ipv4_ping_novrf()
 		log_test_addr ${a} $? 0 "ping out, address bind"
 	done
 
+	#
+	# out, but don't use gateway if peer is not on link
+	#
+	a=${NSB_IP}
+	log_start
+	run_cmd ping -c 1 -w 1 -r ${a}
+	log_test_addr ${a} $? 0 "ping out (don't route), peer on link"
+
+	a=${NSB_LO_IP}
+	log_start
+	show_hint "Fails since peer is not on link"
+	run_cmd ping -c 1 -w 1 -r ${a}
+	log_test_addr ${a} $? 1 "ping out (don't route), peer not on link"
+
 	#
 	# in
 	#
-- 
2.30.2


