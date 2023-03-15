Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1AA6BAE77
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 12:05:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231204AbjCOLFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 07:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbjCOLFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 07:05:53 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95ACE80921
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 04:05:52 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 4298020539;
        Wed, 15 Mar 2023 12:05:51 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ZzcjKymLgSaC; Wed, 15 Mar 2023 12:05:50 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id B9E1F20533;
        Wed, 15 Mar 2023 12:05:50 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id A79B380004A;
        Wed, 15 Mar 2023 12:05:50 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Wed, 15 Mar 2023 12:05:50 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.17; Wed, 15 Mar
 2023 12:05:50 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 9DF5E3182EBA; Wed, 15 Mar 2023 12:05:49 +0100 (CET)
Date:   Wed, 15 Mar 2023 12:05:49 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     <netdev@vger.kernel.org>, David George <David.George@sophos.com>
Subject: Re: [PATCH] xfrm: Remove inner/outer modes from input path
Message-ID: <ZBGmjdCkUw8wNMWL@gauss3.secunet.de>
References: <ZAr3rc+QvKs50xkm@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZAr3rc+QvKs50xkm@gondor.apana.org.au>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 05:26:05PM +0800, Herbert Xu wrote:
> The inner/outer modes were added to abstract out common code that
> were once duplicated between IPv4 and IPv6.  As time went on the
> abstractions have been removed and we are now left with empty
> shells that only contain duplicate information.  These can be
> removed one-by-one as the same information is already present
> elsewhere in the xfrm_state object.
> 
> Removing them from the input path actually allows certain valid
> combinations that are currently disallowed.  In particular, when
> a transport mode SA sits beneath a tunnel mode SA that changes
> address families, at present the transport mode SA cannot have
> AF_UNSPEC as its selector because it will be erroneously be treated
> as inter-family itself even though it simply sits beneath one.
> 
> This is a serious problem because you can't set the selector to
> non-AF_UNSPEC either as that will cause the selector match to
> fail as we always match selectors to the inner-most traffic.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Applied to ipsec-next, thanks a lot Herbert!
