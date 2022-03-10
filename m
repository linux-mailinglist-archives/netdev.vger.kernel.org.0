Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDEC14D414B
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 07:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239876AbiCJGnF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 01:43:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239864AbiCJGnF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 01:43:05 -0500
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E30E33B3
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 22:42:05 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 3DF5D201A0;
        Thu, 10 Mar 2022 07:42:03 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 9F9LUSBrpKC0; Thu, 10 Mar 2022 07:42:02 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 8523B20199;
        Thu, 10 Mar 2022 07:42:02 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 7F08D80004A;
        Thu, 10 Mar 2022 07:42:02 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.18; Thu, 10 Mar 2022 07:42:02 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Thu, 10 Mar
 2022 07:42:01 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 9E8EE31810D1; Thu, 10 Mar 2022 07:42:01 +0100 (CET)
Date:   Thu, 10 Mar 2022 07:42:01 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Haimin Zhang <tcs.kernel@gmail.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        Haimin Zhang <tcs_kernel@tencent.com>,
        TCS Robot <tcs_robot@tencent.com>
Subject: Re: [PATCH v2] af_key: add __GFP_ZERO flag for
 compose_sadb_supported in function pfkey_register
Message-ID: <20220310064201.GG1791239@gauss3.secunet.de>
References: <20220308032028.48779-1-tcs.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220308032028.48779-1-tcs.kernel@gmail.com>
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

On Tue, Mar 08, 2022 at 11:20:28AM +0800, Haimin Zhang wrote:
> From: Haimin Zhang <tcs_kernel@tencent.com>
> 
> Add __GFP_ZERO flag for compose_sadb_supported in function pfkey_register
> to initialize the buffer of supp_skb to fix a kernel-info-leak issue.
> 1) Function pfkey_register calls compose_sadb_supported to request 
> a sk_buff. 2) compose_sadb_supported calls alloc_sbk to allocate
> a sk_buff, but it doesn't zero it. 3) If auth_len is greater 0, then
> compose_sadb_supported treats the memory as a struct sadb_supported and
> begins to initialize. But it just initializes the field sadb_supported_len
> and field sadb_supported_exttype without field sadb_supported_reserved.
> 
> Reported-by: TCS Robot <tcs_robot@tencent.com>
> Signed-off-by: Haimin Zhang <tcs_kernel@tencent.com>

Applied, thanks a lot!
