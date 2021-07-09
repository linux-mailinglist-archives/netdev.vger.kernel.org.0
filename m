Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 526FB3C284D
	for <lists+netdev@lfdr.de>; Fri,  9 Jul 2021 19:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbhGIRcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Jul 2021 13:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbhGIRce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Jul 2021 13:32:34 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A89C0613DD
        for <netdev@vger.kernel.org>; Fri,  9 Jul 2021 10:29:49 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id y21-20020a7bc1950000b02902161fccabf1so6355425wmi.2
        for <netdev@vger.kernel.org>; Fri, 09 Jul 2021 10:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/16PvS0+2CUKH8u7VJDHoAVMZui3Hk9OZqyyxl42huQ=;
        b=GAx44MmrmNnReE+9YFn5w2r22huzdUEmMwN1BJ3SqLdVCktaDWJg7nii/srUK3K4Cv
         7oSxU3HM/DbPnMLZrIqh80NQoQalRjwlPWfp2hsXhH09C+2/KbmSb3rkpy4XE2I9JLRQ
         0rlMvAU1oHUKaOqBGg95Whv9chxzz5mViiat25L9NrFGWpcbK1RKQkAOBwPaaE2Ydh5e
         vJrJE7nINrrgbSet/VxUWxAWk707zClxDKKJiwIJIXvsbO6qO6ZAPiOJYUPiHJlpBoKS
         OXU6dIsd9v8f0cWFVP8/El75DOHttXIgZYS0L11ACfevhbI14gVBJFty4YaLf0iHu13N
         XKYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/16PvS0+2CUKH8u7VJDHoAVMZui3Hk9OZqyyxl42huQ=;
        b=Uw0/eFuO6NazlLbi7zDov2vbXtkO0KusglaGjzI0BcThJcIKdpfowgww6mVxdiCDJS
         7M8lFG9aFNrk1tbnVAUXqDcqh07vQp39/MQFSkPHSdSYbY8BODsZkp/2bWKzr/68u49i
         1Lmu4VZy19Kle34vKXkAfyiTsSd5BhWH6aQzSN/R0zK1S/2iBpraunjezXWvsJN/gLbO
         XUfBqnRdUyZYnIi0mH7YwK6BZJhkS709FZKKgPcBiu8v1qs4qsX8DhldgzyrTvXgV4At
         w00nxpC/2JNN8/iYrGCrdX97M6fSpotINsyTPNgdbi4VNPCB/nX2wOHTEmTyVpKvF+gE
         dUHQ==
X-Gm-Message-State: AOAM531e6IzsIWmE/C2hcJri/2QtUWNPE4pUD8DE+LUj3N0xdyQXEkX/
        ouP5mNalj6VgDZ9c7nokLBxjXA==
X-Google-Smtp-Source: ABdhPJzKryW6GqowLOxmfZ+fK6mhCbrYBIk5e9s8Khy0FhvM4qBxO7ZR/idyqmISnRqUIVBWLvlURg==
X-Received: by 2002:a7b:c751:: with SMTP id w17mr11351014wmk.117.1625851788472;
        Fri, 09 Jul 2021 10:29:48 -0700 (PDT)
Received: from enceladus (athedsl-417902.home.otenet.gr. [79.131.184.108])
        by smtp.gmail.com with ESMTPSA id l17sm12217084wmq.3.2021.07.09.10.29.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Jul 2021 10:29:47 -0700 (PDT)
Date:   Fri, 9 Jul 2021 20:29:44 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Lobakin <alobakin@pm.me>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Guillaume Nault <gnault@redhat.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Matteo Croce <mcroce@microsoft.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1 v2] skbuff: Fix a potential race while recycling
 page_pool packets
Message-ID: <YOiHiGi3bY8g2CEd@enceladus>
References: <20210709062943.101532-1-ilias.apalodimas@linaro.org>
 <CAKgT0UdQmrzZufHpvRBtWgbFdTCVmKH4Vx6GzwtmC9FuM8K+hg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0UdQmrzZufHpvRBtWgbFdTCVmKH4Vx6GzwtmC9FuM8K+hg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 09, 2021 at 07:34:38AM -0700, Alexander Duyck wrote:
> On Thu, Jul 8, 2021 at 11:30 PM Ilias Apalodimas
> <ilias.apalodimas@linaro.org> wrote:
> >
> > As Alexander points out, when we are trying to recycle a cloned/expanded
> > SKB we might trigger a race.  The recycling code relies on the
> > pp_recycle bit to trigger,  which we carry over to cloned SKBs.
> > If that cloned SKB gets expanded or if we get references to the frags,
> > call skbb_release_data() and overwrite skb->head, we are creating separate
> > instances accessing the same page frags.  Since the skb_release_data()
> > will first try to recycle the frags,  there's a potential race between
> > the original and cloned SKB, since both will have the pp_recycle bit set.
> >
> > Fix this by explicitly those SKBs not recyclable.
> > The atomic_sub_return effectively limits us to a single release case,
> > and when we are calling skb_release_data we are also releasing the
> > option to perform the recycling, or releasing the pages from the page pool.
> >
> > Fixes: 6a5bcd84e886 ("page_pool: Allow drivers to hint on SKB recycling")
> > Reported-by: Alexander Duyck <alexanderduyck@fb.com>
> > Suggested-by: Alexander Duyck <alexanderduyck@fb.com>
> > Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> > ---
> > Changes since v1:
> > - Set the recycle bit to 0 during skb_release_data instead of the
> >   individual fucntions triggering the issue, in order to catch all
> >   cases
> >  net/core/skbuff.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> > index 12aabcda6db2..f91f09a824be 100644
> > --- a/net/core/skbuff.c
> > +++ b/net/core/skbuff.c
> > @@ -663,7 +663,7 @@ static void skb_release_data(struct sk_buff *skb)
> >         if (skb->cloned &&
> >             atomic_sub_return(skb->nohdr ? (1 << SKB_DATAREF_SHIFT) + 1 : 1,
> >                               &shinfo->dataref))
> > -               return;
> > +               goto exit;
> >
> >         skb_zcopy_clear(skb, true);
> >
> > @@ -674,6 +674,8 @@ static void skb_release_data(struct sk_buff *skb)
> >                 kfree_skb_list(shinfo->frag_list);
> >
> >         skb_free_head(skb);
> > +exit:
> > +       skb->pp_recycle = 0;
> >  }
> >
> >  /*
> > --
> > 2.32.0.rc0
> >
> 
> This is probably the cleanest approach with the least amount of
> change, but one thing I am concerned with in this approach is that we
> end up having to dirty a cacheline that I am not sure is otherwise
> touched during skb cleanup. I am not sure if that will be an issue or
> not. If it is then an alternative or follow-on patch could move the
> pp_recycle flag into the skb_shared_info flags itself and then make
> certain that we clear it around the same time we are setting
> shinfo->dataref to 1.
> 

Yep that's a viable alternative. Let's see if there's any measurable
impact.

> Otherwise this looks good to me.
> 
> Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

Thanks Alexander!

