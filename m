Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C18F4B0403
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 04:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbiBJDkx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 22:40:53 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiBJDkw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 22:40:52 -0500
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FABC23BF1
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 19:40:54 -0800 (PST)
Received: by mail-oo1-xc29.google.com with SMTP id f11-20020a4abb0b000000b002e9abf6bcbcso4943732oop.0
        for <netdev@vger.kernel.org>; Wed, 09 Feb 2022 19:40:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2Ez2nTX23/RpMbua/tp7BmlVIqHKbLFMA0uYCGy/5mI=;
        b=JlEKjOVBcBywzdh1hxwzJvHJVZExFc2yfOPogFl3eVplGjatBHix3vUqWIQNfCugHo
         U1oKl/fKcoMdWhOJhy+82ZtLNSFfrjjMu+9b7MIheUK8T+DOmewIPRIfaO4lhvjbKYrb
         60FB+1kE3EihaZB46AkvqB9AKQ063bAflUq7fwBkUw3njcDnd2bGlsP+Q7D/VPtEzfhe
         /6cW8uYn8BWWdKpizngmD7bIBklcRJ6O2bYAZk0vNP+IA0ZjiXzmOUBlByO/7mjlxxls
         8DbpcY+dfvse0E7JDHVmSGbS6lqXfy0c9TH5NxiETVn/6EmU3+dSpm3qFqUuEnB0jweT
         HkxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2Ez2nTX23/RpMbua/tp7BmlVIqHKbLFMA0uYCGy/5mI=;
        b=udWYUKmOfuy4kZgtjCVXOg/jOlPeHAjfWKFVWwUTGDvsYyfiaL1p9aBrYGxH5r1JIC
         mNrgxGn8XtLoJyszVqNVZMAUcGAOoD92vZb4+T/kn8wBj4El5nRMu76egX5JuJ1FXEbp
         +bZFZJDi9dnNoUms+kWwEK5qc+IWDkdFVwPU4ElIhKLjxV1IljQIASzfwrSj+bnZ7VD6
         CTUR80rQBUa60YtlhyEcaD9WWqAkJYIApOXIGVPSxdJ5gFIOWaMURwWP4VB6iFCOZh5/
         jMK7hXJZPvSniF/CntvOFx0DLxzHLIrGGBxnxAILiNdcMdruqoOpyRBkdy06Y6iqxglG
         /aOg==
X-Gm-Message-State: AOAM530hN/TXPwrLe43FQHg9PnDz6l+55zggkQKoi6w0M8et8swAW7wc
        llbSFpvUDKJMjYysT7LyOLGs+0pi9K4C5E8duCtPWABXYx6XrQ==
X-Google-Smtp-Source: ABdhPJxCYeSlYaTJ6SZPGxxjdggFOb3m3rYwlx30LSEpfFYePU+aknemPZeItgcHtpy0QfDlo4jN742KCGbmyKraAoI=
X-Received: by 2002:a05:6870:b1d0:: with SMTP id x16mr198811oak.169.1644464453597;
 Wed, 09 Feb 2022 19:40:53 -0800 (PST)
MIME-Version: 1.0
References: <cover.1644394642.git.lucien.xin@gmail.com> <76c52badfdccaa7f094d959eaf24f422ae09dec6.1644394642.git.lucien.xin@gmail.com>
 <20220209175558.3117342d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220209175558.3117342d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 10 Feb 2022 11:40:42 +0800
Message-ID: <CADvbK_ckY31iZq+++z6kOdd5rBYMyZDNe8N_cHT2wAWu8ZzoZA@mail.gmail.com>
Subject: Re: [PATCH net 2/2] vlan: move dev_put into vlan_dev_uninit
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     network dev <netdev@vger.kernel.org>, davem <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Ziyang Xuan <william.xuanziyang@huawei.com>
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

On Thu, Feb 10, 2022 at 9:56 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed,  9 Feb 2022 03:19:56 -0500 Xin Long wrote:
> > Shuang Li reported an QinQ issue by simply doing:
> >
> >   # ip link add dummy0 type dummy
> >   # ip link add link dummy0 name dummy0.1 type vlan id 1
> >   # ip link add link dummy0.1 name dummy0.1.2 type vlan id 2
> >   # rmmod 8021q
> >
> >  unregister_netdevice: waiting for dummy0.1 to become free. Usage count = 1
>
> How about we put this in a selftest under tools/testing/selftests/net/
> or tools/testing/selftests/drivers/net/ ?
I will try.

>
> > When rmmods 8021q, all vlan devs are deleted from their real_dev's vlan grp
> > and added into list_kill by unregister_vlan_dev(). dummy0.1 is unregistered
> > before dummy0.1.2, as it's using for_each_netdev() in __rtnl_kill_links().
> >
> > When unregisters dummy0.1, dummy0.1.2 is not unregistered in the event of
> > NETDEV_UNREGISTER, as it's been deleted from dummy0.1's vlan grp. However,
> > due to dummy0.1.2 still holding dummy0.1, dummy0.1 will keep waiting in
> > netdev_wait_allrefs(), while dummy0.1.2 will never get unregistered and
> > release dummy0.1, as it delays dev_put until calling dev->priv_destructor,
> > vlan_dev_free().
> >
> > This issue was introduced by Commit 563bcbae3ba2 ("net: vlan: fix a UAF in
> > vlan_dev_real_dev()"), and this patch is to fix it by moving dev_put() into
> > vlan_dev_uninit(), which is called after NETDEV_UNREGISTER event but before
> > netdev_wait_allrefs().
> >
> > Fixes: 563bcbae3ba2 ("net: vlan: fix a UAF in vlan_dev_real_dev()")
>
> As far as I understand this is pretty much a revert of the previous fix.
> Note that netdevice_event_work_handler() as seen in the backtrace in the
> commit message of the fix in question is called from a workqueue, so the
> ordering of netdev notifications saves us from nothing here. We can't
> start freeing state until all refs are gone.
understand.

>
> I think better fix would be to rewrite netdev_run_todo() to free the
> netdevs in any order they become ready. That's gonna solve any
> dependency problems and may even speed things up.
>
What about I keep dev_put() in dev->priv_destructor()/vlan_dev_free() for
vlan as before, and fix this problem by using for_each_netdev_reverse()
in __rtnl_kill_links()?
It will make sense as the late added dev should be deleted early when
rtnl_link_unregister a rtnl_link_ops.
