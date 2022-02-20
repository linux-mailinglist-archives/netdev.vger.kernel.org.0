Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA09A4BD28A
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 00:17:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243787AbiBTXGP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 18:06:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbiBTXGO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 18:06:14 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 503E945040;
        Sun, 20 Feb 2022 15:05:52 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id o6so12134869ljp.3;
        Sun, 20 Feb 2022 15:05:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=d6WjrznPFgIX6CuAd5lqklb2/6Lx0uXfvC4YzTqEtvA=;
        b=iMojWWI+7n2PpBTO70eTfp8MW0MzGy2jsjxoDA/jM7LSbgSMvz+CYhaBcCSUgKU6qV
         wGF+vispyXV31QoMLymdM2y0gQCRBOCVQrdmm7mhW1p6vqQsKjwHnYkPb6LdQJT6jX4u
         0Sa8A2m4qHdmKuQcQ58T7X5hkYGanx597cErp/5DADxV3fEeMQ6XbM4/qy5eA6yJAO8q
         4WN+DtbndyHyejG1jiDiG3n16tzWrUDVhBqmh8uPiPaHhLqGdhOrA2ZaewccoS0UxASI
         Plsk5NqiInQlq59Da4UoH2qFPT7Q7koTWvfpvYC6Blvk7XoI5F9u2ZhXKHI/mnfERzlY
         MOGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=d6WjrznPFgIX6CuAd5lqklb2/6Lx0uXfvC4YzTqEtvA=;
        b=yBJrDDFe6/4TTIIoCmxpSV1Urd6gaYiEgg2o8cutS7MviLwRH/LHZdqsuaWPMOf2Q/
         modhIQaLbkD8V1vIsdjoFaO8NxYSO2+w+3RhOOQY18Rx20lqn01fknNB9lMezoCti3fe
         4k/ip8pKM7SYszfRuDgDNPDebtGdQq0H7d0Rt+NLP5p0E3mNtpEAe19hIVV3hR4vUEu5
         CuTHIps2V24ELBuAmMZHlzli/Bz5HnqyxvjFVE1UT1fo9d2if1feODr2NjsJFHrbyisB
         qous8Pwajdkt2PC4FskvKiOkBr44t2HDM4xE77hBtkg2CK+ETYnYJIYF1D8tX53zvYhB
         bxfw==
X-Gm-Message-State: AOAM531PYx5FBDP4knm4KFRwFIrKC2yMNK8/jkjRl7mkHaCKQGvf2F48
        rKWaH/sX+uP7xx1urXH7S804U8w+CEdFDzOplksuUXwlZqk=
X-Google-Smtp-Source: ABdhPJxRJj8QR0il65uClOD8XZzZT0EpucNsBb0C84UmDCLFX0biPyxwmJiPXgddtECvFKINHNwKJr5lK8V9VswbDrs=
X-Received: by 2002:a2e:3a17:0:b0:246:387c:46ab with SMTP id
 h23-20020a2e3a17000000b00246387c46abmr4147234lja.77.1645398350598; Sun, 20
 Feb 2022 15:05:50 -0800 (PST)
MIME-Version: 1.0
References: <20220128110825.1120678-1-miquel.raynal@bootlin.com>
 <20220128110825.1120678-2-miquel.raynal@bootlin.com> <CAB_54W60OiGmjLQ2dAvnraq6fkZ6GGTLMVzjVbVAobcvNsaWtQ@mail.gmail.com>
 <20220131152345.3fefa3aa@xps13> <CAB_54W7SZmgU=2_HEm=_agE0RWfsXxEs_4MHmnAPPFb+iVvxsQ@mail.gmail.com>
 <20220201155507.549cd2e3@xps13> <CAB_54W5mnovPX0cyq5dwVoQKa6VZx3QPCfVoPAF+LQ5DkdQ3Mw@mail.gmail.com>
 <20220207084918.0c2e6d13@xps13>
In-Reply-To: <20220207084918.0c2e6d13@xps13>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Sun, 20 Feb 2022 18:05:39 -0500
Message-ID: <CAB_54W6RC9dqRzPyN3OYb6pWfst+UixSAKppaCtDaCvzE0_kAQ@mail.gmail.com>
Subject: Re: [PATCH wpan-next v2 1/5] net: ieee802154: Improve the way
 supported channels are declared
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        Michael Hennerich <michael.hennerich@analog.com>,
        Varka Bhadram <varkabhadram@gmail.com>,
        Xue Liu <liuxuenetmail@gmail.com>, Alan Ott <alan@signal11.us>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Feb 7, 2022 at 2:49 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> Hi Alexander,
>
> alex.aring@gmail.com wrote on Sun, 6 Feb 2022 16:37:23 -0500:
>
> > Hi,
> >
> > On Tue, Feb 1, 2022 at 9:55 AM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
> > ...
> > >
> > > Given the new information that I am currently processing, I believe the
> > > array is not needed anymore, we can live with a minimal number of
> > > additional helpers, like the one getting the PRF value for the UWB
> > > PHYs. It's the only one I have in mind so far.
> >
> > I am not really sure if I understood now. So far those channel/page
> > combinations are the same because we have no special "type" value in
> > wpan_phy,
>
> Yes, my assumption was more: I know there are only -legacy- phy types
> supported, we will add another (or improve the current) way of defining
> channels when we'll need to. Eg when improving UWB support.
>
> > what we currently support is the "normal" (I think they name
> > it legacy devices) phy type (no UWB, sun phy, whatever) and as Channel
> > Assignments says that it does not apply for those PHY's I think it
> > there are channel/page combinations which are different according to
> > the PHY "type". However we don't support them and I think there might
> > be an upcoming type field in wpan_phy which might be set only once at
> > registration time.
>
> An idea might be to create a callback that drivers might decide to
> implement or not. If they implement it, the core might call it to get
> further information about the channels. The core would provide a {page,
> channel} couple and retrieve a structure with many information such as
> the the frequency, the protocol, eventually the prf, etc.
>

As I said before, for "many information" we should look at how
wireless is using that with regdb and extend it with 802.15.4
channels/etc. The kernel should only deal with an unique
identification of a database key for "regdb" which so far I see is a
combination of phy type, page id and channel id. Then from "somewhere"
also the country code gets involved into that and you get a subset of
what is available.

- Alex
