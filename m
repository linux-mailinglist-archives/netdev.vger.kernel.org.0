Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2203F4B1FC0
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 08:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347870AbiBKH7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 02:59:09 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235256AbiBKH7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 02:59:08 -0500
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B856BBF
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 23:59:08 -0800 (PST)
Received: by mail-oi1-x235.google.com with SMTP id s24so8746781oic.6
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 23:59:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dRFM5xY2xWDueYH/A7p1VzqZHecDcIDdFcKdWXgTvxA=;
        b=Eu2PFQ1lFRSaYv3UEP9EikR8XT1Jc09W/1Fr5OwzU2q6G7IIaz3lb1PIWDQnPR6kdN
         Kl/VNOHensIDM+mVvqnFfZFARChWcyT88qUv4vvow2IkgO07tCBQIldXmG900NvTAqVS
         dq4BK2i3mbwdoxLeGEvX9T+AqyRcZ9OspOf/LZs0qVzAL+apLlPfLOb3KJR86DM81O+H
         6EazyOr8oY1OoyY/RsH2xg12RXx10YNs9Dx9pNOuM90kO/y5R6zlLugtrZUs0s+nfPG/
         /OYv4pdGMcaV6W0PKx/fpVEp9g3hfW3tt9SzsMcXsSmxJ7W3XIQ51Q7oBwzjNikATyM3
         ZOCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dRFM5xY2xWDueYH/A7p1VzqZHecDcIDdFcKdWXgTvxA=;
        b=UaDbAFt2lY9u80UvdKS5/ThGxNJUehqv4vHak5Mp7rR9cPNXPeGR9QWc1qqyk9X64o
         5z+c8BnytkrRquiWPlTbU4gWORkNyYkCkmhdbRsRTSPj7ECbtbMWppZ0PzyJaZ+yHu6I
         R8YalsqOjVYaxfCoMwdgOXe0JbSs9rxp095Q5VsLPW2vU6gE6E4668zTZ0xDGAdGwD2v
         Exr4UtFnVfQ0aUpH3oOU0tdiYD4Ck2rcp7S3OBs1Cg9bRGJnjH/z4YcMBC8cJL4D8AXM
         7x4GBzDAhJMhkm2PU6Pavc/yFRQjOGHmPKGSGjQ+Es+19fF2Xvr+ZZngnI9t6GOw6TvK
         FdzQ==
X-Gm-Message-State: AOAM5328jypyp7H5xhKUFSUfqHCpsDxqcEdlCHQNr/HlcVODHMT2laay
        fyKxXdQJ0mNuF359uI49ABLysSfO/pV5Up72V3kTM3PGdL/6uQ==
X-Google-Smtp-Source: ABdhPJw/koPlPUE5eDdSnuUU5/5T/JkjuwTytyOpyaMo9PHCHHpDuMB/EPsNSyPISWl0Yozi0ae4URDTC3GZx4gVIR8=
X-Received: by 2002:a05:6808:1147:: with SMTP id u7mr534619oiu.189.1644566347434;
 Thu, 10 Feb 2022 23:59:07 -0800 (PST)
MIME-Version: 1.0
References: <cover.1644394642.git.lucien.xin@gmail.com> <76c52badfdccaa7f094d959eaf24f422ae09dec6.1644394642.git.lucien.xin@gmail.com>
 <20220209175558.3117342d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CADvbK_ckY31iZq+++z6kOdd5rBYMyZDNe8N_cHT2wAWu8ZzoZA@mail.gmail.com>
 <20220209212817.4fe52d3a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89iLUhJz7pJRYmg3nBV0EOSFHM3ptcSbpKf=vdZPd+8MioA@mail.gmail.com> <20220209215943.71ee15f5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220209215943.71ee15f5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 11 Feb 2022 15:58:56 +0800
Message-ID: <CADvbK_f-Zk9X7M87yUi8msAykA9z+5-te3hNXg3TRE+bfpfmBg@mail.gmail.com>
Subject: Re: [PATCH net 2/2] vlan: move dev_put into vlan_dev_uninit
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        network dev <netdev@vger.kernel.org>,
        davem <davem@davemloft.net>,
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

On Thu, Feb 10, 2022 at 1:59 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 9 Feb 2022 21:49:51 -0800 Eric Dumazet wrote:
> > > Feels like sooner or later we'll run into a scenario when reversing will
> > > cause a problem. Or some data structure will stop preserving the order.
> > >
> > > Do you reckon rewriting netdev_run_todo() will be a lot of effort or
> > > it's too risky?
> >
> > This is doable, and risky ;)
> >
> > BTW, I have the plan of generalizing blackhole_netdev for IPv6,
> > meaning that we could perhaps get rid of the dependency
> > about loopback dev, being the last device in a netns being dismantled.
>
> Oh, I see..
>
> I have no great ideas then, we may need to go back to zeroing
> vlan->real_dev and making sure the caller can deal with that.
> At least for the time being. Xin this was discussed at some
> length in response to the patch under Fixes.
Hi, Jakub,

What if dev->real_dev is freed and zeroed *after* vlan_dev_real_dev()
is called? This issue can still be triggered, right? I don't see any lock
protecting this.

> Feels like sooner or later we'll run into a scenario when reversing will
> cause a problem. Or some data structure will stop preserving the order.
I was checking a few places doing such batch devices freeing, and noticed that:
In rtnl_group_dellink() and __rtnl_kill_links(), it's using for_each_netdev(),
while in default_device_exit_batch(), it's using for_each_netdev_reverse().

shouldn't be in the same order all these places? If yes, which one is the
right one to use?

Thanks.
