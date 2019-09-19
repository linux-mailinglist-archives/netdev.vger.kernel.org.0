Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02FF6B7630
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 11:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388581AbfISJYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 05:24:51 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:50668 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387637AbfISJYu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Sep 2019 05:24:50 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id CE2362054D;
        Thu, 19 Sep 2019 11:24:48 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id YS69durkIpOQ; Thu, 19 Sep 2019 11:24:48 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 5C12220082;
        Thu, 19 Sep 2019 11:24:48 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Thu, 19 Sep 2019
 11:24:47 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id E340B318022F;
 Thu, 19 Sep 2019 11:24:47 +0200 (CEST)
Date:   Thu, 19 Sep 2019 11:24:47 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     Network Development <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH RFC v3 2/5] net: Add NETIF_F_GRO_LIST feature
Message-ID: <20190919092447.GJ2879@gauss3.secunet.de>
References: <20190918072517.16037-1-steffen.klassert@secunet.com>
 <20190918072517.16037-3-steffen.klassert@secunet.com>
 <CA+FuTSeBmGY4_2X3Ydhf60G=An9g9iikDBQMDji=XptN_jBqiw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CA+FuTSeBmGY4_2X3Ydhf60G=An9g9iikDBQMDji=XptN_jBqiw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 18, 2019 at 12:10:31PM -0400, Willem de Bruijn wrote:
> On Wed, Sep 18, 2019 at 3:25 AM Steffen Klassert
> <steffen.klassert@secunet.com> wrote:
> >
> > This adds a new NETIF_F_GRO_LIST feature flag. I will be used
> > to configure listfyed GRO what will be implemented with some
> > followup paches.
> 
> This should probably simultaneously introduce SKB_GSO_FRAGLIST as well
> as a BUILD_BUG_ON in net_gso_ok.

Yes, good point. I'll also rename NETIF_F_GRO_LIST to NETIF_F_GRO_FRAGLIST
and add NETIF_F_GSO_FRAGLIST what is currently missing.

> 
> Please also in the commit describe the constraints of skbs that have
> this type. If I'm not mistaken, an skb with either gso_size linear
> data or one gso_sized frag, followed by a frag_list of the same. With
> the exception of the last frag_list member, whose mss may be less than
> gso_size. This will help when reasoning about all the types of skbs we
> may see at segmentation, as we recently had to do [1]

We don't use skb_segment(), so I think we don't have this constraint.

> 
> Minor nit: I think it's listified, not listifyed.

I think neither of both words really exist :)
I'll rename it to fraglist GRO.

