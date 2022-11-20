Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB7063169C
	for <lists+netdev@lfdr.de>; Sun, 20 Nov 2022 22:39:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbiKTVjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Nov 2022 16:39:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiKTVjh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Nov 2022 16:39:37 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFACB27FED
        for <netdev@vger.kernel.org>; Sun, 20 Nov 2022 13:39:36 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id r126-20020a1c4484000000b003cffd336e24so6787360wma.4
        for <netdev@vger.kernel.org>; Sun, 20 Nov 2022 13:39:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yV7jyrSm6uC7xzeQOPH5KGqOuppFoAQu4xJv2fUjEmw=;
        b=nbBvMlaGyzTbUNtRW8ocNpVnXsNfXHrxGpy8fAd/dXfHFmrUC9yHq8vAhMy5NpqKZz
         67+Ge0YPWFAIHZAIrSDNV4fYTNgpNo0ydR3tJobfijKH3gdeGIVEbG3Hzh+izW1ELRgM
         U4KYJ4LCkoQ5I9J9uwihDaA74v+Nv60q+iyh+/ECdQjVdZhps4NH2QncnxjBrGUAu5Tx
         82OPT1jWJ3Dc91xz6AjRtKoo2dBYkseDDVPjHN6QsMMFhpDqeOZMqCru4tNkCHuXSdxJ
         oyFwWLE0aw4jeuIxelNlpXDfuhAdvh42xcveurD/m/ckGe0D4t33xg/K0wVXKppX+woI
         HmYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yV7jyrSm6uC7xzeQOPH5KGqOuppFoAQu4xJv2fUjEmw=;
        b=mOzg6orclJJRRSyf4cFgDbCzDPFCNhPf+w9BNk3TGz+ea3HdsIafGjuMGG162mopz3
         tW7pgickpjK9RF1KCFSzWdZysrjavVu/dAzMlOzYvQrE9mjoASpmYvAFoF7EZRfsjARc
         4LTlYCTuAcsBFTg0dju3Y+/rY9Kyl4G7XHlAA7YCUIcOdIRFwjP+wfBg/orqGwnyc6Xg
         tCirBx+2Loqo95LeBjJL0V/vRolCEEyDM5Ys0yi2Rn1xgz+RLKlQMs6deladImdGZeTM
         Jy+VDoZER+xqccqj+JRjwJd1BiRexlXgeBdJX2Eiy+bnwhP9uSbbSdUCQdEdU6ErFRdh
         GjsQ==
X-Gm-Message-State: ANoB5pmjCv2NNr6rysgw4sJoyW2R4gu6M6FzPvY/3HjW55ukOa+sMIks
        zsBdLsK95a2B5pj9savKA2IJbNxoeWnNL2y8NaE=
X-Google-Smtp-Source: AA0mqf5/ePo605InFM6ayqGIhZh0DxyrOQiqCwS3RaIQr96VyOzJgAEtac3cSMXJwVztflegulhIIaUhYqeKfQ8msVU=
X-Received: by 2002:a05:600c:1d12:b0:3cf:8441:4a7c with SMTP id
 l18-20020a05600c1d1200b003cf84414a7cmr14482552wms.0.1668980375104; Sun, 20
 Nov 2022 13:39:35 -0800 (PST)
MIME-Version: 1.0
References: <20221018203258.2793282-1-edumazet@google.com> <162f9155-dfe3-9d78-c59f-f47f7dcf83f5@nvidia.com>
 <CANn89iKwN9tgrNTngYrqWdi_Ti0nb1-02iehJ=tL7oT5wOte2Q@mail.gmail.com>
 <20221103082751.353faa4d@kernel.org> <CANn89iJGcYDqiCHu25X7Eg=s2ypVNLfbNZMomcqvD-7f0SagMw@mail.gmail.com>
 <CAKErNvoCWWHrWGDT+rqKzGgzeaTexss=tNTm0+9Vr-TOH_8y=Q@mail.gmail.com>
 <CANn89iL2Jajn65L7YhqtjTAVMKNpkH0+-zJtQwFVcgrtJwxEWg@mail.gmail.com>
 <46dde206-53bf-8ba8-f964-6bcc22a303c7@nvidia.com> <15d10423-9f8b-668a-ba14-f9c15a3b3782@nvidia.com>
 <9f4c2ca9-bc6d-f2bf-6c03-e95affb55aae@nvidia.com> <CANn89iJkdQ9eBkwmWMcf7uKwB=cY8hbwo2Jqdtwo3mpjswAFHg@mail.gmail.com>
 <e1ccfefa-7910-ca96-9c7f-042df2265db6@nvidia.com> <CANn89iJSsFPBp5dYm3y6Jbbpuwbb9P+X3gmqk6zow0VWgx1Q-A@mail.gmail.com>
