Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C28A51EC3DA
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 22:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728364AbgFBUmK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 16:42:10 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:33880 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726174AbgFBUmK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 16:42:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591130528;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZbzXBMyP2ZV0xb1q05Ewy42EfhDuwN256DhtDnRLuUs=;
        b=Jd5sMa90xZxiZJYMGwExc1Q3AcEwiZ70WLLiqVmEYQUpxdsMLhlqot3CeDZM/ZWsqq9m9H
        PaRno97M8J4s1wpH8PZMP+qH4rwZa+2RxLC4tQgXIm2ixB4eeSuuBf8Fnmewwrlo/fcbGt
        nfX3ZAoG0PoOuceSzH72We7zBmAlDZM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-327-Vt_kCVqTPZO21wafZEjzJw-1; Tue, 02 Jun 2020 16:42:07 -0400
X-MC-Unique: Vt_kCVqTPZO21wafZEjzJw-1
Received: by mail-wr1-f69.google.com with SMTP id j16so22749wre.22
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 13:42:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZbzXBMyP2ZV0xb1q05Ewy42EfhDuwN256DhtDnRLuUs=;
        b=PPEBG93l0EtKrBVBNvvJF4vhvnWS3nCM5WYnykfC4vIwEypac1F3AKab3/D7NP4o/1
         fvfBSVbLFBqZhQET8o5EPtUKUUnoD5YjO1x38k/FTMUesvdAiKJjMrJ9BdhIvLG3NU8Z
         Gb0hsLa1hJDRKCkmaBWdIlr4SERDSwrfCV4VxW0z14uZY8WmGSt4K5ks3p9TJbtw8v77
         GEVMlV0Z9HryLldKX3bvIbIsqr3om/y6mEcahXhhAz7yWbjD2ZmwQyUFzO0VgJ5wlW/l
         KLGBj3/hg+qLCJwbW5OHLj0hw+WNMuFCG6zKfqNNSAmL6whhuPbTOaHOVigpI2wFKpBa
         7THQ==
X-Gm-Message-State: AOAM532YSOTSk32G24R7nFmLRh6nA4KGAO2kHpKT6k9BYaODeyDzbnm4
        AC14nDnPtAnHtKlYTv5u5iS5y+lYdaSDB/EZlVjoZ34yHGkZEB3wwrQ656AIIC11eglnc4uFa4q
        LkgDFCmv+/HTa07UN
X-Received: by 2002:a1c:9896:: with SMTP id a144mr4259285wme.75.1591130525945;
        Tue, 02 Jun 2020 13:42:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzMeM2kEvp4pkvEwdpNO5MlqKjkVW+xipN3ThJjTmbbysJGdPdXbitZwUdNzRZLA11N4P7CNg==
X-Received: by 2002:a1c:9896:: with SMTP id a144mr4259277wme.75.1591130525725;
        Tue, 02 Jun 2020 13:42:05 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id p10sm189217wra.78.2020.06.02.13.42.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 13:42:05 -0700 (PDT)
Date:   Tue, 2 Jun 2020 16:42:03 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH RFC] uaccess: user_access_begin_after_access_ok()
Message-ID: <20200602163937-mutt-send-email-mst@kernel.org>
References: <20200602084257.134555-1-mst@redhat.com>
 <20200602163048.GL23230@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200602163048.GL23230@ZenIV.linux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 02, 2020 at 05:30:48PM +0100, Al Viro wrote:
> On Tue, Jun 02, 2020 at 04:45:05AM -0400, Michael S. Tsirkin wrote:
> > So vhost needs to poke at userspace *a lot* in a quick succession.  It
> > is thus benefitial to enable userspace access, do our thing, then
> > disable. Except access_ok has already been pre-validated with all the
> > relevant nospec checks, so we don't need that.  Add an API to allow
> > userspace access after access_ok and barrier_nospec are done.
> 
> This is the wrong way to do it, and this API is certain to be abused
> elsewhere.  NAK - we need to sort out vhost-related problems, but
> this is not an acceptable solution.  Sorry.

OK so summarizing what you and Linus both said, we need at
least a way to make sure access_ok (and preferably the barrier too)
is not missed.

Another comment is about actually checking that performance impact
is significant and worth the complexity and risk.

Is that a fair summary?

I'm actually thinking it's doable with a new __unsafe_user type of
pointer, sparse will then catch errors for us.


-- 
MST

