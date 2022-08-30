Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 320145A5C79
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 09:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbiH3HGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 03:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbiH3HF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 03:05:58 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A635760E4;
        Tue, 30 Aug 2022 00:05:57 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id j9-20020a17090a3e0900b001fd9568b117so7298198pjc.3;
        Tue, 30 Aug 2022 00:05:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=UYQLKisXo/BAxNrAA7zsBCJdL0psoCAOEA7a+b76dao=;
        b=c1ax37GJTbb8ap0dMglhKXjm2j8LhQAeTuYyh7wsb0Nj1UFwv7ktd6XmU6SBBN9sL5
         LklTffP+wP7AmnqEgo5TgfxQW4Be8a9AODFxVGX2wSjC2kpnk95O1tmaZWWtMHsLMWUH
         aEzYC3aJanKwnGtNUpLLAMDAEFShdQMGjUocb+AykBl8jA+LuM4jWTOvN0zV7uNrSGz/
         O0/BGTXX6sshb/y2HS015kXFXW1cn8Yz93mzRkGeOtWw7tztyFJQN1biTNwkElbWCXsY
         m/C6fDjiQ3SK+KpKu5aRBJ2TC7vHJ9gxsFx94DuOh0AramrIqjLXBoXE0YkWd3l8oLP0
         FvEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=UYQLKisXo/BAxNrAA7zsBCJdL0psoCAOEA7a+b76dao=;
        b=o9J3g2c5qwDY2x0uODHlwxaNVcoNod87/b2T5QxLX/SEbiXEAi8PNLuL39AMbWCbcm
         UKaEta+pDO4xLm9nuiVEoVbIYEMhwWnrD08T+qYmOLK3l1LM/tY58OtbRwzi+eTSmvHD
         51PcWRSSedN9qgq4/wjdiFYDd8tlSn3h6CoSt9x+YxS9Suku0yK/Y3ldkswNBwQ+4ejF
         kIxM5+QDeC4pDzbhYAiPnPsNSdkyS/QybHvqX8Ri113eUcMME2wBv0mNldMOB8Nner35
         sUBmWHJ/ZfEy9G5T7ahNQq9JFlpAw9bXtIUc+9Nh7XHkn9XD0ds5PP7Rr8cwxppFWK81
         WO2Q==
X-Gm-Message-State: ACgBeo2S6qDfuuE564QKhzaKuv0vGXRuCugapJmQT0UfmeoEuRZUTG7B
        Wje/fZ6Hff0qIISp1SZ5uOoGB1OAltFTlQyCUk0=
X-Google-Smtp-Source: AA6agR6BNX2F9Y9ZIIDa+QrhIR5b6dHU1HcqWxalSzQWPAX0UT1Ya2RppBBoss/cwv/5Aq4IVZ82hDLQrVPH8bwsqrw=
X-Received: by 2002:a17:903:40cf:b0:174:be28:6d3c with SMTP id
 t15-20020a17090340cf00b00174be286d3cmr8688553pld.126.1661843156836; Tue, 30
 Aug 2022 00:05:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220826065627.1615965-1-floridsleeves@gmail.com> <3226a822-b8be-b712-737a-f8cc523ebed1@intel.com>
In-Reply-To: <3226a822-b8be-b712-737a-f8cc523ebed1@intel.com>
From:   Li Zhong <floridsleeves@gmail.com>
Date:   Tue, 30 Aug 2022 00:05:45 -0700
Message-ID: <CAMEuxRr7qmP7e=HzbX=W1s7rC9b8noVJmxsMvBj9LLMgjcHvtA@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH net-next v2] drivers/net/ethernet: check
 return value of e1e_rphy()
To:     "Neftin, Sasha" <sasha.neftin@intel.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Ruinskiy, Dima" <dima.ruinskiy@intel.com>,
        "Fuxbrumer, Devora" <devora.fuxbrumer@intel.com>,
        "naamax.meir" <naamax.meir@linux.intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
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

On Mon, Aug 29, 2022 at 11:03 AM Neftin, Sasha <sasha.neftin@intel.com> wrote:
>
> On 8/26/2022 09:56, Li Zhong wrote:
> > e1e_rphy() could return error value, which needs to be checked and
> > reported for debugging and diagnose.
> >
> > Signed-off-by: Li Zhong <floridsleeves@gmail.com>
> > ---
> > drivers/net/ethernet/intel/e1000e/phy.c | 20 +++++++++++++++++---
> > 1 file changed, 17 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/intel/e1000e/phy.c b/drivers/net/ethernet/intel/e1000e/phy.c
> > index fd07c3679bb1..060b263348ce 100644
> > --- a/drivers/net/ethernet/intel/e1000e/phy.c
> > +++ b/drivers/net/ethernet/intel/e1000e/phy.c
> > @@ -2697,9 +2697,14 @@ static s32 e1000_access_phy_wakeup_reg_bm(struct e1000_hw *hw, u32 offset,
> > void e1000_power_up_phy_copper(struct e1000_hw *hw)
> > {
> > u16 mii_reg = 0;
> > + int ret;
> >
> > /* The PHY will retain its settings across a power down/up cycle */
> > - e1e_rphy(hw, MII_BMCR, &mii_reg);
> > + ret = e1e_rphy(hw, MII_BMCR, &mii_reg);
> > + if (ret) {
> > + e_dbg("Error reading PHY register\n");
> > + return;
> > + }
> > mii_reg &= ~BMCR_PDOWN;
> > e1e_wphy(hw, MII_BMCR, mii_reg);
> > }
> > @@ -2715,9 +2720,14 @@ void e1000_power_up_phy_copper(struct e1000_hw *hw)
> > void e1000_power_down_phy_copper(struct e1000_hw *hw)
> > {
> > u16 mii_reg = 0;
> > + int ret;
> >
> > /* The PHY will retain its settings across a power down/up cycle */
> > - e1e_rphy(hw, MII_BMCR, &mii_reg);
> > + ret = e1e_rphy(hw, MII_BMCR, &mii_reg);
> > + if (ret) {
> > + e_dbg("Error reading PHY register\n");
> > + return;
> > + }
> > mii_reg |= BMCR_PDOWN;
> > e1e_wphy(hw, MII_BMCR, mii_reg);
> > usleep_range(1000, 2000);
> > @@ -3037,7 +3047,11 @@ s32 e1000_link_stall_workaround_hv(struct e1000_hw *hw)
> > return 0;
> >
> > /* Do not apply workaround if in PHY loopback bit 14 set */
> > - e1e_rphy(hw, MII_BMCR, &data);
> > + ret_val = e1e_rphy(hw, MII_BMCR, &data);
> > + if (ret_val) {
> > + e_dbg("Error reading PHY register\n");
> > + return ret_val;
> > + }
> > if (data & BMCR_LOOPBACK)
> > return 0;
> >
> Generally, I am good with this patch. One question - it is old HW, any
> idea how to check it? (82577/82578 GbE LOM - from 2008)
> Li, how did you check it manually?

These bugs are detected by static analysis. Therefore it's not run-time
checked. However, since currently there is no error handling after
e1e_rphy(), so I think it's necessary to at least check it and expect
there is a chance to fail.
