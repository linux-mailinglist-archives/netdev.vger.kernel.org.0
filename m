Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B77F5600676
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 07:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbiJQFzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 01:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229975AbiJQFzC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 01:55:02 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF472CDEF
        for <netdev@vger.kernel.org>; Sun, 16 Oct 2022 22:54:59 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id m23so12691182lji.2
        for <netdev@vger.kernel.org>; Sun, 16 Oct 2022 22:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=62S+L9lvQ6yKl9SFK5Ea6OjGhcrckPawD24jzjiDOjs=;
        b=OwZbd1yKCFh9k8IYIsapUj3IinbahiX9SIQYMhZYY8VwAlZQ6XTtka33WwTZOeAAOb
         UDswZXgISy65AzHw+WuwVW7/SQyVl+iVC5bfFD+vraf+gkpnRmo64XOdyeETunRU+R7/
         TJpyXy4VfvZAMm/tRiXFwRXdj4SfzYpY/YIw/srsDlmblULd+j9o7s8sY3/j6l2/u3nq
         aSHhfXqZ1eXcl4PRNRsqxvBcZBdi6j6mZs9sCfLR9llXt/HyHadvs83JLiyZSEI/0h3+
         XY/sBbX8Ayb5/hOzADY+cQik1ChbjLgA+zFV6FL8wOIgH0dc3IIRxS52hzmeRKCkyarK
         D78w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=62S+L9lvQ6yKl9SFK5Ea6OjGhcrckPawD24jzjiDOjs=;
        b=euZU40ND8OXzObuVZaZukzgdHc9RbptTypgP69DBkTtv7fkHCvAcW8jEO2YRforuhZ
         xOC1J9dRsB+SL9zRx1pV2lflhRXls6T4HL3YgwppzZfbzFHZvW+9h7zpeRO0XBUEVOEy
         4qun5fGblCmzQrS4YTUSNfuO3SA1uL6qPu3THtQ+M2uo5sv77reDEcw1rZBGkYusYolj
         kUc5W9bSS97GAUySca/BO6CoE0MHRWDxKCfqwoDQkHF6+gyrCAgx+yuTL/BWhMEyUutw
         bQvVI0+O8QqNK/1ZGFiCX7cIQpwBaaP5jA11tBB8DSdSUyagDAnUfBxpj6Ds1OOJAhsj
         YP+Q==
X-Gm-Message-State: ACrzQf2qt8mFgf6vQjvCgscVSvrnHw06+Umchb4DQq/R2VgRiWH9JtxW
        qRq0Lbmo5A1jLiYPpG48SfBzxPcAUrn2i35K9KlaXg==
X-Google-Smtp-Source: AMsMyM7HpLYx29Z7vacvnTaKV70hInyG36tLoG44GGNdnQ4/Yz8uOVgot2S8hCombJq50nEJWXSwDM6dgR4pU+f1dzo=
X-Received: by 2002:a2e:844e:0:b0:26b:f5ee:b2bb with SMTP id
 u14-20020a2e844e000000b0026bf5eeb2bbmr3554425ljh.403.1665986097966; Sun, 16
 Oct 2022 22:54:57 -0700 (PDT)
MIME-Version: 1.0
References: <CAMGffEmiu2BPx6=KW+7_+pzD-=hb8sX9r5cJ1_NovmrWG9xFuA@mail.gmail.com>
 <Y0fJ6P943FuVZ3k1@unreal> <CAMGffEmFCgKv-6XNXjAKzr5g6TtT_=wj6H62AdGCUXx4hruxBQ@mail.gmail.com>
 <Y0foGrlwnYX8lJX2@unreal>
In-Reply-To: <Y0foGrlwnYX8lJX2@unreal>
From:   Jinpu Wang <jinpu.wang@ionos.com>
Date:   Mon, 17 Oct 2022 07:54:46 +0200
Message-ID: <CAMGffEnWmVb_qZFq6_rhZGH5q1Wq=n5ciJmp6uxxE6JLctywng@mail.gmail.com>
Subject: Re: [BUG] mlx5_core general protection fault in mlx5_cmd_comp_handler
To:     Leon Romanovsky <leon@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Moshe Shemesh <moshe@nvidia.com>,
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

On Thu, Oct 13, 2022 at 12:27 PM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Thu, Oct 13, 2022 at 10:32:55AM +0200, Jinpu Wang wrote:
> > On Thu, Oct 13, 2022 at 10:18 AM Leon Romanovsky <leon@kernel.org> wrote:
> > >
> > > On Wed, Oct 12, 2022 at 01:55:55PM +0200, Jinpu Wang wrote:
> > > > Hi Leon, hi Saeed,
> > > >
> > > > We have seen crashes during server shutdown on both kernel 5.10 and
> > > > kernel 5.15 with GPF in mlx5 mlx5_cmd_comp_handler function.
> > > >
> > > > All of the crashes point to
> > > >
> > > > 1606                         memcpy(ent->out->first.data,
> > > > ent->lay->out, sizeof(ent->lay->out));
> > > >
> > > > I guess, it's kind of use after free for ent buffer. I tried to reprod
> > > > by repeatedly reboot the testing servers, but no success  so far.
> > >
> > > My guess is that command interface is not flushed, but Moshe and me
> > > didn't see how it can happen.
> > >
> > >   1206         INIT_DELAYED_WORK(&ent->cb_timeout_work, cb_timeout_handler);
> > >   1207         INIT_WORK(&ent->work, cmd_work_handler);
> > >   1208         if (page_queue) {
> > >   1209                 cmd_work_handler(&ent->work);
> > >   1210         } else if (!queue_work(cmd->wq, &ent->work)) {
> > >                           ^^^^^^^ this is what is causing to the splat
> > >   1211                 mlx5_core_warn(dev, "failed to queue work\n");
> > >   1212                 err = -EALREADY;
> > >   1213                 goto out_free;
> > >   1214         }
> > >
> > > <...>
> > > >
> > > > Is this problem known, maybe already fixed?
> > >
> > > I don't see any missing Fixes that exist in 6.0 and don't exist in 5.5.32.
>
> Sorry it is 5.15.32
>
> > > Is it possible to reproduce this on latest upstream code?
> > I haven't been able to reproduce it, as mentioned above, I tried to
> > reproduce by simply reboot in loop, no luck yet.
> > do you have suggestions to speedup the reproduction?
>
> Maybe try to shutdown during filling command interface.
> I think that any query command will do the trick.
Just an update.
I tried to run "saquery" in a loop in one session and do "modproble -r
mlx5_ib && modprobe mlx5_ib" in loop in another session during last
days , but still no luck. --c
>
> > Once I can reproduce, I can also try with kernel 6.0.
>
> It will be great.
>
> Thanks
Thanks!
