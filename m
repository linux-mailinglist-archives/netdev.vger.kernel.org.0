Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 725E56291A4
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 06:46:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbiKOFqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 00:46:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230199AbiKOFqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 00:46:48 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B71AE5A
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 21:46:46 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id b9so16164020ljr.5
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 21:46:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OKar4tQ/9UML+jEyYZ0Rf7DUkg+/1BGj6frRwD9ZtKw=;
        b=G7wHExlxJTVBNLeASqeutzBAAyE4wZ7kIHmrHCdtVxCcEhzqMRlLVhml0YCGbP2HE1
         i0vXIunLUatXL9AS2lQfH3++KIh1+AWNi/qOoa7tP65vZVXs2H3B7DYRKj0eaxCHvIi5
         /Of9r2cZ8cKzt5oYmvbA1wV/o7WMlXCg6Lmx+Dmp2/sfoTNV5cATqe43F3h5lptpODrx
         wUA5QL57fabs14rMhXkaq7at8AsBchtmNn2VPnxv9Pt5gJ5XfL3COK2GuqkoRr4dRNvS
         yDzpk1ouYDuLSZKO30B8X8woUsfNLrejriPo2IONubsn6jF1hyI2bePd9CSA+mGiEMmE
         DQfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OKar4tQ/9UML+jEyYZ0Rf7DUkg+/1BGj6frRwD9ZtKw=;
        b=nmhOHYJMztNsP1iiFzOamQXvtLyK8BklxKfjsZ9lh2re4B0+J9CD9j1KQ8bhZwi/b9
         KbYgg9qwWmnGW/ZZyP80H9BKptHYzS3OQBZFy8Wap2ZUwiqvk7mwySpb0HNu7Vvzk7hY
         PiI3bfaqWcKhFfHOOB4eCgphgqXU33oHHjS2Hi0/Ok842dMO51c8nEQhrNcIoTJXF0cq
         737Q6ydBWLYZ3sBIusmRzGRiFJgzkBo62m63cudtYDjybtGCmwfNsZirl+vnQDzQjbmn
         CyL2Wh4J2ToZ5IbMNVjvsPhV/xkuYlk4EqJa9NJgm8BZswS7TxhW3A3Wv3t3NCP6s72F
         mkkw==
X-Gm-Message-State: ANoB5pnz8jpjzGwWA2cw5XmLepsgQtuDwWqfT0SXCbdyHLdhr8Ed386Y
        OZZIuD19w6a7OzDG4AOOUn7R5MxxrmwMKYzcSzgYnw==
X-Google-Smtp-Source: AA0mqf5V7vNHLXyHY12HR7v1WHFCeOkNU5zT9cOOLFzB1VLZs9QFb8FtIzNddUiAY99lIwvaYmG/wIIb+5O3o4nFEuo=
X-Received: by 2002:a05:651c:8b:b0:26d:d196:d04 with SMTP id
 11-20020a05651c008b00b0026dd1960d04mr5484026ljq.403.1668491205128; Mon, 14
 Nov 2022 21:46:45 -0800 (PST)
MIME-Version: 1.0
References: <CAMGffEmiu2BPx6=KW+7_+pzD-=hb8sX9r5cJ1_NovmrWG9xFuA@mail.gmail.com>
 <Y0fJ6P943FuVZ3k1@unreal> <CAMGffEmFCgKv-6XNXjAKzr5g6TtT_=wj6H62AdGCUXx4hruxBQ@mail.gmail.com>
 <Y0foGrlwnYX8lJX2@unreal> <CAMGffEnWmVb_qZFq6_rhZGH5q1Wq=n5ciJmp6uxxE6JLctywng@mail.gmail.com>
 <CAMGffEmY6SGPg8KMMFCFKtv4wiF1VOtVnA7JPnXhz5LKrJsiJA@mail.gmail.com> <82a62c6c-1616-ebb4-6308-ce56ec176cf3@nvidia.com>
In-Reply-To: <82a62c6c-1616-ebb4-6308-ce56ec176cf3@nvidia.com>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Tue, 15 Nov 2022 06:46:34 +0100
Message-ID: <CAMGffEk5=BWNVROHs185WfNH0DRiGpdQnS7aSgD74yjhT803tw@mail.gmail.com>
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

