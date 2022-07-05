Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6693567700
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 20:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233026AbiGES6L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 14:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230417AbiGES6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 14:58:11 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD301F60B
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 11:58:09 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id 76so7875318ybd.0
        for <netdev@vger.kernel.org>; Tue, 05 Jul 2022 11:58:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3raL3Db4m4kOl7wusjljlVNOD4iTwESZC4E355aPMLQ=;
        b=fKq9b41nbWN7wF44/PdWV6ZHCe+bYPNXmJfAcWcc3evXl6sPwIO9uyvv2VC4w6L0DP
         sKwam9/qNxgDRfLB646tXiegomZk8axE/kQUaMlrssfqcIE0RTN4XbxrFXQuDscSNVDk
         0oVlqk1okzJX+nWb9vs9d+aAUWYbjVMztRxqmXpV/mVrgcLEdc/SCnR0NFBic3nyOhXM
         cuZVnWr89P5+sCo8pcSOYUMDSff0hWXOdoz8NGicbWeuOb8RVTetzSXliwZlq7HuuyXP
         mdruvajGc47PV240hYYshZQcU3L1mo7DIIBce2hF6bYaOJboGcmDkH4pQAg4xC1oZIQT
         zuPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3raL3Db4m4kOl7wusjljlVNOD4iTwESZC4E355aPMLQ=;
        b=mwhFP35ymzn1VgTcmuV7YHvOU6+jGcUMa3U9k5SytCSwBRVBKGMTyBZeMfAzpK0aCh
         Nw+SABSUOAiNWlDdAJVgQHM4ndFE3kylkHZZ3+fY5mxkt3nIpTuCGO9bVrDenke5rU0n
         4weLCmzEvpYOosaiPiS+yTMkNSRJ2VbrbFk7mXbFlJzLJpEHuv+SYXBOLhhuUclBdZor
         qAOIxl4Q0d+6jj3REYUQeq1tQVmPr0YJ8nJ956Pveardya7d6A5+Dp28rV+f0JsMJk38
         I8HPpFbFSfl54qtO4A/C1Bop0x0OwKMnX9LJRxKs5NgtspXSrLdQBbznqozD5P2sVDzJ
         MnCg==
X-Gm-Message-State: AJIora8teygVRb95i3GVdJNljXHPMegd20QFfB0FBUEfvMISoSRAPDXP
        Fq79nONZpdKNQY4BbppcsBQM1VB/cNnNkqgyEBJuoA==
X-Google-Smtp-Source: AGRyM1tn8i6N9xJ1nK5EupdELaSdSv9BwRhDnVb3bbeIVNfk3JG3E3E5peA8OUwxmCLWu0Rb9VbhoMarKy+1dmDnJD8=
X-Received: by 2002:a25:2d62:0:b0:66e:7510:8de7 with SMTP id
 s34-20020a252d62000000b0066e75108de7mr4623018ybe.530.1657047488745; Tue, 05
 Jul 2022 11:58:08 -0700 (PDT)
MIME-Version: 1.0
References: <1656618906-29881-1-git-send-email-radhey.shyam.pandey@amd.com>
 <Yr66xEMB/ORr0Xcp@lunn.ch> <MN0PR12MB59531DFD084FA947084D91B6B7819@MN0PR12MB5953.namprd12.prod.outlook.com>
In-Reply-To: <MN0PR12MB59531DFD084FA947084D91B6B7819@MN0PR12MB5953.namprd12.prod.outlook.com>
From:   Saravana Kannan <saravanak@google.com>
Date:   Tue, 5 Jul 2022 11:57:32 -0700
Message-ID: <CAGETcx_BUR3EPDLgp9v0Uk9N=8BtYRjFyhpJTQa9kEMHtkgdwQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: macb: In shared MDIO usecase make MDIO
 producer ethernet node to probe first
