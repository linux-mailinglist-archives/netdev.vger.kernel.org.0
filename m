Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9B2526F201
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 04:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730317AbgIRCz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 22:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727857AbgIRCHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 22:07:08 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30C91C06174A;
        Thu, 17 Sep 2020 19:07:08 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id 19so3763162qtp.1;
        Thu, 17 Sep 2020 19:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=SKCjvQCI5joIwKuWzNdJCH+imv1oMNJjSZtzROemyfE=;
        b=MSyPNXrY1anJdGBnxrLdIs8U4EhQ4Lu4IEMJn7bJ6xemSbEbbh72mByYYoO7w65PVu
         +BJczAIrAWjK6EmKwO+m32YUJcbBU1e5+O41Picxfeb1FFskIxZnqx8s8Q89kpwX1SOp
         2cBe+RimInwPTrlA+1XTxABQxarUPVsFrKcxa3qsayZOG0fqJb8lGY1RDJM4BD0ncZdT
         MQmu8UP2sOyUN1dkJsWInRJeBAZg2rB0oQ5VPBglBUlP6i7SckV92VZPQIZu9NAQftl5
         7SABUesZKAGG7K0UOgW2vIY+h0fs2eRhDnhzh4e73ma7e5a1J5GSxQSrMyUx3GTD0Q24
         hsQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=SKCjvQCI5joIwKuWzNdJCH+imv1oMNJjSZtzROemyfE=;
        b=bX+XVrBsSF6DjRRM9l1NnZCQjGTAb9Tu8hJORb43ESAwINr67rXy2vg9rULCq+sSSo
         wYKlTXBf5A1RIjRUnitZZMfneoqlazZM6lgZRdpCj1ETzPyPieplXUN2rHnnXbwIqQh+
         lOe/Vy7okESPvx6EqHw6+jlo0A/VO4UwgIfiWSxBXh5PsKgizZnnl1kfeoi2hGZ7PNpJ
         3S4lL2CgQibcIX9dk04OJROZxkDMXwqqC2S+vAu31Z/vvWKxkrSnX8rZIjURRv3ztftP
         Yhz29oSrtx8z/OgN0iGVesrEepsk1UKUpTYFwtSP/gYWbgpVzLeYvmIIhSwkP6DWyiQ+
         22Rg==
X-Gm-Message-State: AOAM531XyeHn7ShF1w0EYFCejzQLORpse10Z4Fzu9nRZfOoikSr/fOdV
        x4JpOmJGuSMDROYho6evblX4gedy0kT2V7amLdk=
X-Google-Smtp-Source: ABdhPJw9MFxPj2JK46YeFOy1W3mGhJ7ARD/xaFPk8TJPhFEkyjPoWUho5WzRCy/1J5SV9cqJ/6CdEYecVolKKDn7PtA=
X-Received: by 2002:aed:362a:: with SMTP id e39mr18128107qtb.121.1600394827440;
 Thu, 17 Sep 2020 19:07:07 -0700 (PDT)
MIME-Version: 1.0
References: <465a540e-5296-32e7-f6a6-79942dfe2618@netrounds.com>
 <CACS=qqKhsu6waaXndO5tQL_gC9TztuUQpqQigJA2Ac0y12czMQ@mail.gmail.com>
 <20200825032312.11776-1-hdanton@sina.com> <CACS=qqK-5g-QM_vczjY+A=3fi3gChei4cAkKweZ4Sn2L537DQA@mail.gmail.com>
 <20200825162329.11292-1-hdanton@sina.com> <CACS=qqKgiwdCR_5+z-vkZ0X8DfzOPD7_ooJ_imeBnx+X1zw2qg@mail.gmail.com>
 <CACS=qqKptAQQGiMoCs1Zgs9S4ZppHhasy1AK4df2NxnCDR+vCw@mail.gmail.com>
 <5f46032e.1c69fb81.9880c.7a6cSMTPIN_ADDED_MISSING@mx.google.com>
 <CACS=qq+Yw734DWhETNAULyBZiy_zyjuzzOL-NO30AM7fd2vUOQ@mail.gmail.com>
 <20200827125747.5816-1-hdanton@sina.com> <CACS=qq+a0H=e8yLFu95aE7Hr0bQ9ytCBBn2rFx82oJnPpkBpvg@mail.gmail.com>
 <CAM_iQpV-JMURzFApp-Zhxs3QN9j=Zdf6yqwOP=E42ERDHxe6Hw@mail.gmail.com>
 <dd73f551d1fc89e457ffabd106cbf0bf401b747b.camel@redhat.com>
 <20200903101957.428-1-hdanton@sina.com> <CACS=qqLKSpnRrgROm8jzzFid3MH97phPXWsk28b371dfu0mnVA@mail.gmail.com>
 <CAM_iQpUq9-wja3JHz9+TMeXGyAOmJfZDxWUZJ9v25i7vd0Z-Wg@mail.gmail.com>
 <c97908eb-5a0b-363c-93fd-59c037bbd9f0@huawei.com> <CAM_iQpXiNaushoWjma44X_agPosg9AKk4RzFTX93MSVTM6z3Uw@mail.gmail.com>
