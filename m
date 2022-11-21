Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2701631C8C
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 10:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbiKUJLm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 04:11:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbiKUJLk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 04:11:40 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D356167C6
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 01:11:39 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id k19so13811270lji.2
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 01:11:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TBqHLFX6njp5xQIYaT1aXOK/XEWwB7WcZYV3wFuiEmE=;
        b=dYBSRLy6D2Tn32sIw6dTTu6d9402EYzy9u1ZjuxrP8lQB/6ighZah4JXw8EEP12YgA
         zK0/zQ3mUoH/+qKU7t3TI/kQ6ZBMPP5nSvn3EGIQPlsA5pVwUi19y3/tt+cRoyiJxMFB
         0qZlFv8NsFBMyonyN0MK48tTJOAgbQsGZzbi8z0yC5NaKdT2pBmNQjupFP0/VUFF8hUJ
         fRloI4TqXT86DmwImBQrpISt8HibHsqfMb7VgjxiGxh7l6IDjO5OYvuDb9tzlXsu8VQi
         KGPQksE2QVj4KiQQJ7M+2v2YJKrnsoKtFHwjKwFRDvlJ7B2aqaQ7bOZvXvv/wAmLSCJt
         EFhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TBqHLFX6njp5xQIYaT1aXOK/XEWwB7WcZYV3wFuiEmE=;
        b=o2afgGM766R7h/ucCl1pEp02lIG3BHZlMAoP3Dt+bKLC7tV4gtO6fVKX00TNQHwUju
         cmW/vkvh7mkY/0pJWjuIbILqxO/qVTuf4blk+74IYXUFOCOpkivOh67Zm0OSurRb3h7f
         bIoYHwVT6c1sIFmbqlIFL/zTXwqchJLhzRMxGHStoOV20No3BUmGREPXUuwGL0Oa+GgY
         v+RtXX0DV8yYpPJtzVZOPmGYjQuP2PLQuBLtLNZq7E8nBgllxkkU+3grEjmXC8EnnA62
         EtNIvcyU4rFjT+z7kTiwYwd+J44j10Zt/MF3E8Jdn1T4XRblM7USCH8fhLaehTAbZSUN
         eCGg==
X-Gm-Message-State: ANoB5pkjhmv+BMRn+XFucIrNNFjjyIUzgjSfw7dH0TWg4oOs2QQpC3P3
        M/GdbayKIiDF+QaZsWnUTEA5sr5+/M5jbazs/Isetd8X3qU=
X-Google-Smtp-Source: AA0mqf5W1MYzq8quFPlfN0qnjh4UMs6hZRDX2ESdkhI7m0uaf90C+HxQ52M72bDtsSZXsAAFp1Ifv9XbMNdlH4WUmZE=
X-Received: by 2002:a2e:bcc5:0:b0:279:3851:1420 with SMTP id
 z5-20020a2ebcc5000000b0027938511420mr3355637ljp.265.1669021897741; Mon, 21
 Nov 2022 01:11:37 -0800 (PST)
MIME-Version: 1.0
References: <CAMGffEmiu2BPx6=KW+7_+pzD-=hb8sX9r5cJ1_NovmrWG9xFuA@mail.gmail.com>
 <Y0fJ6P943FuVZ3k1@unreal> <CAMGffEmFCgKv-6XNXjAKzr5g6TtT_=wj6H62AdGCUXx4hruxBQ@mail.gmail.com>
 <Y0foGrlwnYX8lJX2@unreal> <CAMGffEnWmVb_qZFq6_rhZGH5q1Wq=n5ciJmp6uxxE6JLctywng@mail.gmail.com>
 <CAMGffEmY6SGPg8KMMFCFKtv4wiF1VOtVnA7JPnXhz5LKrJsiJA@mail.gmail.com>
 <82a62c6c-1616-ebb4-6308-ce56ec176cf3@nvidia.com> <CAMGffEk5=BWNVROHs185WfNH0DRiGpdQnS7aSgD74yjhT803tw@mail.gmail.com>
 <CAMGffEkaZUDLfXQXK239Nt-DSxqkZpbC=8zUeubv0pxLuoMcZw@mail.gmail.com> <54c10b62-5d53-a3a5-48bb-74552e976067@nvidia.com>
