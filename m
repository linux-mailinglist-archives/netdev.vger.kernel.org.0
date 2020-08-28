Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD7602552AD
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 03:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbgH1BqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 21:46:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726197AbgH1BqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 21:46:05 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A22C061264;
        Thu, 27 Aug 2020 18:46:05 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id m7so8022575qki.12;
        Thu, 27 Aug 2020 18:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=XfUyu9N5xVHQjkPICmmZmHi0bGAWPkVtW1TYQOpXMTc=;
        b=fFoPl1OXxLfnVTMwzSgA7bx4vGhMhtHz9ITkK25UCvdCspHdpzWFYsmrFcss3p7QdW
         7OhHtyvfxCGpzbdZQxAQLV6JWJKPl84aOc1uwsj+Bble7uOSiQIqUQJzBQbBovuVtg0o
         tgSRq5bf3QeWHnF1iMYhCKIxhv8BohUZiyVOvOUbUxeIWTNiRqDQ/BLCoVIVexSsSb8c
         SECzPiivkOHi8YYNOSHXkLCtY7bBX06QRy7hoyouu6tcgSffv7kGhqTGK68OUOJsdn5p
         vQ6IDhjaLKipX1SWY02UjD7H6pzaDho1iKaiSOXiYuSAVErTkZ9/VX7bDkPV4ZdlqkMN
         IFdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=XfUyu9N5xVHQjkPICmmZmHi0bGAWPkVtW1TYQOpXMTc=;
        b=XZv/N/eEh2TgFU8U3h3d609rK8EVR1vdfayaF1spLG8U95z/R5Jiz3T/UnKQxTfi4c
         yIhHWW/CUH6KhJmvmNysHv3Qm4wgqV2C0A+bAJoCrJ+aAVxM8Pfz2WqqwNQeLfUtimwV
         Hoo+1RBPPAm24RBQF33dEU7pSOKJG4jIKREkOrNfMXovxF1vGg+5GvSuVvIIJ4W/WfHo
         nOCd4cFBvCCbGX6r/lbxpBOYlKJq1AW8c0ohiWwirzahq7TB64lUfkaOohnP5OdrSPFO
         SUEv3jCl11n+XXdFOl9WLk2r8cJK9bavPtmnAZaYiIKcUT1qdMpTIQX3w/gEwr53zgD+
         DJFQ==
X-Gm-Message-State: AOAM531O1auXv3MAX2C/S5cJulphZKoC8gBn6dKqF2OBGQtUHxWwzZly
        FJtD55waFKMaBYMI+9NzhhnTwZgmtxwdGWo3Mcb08U/arSw=
X-Google-Smtp-Source: ABdhPJzRioaXKpEXuHH+xgnaqM9TLTGuOtkw/XlnCNWyXDFt5pV8TJx33baphVEwD/Much68yksmX9cv4L3iyLkS6w4=
X-Received: by 2002:a37:b482:: with SMTP id d124mr20753891qkf.98.1598579164268;
 Thu, 27 Aug 2020 18:46:04 -0700 (PDT)
MIME-Version: 1.0
References: <465a540e-5296-32e7-f6a6-79942dfe2618@netrounds.com>
 <20200623134259.8197-1-mzhivich@akamai.com> <1849b74f-163c-8cfa-baa5-f653159fefd4@akamai.com>
 <CAM_iQpX1+dHB0kJF8gRfuDeAb9TsA9mB9H_Og8n8Hr19+EMLJA@mail.gmail.com>
 <CAM_iQpWjQiG-zVs+e-V=8LvTFbRwgC4y4eoGERjezfAT0Fmm8g@mail.gmail.com>
 <7fd86d97-6785-0b5f-1e95-92bc1da9df35@netrounds.com> <500b4843cb7c425ea5449fe199095edd5f7feb0c.camel@redhat.com>
 <25ca46e4-a8c1-1c88-d6a9-603289ff44c3@akamai.com> <CANE52Ki8rZGDPLZkxY--RPeEG+0=wFeyCD6KKkeG1WREUwramw@mail.gmail.com>
 <20200822032800.16296-1-hdanton@sina.com> <CACS=qqKhsu6waaXndO5tQL_gC9TztuUQpqQigJA2Ac0y12czMQ@mail.gmail.com>
 <20200825032312.11776-1-hdanton@sina.com> <CACS=qqK-5g-QM_vczjY+A=3fi3gChei4cAkKweZ4Sn2L537DQA@mail.gmail.com>
 <20200825162329.11292-1-hdanton@sina.com> <CACS=qqKgiwdCR_5+z-vkZ0X8DfzOPD7_ooJ_imeBnx+X1zw2qg@mail.gmail.com>
 <CACS=qqKptAQQGiMoCs1Zgs9S4ZppHhasy1AK4df2NxnCDR+vCw@mail.gmail.com>
 <5f46032e.1c69fb81.9880c.7a6cSMTPIN_ADDED_MISSING@mx.google.com>
 <CACS=qq+Yw734DWhETNAULyBZiy_zyjuzzOL-NO30AB7fd2vUOQ@mail.gmail.com> <20200827125747.5816-1-hdanton@sina.com>
