Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 415B02DA268
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 22:13:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503538AbgLNVNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 16:13:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728716AbgLNVNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 16:13:32 -0500
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A94E1C0613D6
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 13:12:52 -0800 (PST)
Received: by mail-yb1-xb41.google.com with SMTP id w135so16822628ybg.13
        for <netdev@vger.kernel.org>; Mon, 14 Dec 2020 13:12:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4GuvCb9wffjGG+izHKz4P5jrM9DvLexpcqH55zvMG+s=;
        b=Zq3rXgvB1mvv5F/R4fqK9MADbv/dfp3qRBPEXwMi+XUf8b5XecEEz4Gx9PSyyZo1Fp
         J6OFDjfuzEtUgb/GvjxUImf04K9M04jMKEUbSZDPU2kZR9HWMZfSzLLVAwei3mZYM1v/
         atVQ85NbCSeIC6BBGBUQaugkxrqfaOrgDbs0TLbRx8CHMIVzKyV7x12pnwecxCR7swrH
         u21h6NwQwXYbXzIs3y8SECB6dtdB2B9dnSDMgnk7PSluT4PrPDdslxBsNsOgWAogRR6f
         eqYkRi+79rotz664V2FQnyU1SRTZQGvYbPqaJnVy+VEt6B+FvFWZgREdJQiAufUcP206
         APVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4GuvCb9wffjGG+izHKz4P5jrM9DvLexpcqH55zvMG+s=;
        b=V6TVlv9vBze7MEWxLgpgQFmVQUgO6iqPzcqHEC/XEFuZeN21s+iIxljA8EJE49J0Zd
         kFyCzGKywsUEnTV5F6UvlrrrdAicn2ROOA++ejHn0k4rc0xqdKaXROzKlm9wELmvbOKt
         P+YHJKkluqGSPHz3/VmtSllcQmzcLswCH/vHi2XF8PUeURZVT9v39hW24LI7Zwt/mAjU
         BkKCxAXWEN2T12CukI06gRulHT8s9vxQvgUBTRfyLE7t90QPDJWYEXQ7M9NZvdsEO+Ih
         6ZCJdh5ULTgrZgL0aLeD8Sa//6UrkkKpyrz4XO/bq2eSeTBnrtOZqXD9kUhNnVisaIjc
         vgnw==
X-Gm-Message-State: AOAM5310wzBD2/4XWcWnN+uLkt285zsnLlu1lF1/NjUc/39e6c3UYLy/
        kKjfH4STXzUsMX1vG+s4KIxQO0UlC6vt8Jb1mLiKlA==
X-Google-Smtp-Source: ABdhPJwQZlJxjCT8Iu0eQy3qMSXnhmToAokZUSTI4Oxqj9BrEPxf0BLY9nNlE6r7ELtXiErlMgiNUkR2Wno/Sw9sG3Y=
X-Received: by 2002:a25:99c6:: with SMTP id q6mr39523972ybo.408.1607980371714;
 Mon, 14 Dec 2020 13:12:51 -0800 (PST)
MIME-Version: 1.0
References: <20201209005444.1949356-1-weiwan@google.com> <20201209005444.1949356-3-weiwan@google.com>
 <20201212145022.6f2698d3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201212145503.285a8bfb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAEA6p_BM_H=2bhYBtJ3LtBT0DBPBeVLyuC=BRQv=H3Ww2eecWA@mail.gmail.com>
 <20201214110203.7a1e8729@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAEA6p_CqD5kfPxXkMrNNh9TozfCCTdovMgjiS2Abf_KXxAJONA@mail.gmail.com> <20201214123305.288f49bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201214123305.288f49bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Wei Wang <weiwan@google.com>
Date:   Mon, 14 Dec 2020 13:12:41 -0800
Message-ID: <CAEA6p_CD2E1owsgS9qEtrgYRWxNP8bczMNWAOKPj_JvqYc1ZOw@mail.gmail.com>
Subject: Re: [PATCH net-next v4 2/3] net: implement threaded-able napi poll
 loop support
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Eric Dumazet <edumazet@google.com>,
        Felix Fietkau <nbd@nbd.name>, Hillf Danton <hdanton@sina.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 14, 2020 at 12:33 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 14 Dec 2020 11:45:43 -0800 Wei Wang wrote:
> > > It is quite an annoying problem to address, given all relevant NAPI
> > > helpers seem to return void :/ But we're pushing the problem onto the
> > > user just because of internal API structure.
> > >
> > > This reminds me of PTP / timestamping issues some NICs had once upon
> > > a time. The timing application enables HW time stamping, then later some
> > > other application / orchestration changes a seemingly unrelated config,
> > > and since NIC has to reset itself it looses the timestamping config.
> > > Now the time app stops getting HW time stamps, but those are best
> > > effort anyway, so it just assumes the NIC couldn't stamp given frame
> > > (for every frame), not that config got completely broken. The system
> > > keeps running with suboptimal time for months.
> > >
> > > What does the deployment you're expecting to see looks like? What
> > > entity controls enabling the threaded mode on a system? Application?
> > > Orchestration? What's the flow?
> > >
> > I see your point. In our deployment, we have a system daemon which is
> > responsible for setting up all the system tunings after the host boots
> > up (before application starts to run). If certain operation fails, it
> > prints out error msg, and will exit with error. For applications that
> > require threaded mode, I think a check to the sysfs entry to make sure
> > it is enabled is necessary at the startup phase.
>
> That assumes no workload stacking, and dynamic changes after the
> workload has started? Or does the daemon have enough clever logic
> to resolve config changes?
>

The former. There should not be any dynamic changes after the workload
has started. At least for now.

> > > "Forgetting" config based on driver-dependent events feels very fragile.
> > I think we could add a recorded value in dev to represent the user
> > setting, and try to enable threaded mode after napi_disable/enable.
> > But I think user/application still has to check the sysfs entry value
> > to make sure if it is enabled successfully.
>
> In case of an error you're thinking of resetting, still, and returning
> disabled from sysfs? I guess that's fine, we can leave failing the bad
> reconfig operation (rather than resetting config) as a future extension.
> Let's add a WARN_ON, tho, so the failures don't get missed.

Yes. In terms of error, all napi will be reset to using non-threaded
mode, and sysfs returns disabled.
OK. Will add a WARN_ON.
