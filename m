Return-Path: <netdev+bounces-1848-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A9BD6FF4AB
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 16:40:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 55396281618
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 14:40:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A0EB62A;
	Thu, 11 May 2023 14:39:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DF1336D
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 14:39:40 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D9213A
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 07:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683815978;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=beqfaC6OiZWnknb8MSz7RGlb6quTGCMq8b6XuBHQkik=;
	b=RWazumTySL6sb38ogib4y/SqPHp/lqLmkB94cckkT96eKNKt7SmCEQqKbZzB/lurhi6YEJ
	ducchdRqVQPgSUdmLPvf0tOjvROK0AA7dyA8AvY9ET3lGZEYt7ugJ/ko2CwlpW8a+FBlaB
	lx+XglgEgefX/EUDm7+0jf80CVy0eYA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-131-khT-SY4DNTyFaPR68ZPcjw-1; Thu, 11 May 2023 10:39:36 -0400
X-MC-Unique: khT-SY4DNTyFaPR68ZPcjw-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f422dc5ee5so29821685e9.0
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 07:39:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683815975; x=1686407975;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=beqfaC6OiZWnknb8MSz7RGlb6quTGCMq8b6XuBHQkik=;
        b=goZd46h2n4BLOp22R6bXy7RByH1HBt3dOKZZNwuWEyuLSnFBK0+2XgFnqqakvit0eo
         Vl10uOyxggPh56n0TktpzSvKaA8kWWjZ1WX7wQZS3HsclcYoHVgM/PJUGR69814CLSJJ
         ZPYG6Q+s8ZxPe7H4LmkBzWMk0j9IJ330HFjqOb/9uanr5ICOVAuLy1Td6o1MqEbtDQ48
         ITrQMoa+zRPFvSKhYfkfJ0hv6H3EDQzflkm1LXehMkfJqAbSSMVfz10y+6wIsNvTdaFA
         bb/2u8T2rLXR3z4dS41sLfN4pa+pyR/USQjvvExYDFybJwY9CS0PRhjJQrvMtJGvXiw0
         CjCg==
X-Gm-Message-State: AC+VfDyDpJSFkLXmhSr8MVYQnAMmJMSUyrDyyQh/de5W9rpnzt4UNauC
	a/iwONo3WJ6KZBLqz5BywcG3v95Dug0EJ0VISalSaMqaVhPJvOXEBLZedAiSItICp79Vzh1tjLP
	dBx0gajnyFAtLBHzu
X-Received: by 2002:a05:600c:228e:b0:3f4:2174:b28a with SMTP id 14-20020a05600c228e00b003f42174b28amr13420227wmf.15.1683815975624;
        Thu, 11 May 2023 07:39:35 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7+y28Bl7bB10C3fyQtaC95xoWD2pb3TfmNHNU83MF1yoUFCZwenAZcLiaKsIeQaoLhueA4sA==
X-Received: by 2002:a05:600c:228e:b0:3f4:2174:b28a with SMTP id 14-20020a05600c228e00b003f42174b28amr13420200wmf.15.1683815975287;
        Thu, 11 May 2023 07:39:35 -0700 (PDT)
Received: from debian (2a01cb058918ce00af30fd5ba5292148.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:af30:fd5b:a529:2148])
        by smtp.gmail.com with ESMTPSA id p20-20020a1c7414000000b003f435652aaesm5924051wmc.11.2023.05.11.07.39.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 07:39:34 -0700 (PDT)
Date: Thu, 11 May 2023 16:39:32 +0200
From: Guillaume Nault <gnault@redhat.com>
To: David Miller <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>
Cc: netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>
Subject: [PATCH v2 net-next 2/4] selftests: fcnal: Test SO_DONTROUTE on TCP
 sockets.
Message-ID: <a54cb9d143611e568d3e34b801e24dce440c309d.1683814269.git.gnault@redhat.com>
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

