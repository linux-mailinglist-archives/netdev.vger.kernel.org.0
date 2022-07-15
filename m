Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7C9C575B0B
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 07:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbiGOFgO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 01:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229481AbiGOFfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 01:35:52 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C57C7437F
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 22:35:51 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id m20so2056035ili.3
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 22:35:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jYAWOOGtFlkiPG/21I7baDMXyOiUU0gckUwJzmfvwVo=;
        b=LXP7zqiq3V8qxuINIqGk6Lz9zv+XREfojszRJdCNcksqKFsuAIte5OdR5gPw9FOWkZ
         iKPN4sNsVyn3wswEfGaqvCi7nAc+/1UyOIj7gB/ZniGfpZHHOPacEuGKuW0IfKGJHjfS
         MNEZeNLRygOEoCRq1QKYb7mxYusiVsAJQ5oza8cbBh3GJ5MhUx0Mck1TpCtoVqiL2N1Z
         lLKk0YW4wt5um6nED796GFuC9E3fWRtaxmMfn2mXW4Mly/kkNgF35wLMo7v4xxbyRq3X
         G9hEYp4bUJas+Z6Z32oNj8TszzWfHFmU1nx6yU17/a7GczRgJUuHUnLnFyp4+ympyKNI
         DTew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jYAWOOGtFlkiPG/21I7baDMXyOiUU0gckUwJzmfvwVo=;
        b=Gue7ByK0DR5aeD+zxmf0DBXeM67o0dtsV1UE6lfEsyU1LaZKoD+6o1RfzEM1PoOTIg
         5hTPEZd/qn/KJLZ5UEutmemwaL/E1XFDgt72L3xUFyNl6fvMxvtgLg3KvL5xcS2J139+
         G27N7n9T3aSnu1qRBDMnbpKVW/gcD9LGLWhn7Zk0l70c3XNvgSuzWzcelnNgd48tCzDH
         gi9EAWCsHus62v/5LDFQidyI9l9DPNvdAWvUOwJMfFuP19x+A6GY/4IkNn3CEM/fE6Aa
         WnaLFpx8OKzFDtpwDCJ/0bPcG70BvR/78CkkbZp9Ekt7YHzLKHF1/yDgmj/Uhhwv7btF
         a9zA==
X-Gm-Message-State: AJIora/C00zrhnqNPYBEVheP17JBqOAm+F5gmycRYIO1LCIKT985C6V7
        QxOatiDbkWf7DhKPwx26mxfFynr4yhT1WQWo8vk=
X-Google-Smtp-Source: AGRyM1ub23J3OVvO9vrhvoc+99/w7w7FMUkJp4c4jpx89FzhqkMUGqZ5GsWn6mekMOlprLXKEknDD5j4IlqQOQP/F5k=
X-Received: by 2002:a05:6e02:1b85:b0:2dc:c1c5:c444 with SMTP id
 h5-20020a056e021b8500b002dcc1c5c444mr541688ili.81.1657863350838; Thu, 14 Jul
 2022 22:35:50 -0700 (PDT)
MIME-Version: 1.0
References: <CAK4VdL3-BEBzgVXTMejrAmDjOorvoGDBZ14UFrDrKxVEMD2Zjg@mail.gmail.com>
 <1jczjzt05k.fsf@starbuckisacylon.baylibre.com> <CAK4VdL2=1ibpzMRJ97m02AiGD7_sN++F3SCKn6MyKRZX_nhm=g@mail.gmail.com>
 <6b04d864-7642-3f0a-aac0-a3db84e541af@gmail.com> <CAK4VdL0gpz_55aYo6pt+8h14FHxaBmo5kNookzua9+0w+E4JcA@mail.gmail.com>
 <1e828df4-7c5d-01af-cc49-3ef9de2cf6de@gmail.com> <1j8rts76te.fsf@starbuckisacylon.baylibre.com>
 <a4d3fef1-d410-c029-cdff-4d90f578e2da@gmail.com> <CAK4VdL08sdZV7o7Bw=cutdmoCEi1NYB-yisstLqRuH7QcHOHvA@mail.gmail.com>
 <435b2a9d-c3c6-a162-331f-9f47f69be5ac@gmail.com> <CAK4VdL28nWstiS09MYq5nbtiL+aMbNc=Hzv5F0-VMuNKmX9R+Q@mail.gmail.com>
 <1j5yonnp1a.fsf@starbuckisacylon.baylibre.com> <44006194-eab1-7ae2-3cc8-41c210efd0b1@gmail.com>
 <CACdvmAhcyNXViJgk6o6oAoYvAjAg-NFD74Eym_nGHJx3YAqjzw@mail.gmail.com> <1j35g8gavs.fsf@starbuckisacylon.baylibre.com>
In-Reply-To: <1j35g8gavs.fsf@starbuckisacylon.baylibre.com>
From:   Anand Moon <linux.amoon@gmail.com>
Date:   Fri, 15 Jul 2022 11:05:35 +0530
Message-ID: <CANAwSgQBz_VKhkRmMnYdbq2FJiMg5pvp12Ar32SQrU=mYiH2Ug@mail.gmail.com>
Subject: Re: net: stmmac: dwmac-meson8b: interface sometimes does not come up
 at boot
To:     Jerome Brunet <jbrunet@baylibre.com>
Cc:     Da Xue <da@lessconfused.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Erico Nunes <nunes.erico@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        linux-amlogic@lists.infradead.org, netdev@vger.kernel.org,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        linux-sunxi@lists.linux.dev
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

Hi Jerome

