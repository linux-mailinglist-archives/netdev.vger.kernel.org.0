Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECDACB688E
	for <lists+netdev@lfdr.de>; Wed, 18 Sep 2019 18:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732052AbfIRQ6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 12:58:23 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:35339 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731251AbfIRQ6X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 12:58:23 -0400
Received: by mail-qt1-f194.google.com with SMTP id m15so619008qtq.2
        for <netdev@vger.kernel.org>; Wed, 18 Sep 2019 09:58:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pijQu6eKSGmfswoNeqLzyr9j9vooWK4CRXZzJARiJQM=;
        b=ucGmsqQz9k0u/5Bjca6VbjLky8OK6vADef5dzOzIBYdnQaDwFDDtltyzx8gd/Cj7Ya
         H1ybW7RtXmdg1B8gKXXU7KwG2SOD6523jCCzt4sRtS27pycoPLgYGH5yKJbvAkmxqpgi
         m2qFpYam+UcYEnCLqm+XjrzPZWevD2htV2fpatQCjew7JDEYLP06K8uRFEFI7cevnQxL
         O3Ir5kmgSoe6NsOfvJ+mA1Wb09w3ry+OBbMPhGfbSEN0E58hqhi4P3wv6EUHY4Mjjutg
         PNgDoFWjy2om4g7Cy5UJU+CBmntCBcCbcG11NP2DaYa4VvtM9yjfCQOgrWOrMm4EEAi+
         dZDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pijQu6eKSGmfswoNeqLzyr9j9vooWK4CRXZzJARiJQM=;
        b=Q7VUrHt3/zMl6LoFju3nY1XE2jcf6TdhQz7DiS9pj0FKiNwy23PMgJVni3J40kx8tu
         te6FN4+3PlAaXMnaf85mkrCFYnxeSOhkJqTAqH8PnmARBLyqNnmneGepPGHQL5yd1fX9
         b7cbumrbyJzJzPEVBytFP0r3RUSfaVCWbQdl1h02K3LzhSLh1twrcBiIw4Fuw0uq3+Q9
         L79umBH5rF402miqm3HrBOjRIElbFdA2WVBmwjHtLynvlDod8Xc8tPo98ii+LNiVMAOx
         1FdFRSbFsaNd4v4+yETKoclSH8Gp8mBswAoZ56X685SXoSDJ4VSq29EX+Ozrxk7kxhE8
         58EQ==
X-Gm-Message-State: APjAAAWnuNbk9Lckr7feLOcBQ/Onc0nl3bvhILcItenkOMGFmYhA+hhn
        WKZ8gqx6IDpwnyL+/Su7re9zTCCfL20=
X-Google-Smtp-Source: APXvYqx1J/GD8FGmbXfzw1WnN8Cm2kUJYJ3TuM97xVl/Ox+SCe8TqOZipJ1jziRG8jDtnKI3QK7x2g==
X-Received: by 2002:ac8:65c9:: with SMTP id t9mr4841010qto.312.1568825902066;
        Wed, 18 Sep 2019 09:58:22 -0700 (PDT)
Received: from localhost.localdomain ([168.181.48.215])
        by smtp.gmail.com with ESMTPSA id e4sm2631142qkl.135.2019.09.18.09.58.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Sep 2019 09:58:20 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id BFF18C4A54; Wed, 18 Sep 2019 13:58:17 -0300 (-03)
Date:   Wed, 18 Sep 2019 13:58:17 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Network Development <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH RFC v3 0/5] Support fraglist GRO/GSO
Message-ID: <20190918165817.GA3431@localhost.localdomain>
References: <20190918072517.16037-1-steffen.klassert@secunet.com>
 <CA+FuTSdVFguDHXYPJBRrLhzPWBaykd+7PRqEmGf_eOFC3iHpAg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+FuTSdVFguDHXYPJBRrLhzPWBaykd+7PRqEmGf_eOFC3iHpAg@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
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
> Very nice feature, Steffen. Aside from questions around performance,
> my only question is really how this relates to GSO_BY_FRAGS.

They do the exact same thing AFAICT: they GSO according to a
pre-formatted list of fragments/packets, and not to a specific size
(such as MSS).

> 
> More specifically, whether we can remove that in favor of using your
> new skb_segment_list. That would actually be a big first step in
> simplifying skb_segment back to something manageable.

The main issue (that I know) on obsoleting GSO_BY_FRAGS is that
dealing with frags instead of frag_list was considered easier to be
offloaded, if ever attempted.  So this would be a step back on that
aspect.  Other than this, it should be doable.
