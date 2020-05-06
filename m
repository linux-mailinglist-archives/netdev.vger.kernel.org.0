Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A48D1C7032
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 14:21:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728037AbgEFMVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 08:21:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727804AbgEFMVy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 08:21:54 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9315CC061A0F;
        Wed,  6 May 2020 05:21:53 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id z22so1173532lfd.0;
        Wed, 06 May 2020 05:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VsdP3ulXyls4iZ204aQqnDn+7zgjMQGgDA3wThz23eU=;
        b=GdUooXYhovThJskAw/3M7IDG7gj8w7tq0AF8FoQVdXBmDH9htFVSG68e9l293BiFde
         yh1Ul30jzJ9AzeWJG+sv/pQQKqyUh0vreJXtd3vhdqGNuGGUxu2ad5G+875kvCm+aISC
         XtnDaWgVfa0DXVuJp4e5Tm7VcXSTLygCpXXyNFC9K2iJp5Y2OAY2LBrtGsD9eeoXzmX6
         3yZY//4YvL9ZdNin7luDMYtJU9ltTl2SeU2SjVC2vVSkNQpniXOZVlYDOskC16iDSKUl
         z0lhPUm5LgoZ3ktFfc0tj3iDnDw+kOUvAhfM2/Cb4h0MKWldOXEXsAQdEMbqbvdrL/fD
         xaow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VsdP3ulXyls4iZ204aQqnDn+7zgjMQGgDA3wThz23eU=;
        b=PrklIlv4KdVcF0OxcedBElladLqXItQRqytrW4yucHSREv0w6ejWBRkw6I9cLUxT1A
         7/xIMZnxRRx4Rpi0dZy8SgJBfs3cy2yXymDLAjO/fspJPYh5mY0OriN9qXBoczTNg+q1
         xwlsGZMQLLVc0YbCfBShQLS2XiCWePBtXV4JVN7B8uM/Gu+j5eAWdVwUoxV/2TOwUEVO
         b4T4sgzFbl8PVRQvXHGBGAlczgrTQQfRGufLEPVDt3E9zC1Zj5uwKCWpyVa0p14g9QDy
         gmreVF4RFFbCp77nEX13mSAtv0Bofg2xkiQhMR8xrax9CwjogMzV6Lgh98PLW2znxuDn
         BA8A==
X-Gm-Message-State: AGi0PuZJfWC7UwjVtOZKkiOnNkefReIxMYstLvQWjpQeJIBTMSNkL+xE
        nkpFPf6TYxISgXEs7aGDXDAhfi1Yj/tqexDrXtk=
X-Google-Smtp-Source: APiQypJJaMxo7orst7A0rBZm7DSNbuQvBrp2dLcSV0b/jCmG9BTQfK0MRgFoKlDwi9W2mFj5ZkyMbM1dpu+2wGPtY0I=
X-Received: by 2002:a19:84b:: with SMTP id 72mr4984198lfi.133.1588767712011;
 Wed, 06 May 2020 05:21:52 -0700 (PDT)
MIME-Version: 1.0
References: <1588706059-4208-1-git-send-email-jrdr.linux@gmail.com>
 <0bfe4a8a-0d91-ef9b-066f-2ea7c68571b3@nvidia.com> <CAFqt6zZMsQkOdjAb2k1EjwX=DtZ8gKfbRzwvreHOX-0vJLngNg@mail.gmail.com>
 <20200506100649.GI17863@quack2.suse.cz>
In-Reply-To: <20200506100649.GI17863@quack2.suse.cz>
From:   Souptick Joarder <jrdr.linux@gmail.com>
Date:   Wed, 6 May 2020 17:51:39 +0530
Message-ID: <CAFqt6zYaNkJ4AfVzutXS=JsN4fE41ZAvnw03vHWpdyiRHY1m_w@mail.gmail.com>
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

On Wed, May 6, 2020 at 3:36 PM Jan Kara <jack@suse.cz> wrote:
>
> On Wed 06-05-20 02:06:56, Souptick Joarder wrote:
> > On Wed, May 6, 2020 at 1:08 AM John Hubbard <jhubbard@nvidia.com> wrote:
> > >
> > > On 2020-05-05 12:14, Souptick Joarder wrote:
> > > > Currently {get|pin}_user_pages_fast() have 3 return value 0, -errno
> > > > and no of pinned pages. The only case where these two functions will
> > > > return 0, is for nr_pages <= 0, which doesn't find a valid use case.
> > > > But if at all any, then a -ERRNO will be returned instead of 0, which
> > > > means {get|pin}_user_pages_fast() will have 2 return values -errno &
> > > > no of pinned pages.
> > > >
> > > > Update all the callers which deals with return value 0 accordingly.
> > >
> > > Hmmm, seems a little shaky. In order to do this safely, I'd recommend
> > > first changing gup_fast/pup_fast so so that they return -EINVAL if
> > > the caller specified nr_pages==0, and of course auditing all callers,
> > > to ensure that this won't cause problems.
> >
> > While auditing it was figured out, there are 5 callers which cares for
> > return value
> > 0 of gup_fast/pup_fast. What problem it might cause if we change
> > gup_fast/pup_fast
> > to return -EINVAL and update all the callers in a single commit ?
>
> Well, first I'd ask a different question: Why do you want to change the
> current behavior? It's not like the current behavior is confusing.  Callers
> that pass >0 pages can happily rely on the simple behavior of < 0 return on
> error or > 0 return if we mapped some pages. Callers that can possibly ask
> to map 0 pages can get 0 pages back - kind of expected - and I don't see
> any benefit in trying to rewrite these callers to handle -EINVAL instead...

Callers with a request to map 0 pages doesn't have a valid use case. But if any
caller end up doing it mistakenly, -errno should be returned to caller
rather than 0
which will indicate more precisely that map 0 pages is not a valid
request from caller.
With these, 3rd return value 0, is no more needed.

That was the thought behind this proposal.
