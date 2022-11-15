Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7A19629CFB
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 16:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230489AbiKOPJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 10:09:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiKOPI7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 10:08:59 -0500
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33EDE1834A
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 07:08:58 -0800 (PST)
Received: by mail-lj1-x22a.google.com with SMTP id u2so17889611ljl.3
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 07:08:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WdMP7/Hibq3K0cpWUlTc9mxYobtlc/Al3U2JWvm7Dy8=;
        b=VSdJyyb/+meWv4+wQuLp4J9bx3ckO9NRyfrZZi5Xe+cWthBtfL/yLReEjPhYoTJuxd
         HK4u3mnd1d/mQF+pQymj5wbH+y2r7z/y6HCNGswCw9z2x9M8kWGlm4oEHTFIQApKUMpz
         rC3eGD3tShN48mUBdWvBHcLVvucYILOQEdXX5mdr26rwm3nbj3JXaJ0WvOjmRyiAtdvL
         nO10j0Fg940d1jILPQkzgkyrFk/srmyupM9jq3v/M1iHabtdldXSXXRe/QAMyfd8kKAu
         f2JIb1zae2V3PdF+m3LerwU0rsCNiPpgMMK8/o+lgKZmR08nyHQYRP6sjp39q7UQPw5O
         vW4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WdMP7/Hibq3K0cpWUlTc9mxYobtlc/Al3U2JWvm7Dy8=;
        b=UGFfyxXquO1MoOGQ4ztr97ClA6a91Ogytwwx7JYFSHFdR7Jn3J8INFzRY8WZ05+fvY
         Qa0Et4sHsJupC1oUOXLHUbOTin17g/yfbaeBCG6cJ8ISzVns4QoItlA/MF2zJZADm+U7
         9maFsHkHrSA0/H2uI6Ejf3MHBg36y6TNuFfQw7vrd6xhaof5xymB7v5gS6ogAsQbizYM
         CPop80qQrBXQUe39f7dTWBAxIzd3Js+DiLIYL9VuqJra46isqvAItl2ggnmRTS8jjhhM
         RIq0oAxMh3tgnORrBylAcvSS4F94Qg3i6WzbuSndUHmNkxsWsZdpJ43BtmDJEHaZTVl+
         affQ==
X-Gm-Message-State: ANoB5plE+II1hMorOtTU9mByqR/uO8AVvxmKhKizxagFz8eqtgP+dfG9
        Tdnp65MnuKLqfpysPGFbTEj18XCrRtgHG1OkKpZ+5A==
X-Google-Smtp-Source: AA0mqf5Slx2GacuJGXm1aMFurpN072tk7crY2nexZGGWfcuy0fIHlg7XZb6dSR7zE1KEyfR+FlNK6QZzCKAfRId7ie8=
X-Received: by 2002:a2e:9c41:0:b0:278:eef5:8d13 with SMTP id
 t1-20020a2e9c41000000b00278eef58d13mr5221791ljj.56.1668524936401; Tue, 15 Nov
 2022 07:08:56 -0800 (PST)
MIME-Version: 1.0
References: <CAMGffEmiu2BPx6=KW+7_+pzD-=hb8sX9r5cJ1_NovmrWG9xFuA@mail.gmail.com>
 <Y0fJ6P943FuVZ3k1@unreal> <CAMGffEmFCgKv-6XNXjAKzr5g6TtT_=wj6H62AdGCUXx4hruxBQ@mail.gmail.com>
 <Y0foGrlwnYX8lJX2@unreal> <CAMGffEnWmVb_qZFq6_rhZGH5q1Wq=n5ciJmp6uxxE6JLctywng@mail.gmail.com>
 <CAMGffEmY6SGPg8KMMFCFKtv4wiF1VOtVnA7JPnXhz5LKrJsiJA@mail.gmail.com>
 <82a62c6c-1616-ebb4-6308-ce56ec176cf3@nvidia.com> <CAMGffEk5=BWNVROHs185WfNH0DRiGpdQnS7aSgD74yjhT803tw@mail.gmail.com>
