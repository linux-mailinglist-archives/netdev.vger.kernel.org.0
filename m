Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 577E12A777D
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 07:34:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730061AbgKEGej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 01:34:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbgKEGej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 01:34:39 -0500
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9E4CC0613CF
        for <netdev@vger.kernel.org>; Wed,  4 Nov 2020 22:34:38 -0800 (PST)
Received: by mail-il1-x144.google.com with SMTP id z2so402471ilh.11
        for <netdev@vger.kernel.org>; Wed, 04 Nov 2020 22:34:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oCaMrOHH4xrnuGU6GOnuJLAZKZJkXd4m10ZBlU0hpEw=;
        b=hKENIChLsaI9gYgGg4jESwqrKIO09KSkgEhRLJGYJRBaQmrjxQSSKreUCAL15vXWsD
         c4mhh5ACaip2hP4kuIJFfxc6zbFtz+CjEKAtdoavGqkVK7/1MC9VzbmwjAdwUJ/Ap9GH
         pWqqZvVRaB/ekKFj3Zh7aDT29galmigcO2lUFRyJC+8w7IIG3s+dc0d6/EXvKxNTV3II
         ISfAhGuRdF/OViBgUZgZfTozPFqxkeaTV76DF820PyK9XisJUCjVxwj/77d1keofIGe8
         yCMuW0UYjZ7dF9FmCZOKDprsSscmmzJt4i2oNTJi3rp/SVVMQiWYeryG3fXY9TxK/f4A
         DT1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oCaMrOHH4xrnuGU6GOnuJLAZKZJkXd4m10ZBlU0hpEw=;
        b=SDWmNFieTZ6oLNf2mao+vLVmX30bfdf9y6IFw6pq+n6f4s8+0WgH9VJppwe8GHk1gx
         B2qx2oE716qetsQOFmjtJSf0Q0E4F2Cmkr/A33Rqyh0reF84sKbcHC8IDScHiM+tQZ0R
         QU+Yljkb/kdFFeynDlXF/E3evwcrrT504WgXobkvTl+/lEleI0LqodjTRW7X4c0ri4x7
         96yCoNqoOKT9p6OpuyFZUffoQPwjat3iXvaa9yxaSZR43YIg2sVXqYLy4ANXhEy/oBxz
         jq8hq7mO5pLz821ONIeTedqP3qxPGIv9ewuikLJ1O/07FOWH+BnTWUKkbhLaJZ3Pu0Ge
         e04g==
X-Gm-Message-State: AOAM531VD0iHyTvlQr6nnHF6VasJw7JvTkGbVeZ1WOK5wz+KqTFRczXq
        ToFmo9rOLjh+eanPr0LvjRpuoOoaajoZIOgh9YR3vp4Gc5M=
X-Google-Smtp-Source: ABdhPJwjd5HhQ8DVkGWDJJsday8+tpkdDIYu+5X0rBEvIRnuTEYILsGgCh5p6ZgY4OcUBB3Y8vPcLkjM3V+EYzO14Ig=
X-Received: by 2002:a92:c04c:: with SMTP id o12mr861196ilf.22.1604558078335;
 Wed, 04 Nov 2020 22:34:38 -0800 (PST)
MIME-Version: 1.0
References: <20201102201243.287486-1-vlad@buslov.dev> <20201104163916.4cf9b2dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201104163916.4cf9b2dc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 4 Nov 2020 22:34:27 -0800
Message-ID: <CAM_iQpUn2v94cUeE9MmK2__Hsf+rumq-cRNrnRN2iyUn1M1hug@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: sched: implement action-specific terse dump
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Vlad Buslov <vlad@buslov.dev>, Jamal Hadi Salim <jhs@mojatatu.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 4, 2020 at 4:39 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon,  2 Nov 2020 22:12:43 +0200 Vlad Buslov wrote:
> > Allow user to request action terse dump with new flag value
> > TCA_FLAG_TERSE_DUMP. Only output essential action info in terse dump (kind,
> > stats, index and cookie, if set by the user when creating the action). This
> > is different from filter terse dump where index is excluded (filter can be
> > identified by its own handle).
> >
> > Move tcf_action_dump_terse() function to the beginning of source file in
> > order to call it from tcf_dump_walker().
> >
> > Signed-off-by: Vlad Buslov <vlad@buslov.dev>
> > Suggested-by: Jamal Hadi Salim <jhs@mojatatu.com>
>
> Jiri, Cong, can I get an ack?
>
> The previous terse dump made sense because it fulfilled the need of
> an important user (OvS). IDK if this is as clear-cut, and I haven't
> followed the iproute2 thread closely enough, so please weigh in.

Like I said in the previous discussion, I am not a fan of terse dump,
but before we have a better solution here, using this flag is probably
the best we have on the table, so at least for a temporary solution:

Acked-by: Cong Wang <xiyou.wangcong@gmail.com>

Thanks.