In-Reply-To: <CANn89iJSsFPBp5dYm3y6Jbbpuwbb9P+X3gmqk6zow0VWgx1Q-A@mail.gmail.com>
From:   =?UTF-8?B?0JzQsNC60YHQuNC8?= <maxtram95@gmail.com>
Date:   Sun, 20 Nov 2022 23:39:08 +0200
Message-ID: <CAKErNvo1h1Lm_g=-V_=rCjzh1B-L_yqoBQo3wp73pVjSM8x96Q@mail.gmail.com>
Subject: Re: [PATCH net] net: sched: fix race condition in qdisc_graft()
To:     Gal Pressman <gal@nvidia.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Cong Wang <xiyou.wangcong@gmail.com>, eric.dumazet@gmail.com,
        syzbot <syzkaller@googlegroups.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Tariq Toukan <tariqt@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 20 Nov 2022 at 19:01, Eric Dumazet <edumazet@google.com> wrote:
>
> On Sun, Nov 20, 2022 at 8:43 AM Gal Pressman <gal@nvidia.com> wrote:
> >
> > On 20/11/2022 18:09, Eric Dumazet wrote:
> > > On Sat, Nov 19, 2022 at 11:42 PM Gal Pressman <gal@nvidia.com> wrote:
> > >> On 10/11/2022 11:08, Gal Pressman wrote:
> > >>> On 06/11/2022 10:07, Gal Pressman wrote:
> > >>>> It reproduces consistently:
> > >>>> ip link set dev eth2 up
> > >>>> ip addr add 194.237.173.123/16 dev eth2
> > >>>> tc qdisc add dev eth2 clsact
> > >>>> tc qdisc add dev eth2 root handle 1: htb default 1 offload
> > >>>> tc class add dev eth2 classid 1: parent root htb rate 18000mbit ce=
il
> > >>>> 22500.0mbit burst 450000kbit cburst 450000kbit
> > >>>> tc class add dev eth2 classid 1:3 parent 1: htb rate 3596mbit burs=
t
> > >>>> 89900kbit cburst 89900kbit
> > >>>> tc qdisc delete dev eth2 clsact
> > >>>> tc qdisc delete dev eth2 root handle 1: htb default 1
> > >>>>
> > >>>> Please let me know if there's anything else you want me to check.
> > >>> Hi Eric, did you get a chance to take a look?
> > >> No response for quite a long time, Jakub, should I submit a revert?
> > > Sorry, I won't have time to look at this before maybe two weeks.
> >
> > Thanks for the response, Eric.
> >
> > > If you want to revert a patch which is correct, because some code
> > > assumes something wrong,
> >
> > I am not convinced about the "code assumes something wrong" part, and
> > not sure what are the consequences of this WARN being triggered, are yo=
u?
> >
> > > I will simply say this seems not good.
> >
> > Arguable, it is not that clear that a fix that introduces another issue
> > is a good thing, particularly when we don't understand the severity of
> > the thing that got broken.
>
> The offload part has been put while assuming a certain (clearly wrong) be=
havior.
>
> RCU rules are quite the first thing we need to respect in the kernel.
>
> Simply put, when KASAN detects a bug, you can be pretty damn sure it
> is a real one.
>
> >
> > Two weeks gets us to the end of -rc7, a bit too dangerous to my persona=
l
> > taste, but I'm not the one making the calls.
>
> Agreed, please try to find someone at nvidia able to understand what Maxi=
m
> was doing in commit ca49bfd90a9dde175d2929dc1544b54841e33804

The check for TCQ_F_BUILTIN basically means checking for noop_qdisc.
As the comment above the WARN_ON says, my code expects that before the
root HTB qdisc is destroyed (the notify_and_destroy line from Eric's
patch, in qdisc_graft), the kernel assigns &noop_qdisc to all of
dev_queue->qdisc-s (i.e. qdiscs of HTB classes). IIRC, it should
happen in dev_deactivate in qdisc_graft (and if IFF_UP is unset at
this point, that means dev_deactivate has been called before, from
__dev_close_many). That said, I don't see how Eric's patch could
affect this logic. What has changed in Eric's patch is that the old
root qdisc (HTB) is now destroyed after assigning the new qdisc to
dev->qdisc, but it has nothing to do with dev_queue->qdisc-s.

Gal, are you sure the WARN_ON only happens after Eric's patch? If yes,
could you do some tracing and find out whether all the qdiscs of the
netdev queues are noop_qdisc after the dev_deactivate line in
qdisc_graft =E2=80=94 before and after Eric's patch?

for (i =3D 0; i < num_q; i++) {
        struct netdev_queue *dev_queue =3D netdev_get_tx_queue(dev, i);
        if (dev_queue->qdisc =3D=3D &noop_qdisc)
                ...
}

> If something needs stronger rules than standard RCU ones, this should
> be articulated.
>
> As I said, I won't be able to work on this before ~2 weeks.
