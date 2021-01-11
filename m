Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCA262F10B4
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 12:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729604AbhAKK7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 05:59:17 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27281 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725971AbhAKK7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 05:59:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610362669;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z7rOeB+I4wgDC7MUie6XCpYrBBPFo0T1dc7r5uqQ/dE=;
        b=RAoPyI1OFogvIU30Kgnv1D+tptZmJleSv/LgvEKodZmtL+6aiYq036XOTXh/juLllf2vtp
        +3VR6qtAppmIzFubSdmsmUwo8SfM+mJNe4z4wG+/0onJjamwAwNPFqGILW58rUdae42CJz
        4tYE+uIaJJKcCk2+JeCTzw5ACqECsk8=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-105-ZHu-VktxMcyu41XQHjWwmQ-1; Mon, 11 Jan 2021 05:57:47 -0500
X-MC-Unique: ZHu-VktxMcyu41XQHjWwmQ-1
Received: by mail-wm1-f69.google.com with SMTP id l5so1989999wmi.4
        for <netdev@vger.kernel.org>; Mon, 11 Jan 2021 02:57:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=z7rOeB+I4wgDC7MUie6XCpYrBBPFo0T1dc7r5uqQ/dE=;
        b=NrOPTkIFF4yb56hoAj1r4Fek3bqVI3xNIKpzgrv61FaRyIo0tmeo3Naobus4UXN90b
         +8hQ1ALphtRZCzGwFUfBdZE6AJ7V7qVO/amNh4AyaG0AtUAXaaVTUioTSTkYpLcXPY08
         l1Gl2laF9t5alFBiZzr0LhjMmnsYVz3prZtHy0XMnxVL6ImUGWFt0tjd6w5uAYCiDBXD
         zN1GhdEotO2EP/5JH8lrjP3wopKv8devW5lIDmN+6lUAyFZ9redufUR0dyvtRS+idN9A
         KCOyvgKHBevFtDRc0+teOIAxH8rfKODXN+HItocf80A4Ca4r/VLqGKu2bEBFzzrWVX5I
         PpNA==
X-Gm-Message-State: AOAM530utPw6v48ZZZzqN2rWFf+GFhTkSwVm3YhW16mmlglDoXpfwWVX
        WKS3w+VS4RTiicjx+8mNgRNccbNAfsbMh63IXJQ2wUMPBJ/O9NN3I4uc0Y1ViU661uutXVSU1O8
        OXuV4jXr69b+eigqP
X-Received: by 2002:adf:e710:: with SMTP id c16mr15848050wrm.295.1610362666689;
        Mon, 11 Jan 2021 02:57:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJybMfzpjwFHcAW2AKhCDUcRL19WEBuHsiFCND2EjHaV2iQPfZ0szACximcvMtO/eSOrNWSqbg==
X-Received: by 2002:adf:e710:: with SMTP id c16mr15848040wrm.295.1610362666519;
        Mon, 11 Jan 2021 02:57:46 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id n16sm23766290wrj.26.2021.01.11.02.57.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 02:57:45 -0800 (PST)
Date:   Mon, 11 Jan 2021 11:57:44 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] tc: flower: fix json output with mpls lse
Message-ID: <20210111105744.GA13412@linux.home>
References: <1ef12e7d378d5b1dad4f056a2225d5ae9d5326cb.1608330201.git.gnault@redhat.com>
 <20210107164856.GC17363@linux.home>
 <20210107091352.610abd6f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <31cfb1dc-1e93-e3ed-12f4-f8c44adfd535@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31cfb1dc-1e93-e3ed-12f4-f8c44adfd535@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 07, 2021 at 10:39:03AM -0700, David Ahern wrote:
> On 1/7/21 10:13 AM, Jakub Kicinski wrote:
> > On Thu, 7 Jan 2021 17:48:56 +0100 Guillaume Nault wrote:
> >> On Fri, Dec 18, 2020 at 11:25:32PM +0100, Guillaume Nault wrote:
> >>> The json output of the TCA_FLOWER_KEY_MPLS_OPTS attribute was invalid.
> >>>
> >>> Example:
> >>>
> >>>   $ tc filter add dev eth0 ingress protocol mpls_uc flower mpls \
> >>>       lse depth 1 label 100                                     \
> >>>       lse depth 2 label 200
> >>>
> >>>   $ tc -json filter show dev eth0 ingress
> >>>     ...{"eth_type":"8847",
> >>>         "  mpls":["    lse":["depth":1,"label":100],
> >>>                   "    lse":["depth":2,"label":200]]}...  
> >>
> >> Is there any problem with this patch?
> >> It's archived in patchwork, but still in state "new". Therefore I guess
> >> it was dropped before being considered for review.
> > 
> > Erm, that's weird. I think Alexei mentioned that auto-archiving is
> > turned on in the new netdevbpf patchwork instance. My guess is it got
> > auto archived :S
> > 
> > Here is the list of all patches that are Archived as New:
> > 
> > https://patchwork.kernel.org/project/netdevbpf/list/?state=1&archive=true
> > 
> > Should any of these have been reviewed?
> > 
> 
> 
> Interesting. I thought some patches had magically disappeared - and some
> of those are in that list.

Okay, but, in the end, should I repost this patch?

