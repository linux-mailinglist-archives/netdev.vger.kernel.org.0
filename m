Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87B6763E1B1
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 21:17:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbiK3UR0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 15:17:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbiK3URK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 15:17:10 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 442CE1B788
        for <netdev@vger.kernel.org>; Wed, 30 Nov 2022 12:12:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669839149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=O/ACbPWJzhL/TJjykISR4TVd2EF9AhDhJnsvcQ5tN5U=;
        b=SGG2AZmbFmIAj05FHCMf5d30Nb6KWKzCjRdRhJgUYaWumcIfrP+i/mjSSUmmYiwqoJXzOV
        j0Lf4ui7qtaU70JtNRQ83KXHFZuXeRCmW6kNn6uboNRtAHNWG/WqMBS7I9Le4yJtj4P/Xl
        T99sm7wHzUF9zYjD0U9EWtYBBGt8K4Q=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-629-V1fGSWfFOQSbZI-WI4qzng-1; Wed, 30 Nov 2022 15:12:25 -0500
X-MC-Unique: V1fGSWfFOQSbZI-WI4qzng-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EDAE5801585;
        Wed, 30 Nov 2022 20:12:24 +0000 (UTC)
Received: from jtoppins.rdu.csb (unknown [10.22.32.182])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 834A8C15BB4;
        Wed, 30 Nov 2022 20:12:24 +0000 (UTC)
From:   Jonathan Toppins <jtoppins@redhat.com>
To:     netdev@vger.kernel.org
Cc:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/2] Documentation: bonding: correct xmit hash steps
Date:   Wed, 30 Nov 2022 15:12:07 -0500
Message-Id: <32b70509bb70966e13512c1b33958e1e52dbd81d.1669839127.git.jtoppins@redhat.com>
In-Reply-To: <4c3f4f0b8f4a8cd3c104d58c106b97ce5f180bc1.1669839127.git.jtoppins@redhat.com>
References: <4c3f4f0b8f4a8cd3c104d58c106b97ce5f180bc1.1669839127.git.jtoppins@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Correct xmit hash steps for layer3+4 as introduced by commit
49aefd131739 ("bonding: do not discard lowest hash bit for non layer3+4
hashing").

Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
---
 Documentation/networking/bonding.rst | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/networking/bonding.rst b/Documentation/networking/bonding.rst
index da57aac73ffc..adc4bf4f3c50 100644
--- a/Documentation/networking/bonding.rst
+++ b/Documentation/networking/bonding.rst
@@ -957,6 +957,7 @@ xmit_hash_policy
 		hash = hash XOR source IP XOR destination IP
 		hash = hash XOR (hash RSHIFT 16)
 		hash = hash XOR (hash RSHIFT 8)
+		hash = hash RSHIFT 1
 		And then hash is reduced modulo slave count.
 
 		If the protocol is IPv6 then the source and destination
-- 
2.31.1