In-Reply-To: <54c10b62-5d53-a3a5-48bb-74552e976067@nvidia.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Mon, 21 Nov 2022 10:11:26 +0100
Message-ID: <CAMGffEk8_1AYbfcamfn9BCxDCvOaTm1ndNsVYsn+hz3GRH9B6w@mail.gmail.com>
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

On Tue, Nov 15, 2022 at 5:41 PM Moshe Shemesh <moshe@nvidia.com> wrote:
>
>
> On 11/15/2022 5:08 PM, Jinpu Wang wrote:
> > On Tue, Nov 15, 2022 at 6:46 AM Jinpu Wang <jinpu.wang@ionos.com> wrote:
> >> On Tue, Nov 15, 2022 at 6:15 AM Moshe Shemesh <moshe@nvidia.com> wrote:
> >>>
> >>> On 11/9/2022 11:51 AM, Jinpu Wang wrote:
> >>>> On Mon, Oct 17, 2022 at 7:54 AM Jinpu Wang <jinpu.wang@ionos.com> wrote:
> >>>>> On Thu, Oct 13, 2022 at 12:27 PM Leon Romanovsky <leon@kernel.org> wrote:
> >>>>>> On Thu, Oct 13, 2022 at 10:32:55AM +0200, Jinpu Wang wrote:
> >>>>>>> On Thu, Oct 13, 2022 at 10:18 AM Leon Romanovsky <leon@kernel.org> wrote:
> >>>>>>>> On Wed, Oct 12, 2022 at 01:55:55PM +0200, Jinpu Wang wrote:
> >>>>>>>>> Hi Leon, hi Saeed,
> >>>>>>>>>
> >>>>>>>>> We have seen crashes during server shutdown on both kernel 5.10 and
> >>>>>>>>> kernel 5.15 with GPF in mlx5 mlx5_cmd_comp_handler function.
> >>>>>>>>>
> >>>>>>>>> All of the crashes point to
> >>>>>>>>>
> >>>>>>>>> 1606                         memcpy(ent->out->first.data,
> >>>>>>>>> ent->lay->out, sizeof(ent->lay->out));
> >>>>>>>>>
> >>>>>>>>> I guess, it's kind of use after free for ent buffer. I tried to reprod
> >>>>>>>>> by repeatedly reboot the testing servers, but no success  so far.
> >>>>>>>> My guess is that command interface is not flushed, but Moshe and me
> >>>>>>>> didn't see how it can happen.
> >>>>>>>>
> >>>>>>>>     1206         INIT_DELAYED_WORK(&ent->cb_timeout_work, cb_timeout_handler);
> >>>>>>>>     1207         INIT_WORK(&ent->work, cmd_work_handler);
> >>>>>>>>     1208         if (page_queue) {
> >>>>>>>>     1209                 cmd_work_handler(&ent->work);
> >>>>>>>>     1210         } else if (!queue_work(cmd->wq, &ent->work)) {
> >>>>>>>>                             ^^^^^^^ this is what is causing to the splat
> >>>>>>>>     1211                 mlx5_core_warn(dev, "failed to queue work\n");
> >>>>>>>>     1212                 err = -EALREADY;
> >>>>>>>>     1213                 goto out_free;
> >>>>>>>>     1214         }
> >>>>>>>>
> >>>>>>>> <...>
> >>>>>>>>> Is this problem known, maybe already fixed?
> >>>>>>>> I don't see any missing Fixes that exist in 6.0 and don't exist in 5.5.32.
> >>>>>> Sorry it is 5.15.32
> >>>>>>
> >>>>>>>> Is it possible to reproduce this on latest upstream code?
> >>>>>>> I haven't been able to reproduce it, as mentioned above, I tried to
> >>>>>>> reproduce by simply reboot in loop, no luck yet.
> >>>>>>> do you have suggestions to speedup the reproduction?
> >>>>>> Maybe try to shutdown during filling command interface.
> >>>>>> I think that any query command will do the trick.
> >>>>> Just an update.
> >>>>> I tried to run "saquery" in a loop in one session and do "modproble -r
> >>>>> mlx5_ib && modprobe mlx5_ib" in loop in another session during last
> >>>>> days , but still no luck. --c
> >>>>>>> Once I can reproduce, I can also try with kernel 6.0.
> >>>>>> It will be great.
> >>>>>>
> >>>>>> Thanks
> >>>>> Thanks!
> >>>> Just want to mention, we see more crash during reboot, all the crash
> >>>> we saw are all
> >>>> Intel  Intel(R) Xeon(R) Gold 6338 CPU. We use the same HCA on
> >>>> different servers. So I suspect the bug is related to Ice Lake server.
> >>>>
> >>>> In case it matters, here is lspci attached.
> >>>
> >>> Please try the following change on 5.15.32, let me know if it solves the
> >>> failure :
> >> Thank you Moshe, I will test it on affected servers and report back the result.
> > Hi Moshe,
> >
> > I've been running the reboot tests on 4 affected machines in parallel
> > for more than 6 hours,  in total did 300+ reboot, I can no longer
> > reproduce the crash. without the fix, I was able to reproduce 2 times
> > in 20 reboots.
> > So I think the bug is fixed.
>
>
> Great !
>
> > I also did some basic functional test via RNBD/IPOIB, all look good.
> > Tested-by: Jack Wang <jinpu.wang@ionos.com>
> > Please provide a formal fix.
>
>
> Will do.
Hi Moshe,
A gentle ping, when will you send the fix?

