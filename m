Return-Path: <netdev+bounces-1847-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 081FB6FF4A8
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 16:39:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A80B1C20F0A
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 14:39:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B24A372;
	Thu, 11 May 2023 14:39:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A9F36D
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 14:39:35 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 389308E
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 07:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683815973;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=bTPhWMsRGfOJE7oIw5IMJbbyTPlYMqaoJbuyuu8PVWA=;
	b=VFslfgacGJQX/PaBqqhh16Y+6N1aXe+nxT+o+n/SBq6RblNORLtf0zI9YYYKo2rsBybUup
	VaiITWkY9mykHpdaHwgTHlZ/wjaYl01YK2sjP7skd1ySZIQHz5VxbLTeJAfXsM2MQqc8t7
	ki8i8CgQ5+XKyV6F3mRzqkjSy0BMDuM=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-272--4IPmI1fMl-0RvtdcDVhUA-1; Thu, 11 May 2023 10:39:29 -0400
X-MC-Unique: -4IPmI1fMl-0RvtdcDVhUA-1
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-306489b7585so3056051f8f.3
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 07:39:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683815968; x=1686407968;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bTPhWMsRGfOJE7oIw5IMJbbyTPlYMqaoJbuyuu8PVWA=;
        b=Viy0HlmHL/yTjq36tB5IOVMzVJ2KhQSwXor3VTTTLnBLKeuUeOSV8ccJBxeurjp21Q
         GIXYggHYbO+/0ppmjK0ZTV/LKUKOrp5PQguYfrf+D4tEHDbMn0NEgSeGN5je/d+Gkxae
         2jW2n8bEl2ok7HWexX+OS2Jqdro209jC4n/DIjYFK93/1U45lLeVHUlKMzjEm7lrSrE8
         6uhEOUkHHEvG1oTtRrV2i6CEmEpUIaGKwqrlrg3fhgD0JNUUEuHFZ3BOVzx+OFrOcloz
         4Vf3FYy9qvX6s01fURubgl1LNKdq8JoEQrSUeaA2NvMwiprbzsxXu/wLIyM/XchSu/rl
         BN2A==
X-Gm-Message-State: AC+VfDzl+vLpEv+MT7/b4Ii8Ffe07y0FxK44vY/+JbpgnO9QN8Ht2ROm
	e56ljwFKEqzITbuAouc8Z4TKCnw1N2SVOLW73rzTmkx1VKxmX/wMlZAjabR6A4GFFy0sXN1+Zx6
	O5G+NBHglExMl8Iuh1LYvibf3
X-Received: by 2002:adf:e941:0:b0:307:a8e8:ca6c with SMTP id m1-20020adfe941000000b00307a8e8ca6cmr6514364wrn.35.1683815968176;
        Thu, 11 May 2023 07:39:28 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ55nQ0Tt4jnQQcnz5/0YGI0q3kRKPy+bMkwu/gzA47Fm5PhkDZcf9Lyr6Lm0klY1ega3utDFA==
X-Received: by 2002:adf:e941:0:b0:307:a8e8:ca6c with SMTP id m1-20020adfe941000000b00307a8e8ca6cmr6514352wrn.35.1683815967970;
        Thu, 11 May 2023 07:39:27 -0700 (PDT)
Received: from debian (2a01cb058918ce00af30fd5ba5292148.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:af30:fd5b:a529:2148])
        by smtp.gmail.com with ESMTPSA id b15-20020a5d4b8f000000b003064600cff9sm20600864wrt.38.2023.05.11.07.39.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 07:39:27 -0700 (PDT)
Date: Thu, 11 May 2023 16:39:25 +0200
From: Guillaume Nault <gnault@redhat.com>
To: David Miller <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>
Cc: netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>
Subject: [PATCH v2 net-next 1/4] selftests: Add SO_DONTROUTE option to
 nettest.
Message-ID: <0b28378e6a34c9a1ffda95449a1a171491079f06.1683814269.git.gnault@redhat.com>
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

Add --client-dontroute and --server-dontroute options to nettest. They
allow to set the SO_DONTROUTE option to the client and server sockets
respectively. This will be used by the following patches to test
the SO_DONTROUTE kernel behaviour with TCP and UDP.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 v2: Use two different options for setting SO_DONTROUTE either on the
     client or on the server socket.

 tools/testing/selftests/net/nettest.c | 46 ++++++++++++++++++++++++++-
 1 file changed, 45 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/net/nettest.c b/tools/testing/selftests/net/nettest.c
