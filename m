Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D54D29890A
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 10:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1772511AbgJZJE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 05:04:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:23540 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1771139AbgJZJE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 05:04:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603703065;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=v0ChkjzOJmvHdd3ldp4TUvxYDgZflQiFTsiTmYKzbm8=;
        b=Fuoct9svqJqX97S9kQaNhA4psEHmR4KaJcAUFYpDAmX+nySFi7NbFJK386jB0zwEQwlsD/
        gGDhvol6uH5atPx8i0DUY6V+v33Z48qhuaGIPdPpbi7rnRnqYrLXUMVdhfmmBGPjAeCnHK
        SjlLFRRmJup6nfx2y0bBmehgoo/Tvno=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-350-h70jD5K7PIu6Vf3GasIzJQ-1; Mon, 26 Oct 2020 05:04:23 -0400
X-MC-Unique: h70jD5K7PIu6Vf3GasIzJQ-1
Received: by mail-wr1-f71.google.com with SMTP id 33so8038876wrf.22
        for <netdev@vger.kernel.org>; Mon, 26 Oct 2020 02:04:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=v0ChkjzOJmvHdd3ldp4TUvxYDgZflQiFTsiTmYKzbm8=;
        b=TRef/ZeTw4LjBtfqNX4IUT1on8emfLWo/Dzl6gnfcOAAOv8nHyg96ej+d244TP6Mr5
         ITsl/j8Ru2oiaiscAdUv5Xf6kdm+O7iC+cMqeFWNL1fhAQEsOmqNZoXbHuxgdSunRSBk
         OSCK80X47at91XGZsOYZ8qIL7JafaDwv/fTINg74SNhk18alZizRC6ndhwbM8AK/VVRP
         4utpBLJ34zskL5J6KkjnAqYsRVQYfmwUkuo6mx9sOYOE0Psn3eaDNO5542lsaq9xAixs
         ZisG5qRjfzg2b13wmDquHbNdu2qllQeRUDCeHSAmXQ3MDViaSqkTlKPl25mt3eqoJ4uF
         tvcg==
X-Gm-Message-State: AOAM531gLHEWCnrKn5iSpBUIB+qkQDgTM6O9tN7mbrBXZcZJwIaWkknf
        mizQiycQvqAVjm3X0nW1DNJRtcsefrfaRKmO8mUjgTpWBpgam6kPlQLZc7gcimXcpZU+TD0Q7ZU
        D3XUmC67cKIOyG2Ti
X-Received: by 2002:adf:d4ce:: with SMTP id w14mr7060246wrk.142.1603703062066;
        Mon, 26 Oct 2020 02:04:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzV8Xc6i+0yNcn00/ECeQA8zAKfDO2Fns6u2zsPXG0j8aog44G7bkOFGC1fjNPxCdT34UBCwg==
X-Received: by 2002:adf:d4ce:: with SMTP id w14mr7060221wrk.142.1603703061886;
        Mon, 26 Oct 2020 02:04:21 -0700 (PDT)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id j9sm21987746wrp.59.2020.10.26.02.04.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 02:04:21 -0700 (PDT)
Date:   Mon, 26 Oct 2020 10:04:19 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Alexander Ovechkin <ovov@yandex-team.ru>
Subject: Re: [PATCH net 1/2] mpls: Make MPLS_IPTUNNEL select NET_MPLS_GSO
Message-ID: <20201026090419.GA23071@linux.home>
References: <cover.1603469145.git.gnault@redhat.com>
 <5f5132fd657daa503c709b86c87ae147e28a78ad.1603469145.git.gnault@redhat.com>
 <20201023112304.086cd5e0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20201023184816.GB21673@pc-2.home>
 <20201025144309.1c91b166@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <310b13d1-4685-cd76-be5f-e9450fb6a95e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <310b13d1-4685-cd76-be5f-e9450fb6a95e@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 25, 2020 at 08:48:38PM -0600, David Ahern wrote:
> On 10/25/20 3:43 PM, Jakub Kicinski wrote:
> > On Fri, 23 Oct 2020 20:48:16 +0200 Guillaume Nault wrote:
> >> On Fri, Oct 23, 2020 at 11:23:04AM -0700, Jakub Kicinski wrote:
> >>> On Fri, 23 Oct 2020 18:19:43 +0200 Guillaume Nault wrote:  
> >>>> Since commit b7c24497baea ("mpls: load mpls_gso after mpls_iptunnel"),
> >>>> mpls_iptunnel.ko has a softdep on mpls_gso.ko. For this to work, we
> >>>> need to ensure that mpls_gso.ko is built whenever MPLS_IPTUNNEL is set.  
> >>>
> >>> Does it generate an error or a warning? I don't know much about soft
> >>> dependencies, but I'd think it's optional.  
> >>
> >> Yes, it's optional from a softdep point of view. My point was that
> >> having a softdep isn't a complete solution, as a bad .config can still
> >> result in inability to properly transmit GSO packets.
> > 
> > IMO the combination of select and softdep feels pretty strange.
> > 
> > It's either a softdep and therefore optional, or we really don't 
> > want to be missing it in a correctly functioning system, and the
> > dependency should be made stronger.
> > 
> 
> That's why I liked the softdep solution - if the module is there, load it.

Okay, then I'll resubmit without the Kconfig bits.