Thanks!

>
> Thanks!
>
> >
> > Thx!
> >>> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> >>> b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> >>> index e06a6104e91f..d45ca9c52a21 100644
> >>> --- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> >>> +++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> >>> @@ -971,6 +971,7 @@ static void cmd_work_handler(struct work_struct *work)
> >>>                   cmd_ent_get(ent);
> >>>           set_bit(MLX5_CMD_ENT_STATE_PENDING_COMP, &ent->state);
> >>>
> >>> +       cmd_ent_get(ent); /* for the _real_ FW event on completion */
> >>>           /* Skip sending command to fw if internal error */
> >>>           if (mlx5_cmd_is_down(dev) || !opcode_allowed(&dev->cmd, ent->op)) {
> >>>                   u8 status = 0;
> >>> @@ -984,7 +985,6 @@ static void cmd_work_handler(struct work_struct *work)
> >>>                   return;
> >>>           }
> >>>
> >>> -       cmd_ent_get(ent); /* for the _real_ FW event on completion */
> >>>           /* ring doorbell after the descriptor is valid */
> >>>           mlx5_core_dbg(dev, "writing 0x%x to command doorbell\n", 1 <<
> >>> ent->idx);
> >>>           wmb();
> >>> @@ -1598,8 +1598,8 @@ static void mlx5_cmd_comp_handler(struct
> >>> mlx5_core_dev *dev, u64 vec, bool force
> >>>                                   cmd_ent_put(ent); /* timeout work was
> >>> canceled */
> >>>
> >>>                           if (!forced || /* Real FW completion */
> >>> -                           pci_channel_offline(dev->pdev) || /* FW is
> >>> inaccessible */
> >>> -                           dev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
> >>> +                            mlx5_cmd_is_down(dev) || /* No real FW
> >>> completion is expected */
> >>> +                            !opcode_allowed(cmd, ent->op))
> >>>                                   cmd_ent_put(ent);
> >>>
> >>>                           ent->ts2 = ktime_get_ns();
> >>>
> >>>> Thx!
