Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40B9650E5C4
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 18:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243604AbiDYQak (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 12:30:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243638AbiDYQad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 12:30:33 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF89E8A325
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 09:26:21 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id e194so16389971iof.11
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 09:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HU3UDCc+mIqj0/fp/LE7q8+k94zCe9E1Hd4WYWfxitY=;
        b=jgVuez9s1TQ+m/thsk1SoF2n6jLIvdnsC+TSdm3h/UY7rFdEYPJpCUNBVO2xL/L8jG
         aB7dtnOWSlvzIAOeliZvm4CWNAi6M63Vf9FjYAtC07CvNJ1CgJbByEgsttFCt4oufUTR
         CSQaLZMqVA9o2+L7pmQW/PpRncduTaBQ5lGRc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HU3UDCc+mIqj0/fp/LE7q8+k94zCe9E1Hd4WYWfxitY=;
        b=Z8ZwFC0YBLpk46fA9jI6vGy2GzDEv2TNIJxCy8aItVYTdd9XJ94Wl0dDupZMzSSU5Y
         viaJRMCDWsqYQ5YYGG1gznkG+6zktSnNsFedM5/dec6JB7n2ICzb7N09/VJPGao9JW0B
         cQiSpZDIT3z+m2SCNEsqpqYZmJwmGwhPUsw3EVeDOdQdVULAsKwGl9DF2yhT5xQy9bKB
         wCetx4Pw5ipTSLRv0n/uS5KajQ6tMRSpn8uiGFjOoX0tEukNkcjrG0F5tJnaXUwkk7+T
         bq/3BWlTVYh4AuAqgUv9xc4/4//f9JPTOjTvPyKZCvxtLdN1d9XBNeXVi4N36F1cZOiW
         PNnw==
X-Gm-Message-State: AOAM5308zPMHYFNc4jKkZjxGwNP0/LavOZSmo7r1EkSID+9GLIQ7iSb9
        RElBb1AmjNf+CBFmScOluhYuwiOxjgVyzi2DTNKx8w==
X-Google-Smtp-Source: ABdhPJwXZUZ5zyqAqVlx/rPhR9eSgerc+CnpehGwUvzudCRMcUQFGT1nRMwSQGb1+5GWDsBJTK8fhG1CWTqwn2ATAYU=
X-Received: by 2002:a05:6638:617:b0:32a:de4f:7772 with SMTP id
 g23-20020a056638061700b0032ade4f7772mr4070395jar.155.1650903981260; Mon, 25
 Apr 2022 09:26:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220425021442.1.I650b809482e1af8d0156ed88b5dc2677a0711d46@changeid>
 <87czh5k7ua.fsf@kernel.org>
In-Reply-To: <87czh5k7ua.fsf@kernel.org>
From:   Abhishek Kumar <kuabhs@chromium.org>
Date:   Mon, 25 Apr 2022 09:26:09 -0700
Message-ID: <CACTWRwvqtDW_91-JGvH4bNRRo4EqEZZQCJHy7ms0QNwrz=f-oA@mail.gmail.com>
Subject: Re: [PATCH] ath10k: skip ath10k_halt during suspend for driver state RESTARTING
To:     Kalle Valo <kvalo@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        briannorris@chromium.org, ath10k@lists.infradead.org,
        netdev@vger.kernel.org, Wen Gong <quic_wgong@quicinc.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Kalle for having a look and adding this on behalf of me.
Here is the Tested-on tag,
Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00288-QCARMSWPZ-1

Thanks
Abhishek

On Sun, Apr 24, 2022 at 11:14 PM Kalle Valo <kvalo@kernel.org> wrote:
>
> Abhishek Kumar <kuabhs@chromium.org> writes:
>
> > Double free crash is observed when FW recovery(caused by wmi
> > timeout/crash) is followed by immediate suspend event. The FW recovery
> > is triggered by ath10k_core_restart() which calls driver clean up via
> > ath10k_halt(). When the suspend event occurs between the FW recovery,
> > the restart worker thread is put into frozen state until suspend completes.
> > The suspend event triggers ath10k_stop() which again triggers ath10k_halt()
> > The double invocation of ath10k_halt() causes ath10k_htt_rx_free() to be
> > called twice(Note: ath10k_htt_rx_alloc was not called by restart worker
> > thread because of its frozen state), causing the crash.
> >
> > To fix this, during the suspend flow, skip call to ath10k_halt() in
> > ath10k_stop() when the current driver state is ATH10K_STATE_RESTARTING.
> > Also, for driver state ATH10K_STATE_RESTARTING, call
> > ath10k_wait_for_suspend() in ath10k_stop(). This is because call to
> > ath10k_wait_for_suspend() is skipped later in
> > [ath10k_halt() > ath10k_core_stop()] for the driver state
> > ATH10K_STATE_RESTARTING.
> >
> > The frozen restart worker thread will be cancelled during resume when the
> > device comes out of suspend.
> >
> > Below is the crash stack for reference:
> >
> > [  428.469167] ------------[ cut here ]------------
> > [  428.469180] kernel BUG at mm/slub.c:4150!
> > [  428.469193] invalid opcode: 0000 [#1] PREEMPT SMP NOPTI
> > [  428.469219] Workqueue: events_unbound async_run_entry_fn
> > [  428.469230] RIP: 0010:kfree+0x319/0x31b
> > [  428.469241] RSP: 0018:ffffa1fac015fc30 EFLAGS: 00010246
> > [  428.469247] RAX: ffffedb10419d108 RBX: ffff8c05262b0000
> > [  428.469252] RDX: ffff8c04a8c07000 RSI: 0000000000000000
> > [  428.469256] RBP: ffffa1fac015fc78 R08: 0000000000000000
> > [  428.469276] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [  428.469285] Call Trace:
> > [  428.469295]  ? dma_free_attrs+0x5f/0x7d
> > [  428.469320]  ath10k_core_stop+0x5b/0x6f
> > [  428.469336]  ath10k_halt+0x126/0x177
> > [  428.469352]  ath10k_stop+0x41/0x7e
> > [  428.469387]  drv_stop+0x88/0x10e
> > [  428.469410]  __ieee80211_suspend+0x297/0x411
> > [  428.469441]  rdev_suspend+0x6e/0xd0
> > [  428.469462]  wiphy_suspend+0xb1/0x105
> > [  428.469483]  ? name_show+0x2d/0x2d
> > [  428.469490]  dpm_run_callback+0x8c/0x126
> > [  428.469511]  ? name_show+0x2d/0x2d
> > [  428.469517]  __device_suspend+0x2e7/0x41b
> > [  428.469523]  async_suspend+0x1f/0x93
> > [  428.469529]  async_run_entry_fn+0x3d/0xd1
> > [  428.469535]  process_one_work+0x1b1/0x329
> > [  428.469541]  worker_thread+0x213/0x372
> > [  428.469547]  kthread+0x150/0x15f
> > [  428.469552]  ? pr_cont_work+0x58/0x58
> > [  428.469558]  ? kthread_blkcg+0x31/0x31
> >
> > Signed-off-by: Abhishek Kumar <kuabhs@chromium.org>
> > Co-developed-by: Wen Gong <quic_wgong@quicinc.com>
> > Signed-off-by: Wen Gong <quic_wgong@quicinc.com>
>
> Tested-on tag missing, but I can add it if you provide it.
>
> https://wireless.wiki.kernel.org/en/users/drivers/ath10k/submittingpatches#tested-on_tag
>
> --
> https://patchwork.kernel.org/project/linux-wireless/list/
>
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
