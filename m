Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 801574B05C9
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 06:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234465AbiBJFuC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 00:50:02 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:43758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232529AbiBJFuB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 00:50:01 -0500
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C0F610CD
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 21:50:03 -0800 (PST)
Received: by mail-yb1-xb2e.google.com with SMTP id y6so12323594ybc.5
        for <netdev@vger.kernel.org>; Wed, 09 Feb 2022 21:50:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WOmvF3M8B+w5v+1bggjdo3Lq30juRX5w3Rct2I4Sfe0=;
        b=ZOv7J8hZH/KCkU742nAXPMxScj+vXmupezkto5eFXaKMyDb1sXurwWQMHaYTqyk860
         X5FW8vl6TD79nU+kSFEQFmfqlzEh3y4WNYGGNE1rc9k5TB9HCHmDo2X/VvXe84W9EfcZ
         bKGnRXJzinfDH1Tu2wNDRauaw4Cv6WQpNxknTnEbYAbFIbai0O61kWZLWRDC0qsQ75cc
         rZINDVBZtvGlRBDcIhFIsvdj8FcioDpiMAg31ymsQjseBGKu1I6cynWxq2SSsEsQckNQ
         NEz1VB2hZeTZch1/IRsD9JY5eAa2r5sdxWOeTSKgLMkv/N7NOxegxbMLiDlt2yXgykNu
         ireA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WOmvF3M8B+w5v+1bggjdo3Lq30juRX5w3Rct2I4Sfe0=;
        b=ez0mhdq0lDQiLCcymscEcuHKALVSzzI0Oveijur/48TbNPLJexpOw3K/ySH++yfkx5
         tiemn+2mSSaD87CAAY1oozhMuF0VRH49gz1tIt3Vaq7pV2BuyAcRqoMvDlN5wpodU/Ey
         8zPf2LtPvXt/MtBkOo7vVTz8R2ToYiRRI/O6Mc0XWEVAS2dY4L2a8Sv7zfGS/ekUIrLs
         k9VDeX0tirO0wEXXzf/x2y5LlpcSJ6DnFC8nPmK7nlccy2tkht3ReK6G8y+48ICwQAxO
         FFEYvkpIhdoYR4oFcnCCh7dQpEPghIaSRP/6hLeSs8jzRpB6UMFNXaJEy1rM1444yX8L
         WR0Q==
X-Gm-Message-State: AOAM531KhVY7NohO8NKMDWxj2A0aPj6s2UXewi+/KjYznBmTRxjDUjcl
        hwVgK49LIyq8TXMOLc/8UKwG6IG8D3VaiseFQG4HwQ==
X-Google-Smtp-Source: ABdhPJweX61Kb6HF38XTTVHt/QC/sMJOusj48MDlAhlPzkBDIml+fYg1ySWFnWPzojOGFUPx1PgKXr18C+QTKtmbXPk=
X-Received: by 2002:a81:3593:: with SMTP id c141mr5655782ywa.73.1644472201987;
 Wed, 09 Feb 2022 21:50:01 -0800 (PST)
MIME-Version: 1.0
References: <cover.1644394642.git.lucien.xin@gmail.com> <76c52badfdccaa7f094d959eaf24f422ae09dec6.1644394642.git.lucien.xin@gmail.com>
 <20220209175558.3117342d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CADvbK_ckY31iZq+++z6kOdd5rBYMyZDNe8N_cHT2wAWu8ZzoZA@mail.gmail.com> <20220209212817.4fe52d3a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220209212817.4fe52d3a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 9 Feb 2022 21:49:51 -0800
Message-ID: <CANn89iLUhJz7pJRYmg3nBV0EOSFHM3ptcSbpKf=vdZPd+8MioA@mail.gmail.com>
Subject: Re: [PATCH net 2/2] vlan: move dev_put into vlan_dev_uninit
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        davem <davem@davemloft.net>,
        Ziyang Xuan <william.xuanziyang@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 9, 2022 at 9:28 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 10 Feb 2022 11:40:42 +0800 Xin Long wrote:
> > > I think better fix would be to rewrite netdev_run_todo() to free the
> > > netdevs in any order they become ready. That's gonna solve any
> > > dependency problems and may even speed things up.
> >
> > What about I keep dev_put() in dev->priv_destructor()/vlan_dev_free() for
> > vlan as before, and fix this problem by using for_each_netdev_reverse()
> > in __rtnl_kill_links()?
> > It will make sense as the late added dev should be deleted early when
> > rtnl_link_unregister a rtnl_link_ops.
>
> Feels like sooner or later we'll run into a scenario when reversing will
> cause a problem. Or some data structure will stop preserving the order.
>
> Do you reckon rewriting netdev_run_todo() will be a lot of effort or
> it's too risky?

This is doable, and risky ;)

BTW, I have the plan of generalizing blackhole_netdev for IPv6,
meaning that we could perhaps get rid of the dependency
about loopback dev, being the last device in a netns being dismantled.
