Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9581C75C3
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 18:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730030AbgEFQIx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 12:08:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729418AbgEFQIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 12:08:53 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 168D8C061A0F;
        Wed,  6 May 2020 09:08:53 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id x73so1827306lfa.2;
        Wed, 06 May 2020 09:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=if5qgNlscRmpJPzG9Z3gnyaxZ0iIBynHsVjhr1Dlctg=;
        b=eyheCbu3Wl4jWBLi16KmwXC3GUZfSR8nyYtYtWYhHzvEAIgisTgNndWd+2/Dmn4Fu3
         1/oZO1IAPn6+vOlMTBDdlshLkF7l+t81nke8HHUt/QG94oWJqyYv91zK/x8cIh2JkzYY
         SiY6Acsis1eShDIqatzkzYNXXugeecGd27RlgztExMUWAy7ZyTg+hq899Yt9jwljo6NT
         oTUEHhn9ghJ9p/zYohANqpmvT5SK6bz6NY+aHmz3H2IcRdRkvmLUpcLxtsR0QBj8Wziu
         Vesw1YJeeNK8g67yToViiZOrPAaIQJBycwOimRy0oehpSLGYq4Y838PHAzbbzZBH0LR8
         sHlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=if5qgNlscRmpJPzG9Z3gnyaxZ0iIBynHsVjhr1Dlctg=;
        b=iHd6nt9IcjtqEYsGsJqaL+Ll2ZHXzeeiPgI56bQu28tzvsIQF6Zans+BjzBHEQ+mlH
         RGAZTGfnqd0Ea1NjUv/J+qPTeiFL0oX7WYgdeyaMQMGqlKLRXOwrDgMmo97RaiSaXInZ
         ZXVgpqFxoxTRXF61ciDivbaTPMNjigKok40ddkjV2JeEH5EewhwXMvs3Nhg+R7q8dDIL
         /iZkLNy9iOy2QQLGXwLSnvoDdgX2aHZyFGEXenxhWzm4UacrZGsG1FLfbifjx3qi+8Yw
         mDkR7R3U1ZkAa+RGfP6xAm+oAiC8xDB2P4n1+2muBXCIg6VQCO77+NK16aPAQt4lCYVR
         elGw==
X-Gm-Message-State: AGi0Pubbj+LscFvT8jQXhpE4Wb50njhBJxa/SLBTyRtOC1NumS8Hncwf
        qYCXi8wQk9yFseJvujT18WGR2M1y6pR28Fo/WZ0=
X-Google-Smtp-Source: APiQypIkTeJRFv9Pb7bCztfKTE6r/gqFVdDFRACyd8JugwVuYo9Fzohu16CEHDV6PG4WB2H/mhehSpBDfnzO3UangrI=
X-Received: by 2002:ac2:4105:: with SMTP id b5mr5786969lfi.94.1588781331398;
 Wed, 06 May 2020 09:08:51 -0700 (PDT)
MIME-Version: 1.0
References: <1588706059-4208-1-git-send-email-jrdr.linux@gmail.com>
 <0bfe4a8a-0d91-ef9b-066f-2ea7c68571b3@nvidia.com> <CAFqt6zZMsQkOdjAb2k1EjwX=DtZ8gKfbRzwvreHOX-0vJLngNg@mail.gmail.com>
 <20200506100649.GI17863@quack2.suse.cz> <CAFqt6zYaNkJ4AfVzutXS=JsN4fE41ZAvnw03vHWpdyiRHY1m_w@mail.gmail.com>
 <20200506125930.GJ17863@quack2.suse.cz>
In-Reply-To: <20200506125930.GJ17863@quack2.suse.cz>
From:   Souptick Joarder <jrdr.linux@gmail.com>
Date:   Wed, 6 May 2020 21:38:40 +0530
Message-ID: <CAFqt6zZztn_AiaGAhV+_uwrnVdKY-xLsxOwYBt-zGmLaat+OhQ@mail.gmail.com>
Subject: Re: [RFC] mm/gup.c: Updated return value of {get|pin}_user_pages_fast()
To:     Jan Kara <jack@suse.cz>
Cc:     John Hubbard <jhubbard@nvidia.com>,
        Tony Luck <tony.luck@intel.com>, fenghua.yu@intel.com,
        Rob Springer <rspringer@google.com>,
        Todd Poynor <toddpoynor@google.com>, benchan@chromium.org,
        Greg KH <gregkh@linuxfoundation.org>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        santosh.shilimkar@oracle.com,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        Ira Weiny <ira.weiny@intel.com>,
        =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>,
        inux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
        "open list:ANDROID DRIVERS" <devel@driverdev.osuosl.org>,
        tee-dev@lists.linaro.org, Linux-MM <linux-mm@kvack.org>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 6, 2020 at 6:29 PM Jan Kara <jack@suse.cz> wrote:
