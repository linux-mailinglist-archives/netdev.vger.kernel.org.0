Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35EB5171232
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 09:14:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728484AbgB0IOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 03:14:30 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30430 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726999AbgB0IOa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 03:14:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582791268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fpReiO6LFVlN1IqtLDuQUSqHXgtDgIbrEY8RRSr+WUw=;
        b=BbIH3QjyEC4uamG4tob835JnnFNNBfA2HMazyybKC9xE+/FclYulHCfAGKHlEmobiBGz2g
        ED+KBcGTsubrmMJ/DvjswvkQCias5NeW7SbRbqZa6kHEmfGf8UskMwB54hYsH0ZdHngiu/
        E3M+KP5JhvYt0SMxFestR9bpZpH3VyI=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-91-z8gVESeXN96oC6GfIlZaLA-1; Thu, 27 Feb 2020 03:14:26 -0500
X-MC-Unique: z8gVESeXN96oC6GfIlZaLA-1
Received: by mail-qv1-f72.google.com with SMTP id b3so2701314qvy.3
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 00:14:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fpReiO6LFVlN1IqtLDuQUSqHXgtDgIbrEY8RRSr+WUw=;
        b=BbEuYpx01R27xJp/pqTrWK2Dl7lTgKjue1o87b4W1SqMDgf03zVqWhfaKp8Tx2dITz
         qKM5nym/QGICULF/LjZ2rG5rbTW+OXv9GBH2ooBvqDJK2QKnKUbT3apiFXxzXFoCZ2hc
         BGsdUSRtW22hFwuEB4HPO/+lijrIJ3RxGlCcuG+Fy6v+VLDZdEKDYvdYE4EnIFwQJOJT
         dSr1bei9cwshvFxR6CIuH68hcGigC/r0VkzUjgnLmzOjAsZ5VWrSJG0qnEYYmN4Hn+jK
         aBd0wHmGEmFY6ebyjVMW1Pb3e8dr6Dp/TV7zc0Ci7vNk5r1lILInrrIgdI0iwMjFbHq5
         wCjA==
X-Gm-Message-State: APjAAAVy6P/AhCbpx+NT/jhymt0JXDEwhwlqv2SQjPPAnE3tCf3660fz
        xSTbAHVrBgLUHIWYFvqVwx4j+mttrnq8q1HGGhh5Cz1YaayONR0dB3KOCNWE1afpsCL6X6fRRKe
        a6qiVkMlB1BaNskyn
X-Received: by 2002:a05:620a:909:: with SMTP id v9mr4167283qkv.138.1582791266518;
        Thu, 27 Feb 2020 00:14:26 -0800 (PST)
X-Google-Smtp-Source: APXvYqzjgvad+XPTK/815hjSZUOnqdCOU8KLX/bhWw2S+6pkWBNBSKba7n/FRyus0UnQEIWofwhToA==
X-Received: by 2002:a05:620a:909:: with SMTP id v9mr4167257qkv.138.1582791266222;
        Thu, 27 Feb 2020 00:14:26 -0800 (PST)
Received: from redhat.com (bzq-79-178-2-214.red.bezeqint.net. [79.178.2.214])
        by smtp.gmail.com with ESMTPSA id w11sm2685197qkf.113.2020.02.27.00.14.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 00:14:25 -0800 (PST)
Date:   Thu, 27 Feb 2020 03:14:20 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dahern@digitalocean.com>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Michael Chan <michael.chan@broadcom.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: virtio_net: can change MTU after installing program
Message-ID: <20200227030914-mutt-send-email-mst@kernel.org>
References: <20200226093330.GA711395@redhat.com>
 <87lfopznfe.fsf@toke.dk>
 <0b446fc3-01ed-4dc1-81f0-ef0e1e2cadb0@digitalocean.com>
 <20200226115258-mutt-send-email-mst@kernel.org>
 <ec1185ac-a2a1-e9d9-c116-ab42483c3b85@digitalocean.com>
 <20200226120142-mutt-send-email-mst@kernel.org>
 <20200226173751.0b078185@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200226173751.0b078185@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 26, 2020 at 05:37:51PM -0800, Jakub Kicinski wrote:
> On Wed, 26 Feb 2020 12:02:03 -0500 Michael S. Tsirkin wrote:
> > On Wed, Feb 26, 2020 at 09:58:00AM -0700, David Ahern wrote:
> > > On 2/26/20 9:55 AM, Michael S. Tsirkin wrote:  
> > > > OK that seems to indicate an ndo callback as a reasonable way
> > > > to handle this. Right? The only problem is this might break
> > > > guests if they happen to reverse the order of
> > > > operations:
> > > > 	1. set mtu
> > > > 	2. detach xdp prog
> > > > would previously work fine, and would now give an error.  
> > > 
> > > That order should not work at all. You should not be allowed to change
> > > the MTU size that exceeds XDP limits while an XDP program is attached.  
> > 
> > 
> > Right. But we didn't check it so blocking that now is a UAPI change.
> > Do we care?
> 
> I'd vote that we don't care. We should care more about consistency
> across drivers than committing to buggy behavior.
> 
> All drivers should have this check (intel, mlx, nfp definitely do),
> I had a look at Broadcom and it seems to be missing there as well :(
> Qlogic also. Ugh.

Any chance to put it in net core then? Seems straight-forward enough ...

-- 
MST

