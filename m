Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 14C086F1A46
	for <lists+netdev@lfdr.de>; Fri, 28 Apr 2023 16:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229700AbjD1OPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Apr 2023 10:15:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjD1OPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Apr 2023 10:15:11 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC4B3210C
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 07:15:09 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-63b5c4c769aso18554b3a.3
        for <netdev@vger.kernel.org>; Fri, 28 Apr 2023 07:15:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682691309; x=1685283309;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=unDfAt/FrXHltaITVyzGZGEMGDv/IpsM+r6uvhqI/NI=;
        b=rud//wjatiP7p8JQ5JzFB6cErnIqmwzkTNS2sbp4d7XGPH1XRfkG9KRMat/CzuWjLi
         xJ4eavm0M9uwUmJxKcuFbyK8Y4aRio/7WqL1boQnN3xETr1nHffsJXgmZj1DameLxiUc
         ExfZ3A/sUsLUPixLLxxNRn9iTvEMzZOZ0/iyFbCt4KqoDccJ0Wl4QxqpcYAmEFIJBK1s
         w8pYbaw9w9zAuSPvk36K7eBmxBrHNxNlFxdd+Iz8a29rDXfoFSeYvr7ZJKnAZl6uw6/r
         bSZZeBF5CHGVH+XeGOrU2/4aEmYbVmDNwVE7T/MU5Ny7dX7SNWMnHrFf2EaHJ77VT9l/
         njsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682691309; x=1685283309;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=unDfAt/FrXHltaITVyzGZGEMGDv/IpsM+r6uvhqI/NI=;
        b=UtMHjcZ0a0CG457oWdtr6CgjFJI2E06Kp+0qJpKP337tCQcoVZj1N86b2qRnxx462P
         ykRqkn05ntH9BtSLhvoHlX6eaGxpuGI6eoNGD19iWvzGwvpxdtVzeWCUfrwquiQ+Hski
         J37ydYgH0lCwzaOd7LYgCXK3D+fIvpnI9ZC0cwt+/WyJ3r19J3mApqKr/oPu0MLx/5VI
         rLas/PWiEqGETSd1Y58u61mT+okSGCWYWdJO8Zh/lOKc/sq+4vdbHoHUJRcYzNLJBbRW
         7x3d69Krug8tv4KujWauObHkOD7ZYbU16jtfbjO+MxjdnQ52PdE58Ym7Tmf9gA9xpqam
         TxPQ==
X-Gm-Message-State: AC+VfDxiS5s96XB8pekV30k8iGpL0OhSG7k3KXt+yD6qIovh/X06x83i
        f9zITS6NvVB3Clykkw79AQy9Cu+hoFmxfaky/XQ=
X-Google-Smtp-Source: ACHHUZ51lO/ca2kvi0X6s9TojLQb3J7eSz6mizfyg9lmHHGFmy8zLgSO8RmjWQhCkgUTJVXNcLys76Dz0Bwyn0DAXz8=
X-Received: by 2002:a05:6a00:a26:b0:641:3c61:db27 with SMTP id
 p38-20020a056a000a2600b006413c61db27mr1047947pfh.13.1682691308822; Fri, 28
 Apr 2023 07:15:08 -0700 (PDT)
MIME-Version: 1.0
References: <20230423032437.285014-1-glipus@gmail.com> <20230426165835.443259-1-kory.maincent@bootlin.com>
 <CAP5jrPE3wpVBHvyS-C4PN71QgKXrA5GVsa+D=RSaBOjEKnD2vw@mail.gmail.com>
 <20230427102945.09cf0d7f@kmaincent-XPS-13-7390> <CAP5jrPH5kQzqzeQwmynOYLisbzL1TUf=AwA=cRbCtxU4Y6dp9Q@mail.gmail.com>
 <20230428101103.02a91264@kmaincent-XPS-13-7390>
In-Reply-To: <20230428101103.02a91264@kmaincent-XPS-13-7390>
From:   Max Georgiev <glipus@gmail.com>
Date:   Fri, 28 Apr 2023 08:14:57 -0600
Message-ID: <CAP5jrPH1=fw7ayEFuzQZKXSkcXeGfUy134yEANzDcSyvwOB-2g@mail.gmail.com>
Subject: Re: [RFC PATCH v4 0/5] New NDO methods ndo_hwtstamp_get/set
To:     =?UTF-8?Q?K=C3=B6ry_Maincent?= <kory.maincent@bootlin.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        maxime.chevallier@bootlin.com, vladimir.oltean@nxp.com,
        vadim.fedorenko@linux.dev, richardcochran@gmail.com,
        gerhard@engleder-embedded.com, thomas.petazzoni@bootlin.com
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

On Fri, Apr 28, 2023 at 2:11=E2=80=AFAM K=C3=B6ry Maincent <kory.maincent@b=
ootlin.com> wrote:
>
> On Thu, 27 Apr 2023 22:57:27 -0600
> Max Georgiev <glipus@gmail.com> wrote:
>
> > Sorry, I'm still learning the kernel patch communication rules.
> > Thank you for guiding me here.
>
> Also, each Linux merging subtree can have its own rules.
> I also, was not aware of net special merging rules:
> https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html
>
>
> > On Thu, Apr 27, 2023 at 2:43=E2=80=AFAM K=C3=B6ry Maincent <kory.maince=
nt@bootlin.com>
> > wrote:
> > >
> > > On Wed, 26 Apr 2023 22:00:43 -0600
> > > Max Georgiev <glipus@gmail.com> wrote:
> > >
> > > >
> > > > Thank you for giving it a try!
> > > > I'll drop the RFC tag starting from the next iteration.
> > >
> > > Sorry I didn't know the net-next submission rules. In fact keep the R=
FC tag
> > > until net-next open again.
> > > http://vger.kernel.org/~davem/net-next.html
> > >
> > > Your patch series don't appear in the cover letter thread:
> > > https://lore.kernel.org/all/20230423032437.285014-1-glipus@gmail.com/
> > > I don't know if it comes from your e-mail or just some issue from lor=
e but
> > > could you check it?
> >
> > Could you please elaborate what's missing in the cover letter?
> > Should the cover letter contain the latest version of the patch
> > stack (v4, then v5, etc.) and some description of the differences
> > between the patch versions?
> > Let me look up some written guidance on this.
>
> I don't know how you send your patch series but when you look on your e-m=
ail
> thread the patches are not present:
> https://lore.kernel.org/all/20230423032437.285014-1-glipus@gmail.com/
>
> It is way easier to find your patches when you have all the patches of th=
e
> series in the e-mail thread.
>

Aha, I see the problem now. I guess it has something to do with "--in-reply=
-to"
git send-email optio or similar options.

> Here for example they are in the thread:
> https://lore.kernel.org/all/20230406173308.401924-1-kory.maincent@bootlin=
.com/
>
> Do you use git send-email?

Yes, I use "git format-patch" to generate individual patch files for
every patch in the
stack, and then I use "git send-email" to send out these patches on-by-one.

Is there a recommended way to send out stacks of patches?
