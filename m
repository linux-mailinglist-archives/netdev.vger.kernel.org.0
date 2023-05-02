Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1A266F3CC2
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 06:35:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbjEBEfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 00:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231953AbjEBEfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 00:35:19 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD6ECF9
        for <netdev@vger.kernel.org>; Mon,  1 May 2023 21:35:17 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-64115e652eeso31747582b3a.0
        for <netdev@vger.kernel.org>; Mon, 01 May 2023 21:35:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683002117; x=1685594117;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yvC+pBFey4Qf5lN50r14SIp8a1YTx2MtWY3O1i5DyvI=;
        b=QDTr1Gs9EJCrXoOAputpTuAenRfqyLZaN6733/Q8/IbQ0FKYl3NS8U83kb7GfIK/np
         sOtr1RogqUGkQIuImnBcJQPnshifPx22249YV9gcI87BkyPlEurLmuwdECIWLX5v7g49
         GaqEGZOn9wN7C1hnejKsn/MlthgG6ZYnp5rl7R5TJwI9gLrIR8sBmxjrKXoFx1++1bes
         F0wpsenHCq5U9+ySdSTDVI4znM+oN5TqaerU2Wkn2g3NO0pHg1eNR7nI7Dq+rWsEnnc0
         q7kG1JTzI3WDdfjaUyCW6f4do9YzBB0gjP+1h8qaAtj//y+S2LBc8Y3Lzq7coAB7GNQp
         O1sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683002117; x=1685594117;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yvC+pBFey4Qf5lN50r14SIp8a1YTx2MtWY3O1i5DyvI=;
        b=GKb1TtpIl50AF6vXHFYaJInKh4HXuve50w43DAOfOIT3MV8JZm5hhnIV62xCt/Pw5t
         wxv0Io3zk2ysGLtMu+/IHh6uH9XVYlsNBvknnuuN5uDm+8XbRcIsBx73g+g3uKHtXQu1
         T89TE7SAa4YgxIRkcE676tiH39mrBa7DVmqYJSV7No7C/W5k+54aLME5MXwGI3EjPYWm
         P+3RbCZxAS0137asU7VNlPZ4HSSVY5byQ2BFmFoFnUByFEg2gvmci29OcsNMm6vV+/qZ
         5qWXRL2Tb6ZW1Wfg8xMEx/+K0YNBkKtle9g3J3p3EWXaC3twnjIEtpcvFIB3wisrfrjG
         p5Cw==
X-Gm-Message-State: AC+VfDzo6L8k0Ejk0ef599AeVQXOphd1NuhRBeee7pCeeWN/zbJtRK+l
        4Oi3ZLMLsc0K6OkCy4RpSVVwT624lPxjxSue4in68uarwgA=
X-Google-Smtp-Source: ACHHUZ5NHfl7pLO3bqgLPmEEilntKRp+gQpQSsKRe42UYF7uL3pt8N5FQr/sBmXlg7qhzI9Sh6n2hL/wWyqbXSxIG1Y=
X-Received: by 2002:a17:90a:d143:b0:23f:962e:825d with SMTP id
 t3-20020a17090ad14300b0023f962e825dmr19365298pjw.1.1683002116519; Mon, 01 May
 2023 21:35:16 -0700 (PDT)
MIME-Version: 1.0
References: <20230423032437.285014-1-glipus@gmail.com> <20230426165835.443259-1-kory.maincent@bootlin.com>
 <CAP5jrPE3wpVBHvyS-C4PN71QgKXrA5GVsa+D=RSaBOjEKnD2vw@mail.gmail.com>
 <20230427102945.09cf0d7f@kmaincent-XPS-13-7390> <CAP5jrPH5kQzqzeQwmynOYLisbzL1TUf=AwA=cRbCtxU4Y6dp9Q@mail.gmail.com>
 <20230428101103.02a91264@kmaincent-XPS-13-7390> <CAP5jrPH1=fw7ayEFuzQZKXSkcXeGfUy134yEANzDcSyvwOB-2g@mail.gmail.com>
 <4c27d467-95a3-fb9a-52be-bcb54f7d1aaf@linux.dev>
