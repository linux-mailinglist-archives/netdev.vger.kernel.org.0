Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 591B26ED7B3
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 00:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbjDXWW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 18:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233185AbjDXWWY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 18:22:24 -0400
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5C379016
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 15:22:18 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id 3f1490d57ef6-b99efd7c335so128887276.0
        for <netdev@vger.kernel.org>; Mon, 24 Apr 2023 15:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20221208.gappssmtp.com; s=20221208; t=1682374938; x=1684966938;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6b0u+MTSBzRZX+Zvi46C+c/yJfMlEGWzvCMhP1GXTzQ=;
        b=2/Q7E2LmyGo8+h/Bws5tu4w2SWfpGUXqacdWRNC+yJIX1bL6Ia6t8+rlau7LwWPE+j
         93KJ5IgvBm2OclIwgJlrAeo1BxkmBj1wYWo+LVV3O6EI2XMu5wPGLYReEKJ6ksiLfL6F
         W5IEG10pXKd1eUD6l/Zu/GE9VERiV/PCYj8CjsLXETlv6KcoEoc99sK6cGW4P6b3i/bs
         RhVsaJZ3cY5ZqqoS74lwlAnlvDU+dOLCLidAboPyEZVLhw5doy8R9y7s0ZApNtdfITC4
         jz8+3GBTsAaYcDXkOOnfqDP0lS8tfXip0JGHEeCTJOOhr7/G5OtJZoMX5x2VrDgWiN03
         /I1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682374938; x=1684966938;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6b0u+MTSBzRZX+Zvi46C+c/yJfMlEGWzvCMhP1GXTzQ=;
        b=TS1qJ+nWCsQl5/0V/WCPaye8lwKlYllB4VJVU9YobI5JOsrss0o09VG5wUlA14L3u8
         64XXgBZN9kMIDmMs4kilqbJmnGHk0YbpNOdnrjpK7ZntniQPep1j8gXtvaH5EcQj+b4f
         BpC8zrCIEOhXzITIZXzz1dWgoTrWXQ7QtfRON04CBkYaQb56JhyDUMeQY81RRUFeqAz+
         B74/qqHJZU5eZ9Huhq1GkjcC8qUHWRZQrnBiNYltZvEivceBasmaoD7zOrjcUlV+EJOm
         y6x12U35GkXLjaXOAPoAvWKaIYsBJB7pVFvaFemptxniKSskiuLK+bngHir5n31b1mpk
         r/Ag==
X-Gm-Message-State: AAQBX9f5ygPOIZ8pb/Behq3MQ6zbmk1oFP1YfKTxOOv2fTeLbHfWFn33
        ibve7aZ1/x+Jf61JSfRDf3xk5SrrJm6h5ghW2pGYzQ==
X-Google-Smtp-Source: AKy350Ypm82MgXw4jLXXJEFl2fIliwDWnYDjgtUo7WPmBsQxNRDFy1GMymMo/zyoogAALRRMBvpAE4ICpg4r/n1rbhg=
X-Received: by 2002:a25:452:0:b0:b99:53e9:ba89 with SMTP id
 79-20020a250452000000b00b9953e9ba89mr6401875ybe.50.1682374937920; Mon, 24 Apr
 2023 15:22:17 -0700 (PDT)
MIME-Version: 1.0
References: <20230424170832.549298-1-victor@mojatatu.com> <20230424173602.GA27649@unreal>
 <20230424104408.63ba1159@hermes.local> <CAM0EoMnM-s4M4HFpK1MVr+ey6PkU=uzwYsUipc1zBA5RPhzt-A@mail.gmail.com>
 <20230424143651.53137be4@kernel.org> <CAM0EoM==4T=64FH7t4taURugM4d0Stv2oXFgr5+qNBNEe9bjwQ@mail.gmail.com>
 <20230424151011.0f8cd8b3@hermes.local>
In-Reply-To: <20230424151011.0f8cd8b3@hermes.local>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Mon, 24 Apr 2023 18:22:06 -0400
Message-ID: <CAM0EoMkc20vZSKGUrc2qx76HYba69mVZtRCq57JsYDyxENCkqQ@mail.gmail.com>
Subject: Re: [PATCH net v2] net/sched: act_mirred: Add carrier check
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Victor Nogueira <victor@mojatatu.com>, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, kernel@mojatatu.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 24, 2023 at 6:10=E2=80=AFPM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Mon, 24 Apr 2023 17:53:03 -0400
> Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> > On Mon, Apr 24, 2023 at 5:36=E2=80=AFPM Jakub Kicinski <kuba@kernel.org=
> wrote:
> > >
> > > On Mon, 24 Apr 2023 13:59:15 -0400 Jamal Hadi Salim wrote:
> > > > > Then fix the driver. It shouldn't hang.
> > > > > Other drivers just drop packets if link is down.
> > > >
> > > > We didnt do extensive testing of drivers but consider this a safegu=
ard
> > > > against buggy driver (its a huge process upgrading drivers in some
> > > > environments). It may even make sense to move this to dev_queue_xmi=
t()
> > > > i.e the arguement is: why is the core sending a packet to hardware
> > > > that has link down to begin with? BTW, I believe the bridge behaves
> > > > this way ...
> > >
> > > I'm with Stephen, even if the check makes sense in general we should
> > > first drill down into the real bug, and squash it.
> >
> > Ok then, I guess in keeping up with the spirit of trivial patches
> > generating the most discussion, these are two separate issues in my
> > opinion: IOW, the driver bug should be fixed (we have reached out to
> > the  vendor) - but the patch stands on its own.
>
> There are many other ways packet could arrive at driver when link
> is down. You are addressing only one small corner case by patching
> mirred.

Of course, we are dealing with the thing that is causing us grief is a
fair thing to do, no?
What other (non-corner use) cases do you want to see fixed?

cheers
