Return-Path: <netdev+bounces-1153-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8591F6FC5C2
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 14:03:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 57A0628124E
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 12:03:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12E32182C5;
	Tue,  9 May 2023 12:02:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08531182B5
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 12:02:45 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4886FA
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 05:02:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683633762;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aVSefJv3UGBgJwbiyuokVG1nOTH+/IsF6e+/n0tlWcM=;
	b=ZPrcXv3U9dZRKuHCmnxXwWF9baU0flLmz3ohQ2rLHmOdeQoRbFnb8hb8gJUkMhcMf75M5t
	J4cCBhYeq+iU75B/QcTNeVrjfKjzkHhYdIjcZjwWPEAaYgt4sRfUqJkyjvTVTlLTQ+a+hl
	ztbg83Ya1JUPFUUND9QwS+bkTHfurS8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-218-lufwFGHlM-KAHN3PDxvPZA-1; Tue, 09 May 2023 08:02:41 -0400
X-MC-Unique: lufwFGHlM-KAHN3PDxvPZA-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-3f3157128b4so135666945e9.0
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 05:02:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683633760; x=1686225760;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aVSefJv3UGBgJwbiyuokVG1nOTH+/IsF6e+/n0tlWcM=;
        b=DyUjvwv2pPzSrBY+STkywEL3X78QaF5+WDqccZ1ImfC55ZQm4g6E/9gMytSqm2na5N
         e8Zbumpyht96KvcMkmhAyVkRoH5GQW393tE5k3cWTZd+OVMYF9lJZ3LTilIYrZ//dWyD
         EPnDTY+HKr08puV35ieWzOBkJ08PjlPTaPuaepSOu0wtQRpn5Lv3eqRHIB496HHonuM5
         PEn26GM+BdUVnAzofPXvDVfLA0RZx14R83GBiZlSQJmLadc7GK41KcZTzuhPId1QpAGe
         pIi7EZIiy9dqeXB6h6f4VZ7y4k5DbHd8OuI/1UXJtEoXE/7E8AdH7jz1+wfmz7qjS3kC
         s7BQ==
X-Gm-Message-State: AC+VfDw/IuXkvaPC4tyoGjnOTKJ6JlaNCrH3oi2oKOP2Va4oDHlVGTUP
	W8/L2j/aE25SX9f0O8NVTvMarxQvlVte7XVhd3Egj5OYBV09mTc5+1fsHtg3g3lbiju/70j2PLK
	7JyzJiCGf9PLSck+n
X-Received: by 2002:a5d:6384:0:b0:2fa:abcd:59a2 with SMTP id p4-20020a5d6384000000b002faabcd59a2mr9534881wru.30.1683633759863;
        Tue, 09 May 2023 05:02:39 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7GP6whMq0YqFjyrM7/fi3cM7/g3qSHCDeHfIDcA/43Gek0Ibt7HmrMHft3oOFW6Tje5Fx/JQ==
X-Received: by 2002:a5d:6384:0:b0:2fa:abcd:59a2 with SMTP id p4-20020a5d6384000000b002faabcd59a2mr9534868wru.30.1683633759657;
        Tue, 09 May 2023 05:02:39 -0700 (PDT)
Received: from debian (2a01cb058918ce005a3b5dcb9dbff7d2.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:5a3b:5dcb:9dbf:f7d2])
        by smtp.gmail.com with ESMTPSA id s9-20020a5d5109000000b002ffbf2213d4sm14106651wrt.75.2023.05.09.05.02.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 05:02:39 -0700 (PDT)
Date: Tue, 9 May 2023 14:02:37 +0200
From: Guillaume Nault <gnault@redhat.com>
To: David Miller <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>
Cc: netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>
Subject: [PATCH net-next 2/4] selftests: fcnal: Test SO_DONTROUTE on TCP
 sockets.
Message-ID: <ac92940c6d2c17c7c8d476428cfa94c4ffa6bd8b.1683626501.git.gnault@redhat.com>
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
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Use nettest -G to test the kernel behaviour with TCP sockets having the
SO_DONTROUTE option. Sending packets to a neighbour (on link) host,
should work. When the host is behind a router, sending should fail.

Client and server sockets are tested independently, so that we can
cover different TCP kernel paths.

SO_DONTROUTE also affects the syncookies path. So ipv4_tcp_dontroute()
is made to work with or without syncookies, to cover both paths.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 tools/testing/selftests/net/fcnal-test.sh | 70 +++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/selftests/net/fcnal-test.sh
index 21ca91473c09..1f8939fbb021 100755
--- a/tools/testing/selftests/net/fcnal-test.sh
+++ b/tools/testing/selftests/net/fcnal-test.sh
@@ -1098,6 +1098,73 @@ test_ipv4_md5_vrf__global_server__bind_ifindex0()
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
+	run_cmd_nsb nettest -s &
+	sleep 1
+	run_cmd nettest -r ${a} -G
+	log_test_addr ${a} $? 0 "SO_DONTROUTE client, syncookies=${syncookies}"
+
+	a=${NSB_IP}
+	log_start
+	# Ensure previous nettest server exited, so that it won't respond (we
+	# really want to test the -G option on the server).
+	wait
+	run_cmd_nsb nettest -s -G &
+	sleep 1
+	run_cmd nettest -r ${a}
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
+	run_cmd_nsb nettest -s &
+	sleep 1
+	run_cmd nettest -c ${NSA_LO_IP} -r ${a} -G
+	log_test_addr ${a} $? 1 "SO_DONTROUTE client, syncookies=${syncookies}"
+
+	a=${NSB_LO_IP}
+	log_start
+	show_hint "Should timeout since server cannot respond (client is not on link)"
+	# Ensure previous nettest server exited, so that it won't respond (we
+	# really want to test the -G option on the server).
+	wait
+	run_cmd_nsb nettest -s -G &
+	sleep 1
+	run_cmd nettest -c ${NSA_LO_IP} -r ${a}
+	log_test_addr ${a} $? 2 "SO_DONTROUTE server, syncookies=${syncookies}"
+
+	ip netns exec "${NSB}" sysctl -wq net.ipv4.tcp_syncookies=${nsb_syncookies}
+	ip netns exec "${NSA}" sysctl -wq net.ipv4.tcp_syncookies=${nsa_syncookies}
+}
+
 ipv4_tcp_novrf()
 {
 	local a
@@ -1217,6 +1284,9 @@ ipv4_tcp_novrf()
 	log_test_addr ${a} $? 1 "No server, device client, local conn"
 
 	ipv4_tcp_md5_novrf
+
+	ipv4_tcp_dontroute 0
+	ipv4_tcp_dontroute 2
 }
 
 ipv4_tcp_vrf()
-- 
2.30.2


