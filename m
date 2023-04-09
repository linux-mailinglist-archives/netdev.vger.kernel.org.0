Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFC126DC20D
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 01:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjDIXut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Apr 2023 19:50:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjDIXus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Apr 2023 19:50:48 -0400
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F8A030F8
        for <netdev@vger.kernel.org>; Sun,  9 Apr 2023 16:50:46 -0700 (PDT)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-54ee108142eso76832197b3.2
        for <netdev@vger.kernel.org>; Sun, 09 Apr 2023 16:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1681084245; x=1683676245;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C8adOTLqct3XPr3reuWveSLSHKj0Xf6hKON3MRJlKAw=;
        b=HRskwsUquntZ9S5aTDjoFQ4goQx5DL2UfKOdPBnTQEIZlDrxKg5WEate7r6j99qfZC
         3WHt2Z+S4llzaWSLyrzPZLwpEvRkJklqousERjLsGNL4rrRUMsJ/oKZdu73v2C0wgxLB
         df+OebMOgeB9cILjd3s/HIuUGESQFq+nRbyAmgcoMVCz2aEH1rNX8uGhj2eWRT4ockt1
         qdD3NIIK/DlFiH0ppNY94awHb3wBU88JcSFBv0mR4di/CosztQnXGc3gT1dAqAEl/uc3
         9UZDuNPJSUredgreXTdnw9vUWU/MWlMaJ99fEMcTKmcAIFFayEG6Fuc2Sg20IMvvWOqU
         YEvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681084245; x=1683676245;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C8adOTLqct3XPr3reuWveSLSHKj0Xf6hKON3MRJlKAw=;
        b=rvwUoOvzOE2aMkd5n++PUaSk6prCrVTY8PdYFn8IdToTT6Jux34OG6bXr9Imtd1yzv
         QB7RgflxtwTSA6X6+u9J4CRENvIHWEhu/Sgs5tk4A4YOg3TIah7w7dPFj9BibiVd7te4
         D9HiBXv5eFgMF6IQH1h4YgnW4xkb/SZuufoWa1OzrXv70VVkSmYVl63ZA/Y2sE3ssRnc
         Paw+AqbO7Mr6cm/LG1h/P2Xb8oUaucdbnoYLr+JPWfqMfN4bw/RjkXeMsnYw9pMBsd9W
         hz9VZHT9FtAicOPqtqm4gE2YW2xvd/HNVqGCd+AcyJttbDfrvr8EAJGDlSN+O9eIHQOV
         vGZA==
X-Gm-Message-State: AAQBX9cHx5vXSkB6vqssfRohOoPATHyoTUB1wNVxgdOVA0tyjFBElywZ
        XeruXl1L3uurYXtFofo2MzsKqUTxOVKdntquEiDz
X-Google-Smtp-Source: AKy350bYTBAYKL5z68O0jiMYR+Tf1OahY27Ts2OtuoJq3/t07mxm9Rn7tc7NG269YV0dgp3vZ/2TUjKi+UpYT5hdtF0=
X-Received: by 2002:a81:c905:0:b0:545:6132:e75f with SMTP id
 o5-20020a81c905000000b005456132e75fmr5245287ywi.8.1681084245250; Sun, 09 Apr
 2023 16:50:45 -0700 (PDT)
MIME-Version: 1.0
References: <CAHC9VhQ7A4+msL38WpbOMYjAqLp0EtOjeLh4Dc6SQtD6OUvCQg@mail.gmail.com>
 <ZCS5oxM/m9LuidL/@x130> <CAHC9VhTvQLa=+Ykwmr_Uhgjrc6dfi24ou=NBsACkhwZN7X4EtQ@mail.gmail.com>
 <1c8a70fc-18cb-3da7-5240-b513bf1affb9@leemhuis.info>
In-Reply-To: <1c8a70fc-18cb-3da7-5240-b513bf1affb9@leemhuis.info>
From:   Paul Moore <paul@paul-moore.com>
Date:   Sun, 9 Apr 2023 19:50:34 -0400
Message-ID: <CAHC9VhT+=DtJ1K1CJDY4=L_RRJSGqRDvnaOdA6j9n+bF7y+36A@mail.gmail.com>
Subject: Re: Potential regression/bug in net/mlx5 driver
To:     Linux regressions mailing list <regressions@lists.linux.dev>
Cc:     Saeed Mahameed <saeed@kernel.org>, Shay Drory <shayd@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 9, 2023 at 4:48=E2=80=AFAM Linux regression tracking (Thorsten
Leemhuis) <regressions@leemhuis.info> wrote:
> On 30.03.23 03:27, Paul Moore wrote:
> > On Wed, Mar 29, 2023 at 6:20=E2=80=AFPM Saeed Mahameed <saeed@kernel.or=
g> wrote:
> >> On 28 Mar 19:08, Paul Moore wrote:
> >>>
> >>> Starting with the v6.3-rcX kernel releases I noticed that my
> >>> InfiniBand devices were no longer present under /sys/class/infiniband=
,
> >>> causing some of my automated testing to fail.  It took me a while to
> >>> find the time to bisect the issue, but I eventually identified the
> >>> problematic commit:
> >>>
> >>>  commit fe998a3c77b9f989a30a2a01fb00d3729a6d53a4
> >>>  Author: Shay Drory <shayd@nvidia.com>
> >>>  Date:   Wed Jun 29 11:38:21 2022 +0300
> >>>
> >>>   net/mlx5: Enable management PF initialization
> >>>
> >>>   Enable initialization of DPU Management PF, which is a new loopback=
 PF
> >>>   designed for communication with BMC.
> >>>   For now Management PF doesn't support nor require most upper layer
> >>>   protocols so avoid them.
> >>>
> >>>   Signed-off-by: Shay Drory <shayd@nvidia.com>
> >>>   Reviewed-by: Eran Ben Elisha <eranbe@nvidia.com>
> >>>   Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
> >>>   Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> >>>
> >>> I'm not a mlx5 driver expert so I can't really offer much in the way
> >>> of a fix, but as a quick test I did remove the
> >>> 'mlx5_core_is_management_pf(...)' calls in mlx5/core/dev.c and
> >>> everything seemed to work okay on my test system (or rather the tests
> >>> ran without problem).
> >>>
> >>> If you need any additional information, or would like me to test a
> >>> patch, please let me know.
> >>
> >> Our team is looking into this, the current theory is that you have an =
old
> >> FW that doesn't have the correct capabilities set.
> >
> > That's very possible; I installed this card many years ago and haven't
> > updated the FW once.
> >
> >  I'm happy to update the FW (do you have a
> > pointer/how-to?), but it might be good to identify a fix first as I'm
> > guessing there will be others like me ...
>
> Nothing happened here for about ten days afaics (or was there progress
> and I just missed it?). That made me wonder: how sound is Paul's guess
> that there will be others that might run into this? If that's likely it
> afaics would be good to get this regression fixed before the release,
> which is just two or three weeks away.
>
> Ciao, Thorsten (wearing his 'the Linux kernel's regression tracker' hat)
> --
> Everything you wanna know about Linux kernel regression tracking:
> https://linux-regtracking.leemhuis.info/about/#tldr
> If I did something stupid, please tell me, as explained on that page.
>
> #regzbot poke

I haven't seen any updates from the mlx5 driver folks, although I may
not have been CC'd?

I did revert that commit on my automated testing kernels and things
are working correctly again, although I'm pretty sure that's not a
good long term solution.  I did also dig up the information on
updating the card's firmware, but I'm holding off on that in case the
driver devs want me to test a fix.

--=20
paul-moore.com
