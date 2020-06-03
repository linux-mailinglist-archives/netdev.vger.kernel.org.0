Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 227681EC97E
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 08:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726009AbgFCG0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 02:26:03 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:35263 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbgFCG0D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jun 2020 02:26:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591165561;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=W9gnWO3EugB5fOJdsC5D6jCryswD8dlMs+CpQYmUgaY=;
        b=HUgxPLCU6WnGK0LMkoSYx48M7MGp+z/gdL24d6IoOIPji/FKxsmjknTX/o6n7WcUEFDnIy
        vQfNsi3CJgtcuKDJ/OYpmiO/fROY50Eq9l5mCrrO32CQ0coVfeOQd8I12kKUo5BjhE6sS6
        V5CfSZoi8Ee9MV4cIp0+Ar/AatbWRiE=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-20-2tcYP93NOMeMCSRtx8leug-1; Wed, 03 Jun 2020 02:26:00 -0400
X-MC-Unique: 2tcYP93NOMeMCSRtx8leug-1
Received: by mail-wr1-f69.google.com with SMTP id n6so662683wrv.6
        for <netdev@vger.kernel.org>; Tue, 02 Jun 2020 23:26:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=W9gnWO3EugB5fOJdsC5D6jCryswD8dlMs+CpQYmUgaY=;
        b=PcdorCnMAZ7xngt7gFE30HxxfHlUGzg+fVA84Xmr111cm9xLOkIx0ZJuc6e9dGwVZB
         p7Of58vZKIRS0iX6667nlpnnhIVmCztmwoUqQvLzxu3DG4HJ4GFYn9UuVzcYPY6SaqVq
         N3MynQg331O453EsdL21MZ533Qu6gaEVbKzAE7jUowiW4dEswVPziLnuGgNO+LZjZ0IE
         3MOt5JhbHA4od42GyrdAPq18lXIKneZ2mm+mp2uX0jd8PBvhRWqoI9X/jjQzhIY+tsyb
         AZovbugUapuab0EGV64BZIQpYZ47fCSd69rbxh6ul7QTGNmg/WEUCzibVj32nJQRDsNE
         5Ahw==
X-Gm-Message-State: AOAM532LSmj6kY3BzRf3sor1ykg47daNAThsUcyhs/unMs1UoEbWvXnb
        2yD9U5oA27OxOJS+rlOxMu9k9pCTbbU+wXhzfRO1DxRaIoEsf4RV9yk4ZRpEggJKQhyL7T2EI6L
        fl3fMfPjgK+3c3rae
X-Received: by 2002:adf:f64e:: with SMTP id x14mr30741026wrp.426.1591165559062;
        Tue, 02 Jun 2020 23:25:59 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy1i5xHd6fc3nWnTFZOzvGSSo6xaM9/6SXCQM6Yg/CKeNgxi2/7C9Q2o+55R5dUbq2NQc+Szw==
X-Received: by 2002:adf:f64e:: with SMTP id x14mr30741013wrp.426.1591165558867;
        Tue, 02 Jun 2020 23:25:58 -0700 (PDT)
Received: from redhat.com (bzq-109-64-41-91.red.bezeqint.net. [109.64.41.91])
        by smtp.gmail.com with ESMTPSA id s5sm1394880wme.37.2020.06.02.23.25.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 23:25:58 -0700 (PDT)
Date:   Wed, 3 Jun 2020 02:25:56 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Al Viro <viro@zeniv.linux.org.uk>
Cc:     Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH RFC] uaccess: user_access_begin_after_access_ok()
Message-ID: <20200603020325-mutt-send-email-mst@kernel.org>
References: <20200602084257.134555-1-mst@redhat.com>
 <20200603014815.GR23230@ZenIV.linux.org.uk>
 <3358ae96-abb6-6be9-346a-0e971cb84dcd@redhat.com>
 <20200603041849.GT23230@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200603041849.GT23230@ZenIV.linux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 03, 2020 at 05:18:49AM +0100, Al Viro wrote:
> On Wed, Jun 03, 2020 at 11:57:11AM +0800, Jason Wang wrote:
> 
> > > How widely do you hope to stretch the user_access areas, anyway?
> > 
> > 
> > To have best performance for small packets like 64B, if possible, we want to
> > disable STAC not only for the metadata access done by vhost accessors but
> > also the data access via iov iterator.
> 
> If you want to try and convince Linus to go for that, make sure to Cc
> me on that thread.  Always liked quality flame...

It's not about iov the way I see it.

It's a more fine-grained version of "nosmap".

Right now you basically want nosmap if you are running
a workload that does 100 byte reads/writes of userspace memory
all the time.

Which isn't so bad, I'm not sure how much security does smap add at all.
Were there any exploits that it blocked ever since it was introduced?

But in any case, it would be nice to also have an option to make it
possible to disable smap e.g. just for vhost. Not because vhost is
so secure, but simply because user wants this tradeoff.

-- 
MST

