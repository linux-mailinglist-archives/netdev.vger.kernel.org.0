Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD92582543
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 13:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbiG0LSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 07:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiG0LSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 07:18:32 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C1BD7B7CE
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 04:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658920706;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=7k3HVTGSRUsrBZNnvZlAI9Am+2qyRQXYx0CQhkFznuM=;
        b=h3Hel3y0hTrIcP1FpTZiKJ7SNS3GEeDdtU0+2drxB+8Tc0NlDfChIkPJX6qqudvLenxPub
        IwJa/2CT2hrsao/OC9015QiWPtavDywUPGOJwXl9WU0rD2SgE1RsvHPo+iwH+ruJ98oVNA
        HPAqs5CHvKujPMH9KbWupYsOE477/u0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-648-B6wVptHMNsG0uD2P1yWSXg-1; Wed, 27 Jul 2022 07:18:25 -0400
X-MC-Unique: B6wVptHMNsG0uD2P1yWSXg-1
Received: by mail-wm1-f70.google.com with SMTP id az39-20020a05600c602700b003a321d33238so8947789wmb.1
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 04:18:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=7k3HVTGSRUsrBZNnvZlAI9Am+2qyRQXYx0CQhkFznuM=;
        b=zf46Wb7eRIwKLmF18p4OB9LiOdB4qmpejq86zGtRYBmNrkUwyL6UYXKkE0R04ciJ8g
         Vbj1wOCboobeBd54kgKMApfgetbDS73SAzwpJfXorYcWwbs6PihFzlSU5HxgsaDKMLGI
         VwF/ZM5eb87ntl5qeB39nLiip9YN4gYayJvjxa+eR0sx+5g52IhsH6lzqdTF/0LUYIZV
         ltOSmrwXARvgYSHRABuxolt5DySBJJ4PzyH4NkeHuuAswoz8iFkSQTzY0Rl6LEWtstF8
         wc04NSjUNMHGhAstSaw98L2oJSV+tq1TeiWVrygAv8LZXJDbQo+0NVSzi5swEOvMWDeX
         MdPw==
X-Gm-Message-State: AJIora/gqPK/9iY/bAdkBymC9a7BRHuKEh3mhb8yr+R7KHdqrpGRSPKQ
        udBIMEiqEhfC3QdaWfiZ3blCOdAI29vdVrfOsAsu7z1wOCp/ljsJjsSOH9MKQVsok4fc0TqAaiH
        WRpe/s/tlwyzxiXpJ
X-Received: by 2002:adf:d1c6:0:b0:21e:4f40:9029 with SMTP id b6-20020adfd1c6000000b0021e4f409029mr14239253wrd.719.1658920704517;
        Wed, 27 Jul 2022 04:18:24 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sa2gsQ6BbGLQeaNowdO7UHKQMe23+XbkAKMQ7BtzS25GGP9sppnD4ZAGn8edtOiIsqQs3wjA==
X-Received: by 2002:adf:d1c6:0:b0:21e:4f40:9029 with SMTP id b6-20020adfd1c6000000b0021e4f409029mr14239232wrd.719.1658920704190;
        Wed, 27 Jul 2022 04:18:24 -0700 (PDT)
Received: from pc-4.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id z18-20020a05600c0a1200b003a03185231bsm2137499wmp.31.2022.07.27.04.18.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 04:18:23 -0700 (PDT)
Date:   Wed, 27 Jul 2022 13:18:21 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        linux-doc@vger.kernel.org
Subject: [PATCH net-next] Documentation: Describe net.ipv4.tcp_reflect_tos.
Message-ID: <4376126910096258f0a9da93ec53cad99a072afc.1658920560.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tcp_reflect_tos option was introduced in Linux 5.10 but was still
undocumented.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 Documentation/networking/ip-sysctl.rst | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 5879ef3bc2cb..70f009f75e74 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -636,6 +636,16 @@ tcp_recovery - INTEGER
 
 	Default: 0x1
 
+tcp_reflect_tos - BOOLEAN
+	For listening sockets, reuse the DSCP value of the initial SYN message
+	for outgoing packets. This allows to have both directions of a TCP
+	stream to use the same DSCP value, assuming DSCP remains unchanged for
+	the lifetime of the connection.
+
+	This options affects both IPv4 and IPv6.
+
+	Default: 0 (disabled)
+
 tcp_reordering - INTEGER
 	Initial reordering level of packets in a TCP stream.
 	TCP stack can then dynamically adjust flow reordering level
-- 
2.21.3

