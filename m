Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBD2D647FDC
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 10:09:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229907AbiLIJJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 04:09:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbiLIJJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 04:09:15 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BF1254768
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 01:09:14 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id n21so9995081ejb.9
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 01:09:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fgt48rlINqJ++gacbxzdaxwfqg3JChGGNmk6rKS5098=;
        b=cg9EXQ+Rf7e0oz0EmjAlbT5rQH90QcXrsnQudbV0PkUPgPs3Em4g8N6xYIW5L68gsD
         BA9xDyfWjcZLsLKPukBPLaA3DnV2+Gqsdy457UOCz2Iyu/IBdkyZyRl8Kz2cz7omCUd7
         SpMl0xXqSMKX7AZ2STfDKAnkspOm/hCJZ4cqVz/ROXozYCel2AauuGpQvrwLTfI9UVpl
         OXHWCoqZiNIgEyGXlhbgcnYP903O1i0v2g3PxBJxv3OCr+oZQ6QguC/bTIwyg/OhzllB
         o6lHVTBOiM8EiHbx6Q3zvl8f8wKaqwHAbpS6exEkda9NOdlPRg8jibSMelZ0weBJbPSx
         uu7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fgt48rlINqJ++gacbxzdaxwfqg3JChGGNmk6rKS5098=;
        b=IKrgW9bib3zW92DzT/XKx7JNoskgflR5WBR/5mVPJoI1N3qdCm+rfV8wJTxd3hih0L
         UKbRfoyCo8yDN0pXQnIO+L85Ig6m1Yw6XYKfqd/Esnu4grVx1QfIOsa4Ea2qe1RwAsCU
         hExBf/PhVYMFacfRMEKBb6qL/+k9Yzsspsu7K0Jf/cDRI7L4y+ju77NqRlK/GS0vYtSy
         fK7Dk42cC7/nPgTnIYArsgjCQpuuy2qVAdudbooLKZbq3I428qHSdnRSM+4L9d7ESsKY
         i/hwyRC6pcnk/l5tJzMxao3eckoJZ4PcaOyxaAU9ZALzp1MikumOjEQKJGyKo7QXtb46
         fc0A==
X-Gm-Message-State: ANoB5pkXJ3sYruTrK2lYoemKL3YGqpClBoL5xXDuAQAI7zX34CK4YDF/
        yIXvZ46UgEW6UxYw1BgaJn5yevelENi6VRjwMxbwntfEgD3/3A==
X-Google-Smtp-Source: AA0mqf5DLMTCrXds3dIr04vA44eSdXU4m05VJ0nn6h21t7DCRo/HUhy7HWIoC0jY748nadNyO+9AG8GwUrzCiICNBGg=
X-Received: by 2002:a17:906:6b97:b0:7c0:fe68:35e9 with SMTP id
 l23-20020a1709066b9700b007c0fe6835e9mr12098147ejr.49.1670576952640; Fri, 09
 Dec 2022 01:09:12 -0800 (PST)
MIME-Version: 1.0
References: <20221118090306.48022-1-tirthendu.sarkar@intel.com>
 <Y3ytcGM2c52lzukO@unreal> <20221122155759.426568-1-alexandr.lobakin@intel.com>
 <MN2PR11MB404540A828EDDE82F00E8E2BEA1A9@MN2PR11MB4045.namprd11.prod.outlook.com>
 <CAJ8uoz1RjaGv=HEwmaZw1hKH_GpHA9u-sBvz-Cxb0W_wdYjDZg@mail.gmail.com>
In-Reply-To: <CAJ8uoz1RjaGv=HEwmaZw1hKH_GpHA9u-sBvz-Cxb0W_wdYjDZg@mail.gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Fri, 9 Dec 2022 10:09:00 +0100
Message-ID: <CAJ8uoz2_s_hyYZaPt15a9c274UXC-8Ejc2nPAmqMN9437fcciQ@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH intel-next v4] i40e: allow toggling
 loopback mode via ndo_set_features callback
To:     "Rout, ChandanX" <chandanx.rout@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Cc:     "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Sarkar, Tirthendu" <tirthendu.sarkar@intel.com>,
        "tirtha@gmail.com" <tirtha@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Kuruvinakunnel, George" <george.kuruvinakunnel@intel.com>,
        "Nagaraju, Shwetha" <shwetha.nagaraju@intel.com>,
        "Nagraj, Shravan" <shravan.nagraj@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 7, 2022 at 4:37 PM Magnus Karlsson
<magnus.karlsson@gmail.com> wrote:
>
> On Wed, Dec 7, 2022 at 4:01 PM Rout, ChandanX <chandanx.rout@intel.com> wrote:
> >
> > Hi Team,
> > We observed some different result on i40e driver which are as follows
> >
> > Issue Summary: Unable to find loopback test in "ethtool -t <interface> using i40e driver using latest next-queue.
> > Observations:
> > ===========
> > 1. we are able to enable loopback mode on i40e driver.
> > 2. We are unable to find loopback test in "ethtool -t <interface>" command while using i40e driver.
>
> That is correct, there is no loopback test in i40e. We chose not to
> add one since it was broken in ice (until Maciej fixed it), so we
> thought nobody actually used it. Instead, we have a much more thorough
> test shipped in tools/testing/selftests/bpf/xsk* that tests the
> loopback support in more ways than just sending a single message. I
> have run this test using Tirtha's patch and it passes. So can I sign
> off with a Tested-by? Would save you a lot of time, which is good.
> There is no point for you to run the same test as I did again. Just a
> waste of valuable testing time.

