Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71C065B6915
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 09:56:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbiIMH4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 03:56:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230504AbiIMH4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 03:56:05 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC4C5A3EF
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 00:56:03 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id 198so11394559ybc.1
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 00:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=cLpbb86UrbdT6Fmy4lqyat3r0rgj69ADWnh5PWd/WeA=;
        b=Nj+/nuQcfIknUGti4zXJEeziglp1/iJvtBvdYNeyVqEsJ5By9njKtfGlJBOOR8IQLV
         q4K/oFuMhiGTt11Egdf6HPMlS/lMqPRvJj4Ks+BpEKzDFwuADOKLXOxtdMMOGigRxlQR
         eXHrTwffRbxNKjrbpVCZtcx5ATMEwhNSP4a6pjOMMTR/ISP+8epFBSv+M2AdrAOx64XK
         9ZnW/UQb6VO8R+6Qlwv/P0GeOTu0x9qhZicfiMqTcT+iXVH7JJveB3p3xnQcpAVRiDV9
         SmjFX7g7ZhkLJKqKlwO7JqENZut5DQFC4/7YBzzrpHYWq+Nom+xIKfe8HhelApkgmcvI
         fxZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=cLpbb86UrbdT6Fmy4lqyat3r0rgj69ADWnh5PWd/WeA=;
        b=HN0WW5i4P7eOVRgBN46rWEE1q03NofPMUq7ONid7XzlWKhtDyUKFVUysEHEdD4wXRi
         4mVjmiX4aIeksVYzwcJuk8EInJ2oE0EJvxeuXUAzVW7kHbp3NkZIT6id1CQrsyu3cti2
         etWZfawH7gnVe6dSMLNinRy0tHHHM+icsO8Xr8gWZnaLl0vVVy90nEjrVJmwlEgJpIif
         HMh39CeNZyeeTRJBF3vqtBVElRhcChEh+VJRt7hu3vDX+EaVbeDd/J22zNoQwK5UAesw
         asIqjdC6MidiGjLM5RU1B+mCLf1cqhqPKNFH7yIIEfl4Ob0Ya1EBK2ta9PmjxVptFBZD
         5ULg==
X-Gm-Message-State: ACgBeo1+pGOjozWYcx11QlE//Vps1F3O3gNqDRzGBB+SY4APC01tpr+0
        T9OecHfYvt6EsE6nTntIDkMsq5wdaZnL6i4YGnc=
X-Google-Smtp-Source: AA6agR5tCkIemEq9F7BHd5gX7YHzj9YA4lfp0b/xqFnQt49xmGWGBv0Ee4/8dIvOwqxu4/ETWiTPNEnStCbHr2aXrT4=
X-Received: by 2002:a25:8242:0:b0:6a9:1089:e68 with SMTP id
 d2-20020a258242000000b006a910890e68mr26634924ybn.452.1663055762369; Tue, 13
 Sep 2022 00:56:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220707101423.90106-1-jbrunet@baylibre.com> <00f1e968-c140-29b9-dc82-a6f831171d6f@gmail.com>
 <CACdvmAiyFQTUgEzkva9j8xYJYYBRXg_sfB562f3F515AHmkUoA@mail.gmail.com>
 <5c8f4cc4-9807-cfe5-7e0a-7961aef5057f@gmail.com> <1jfshftliz.fsf@starbuckisacylon.baylibre.com>
 <CAK4VdL0pWFga4V1jR8B4oHjXmbBm7dU6BB8pdh0Hymd2sAiqiw@mail.gmail.com> <99839201-6c30-b455-2f32-ea0f992427fc@gmail.com>
In-Reply-To: <99839201-6c30-b455-2f32-ea0f992427fc@gmail.com>
From:   Erico Nunes <nunes.erico@gmail.com>
Date:   Tue, 13 Sep 2022 09:55:50 +0200
Message-ID: <CAK4VdL2b+LjEsXtkDi=judJXj2gEjHL=6QxNFeiPjmdQq8NceQ@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH] net: stmmac: do not poke MAC_CTRL_REG twice on
 link up
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jerome Brunet <jbrunet@baylibre.com>, Da Xue <da@lessconfused.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        linux-amlogic@lists.infradead.org,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Vyacheslav <adeep@lexina.in>, Qi Duan <qi.duan@amlogic.com>
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

On Mon, Aug 29, 2022 at 8:25 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>
> On 29.08.2022 12:29, Erico Nunes wrote:
> > On Mon, Aug 29, 2022 at 12:02 PM Jerome Brunet <jbrunet@baylibre.com> wrote:
> >>>>> Jerome, can you confirm that after this commit the following is no longer needed?
> >>>>> 2c87c6f9fbdd ("net: phy: meson-gxl: improve link-up behavior")
> >>
> >> This never had any meaningful impact for me. I have already reverted it
> >> for testing.
> >>
> >> I'm all for reverting it
> >>
> >>>>>
> >>>>> Then I'd revert it, referencing the successor workaround / fix in stmmac.
> > If we are considering to revert that, I would like to trigger some
> > tests on my S805X CI board farm as well, to ensure it won't regress
> > later. That was one of the original reasons for that patch.
> >
> > Since there are some more changes referenced in this thread, can
> > someone clarify what is the desired state to test? Just revert
> > 2c87c6f9fbdd on top of linux-next, or also apply some other patch?
>
> Yes, just revert 2c87c6f9fbdd on top of linux-next.

I see that the revert is already applied.
For what it's worth I ran have been running some test jobs on my CI
farm with linux-next and the patch reverted and haven't reproduced the
bug that originally prompted 2c87c6f9fbdd so far. So it seems to me
that that patch is indeed no longer needed.

Thanks

Erico
