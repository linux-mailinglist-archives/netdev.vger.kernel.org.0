Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54654382044
	for <lists+netdev@lfdr.de>; Sun, 16 May 2021 20:12:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230248AbhEPSN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 May 2021 14:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbhEPSN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 May 2021 14:13:26 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B81BC061573
        for <netdev@vger.kernel.org>; Sun, 16 May 2021 11:12:11 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id z24so3693730ioj.7
        for <netdev@vger.kernel.org>; Sun, 16 May 2021 11:12:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=E2FuQgUKxyLwsqCIUkYLRRw5DyzhiK8Ym8+oofH6L/Q=;
        b=usTfdW2rkW5WwbbcPESt3OG8Ak2est96rgMEEKV2/Gt0hwZBX7b/gtgcjnUdpBjiVi
         xii66etGvOCty2+dihcA60yL00JNN+7MLAtCaT8GupEa+qJzcgUEX68fIroE4SpkwfVy
         LQmfzmScU/KPWZGYlhQMXRUjoQco4nWwzIqeBRYkGAyInFBa2j0VxozypcGzOmz4Puyf
         MP3Xx4SsOmmlaBHblUpJxrEolTt1RbTodPZNs2BVBUsNHrnZOxHLf0T1hpmOvluoZuUI
         XOcXR41bTt3z1SqSakVVI8Dh1bWvaYS1tXAMhquGTQgIKEt2sqpwwZSpSSERQmYQ0V2b
         ozxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=E2FuQgUKxyLwsqCIUkYLRRw5DyzhiK8Ym8+oofH6L/Q=;
        b=JKZAFVBDEDKJe/+wwljHoF/t3RUtANdiH8aBWBR4uZBxzNpz3Dn9q0SLZ7RR8H4IUi
         K4ADTON/WRLyS5VcJwpHmNUt4Qu0qNf6j5AI+XCeouXSyzYS3u97z1ZvfX4dk9F9arZZ
         4COSBKn/4pz7hYCPtHAUjltQqgbC/1V1ssxysEDltsKnlu6eTHV2zdc/wX1nfjN7Xldi
         2L/y912mXrxbQ5XbIfk9+qBBwv45lUMnCaGGjv8fsJUpSf0pEqDlhVNYjcQHxPOLuzL7
         JdTGonpm99j43p3zhO7sE/3d37NZdPhJfgfUiCLBeOYi4l61CNOtKdL3/W2JZWfTHdnX
         gLaA==
X-Gm-Message-State: AOAM531u4Nc1CqIOE9yZe70zo3iHY7sUCCLE4nQKEyHYRz6tcrdcXiOZ
        t4D/shaoDRbH1pPUF3CYmJe3ZVbeCIuGf1xUo2MOzHwxk18=
X-Google-Smtp-Source: ABdhPJwRFuITDDTQeqSe2Q9omoujOd/wCBCrIi7HAkfcUeVf2QM8k4LV0LMd2+X+PFirIGfi9xCWgMtYRiK5UTAFxVs=
X-Received: by 2002:a5d:8787:: with SMTP id f7mr42742794ion.108.1621188730748;
 Sun, 16 May 2021 11:12:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210515064907.28235-1-heiko.thiery@gmail.com> <CAEyMn7a_ig6-FRjyY0uv1q28KNTjcf4AHG3NZaGch_Zeo3P49g@mail.gmail.com>
In-Reply-To: <CAEyMn7a_ig6-FRjyY0uv1q28KNTjcf4AHG3NZaGch_Zeo3P49g@mail.gmail.com>
From:   Heiko Thiery <heiko.thiery@gmail.com>
Date:   Sun, 16 May 2021 20:11:59 +0200
Message-ID: <CAEyMn7ap3RL_oh0ucerH9POP+S4VGKfULhJQSb3AVeNFjR4VZw@mail.gmail.com>
Subject: Re: [PATCH] Fix warning due to format mismatch for field width
 argument to fprintf()
To:     netdev@vger.kernel.org
Cc:     Ben Hutchings <bhutchings@solarflare.com>,
        Ben Hutchings <bwh@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Am Sa., 15. Mai 2021 um 09:59 Uhr schrieb Heiko Thiery <heiko.thiery@gmail.=
com>:
>
> Added Ben's other mail addresses.
>
> Am Sa., 15. Mai 2021 um 08:49 Uhr schrieb Heiko Thiery <heiko.thiery@gmai=
l.com>:
> >
> > bnxt.c:66:54: warning: format =E2=80=98%lx=E2=80=99 expects argument of=
 type =E2=80=98long unsigned int=E2=80=99, but argument 3 has type =E2=80=
=98unsigned int=E2=80=99 [-Wformat=3D]
> >    66 |   fprintf(stdout, "Length is too short, expected 0x%lx\n",
> >       |                                                    ~~^
> >       |                                                      |
> >       |                                                      long unsig=
ned int
> >       |                                                    %x
> >
> > Signed-off-by: Heiko Thiery <heiko.thiery@gmail.com>
> > ---
> >  bnxt.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/bnxt.c b/bnxt.c
> > index b46db72..0c62d1e 100644
> > --- a/bnxt.c
> > +++ b/bnxt.c
> > @@ -63,7 +63,7 @@ int bnxt_dump_regs(struct ethtool_drvinfo *info __may=
be_unused, struct ethtool_r
> >                 return 0;
> >
> >         if (regs->len < (BNXT_PXP_REG_LEN + BNXT_PCIE_STATS_LEN)) {
> > -               fprintf(stdout, "Length is too short, expected 0x%lx\n"=
,
> > +               fprintf(stdout, "Length is too short, expected 0x%x\n",
> >                         BNXT_PXP_REG_LEN + BNXT_PCIE_STATS_LEN);

This does not solve the issue. The provided patch only works on 32bit
systems. It seems there is a problem with 32bit vs 64bit.

--=20
Heiko
