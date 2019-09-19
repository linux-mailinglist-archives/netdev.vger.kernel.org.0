Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDF61B788B
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 13:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389937AbfISLgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 07:36:43 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:57724 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389926AbfISLgn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Sep 2019 07:36:43 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 1BC86205B2;
        Thu, 19 Sep 2019 13:36:41 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id bo43BjrrLMSX; Thu, 19 Sep 2019 13:36:40 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id AE839201AE;
        Thu, 19 Sep 2019 13:36:40 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Thu, 19 Sep 2019
 13:36:38 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 614B5318022F;
 Thu, 19 Sep 2019 13:36:40 +0200 (CEST)
Date:   Thu, 19 Sep 2019 13:36:40 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     <marcelo.leitner@gmail.com>, <willemdebruijn.kernel@gmail.com>,
        <netdev@vger.kernel.org>, <pabeni@redhat.com>
Subject: Re: [PATCH RFC v3 0/5] Support fraglist GRO/GSO
Message-ID: <20190919113640.GO2879@gauss3.secunet.de>
References: <CA+FuTSdVFguDHXYPJBRrLhzPWBaykd+7PRqEmGf_eOFC3iHpAg@mail.gmail.com>
 <20190918165817.GA3431@localhost.localdomain>
 <20190919110125.GN2879@gauss3.secunet.de>
 <20190919.131816.1861650130627229336.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190919.131816.1861650130627229336.davem@davemloft.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 19, 2019 at 01:18:16PM +0200, David Miller wrote:
> From: Steffen Klassert <steffen.klassert@secunet.com>
> Date: Thu, 19 Sep 2019 13:01:25 +0200
> 
> > If the packet data of all the fraglist GRO skbs are backed by a
> > page fragment then we could just do the same by iterating with
> > skb_walk_frags(). I'm not a driver expert and might be misstaken,
> > but it looks like that could be done with existing hardware that
> > supports segmentation offload.
> 
> Having to add frag list as well as page frag iterating in a driver is
> quite a bit of logic, and added complexity.
> 
> If the frag list SKBs are indeed backed by a page, you could just as
> easily coalesce everything into the page frag array of the first SKB.

That is true indeed. Fraglist GRO is more optimized to the case
where we still need the skb arround the packet data. I.e. if it 
can't be offloaded.