In-Reply-To: <CAM_iQpXiNaushoWjma44X_agPosg9AKk4RzFTX93MSVTM6z3Uw@mail.gmail.com>
From:   Kehuan Feng <kehuan.feng@gmail.com>
Date:   Fri, 18 Sep 2020 10:06:56 +0800
Message-ID: <CACS=qqJu6soSDPo+mJhDQwv2Tn-TxjF56w7H8q6zCE=4TJps2g@mail.gmail.com>
Subject: Re: Packet gets stuck in NOLOCK pfifo_fast qdisc
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        Hillf Danton <hdanton@sina.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jike Song <albcamus@gmail.com>, Josh Hunt <johunt@akamai.com>,
        Jonas Bonn <jonas.bonn@netrounds.com>,
        Michael Zhivich <mzhivich@akamai.com>,
        David Miller <davem@davemloft.net>,
        John Fastabend <john.fastabend@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry, guys, the experiment environment is no longer existing now. We
finally use fq_codel for online product.

Cong Wang <xiyou.wangcong@gmail.com> =E4=BA=8E2020=E5=B9=B49=E6=9C=8818=E6=
=97=A5=E5=91=A8=E4=BA=94 =E4=B8=8A=E5=8D=883:52=E5=86=99=E9=81=93=EF=BC=9A
>
> On Sun, Sep 13, 2020 at 7:10 PM Yunsheng Lin <linyunsheng@huawei.com> wro=
te:
> >
> > On 2020/9/11 4:19, Cong Wang wrote:
> > > On Thu, Sep 3, 2020 at 8:21 PM Kehuan Feng <kehuan.feng@gmail.com> wr=
ote:
> > >> I also tried Cong's patch (shown below on my tree) and it could avoi=
d
> > >> the issue (stressing for 30 minutus for three times and not jitter
> > >> observed).
> > >
> > > Thanks for verifying it!
> > >
> > >>
> > >> --- ./include/net/sch_generic.h.orig 2020-08-21 15:13:51.787952710 +=
0800
> > >> +++ ./include/net/sch_generic.h 2020-09-03 21:36:11.468383738 +0800
> > >> @@ -127,8 +127,7 @@
> > >>  static inline bool qdisc_run_begin(struct Qdisc *qdisc)
> > >>  {
> > >>   if (qdisc->flags & TCQ_F_NOLOCK) {
> > >> - if (!spin_trylock(&qdisc->seqlock))
> > >> - return false;
> > >> + spin_lock(&qdisc->seqlock);
> > >>   } else if (qdisc_is_running(qdisc)) {
> > >>   return false;
> > >>   }
> > >>
> > >> I am not actually know what you are discussing above. It seems to me
> > >> that Cong's patch is similar as disabling lockless feature.
> > >
> > >>From performance's perspective, yeah. Did you see any performance
> > > downgrade with my patch applied? It would be great if you can compare
> > > it with removing NOLOCK. And if the performance is as bad as no
> > > NOLOCK, then we can remove the NOLOCK bit for pfifo_fast, at least
> > > for now.
> >
> > It seems the lockless qdisc may have below concurrent problem:
> >   cpu0:                                                           cpu1:
> > q->enqueue                                                          .
> > qdisc_run_begin(q)                                                  .
> > __qdisc_run(q) ->qdisc_restart() -> dequeue_skb()                   .
> >                                  -> sch_direct_xmit()               .
> >                                                                     .
> >                                                                 q->enqu=
eue
> >                                                              qdisc_run_=
begin(q)
> > qdisc_run_end(q)
> >
> >
> > cpu1 enqueue a skb without calling __qdisc_run(), and cpu0 did not see =
the
> > enqueued skb when calling __qdisc_run(q) because cpu1 may enqueue the s=
kb
> > after cpu0 called __qdisc_run(q) and before cpu0 called qdisc_run_end(q=
).
>
> This is the same problem that my patch fixes, I do not know
> why you are suggesting another patch despite quoting mine.
> Please read the whole thread if you want to participate.
>
> Thanks.
