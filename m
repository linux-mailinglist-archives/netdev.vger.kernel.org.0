Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58C965D98D
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 02:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbfGCArm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 20:47:42 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:37660 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727069AbfGCArm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 20:47:42 -0400
Received: by mail-pf1-f193.google.com with SMTP id 19so298711pfa.4
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 17:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=a6DSR9zMVNSIPOHutOGYYowzxyygnNjjAgHH6t/fH3Q=;
        b=ZMFtd4fnwBhjqDgEcmMPYqwTfM3scvxup6E9ES0eTl1QBLbkm4L+EYQQqrUrDt7I0f
         1W7i7K4qFAKEM9FkLZbBvOwEPA2KShqct0FnQuEtwjRtbN+49uyAwET1ta2fkPFntUdL
         d1HKAJ/XrkEjycdCCsfgQI1lqoOc8poLOC7Ys=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=a6DSR9zMVNSIPOHutOGYYowzxyygnNjjAgHH6t/fH3Q=;
        b=pluHld0bOz44StkNPeSTuc3Mo3iCNoAvqYsgTf0OGt9yoDSvqsgcp+3JYQ5ZlnONgg
         6vwP98lfkldCh9vpgbPES+u/3TC1KdUW8xo1+KAscfX5TYwV44cy3I/tjhsEk7SW6Jn3
         SrjAwT05Yd+iJyy5DRP8tAiNmahDppg0RZ2rdUg2vF7iyaSumflL7CHotFGUyzlNvbeC
         tG4rEFeD5K2wxs7nwl84PU+/wXXBFYzoQL+dxedadzUs+tU5ZNsHt/zKFdDWGd34NgA4
         xXfHr1+j0RtVhmgzanRJfNHTqXUWUThY2Nbb8tUX8cdF9rTvvnPVGEntBO2BM2eQ64lV
         tY8Q==
X-Gm-Message-State: APjAAAXBBpnk6nf23iuns8B4NP5O7PCQOPDY9cW7z8dLXUwc3BwT6e3B
        zlrZ2kxdwzacbLweYwfZTiRfeHyVEeY=
X-Google-Smtp-Source: APXvYqxbnDf0epA4zxEVMf+KQtiS47h5ZVi4HVl0lxeY8pfHVzHmCshNhotvWTcEjEQC+XEnSbkkRg==
X-Received: by 2002:a17:90a:b908:: with SMTP id p8mr7901348pjr.94.1562101447970;
        Tue, 02 Jul 2019 14:04:07 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id g1sm52207pgg.27.2019.07.02.14.04.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 02 Jul 2019 14:04:03 -0700 (PDT)
Date:   Tue, 2 Jul 2019 09:33:02 -0700
From:   Kees Cook <keescook@chromium.org>
To:     Joe Perches <joe@perches.com>
Cc:     Alexey Dobriyan <adobriyan@gmail.com>,
        Andreas Dilger <adilger@dilger.ca>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shyam Saini <shyam.saini@amarulasolutions.com>,
        kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org,
        intel-gvt-dev@lists.freedesktop.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        netdev@vger.kernel.org, linux-ext4 <linux-ext4@vger.kernel.org>,
        devel@lists.orangefs.org, linux-mm@kvack.org,
        linux-sctp@vger.kernel.org, bpf@vger.kernel.org,
        kvm@vger.kernel.org, mayhs11saini@gmail.com
Subject: Re: [PATCH V2] include: linux: Regularise the use of FIELD_SIZEOF
 macro
Message-ID: <201907020931.2170BAB@keescook>
References: <20190611193836.2772-1-shyam.saini@amarulasolutions.com>
 <20190611134831.a60c11f4b691d14d04a87e29@linux-foundation.org>
 <6DCAE4F8-3BEC-45F2-A733-F4D15850B7F3@dilger.ca>
 <20190629142510.GA10629@avx2>
 <c3b83ba7f9b003dd4fb9cad885461ce93165dc04.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c3b83ba7f9b003dd4fb9cad885461ce93165dc04.camel@perches.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 29, 2019 at 09:45:10AM -0700, Joe Perches wrote:
> On Sat, 2019-06-29 at 17:25 +0300, Alexey Dobriyan wrote:
> > On Tue, Jun 11, 2019 at 03:00:10PM -0600, Andreas Dilger wrote:
> > > On Jun 11, 2019, at 2:48 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> > > > On Wed, 12 Jun 2019 01:08:36 +0530 Shyam Saini <shyam.saini@amarulasolutions.com> wrote:
> > > I did a check, and FIELD_SIZEOF() is used about 350x, while sizeof_field()
> > > is about 30x, and SIZEOF_FIELD() is only about 5x.
> > > 
> > > That said, I'm much more in favour of "sizeof_field()" or "sizeof_member()"
> > > than FIELD_SIZEOF().  Not only does that better match "offsetof()", with
> > > which it is closely related, but is also closer to the original "sizeof()".
> > > 
> > > Since this is a rather trivial change, it can be split into a number of
> > > patches to get approval/landing via subsystem maintainers, and there is no
> > > huge urgency to remove the original macros until the users are gone.  It
> > > would make sense to remove SIZEOF_FIELD() and sizeof_field() quickly so
> > > they don't gain more users, and the remaining FIELD_SIZEOF() users can be
> > > whittled away as the patches come through the maintainer trees.
> > 
> > The signature should be
> > 
> > 	sizeof_member(T, m)
> > 
> > it is proper English,
> > it is lowercase, so is easier to type,
> > it uses standard term (member, not field),
> > it blends in with standard "sizeof" operator,
> 
> yes please.
> 
> Also, a simple script conversion applied
> immediately after an rc1 might be easiest
> rather than individual patches.

This seems reasonable to me. I think the patch steps would be:

1) implement sizeof_member(T, m) as a stand-alone macro
2) do a scripted replacement of all identical macros.
3) remove all the identical macros.

Step 2 can be a patch that includes the script used to do the
replacement. That way Linus can choose to just run the script instead of
taking the patch.

-- 
Kees Cook
