Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7DB1D82B9
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 19:58:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731955AbgERR6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 13:58:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731945AbgERR6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 13:58:45 -0400
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A909C061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 10:58:45 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id 63so8854547oto.8
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 10:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=RubWoVHwXtu/OtDLvcExamZNdRA6YxLeSiOYrp2Oruo=;
        b=TWpkhyCmbCzo0Qz942pvYsN7xB3JeCyUytV4WNzUyJpkVJqnrToDZ/UVOHbwJ6IAhU
         2kqRfdjAnTxb2FQ7His0tSxGF4ncqToQlh9rgM7B5xIonyVJR7ShlXgngLr9ayb6Hm9V
         EgKQ2gJTx0VHBVE97wXE/4KBMxgAe6LmBaBLR7/utbMAMRB8xDUs7JO1tgTmr+4ZWTE8
         uAWWwrpZbp94XALk1wHvsKWBnkCBJBFRD/l/twNMWY5PIqNEPHWMqaoqMfna6hsAMG+O
         wN5huylksWzJVT2p5tCRBhdsnKMWVbUIO0MdOvVwhYPgV4WbmZYqtTGKbufeXinOOUkS
         751A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=RubWoVHwXtu/OtDLvcExamZNdRA6YxLeSiOYrp2Oruo=;
        b=BRiKgtHQd09zAw4Rh094B7XLqOBcDPvVvIB8uxWQEP2VL0JVrjjg9XXBKL/fH89hzG
         1hWmJrtUnuV9gcJ2rwRPihUgfdgf/ZWDDvQBe+K7DrKR4bgZ1nnri1/e0slL8qrdNw2N
         O7a0Zg16nIfZV92Zjh+vNTR272JSAEkIlhTtPi3fBHKA1ZSFagDS4FcdoJsirHsbjz81
         uBd3KNMyFH+ru9kGc3zs7jLkJQZwvr5RX7g5cxhSC+pAr0gOFrjpDc+28OeheMX3Ox6A
         btjSEVYpQk7GDO2fHSpwrcmernh0Lr6N8wwV4uoPe3gfbSNzMmL3PgE1Vv8RH2+RMwt2
         pBCw==
X-Gm-Message-State: AOAM530i6wl1W+1kEKv4zqMzlwNAsX4NdLee7eqO5t2e/rpto5d0LIwV
        yahGMOW7d3eO8agI6Rd2I8EZX1FgMFT1wgyUOYE2oD8Kt3g=
X-Google-Smtp-Source: ABdhPJwbW6hHE0M15qJG3qz6EKmVSjO/xqcaym3d/zE5WulHllLO+eLdQMC/KEmTy7CCo6dMDQKfoSsul8YFgJXPkwg=
X-Received: by 2002:a9d:d0a:: with SMTP id 10mr12886728oti.189.1589824724908;
 Mon, 18 May 2020 10:58:44 -0700 (PDT)
MIME-Version: 1.0
References: <1589719591-32491-1-git-send-email-mrv@mojatatu.com>
 <CAM_iQpXx-yBm2jQ57L+vkiU+hR4VExgzFrntw3R2HmOFpzF5Ug@mail.gmail.com>
 <85y2pqm4jq.fsf@mojatatu.com> <25cff61e-5068-e25d-4554-a3ed3ccb0373@mojatatu.com>
In-Reply-To: <25cff61e-5068-e25d-4554-a3ed3ccb0373@mojatatu.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 18 May 2020 10:58:34 -0700
Message-ID: <CAM_iQpXi2qCXE31TA_y9-DFUL3TcPL3ucbX88WxB_=pzSvWUWw@mail.gmail.com>
Subject: Re: [PATCH net 1/1] net sched: fix reporting the first-time use timestamp
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Roman Mashak <mrv@mojatatu.com>,
        David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        kernel@mojatatu.com, Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 18, 2020 at 5:43 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> On 2020-05-17 9:10 p.m., Roman Mashak wrote:
> > Cong Wang <xiyou.wangcong@gmail.com> writes:
> >
> >> On Sun, May 17, 2020 at 5:47 AM Roman Mashak <mrv@mojatatu.com> wrote:
> >>>
> >>> When a new action is installed, firstuse field of 'tcf_t' is explicitly set
> >>> to 0. Value of zero means "new action, not yet used"; as a packet hits the
> >>> action, 'firstuse' is stamped with the current jiffies value.
> >>>
> >>> tcf_tm_dump() should return 0 for firstuse if action has not yet been hit.
> >>
> >> Your patch makes sense to me.
> >>
> >> Just one more thing, how about 'lastuse'? It is initialized with jiffies,
> >> not 0, it seems we should initialize it to 0 too, as it is not yet used?
> >
> > Yes, exactly. I was planning to send a separate patch for this.
> >
> > Thanks for review, Cong.
> >
>
> For these corner cases, firstuse using zero to indicate
> "has not been used" is not ambigious.
> lastuse has ambiguity because zero now has two meanings
> if you check for the corner case in the kernel.
> 1)Zero is a legit value when dumping or
> getting (example an action was just hit when you dumped).
> 2) zero also now means "has not been used".

Well, technically firstuse could be a legit 0 too, when the
action was just hit for the first time right when dumping.
So the ambiguity is same for both.

>
> My suggestion is to leave this alone in the kernel.
> In user space/iproute2 check if lastused and created
> are equal and declare "has not been used".

Sounds a good idea to me.

Thanks.
