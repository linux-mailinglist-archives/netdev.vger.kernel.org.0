Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69E051EC8CC
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 07:29:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725807AbgFCF3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 01:29:08 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31593 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725275AbgFCF3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 01:29:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591162145;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xNVdNTJykIgXntfyZGGGb9JsxUOLAT7J/N2JWA0NTcE=;
        b=i/I+vpluH0UTJJ0hVsPOhM8o7rm+ohHZidu+r6rdniULazZ2VxHPqaPir2LSn8gavgqcnG
        PbBvCbEK+X+Tc1LtuzNOLaByRZZqDT8J1RdrQlA/LaiVzOvpcHO6rLh/Wc0Ul+rURO9BYW
        jLyq/d2oLran82uRb4hFwnuxwuu8HgY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-AJyT1sCfPWqts4-17toVDA-1; Wed, 03 Jun 2020 01:29:04 -0400
X-MC-Unique: AJyT1sCfPWqts4-17toVDA-1
Received: by mail-wr1-f69.google.com with SMTP id p9so604243wrx.10
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 22:29:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xNVdNTJykIgXntfyZGGGb9JsxUOLAT7J/N2JWA0NTcE=;
        b=PkRSgk8MaAxKU+P474ksIXFTsnHzKvQnpULs0CcKMm26/dcFfmh5lLDsY7K7DENgPj
         xB4vx2OOevmzbh0HZwSzzXU4iS1gW2urqmXOnEPLSAjaYETPPD4pvCBajslH68r6SA6z
         i5Lq/W9zAPpHoeb7PCWRQf0KEls/Cp+B+80xcVduM+0WqsjNx8KdRG+3dTkKfRq5uyPw
         dTuXGLWKZUpJBAySIwBFCzYJUreDRMJl1NKc/dn2hXklftbtgZ5agZjql3G9V7bDroAk
         0o4nOmtB0Ye8yZJoC+BjH/NCt0+wIqhg2K8oF95v+BfNAjxUO4QJ5D2zOgw1EdLJjkAT
         qnUw==
X-Gm-Message-State: AOAM530Cqy2Dwm3IprNFL9gIDtaB/RmhtD2Gdxe2OFFMbFXmUC4XG1iR
        gUkFFmERxz5AeKn48wcc7MbC44TS3FLQ1231XmJP0a5R4CHJ9vAS4cazUOzRVuGYc7FEDR13BN2
        4YKqc4I2ndc7vmYpV
X-Received: by 2002:a5d:5261:: with SMTP id l1mr30015742wrc.246.1591162143067;
        Tue, 02 Jun 2020 22:29:03 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzatHie8R5GxYMNVKDHlOh0ilfiE7KgXoOGtC9FzER3y1IyDQTbS3WNBoItX96AFMH7YDa8vA==
X-Received: by 2002:a5d:5261:: with SMTP id l1mr30015727wrc.246.1591162142746;
        Tue, 02 Jun 2020 22:29:02 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id y5sm1588673wrs.63.2020.06.02.22.29.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 22:29:02 -0700 (PDT)
Date:   Wed, 3 Jun 2020 01:29:00 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH RFC] uaccess: user_access_begin_after_access_ok()
Message-ID: <20200603011810-mutt-send-email-mst@kernel.org>
References: <20200602084257.134555-1-mst@redhat.com>
 <20200603014815.GR23230@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603014815.GR23230@ZenIV.linux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 03, 2020 at 02:48:15AM +0100, Al Viro wrote:
> On Tue, Jun 02, 2020 at 04:45:05AM -0400, Michael S. Tsirkin wrote:
> > So vhost needs to poke at userspace *a lot* in a quick succession.  It
> > is thus benefitial to enable userspace access, do our thing, then
> > disable. Except access_ok has already been pre-validated with all the
> > relevant nospec checks, so we don't need that.  Add an API to allow
> > userspace access after access_ok and barrier_nospec are done.
> 
> BTW, what are you going to do about vq->iotlb != NULL case?  Because
> you sure as hell do *NOT* want e.g. translate_desc() under STAC.
> Disable it around the calls of translate_desc()?
> 
> How widely do you hope to stretch the user_access areas, anyway?

So ATM I'm looking at adding support for the packed ring format.
That does something like:


get_user(flags, desc->flags)
smp_rmb()
if (flags & VALID)
copy_from_user(&adesc, desc, sizeof adesc);


this would be a good candidate I think.






> BTW, speaking of possible annotations: looks like there's a large
> subset of call graph that can be reached only from vhost_worker()
> or from several ioctls, with all uaccess limited to that subgraph
> (thankfully).  Having that explicitly marked might be a good idea...

Sure. What's a good way to do that though? Any examples to follow?
Or do you mean code comments?


> Unrelated question, while we are at it: is there any point having
> vhost_get_user() a polymorphic macro?  In all callers the third
> argument is __virtio16 __user * and the second one is an explicit
> *<something> where <something> is __virtio16 *.  Similar for
> vhost_put_user(): in all callers the third arugment is
> __virtio16 __user * and the second - cpu_to_vhost16(vq, something).
> 
> Incidentally, who had come up with the name __vhost_get_user?
> Makes for lovey WTF moment for readers - esp. in vhost_put_user()...


Good points, I'll fix these.

-- 
MST

