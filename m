Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46A9022BD75
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 07:27:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgGXF1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 01:27:24 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:56270 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726020AbgGXF1X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jul 2020 01:27:23 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 915462052E
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 07:27:22 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id lnogxqcCq7aQ for <netdev@vger.kernel.org>;
        Fri, 24 Jul 2020 07:27:22 +0200 (CEST)
Received: from mail-essen-02.secunet.de (mail-essen-02.secunet.de [10.53.40.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 2E9A3201A0
        for <netdev@vger.kernel.org>; Fri, 24 Jul 2020 07:27:22 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-02.secunet.de (10.53.40.205) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 24 Jul 2020 07:27:22 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 24 Jul
 2020 07:27:21 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 6D0F831805D5;
 Fri, 24 Jul 2020 07:27:21 +0200 (CEST)
Date:   Fri, 24 Jul 2020 07:27:21 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC ipsec] xfrm: Fix crash when the hold queue is used.
Message-ID: <20200724052721.GT20687@gauss3.secunet.de>
References: <20200717083427.GA20687@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200717083427.GA20687@gauss3.secunet.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 17, 2020 at 10:34:27AM +0200, Steffen Klassert wrote:
> The commits "xfrm: Move dst->path into struct xfrm_dst"
> and "net: Create and use new helper xfrm_dst_child()."
> changed xfrm bundle handling under the assumption
> that xdst->path and dst->child are not a NULL pointer
> only if dst->xfrm is not a NULL pointer. That is true
> with one exception. If the xfrm hold queue is used
> to wait until a SA is installed by the key manager,
> we create a dummy bundle without a valid dst->xfrm
> pointer. The current xfrm bundle handling crashes
> in that case. Fix this by extending the NULL check
> of dst->xfrm with a test of the DST_XFRM_QUEUE flag.
> 
> Fixes: 0f6c480f23f4 ("xfrm: Move dst->path into struct xfrm_dst")
> Fixes: b92cf4aab8e6 ("net: Create and use new helper xfrm_dst_child().")
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>

Now applied to the ipsec tree.
