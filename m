Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BDCC57FF2F
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 14:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235096AbiGYMp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 08:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234808AbiGYMpZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 08:45:25 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55D2862FD
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 05:45:24 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id e11so12984833ljl.4
        for <netdev@vger.kernel.org>; Mon, 25 Jul 2022 05:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jc/BDHMhK7iVrMHxH2raQUC5msig51Chw85BZlvexog=;
        b=d3/PmsviXYCk0itavdxDqkvzp8Kz9cccCIGsW5lkbDT80suAiNOcyPvQwiEya3G4Mf
         e0LrE0W4gpboiQ9zI5/nYBW3ry4+9nQUWZz1VV6DufjOI36YRFkFznXf9NFTGtG9xVLR
         mJNtZGy+xADkT3tKDanfBBdZ5ZFKpsQq/Op/BB4FaABjvB9ZzlIwiaCHh1XJE570mDVq
         /aAyku306M+TRH2XHHNJOxt1kd1UFqhQSJGWI5k0gJStQQliTfMuSzwp1DxmA6/I6wnf
         045ou4K6VM40gyDik9i7VB7HFSavn6ixutQ86mfaCKiTwF7I9uuiMbiYDroAvgzVbo84
         6XXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jc/BDHMhK7iVrMHxH2raQUC5msig51Chw85BZlvexog=;
        b=cm4jvxOlrg1Uz0I5tFyCjXhMc2WU6IwPCqzoLw68VINgcrlMXNq7PSNNv6sFxdG/Lu
         mnLOj505WoQ1/RxQmtADaJl4nirR7CaQhuAiRah6UEgCiNUEsjAbOZec2zC5IGyfLvU8
         tVCDNF36BTC2UFXNjSyOLc2/Bf8XYSlLqfVxhKQfUo1rNGHeWMX4gI0+Pbq2M9U3Ptr9
         nHwM2bZmEJ9MGQiU5ElrkKfYXy98x6gqCgXMGvN0q0lpnP+U2qHdyIQ3Gp9GUL7VBIEw
         LvMWqipBxDx3JGOt0Syf3CJXsokeKG4NLLyTox0l75FSc+FWc+7/2j4xbntH8rr95nZ8
         zb2A==
X-Gm-Message-State: AJIora+JCMvDsP1aPVY6RiJ7toldsbJEn4EEMw1dJOAmDAuDkU2/eHLR
        TR77ds4Z8ycZEGCFGlmV6a/n6Y9B+NdaJK3jTms9+Q==
X-Google-Smtp-Source: AGRyM1ttCR4r5EwqnFicWDa0hJroSrq3Kb6EnYgiHUHsvLcqYfg0QWWCCLkJwznDc3Bw24pP9aVgr3kHyU9nkbMlBHw=
X-Received: by 2002:a2e:bd0e:0:b0:25a:88b3:9af6 with SMTP id
 n14-20020a2ebd0e000000b0025a88b39af6mr4397667ljq.363.1658753120669; Mon, 25
 Jul 2022 05:45:20 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000e6917605e48ce2bf@google.com> <fb9febe5-00a6-61e9-a2d0-40982f9721a3@suse.cz>
 <Yt6DjrMdIhpQmm7V@codewreck.org>
In-Reply-To: <Yt6DjrMdIhpQmm7V@codewreck.org>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Mon, 25 Jul 2022 14:45:08 +0200
Message-ID: <CACT4Y+Yx2MZ9KEX9gfm-LahQE4KaXX=u4RQBuj-1gS57KL0OSw@mail.gmail.com>
Subject: Re: [syzbot] WARNING in p9_client_destroy
To:     asmadeus@codewreck.org
Cc:     Vlastimil Babka <vbabka@suse.cz>,
        syzbot <syzbot+5e28cdb7ebd0f2389ca4@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, davem@davemloft.net,
        edumazet@google.com, elver@google.com, ericvh@gmail.com,
        hdanton@sina.com, k.kahurani@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux_oss@crudebyte.com,
        lucho@ionkov.net, netdev@vger.kernel.org, pabeni@redhat.com,
        rientjes@google.com, syzkaller-bugs@googlegroups.com,
        torvalds@linux-foundation.org, v9fs-developer@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 25 Jul 2022 at 13:51, <asmadeus@codewreck.org> wrote:
>
> Vlastimil Babka wrote on Mon, Jul 25, 2022 at 12:15:24PM +0200:
> > On 7/24/22 15:17, syzbot wrote:
> > > syzbot has bisected this issue to:
> > >
> > > commit 7302e91f39a81a9c2efcf4bc5749d18128366945
> > > Author: Marco Elver <elver@google.com>
> > > Date:   Fri Jan 14 22:03:58 2022 +0000
> > >
> > >     mm/slab_common: use WARN() if cache still has objects on destroy
> >
> > Just to state the obvious, bisection pointed to a commit that added the
> > warning, but the reason for the warning would be that p9 is destroying a
> > kmem_cache without freeing all the objects there first, and that would be
> > true even before the commit.
>
> Probably true from the moment that cache/idr was introduced... I've got
> a couple of fixes in next but given syzcaller claims that's the tree it
> was produced on I guess there can be more such leaks.
> (well, the lines it sent in the backtrace yesterday don't match next,
> but I wouldn't count on it)
>
> If someone wants to have a look please feel free, I would bet the
> problem is just that p9_fd_close() doesn't call or does something
> equivalent to p9_conn_cancel() and there just are some requests that
> haven't been sent yet when the mount is closed..
> But I don't have/can/want to take the time to check right now as I
> consider such a leak harmless enough, someone has to be root or
> equivalent to do 9p mounts in most cases.

FWIW with KASAN we have allocation stacks for each heap object. So
when KASAN is enabled that warning could list all live object
allocation stacks.
