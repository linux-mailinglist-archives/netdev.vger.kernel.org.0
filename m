Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5D05A2066
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 07:43:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231532AbiHZFnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Aug 2022 01:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbiHZFnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Aug 2022 01:43:00 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79AC2D0206;
        Thu, 25 Aug 2022 22:42:59 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id u22so691890plq.12;
        Thu, 25 Aug 2022 22:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=1YeSohKprvznhG9NRDHk53lOiY+tzruNA0zvGt6cDqA=;
        b=QIYjs8ZjdE355CkSF1xQ6exccmZKYEc1ldYwXFNX6soDgzVvKLLilEKEW8BstaCngQ
         u2lR5DnJVzUwuQuHiJcApUvD4PGhmBLJR6Cm7Upt4hirsCx2tM0rgj6oDvZwAb7Wwcqm
         k0HGwVHgt+ac9cT+oqf/RhfqYcAOS3yCh8oLPtBMy7wF/0JIrVHGib2HbUu7+bXy9i83
         txnd5pvztmmAnQyrTUc7nHr7BWNlEuZPFOHy02BU8FMod/i2iA7OHG6R6YAVim4IlB9Z
         NTfE5Rv7iSb+N0OwR05f25fHMYpZWP1FED5BVglgO0z44oolAcCrjeLrGt9afUkb6a8e
         tlYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=1YeSohKprvznhG9NRDHk53lOiY+tzruNA0zvGt6cDqA=;
        b=1xrOBXOKlROt0J6T40JODnTm3SO5Y1hGb2LwKGbe1Lwb6tbCER0Jx4DF2b2VX+c8QR
         PiPuZ0G6Azaf7p/UVVxAMBvoWeeRUBB1aH11hCTBA9Xdis8bCezLBVZEfb7O34N7yJmv
         ERG6ObpGRCI/HDgsBCt5kSM18eTjt6tUkSt5ImWkqBszG76zUdF/PwteIxNqnmVsKNSd
         Ot170+LZJP4HjxohzqdSVPdKjRR6OqyDtbnuIVTmoJX/ygPw3E9PsAWPWWb1K2GdfJ3B
         0/6PutqSDcCOg3tgBgPzA9EIdF8iWDsHhyia2N1N5Wjps2SqApc/KvHMKVknRifjRy1g
         B9Ww==
X-Gm-Message-State: ACgBeo3fIyQfsDIxTwkNCmvQrPk+fSm4ofA8fjV3QJOHgcVOU1n05btt
        ZQ0SeMmaxVmi80NmP2qiQDzCDF50xsQAFIOKPI0=
X-Google-Smtp-Source: AA6agR42kqYx1732sUGKVGYoHwU6CxdVQe0DWE+KnwPrgjRLwjUZgsI4L38JkYQD/RyuNhYYMhxwZyJBxYpd0NwXP2I=
X-Received: by 2002:a17:902:d584:b0:173:19a2:b831 with SMTP id
 k4-20020a170902d58400b0017319a2b831mr2301769plh.126.1661492578880; Thu, 25
 Aug 2022 22:42:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220823060200.1452663-1-floridsleeves@gmail.com> <0056a39d-d7dc-34ea-3a71-6d5d3835c2d5@intel.com>
In-Reply-To: <0056a39d-d7dc-34ea-3a71-6d5d3835c2d5@intel.com>
From:   Li Zhong <floridsleeves@gmail.com>
Date:   Thu, 25 Aug 2022 22:42:48 -0700
Message-ID: <CAMEuxRraM31C1k9u37ZyxrYVUtKuWdiYUfhw+g=p7_oq-MrMEA@mail.gmail.com>
Subject: Re: [PATCH v1] drivers/net/ethernet: check return value of e1e_rphy()
To:     Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc:     intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
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

On Tue, Aug 23, 2022 at 8:19 AM Jesse Brandeburg
<jesse.brandeburg@intel.com> wrote:
>
> On 8/22/2022 11:02 PM, lily wrote:
> > e1e_rphy() could return error value, which need to be checked.
>
> Thanks for having a look at the e1000e driver. Was there some bug you
> found or is this just a fix based on a tool or observation?
>
> If a tool was used, what tool?
>
These bugs are detected by a static analysis tool to check whether a
return error is handled.

> For networking patches please follow the guidance at
> https://www.kernel.org/doc/html/latest/process/maintainer-netdev.html
>
>
> > Signed-off-by: Li Zhong <floridsleeves@gmail.com>
> > ---
> >   drivers/net/ethernet/intel/e1000e/phy.c | 14 +++++++++++---
> >   1 file changed, 11 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/intel/e1000e/phy.c b/drivers/net/ethernet/intel/e1000e/phy.c
> > index fd07c3679bb1..15ac302fdee0 100644
> > --- a/drivers/net/ethernet/intel/e1000e/phy.c
> > +++ b/drivers/net/ethernet/intel/e1000e/phy.c
> > @@ -2697,9 +2697,12 @@ static s32 e1000_access_phy_wakeup_reg_bm(struct e1000_hw *hw, u32 offset,
> >   void e1000_power_up_phy_copper(struct e1000_hw *hw)
> >   {
> >       u16 mii_reg = 0;
> > +     int ret;
> >
> >       /* The PHY will retain its settings across a power down/up cycle */
> > -     e1e_rphy(hw, MII_BMCR, &mii_reg);
> > +     ret = e1e_rphy(hw, MII_BMCR, &mii_reg);
> > +     if (ret)
> > +             return ret;
>
> Can't return value to a void declared function, did you even compile
> test this?

Sorry for the compilation error. We will fix it in patch v2.

>
> Maybe it should be like:
>      if (ret) {
>         // this is psuedo code
>          dev_warn(..., "PHY read failed during power up\n");
>          return;
>      }
>
> >       mii_reg &= ~BMCR_PDOWN;
> >       e1e_wphy(hw, MII_BMCR, mii_reg);
> >   }
> > @@ -2715,9 +2718,12 @@ void e1000_power_up_phy_copper(struct e1000_hw *hw)
> >   void e1000_power_down_phy_copper(struct e1000_hw *hw)
> >   {
> >       u16 mii_reg = 0;
> > +     int ret;
> >
> >       /* The PHY will retain its settings across a power down/up cycle */
> > -     e1e_rphy(hw, MII_BMCR, &mii_reg);
> > +     ret = e1e_rphy(hw, MII_BMCR, &mii_reg);
> > +     if (ret)
> > +             return ret;
>
> same here.
>
> >       mii_reg |= BMCR_PDOWN;
> >       e1e_wphy(hw, MII_BMCR, mii_reg);
> >       usleep_range(1000, 2000);
> > @@ -3037,7 +3043,9 @@ s32 e1000_link_stall_workaround_hv(struct e1000_hw *hw)
> >               return 0;
> >
> >       /* Do not apply workaround if in PHY loopback bit 14 set */
> > -     e1e_rphy(hw, MII_BMCR, &data);
> > +     ret_val = e1e_rphy(hw, MII_BMCR, &data);
> > +     if (ret_val)
> > +             return ret_val;
> >       if (data & BMCR_LOOPBACK)
> >               return 0;
> >
>
> Did any of the callers of the above function care about the return code
> being an error value? This has been like this for a long time...

We manually check this function e1e_rphy(). We think it's possible that
this function fails and it would be better if we can check the error and
report it for debugging and diagnosing. Though the possibility of error
may be low and that's why it has been here for a long time.
