Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AEE81D8772
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 20:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729037AbgERSqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 14:46:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727938AbgERSqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 14:46:33 -0400
Received: from mail-oo1-xc44.google.com (mail-oo1-xc44.google.com [IPv6:2607:f8b0:4864:20::c44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71580C061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 11:46:33 -0700 (PDT)
Received: by mail-oo1-xc44.google.com with SMTP id i9so2278763ool.5
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 11:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lqKtfXK5GrdN7bjIh6Yjghx4pPP5xkRWFQGHVW/WpDg=;
        b=Oa2jWGpfwJvzrQqbnv+jqJUvXxn/mO+CVyO7Ou4u+NxbNA5sgWtj5VnZl9tFsGiWBc
         h3zC24RbnUm+0rMhBe/t32ecpyao+gZ6+KoCxCYktlktvCs0JTjFjLHXl6JG3HWL6ZDv
         Ra26dISwC5FG231x8jslL+cdRsHVMNcCtR5+ncomm2q+UbDS1j0ffVhDAALdyNcxtgWQ
         pydgyzjl8KnTvbSKto0Alz4Zivo+JaCI9foEmLR+dz7WIyOVX7BVf2esl8B0sZxOvrPM
         Cr+4J96CRXTnhxosRDxoEMNE75HXVYsbyDBfseHzcIIN7hWIuQPXk9gLewFjnmy1Mv8Z
         A62A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lqKtfXK5GrdN7bjIh6Yjghx4pPP5xkRWFQGHVW/WpDg=;
        b=lwMSb6XzDh6/KxXzhewBkUTFLG7R6gdEQrt2Kvo5MrNTxnkRFxp9meBVGL3BIY1fy0
         nGLO/A7sHa6PKpn0L1qMKhVIupJk5osTyQX7mt6Iwi/jZ2lQY0dogS5FD+B9L8993eTK
         EGPVul7gowpvuwt4T4KvOcP3R6TtNUIPP+hoF9T+yIzlov5JojvkbBKFv6xeUaeBMKCO
         Oj2Xh21VKr6yyXft4jDQur042P1Zo46YL0/sCnCMHlzbF5J4mbsu0kg/PMwlf2f710s2
         HDZxaegKgylSo0+mC/BEp7KmO6JdcAtAGOPQ1MXL+2/JAwx5fPJYHIBBJaE8RTkaew0V
         9Z5Q==
X-Gm-Message-State: AOAM533LN6yUOf3RHuKOHzd10PFQXq5PHBOSqLWUU4NEcoEOehop5wxK
        V26Q5njF40L1CcomsRI+/mgijQrt59e5cGAPj9Y=
X-Google-Smtp-Source: ABdhPJyAepEMzEeDvyw5puu1vthGjIK3MCkm665dZoM/twTUi1qTIvU1akYC+JydAafVapd0RmoBKD6BP0CSMlRMb3Y=
X-Received: by 2002:a4a:5147:: with SMTP id s68mr13955477ooa.86.1589827592731;
 Mon, 18 May 2020 11:46:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200515114014.3135-1-vladbu@mellanox.com> <CAM_iQpXtqZ-Uy=x_UzTh0N0_LRYGp-bFKyOwTUMNLaiVs=7XKQ@mail.gmail.com>
 <vbf4ksdpwsu.fsf@mellanox.com>
In-Reply-To: <vbf4ksdpwsu.fsf@mellanox.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 18 May 2020 11:46:21 -0700
Message-ID: <CAM_iQpXdyFqBO=AkmLqVW=dZxQ3SfjKp71BxsKRuyhaoVuMEfg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 0/4] Implement classifier-action terse dump mode
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     Jiri Pirko <jiri@resnulli.us>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 17, 2020 at 11:44 PM Vlad Buslov <vladbu@mellanox.com> wrote:
>
>
> On Sun 17 May 2020 at 22:13, Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > On Fri, May 15, 2020 at 4:40 AM Vlad Buslov <vladbu@mellanox.com> wrote:
> >>
> >> Output rate of current upstream kernel TC filter dump implementation if
> >> relatively low (~100k rules/sec depending on configuration). This
> >> constraint impacts performance of software switch implementation that
> >> rely on TC for their datapath implementation and periodically call TC
> >> filter dump to update rules stats. Moreover, TC filter dump output a lot
> >> of static data that don't change during the filter lifecycle (filter
> >> key, specific action details, etc.) which constitutes significant
> >> portion of payload on resulting netlink packets and increases amount of
> >> syscalls necessary to dump all filters on particular Qdisc. In order to
> >> significantly improve filter dump rate this patch sets implement new
> >> mode of TC filter dump operation named "terse dump" mode. In this mode
> >> only parameters necessary to identify the filter (handle, action cookie,
> >> etc.) and data that can change during filter lifecycle (filter flags,
> >> action stats, etc.) are preserved in dump output while everything else
> >> is omitted.
> >>
> >> Userspace API is implemented using new TCA_DUMP_FLAGS tlv with only
> >> available flag value TCA_DUMP_FLAGS_TERSE. Internally, new API requires
> >> individual classifier support (new tcf_proto_ops->terse_dump()
> >> callback). Support for action terse dump is implemented in act API and
> >> don't require changing individual action implementations.
> >
> > Sorry for being late.
> >
> > Why terse dump needs a new ops if it only dumps a subset of the
> > regular dump? That is, why not just pass a boolean flag to regular
> > ->dump() implementation?
> >
> > I guess that might break user-space ABI? At least some netlink
> > attributes are not always dumped anyway, so it does not look like
> > a problem?
> >
> > Thanks.
>
> Hi Cong,
>
> I considered adding a flag to ->dump() callback but decided against it
> for following reasons:
>
> - It complicates fl_dump() code by adding additional conditionals. Not a
>   big problem but it seemed better for me to have a standalone callback
>   because with combined implementation it is even hard to deduce what
>   does terse dump actually output.

This is not a problem, at least you can add a big if in fl_dump(),
something like:

if (terse) {
  // do terse dump
  return 0;
}
// normal dump

>
> - My initial implementation just called regular dump for classifiers
>   that don't support terse dump, but in internal review Jiri insisted
>   that cls API should fail if it can't satisfy user's request and having
>   dedicated callback allows implementation to return an error if
>   classifier doesn't define ->terse_dump(). With flag approach it would
>   be not trivial to determine if implementation actually uses the flag.

Hmm? For those not support terse dump, we can just do:

if (terse)
  return -EOPNOTSUPP;
// normal dump goes here

You just have to pass 'terse' flag to all implementations and let them
to decide whether to support it or not.


>   I guess I could have added new tcf_proto_ops->flags value to designate
>   terse dump support, but checking for dedicated callback existence
>   seemed like obvious approach.

This does not look necessary, as long as we can just pass the flag
down to each ->dump().

Thanks.