>
> On Wed 06-05-20 17:51:39, Souptick Joarder wrote:
> > On Wed, May 6, 2020 at 3:36 PM Jan Kara <jack@suse.cz> wrote:
> > >
> > > On Wed 06-05-20 02:06:56, Souptick Joarder wrote:
> > > > On Wed, May 6, 2020 at 1:08 AM John Hubbard <jhubbard@nvidia.com> wrote:
> > > > >
> > > > > On 2020-05-05 12:14, Souptick Joarder wrote:
> > > > > > Currently {get|pin}_user_pages_fast() have 3 return value 0, -errno
> > > > > > and no of pinned pages. The only case where these two functions will
> > > > > > return 0, is for nr_pages <= 0, which doesn't find a valid use case.
> > > > > > But if at all any, then a -ERRNO will be returned instead of 0, which
> > > > > > means {get|pin}_user_pages_fast() will have 2 return values -errno &
> > > > > > no of pinned pages.
> > > > > >
> > > > > > Update all the callers which deals with return value 0 accordingly.
> > > > >
> > > > > Hmmm, seems a little shaky. In order to do this safely, I'd recommend
> > > > > first changing gup_fast/pup_fast so so that they return -EINVAL if
> > > > > the caller specified nr_pages==0, and of course auditing all callers,
> > > > > to ensure that this won't cause problems.
> > > >
> > > > While auditing it was figured out, there are 5 callers which cares for
> > > > return value
> > > > 0 of gup_fast/pup_fast. What problem it might cause if we change
> > > > gup_fast/pup_fast
> > > > to return -EINVAL and update all the callers in a single commit ?
> > >
> > > Well, first I'd ask a different question: Why do you want to change the
> > > current behavior? It's not like the current behavior is confusing.  Callers
> > > that pass >0 pages can happily rely on the simple behavior of < 0 return on
> > > error or > 0 return if we mapped some pages. Callers that can possibly ask
> > > to map 0 pages can get 0 pages back - kind of expected - and I don't see
> > > any benefit in trying to rewrite these callers to handle -EINVAL instead...
> >
> > Callers with a request to map 0 pages doesn't have a valid use case. But if any
> > caller end up doing it mistakenly, -errno should be returned to caller
> > rather than 0
> > which will indicate more precisely that map 0 pages is not a valid
> > request from caller.
>
> Well, I believe this depends on the point of view. Similarly as reading 0
> bytes is successful, we could consider mapping 0 pages successful as well.
> And there can be valid cases where number of pages to map is computed from
> some input and when 0 pages should be mapped, it is not a problem and your
> change would force such callers to special case this with explicitely
> checking for 0 pages to map and not calling GUP in that case at all.
>
> I'm not saying what you propose is necessarily bad, I just say I don't find
> it any better than the current behavior and so IMO it's not worth the
> churn. Now if you can come up with some examples of current in-kernel users
> who indeed do get the handling of the return value wrong, I could be
> convinced otherwise.

There are 5 callers of {get|pin}_user_pages_fast().

arch/ia64/kernel/err_inject.c#L145
staging/gasket/gasket_page_table.c#L489

Checking return value 0 doesn't make sense for above 2.

drivers/platform/goldfish/goldfish_pipe.c#L277
net/rds/rdma.c#L165
drivers/tee/tee_shm.c#L262

These 3 callers have calculated the no of pages value before passing it to
{get|pin}_user_pages_fast(). But if they end up passing nr_pages <= 0, a return
value of either 0 or -EINVAL doesn't going to harm any existing
behavior of callers.

IMO, it is safe to return -errno for nr_pages <= 0, for
{get|pin}_user_pages_fast().