In-Reply-To: <CAMGffEk5=BWNVROHs185WfNH0DRiGpdQnS7aSgD74yjhT803tw@mail.gmail.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Tue, 15 Nov 2022 16:08:45 +0100
Message-ID: <CAMGffEkaZUDLfXQXK239Nt-DSxqkZpbC=8zUeubv0pxLuoMcZw@mail.gmail.com>
Subject: Re: [BUG] mlx5_core general protection fault in mlx5_cmd_comp_handler
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     Leon Romanovsky <leon@kernel.org>, netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>, Shay Drory <shayd@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 15, 2022 at 6:46 AM Jinpu Wang <jinpu.wang@ionos.com> wrote:
>
> On Tue, Nov 15, 2022 at 6:15 AM Moshe Shemesh <moshe@nvidia.com> wrote:
> >
> >
> > On 11/9/2022 11:51 AM, Jinpu Wang wrote:
> > > On Mon, Oct 17, 2022 at 7:54 AM Jinpu Wang <jinpu.wang@ionos.com> wrote:
> > >> On Thu, Oct 13, 2022 at 12:27 PM Leon Romanovsky <leon@kernel.org> wrote:
> > >>> On Thu, Oct 13, 2022 at 10:32:55AM +0200, Jinpu Wang wrote:
> > >>>> On Thu, Oct 13, 2022 at 10:18 AM Leon Romanovsky <leon@kernel.org> wrote:
> > >>>>> On Wed, Oct 12, 2022 at 01:55:55PM +0200, Jinpu Wang wrote:
> > >>>>>> Hi Leon, hi Saeed,
> > >>>>>>
> > >>>>>> We have seen crashes during server shutdown on both kernel 5.10 and
> > >>>>>> kernel 5.15 with GPF in mlx5 mlx5_cmd_comp_handler function.
> > >>>>>>
> > >>>>>> All of the crashes point to
> > >>>>>>
> > >>>>>> 1606                         memcpy(ent->out->first.data,
> > >>>>>> ent->lay->out, sizeof(ent->lay->out));
> > >>>>>>
> > >>>>>> I guess, it's kind of use after free for ent buffer. I tried to reprod
> > >>>>>> by repeatedly reboot the testing servers, but no success  so far.
> > >>>>> My guess is that command interface is not flushed, but Moshe and me
> > >>>>> didn't see how it can happen.
> > >>>>>
> > >>>>>    1206         INIT_DELAYED_WORK(&ent->cb_timeout_work, cb_timeout_handler);
> > >>>>>    1207         INIT_WORK(&ent->work, cmd_work_handler);
> > >>>>>    1208         if (page_queue) {
> > >>>>>    1209                 cmd_work_handler(&ent->work);
> > >>>>>    1210         } else if (!queue_work(cmd->wq, &ent->work)) {
> > >>>>>                            ^^^^^^^ this is what is causing to the splat
> > >>>>>    1211                 mlx5_core_warn(dev, "failed to queue work\n");
> > >>>>>    1212                 err = -EALREADY;
> > >>>>>    1213                 goto out_free;
> > >>>>>    1214         }
> > >>>>>
> > >>>>> <...>
> > >>>>>> Is this problem known, maybe already fixed?
> > >>>>> I don't see any missing Fixes that exist in 6.0 and don't exist in 5.5.32.
> > >>> Sorry it is 5.15.32
> > >>>
> > >>>>> Is it possible to reproduce this on latest upstream code?
> > >>>> I haven't been able to reproduce it, as mentioned above, I tried to
> > >>>> reproduce by simply reboot in loop, no luck yet.
> > >>>> do you have suggestions to speedup the reproduction?
> > >>> Maybe try to shutdown during filling command interface.
> > >>> I think that any query command will do the trick.
> > >> Just an update.
> > >> I tried to run "saquery" in a loop in one session and do "modproble -r
> > >> mlx5_ib && modprobe mlx5_ib" in loop in another session during last
> > >> days , but still no luck. --c
> > >>>> Once I can reproduce, I can also try with kernel 6.0.
> > >>> It will be great.
> > >>>
> > >>> Thanks
> > >> Thanks!
> > > Just want to mention, we see more crash during reboot, all the crash
> > > we saw are all
> > > Intel  Intel(R) Xeon(R) Gold 6338 CPU. We use the same HCA on
> > > different servers. So I suspect the bug is related to Ice Lake server.
> > >
> > > In case it matters, here is lspci attached.
> >
> >
> > Please try the following change on 5.15.32, let me know if it solves the
> > failure :
>
> Thank you Moshe, I will test it on affected servers and report back the result.
Hi Moshe,

I've been running the reboot tests on 4 affected machines in parallel
for more than 6 hours,  in total did 300+ reboot, I can no longer
reproduce the crash. without the fix, I was able to reproduce 2 times
in 20 reboots.
So I think the bug is fixed.
I also did some basic functional test via RNBD/IPOIB, all look good.
Tested-by: Jack Wang <jinpu.wang@ionos.com>
Please provide a formal fix.

Thx!
> >
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> > b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> > index e06a6104e91f..d45ca9c52a21 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> > @@ -971,6 +971,7 @@ static void cmd_work_handler(struct work_struct *work)
> >                  cmd_ent_get(ent);
> >          set_bit(MLX5_CMD_ENT_STATE_PENDING_COMP, &ent->state);
> >
> > +       cmd_ent_get(ent); /* for the _real_ FW event on completion */
> >          /* Skip sending command to fw if internal error */
> >          if (mlx5_cmd_is_down(dev) || !opcode_allowed(&dev->cmd, ent->op)) {
> >                  u8 status = 0;
> > @@ -984,7 +985,6 @@ static void cmd_work_handler(struct work_struct *work)
> >                  return;
> >          }
> >
> > -       cmd_ent_get(ent); /* for the _real_ FW event on completion */
> >          /* ring doorbell after the descriptor is valid */
> >          mlx5_core_dbg(dev, "writing 0x%x to command doorbell\n", 1 <<
> > ent->idx);
> >          wmb();
> > @@ -1598,8 +1598,8 @@ static void mlx5_cmd_comp_handler(struct
> > mlx5_core_dev *dev, u64 vec, bool force
> >                                  cmd_ent_put(ent); /* timeout work was
> > canceled */
> >
> >                          if (!forced || /* Real FW completion */
> > -                           pci_channel_offline(dev->pdev) || /* FW is
> > inaccessible */
> > -                           dev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
> > +                            mlx5_cmd_is_down(dev) || /* No real FW
> > completion is expected */
> > +                            !opcode_allowed(cmd, ent->op))
> >                                  cmd_ent_put(ent);
> >
> >                          ent->ts2 = ktime_get_ns();
> >
> > > Thx!
