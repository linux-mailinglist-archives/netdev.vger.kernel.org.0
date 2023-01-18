Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECD44671871
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 11:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230122AbjARKD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 05:03:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbjARKBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 05:01:20 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8066C951B7;
        Wed, 18 Jan 2023 01:08:58 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id v30so48700077edb.9;
        Wed, 18 Jan 2023 01:08:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TK3qq2DIZCRKV3EaJMeG+kJeMf3Jk06Hg2r49DutS2I=;
        b=beBW8UEmmiP/XEulFLyOZ8zULhs3O8kJR1mGKaz5IB7yWI5puDGvj/ibNDyYEz7wBM
         nAZKmm9wcEV2x5zFbxRUnQ5pLAG+BTk2GpTGoL03kSsiKLO733Fk2VOr+DYVfL5LsLog
         B6Xrth4yzvh6vHP9MtKHZ1Xxz9oO2sW+nEvw80LX8HDY9qXgnPNvSZOhz3Lg0nTGKJhX
         j/E03chxWNiHVijx08eZk4b7lZ7ImA/7ZXTaW4U45g5hriSyJMk51unWYPrdC2mrmsoy
         ynG+Xud40Jjv0Yq590LD2jlCo76XukSunhXttKqSb4Newy8URoxnuj0+glfLQC4GS9zk
         MNaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TK3qq2DIZCRKV3EaJMeG+kJeMf3Jk06Hg2r49DutS2I=;
        b=1ZfeDly0oT4ePRMpDUKxYNtCkAIy4zNinGWb2h7yG2f+R3Rt+4lrmVaIAq7aJrq1J8
         qznpWrvIFGEGHsRjNenmlwwDcF/XlgFMIl5L/qT2eBDLievS3Mn4qcPOOjP3CFYAyZbp
         BjACz8tU9p+rvQYIE5XchUNOF/UiHwZqjxQgrHWVk1r+FAAQPqyTMs76knaCoDHSOABf
         AP2IXZEXPT8ChxFfLg6rIKY7Vw9Z1ovaWC2DQtRiIcgGbU3RLN7RG+NmlmX5zV+E7FBV
         mTisdaAXJfcp/dt7vIrbPwphk03eho3Urc6UrGU2/E4hnQ2SylznwLczWTq/igim4zYe
         Cs2g==
X-Gm-Message-State: AFqh2kp6563PLHHmJcRbs4WoGoEUBq9F81xEJPpDwDOapM3ZT64uWuf1
        g49Kc5OHPQuOVOX/LPux24h6CmL/ERjUGDxpcL4=
X-Google-Smtp-Source: AMrXdXt27Qm/P0OJ9NMULTf9tfxamPk7OkdvmaUnXQRQHp04wzC5i7h6K1ynpktCZZ9IKafJhd1jCUT26YRgag+pB0Y=
X-Received: by 2002:a05:6402:643:b0:46f:77af:10ff with SMTP id
 u3-20020a056402064300b0046f77af10ffmr808049edx.178.1674032937213; Wed, 18 Jan
 2023 01:08:57 -0800 (PST)
MIME-Version: 1.0
References: <20230117102645.24920-1-liujia6264@gmail.com> <9f29ff29-62bb-c92b-6d69-ccc86938929e@intel.com>
 <5d96deeb-a59d-366d-dbb2-d88623cdfa2d@intel.com>
In-Reply-To: <5d96deeb-a59d-366d-dbb2-d88623cdfa2d@intel.com>
From:   Jia Liu <liujia6264@gmail.com>
Date:   Wed, 18 Jan 2023 17:08:45 +0800
Message-ID: <CA+eZsiZ81+AL1-mLb4mONZnMqO=uUPFcw=QWFhEY36_jg9MpiQ@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH] e1000e: Add ADP_I219_LM17 to ME S0ix blacklist
To:     "Neftin, Sasha" <sasha.neftin@intel.com>
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org,
        "Ruinskiy, Dima" <dima.ruinskiy@intel.com>,
        "Lifshits, Vitaly" <vitaly.lifshits@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 18, 2023 at 1:20 PM Neftin, Sasha <sasha.neftin@intel.com> wrote:
>
> On 1/17/2023 21:34, Jacob Keller wrote:
> >
> >
> > On 1/17/2023 2:26 AM, Jiajia Liu wrote:
> >> I219 on HP EliteOne 840 All in One cannot work after s2idle resume
> >> when the link speed is Gigabit, Wake-on-LAN is enabled and then set
> >> the link down before suspend. No issue found when requesting driver
> >> to configure S0ix. Add workround to let ADP_I219_LM17 use the dirver
> >> configured S0ix.
> >>
> >> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=216926
> >> Signed-off-by: Jiajia Liu <liujia6264@gmail.com>
> >> ---
> >>
> >> It's regarding the bug above, it looks it's causued by the ME S0ix.
> >> And is there a method to make the ME S0ix path work?
> No. This is a fragile approach. ME must get the message from us
> (unconfigure the device from s0ix). Otherwise, ME will continue to
> access LAN resources and the controller could get stuck.
> I see two ways:
> 1. you always can skip s0ix flow by priv_flag
> 2. Especially in this case (HP platform) - please, contact HP (what is
> the ME version on this system, and how was it released...). HP will open
> a ticket with Intel. (then we can involve the ME team)