In-Reply-To: <4c27d467-95a3-fb9a-52be-bcb54f7d1aaf@linux.dev>
From:   Max Georgiev <glipus@gmail.com>
Date:   Mon, 1 May 2023 22:35:05 -0600
Message-ID: <CAP5jrPE8rriDGVrXwszj8DrrGvmRaqnbRzWuCTfhpt4g9G9FLw@mail.gmail.com>
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

On Sat, Apr 29, 2023 at 1:45=E2=80=AFPM Vadim Fedorenko
<vadim.fedorenko@linux.dev> wrote:
>
> On 28.04.2023 15:14, Max Georgiev wrote:
> > On Fri, Apr 28, 2023 at 2:11=E2=80=AFAM K=C3=B6ry Maincent <kory.maince=
nt@bootlin.com> wrote:
> >>
> >> On Thu, 27 Apr 2023 22:57:27 -0600
> >> Max Georgiev <glipus@gmail.com> wrote:
> >>
> >>> Sorry, I'm still learning the kernel patch communication rules.
> >>> Thank you for guiding me here.
> >>
> >> Also, each Linux merging subtree can have its own rules.
> >> I also, was not aware of net special merging rules:
> >> https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html
> >>
> >>
> >>> On Thu, Apr 27, 2023 at 2:43=E2=80=AFAM K=C3=B6ry Maincent <kory.main=
cent@bootlin.com>
> >>> wrote:
> >>>>
> >>>> On Wed, 26 Apr 2023 22:00:43 -0600
> >>>> Max Georgiev <glipus@gmail.com> wrote:
> >>>>
> >>>>>
> >>>>> Thank you for giving it a try!
> >>>>> I'll drop the RFC tag starting from the next iteration.
> >>>>
> >>>> Sorry I didn't know the net-next submission rules. In fact keep the =
RFC tag
> >>>> until net-next open again.
> >>>> http://vger.kernel.org/~davem/net-next.html
> >>>>
> >>>> Your patch series don't appear in the cover letter thread:
> >>>> https://lore.kernel.org/all/20230423032437.285014-1-glipus@gmail.com=
/
> >>>> I don't know if it comes from your e-mail or just some issue from lo=
re but
> >>>> could you check it?
> >>>
> >>> Could you please elaborate what's missing in the cover letter?
> >>> Should the cover letter contain the latest version of the patch
> >>> stack (v4, then v5, etc.) and some description of the differences
> >>> between the patch versions?
> >>> Let me look up some written guidance on this.
> >>
> >> I don't know how you send your patch series but when you look on your =
e-mail
> >> thread the patches are not present:
> >> https://lore.kernel.org/all/20230423032437.285014-1-glipus@gmail.com/
> >>
> >> It is way easier to find your patches when you have all the patches of=
 the
> >> series in the e-mail thread.
> >>
> >
> > Aha, I see the problem now. I guess it has something to do with "--in-r=
eply-to"
> > git send-email optio or similar options.
> >
> >> Here for example they are in the thread:
> >> https://lore.kernel.org/all/20230406173308.401924-1-kory.maincent@boot=
lin.com/
> >>
> >> Do you use git send-email?
> >
> > Yes, I use "git format-patch" to generate individual patch files for
> > every patch in the
> > stack, and then I use "git send-email" to send out these patches on-by-=
one.
> >
>
> The problem is, as K=C3=B6ry has mentioned already, in sending patches on=
e-by-one.
> You can provide a directory with patches to git send-email and it will ta=
ke all
> of them at once. You can try it with --dry-run and check that all pacthes=
 have
> the same In-Reply-To and References headers.

So the best practice for sending patch stacks is to run "git
send-email ..." against
a folder containing the freshly generated patch files!
Thank you for the guidance!

>
> > Is there a recommended way to send out stacks of patches?
>
