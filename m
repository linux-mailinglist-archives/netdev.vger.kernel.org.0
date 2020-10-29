Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6B129E4C8
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 08:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387409AbgJ2HrJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 03:47:09 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:58596 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1733219AbgJ2HrE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 03:47:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603957622;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=E54pnSxqIHTNRMHY8e73O1yEsZObem3++NJwfwkL3+A=;
        b=Cedj5/Dr/lUIBEA329iRlMY+oiCvYFOrUHGC5LypfpvvKRQLQFdNL7euCvML3kJiOHlbOG
        sX2yp2GmjT3JubdNI3Qtw2ZJi0uchF7d31SxypajXfDknEy6FAHW7/xs1sqzu+kw4OJXDh
        bj03GZUKZGbqBM47Tfd5kEYCa9xkwGk=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-bQVAUP_rNqmONzNS1IlGJQ-1; Wed, 28 Oct 2020 22:45:20 -0400
X-MC-Unique: bQVAUP_rNqmONzNS1IlGJQ-1
Received: by mail-pg1-f199.google.com with SMTP id e16so1007241pgm.1
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 19:45:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=E54pnSxqIHTNRMHY8e73O1yEsZObem3++NJwfwkL3+A=;
        b=BEdkCn/WpguxhiGj8ckx1BZFuVP06Gprz6mChmc5E7j/yUVEqyHLJ2/IsxqGxQOJaM
         9pSlHO3IIsnqOXSdbvJxyzQ7AXtdRK9oHlG5vF1nPxxrci2ptFvtP4/5wpyQvFFpASS4
         NYg+SRhsmCkoK7C/0rtmMbYwV7KjnNgYQPpZQf1OcopFM0gEVizqqplu0PxV2Ib4LBeg
         LVgDorgLDnx58bHGuSxfMlyvjJRAmMi4KPEMW0C96moRfa0qgb7OD8h/MfodveyxoHOA
         t1IeQagXigqfKXx+5JpNahX9A4MjrS1oFyqVs5nsaCmxvLWIm2drsxbkvsLEm2HUAC1v
         O+SQ==
X-Gm-Message-State: AOAM532FyXFK17+aLUrQXRNkHtpRtXkloTGrsY6AHl5rAYbhkee1MReT
        pQlNsdPFpRuh21myYJbG9m6OBWUqq6KnD6SsfGTOitvDKCW2Nim8id1RCnZZOrC5pliuVdXVZT0
        DGjPIFOpgR6xEtpA=
X-Received: by 2002:a17:90a:498d:: with SMTP id d13mr2003985pjh.86.1603939519095;
        Wed, 28 Oct 2020 19:45:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzdaVPQ2CJKYuYOgKJmzIf1UCAj+FXrBrCc2ewXMYmo9Fgwj6Z3nDDfY+MOItezGGROoAztsg==
X-Received: by 2002:a17:90a:498d:: with SMTP id d13mr2003968pjh.86.1603939518825;
        Wed, 28 Oct 2020 19:45:18 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y22sm944732pfr.62.2020.10.28.19.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 19:45:18 -0700 (PDT)
Date:   Thu, 29 Oct 2020 10:45:06 +0800
From:   Hangbin Liu <haliu@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Jiri Benc <jbenc@redhat.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>
Subject: Re: [PATCHv2 iproute2-next 0/5] iproute2: add libbpf support
Message-ID: <20201029024506.GN2408@dhcp-12-153.nay.redhat.com>
References: <20201023033855.3894509-1-haliu@redhat.com>
 <20201028132529.3763875-1-haliu@redhat.com>
 <7babcccb-2b31-f9bf-16ea-6312e449b928@gmail.com>
 <20201029020637.GM2408@dhcp-12-153.nay.redhat.com>
 <7a412e24-0846-bffe-d533-3407d06d83c4@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7a412e24-0846-bffe-d533-3407d06d83c4@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 08:20:55PM -0600, David Ahern wrote:
> >> root@u2010-sfo3:~/iproute2.git# make -j 4
> >> ...
> >> /usr/bin/ld: ../lib/libutil.a(bpf_libbpf.o): in function `load_bpf_object':
> >> bpf_libbpf.c:(.text+0x3cb): undefined reference to
> >> `bpf_program__section_name'
> >> /usr/bin/ld: bpf_libbpf.c:(.text+0x438): undefined reference to
> >> `bpf_program__section_name'
> >> /usr/bin/ld: bpf_libbpf.c:(.text+0x716): undefined reference to
> >> `bpf_program__section_name'
> >> collect2: error: ld returned 1 exit status
> >> make[1]: *** [Makefile:27: ip] Error 1
> >> make[1]: *** Waiting for unfinished jobs....
> >> make: *** [Makefile:64: all] Error 2
> > 
> > You need to update libbpf to latest version.
> 
> nope. you need to be able to handle this. Ubuntu 20.10 was just
> released, and it has a version of libbpf. If you are going to integrate
> libbpf into other packages like iproute2, it needs to just work with
> that version.

OK, I can replace bpf_program__section_name by bpf_program__title().
> 
> > 
> > But this also remind me that I need to add bpf_program__section_name() to
> > configure checking. I will see if I missed other functions' checking.
> 
> This is going to be an on-going problem. iproute2 should work with
> whatever version of libbpf is installed on that system.

I will make it works on Ubuntu 20.10, but with whatever version of libbpf?
That looks hard, especially with old libbpf.

Thanks
Hangbin

