Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BEF52B66B7
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 15:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730077AbgKQOG0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 09:06:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:47595 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728360AbgKQOGY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 09:06:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605621983;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UspmaeppXpINYHqjCQN1dQiXGQvIicJA54gqiqQ+u6Q=;
        b=BsPeod2+eVPso6VPkNJHWcbCTEA21KtNtu8KxB72ttzmf9eHx/60y7uX9zJvVLtNXZB4nf
        +audUgs4B6geW8jUD0/pRVfPdy66H/T0VmhRreYTrTz6kRlcBDZR1cr2SLyo/Wp0UQugxl
        Wg6rHANUJMStxtr54CEq7d+WUQsCHeA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-341-Qohy4UMGMvSv4r2fiFTNZw-1; Tue, 17 Nov 2020 09:06:21 -0500
X-MC-Unique: Qohy4UMGMvSv4r2fiFTNZw-1
Received: by mail-wm1-f69.google.com with SMTP id o203so1462178wmo.3
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 06:06:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UspmaeppXpINYHqjCQN1dQiXGQvIicJA54gqiqQ+u6Q=;
        b=sfooVJ6OQJjKC/UaFABOl8v765y5dUtINm5Fyd03b1LK9R99Cu3OVs1Kv5Bt2YgdTe
         boFCi4969LHu3x+tAxrfkwSTBJM9VJnRIk+VI/MACIQ8CFt72d5Ov8Gw9lizGzr0kY7E
         0GCukXRpeTQ5hXEZmjdbKG8FUH6EGeLtFAMEIibWKvCarpRjKcUfhZDfF7MPFmI4oYza
         UuRfs5OnBO4IaCrkkNmTusoQj2CoUidNxmv9hGrGA+OQpbE8hTHxbDKDeMIpm7+ripF3
         uTXDKTCReF7ydCGZLkDThHV8soSngUVYDpaxbUK8ApCnL4zBcwEWamUX+xylEQrVMl/U
         sBKA==
X-Gm-Message-State: AOAM530FCcVwbPZP6gcnVbcWpzrBKTvFXrzxhboAsAqtFhL0NXxqb96Q
        3Ucj0KlsOn68BrCfushsQH0t2GqcJUFyPCbpBf7u7Zngxa+X65vU6yhPW4R1Vv/40pxWCMTNVix
        62DL7YmZXryv9RE4i
X-Received: by 2002:adf:9b95:: with SMTP id d21mr24559921wrc.335.1605621979595;
        Tue, 17 Nov 2020 06:06:19 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwhSYbi+WC19aTHz0B4Dm8F1kUlvECnXg3hRisQ3WDbkcJYAD/TjJQ7nb/UTTh8ludLybHY7Q==
X-Received: by 2002:adf:9b95:: with SMTP id d21mr24559899wrc.335.1605621979350;
        Tue, 17 Nov 2020 06:06:19 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id j15sm29504850wrm.62.2020.11.17.06.06.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2020 06:06:18 -0800 (PST)
Date:   Tue, 17 Nov 2020 15:06:16 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Tom Parkin <tparkin@katalix.com>
Cc:     netdev@vger.kernel.org, jchapman@katalix.com
Subject: Re: [RFC PATCH 1/2] ppp: add PPPIOCBRIDGECHAN ioctl
Message-ID: <20201117140616.GA17578@linux.home>
References: <20201106181647.16358-1-tparkin@katalix.com>
 <20201106181647.16358-2-tparkin@katalix.com>
 <20201109232401.GM2366@linux.home>
 <20201110120429.GB5635@katalix.com>
 <20201115162838.GF11274@linux.home>
 <20201117122638.GB4640@katalix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117122638.GB4640@katalix.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 12:26:38PM +0000, Tom Parkin wrote:
> On  Sun, Nov 15, 2020 at 17:28:38 +0100, Guillaume Nault wrote:
> > On Tue, Nov 10, 2020 at 12:04:29PM +0000, Tom Parkin wrote:
> > > On  Tue, Nov 10, 2020 at 00:24:01 +0100, Guillaume Nault wrote:
> > > However, my primary motivation for using ppp_channel_push was actually
> > > the handling for managing dropping the packet if the channel was
> > > deregistered.
> > 
> > I might be missing something, but I don't see what ppp_channel_push()
> > does appart from holding the xmit lock and handling the xmit queue.
> > If we agree that there's no need to use the xmit queue, all
> > ppp_channel_push() does for us is taking pch->downl, which we probably
> > can do on our own.
> > 
> > > It'd be simple enough to add another function which performed the same
> > > deregistration check but didn't transmit via. the queue.
> > 
> > That's probably what I'm missing: what do you mean by "deregistration
> > check"? I can't see anything like this in ppp_channel_push().
> 
> It's literally just the check on pch->chan once pch->downl is held.
> So it would be trivial to do the same thing in a different codepath: I
> just figured why reinvent the wheel :-)

Okay, I was thinking of something more complex. I agree with not
reinventing existing functions, but in this case, I think that
ppp_channel_push() does too many unecessary operations (like recursion
handling and processing the parent unit's queue). Also, a helper
function would be the natural place for calling skb_scrub_packet()
and for handling concurent access or modification of the ->bridge
pointer (as discussed earlier in this thread).

> 
> Sorry for the confusion.

No problem. It's nice to see some work being done in this area :).