index ee9a72982705..39a0e01f8554 100644
--- a/tools/testing/selftests/net/nettest.c
+++ b/tools/testing/selftests/net/nettest.c
@@ -76,7 +76,9 @@ struct sock_args {
 		     has_grp:1,
 		     has_expected_laddr:1,
 		     has_expected_raddr:1,
-		     bind_test_only:1;
+		     bind_test_only:1,
+		     client_dontroute:1,
+		     server_dontroute:1;
 
 	unsigned short port;
 
@@ -611,6 +613,18 @@ static int set_dsfield(int sd, int version, int dsfield)
 	return 0;
 }
 
+static int set_dontroute(int sd)
+{
+	unsigned int one = 1;
+
+	if (setsockopt(sd, SOL_SOCKET, SO_DONTROUTE, &one, sizeof(one)) < 0) {
+		log_err_errno("setsockopt(SO_DONTROUTE)");
+		return -1;
+	}
+
+	return 0;
+}
+
 static int str_to_uint(const char *str, int min, int max, unsigned int *value)
 {
 	int number;
@@ -1351,6 +1365,14 @@ static int msock_init(struct sock_args *args, int server)
 	if (set_dsfield(sd, AF_INET, args->dsfield) != 0)
 		goto out_err;
 
+	if (server) {
+		if (args->server_dontroute && set_dontroute(sd) != 0)
+			goto out_err;
+	} else {
+		if (args->client_dontroute && set_dontroute(sd) != 0)
+			goto out_err;
+	}
+
 	if (args->dev && bind_to_device(sd, args->dev) != 0)
 		goto out_err;
 	else if (args->use_setsockopt &&
@@ -1482,6 +1504,9 @@ static int lsock_init(struct sock_args *args)
 	if (set_dsfield(sd, args->version, args->dsfield) != 0)
 		goto err;
 
+	if (args->server_dontroute && set_dontroute(sd) != 0)
+		goto err;
+
 	if (args->dev && bind_to_device(sd, args->dev) != 0)
 		goto err;
 	else if (args->use_setsockopt &&
@@ -1698,6 +1723,9 @@ static int connectsock(void *addr, socklen_t alen, struct sock_args *args)
 	if (set_dsfield(sd, args->version, args->dsfield) != 0)
 		goto err;
 
+	if (args->client_dontroute && set_dontroute(sd) != 0)
+		goto err;
+
 	if (args->dev && bind_to_device(sd, args->dev) != 0)
 		goto err;
 	else if (args->use_setsockopt &&
@@ -1905,10 +1933,14 @@ static int ipc_parent(int cpid, int fd, struct sock_args *args)
 #define GETOPT_STR  "sr:l:c:Q:p:t:g:P:DRn:M:X:m:d:I:BN:O:SUCi6xL:0:1:2:3:Fbqf"
 #define OPT_FORCE_BIND_KEY_IFINDEX 1001
 #define OPT_NO_BIND_KEY_IFINDEX 1002
+#define OPT_CLIENT_DONTROUTE 1003
+#define OPT_SERVER_DONTROUTE 1004
 
 static struct option long_opts[] = {
 	{"force-bind-key-ifindex", 0, 0, OPT_FORCE_BIND_KEY_IFINDEX},
 	{"no-bind-key-ifindex", 0, 0, OPT_NO_BIND_KEY_IFINDEX},
+	{"client-dontroute", 0, 0, OPT_CLIENT_DONTROUTE},
+	{"server-dontroute", 0, 0, OPT_SERVER_DONTROUTE},
 	{0, 0, 0, 0}
 };
 
@@ -1954,6 +1986,12 @@ static void print_usage(char *prog)
 	"    --no-bind-key-ifindex: Force TCP_MD5SIG_FLAG_IFINDEX off\n"
 	"    --force-bind-key-ifindex: Force TCP_MD5SIG_FLAG_IFINDEX on\n"
 	"        (default: only if -I is passed)\n"
+	"    --client-dontroute: don't use gateways for client socket: send\n"
+	"                        packets only if destination is on link (see\n"
+	"                        SO_DONTROUTE in socket(7))\n"
+	"    --server-dontroute: don't use gateways for server socket: send\n"
+	"                        packets only if destination is on link (see\n"
+	"                        SO_DONTROUTE in socket(7))\n"
 	"\n"
 	"    -g grp        multicast group (e.g., 239.1.1.1)\n"
 	"    -i            interactive mode (default is echo and terminate)\n"
@@ -2076,6 +2114,12 @@ int main(int argc, char *argv[])
 		case OPT_NO_BIND_KEY_IFINDEX:
 			args.bind_key_ifindex = -1;
 			break;
+		case OPT_CLIENT_DONTROUTE:
+			args.client_dontroute = 1;
+			break;
+		case OPT_SERVER_DONTROUTE:
+			args.server_dontroute = 1;
+			break;
 		case 'X':
 			args.client_pw = optarg;
 			break;
-- 
2.30.2