Use nettest --{client,server}-dontroute to test the kernel behaviour
with TCP sockets having the SO_DONTROUTE option. Sending packets to a
neighbour (on link) host, should work. When the host is behind a
router, sending should fail.

Client and server sockets are tested independently, so that we can
cover different TCP kernel paths.

SO_DONTROUTE also affects the syncookies path. So ipv4_tcp_dontroute()
is made to work with or without syncookies, to cover both paths.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 v2: Use 'nettest -B' instead of invoking two nettest instances for
     client and server.

 tools/testing/selftests/net/fcnal-test.sh | 56 +++++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 21ca91473c09..3a1f3051321f 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -1098,6 +1098,59 @@ test_ipv4_md5_vrf__global_server__bind_ifindex0()
 	set_sysctl net.ipv4.tcp_l3mdev_accept="$old_tcp_l3mdev_accept"
 }
 
+ipv4_tcp_dontroute()
+{
+	local syncookies=$1
+	local nsa_syncookies
+	local nsb_syncookies
+	local a
+
+	#
+	# Link local connection tests (SO_DONTROUTE).
+	# Connections should succeed only when the remote IP address is
+	# on link (doesn't need to be routed through a gateway).
+	#
+
+	nsa_syncookies=$(ip netns exec "${NSA}" sysctl -n net.ipv4.tcp_syncookies)
+	nsb_syncookies=$(ip netns exec "${NSB}" sysctl -n net.ipv4.tcp_syncookies)
+	ip netns exec "${NSA}" sysctl -wq net.ipv4.tcp_syncookies=${syncookies}
+	ip netns exec "${NSB}" sysctl -wq net.ipv4.tcp_syncookies=${syncookies}
+
+	# Test with eth1 address (on link).
+
+	a=${NSB_IP}
+	log_start
+	do_run_cmd nettest -B -N "${NSA}" -O "${NSB}" -r ${a} --client-dontroute
+	log_test_addr ${a} $? 0 "SO_DONTROUTE client, syncookies=${syncookies}"
+
+	a=${NSB_IP}
+	log_start
+	do_run_cmd nettest -B -N "${NSA}" -O "${NSB}" -r ${a} --server-dontroute
+	log_test_addr ${a} $? 0 "SO_DONTROUTE server, syncookies=${syncookies}"
+
+	# Test with loopback address (routed).
+	#
+	# The client would use the eth1 address as source IP by default.
+	# Therefore, we need to use the -c option here, to force the use of the
+	# routed (loopback) address as source IP (so that the server will try
+	# to respond to a routed address and not a link local one).
+
+	a=${NSB_LO_IP}
+	log_start
+	show_hint "Should fail 'Network is unreachable' since server is not on link"
+	do_run_cmd nettest -B -N "${NSA}" -O "${NSB}" -c "${NSA_LO_IP}" -r ${a} --client-dontroute
+	log_test_addr ${a} $? 1 "SO_DONTROUTE client, syncookies=${syncookies}"
+
+	a=${NSB_LO_IP}
+	log_start
+	show_hint "Should timeout since server cannot respond (client is not on link)"
+	do_run_cmd nettest -B -N "${NSA}" -O "${NSB}" -c "${NSA_LO_IP}" -r ${a} --server-dontroute
+	log_test_addr ${a} $? 2 "SO_DONTROUTE server, syncookies=${syncookies}"
+
+	ip netns exec "${NSB}" sysctl -wq net.ipv4.tcp_syncookies=${nsb_syncookies}
+	ip netns exec "${NSA}" sysctl -wq net.ipv4.tcp_syncookies=${nsa_syncookies}
+}
+
 ipv4_tcp_novrf()
 {
 	local a
@@ -1217,6 +1270,9 @@ ipv4_tcp_novrf()
 	log_test_addr ${a} $? 1 "No server, device client, local conn"
 
 	ipv4_tcp_md5_novrf
+
+	ipv4_tcp_dontroute 0
+	ipv4_tcp_dontroute 2
 }
 
 ipv4_tcp_vrf()
-- 
2.30.2


