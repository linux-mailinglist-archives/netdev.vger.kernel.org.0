Return-Path: <netdev+bounces-1152-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AAA596FC5C0
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 14:03:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D53B61C20B7E
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 12:03:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C757182B6;
	Tue,  9 May 2023 12:02:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3709182B5
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 12:02:43 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41A191A4
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 05:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683633761;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mMSi69loZlQv+vSAkw/8FzHDDZFUzwS5MLW0SwisgX4=;
	b=DDBmADkIxj9m+o++0+ZrF4P+5F1Kcx92211w35lcWYOSJWdtLBjHShj3Tb4p6BC78qZQ57
	erVQeTjFyxHy5/I8a8MfjaQlhlSpnyLV9yunZlftim5/psjuzhKwQ3ZMpp9/hMXgHDGpVA
	Xc5iiX2JK+3ZOzPDvjuE9R/6HeNXCr8=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-205-rkiskIDcPR-D7ozwTS3kPw-1; Tue, 09 May 2023 08:02:40 -0400
X-MC-Unique: rkiskIDcPR-D7ozwTS3kPw-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-307977ae703so1325003f8f.3
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 05:02:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683633759; x=1686225759;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mMSi69loZlQv+vSAkw/8FzHDDZFUzwS5MLW0SwisgX4=;
        b=kol+D8CKU8uZYfdhMCWIa7jGWzttI4mzstyW2lgrF8apKHVLDHU+yKR6Jl1gwOj99T
         nY9K8IWIE0Rf2c4/mid6Cu6lAqMMvrA5eEnYpGUCyLW6UxR2GVROiQ2nkZQidSeem2VN
         21QMCbUwG0G5Lb85NxNhzKh8Hk6X3ytO42JUVnut50gvlPGZxAivX3RMtI8du/D5qwbE
         nGYkai9ik/jYnyovHjH8bT8l19aMVHXu3hX/MYrP5JhUsM0F/j2bpXJdkWduAjWCCIQ9
         tVxx2R6eiyFA7CQXRqVZlF7tqUujetZkbE1DoFVw7/YvyR11s145aWjzG+m0vZ0k6EJX
         5+nA==
X-Gm-Message-State: AC+VfDxsX0st+GisZQSpwEx+etruC5xQ/IECuxrP5bRVRE6P/6V/7wRw
	zL8/8KEsz1R5qc4stiJ6ku0CmZ5b+gITAbb50NttaH2qA/TCTRnYZFEuJ87gXILCbGtIgFTMaFy
	xFZPQmItqK0ciJVDd
X-Received: by 2002:a05:6000:cc:b0:307:95ac:a3f with SMTP id q12-20020a05600000cc00b0030795ac0a3fmr4199426wrx.23.1683633759083;
        Tue, 09 May 2023 05:02:39 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6LyUMAYECQ2mWFhvjel4rcl93hqmAEcXqRgzRMC5xeNshkDXiBrDVot+m3HUtlIjefIwoObw==
X-Received: by 2002:a05:6000:cc:b0:307:95ac:a3f with SMTP id q12-20020a05600000cc00b0030795ac0a3fmr4199411wrx.23.1683633758839;
        Tue, 09 May 2023 05:02:38 -0700 (PDT)
Received: from debian (2a01cb058918ce005a3b5dcb9dbff7d2.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:5a3b:5dcb:9dbf:f7d2])
        by smtp.gmail.com with ESMTPSA id u1-20020a5d4681000000b003062f894b64sm14442267wrq.22.2023.05.09.05.02.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 05:02:38 -0700 (PDT)
