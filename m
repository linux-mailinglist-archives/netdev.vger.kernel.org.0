Return-Path: <netdev+bounces-1151-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E8E96FC5BF
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 14:02:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 318EF1C209C1
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 12:02:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE707182A3;
	Tue,  9 May 2023 12:02:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7763C02
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 12:02:42 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CA36DD
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 05:02:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683633760;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=toJuReQ5Kf/WDhdY4SWki9E6J2YIApvV3bMviHGwKXU=;
	b=jJvJ3mGg5C8ZQj4X9S6fwUmm1j1zX4VuVtETTrmSeHvWOloKB6zsqhXqq6zg4zfpSkYRIf
	jfLbhmF81O5Sd2sgBYqtqHIcA+FQ4z5zALoSNhz7Wo711tFVnHWauV2RVFhv8NHd+9XfSE
	FbaJ/bhBoA3eTxVIXGxfo2dz+0ZR3GQ=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-461-BFr4tHeJOqqtK1Rn3gmA2g-1; Tue, 09 May 2023 08:02:38 -0400
X-MC-Unique: BFr4tHeJOqqtK1Rn3gmA2g-1
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-3f41dcf1e28so11849555e9.3
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 05:02:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683633757; x=1686225757;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=toJuReQ5Kf/WDhdY4SWki9E6J2YIApvV3bMviHGwKXU=;
        b=Oz7Tnsw61+Fg8jOmBKfgeqGcWalSzNxoo99PEM6hXSncqUeswqaT1ibiBniIyJ8afC
         xp7AyjbGflq0lYzc84paxCt3i7ws+4KulTdRu+q3lBri3H99LgZAfZELboas6Y2IlNFq
         9ctAqdRYHLItrcl4VTe/dn74Xh3GYwsTbrSyIZkmcvpp5EWFNFTFqA+0R99cb2j9vtGb
         Qasi6uSrO0cdALB7sWaSAHxXppjfEngyu7EbDKU4w3G8+YfWiJEI5RgPwtfJ1Irr4t6l
         jOdZxEUCGcUown76u0vp3KhsB4p1iYAWDMpHpkWHosP/UTejBqlTMFoX2mNMDEqRMA7+
         BR5w==
X-Gm-Message-State: AC+VfDwEeCk5c/kCp9b9VAAKaU8YN+tScpSmKXdsnNIBeraEgkWH8FPc
	gv+CJC6/oTr4Vol6LMfMvkijHeytqjqbN5ey8d5fiLlJLUXZgkYLKCpDt/voeLVRt45d95AJA1Y
	3xHhJeTjR7vdG8CD3
X-Received: by 2002:a05:600c:21ca:b0:3f4:2c46:e74f with SMTP id x10-20020a05600c21ca00b003f42c46e74fmr1160625wmj.12.1683633757638;
        Tue, 09 May 2023 05:02:37 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4Jcw+7WM3PxbwPgO57X51v0cak3B50gziqLSjfjfYGj1ZUPLFlCkfc8wUbdkQebdDAcvqu0w==
X-Received: by 2002:a05:600c:21ca:b0:3f4:2c46:e74f with SMTP id x10-20020a05600c21ca00b003f42c46e74fmr1160607wmj.12.1683633757301;
        Tue, 09 May 2023 05:02:37 -0700 (PDT)
Received: from debian (2a01cb058918ce005a3b5dcb9dbff7d2.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:5a3b:5dcb:9dbf:f7d2])
        by smtp.gmail.com with ESMTPSA id j15-20020a05600c1c0f00b003f1738d0d13sm2342100wms.1.2023.05.09.05.02.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 May 2023 05:02:36 -0700 (PDT)
Date: Tue, 9 May 2023 14:02:35 +0200
From: Guillaume Nault <gnault@redhat.com>
To: David Miller <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>
Cc: netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>
Subject: [PATCH net-next 0/4] selftests: fcnal: Test SO_DONTROUTE socket
 option.
Message-ID: <cover.1683626501.git.gnault@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The objective is to cover kernel paths that use the RTO_ONLINK flag
in .flowi4_tos. This way we'll be able to safely remove this flag in
the future by properly setting .flowi4_scope instead. With these
selftests in place, we can make sure this won't introduce regressions.

For more context, the final objective is to convert .flowi4_tos to
dscp_t, to ensure that ECN bits don't influence route and fib-rule
lookups (see commit a410a0cf9885 ("ipv6: Define dscp_t and stop taking
ECN bits into account in fib6-rules")).

These selftests only cover IPv4, as SO_DONTROUTE has no effect on IPv6
sockets.

Guillaume Nault (4):
  selftests: Add SO_DONTROUTE option to nettest.
  selftests: fcnal: Test SO_DONTROUTE on TCP sockets.
  selftests: fcnal: Test SO_DONTROUTE on UDP sockets.
  selftests: fcnal: Test SO_DONTROUTE on raw and ping sockets.

 tools/testing/selftests/net/fcnal-test.sh | 105 ++++++++++++++++++++++
 tools/testing/selftests/net/nettest.c     |  32 ++++++-
 2 files changed, 135 insertions(+), 2 deletions(-)

-- 
2.30.2


