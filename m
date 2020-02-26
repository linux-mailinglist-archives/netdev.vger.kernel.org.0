Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7C817054F
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 18:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728444AbgBZRCP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 12:02:15 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27982 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728139AbgBZRCP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 12:02:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582736534;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vASGwlx8enUkT3EZXPxeOQJNRlOhWg01hQHTPNyZHeA=;
        b=EI+Z1Sc8eJCBhVPPvwFKTQjKFvMA1hDST51L71jzyYZYB36PfqYLsPwOi0iYpycDzUTMYk
        OtWQiXywTS+iFGd3A2qhn//DSi1Expp311GnQnhAhymyV9v5MORbAZyHHjhQMDZbyq+PTQ
        sQP1OhSmYyrEbEABR8UmoqgptylNiro=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-441-w7M33_7gOPK9Hbrt0PFejQ-1; Wed, 26 Feb 2020 12:02:12 -0500
X-MC-Unique: w7M33_7gOPK9Hbrt0PFejQ-1
Received: by mail-qk1-f197.google.com with SMTP id o16so4928761qkm.15
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 09:02:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vASGwlx8enUkT3EZXPxeOQJNRlOhWg01hQHTPNyZHeA=;
        b=bQH4EdeSNKtE9K68iJvh1F5Z5T4E2Fhtaw6d4pqabsQmvEdUgvedEL383iU51C5x6Y
         6osy2Iyfwvg/EueDRBvUvSQe3zP/hmQAygv/RTmPMsToP7eM9s/GfQFdj/lnKVWwMIcA
         YkENWBJXXX6YiW7irTxix8Q4Qs8jrVjkJed6eiseDgNtjIrSW/3CYGCFEWEyTuECdJaB
         VrBUqAPbUdNIMmW7X7jRNOZwBNLZVsl9tVdDCetA6ufYPGt/RDZU2xD6IeLzxfwywfh4
         3t62dqJOaoCgHVB7ZAu82CiwXunLeF/WwghPXnxg1E3xGd+cUe3MNMgHLYtKVi70jOYc
         XinA==
X-Gm-Message-State: APjAAAVmnHoR9pMN9jJfLx5g1sDc8LscORlXPTv3GUjiFbiiszOoSdyT
        sA+TrKQoRKpsGrS4Q0iBr0A5IB/abCxLuQv8VQuJvmjW/GxjfO3TshLOxg70KzXGq9mYN7C6F1y
        fckef+30g3RlpK5YJ
X-Received: by 2002:ac8:340c:: with SMTP id u12mr6243850qtb.257.1582736529624;
        Wed, 26 Feb 2020 09:02:09 -0800 (PST)
X-Google-Smtp-Source: APXvYqz3BbX3mFXc8LOkj2pxYf0QPsBthZWfYVVKgUJcWHR5wzmL9mLIOlWVfdT52lNhX4mb/8idng==
X-Received: by 2002:ac8:340c:: with SMTP id u12mr6243823qtb.257.1582736529401;
        Wed, 26 Feb 2020 09:02:09 -0800 (PST)
Received: from redhat.com (bzq-79-178-2-214.red.bezeqint.net. [79.178.2.214])
        by smtp.gmail.com with ESMTPSA id y91sm1440363qtd.13.2020.02.26.09.02.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 09:02:08 -0800 (PST)
Date:   Wed, 26 Feb 2020 12:02:03 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     David Ahern <dahern@digitalocean.com>
Cc:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: virtio_net: can change MTU after installing program
Message-ID: <20200226120142-mutt-send-email-mst@kernel.org>
References: <20200226093330.GA711395@redhat.com>
 <87lfopznfe.fsf@toke.dk>
 <0b446fc3-01ed-4dc1-81f0-ef0e1e2cadb0@digitalocean.com>
 <20200226115258-mutt-send-email-mst@kernel.org>
 <ec1185ac-a2a1-e9d9-c116-ab42483c3b85@digitalocean.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec1185ac-a2a1-e9d9-c116-ab42483c3b85@digitalocean.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 26, 2020 at 09:58:00AM -0700, David Ahern wrote:
> On 2/26/20 9:55 AM, Michael S. Tsirkin wrote:
> > 
> > OK that seems to indicate an ndo callback as a reasonable way
> > to handle this. Right? The only problem is this might break
> > guests if they happen to reverse the order of
> > operations:
> > 	1. set mtu
> > 	2. detach xdp prog
> > would previously work fine, and would now give an error.
> 
> That order should not work at all. You should not be allowed to change
> the MTU size that exceeds XDP limits while an XDP program is attached.


Right. But we didn't check it so blocking that now is a UAPI change.
Do we care?

> > 
> > If we want to make it transparent for userspace,
> > I guess we can defer the actual update until xdp prog is detached.
> > Sound ugly and might still confuse some userspace ... worth it?
> > 

