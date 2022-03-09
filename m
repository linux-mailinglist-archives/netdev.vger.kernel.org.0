Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3BA84D3B68
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 21:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235370AbiCIUyJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 15:54:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232954AbiCIUyI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 15:54:08 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B06CCC72
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 12:53:08 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 8E0E320569;
        Wed,  9 Mar 2022 21:53:06 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 5EjbFNw-DdHs; Wed,  9 Mar 2022 21:53:06 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 13FA8201D3;
        Wed,  9 Mar 2022 21:53:06 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id 0C75780004A;
        Wed,  9 Mar 2022 21:53:06 +0100 (CET)
Received: from mbx-essen-02.secunet.de (10.53.40.198) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.18; Wed, 9 Mar 2022 21:53:05 +0100
Received: from moon.secunet.de (172.18.149.2) by mbx-essen-02.secunet.de
 (10.53.40.198) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Wed, 9 Mar
 2022 21:53:05 +0100
Date:   Wed, 9 Mar 2022 21:52:58 +0100
From:   Antony Antony <antony.antony@secunet.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     David Ahern <dsahern@gmail.com>, <netdev@vger.kernel.org>,
        Matt Ellison <matt@arroyo.io>,
        Eyal Birger <eyal.birger@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH iproute2] testsuite: link xfrm delete no if_id test
Message-ID: <ae4f7181d7ff016c262b638e3dd42d708833d5b1.1646858967.git.antony.antony@secunet.com>
Reply-To: <antony.antony@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Organization: secunet
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-02.secunet.de (10.53.40.198)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since kernel commit 8dce43919566 ("xfrm: interface with if_id 0 should return error")
if_id should be non zero.
Delete the test without if_id, which defaulted if_id to zero.

Reported-by: Stephen Hemminger <stephen@networkplumber.org>
Signed-off-by: Antony Antony <antony.antony@secunet.com>
---
 testsuite/tests/ip/link/add_type_xfrm.t | 15 ---------------
 1 file changed, 15 deletions(-)

diff --git a/testsuite/tests/ip/link/add_type_xfrm.t b/testsuite/tests/ip/link/add_type_xfrm.t
index 78ce28e0..caba0e46 100755
--- a/testsuite/tests/ip/link/add_type_xfrm.t
+++ b/testsuite/tests/ip/link/add_type_xfrm.t
@@ -15,18 +15,3 @@ test_on "$NEW_DEV"
 test_on "if_id $IF_ID"

 ts_ip "$0" "Del $NEW_DEV xfrm interface"   link del dev $NEW_DEV
-
-
-ts_log "[Testing Add XFRM Interface, No IF-ID]"
-
-PHYS_DEV="lo"
-NEW_DEV="$(rand_dev)"
-IF_ID="0xf"
-
-ts_ip "$0" "Add $NEW_DEV xfrm interface"    link add dev $NEW_DEV type xfrm dev $PHYS_DEV
-
-ts_ip "$0" "Show $NEW_DEV xfrm interface"   -d link show dev $NEW_DEV
-test_on "$NEW_DEV"
-test_on_not "if_id $IF_ID"
-
-ts_ip "$0" "Del $NEW_DEV xfrm interface"   link del dev $NEW_DEV
--
2.30.2

