Return-Path: <netdev+bounces-1849-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CA1476FF4AC
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 16:40:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 825E12815D2
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 14:40:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9224436D;
	Thu, 11 May 2023 14:39:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82606801
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 14:39:46 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B1E42102
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 07:39:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683815984;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Aa3z44yU0DxyJitqNmKNyE7RxW0goYpKNcBwEUkPSqs=;
	b=bmB9acd2wFibZlyP69YvmdYjdf/Pi7j1RTSTX7hHNovE4lnXhmnm3ut7LJkOULkAO1shCf
	lPwociZ2pH9S18r8E9MPkkAF4WXX2D7TcZgFninlEJ6bAuPFx6HDRpfRetHY+xLsVJ9ePC
	/WCpZZaFll31Fi3/uQcufXmYLmMpKn8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-589-crIb_Y7EPauQG53yVdixjg-1; Thu, 11 May 2023 10:39:43 -0400
X-MC-Unique: crIb_Y7EPauQG53yVdixjg-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-30793c16c78so3342934f8f.3
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 07:39:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683815982; x=1686407982;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Aa3z44yU0DxyJitqNmKNyE7RxW0goYpKNcBwEUkPSqs=;
        b=IW2Snt8yRee3lstu+2XCnwWXsgyFTLkkLAkNJkqjW1wVKrXjOuX9VlPFRYBDFw2ncz
         FIbwV4jiLFBXtPQTdlWsjbyriVBj41wvMo6L8Z3dqRnxbe+0VogpEzymN5QCnVMcel/Q
         ySPGc40PkTvtYvIwLnFCYolgdZBuXwvU3mdFTmMW5SZvcR/SscsscJPtumokn++Y1RaS
         uclRohfuOSsgVXHPnwR3vssRjbEVNk+EJ0XaG07u/PIGBs6cNEhk4Ic8MhCbS5jsaTVr
         0Cwird2oJY3JXtB819Vj3+gBgugbm7TUHUbZWpTfYBOqxE0B3dDSSrk0pmwL7QyxNgsM
         QPhQ==
X-Gm-Message-State: AC+VfDzSEnVhRyYILcGXxk5+q/jOvZCyBT03NfyUpQcTDxgSfHC3oFzH
	DFWCt+tmmvRV6lKZvzLbnfcJehSj3RQY1cCrf8F6psCmFIzIKpS9xX4yjjBWBbXjNlJVqvrlcGx
	4b8gJdRoGPWaF3Ldn
X-Received: by 2002:adf:fa8b:0:b0:307:a4ee:4a25 with SMTP id h11-20020adffa8b000000b00307a4ee4a25mr7514251wrr.28.1683815982106;
        Thu, 11 May 2023 07:39:42 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5GpzAFtPo1MBqiX+OEtjbzmygs7Ku/V2kTllt2P9A6tTFuxSQPdAPPG4Zibwyk6uq/7A8jIg==
X-Received: by 2002:adf:fa8b:0:b0:307:a4ee:4a25 with SMTP id h11-20020adffa8b000000b00307a4ee4a25mr7514232wrr.28.1683815981783;
        Thu, 11 May 2023 07:39:41 -0700 (PDT)
Received: from debian (2a01cb058918ce00af30fd5ba5292148.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:af30:fd5b:a529:2148])
        by smtp.gmail.com with ESMTPSA id o4-20020a5d4a84000000b003062b6a522bsm20792700wrq.96.2023.05.11.07.39.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 07:39:41 -0700 (PDT)
Date: Thu, 11 May 2023 16:39:39 +0200
From: Guillaume Nault <gnault@redhat.com>
To: David Miller <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>
Cc: netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>
Subject: [PATCH v2 net-next 3/4] selftests: fcnal: Test SO_DONTROUTE on UDP
 sockets.
Message-ID: <dbc62d5ea038e0fc7b0a59cedc1213d3ae6a59fe.1683814269.git.gnault@redhat.com>
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
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Use nettest --client-dontroute to test the kernel behaviour with UDP
sockets having the SO_DONTROUTE option. Sending packets to a neighbour
(on link) host, should work. When the host is behind a router, sending
should fail.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 v2: Use 'nettest -B' instead of invoking two nettest instances for
     client and server.

 tools/testing/selftests/net/fcnal-test.sh | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 3a1f3051321f..08b4b96cbd63 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -1641,6 +1641,23 @@ ipv4_udp_novrf()
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
+	do_run_cmd nettest -B -D -N "${NSA}" -O "${NSB}" -r ${a} --client-dontroute
+	log_test_addr ${a} $? 0 "SO_DONTROUTE client"
+
+	a=${NSB_LO_IP}
+	log_start
+	show_hint "Should fail 'Network is unreachable' since server is not on link"
+	do_run_cmd nettest -B -D -N "${NSA}" -O "${NSB}" -r ${a} --client-dontroute
+	log_test_addr ${a} $? 1 "SO_DONTROUTE client"
 }
 
 ipv4_udp_vrf()
-- 
2.30.2


