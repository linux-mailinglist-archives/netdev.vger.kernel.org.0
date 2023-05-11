Return-Path: <netdev+bounces-1846-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AD366FF4A7
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 16:39:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 640C11C20F3F
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 14:39:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A1C136D;
	Thu, 11 May 2023 14:39:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E627620
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 14:39:27 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8347C13280
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 07:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1683815964;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=bZ7Q0rNDPDrrhxTKfmPgoi35Uu4qvx3L1i5jgXfiW38=;
	b=POukJ+KTmI0k99y4qxG9+keqGQkEe0wOxrw3LA0pdQj9i8+geTIXZyXvL3f3dieMJQjpPF
	aaqPrmXEoB+k/LXsDnz7MAJbg9aHG622qg7YsEhuuyllqeMT6+xHdYM4l87nOhTvIEOQBz
	HOC9n1VbALX4NibgigBn3f4gmD9jJ/g=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-608-QylxVAWgPnugbL8JumlrPA-1; Thu, 11 May 2023 10:39:23 -0400
X-MC-Unique: QylxVAWgPnugbL8JumlrPA-1
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-2f2981b8364so5323121f8f.1
        for <netdev@vger.kernel.org>; Thu, 11 May 2023 07:39:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683815962; x=1686407962;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bZ7Q0rNDPDrrhxTKfmPgoi35Uu4qvx3L1i5jgXfiW38=;
        b=avEYTtraouwl2YyLhxGjKgejf7VPRsQNov1xwRGWSWhxG/8u6GDCeZFUvI0wdgVgsU
         EA0aCBa08exhMs1X8o6+E9IksEdv2i5rE5rLmC0PD7YvrLWdNH56odpuZ7Vi8cKWMN3A
         RAVgo6FnjXCU4C23+DHQuoR31ealIuiyVzD196NQ2dgPT7fP+xkJ8QrlI1dlxIguIhCE
         JSZokOJnavaJgbvlvi0anJZ4lI8xsmxkNfytnpGBNXmliygzX+UFaovM9Jv/sWMIOHNE
         leZmcdiqn8BxFiLpb1xurNCaVAJGJ3UhePe00iu82AVcd4BcZRX6w0JZNmEfeqtufBr4
         p0Lw==
X-Gm-Message-State: AC+VfDweJpJYpGKIq2P781PPSqt3/la8z2n+y/IKlFfbNtV0tNTcJc/F
	zx26KUeJ1/bL+oSIxkewipNK7rP3eJdPFxIYC9k6dM+rFheKKsd1crA24qsctjcGU2z0RwaxLRR
	+I8DU3annqfpZBumU265G1f8E
X-Received: by 2002:a05:6000:136d:b0:307:9ed1:f0b3 with SMTP id q13-20020a056000136d00b003079ed1f0b3mr10768133wrz.18.1683815962101;
        Thu, 11 May 2023 07:39:22 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7prnKjn+OXdt4ptnJ79HTZAnGcvQ9mOyBzmEbcF0ciesSAQJ3EAtlR0/fm20JwXEfdwfIvig==
X-Received: by 2002:a05:6000:136d:b0:307:9ed1:f0b3 with SMTP id q13-20020a056000136d00b003079ed1f0b3mr10768105wrz.18.1683815961794;
        Thu, 11 May 2023 07:39:21 -0700 (PDT)
Received: from debian (2a01cb058918ce00af30fd5ba5292148.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:af30:fd5b:a529:2148])
        by smtp.gmail.com with ESMTPSA id s9-20020a5d5109000000b002ffbf2213d4sm20492704wrt.75.2023.05.11.07.39.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 07:39:21 -0700 (PDT)
Date: Thu, 11 May 2023 16:39:19 +0200
From: Guillaume Nault <gnault@redhat.com>
To: David Miller <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>
Cc: netdev@vger.kernel.org, David Ahern <dsahern@kernel.org>
Subject: [PATCH v2 net-next 0/4] selftests: fcnal: Test SO_DONTROUTE socket
 option.
Message-ID: <cover.1683814269.git.gnault@redhat.com>
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
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
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

v2:
  - Use two different nettest options for setting SO_DONTROUTE either
    on the server or on the client socket.

  - Use the above feature to run a single 'nettest -B' instance per
    test (instead of having two nettest processes for server and
    client).

Guillaume Nault (4):
  selftests: Add SO_DONTROUTE option to nettest.
  selftests: fcnal: Test SO_DONTROUTE on TCP sockets.
  selftests: fcnal: Test SO_DONTROUTE on UDP sockets.
  selftests: fcnal: Test SO_DONTROUTE on raw and ping sockets.

 tools/testing/selftests/net/fcnal-test.sh | 87 +++++++++++++++++++++++
 tools/testing/selftests/net/nettest.c     | 46 +++++++++++-
 2 files changed, 132 insertions(+), 1 deletion(-)

-- 
2.30.2


