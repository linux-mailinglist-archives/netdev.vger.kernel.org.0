Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 853921DA01A
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 20:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726831AbgESS6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 14:58:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726407AbgESS6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 14:58:45 -0400
Received: from mail-oo1-xc44.google.com (mail-oo1-xc44.google.com [IPv6:2607:f8b0:4864:20::c44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F410C08C5C0
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 11:58:45 -0700 (PDT)
Received: by mail-oo1-xc44.google.com with SMTP id c187so193629ooc.2
        for <netdev@vger.kernel.org>; Tue, 19 May 2020 11:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UgpBk3iFedGLxfckoRICuNoOR+P8sQ3rwgF8ZOEEfCI=;
        b=dsOMAfBhwdX7Wkx/EnVCXNafjPjYcpIUrbWy1EkAzixwn+sBC+y9oQ3XPpqCIzWP2t
         RzruhAHKyJK6TvwKutefOl4/ZJp/C0ARRm2zppsOdDFj9/RknQwNMoJd9Ns9mnlzMNtP
         /+aQyzhCoDy3zkvH/6eYJ933mbC9rzb7DWW5r/ROKMlh9DycqK8Uy+5DsQnSztcO807i
         JQaoI+FsVVBJ0rjlnU2kgNcz4jGwfS6JHFFGHH8w7p52z+pc6sU1Nug2oTqgOOWUgqRM
         Wp1kMzSDM6wLcxGm/krgVFum9goAQQJHWrercZy0QslYxH/1h1p/9tsdhiy5rcJmjv8S
         E1Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UgpBk3iFedGLxfckoRICuNoOR+P8sQ3rwgF8ZOEEfCI=;
        b=c4leC4zVcwQXVZja8wCvrfBn79A0zU2M8pravcNZlSiCEposJeBhIT4aIM7oOBe0xG
         EPj/FVZa3wqMx4y7R7Wb1/yKNO60nhpHZQmdtJQJuJFL0pZtvzzcNRbchiFLGFD4j5vF
         gZzUgComKjxRydLPJeL2SpkFd+Q8rSQDlaI2fVty+SjoGIPSF9KcULkBjQypc5iFFdbw
         Q1xXqeVmp8CPA56DNawRBIDucVi56vWFu/eY+MWyJq5RcLAGyU/L0ZXyPkzNv3IftEOu
         N94gLm6a0cVy5izPeNZAc633hUfWuFOZksoheUACsACDfL0nGtPTGsBBFEPAfFSKd/D5
         MCjQ==
X-Gm-Message-State: AOAM533Jzr2vMksmZKQdXddqu60r53ZCnhIhqCDFe5LKTaHneFrla4oV
        LfaIk/V0x+7n1tPQwl9W3CbzGK1VH1vCubifC/g=
X-Google-Smtp-Source: ABdhPJxnK+sqU/1vtQ/OwmmmScicdmRqKhnGV+W8qXTNLLZdNVugfAhkKau1PMMnVJT2FVWoZB8N3ndRlA17KEvlDVY=
X-Received: by 2002:a4a:dbc7:: with SMTP id t7mr482524oou.48.1589914724274;
 Tue, 19 May 2020 11:58:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200515114014.3135-1-vladbu@mellanox.com> <649b2756-1ddf-2b3e-cd13-1c577c50eaa2@solarflare.com>
 <vbfo8qkb8ip.fsf@mellanox.com>
In-Reply-To: <vbfo8qkb8ip.fsf@mellanox.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 19 May 2020 11:58:33 -0700
Message-ID: <CAM_iQpXqLdAJOcwyQ=DZs5zi=zEtr97_LT9uhPtTTPke=8Vvdw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 0/4] Implement classifier-action terse dump mode
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     Edward Cree <ecree@solarflare.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Davide Caratti <dcaratti@redhat.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 19, 2020 at 2:04 AM Vlad Buslov <vladbu@mellanox.com> wrote:
> I considered that approach initially but decided against it for
> following reasons:
>
> - Generic data is covered by current terse dump implementation.
>   Everything else will be act or cls specific which would result long
>   list of flag values like: TCA_DUMP_FLOWER_KEY_ETH_DST,
>   TCA_DUMP_FLOWER_KEY_ETH_DST, TCA_DUMP_FLOWER_KEY_VLAN_ID, ...,
>   TCA_DUMP_TUNNEL_KEY_ENC_KEY_ID, TCA_DUMP_TUNNEL_KEY_ENC_TOS. All of
>   these would require a lot of dedicated logic in act and cls dump
>   callbacks. Also, it would be quite a challenge to test all possible
>   combinations.

Well, if you consider netlink dump as a database query, what Edward
proposed is merely "select COLUMN1 COLUMN2 from cls_db" rather
than "select * from cls_db".

No one said it is easy to implement, it is just more elegant than you
select a hardcoded set of columns for the user.

Think about it, what if another user wants a less terse dump but still
not a full dump? Would you implement ops->terse_dump2()? Or
what if people still think your terse dump is not as terse as she wants?
ops->mini_dump()? How many ops's we would end having?


>
> - It is hard to come up with proper validation for such implementation.
>   In case of terse dump I just return an error if classifier doesn't
>   implement the callback (and since current implementation only outputs
>   generic action info, it doesn't even require support from
>   action-specific dump callbacks). But, for example, how do we validate
>   a case where user sets some flower and tunnel_key act dump flags from
>   previous paragraph, but Qdisc contains some other classifier? Or
>   flower classifier points to other types of actions? Or when flower
>   classifier has and tunnel_key actions but also mirred? Should the

Each action should be able to dump selectively too. If you think it
as a database, it is just a different table with different schemas.


>   implementation return an error on encountering any classifier or
>   action that doesn't have any flags set for its type or just print all
>   data like regular dump? What if user asks to dump some specific option
>   that wasn't set for particular filter of action instance?

Undefined or error.

>
> Overall, the more I think about such implementation the more it looks
> like a mess to me.

This is what I think about your current implementation. You know once
we add this we can't remove it any longer, right? This is why we should
make it right and better in the first place, not after carrying it for even one
release.

Thanks.
