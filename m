Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5830B247762
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 21:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732723AbgHQTsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 15:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732631AbgHQTsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 15:48:01 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4263AC061389
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 12:48:01 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id z6so18853706iow.6
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 12:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nLiYGIDs7Rg8zdSPdf2kY6/a1Nkr7+zk8Xu3n9vkhCM=;
        b=FMF66r36hiOvqpFsXpDGoVkcIASDLANru8gqY6E6GdXglvuVOCLtIIDBtoBLdid9A/
         rQU8OvmWAdW0q6jB6+PGGcqDS3NMdBi8qQhwyf2nCgTHDMnsna+mAbiXeNKXmASeDsRb
         AarbghodnklU5XL4aNr62ICrx3DSZ0h/zzdn3jJTIBsunJuOYG55X9Prde9jYCDDg2iB
         Inot/EsmGSvwW7/k0o2eq4B5HCOcJq2VC9YdAVhbK+m7GgYGvuaCn9nzychCBDPspVO+
         1sY6TCD2/oRyt7GhR9nkc2momVysI2/7Jc0rBK+wuKb2voChUePd7tH0aLlUIxqhEmvu
         5PNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nLiYGIDs7Rg8zdSPdf2kY6/a1Nkr7+zk8Xu3n9vkhCM=;
        b=LHZGNV15YQ/wPjShNc0HX19/SlrYaPP+Be3AAB78vKJYZhkCen1xEhrDIX6n+KySip
         J+9eU+8CwpLMSIE4IYqAqLr2Y31jfx7/r+WXs9arhn5GI1vexBu41YboQjWHAsgy93u8
         sVEN/MWEngv4OuGdq9CuUDwhhXqduNl5OpqcMMM1+s7jauEleu4e8SBgvDZae1FA2QRh
         lGyoUkKLrB5NmUG3MnULgIGN/SiDN/jxtVV2esjlxptgpJwV3AaFrbIT1z1PWwQjZCnc
         cZ3DhP1lIwk3HDAQGTMVaDUfYl3J+bM0J2aR2FgiIqdFj3R0FYxijsEbBxFDnR8Vz0qk
         979w==
X-Gm-Message-State: AOAM532hbI7I4+zW53YSgP1aUuXx0oLX8OSfXvP7Nvq6NGmdnQpBZJ/W
        H5dphpmUFsg8LSPGcVumbj5zuU8IqxdDwNG8bQZreynGKaseXQ==
X-Google-Smtp-Source: ABdhPJxd6hcxTBBIcQHVBC5QYetoNtoOoKEvXIYNTaswwaApv5VIDHVpCZJkLWiRmnBDdHdQd2SkzpyEsgc7LVo8Gw4=
X-Received: by 2002:a02:29ca:: with SMTP id p193mr16499470jap.131.1597693680601;
 Mon, 17 Aug 2020 12:48:00 -0700 (PDT)
MIME-Version: 1.0
References: <20200807222816.18026-1-jhs@emojatatu.com> <CAM_iQpU6j2TVOu2uYFcFWhBdMj_nu1TuLWfnR3O+2F2CPG+Wzw@mail.gmail.com>
 <3ee54212-7830-8b07-4eed-a0ddc5adecab@mojatatu.com> <CAM_iQpU6KE4O6L1qAB5MjJGsc-zeQwx6x3HjgmevExaHntMyzA@mail.gmail.com>
 <64844778-a3d5-7552-df45-bf663d6498b6@mojatatu.com> <CAM_iQpVBs--KBGe4ZDtUJ0-FsofMOkfnUY=bWJjE0_dFYmv5SA@mail.gmail.com>
 <c8722128-71b7-ad83-b142-8d53868dafc6@mojatatu.com>
In-Reply-To: <c8722128-71b7-ad83-b142-8d53868dafc6@mojatatu.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 17 Aug 2020 12:47:49 -0700
Message-ID: <CAM_iQpX71-jFUddZoSQrXWpd0KRpi0ueoK=h3ugBh5ufYvqLEQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/1] net/sched: Introduce skb hash classifier
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Ariel Levkovich <lariel@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 17, 2020 at 4:19 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> On 2020-08-16 2:59 p.m., Cong Wang wrote:
> > On Thu, Aug 13, 2020 at 5:52 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
>
> [..]
> >> How do you know whether to use hash or mark or both
> >> for that specific key?
> >
> > Hmm, you can just unconditionally pass skb->hash and skb->mark,
> > no? Something like:
> >
> > if (filter_parameter_has_hash) {
> >      match skb->hash with cls->param_hash
> > }
> >
> > if (filter_parameter_has_mark) {
> >      match skb->mark with cls->param_mark
> > }
> >
>  >
> > fw_classify() uses skb->mark unconditionally anyway, without checking
> > whether it is set or not first.
> >
>
> There is no ambiguity of intent in the fw case, there is only one field.
> In the case of having multiple fields it is ambigious if you
> unconditionally look.
>
> Example: policy says to match skb mark of 5 and hash of 3.
> If packet arrives with skb->mark is 5 and skb->hash is 3
> very clearly matched the intent of the policy.
> If packet arrives withj skb->mark 7 and hash 3 it clearly
> did not match the intent. etc.

This example clearly shows no ambiguous, right? ;)


>
> > But if filters were put in a global hashtable, the above would be
> > much harder to implement.
> >
>
> Ok, yes. My assumption has been you will have some global shared
> structure where all filters will be installed on.

Sure, if not hashtable, we could simply put them in a list:

list_for_each_filter {
  if (filter_parameter_has_hash) {
    match skb->hash with cls->param_hash
  }
  if (filter_parameter_has_mark) {
    match skb->mark with cls->param_mark
  }
}


>
> I think i may have misunderstood all along what you were saying
> which is:
>
> a) add the rules so they are each _independent with different
>     priorities_ in a chain.

Yes, because this gives users freedom to pick a different prio
from its value (hash or mark).


>
> b)  when i do lookup for packet arrival, i will only see a filter
>   that matches "match mark 5 and hash 3" (meaning there is no
>   ambiguity on intent). If packet data doesnt match policy then
>   i will iterate to another filter on the chain list with lower
>   priority.

Right. Multiple values mean AND, not OR, so if you specify
mark 5 and hash 3, it will match skb->mark==5 && skb->hash==3.
If not matched, it will continue the iteration until the end.

>
> Am i correct in my understanding?
>
> If i am - then we still have a problem with lookup scale in presence
> of a large number of filters since essentially this approach
> is linear lookup (similar problem iptables has). I am afraid
> a hash table or something with similar principle goals is needed.

Yeah, this is why I asked you whether we have to put them in a
hashtable in previous emails, as hashtable organizes them with
a key, it is hard to combine multiple fields in one key and allow
to extend easily in the future. But other people smarter than me
may have better ideas here.

Thanks.
