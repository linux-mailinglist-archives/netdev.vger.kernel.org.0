Return-Path: <netdev+bounces-1154-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4775A6FC5C3
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 14:03:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 10DF828111B
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 12:03:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6E90182B5;
	Tue,  9 May 2023 12:02:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA724182A1
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 12:02:48 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E25D1A4
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 05:02:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683633766;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aU43Qs7UjsRBZNgfEytJf+FfsXtk10SwHaLmkca1aWQ=;
	b=N3OmVEV7P7/ryxlX8+vfnilhOu/wlvuiFFtSQKBOyvKYi6LBlh72t89A9av69Q7SwcNu1y
	/DZusufYhAiInQGPnyQZTFGUQFjxQxA5GCQChkhXhYweeDCqtcOiraV4EgYvf2Pv51f+Ui
	+OlxTACEjmyabNS0idASH3qaNIW9ngY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-195-17hI4DOLOqC6fMGGUXj3Og-1; Tue, 09 May 2023 08:02:44 -0400
X-MC-Unique: 17hI4DOLOqC6fMGGUXj3Og-1
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3062e5d0cd3so2299263f8f.3
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 05:02:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683633762; x=1686225762;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aU43Qs7UjsRBZNgfEytJf+FfsXtk10SwHaLmkca1aWQ=;
        b=HDO98Cb4pwhraOYRw3908rwqL74sdXT6ikM8IiSeHQQbdoc8aUbnj84tYPyK5enHdy
         Srop0gfH/vfObf9FUgxvrhmyKoVrc16rtr/RKhNSmP7apRwLR70av5BTWOooEgB0JoG+
         9ZzujmPumuWwzaG1tgrj2UiOcFCUad6+bQzdGjnQQzkvNsiTKMbUQcSIaO5nsglfHToc
         yc9h8AKtfRL/xgNZI47e5q80YrBM362qr2YIRPV9SkPBtwz5xUuF7GARVjsU7KivWSYI
         xs5GqBRJJumQlBc94lI07twiE2032Iem41+b/fWtENuIWkOt0KAXppGdOQa2BHZBM5mK
         Uc5Q==
X-Gm-Message-State: AC+VfDwfMXCR7k5Avq0+PNSsWlVT1upUpHmwnhU1PttuSp1ERnuJx949
	bWtmpDMbD/b5VlM/MuEWi75t/skLdJdiAW2lEuDGYGT+6eAEjQ2vGT98rXV13O9Hmnfp7KNoUyL
	qJMjhQvdSEaEk3A4X
X-Received: by 2002:a5d:6e81:0:b0:306:2f8e:d25f with SMTP id k1-20020a5d6e81000000b003062f8ed25fmr9368916wrz.16.1683633762411;
        Tue, 09 May 2023 05:02:42 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4PTc5BY7ay8+iZ6sF3vJzLijurw+woZq5XJFqrWHJ0I/mcBHLjJ/doZcQ7mRNxv97vU1IXBw==
X-Received: by 2002:a5d:6e81:0:b0:306:2f8e:d25f with SMTP id k1-20020a5d6e81000000b003062f8ed25fmr9368901wrz.16.1683633762148;
        Tue, 09 May 2023 05:02:42 -0700 (PDT)
Received: from debian (2a01cb058918ce005a3b5dcb9dbff7d2.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:5a3b:5dcb:9dbf:f7d2])
        by smtp.gmail.com with ESMTPSA id h1-20020a5d5481000000b0030647d1f34bsm14351106wrv.1.2023.05.09.05.02.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 05:02:41 -0700 (PDT)
Date: Tue, 9 May 2023 14:02:39 +0200
From: Guillaume Nault <gnault@redhat.com>
To: David Miller <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>
Cc: netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>
Subject: [PATCH net-next 4/4] selftests: fcnal: Test SO_DONTROUTE on raw and
 ping sockets.
Message-ID: <b2c3102805fafa2bd935ab8119af9229cb81f25c.1683626501.git.gnault@redhat.com>
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
index 23672cba8781..3321d1971bd8 100755
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