In-Reply-To: <20200827125747.5816-1-hdanton@sina.com>
From:   Kehuan Feng <kehuan.feng@gmail.com>
Date:   Fri, 28 Aug 2020 09:45:52 +0800
Message-ID: <CACS=qq+a0H=e8yLFu95aE7Hr0bQ9ytCBBn2rFx82oJnPpkBpvg@mail.gmail.com>
Subject: Re: Packet gets stuck in NOLOCK pfifo_fast qdisc
To:     Hillf Danton <hdanton@sina.com>
Cc:     Jike Song <albcamus@gmail.com>, Josh Hunt <johunt@akamai.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jonas Bonn <jonas.bonn@netrounds.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Michael Zhivich <mzhivich@akamai.com>,
        David Miller <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hillf,

Unfortunately, above mem barriers don't help. The issue shows up
within 1 minute ...

Hillf Danton <hdanton@sina.com> =E4=BA=8E2020=E5=B9=B48=E6=9C=8827=E6=97=A5=
=E5=91=A8=E5=9B=9B =E4=B8=8B=E5=8D=888:58=E5=86=99=E9=81=93=EF=BC=9A

>
>
> On Thu, 27 Aug 2020 14:56:31 +0800 Kehuan Feng wrote:
> >
> > > Lets see if TCQ_F_NOLOC is making fq_codel different in your testing.
> >
> > I assume you meant disabling NOLOCK for pfifo_fast.
> >
> > Here is the modification,
> >
> > --- ./net/sched/sch_generic.c.orig      2020-08-24 22:02:04.589830751 +=
0800
> > +++ ./net/sched/sch_generic.c   2020-08-27 10:17:10.148977195 +0800
> > @@ -792,7 +792,7 @@
> >         .dump           =3D3D       pfifo_fast_dump,
> >         .change_tx_queue_len =3D3D  pfifo_fast_change_tx_queue_len,
> >         .owner          =3D3D       THIS_MODULE,
> > -       .static_flags   =3D3D       TCQ_F_NOLOCK | TCQ_F_CPUSTATS,
> > +       .static_flags   =3D3D       TCQ_F_CPUSTATS,
> >
> > The issue never happen again with it for over 3 hours stressing. And I
> > restarted the test for two times. No any surprising. Quite stable...
>
> Jaw off. That is great news and I'm failing again to explain the test
> result wrt the difference TCQ_F_NOLOCK can make in running qdisc.
>
> Nothing comes into mind other than two mem barriers though only one is
> needed...
>
> --- a/net/core/dev.c
> +++ b/net/core/dev.c
> @@ -3040,6 +3040,7 @@ static void __netif_reschedule(struct Qd
>
>  void __netif_schedule(struct Qdisc *q)
>  {
> +       smp_mb__before_atomic();
>         if (!test_and_set_bit(__QDISC_STATE_SCHED, &q->state))
>                 __netif_reschedule(q);
>  }
> @@ -4899,6 +4900,7 @@ static __latent_entropy void net_tx_acti
>                          */
>                         smp_mb__before_atomic();
>                         clear_bit(__QDISC_STATE_SCHED, &q->state);
> +                       smp_mb__after_atomic();
>                         qdisc_run(q);
>                         if (root_lock)
>                                 spin_unlock(root_lock);
>
