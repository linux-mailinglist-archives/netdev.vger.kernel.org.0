Return-Path: <netdev+bounces-1274-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AC1A36FD27E
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 00:17:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7ECB3281135
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 22:17:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A841719E60;
	Tue,  9 May 2023 22:16:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BB1119E4B
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 22:16:23 +0000 (UTC)
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5220A3A87
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 15:16:22 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id 5b1f17b1804b1-3f42b984405so9829635e9.3
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 15:16:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google; t=1683670581; x=1686262581;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lc+xA7tlcC6A/HLIGYglx4S12hhfgqdXTKqlDOHD+8g=;
        b=MzlgfUUAYES98I8Blt0uDfqbqzdhCiYd3z2QxUhekOknoxQbNIgpLRyzMq1Xmch7h8
         HItqYCSavUCqWy6kHsNZ0BcKI0OVSRDn6fwwYEQTXfplkFaQkswuICiX2I3//M9E6kAB
         P2nMX2EJLEkjUiRmfAAJoiyX555vwsTfgrWbc6FYyR/Pab9SfAR5yRxBmcBmTuaTDhmf
         jz/2BVV0PIEB5rr4S6tBalg4PrONuoUJJVDKZoAR+ajpq3NwV9XoZ8Lq2Nc2Avbp4q9O
         tXCn4Yl6HwngLAP+Lu+i6S3wv4Uhh/lPDtEwx1EtJpazHkWWT3scsIQqIIemzg+mHVwv
         Jrdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683670581; x=1686262581;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lc+xA7tlcC6A/HLIGYglx4S12hhfgqdXTKqlDOHD+8g=;
        b=GbR93vnbfIvUxTc5mrnuDVSLFYgAzW4xrmPmRO69pHNlyIiNlkAFFHzq0FmH6cK510
         yeTwDa1W29rEsQ3g3WBQwZW1n13RqLRNqu0lZqhL9D1Gd8jjkbeycEwVJL7ieYbIjh+A
         zOxaGqZM4588G95nYtSwlREUxTJFw90AcSM8jHCwr2Ed+OH3tXbDoF40Vq1X4cEeaYeH
         dnajLOP7LVYtwC1ynTCehOwhMq+CHO5INa+GvvYT4u5yzjBFNkfUQOWSZoJmgGHRgZsx
         ptsIe9MRNE375o4Cx5R8lSHMB6UfwRMNWpt1EovvrIM/PVU8jILa5i8IaIgNBJ0BO47r
         Zi+Q==
X-Gm-Message-State: AC+VfDx7d3ak9sBd4LkTAInCAdoofb6etj6Y3aN64FZ7D/NQUTwX7Gdx
	q0Tzxcm6XA+pVfWSp9GU0FQ2mA==
X-Google-Smtp-Source: ACHHUZ53khA8ZUPP0QlnwjV+NGrdwIuAZcQJbHfVX3TMwqEq0wSrQhmpuHxdHD0QKJFqU+ila5I/Bg==
X-Received: by 2002:a1c:f20a:0:b0:3f1:819d:d050 with SMTP id s10-20020a1cf20a000000b003f1819dd050mr10537973wmc.37.1683670580862;
        Tue, 09 May 2023 15:16:20 -0700 (PDT)
Received: from Mindolluin.ire.aristanetworks.com ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id t25-20020a7bc3d9000000b003f42d3111b8sm2052888wmj.30.2023.05.09.15.16.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 15:16:20 -0700 (PDT)
From: Dmitry Safonov <dima@arista.com>
To: linux-kernel@vger.kernel.org,
	David Ahern <dsahern@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>
Cc: Dmitry Safonov <dima@arista.com>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
	Leonard Crestez <cdleonard@gmail.com>,
	Salam Noureddine <noureddine@arista.com>,
	netdev@vger.kernel.org
Subject: [RFC 5/5] net/tcp-md5: Don't send ACK if key (dis)appears
Date: Tue,  9 May 2023 23:16:08 +0100
Message-Id: <20230509221608.2569333-6-dima@arista.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230509221608.2569333-1-dima@arista.com>
References: <20230509221608.2569333-1-dima@arista.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

To mirror RST paranoid checks and tcp_inbound_md5_hash().

Signed-off-by: Dmitry Safonov <dima@arista.com>
---
 net/ipv4/tcp_ipv4.c | 2 ++
 net/ipv6/tcp_ipv6.c | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index d94cd5e70d58..0c8893240f70 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -918,6 +918,8 @@ static void tcp_v4_send_ack(const struct sock *sk,
 	rep.th.window  = htons(win);
 
 #ifdef CONFIG_TCP_MD5SIG
+	if (unlikely(!!key != !!tcp_parse_md5sig_option(th)))
+		return;
 	if (key) {
 		int offset = (tsecr) ? 3 : 0;
 
diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index 498dfa194b8b..4131ada9fabf 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -863,6 +863,8 @@ static void tcp_v6_send_response(const struct sock *sk, struct sk_buff *skb, u32
 	if (tsecr)
 		tot_len += TCPOLEN_TSTAMP_ALIGNED;
 #ifdef CONFIG_TCP_MD5SIG
+	if (!rst && unlikely(!!key != !!tcp_parse_md5sig_option(th)))
+		return;
 	if (key)
 		tot_len += TCPOLEN_MD5SIG_ALIGNED;
 #endif
-- 
2.40.0


