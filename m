Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 441F5537557
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 09:24:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233086AbiE3HDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 03:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231735AbiE3HDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 03:03:03 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38116F4AC
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 00:03:00 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id DD7EB20504;
        Mon, 30 May 2022 09:02:57 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 6_XB_gEnEI_D; Mon, 30 May 2022 09:02:57 +0200 (CEST)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 279CF201AA;
        Mon, 30 May 2022 09:02:57 +0200 (CEST)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 2299B80004A;
        Mon, 30 May 2022 09:02:57 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Mon, 30 May 2022 09:02:57 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Mon, 30 May
 2022 09:02:56 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 2EE793182D2D; Mon, 30 May 2022 09:02:56 +0200 (CEST)
Date:   Mon, 30 May 2022 09:02:56 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Maciej =?utf-8?Q?=C5=BBenczykowski?= <maze@google.com>
CC:     Linux NetDev <netdev@vger.kernel.org>,
        Benedict Wong <benedictwong@google.com>,
        Yan Yan <evitayan@google.com>
Subject: Re: 5.18 breaks Android net test PFKEY AddSA test case
Message-ID: <20220530070256.GA2517843@gauss3.secunet.de>
References: <CANP3RGcW6DWei2bXrAQn8B4Uf0ggx_MgEfVyX_D7AaYZcYOchQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANP3RGcW6DWei2bXrAQn8B4Uf0ggx_MgEfVyX_D7AaYZcYOchQ@mail.gmail.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 28, 2022 at 01:54:25AM -0700, Maciej Żenczykowski wrote:
> I've not gotten to the bottom of the root cause, since I'm hoping
> someone will know off the top of their head,
> why this might now be broken...
> 
> ##### ./pf_key_test.py (13/25)
> 
> E
> ======================================================================
> ERROR: testAddDelSa (__main__.PfKeyTest)
> ----------------------------------------------------------------------
> Traceback (most recent call last):
>   File "./pf_key_test.py", line 42, in testAddDelSa
>     pf_key.SADB_X_AALG_SHA2_256HMAC, ENCRYPTION_KEY)
>   File "/aosp-tests/net/test/pf_key.py", line 254, in AddSa
>     self.SendAndRecv(msg, self.PackPfKeyExtensions(extlist))
>   File "/aosp-tests/net/test/pf_key.py", line 218, in SendAndRecv
>     return self.Recv()
>   File "/aosp-tests/net/test/pf_key.py", line 208, in Recv
>     raise OSError(msg.errno, os.strerror(msg.errno))
> OSError: [Errno 3] No such process
> 
> The failure is at
>   https://cs.android.com/android/platform/superproject/+/master:kernel/tests/net/test/pf_key_test.py;l=42
> ie.
> 
> ENCRYPTION_KEY =
> ("308146eb3bd84b044573d60f5a5fd15957c7d4fe567a2120f35bae0f9869ec22".decode("hex"))
> 
> src4 = csocket.Sockaddr(("192.0.2.1", 0))
> dst4 = csocket.Sockaddr(("192.0.2.2", 1))
> self.pf_key.AddSa(src4, dst4, 0xdeadbeef, pf_key.SADB_TYPE_ESP,
> pf_key.IPSEC_MODE_TRANSPORT, 54321,
> pf_key.SADB_X_EALG_AESCBC, ENCRYPTION_KEY,
> pf_key.SADB_X_AALG_SHA2_256HMAC, ENCRYPTION_KEY)

I guess that is because of

commit 4dc2a5a8f6754492180741facf2a8787f2c415d7
net: af_key: add check for pfkey_broadcast in function pfkey_process

This is already reverted in the ipsec tree and will go upstream
this week.
