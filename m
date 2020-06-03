Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB141EC8A6
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 07:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725878AbgFCFRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 01:17:53 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45377 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725275AbgFCFRx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 01:17:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591161471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9zb23GOwMdeuO409vFKEhupNpLymoL466WEUGj0SSmg=;
        b=RmMOvriMWs8yA0uojFx0ZznFPPCvPlIf01dt6bZdnPKoNVx41ISTXNR/tcXkArFum7r50X
        0z6Nz/ejPynE56m12gJO4ttA+Y3W0o9yZOzyWIkQq2NrtbKXCKJHNolCCujDaq2xre3mLJ
        QpmNIjl1Xcm2YXwwHYf6iqbP5rUqUZY=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-178-REFz1FlaNrOZNk_9IBwyxw-1; Wed, 03 Jun 2020 01:17:49 -0400
X-MC-Unique: REFz1FlaNrOZNk_9IBwyxw-1
Received: by mail-wr1-f72.google.com with SMTP id c14so589289wrw.11
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 22:17:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9zb23GOwMdeuO409vFKEhupNpLymoL466WEUGj0SSmg=;
        b=qW3iUKulPkkvXwLhCL1dJID5tkP9Ium7BpighPW5lKHaUNDiwOKBfpepi8o3+CTOnk
         pedyA/2R16bXTdNw+neiD232uysCjf8jyUSKQZPxZm823VDVe41f6NCVIDHq0piVEt4S
         vxfiWogyI1DkmdwkyDu01SeFxVpNSoUY2Z+RkIVLm9YkPGfRGgaHp0phk0k7rraNiy+P
         Le4nZo8XREi/cDvR60E+j5zOESuvKJxJbzhbhctWyrKUHJOhaIH3jDXEo3mm9KmOe+MJ
         gJ21R1vWmLF4akQiOQIhvPmijyzpKhmQ5JD54qs1YPy50EqsBOGDK4zq/iHspSsQQook
         +xiw==
X-Gm-Message-State: AOAM533Jw/pLN2CA1SoCKbiqooLHYKOHL22RC1TgHZs1YuN84O6qk4Pe
        7Ks8nlqhw8BQmGEX3YNgh8jdWIaVrMHTuRA49FhJ5ewwdsLlcpn/F0KZ6rNqRdIyAuaFTF6gkTN
        tuXt9j8nrcDPaAIH6
X-Received: by 2002:a7b:c158:: with SMTP id z24mr7422329wmi.12.1591161468608;
        Tue, 02 Jun 2020 22:17:48 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwJEou6ul/0ePHl0Sxjd9yTiJzg78VX6HFkFw1rv8Xk3wqLdc+7XBJv21QaaCDP6N70D59EvQ==
X-Received: by 2002:a7b:c158:: with SMTP id z24mr7422312wmi.12.1591161468380;
        Tue, 02 Jun 2020 22:17:48 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id 1sm1180009wms.25.2020.06.02.22.17.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 22:17:47 -0700 (PDT)
Date:   Wed, 3 Jun 2020 01:17:45 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     linux-kernel@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH RFC] uaccess: user_access_begin_after_access_ok()
Message-ID: <20200603010645-mutt-send-email-mst@kernel.org>
References: <20200602084257.134555-1-mst@redhat.com>
 <20200602163048.GL23230@ZenIV.linux.org.uk>
 <20200602163937-mutt-send-email-mst@kernel.org>
 <20200602221057.GQ23230@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200602221057.GQ23230@ZenIV.linux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 02, 2020 at 11:10:57PM +0100, Al Viro wrote:
> On Tue, Jun 02, 2020 at 04:42:03PM -0400, Michael S. Tsirkin wrote:
> > On Tue, Jun 02, 2020 at 05:30:48PM +0100, Al Viro wrote:
> > > On Tue, Jun 02, 2020 at 04:45:05AM -0400, Michael S. Tsirkin wrote:
> > > > So vhost needs to poke at userspace *a lot* in a quick succession.  It
> > > > is thus benefitial to enable userspace access, do our thing, then
> > > > disable. Except access_ok has already been pre-validated with all the
> > > > relevant nospec checks, so we don't need that.  Add an API to allow
> > > > userspace access after access_ok and barrier_nospec are done.
> > > 
> > > This is the wrong way to do it, and this API is certain to be abused
> > > elsewhere.  NAK - we need to sort out vhost-related problems, but
> > > this is not an acceptable solution.  Sorry.
> > 
> > OK so summarizing what you and Linus both said, we need at
> > least a way to make sure access_ok (and preferably the barrier too)
> > is not missed.
> > 
> > Another comment is about actually checking that performance impact
> > is significant and worth the complexity and risk.
> > 
> > Is that a fair summary?
> > 
> > I'm actually thinking it's doable with a new __unsafe_user type of
> > pointer, sparse will then catch errors for us.
> 
> Er... how would sparse keep track of the range?

Using types. So you start with a user pointer:

struct foo __user *up;

Now you validate it, including a speculation barrier:

struct foo __valdated_user *p = user_access_validate(up, sizeof *up);

and you can save it and use it with something like unsafe_get_user and unsafe_put_user
that gets __valdated_user pointers:

user_access_begin_validated(p, sizeof *p)
valiated_get_user(bar, foo->bar, err_fault)
valiated_put_user(baz, foo->baz, err_fault)
user_access_end()




-- 
MST