HP released BIOS including ME firmware on their website HP.com at
https://support.hp.com/my-en/drivers/selfservice/hp-eliteone-840-23.8-inch-g9-all-in-one-desktop-pc/2101132389.
There is upgrade interface on the BIOS setup menu which can connect
HP.com and upgrade to newer BIOS.

The initial ME version was v16.0.15.1735 from BIOS 02.03.04.
Then I upgraded to the latest one v16.1.25.1932v3 from BIOS 02.06.01
released on Nov 28, 2022. Both of them can produce this issue.

I have only one setup. Is it possible to try on your system which has the
same I219-LM to see if it's platform specific or not?

> >>
> >
> > No idea. It does seem better to disable S0ix if it doesn't work properly
> > first though...
> >
> >>   drivers/net/ethernet/intel/e1000e/netdev.c | 25 ++++++++++++++++++++++
> >>   1 file changed, 25 insertions(+)
> >>
> >> diff --git a/drivers/net/ethernet/intel/e1000e/netdev.c b/drivers/net/ethernet/intel/e1000e/netdev.c
> >> index 04acd1a992fa..7ee759dbd09d 100644
> >> --- a/drivers/net/ethernet/intel/e1000e/netdev.c
> >> +++ b/drivers/net/ethernet/intel/e1000e/netdev.c
> >> @@ -6330,6 +6330,23 @@ static void e1000e_flush_lpic(struct pci_dev *pdev)
> >>      pm_runtime_put_sync(netdev->dev.parent);
> >>   }
> >>
> >> +static u16 me_s0ix_blacklist[] = {
> >> +    E1000_DEV_ID_PCH_ADP_I219_LM17,
> >> +    0
> >> +};
> >> +
> >> +static bool e1000e_check_me_s0ix_blacklist(const struct e1000_adapter *adapter)
> >> +{
> >> +    u16 *list;
> >> +
> >> +    for (list = me_s0ix_blacklist; *list; list++) {
> >> +            if (*list == adapter->pdev->device)
> >> +                    return true;
> >> +    }
> >> +
> >> +    return false;
> >> +}
> >
> > The name of this function seems odd..? "check_me"? It also seems like we
> > could just do a simple switch/case on the device ID or similar.
> >
> > Maybe: "e1000e_device_supports_s0ix"?
> >
> >> +
> >>   /* S0ix implementation */
> >>   static void e1000e_s0ix_entry_flow(struct e1000_adapter *adapter)
> >>   {
> >> @@ -6337,6 +6354,9 @@ static void e1000e_s0ix_entry_flow(struct e1000_adapter *adapter)
> >>      u32 mac_data;
> >>      u16 phy_data;
> >>
> >> +    if (e1000e_check_me_s0ix_blacklist(adapter))
> >> +            goto req_driver;
> >> +
> >>      if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID &&
> >>          hw->mac.type >= e1000_pch_adp) {
> >>              /* Request ME configure the device for S0ix */
> >
> >
> > The related code also seems to already perform some set of mac checks
> > here...
> >
> >> @@ -6346,6 +6366,7 @@ static void e1000e_s0ix_entry_flow(struct e1000_adapter *adapter)
> >>              trace_e1000e_trace_mac_register(mac_data);
> >>              ew32(H2ME, mac_data);
> >>      } else {
> >> +req_driver:>                /* Request driver configure the device to S0ix */
> >>              /* Disable the periodic inband message,
> >>               * don't request PCIe clock in K1 page770_17[10:9] = 10b
> >> @@ -6488,6 +6509,9 @@ static void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
> >>      u16 phy_data;
> >>      u32 i = 0;
> >>
> >> +    if (e1000e_check_me_s0ix_blacklist(adapter))
> >> +            goto req_driver;
> >> +
> >
> > Why not just combine this check into the statement below rather than
> > adding a goto?
> >
> >>      if (er32(FWSM) & E1000_ICH_FWSM_FW_VALID &&
> >>          hw->mac.type >= e1000_pch_adp) {
> >>              /* Keep the GPT clock enabled for CSME */
> >> @@ -6523,6 +6547,7 @@ static void e1000e_s0ix_exit_flow(struct e1000_adapter *adapter)
> >>              else
> >>                      e_dbg("DPG_EXIT_DONE cleared after %d msec\n", i * 10);
> >>      } else {
> >> +req_driver:
> >>              /* Request driver unconfigure the device from S0ix */
> >>
> >>              /* Disable the Dynamic Power Gating in the MAC */
> > _______________________________________________
> > Intel-wired-lan mailing list
> > Intel-wired-lan@osuosl.org
> > https://lists.osuosl.org/mailman/listinfo/intel-wired-lan
>