Adding intel-wired and Tony who was not on the reply for some reason.

I have now tested the patch and it passes all the tests executed by
tools/testing/selftests/bpf/test_xsk.sh. The script launches over 100
tests that send 1000s of different packets through the loopback
interface and verifies that the packet content is the same as what was
sent and that they are received in order.

Tested-by: Magnus Karlsson <magnus.karlsson@intel.com>

Tony, please pick this up for your next i40e pull request / release.

Thank you: Magnus

> > 3. However, in ice driver we are able to enable loopback mode also we are able to see the loopback test using "ethtool -t <interface>".
> >
> > Note: Detail Observation is attached in excel format.
> >
> > On I40e
> > =======
> > [root@localhost admin]# ethtool -k ens802f3 | grep loopback
> > loopback: off
> > [root@localhost admin]# ethtool -K ens802f3 loopback on
> > [root@localhost admin]# ethtool -k ens802f3 | grep loopback
> > loopback: on
> > [root@localhost admin]# ethtool -t ens802f3 online
> > The test result is PASS
> > The test extra info:
> > Register test  (offline)         0
> > Eeprom test    (offline)         0
> > Interrupt test (offline)         0
> > Link test   (on/offline)         0
> > [root@localhost admin]# ethtool -t ens802f3 offline
> > The test result is PASS
> > The test extra info:
> > Register test  (offline)         0
> > Eeprom test    (offline)         0
> > Interrupt test (offline)         0
> > Link test   (on/offline)         0
> >
> > On ice
> > =====
> > [root@localhost admin]# ethtool -k ens801f0np0 | grep loopback
> > loopback: off
> > [root@localhost admin]# ethtool -K ens801f0np0 loopback on
> > [root@localhost admin]# ethtool -k ens801f0np0 | grep loopback
> > loopback: on
> > [root@localhost admin]# ethtool -t ens801f0np0 online
> > The test result is PASS
> > The test extra info:
> > Register test  (offline)         0
> > EEPROM test    (offline)         0
> > Interrupt test (offline)         0
> > Loopback test  (offline)         0
> > Link test   (on/offline)         0
> > [root@localhost admin]# ethtool -t ens801f0np0 offline
> > The test result is PASS
> > The test extra info:
> > Register test  (offline)         0
> > EEPROM test    (offline)         0
> > Interrupt test (offline)         0
> > Loopback test  (offline)         0
> > Link test   (on/offline)         0
> >
> >
> > Thanks & Regards
> > Chandan Kumar Rout
> >
> > -----Original Message-----
> > From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of Lobakin, Alexandr
> > Sent: 22 November 2022 21:28
> > To: Leon Romanovsky <leon@kernel.org>
> > Cc: Sarkar, Tirthendu <tirthendu.sarkar@intel.com>; tirtha@gmail.com; intel-wired-lan@lists.osuosl.org; netdev@vger.kernel.org; Karlsson, Magnus <magnus.karlsson@intel.com>
> > Subject: Re: [Intel-wired-lan] [PATCH intel-next v4] i40e: allow toggling loopback mode via ndo_set_features callback
> >
> > From: Leon Romanovsky <leon@kernel.org>
> > Date: Tue, 22 Nov 2022 13:07:28 +0200
> >
> > > On Fri, Nov 18, 2022 at 02:33:06PM +0530, Tirthendu Sarkar wrote:
> > > > Add support for NETIF_F_LOOPBACK. This feature can be set via:
> > > > $ ethtool -K eth0 loopback <on|off>
> > > >
> > > > This sets the MAC Tx->Rx loopback.
> > > >
> > > > This feature is used for the xsk selftests, and might have other
> > > > uses too.
> >
> > [...]
> >
> > > > @@ -12960,6 +12983,9 @@ static int i40e_set_features(struct net_device *netdev,
> > > >     if (need_reset)
> > > >             i40e_do_reset(pf, I40E_PF_RESET_FLAG, true);
> > > >
> > > > +   if ((features ^ netdev->features) & NETIF_F_LOOPBACK)
> > > > +           return i40e_set_loopback(vsi, !!(features & NETIF_F_LOOPBACK));
> > >
> > > Don't you need to disable loopback if NETIF_F_LOOPBACK was cleared?
> >
> > 0 ^ 1 == 1 -> call i40e_set_loopback()
> > !!(0) == 0 -> disable
> >
> > >
> > > > +
> > > >     return 0;
> > > >  }
> > > >
> > > > @@ -13722,7 +13748,7 @@ static int i40e_config_netdev(struct i40e_vsi *vsi)
> > > >     if (!(pf->flags & I40E_FLAG_MFP_ENABLED))
> > > >             hw_features |= NETIF_F_NTUPLE | NETIF_F_HW_TC;
> > > >
> > > > -   netdev->hw_features |= hw_features;
> > > > +   netdev->hw_features |= hw_features | NETIF_F_LOOPBACK;
> > > >
> >
> > Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> >
> > Thanks,
> > Olek
> > _______________________________________________
> > Intel-wired-lan mailing list
> > Intel-wired-lan@osuosl.org
> > https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
