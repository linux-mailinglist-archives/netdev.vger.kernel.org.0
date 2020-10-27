Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6555029C7CD
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 19:53:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1829155AbgJ0Sui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 14:50:38 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:34054 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1829117AbgJ0SuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 14:50:09 -0400
Received: by mail-io1-f65.google.com with SMTP id z5so2704102iob.1
        for <netdev@vger.kernel.org>; Tue, 27 Oct 2020 11:50:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YpkiPLar3R5c4dVI2xBXh3hedPGoWq35CkBmPh//SmU=;
        b=ik1b7e5HS6xJuo57JwEVbGjdzAhGnUubhKFP4XPEtDVrlEJMStEBKQYrAvrs+cU4lp
         ojyEgvkmjDxEbsInjD/oLJmWH9NzaX5H1tYdARoo3bh3EDVi/BdcKWFU2tUe3PvapgUK
         uN13wNj1wxinRXTnARcata4sdWPnN9TtPr6AC7pEVpoSfuW62kPkL2Cy+YwnogAB9BQF
         4DLkI2LIBj7UVzEcg2D9UCXLbYvRTasV1q1KqEcAnQjp42DboEIrJhowIWYj5fhNnFGg
         egjXukQJ5KqcHmkzp6zTU4+YuUg+0tk3IqAxzYO7YE+Q81GwpB2LQ8SEi+JDLoE8RQ56
         uXtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YpkiPLar3R5c4dVI2xBXh3hedPGoWq35CkBmPh//SmU=;
        b=dOqQM6gv9hp1J6IpXI83q9dU9TI4B7tnrsfFHe++gmhnlTbMq+g4gCnqXXYZN1fR17
         uKsucSACQmSBDcKYQ9mP3m+LbJ2qAC06ykyKoBN7NTp3C5J35zOOIJLqLljeboUh2CO2
         TjFQRCs8pQng4kNoOmOn+dRr6MnwglchNMbPnibKbEtTqBCeay3CyaU+4kApL3RidfE0
         eAcpimlHJ9Hh7AebRVdU4cGI9v+voR/rsqFJM9j6ONhSO2EOSJUYhbwuwzcFJ9AEkU4V
         fS5XzmUS1Cp+bbPvrBFK+ndsrUKinzFqimdtuC+k0aB/RG9Wxz8q1z4U9BtdR+CW1ZwE
         aNRg==
X-Gm-Message-State: AOAM530frgUHPYWHiSnK4UmfLSO1od0E94PfxPIYIDOZp9NKRfd7vjox
        EjkxAPzDkydBO244Py8Ys1DPoX6lY1JTlNgIX5M6dLqRu20FEg==
X-Google-Smtp-Source: ABdhPJwmqq3MH7omXKmK5oKNQ1fPIKs9GfF1K1UddU4N6z3k1VQMyR0at3tInay0kYmtLof+Lb9u1Xh7inC8X5/IAdM=
X-Received: by 2002:a02:95ea:: with SMTP id b97mr3813350jai.16.1603824607681;
 Tue, 27 Oct 2020 11:50:07 -0700 (PDT)
MIME-Version: 1.0
References: <20201026104333.13008-1-tung.q.nguyen@dektech.com.au> <CAM_iQpXnsiGP_x-D5YEWbVmqzP2ZhRdtG1ReDQq2wr6YUs2J0w@mail.gmail.com>
In-Reply-To: <CAM_iQpXnsiGP_x-D5YEWbVmqzP2ZhRdtG1ReDQq2wr6YUs2J0w@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 27 Oct 2020 11:49:56 -0700
Message-ID: <CAM_iQpUSC5Xxos=P=kLx4_ocFOvX=8GXLn4rB5+Uhy_Gs9zzaw@mail.gmail.com>
Subject: Re: [tipc-discussion] [net v2 1/1] tipc: fix memory leak caused by tipc_buf_append()
To:     Tung Nguyen <tung.q.nguyen@dektech.com.au>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        tipc-discussion@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 27, 2020 at 11:21 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Mon, Oct 26, 2020 at 3:46 AM Tung Nguyen
> <tung.q.nguyen@dektech.com.au> wrote:
> >
> > Commit ed42989eab57 ("fix the skb_unshare() in tipc_buf_append()")
> > replaced skb_unshare() with skb_copy() to not reduce the data reference
> > counter of the original skb intentionally. This is not the correct
> > way to handle the cloned skb because it causes memory leak in 2
> > following cases:
> >  1/ Sending multicast messages via broadcast link
> >   The original skb list is cloned to the local skb list for local
> >   destination. After that, the data reference counter of each skb
> >   in the original list has the value of 2. This causes each skb not
> >   to be freed after receiving ACK:
>
> Interesting, I can not immediately see how tipc_link_advance_transmq()
> clones the skb. You point out how it is freed but not cloned.
>
> It looks really odd to see the skb is held by some caller, then expected
> to be released by the unshare in tipc_buf_append(). IMHO, the refcnt
> should be released where it is held.

More importantly, prior to Xin Long's change of skb_unshare(),
skb_unclone() was used, which does not touch the skb refcnt either.
So, why does it rely on skb_unshare() to release this refcnt now?

Thanks.