To:     "Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "claudiu.beznea@microchip.com" <claudiu.beznea@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "git (AMD-Xilinx)" <git@amd.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 5, 2022 at 11:49 AM Pandey, Radhey Shyam
<radhey.shyam.pandey@amd.com> wrote:
>
> > -----Original Message-----
> > From: Andrew Lunn <andrew@lunn.ch>
> > Sent: Friday, July 1, 2022 2:44 PM
> > To: Pandey, Radhey Shyam <radhey.shyam.pandey@amd.com>
> > Cc: nicolas.ferre@microchip.com; claudiu.beznea@microchip.com;
> > davem@davemloft.net; edumazet@google.com; kuba@kernel.org;
> > pabeni@redhat.com; hkallweit1@gmail.com; linux@armlinux.org.uk;
> > gregkh@linuxfoundation.org; rafael@kernel.org; saravanak@google.com;
> > netdev@vger.kernel.org; linux-kernel@vger.kernel.org; git (AMD-Xilinx)
> > <git@amd.com>
> > Subject: Re: [PATCH net-next v2] net: macb: In shared MDIO usecase make
> > MDIO producer ethernet node to probe first
> >
> > On Fri, Jul 01, 2022 at 01:25:06AM +0530, Radhey Shyam Pandey wrote:
> > > In shared MDIO suspend/resume usecase for ex. with MDIO producer
> > > (0xff0c0000) eth1 and MDIO consumer(0xff0b0000) eth0 there is a
> > > constraint that ethernet interface(ff0c0000) MDIO bus producer has to
> > > be resumed before the consumer ethernet interface(ff0b0000).
> > >
> > > However above constraint is not met when GEM0(ff0b0000) is resumed first.
> > > There is phy_error on GEM0 and interface becomes non-functional on
> > resume.
> > >
> > > suspend:
> > > [ 46.477795] macb ff0c0000.ethernet eth1: Link is Down [ 46.483058]
> > > macb ff0c0000.ethernet: gem-ptp-timer ptp clock unregistered.
> > > [ 46.490097] macb ff0b0000.ethernet eth0: Link is Down [ 46.495298]
> > > macb ff0b0000.ethernet: gem-ptp-timer ptp clock unregistered.
> > >
> > > resume:
> > > [ 46.633840] macb ff0b0000.ethernet eth0: configuring for phy/sgmii
> > > link mode macb_mdio_read -> pm_runtime_get_sync(GEM1) it return -
> > EACCES error.
> > >
> > > The suspend/resume is dependent on probe order so to fix this
> > > dependency ensure that MDIO producer ethernet node is always probed
> > > first followed by MDIO consumer ethernet node.
> > >
> > > During MDIO registration find out if MDIO bus is shared and check if
> > > MDIO producer platform node(traverse by 'phy-handle' property) is
> > > bound. If not bound then defer the MDIO consumer ethernet node probe.
> > > Doing it ensures that in suspend/resume MDIO producer is resumed
> > > followed by MDIO consumer ethernet node.
> >
> > I don't think there is anything specific to MACB here. There are Freescale
> > boards which have an MDIO bus shared by two interfaces etc.
> >
> > Please try to solve this in a generic way, not specific to one MAC and MDIO
> > combination.
>
> Thanks for the review.  I want to get your thoughts on the outline of
> the generic solution. Is the current approach fine and we can extend it
> for all shared MDIO use cases/ or do we see any limitations?
>
> a) Figure out if the MDIO bus is shared.  (new binding or reuse existing)
> b) If the MDIO bus is shared based on DT property then figure out if the
> MDIO producer platform device is probed. If not, defer MDIO consumer
> MDIO bus registration.

Radhey,

I think Andrew added me because he's pointing you towards fw_devlink.

Andrew,

I have intentionally not added phy-handle support to fw_devlink
because it would also prevent the generic driver from binding/cause
issues with DSA. I have some high level ideas on fixing that but
haven't gotten around to it yet.

-Saravana