On Tue, Nov 15, 2022 at 6:15 AM Moshe Shemesh <moshe@nvidia.com> wrote:
>
>
> On 11/9/2022 11:51 AM, Jinpu Wang wrote:
> > On Mon, Oct 17, 2022 at 7:54 AM Jinpu Wang <jinpu.wang@ionos.com> wrote:
> >> On Thu, Oct 13, 2022 at 12:27 PM Leon Romanovsky <leon@kernel.org> wrote:
> >>> On Thu, Oct 13, 2022 at 10:32:55AM +0200, Jinpu Wang wrote:
> >>>> On Thu, Oct 13, 2022 at 10:18 AM Leon Romanovsky <leon@kernel.org> wrote:
> >>>>> On Wed, Oct 12, 2022 at 01:55:55PM +0200, Jinpu Wang wrote:
> >>>>>> Hi Leon, hi Saeed,
> >>>>>>
> >>>>>> We have seen crashes during server shutdown on both kernel 5.10 and
> >>>>>> kernel 5.15 with GPF in mlx5 mlx5_cmd_comp_handler function.
> >>>>>>
> >>>>>> All of the crashes point to
> >>>>>>
> >>>>>> 1606                         memcpy(ent->out->first.data,
> >>>>>> ent->lay->out, sizeof(ent->lay->out));
> >>>>>>
> >>>>>> I guess, it's kind of use after free for ent buffer. I tried to reprod
> >>>>>> by repeatedly reboot the testing servers, but no success  so far.
> >>>>> My guess is that command interface is not flushed, but Moshe and me
> >>>>> didn't see how it can happen.
> >>>>>
> >>>>>    1206         INIT_DELAYED_WORK(&ent->cb_timeout_work, cb_timeout_handler);
> >>>>>    1207         INIT_WORK(&ent->work, cmd_work_handler);
> >>>>>    1208         if (page_queue) {
> >>>>>    1209                 cmd_work_handler(&ent->work);
> >>>>>    1210         } else if (!queue_work(cmd->wq, &ent->work)) {
> >>>>>                            ^^^^^^^ this is what is causing to the splat
> >>>>>    1211                 mlx5_core_warn(dev, "failed to queue work\n");
> >>>>>    1212                 err = -EALREADY;
> >>>>>    1213                 goto out_free;
> >>>>>    1214         }
> >>>>>
> >>>>> <...>
> >>>>>> Is this problem known, maybe already fixed?
> >>>>> I don't see any missing Fixes that exist in 6.0 and don't exist in 5.5.32.
> >>> Sorry it is 5.15.32
> >>>
> >>>>> Is it possible to reproduce this on latest upstream code?
> >>>> I haven't been able to reproduce it, as mentioned above, I tried to
> >>>> reproduce by simply reboot in loop, no luck yet.
> >>>> do you have suggestions to speedup the reproduction?
> >>> Maybe try to shutdown during filling command interface.
> >>> I think that any query command will do the trick.
> >> Just an update.
> >> I tried to run "saquery" in a loop in one session and do "modproble -r
> >> mlx5_ib && modprobe mlx5_ib" in loop in another session during last
> >> days , but still no luck. --c
> >>>> Once I can reproduce, I can also try with kernel 6.0.
> >>> It will be great.
> >>>
> >>> Thanks
> >> Thanks!
> > Just want to mention, we see more crash during reboot, all the crash
> > we saw are all
> > Intel  Intel(R) Xeon(R) Gold 6338 CPU. We use the same HCA on
> > different servers. So I suspect the bug is related to Ice Lake server.
> >
> > In case it matters, here is lspci attached.
>
>
> Please try the following change on 5.15.32, let me know if it solves the
> failure :

Thank you Moshe, I will test it on affected servers and report back the result.
>
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> index e06a6104e91f..d45ca9c52a21 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
> @@ -971,6 +971,7 @@ static void cmd_work_handler(struct work_struct *work)
>                  cmd_ent_get(ent);
>          set_bit(MLX5_CMD_ENT_STATE_PENDING_COMP, &ent->state);
>
> +       cmd_ent_get(ent); /* for the _real_ FW event on completion */
>          /* Skip sending command to fw if internal error */
>          if (mlx5_cmd_is_down(dev) || !opcode_allowed(&dev->cmd, ent->op)) {
>                  u8 status = 0;
> @@ -984,7 +985,6 @@ static void cmd_work_handler(struct work_struct *work)
>                  return;
>          }
>
> -       cmd_ent_get(ent); /* for the _real_ FW event on completion */
>          /* ring doorbell after the descriptor is valid */
>          mlx5_core_dbg(dev, "writing 0x%x to command doorbell\n", 1 <<
> ent->idx);
>          wmb();
> @@ -1598,8 +1598,8 @@ static void mlx5_cmd_comp_handler(struct
> mlx5_core_dev *dev, u64 vec, bool force
>                                  cmd_ent_put(ent); /* timeout work was
> canceled */
>
>                          if (!forced || /* Real FW completion */
> -                           pci_channel_offline(dev->pdev) || /* FW is
> inaccessible */
> -                           dev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
> +                            mlx5_cmd_is_down(dev) || /* No real FW
> completion is expected */
> +                            !opcode_allowed(cmd, ent->op))
>                                  cmd_ent_put(ent);
>
>                          ent->ts2 = ktime_get_ns();
>
> > Thx!