Date: Tue, 9 May 2023 14:02:36 +0200
From: Guillaume Nault <gnault@redhat.com>
To: David Miller <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>
Cc: netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>
Subject: [PATCH net-next 1/4] selftests: Add SO_DONTROUTE option to nettest.
Message-ID: <1b3d54c39af185c514a16cbd779b52a9cf9ef2de.1683626501.git.gnault@redhat.com>
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
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Add -G option to nettest. It allows to set the SO_DONTROUTE option to
the created sockets. This will be used by the following patches to test
the SO_DONTROUTE behaviour with TCP and UDP.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 tools/testing/selftests/net/nettest.c | 32 +++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/net/nettest.c b/tools/testing/selftests/net/nettest.c
index ee9a72982705..0b5b580e6eba 100644
--- a/tools/testing/selftests/net/nettest.c
+++ b/tools/testing/selftests/net/nettest.c
@@ -76,7 +76,8 @@ struct sock_args {
 		     has_grp:1,
 		     has_expected_laddr:1,
 		     has_expected_raddr:1,
-		     bind_test_only:1;
+		     bind_test_only:1,
+		     dontroute:1;
 
 	unsigned short port;
 
@@ -611,6 +612,18 @@ static int set_dsfield(int sd, int version, int dsfield)
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
@@ -1351,6 +1364,9 @@ static int msock_init(struct sock_args *args, int server)
 	if (set_dsfield(sd, AF_INET, args->dsfield) != 0)
 		goto out_err;
 
+	if (args->dontroute && set_dontroute(sd) != 0)
+		goto out_err;
+
 	if (args->dev && bind_to_device(sd, args->dev) != 0)
 		goto out_err;
 	else if (args->use_setsockopt &&
@@ -1482,6 +1498,9 @@ static int lsock_init(struct sock_args *args)
 	if (set_dsfield(sd, args->version, args->dsfield) != 0)
 		goto err;
 
+	if (args->dontroute && set_dontroute(sd) != 0)
+		goto err;
+
 	if (args->dev && bind_to_device(sd, args->dev) != 0)
 		goto err;
 	else if (args->use_setsockopt &&
@@ -1698,6 +1717,9 @@ static int connectsock(void *addr, socklen_t alen, struct sock_args *args)
 	if (set_dsfield(sd, args->version, args->dsfield) != 0)
 		goto err;
 
+	if (args->dontroute && set_dontroute(sd) != 0)
+		goto err;
+
 	if (args->dev && bind_to_device(sd, args->dev) != 0)
 		goto err;
 	else if (args->use_setsockopt &&
@@ -1902,7 +1924,7 @@ static int ipc_parent(int cpid, int fd, struct sock_args *args)
 	return client_status;
 }
 
-#define GETOPT_STR  "sr:l:c:Q:p:t:g:P:DRn:M:X:m:d:I:BN:O:SUCi6xL:0:1:2:3:Fbqf"
+#define GETOPT_STR  "sr:l:c:Q:Gp:t:g:P:DRn:M:X:m:d:I:BN:O:SUCi6xL:0:1:2:3:Fbqf"
 #define OPT_FORCE_BIND_KEY_IFINDEX 1001
 #define OPT_NO_BIND_KEY_IFINDEX 1002
 
@@ -1935,6 +1957,9 @@ static void print_usage(char *prog)
 	"    -c addr       local address to bind to in client mode\n"
 	"    -Q dsfield    DS Field value of the socket (the IP_TOS or\n"
 	"                  IPV6_TCLASS socket option)\n"
+	"    -G            don't use gateways: send packets only if\n"
+	"                  destination is on link (see SO_DONTROUTE in\n"
+	"                  socket(7))\n"
 	"    -x            configure XFRM policy on socket\n"
 	"\n"
 	"    -d dev        bind socket to given device name\n"
@@ -2020,6 +2045,9 @@ int main(int argc, char *argv[])
 			}
 			args.dsfield = tmp;
 			break;
+		case 'G':
+			args.dontroute = 1;
+			break;
 		case 'p':
 			if (str_to_uint(optarg, 1, 65535, &tmp) != 0) {
 				fprintf(stderr, "Invalid port\n");
-- 
2.30.2


