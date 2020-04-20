Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2CAD1B0E18
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 16:16:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728920AbgDTOQV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 10:16:21 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:59291 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727774AbgDTOQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 10:16:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587392178;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JkxIFVIohEorxeTZe98++uLsQqk7YmDIx4Z7KvJXfYk=;
        b=J/+vovtH4rUFhy1acS3xf4cXditJ6DyOfYzH0wHtbd8mBrZZZWBw2LErnFHPtLcUseW8Pc
        R5TEJAvI4Ied6rVXUK7oOGRmW5gvmGUoYbSt68dLsaSsurj2JYnp1NpCXDpuRF3q9k7zpe
        QipqJ2id23oTrCvRdnA2qRDYknPOYh4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-155-h9F7sXTgMh-jhb5YTO9a2w-1; Mon, 20 Apr 2020 10:16:16 -0400
X-MC-Unique: h9F7sXTgMh-jhb5YTO9a2w-1
Received: by mail-wr1-f69.google.com with SMTP id e5so5735697wrs.23
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 07:16:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JkxIFVIohEorxeTZe98++uLsQqk7YmDIx4Z7KvJXfYk=;
        b=UuGMxOD20JcKNWAXGGpEJBxfMLKrNcXLRYNU3+2TFmKc9X++k3ZAyHIKCdX3FSM552
         kji1R3H8DQIBpkmAjK9MV7fIUWx7aXXliNiq4rvM6f8fUXpVxOamXPCJ1TF5KiSOEGGr
         zAO+hYzj7IhQuySrkX8JJtv+ZYQD0nAPfrocZ+p0lEy4kowgL1lN5rnCtAGKzRu2AJt3
         I4WlkWNeOiu3WelWFOkXfgrW/4761Y92msXd9q92/+LPrWwtsP/6y1hjxlWRp7m7FIaa
         E7U9afCCff/aafNNircLP0IKViukokknXpKKZ56PLDMabDngdARzoQPPl6cEUWxvhN7g
         zbEA==
X-Gm-Message-State: AGi0PuY7bVUwALTMac0GXQ36SG2+q2p0O3PErwXykbvUJa7NJttlbMtt
        bCuBSSKrX9Mr9zvcr+duqBJPx7of1JRpvLTI2Snvwmfk+JsM9z8pMDvu1iLMqTDX8DqeSMVxA/0
        m59/KLtsXlpmx96t1
X-Received: by 2002:adf:aa92:: with SMTP id h18mr16805517wrc.20.1587392175531;
        Mon, 20 Apr 2020 07:16:15 -0700 (PDT)
X-Google-Smtp-Source: APiQypILEROI3x8fort+5bkMx0TZQmQ1zQlGbT1pp1O6iljI2XwZ+SmO3RgUlnhFtDZnZ7lv8EOcYQ==
X-Received: by 2002:adf:aa92:: with SMTP id h18mr16805492wrc.20.1587392175345;
        Mon, 20 Apr 2020 07:16:15 -0700 (PDT)
Received: from redhat.com (bzq-79-183-51-3.red.bezeqint.net. [79.183.51.3])
        by smtp.gmail.com with ESMTPSA id f18sm1432047wrq.29.2020.04.20.07.16.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 07:16:14 -0700 (PDT)
Date:   Mon, 20 Apr 2020 10:16:11 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-kernel@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        Richard Earnshaw <Richard.Earnshaw@arm.com>,
        Sudeep Dutt <sudeep.dutt@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jason Wang <jasowang@redhat.com>, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Subject: Re: [PATCH v3] vhost: disable for OABI
Message-ID: <20200420101511-mutt-send-email-mst@kernel.org>
References: <20200416221902.5801-1-mst@redhat.com>
 <20200420082909.GA28749@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200420082909.GA28749@infradead.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 20, 2020 at 01:29:09AM -0700, Christoph Hellwig wrote:
> On Thu, Apr 16, 2020 at 06:20:20PM -0400, Michael S. Tsirkin wrote:
> > vhost is currently broken on the some ARM configs.
> > 
> > The reason is that that uses apcs-gnu which is the ancient OABI that is been
> > deprecated for a long time.
> > 
> > Given that virtio support on such ancient systems is not needed in the
> > first place, let's just add something along the lines of
> > 
> > 	depends on !ARM || AEABI
> > 
> > to the virtio Kconfig declaration, and add a comment that it has to do
> > with struct member alignment.
> > 
> > Note: we can't make VHOST and VHOST_RING themselves have
> > a dependency since these are selected. Add a new symbol for that.
> 
> This description is horrible.  The only interesting thing for ARM OABI
> is that it has some strange padding rules, but that isn't something
> that can't be handled.   Please spend some time looking into the issue
> and add te proper __padded annotations, we've done that elsewhere in
> the kernel and it isn't too bad - in fact it helps understanding issues
> with implicit alignment.

Yes I have a patch queued to fix it. I wanted a minimal patch for this
release though.

> And even if you have a good reason not to fix vhost (which I think you
> don't have) this changelog is just utter crap, as it fails to mention
> what the problem with ARM OABI even is.

I'll tweak that, thanks!

-- 
MST

