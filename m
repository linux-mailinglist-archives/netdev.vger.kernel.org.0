Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 169E829E63E
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 09:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbgJ2IUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 04:20:10 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60937 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727210AbgJ2IUG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 04:20:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603959605;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=TeMqk+ih9QIaMMmCc/T/951IImRhCGbNj2uycs0M7UY=;
        b=Y68nur89F8pFSvOWYxG1mTNLh0o8bqLvSYknPcfhmcMYWX73Z5Vxp+BCXASN0yfuh/+hMh
        B/rUEJZjfehy34zmXPhNXMXIWGYwPQaxvg9d0EM93EGZKk2QNTtSYlPZwGHH12pG2rTRMr
        qaAXDB9pbDyAJs+RX7fiyZdSqo+T8MA=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-549-2hbCcMdgOrqi5dK8x15nWw-1; Wed, 28 Oct 2020 23:17:26 -0400
X-MC-Unique: 2hbCcMdgOrqi5dK8x15nWw-1
Received: by mail-pg1-f199.google.com with SMTP id m11so1043009pgq.7
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 20:17:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TeMqk+ih9QIaMMmCc/T/951IImRhCGbNj2uycs0M7UY=;
        b=AimMFLth+AN0wwGj2pvzk5mQMXsHDBS7BWJdCgdy9YiBYES0sLpxjTN6oNpWtEWqpq
         QtK4aQFsnJbvsq5IY3ddvUOscN4CELXIWpr4rGmsf+a3/Ks/7s6KhICshZteb6Hy5G6i
         a1uj7i9+FzCnjAmjhoP8XEBBF8vWnnCH/oRC0QPUx+cYuKyKSPtJKcI2CoJhJXHMZoBX
         cgsU2tLIB55n22ARDnU96qja5kE1Er7P+TbAueVnFfH4Yh8IfZqKqbsK9QGwYo60inGk
         XKYUOxhM11ZROMlf+JqpMqVqjl/yUKJQ731CjiSU/qzHwKnQxBicCZAjWirwP8fiqnSY
         4A7A==
X-Gm-Message-State: AOAM532QCSCWaOtRmnPHjBCTBNJLr8mglhJ3mW4Ii3ugKzgvS8HsRz9E
        brRnVAqVnTonmNFaUXRK9cXUSYFyPT1ZytcI1Iml96lklCNOjcqmNzAII8c6K/M+lLUPHhBxrta
        BKDNoJVRiVrY9M5E=
X-Received: by 2002:a17:90a:ff92:: with SMTP id hf18mr2101043pjb.171.1603941445306;
        Wed, 28 Oct 2020 20:17:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyc9B1oRLut5gSl4Uif8mUf/xBMneqUW090I8ZNd/TXhV5lIoxHL5nTWxZlK5T3iwIYRRhZgg==
X-Received: by 2002:a17:90a:ff92:: with SMTP id hf18mr2101023pjb.171.1603941445054;
        Wed, 28 Oct 2020 20:17:25 -0700 (PDT)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id v24sm723401pgi.91.2020.10.28.20.17.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Oct 2020 20:17:24 -0700 (PDT)
Date:   Thu, 29 Oct 2020 11:17:12 +0800
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
Message-ID: <20201029031712.GO2408@dhcp-12-153.nay.redhat.com>
References: <20201023033855.3894509-1-haliu@redhat.com>
 <20201028132529.3763875-1-haliu@redhat.com>
 <7babcccb-2b31-f9bf-16ea-6312e449b928@gmail.com>
 <20201029020637.GM2408@dhcp-12-153.nay.redhat.com>
 <7a412e24-0846-bffe-d533-3407d06d83c4@gmail.com>
 <20201029024506.GN2408@dhcp-12-153.nay.redhat.com>
 <99d68384-c638-1d65-5945-2814ccd2e09e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <99d68384-c638-1d65-5945-2814ccd2e09e@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 09:00:41PM -0600, David Ahern wrote:
> >>> You need to update libbpf to latest version.
> >>
> >> nope. you need to be able to handle this. Ubuntu 20.10 was just
> >> released, and it has a version of libbpf. If you are going to integrate
> >> libbpf into other packages like iproute2, it needs to just work with
> >> that version.
> > 
> > OK, I can replace bpf_program__section_name by bpf_program__title().
> 
> I believe this one can be handled through a compatability check. Looks

Do you mean add a check like

#ifdef has_section_name_support
	use bpf_program__section_name;
#else
	use bpf_program__title;
#endif

> the rename / deprecation is fairly recent (78cdb58bdf15f from Sept 2020).

Yeah... As Andrii said, libbpf is in fast moving..

> >>
> >>>
> >>> But this also remind me that I need to add bpf_program__section_name() to
> >>> configure checking. I will see if I missed other functions' checking.
> >>
> >> This is going to be an on-going problem. iproute2 should work with
> >> whatever version of libbpf is installed on that system.
> > 
> > I will make it works on Ubuntu 20.10, but with whatever version of libbpf?
> > That looks hard, especially with old libbpf.
> > 
> 
> I meant what comes with the OS. I believe I read that Fedora 33 was just
> released as well. Does it have a version of libbpf? If so, please verify
> it compiles and works with that version too. Before committing I will
> also verify it compiles and links against a local version of libbpf (top
> of tree) just to get a range of versions.
> 

Yes, it makes sense. I will also check the libbpf on Fedora 33.

Thanks
Hangbin

