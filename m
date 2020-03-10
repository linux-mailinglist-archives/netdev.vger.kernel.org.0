Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8871F17EE80
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 03:21:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbgCJCVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 22:21:40 -0400
Received: from mail-yw1-f66.google.com ([209.85.161.66]:35389 "EHLO
        mail-yw1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbgCJCVk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 22:21:40 -0400
Received: by mail-yw1-f66.google.com with SMTP id d79so11233163ywd.2
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 19:21:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Wq7rIgcxJYUmMsHvdyxC0lAaZEg2UPI4DtUZCghoc2M=;
        b=W+6/tOaVxGiLqLqS/wU0x6rTJBxgY4clEdAUMXUNl6rTrVYNzmMTadvRvDzYQdIUSx
         DJOAMc16JxbKdF8odCYM4fB0hvKfxQAmKMIV0bB0s6ENkdCdQn4AZ1/re4oUS8ypNdXI
         3cgRifr5c/DAoniYHWfI4DFYmbCQRq6N97snT2nYH1UpQnxXkWmkFAz3hpzeAQ9HIknx
         QHcg7jRpAxW5CQTyuyJC7LlQ+f58ksIO2eF28q0Z3gO6PuRpViKJbjiz5/Ctg9dFK3f1
         z7ehibolWyxpm7y8TajktrZelIftSeOwITRDrQcjGx156F3tb9aicfOA94WeDINGYVPp
         s4GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Wq7rIgcxJYUmMsHvdyxC0lAaZEg2UPI4DtUZCghoc2M=;
        b=uhrG4L8YBD+HOgJ11gF2v3AAMGgXgWpraj1gOm6OLllJ5qeEMqbNHp3SrJA5keG+K9
         JyQ+YJxJVeoGc/ZKNBMVEQLnsxBzqWDR5RdovIaJ21GCxsEouk0mtwDgp7D5zoexr9PN
         gp4VPN8WbFFNx7uHZsBAemGz3wLuKgSERUDYTa7q1AlDDaabw/snMrLTx1wgsrKve4xR
         oxqZvOj8mu0GqjoeTb7RpQepcf4ELmTd3+l5W39iJzHNAzaNg6+BHDabT9o5yGlcXX9v
         rpr8/rgwAYWFI7spa1RlYsYMSvZuBUD6c9GdmWUFXgvvKIlwhk5XRAGY1UYq1+yZAYOH
         ePZw==
X-Gm-Message-State: ANhLgQ2XzFncAMM1NMf7n4tNL9gZlEsQseJLPqxQ74riRqylW44oecNV
        diGkx2t7OKWf19KKAQl0cSZUdToxPqQWNBkdMRgzgsMB
X-Google-Smtp-Source: ADFU+vuaQg9cfjPCGtb0sumAFYqu+fHrEy1l4pBYJ4DqpyTraRphiOKeFMHA+TNfLGgLxc2wdSu4w7IouxkkswMule8=
X-Received: by 2002:a25:68c1:: with SMTP id d184mr20798858ybc.335.1583806899071;
 Mon, 09 Mar 2020 19:21:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200309225702.63695-1-maheshb@google.com> <eff143b1-1c88-4ed7-ff59-b25ac0dfd42f@gmail.com>
In-Reply-To: <eff143b1-1c88-4ed7-ff59-b25ac0dfd42f@gmail.com>
From:   =?UTF-8?B?TWFoZXNoIEJhbmRld2FyICjgpK7gpLngpYfgpLYg4KSs4KSC4KSh4KWH4KS14KS+4KSwKQ==?= 
        <maheshb@google.com>
Date:   Mon, 9 Mar 2020 19:21:22 -0700
Message-ID: <CAF2d9jiRovyHkASL=BO2q3TF1CAfoa_yN9jckF8oS1Czx+x47w@mail.gmail.com>
Subject: Re: [PATCH net] ipvlan: add cond_resched_rcu() while processing
 muticast backlog
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <mahesh@bandewar.net>,
        syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 9, 2020 at 6:07 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 3/9/20 3:57 PM, Mahesh Bandewar wrote:
> > If there are substantial number of slaves created as simulated by
> > Syzbot, the backlog processing could take much longer and result
> > into the issue found in the Syzbot report.
> >
>
> ...
>
> >
> > Fixes: ba35f8588f47 (=E2=80=9Cipvlan: Defer multicast / broadcast proce=
ssing to a work-queue=E2=80=9D)
> > Signed-off-by: Mahesh Bandewar <maheshb@google.com>
> > Reported-by: syzbot <syzkaller@googlegroups.com>
> > ---
> >  drivers/net/ipvlan/ipvlan_core.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/drivers/net/ipvlan/ipvlan_core.c b/drivers/net/ipvlan/ipvl=
an_core.c
> > index 53dac397db37..5759e91dec71 100644
> > --- a/drivers/net/ipvlan/ipvlan_core.c
> > +++ b/drivers/net/ipvlan/ipvlan_core.c
> > @@ -277,6 +277,7 @@ void ipvlan_process_multicast(struct work_struct *w=
ork)
> >                       }
> >                       ipvlan_count_rx(ipvlan, len, ret =3D=3D NET_RX_SU=
CCESS, true);
> >                       local_bh_enable();
> > +                     cond_resched_rcu();
>
> This does not work : If you release rcu_read_lock() here,
> then the surrounding loop can not be continued without risking use-after-=
free
>
.. but cond_resched_rcu() is nothing but
      rcu_read_unlock(); cond_resched(); rcu_read_lock();

isn't that sufficient?

> rcu_read_lock();
> list_for_each_entry_rcu(ipvlan, &port->ipvlans, pnode) {
>     ...
>     cond_resched_rcu();
>     // after this point bad things can happen
> }
>
>
> You probably should do instead :
>
> diff --git a/drivers/net/ipvlan/ipvlan_core.c b/drivers/net/ipvlan/ipvlan=
_core.c
> index 30cd0c4f0be0b4d1dea2c0a4d68d0e33d1931ebc..57617ff5565fb87035c13dcf1=
de9fa5431d04e10 100644
> --- a/drivers/net/ipvlan/ipvlan_core.c
> +++ b/drivers/net/ipvlan/ipvlan_core.c
> @@ -293,6 +293,7 @@ void ipvlan_process_multicast(struct work_struct *wor=
k)
>                 }
>                 if (dev)
>                         dev_put(dev);
> +               cond_resched();
>         }

reason this may not work is because the inner loop is for slaves for a
single packet and if there are 1k slaves, then skb_clone() will be
called 1k times before doing cond_reched() and the problem may not
even get mitigated.

>  }
>