On Mon, 13 Jun 2022 at 15:10, Jerome Brunet <jbrunet@baylibre.com> wrote:
>
>
> On Sat 11 Jun 2022 at 17:00, Da Xue <da@lessconfused.com> wrote:
>
> > On Wed, Mar 9, 2022 at 3:42 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
> >
> >  On 09.03.2022 15:57, Jerome Brunet wrote:
> >  >
> >  > On Wed 09 Mar 2022 at 15:45, Erico Nunes <nunes.erico@gmail.com> wrote:
> >  >
> >  >> On Sun, Mar 6, 2022 at 1:56 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
> >  >>> You could try the following (quick and dirty) test patch that fully mimics
> >  >>> the vendor driver as found here:
> >  >>> https://github.com/khadas/linux/blob/buildroot-aml-4.9/drivers/amlogic/ethernet/phy/amlogic.c
> >  >>>
> >  >>> First apply
> >  >>> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=a502a8f04097e038c3daa16c5202a9538116d563
> >  >>> This patch is in the net tree currently and should show up in linux-next
> >  >>> beginning of the week.
> >  >>>
> >  >>> On top please apply the following (it includes the test patch your working with).
> >  >>
> >  >> I triggered test jobs with this configuration (latest mainline +
> >  >> a502a8f0409 + test patch for vendor driver behaviour), and the results
> >  >> are pretty much the same as with the previous test patch from this
> >  >> thread only.
> >  >> That is, I never got the issue with non-functional link up anymore,
> >  >> but I get the (rare) issue with link not going up.
> >  >> The reproducibility is still extremely low, in the >1% range.
> >  >
> >  > Low reproducibility means the problem is still there, or at least not
> >  > understood completly.
> >  >
> >  > I understand the benefit from the user standpoint.
> >  >
> >  > Heiner if you are going to continue from the test patch you sent,
> >  > I would welcome some explanation with each of the changes.
> >  >
> >  The latest test patch was purely for checking whether we see any
> >  difference in behavior between vendor driver and the mainlined
> >  version. It's in no way meant to be applied to mainline.
> >
> >  > We know very little about this IP and I'm not very confortable with
> >  > tweaking/aligning with AML sdk "blindly" on a driver that has otherwise
> >  > been working well so far.
> >  >
> >
> >  This touches one thing I wanted to ask anyway: Supposedly Amlogic
> >  didn't develop an own Ethernet PHY, and if they licensed an existing
> >  IP then it should be similar to some other existing PHY (that may
> >  have a driver in phylib).
> >
> >  Then what I'll do is submit the following small change that brought
> >  the error rate significantly down according to Erico's tests.
> >
> >  -       phy_trigger_machine(phydev);
> >  +       if (irq_status & INTSRC_ANEG_COMPLETE)
> >  +               phy_queue_state_machine(phydev, msecs_to_jiffies(100));
> >  +       else
> >  +               phy_trigger_machine(phydev);
> >
> >  > Thx
> >  >
> >  >>
> >  >> So at this point, I'm not sure how much more effort to invest into
> >  >> this. Given the rate is very low and the fallback is it will just
> >  >> reset the link and proceed to work, I think the situation would
> >  >> already be much better with the solution from that test patch being
> >  >> merged. If you propose that as a patch separately, I'm happy to test
> >  >> the final submitted patch again and provide feedback there. Or if
> >  >> there is another solution to try, I can try with that too.
> >  >>
> >  >> Thanks
> >  >>
> >  >>
> >  >> Erico
> >  >
> >
> >  Heiner
> >
> > To help reproduce this problem, I have had this problem for as long as I can remember and it still occurs with this patch.
>
> Same here, on both gxl and g12a. Occurrence remains unchanged.
> The is even reproduced if the PHY is switched to polling mode so the
> merged change, related to the IRQ handling, is very unlikely to fix the
> problem.
>
> >
> > This doesn't happen on first boot most of the time. It happens on reboot consistently. I have tested with AML-S805X-CC board, AML-S905X-CC V1, and V2 boards.
> >
>
> On my side, I confirm the network never seems to get stuck in u-boot but
> it might break in Linux, even on the first boot after a power up from
> what I have seen so far.
>
> > I am on u-boot 22.04 with 5.18.3 which includes the patch.
> > u-boot brings up ethernet on start and can grab an IP.
> > Linux brings up ethernet and can grab an IP.
> > reboot
> > u-boot can grab an IP.
> > Linux does not get anything.
> > I have to do ip link set dev eth0 down && up once or more to get ethernet to work again.
> > Sometimes it spams meson8b-dwmac c9410000.ethernet eth0: Reset adapter. If it spams this, ethernet is dead and can't be recovered.
>
> I tried several things, none showing any improvement so far
> * Make sure LPI/EEE is disabled
> * Add the ethernet reset from the main controller on the MAC
> * Test the various DMA modes of STMMAC
> * Port the differences from u-boot and the vendor kernel in the Phy driver
>
> I have also tried to go back in time, up to v4.19 but the problem is actually
> already there. It occurs at lot less though.
> Since v5.6+ the occurence is quite high: approx 1 in 4 boots
> On v4.19: 1 in 50 boots - up to 150.
>
> >
>
> When the problem happen
> * link is reported up
> * ifconfig / MAC is claiming to be sending packets (Tx increasing - no Rx)
> * I see no traffic with wireshark
>
> The packets are getting lost somewhere. Can't say for sure if it is in
> the MAC or the PHY.
>
> > This is fixed via power cycle so I'm assuming some register is not reset or maybe the IP is stuck.
> >
>
> `ethtool -r eth0` also seems to work around the problem.
> This trigs the restart of so many things, it is close to an un/replug of
> the ethernet cable :/
>

Have you give a try for setting up a regulator for ethernet and
implementing runtime power management

Best Regards
-Anand
> > Best,
> > Da Xue
>
>
> _______________________________________________
> Linux-rockchip mailing list
> Linux-rockchip@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-rockchip
