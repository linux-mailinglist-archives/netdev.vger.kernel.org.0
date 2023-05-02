Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DCB16F3CCB
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 06:44:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233450AbjEBEog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 00:44:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233416AbjEBEof (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 00:44:35 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 126B430FD
        for <netdev@vger.kernel.org>; Mon,  1 May 2023 21:44:34 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id 98e67ed59e1d1-24b725d6898so2146319a91.2
        for <netdev@vger.kernel.org>; Mon, 01 May 2023 21:44:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683002673; x=1685594673;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kmzeFw2KpvheSlrtQxpnFeN/1gMHt3CE0Q5AjpkUpLU=;
        b=FMGk0Stoda2C52B9ZzVuDnekPRz8bNUjzwYva/SbC5Sfvqxq+07KzBmb14vj4dBWx6
         U6Wus/VzVy30z9Jpwmm3VDMs4EOXw9l6KN1K2S9q/kMf6LYB02ffwn6mVCAk/PednKCy
         BoJEiu0zm63Gv5VHDwUhdE5ZH1Q55X9kmiIVUokxTI8B40mL6XEgJI8naBfVf/IWykAb
         P8wcY4t7e1E7s6dPg65eAx9kwhVryKXX2JojtGyVQvVTSeQFsOFoBK6P4+uQVHRzbMfA
         qNLtg5puOa35s9I9ZJ2YQyufXot1EY1fLrD8TiXihVaaPrXGvoA/fQneS/QMB9sj56aa
         r8GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683002673; x=1685594673;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kmzeFw2KpvheSlrtQxpnFeN/1gMHt3CE0Q5AjpkUpLU=;
        b=crKBrjovpRcjzSkkHqAur6irWNxsDL9glqATvr/tIozswZkvonFLVi+Wk0FhU//w9K
         n8/0yfEEWRbzCTulL+F3QrWI6iVhVBSgnfgxy6k4zm0ONFqlNtkSMSrVoyuZAe64+yVN
         sBCyoXZrVSjM4CT2QO9X8FQ+Uq0nATtgZ1lbNodfV3b8L7rqUbFFfxkNLA1fFvuOYN3N
         8rH5SZlhZmedbgsduf/LYcDyYNd6xL/OZRXlOQghwutdW9+i00zzUDvINkbXto3WaMLF
         BPz6U+5hmsjqaduTJQlPRJMC09JNPu1pwdqZBftM0pp/qI8DiAwewBkFDqB6aANwFxKd
         mRFw==
X-Gm-Message-State: AC+VfDwmMWoqEscyEiUXAZfQxBvUGg3gf6aSq3foRbpxvDud74nL3Vku
        OVFX0FmY30f1t+uz53Xjv7VFQezUXyizp7t6ahw=
X-Google-Smtp-Source: ACHHUZ4NROOKKH5scgw/zPhO6MCmiwIBpWhTLY7QITxzlC3SJN06CyeI0sPCPolcr0LDI46jAPFv9rsqfcSTDD4WxCo=
X-Received: by 2002:a17:90b:3548:b0:24d:f880:5192 with SMTP id
 lt8-20020a17090b354800b0024df8805192mr6586372pjb.19.1683002673416; Mon, 01
 May 2023 21:44:33 -0700 (PDT)
MIME-Version: 1.0
References: <20230423032437.285014-1-glipus@gmail.com> <20230426165835.443259-1-kory.maincent@bootlin.com>
 <CAP5jrPE3wpVBHvyS-C4PN71QgKXrA5GVsa+D=RSaBOjEKnD2vw@mail.gmail.com>
 <20230427102945.09cf0d7f@kmaincent-XPS-13-7390> <CAP5jrPH5kQzqzeQwmynOYLisbzL1TUf=AwA=cRbCtxU4Y6dp9Q@mail.gmail.com>
 <20230428101103.02a91264@kmaincent-XPS-13-7390> <CAP5jrPH1=fw7ayEFuzQZKXSkcXeGfUy134yEANzDcSyvwOB-2g@mail.gmail.com>
 <4c27d467-95a3-fb9a-52be-bcb54f7d1aaf@linux.dev> <CAP5jrPE8rriDGVrXwszj8DrrGvmRaqnbRzWuCTfhpt4g9G9FLw@mail.gmail.com>
In-Reply-To: <CAP5jrPE8rriDGVrXwszj8DrrGvmRaqnbRzWuCTfhpt4g9G9FLw@mail.gmail.com>
From:   Max Georgiev <glipus@gmail.com>
Date:   Mon, 1 May 2023 22:44:22 -0600
Message-ID: <CAP5jrPH1Xn5Sja8wqB_oybrv6mubaP+nhpOjRHN8TCDW2=Auhw@mail.gmail.com>
Subject: Re: [RFC PATCH v4 0/5] New NDO methods ndo_hwtstamp_get/set
To:     Vadim Fedorenko <vadim.fedorenko@linux.dev>
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
        richardcochran@gmail.com, gerhard@engleder-embedded.com,
        thomas.petazzoni@bootlin.com,
        =?UTF-8?Q?K=C3=B6ry_Maincent?= <kory.maincent@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 1, 2023 at 10:35=E2=80=AFPM Max Georgiev <glipus@gmail.com> wro=
te:
>
> On Sat, Apr 29, 2023 at 1:45=E2=80=AFPM Vadim Fedorenko
> <vadim.fedorenko@linux.dev> wrote:
> >
> > On 28.04.2023 15:14, Max Georgiev wrote:
> > > On Fri, Apr 28, 2023 at 2:11=E2=80=AFAM K=C3=B6ry Maincent <kory.main=
cent@bootlin.com> wrote:
> > >>
> > >> On Thu, 27 Apr 2023 22:57:27 -0600
> > >> Max Georgiev <glipus@gmail.com> wrote:
> > >>
> > >>> Sorry, I'm still learning the kernel patch communication rules.
> > >>> Thank you for guiding me here.
> > >>
> > >> Also, each Linux merging subtree can have its own rules.
> > >> I also, was not aware of net special merging rules:
> > >> https://www.kernel.org/doc/html/latest/process/maintainer-netdev.htm=
l
> > >>
> > >>
> > >>> On Thu, Apr 27, 2023 at 2:43=E2=80=AFAM K=C3=B6ry Maincent <kory.ma=
incent@bootlin.com>
> > >>> wrote:
> > >>>>
> > >>>> On Wed, 26 Apr 2023 22:00:43 -0600
> > >>>> Max Georgiev <glipus@gmail.com> wrote:
> > >>>>
> > >>>>>
> > >>>>> Thank you for giving it a try!
> > >>>>> I'll drop the RFC tag starting from the next iteration.
> > >>>>
> > >>>> Sorry I didn't know the net-next submission rules. In fact keep th=
e RFC tag
> > >>>> until net-next open again.
> > >>>> http://vger.kernel.org/~davem/net-next.html
> > >>>>
> > >>>> Your patch series don't appear in the cover letter thread:
> > >>>> https://lore.kernel.org/all/20230423032437.285014-1-glipus@gmail.c=
om/
> > >>>> I don't know if it comes from your e-mail or just some issue from =
lore but
> > >>>> could you check it?
> > >>>
> > >>> Could you please elaborate what's missing in the cover letter?
> > >>> Should the cover letter contain the latest version of the patch
> > >>> stack (v4, then v5, etc.) and some description of the differences
> > >>> between the patch versions?
> > >>> Let me look up some written guidance on this.
> > >>
> > >> I don't know how you send your patch series but when you look on you=
r e-mail
> > >> thread the patches are not present:
> > >> https://lore.kernel.org/all/20230423032437.285014-1-glipus@gmail.com=
/
> > >>
> > >> It is way easier to find your patches when you have all the patches =
of the
> > >> series in the e-mail thread.
> > >>
> > >
> > > Aha, I see the problem now. I guess it has something to do with "--in=
-reply-to"
> > > git send-email optio or similar options.
> > >
> > >> Here for example they are in the thread:
> > >> https://lore.kernel.org/all/20230406173308.401924-1-kory.maincent@bo=
otlin.com/
> > >>
> > >> Do you use git send-email?
> > >
> > > Yes, I use "git format-patch" to generate individual patch files for
> > > every patch in the
> > > stack, and then I use "git send-email" to send out these patches on-b=
y-one.
> > >
> >
> > The problem is, as K=C3=B6ry has mentioned already, in sending patches =
one-by-one.
> > You can provide a directory with patches to git send-email and it will =
take all
> > of them at once. You can try it with --dry-run and check that all pacth=
es have
> > the same In-Reply-To and References headers.
>
> So the best practice for sending patch stacks is to run "git
> send-email ..." against
> a folder containing the freshly generated patch files!
> Thank you for the guidance!
>
> >
> > > Is there a recommended way to send out stacks of patches?
> >

Is it better this time?
https://lore.kernel.org/netdev/20230502043150.17097-1-glipus@gmail.com/
