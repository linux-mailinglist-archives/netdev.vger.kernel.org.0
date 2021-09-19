Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A403410DDA
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 01:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbhISXkI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Sep 2021 19:40:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbhISXkH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Sep 2021 19:40:07 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31CC7C061574
        for <netdev@vger.kernel.org>; Sun, 19 Sep 2021 16:38:42 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id m21-20020a17090a859500b00197688449c4so11399314pjn.0
        for <netdev@vger.kernel.org>; Sun, 19 Sep 2021 16:38:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2hD7BC3KFZqKqqhcXS1CiahfKeFXgcDCE2o0JY2ktgY=;
        b=DypUIABE7ttg5qbGsukUx3j6JodsIjH5gq8UofJW1HCqEObhy+kQSj45sE0x+Yb9Ml
         /48qGpEu3G7l6CVDGHVUlEm3MN3BmFRYTzpgYTsWo95XkgHxz5hsk4XTD/YUIOQ7jWqy
         s5K9KGLydnxHHuczwjwAZ3BdI8V3eTGpZEQEP2fmWf7dKFjTTPsVnNjf12qrEcJ7p7Wd
         o6gKc+X08IRZYOYG55AHbw4Cw6Wd1YSI//iyAit22KXI0MCkA6NnqfAVAXaBd3Bx1p9x
         1R8bpn7x4H2BvA1WGzP7K+gI/SFn9bqEv0PrtIV4sSnUFNs/bYOC/Vf7sEj79/eJzphV
         tmtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2hD7BC3KFZqKqqhcXS1CiahfKeFXgcDCE2o0JY2ktgY=;
        b=bkAmKsUfwkhArsXlghIWLqYwlN1npxZom1+1ORiyjW33CCAq/W6WZPYssSm2jXAPJb
         uai8kwi4zO6wvlYTkZKpsjn/gbknavvljrCVV0GvnNZj4Updxw8wMVJv9tJhVXBbCfl2
         EIEafvn4QZyQaoYLBEp4yfZBDCo9KWfem98aXAXKEZ4sw5D+NNBDA1azA88pEhqaAnZ0
         w7z5yRP6TOaXXFRoHoDvuMpk5r/E55KBmTZf8JCgBYffPnAyFBIgrz4cvrOMVHMfkg5D
         +kuvAPQcEOiYiCGMr11Bpd7N+Mm/2bzPl9D4GNttV5rkgy/a43gX/k7Bv2EPKpUVmBRc
         WnPA==
X-Gm-Message-State: AOAM530+vZNyEg9GKJDyfAUEs0j+iIfhWJEzV1LpD2DjFjTfFWgltftR
        EkaqTVZkuiMnhY5GWrg3gPN43spgyGmT8ZSQGnI=
X-Google-Smtp-Source: ABdhPJy1llkgMBvr1VzZCBltLMVo7AivGJl7lH9atfk3m4FfYnRgVniTBbVjW9pgAzCR0t+wPmW93cFTUZjg5i2RhWw=
X-Received: by 2002:a17:902:e282:b0:13a:45b7:d2cd with SMTP id
 o2-20020a170902e28200b0013a45b7d2cdmr20210011plc.86.1632094721764; Sun, 19
 Sep 2021 16:38:41 -0700 (PDT)
MIME-Version: 1.0
References: <20210913225332.662291-1-kuba@kernel.org> <20210913225332.662291-2-kuba@kernel.org>
 <CAM_iQpVec_FY-71n3VUUgo8YCcn00+QzBBck9h1RGNaFzXX_ig@mail.gmail.com>
 <20210915123642.218f7f11@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAM_iQpW553fnxXxC+BLkhzsGixoufNrjzRTrhFKo_gsE9xPwbQ@mail.gmail.com> <20210917060859.637dd9c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210917060859.637dd9c0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 19 Sep 2021 16:38:30 -0700
Message-ID: <CAM_iQpUmPv8BjFLyS9faR+OCfeW5L6=qyLem5MhgXxk=J2iiyw@mail.gmail.com>
Subject: Re: [PATCH net-next 1/3] net: sched: update default qdisc visibility
 after Tx queue cnt changes
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Eric Dumazet <edumazet@google.com>,
        Matthew Massey <matthewmassey@fb.com>,
        Dave Taht <dave.taht@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 17, 2021 at 6:09 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 16 Sep 2021 22:46:42 -0700 Cong Wang wrote:
> > On Wed, Sep 15, 2021 at 12:36 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > > On Wed, 15 Sep 2021 09:31:08 -0700 Cong Wang wrote:
> > > > Don't we need to flip the device with dev_deactivate()+dev_activate()?
> > > > It looks like the only thing this function resets is qdisc itself, and only
> > > > partially.
> > >
> > > We're only making the qdiscs visible, there should be
> > > no datapath-visible change.
> >
> > Isn't every qdisc under mq visible to datapath?
> >
> > Packets can be pending in qdisc's, and qdisc's can be scheduled
> > in TX softirq, so essentially we need to flip the device like other
>
> By visible I mean tc qdisc dump shows them. I'm adding/removing
> the qdiscs to netdev->qdisc_hash. That's only used by control
> paths to dump or find qdiscs by handle.

Oh, I see, I missed this difference. If datapath can't see this change
immediately, we don't need to flip it.

Thanks.
