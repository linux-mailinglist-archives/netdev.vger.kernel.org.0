Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B79BB767F
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 11:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388903AbfISJlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 05:41:09 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:52012 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388084AbfISJlJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Sep 2019 05:41:09 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id AE654205E5;
        Thu, 19 Sep 2019 11:41:07 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 1Ck0EFH89DYn; Thu, 19 Sep 2019 11:41:07 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 43E9A20082;
        Thu, 19 Sep 2019 11:41:07 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Thu, 19 Sep 2019
 11:41:05 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id E7FA7318022F;
 Thu, 19 Sep 2019 11:41:06 +0200 (CEST)
Date:   Thu, 19 Sep 2019 11:41:06 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     Network Development <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, <marcelo.leitner@gmail.com>
Subject: Re: [PATCH RFC v3 0/5] Support fraglist GRO/GSO
Message-ID: <20190919094106.GM2879@gauss3.secunet.de>
References: <20190918072517.16037-1-steffen.klassert@secunet.com>
 <CA+FuTSdVFguDHXYPJBRrLhzPWBaykd+7PRqEmGf_eOFC3iHpAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CA+FuTSdVFguDHXYPJBRrLhzPWBaykd+7PRqEmGf_eOFC3iHpAg@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 18, 2019 at 12:17:08PM -0400, Willem de Bruijn wrote:
> On Wed, Sep 18, 2019 at 3:25 AM Steffen Klassert
> <steffen.klassert@secunet.com> wrote:
> >
> > This patchset adds support to do GRO/GSO by chaining packets
> > of the same flow at the SKB frag_list pointer. This avoids
> > the overhead to merge payloads into one big packet, and
> > on the other end, if GSO is needed it avoids the overhead
> > of splitting the big packet back to the native form.
> >
> > Patch 1 Enables UDP GRO by default.
> >
> > Patch 2 adds a netdev feature flag to enable listifyed GRO,
> > this implements one of the configuration options discussed
> > at netconf 2019.
> >
> > Patch 3 adds a netdev software feature set that defaults to off
> > and assigns the new listifyed GRO feature flag to it.
> >
> > Patch 4 adds the core infrastructure to do fraglist GRO/GSO.
> >
> > Patch 5 enables UDP to use fraglist GRO/GSO if configured and no
> > GRO supported socket is found.
> 
> Very nice feature, Steffen.

Thanks!

> Aside from questions around performance,
> my only question is really how this relates to GSO_BY_FRAGS.
> 
> More specifically, whether we can remove that in favor of using your
> new skb_segment_list. That would actually be a big first step in
> simplifying skb_segment back to something manageable.

As Marcelo pointed out, this should be doable.

Thanks for all your review. I'll incorporate your comments and do
RFC v4, so that we hopefully can start the mainlining process as
soon as net-next opens again.
