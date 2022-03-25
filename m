Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 406D04E6CFE
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 05:02:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235419AbiCYED5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 00:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229928AbiCYED4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 00:03:56 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D097C55BD
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 21:02:23 -0700 (PDT)
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 404073F1CF
        for <netdev@vger.kernel.org>; Fri, 25 Mar 2022 04:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1648180942;
        bh=HKJrrEY1caDaQR7fQn155PNfxwpc0Tf0D5pTcclyisE=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=PQfMVX4uKj+xJP3XlxIVrcgkqPQIPjYM4hrVjBOEFARmiYeaxnbqKjfnvN1BhJVdS
         Gtr1spqIyhWU2BbL66j94XM9bxUGhVtlakfTe+oENXZMIkfKPy0jAB4PuFrn+FJYO6
         xp0XGEOEbSqG52zmuwNLKPXs+9LLTNQ9hb3s7wOOC8KHsyvrHDMH2u4i7NWJq1dbcD
         cyzRvPH/7Fg22d9WPq6KJcDVK0z26jX5pVWUUfS6U0cAxqRIvHdrSfMlwpaHSQML7L
         D4Eb3rNfnveG0TTTFoewnycOwY90oD1/DqQUN9gx+Bv0Uo0X/6wV2VCnKkKviKQT/5
         FAahpizKwN6NQ==
Received: by mail-oi1-f197.google.com with SMTP id k8-20020a0568080e8800b002ccac943a76so3779419oil.15
        for <netdev@vger.kernel.org>; Thu, 24 Mar 2022 21:02:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HKJrrEY1caDaQR7fQn155PNfxwpc0Tf0D5pTcclyisE=;
        b=suPsW5fRQb1tCZqnp40mQAp1HhbgHM8hKWZ7yJlkhiK4YtEeFMlqvEivLqLwL8Mt+G
         GkP264MBFadA23RRSuqhH75lQTgcAGqIbs1HUcjctnmhy7sU4yZAcDAuhcozSrkUTPPI
         WRvUUQmFWVvQ9kjPPZMPpiSPHuAJuRLHxcBz/SARj9o4LUhe8WXbBbG4Q9dc2Sv62JOK
         K3M67eP/S1sw64S9rgp9eyWakR7dB2AMPI7FO/KwzutQqp4oaWfn0szh3ogAbmMWS0dr
         GOaH/tKLJujHuXDA23egBAKgvZw7rw+rmy934E7so83YNpmO4D5btNMmkDVmgl1763oY
         7PfA==
X-Gm-Message-State: AOAM531tGygyiC/Z0GPCkhf0qnxaI306r3xcE/uO1n90hxhMi0itlFzP
        MGVGVh2q3JQUC0Phj2oCcVGVWgVP1UExM1OyWVzKBVByqhDHWPJO7MZWOsTrHZuKrzo0QTYYChi
        B7VYYv3UWRQg36LjGonJJtf4XguXCYpton62RY0bSHhrIjgHNwA==
X-Received: by 2002:a05:6870:8182:b0:dd:cffa:9c29 with SMTP id k2-20020a056870818200b000ddcffa9c29mr4129460oae.82.1648180941005;
        Thu, 24 Mar 2022 21:02:21 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw19v/fBmujiTN/FbIgCV0Ax4/u+DQ+UpfqJcD0b+4aMAH4mU14/pYOv4glKf5PUc/WrOsn21CTEKscgWwH/98=
X-Received: by 2002:a05:6870:8182:b0:dd:cffa:9c29 with SMTP id
 k2-20020a056870818200b000ddcffa9c29mr4129450oae.82.1648180940751; Thu, 24 Mar
 2022 21:02:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220318024216.42204-1-chris.chiu@canonical.com> <b764c724-9481-09ed-8dd5-a0ebeb0f8a25@reto-schneider.ch>
In-Reply-To: <b764c724-9481-09ed-8dd5-a0ebeb0f8a25@reto-schneider.ch>
From:   Chris Chiu <chris.chiu@canonical.com>
Date:   Fri, 25 Mar 2022 12:02:10 +0800
Message-ID: <CABTNMG2TUKxZL=3RJYGYLeu3-3-G-G_SMdcWHuVHUDepPVgSNQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] rtl8xxxu: Fill up more TX information
To:     Reto Schneider <code@reto-schneider.ch>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvalo@kernel.org,
        Jes.Sorensen@gmail.com, davem@davemloft.net, kuba@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 25, 2022 at 12:32 AM Reto Schneider <code@reto-schneider.ch> wrote:
>
>
> On 18.03.22 03:42, Chris Chiu wrote:
> > The antenna information is missing in rtl8xxxu and txrate is NULL
> > in 8188cu and 8192cu. Fill up the missing information for iw
> > commands.
> >
> > Chris Chiu (2):
> >    rtl8xxxu: feed antenna information for cfg80211
> >    rtl8xxxu: fill up txrate info for gen1 chips
> >
> >   .../wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 75 +++++++++++++++++++
> >   1 file changed, 75 insertions(+)
> >
>
> Those two patches applied to most recent master
> (v5.17-4443-ged4643521e6a) do not compile as rtl8xxxu_legacy_ratetable[]
> and rtl8xxxu_desc_to_mcsrate() are defined twice.
>
> Kind regards,
> Reto

Thanks for pointing this out. I'll fix it in v3.

Chris
