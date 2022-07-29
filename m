Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A343C585017
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 14:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236061AbiG2MbS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 08:31:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235897AbiG2MbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 08:31:17 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F90A675AA
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 05:31:15 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id h12so3901554lfu.10
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 05:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UscPiVc3W69u2SDEZgLhh627QT22j/EkeFjDm8ewhDU=;
        b=nJrpxtj3/Yr1byjkae9e+eAEwtAZS6cQLSq9Wf/FbOweTm1lCQVUsPbRKq3KsquHix
         Ahx76WP2GWkQOvWSzNFy/ojyGd9Wrx02NkjPklNTCGLCJEyvOFX2lCKqmtSGsrSciIga
         juEvUdPxt4sxwKHufQCBxHAQGnMZw0p0eyn1K88qjYMCqpIC8Hj5RFCIHsOW7O6qvkuU
         6U2SdnxZg83UIY3mAlDL62txLD3y11abWwFFIGB9Klz0ZvA0NHYkD7Lmo1AXFwWl4L10
         LCF2cCFW4VSrlv8DHIP2JK3k43qO7RHanKnUtmINBDajIStTnQ7okAWfcVh35ThcWcQl
         Hrbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UscPiVc3W69u2SDEZgLhh627QT22j/EkeFjDm8ewhDU=;
        b=YeXP1DV3C3aEhAS75U7B48crSoA06Z5QRAJLdcXRJTTerVufGJg0Ynjm3QkjRXKSan
         dArGkaPI0FR2XI2AuwpZct/4BOW+pr1g8rdrLXXekziQhbP7d4vmOtqBnS/PzzuOk+9A
         DQir08xHND6EyKk8W7dYjA8KNRGtnXzOwNGsPB0udEY9f1qGnw9YveqIn8qRO4lBmD3G
         8WopB//tFJIRKMdGGyNKwqUAzNxU7DmKwoM9TzK9160NkPaTwVf09FhspxGOtdcUewFi
         mCwB2u0r20hYgjqJ+NQwPhtOGGimNwcdTOfERl+7ex6wgjRuJEdAAm3ucGIO8OWIqWYq
         jEFA==
X-Gm-Message-State: AJIora83MeQ1WgUDViB6XljqyNXrfo/O9TRKZHSEGmyIFlkqLQ3FO7/p
        wrftYHYHLkGtCyvuO9f79Y/dJTmavhDGZMcTxFwOYg==
X-Google-Smtp-Source: AA6agR62HeE51l5IAK04JRZwMFJ1wYjG83cpBLDmLAJjptPk6vF7HAk3w0wXXYaTfDZ+/dbgsxR4PZ99SvySsvQiBoI=
X-Received: by 2002:a05:6512:1093:b0:48a:7c08:8d29 with SMTP id
 j19-20020a056512109300b0048a7c088d29mr1161026lfg.540.1659097873241; Fri, 29
 Jul 2022 05:31:13 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000e6917605e48ce2bf@google.com> <Yt6DjrMdIhpQmm7V@codewreck.org>
 <CACT4Y+Yx2MZ9KEX9gfm-LahQE4KaXX=u4RQBuj-1gS57KL0OSw@mail.gmail.com> <2916828.W3qMjvkFlE@silver>
In-Reply-To: <2916828.W3qMjvkFlE@silver>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Fri, 29 Jul 2022 14:31:01 +0200
Message-ID: <CACT4Y+Ycz2a2tuPs4R2WS3Gs+rvLBrusamCq3kQ3wj8R+=rX6w@mail.gmail.com>
Subject: Re: [syzbot] WARNING in p9_client_destroy
To:     Christian Schoenebeck <linux_oss@crudebyte.com>
Cc:     asmadeus@codewreck.org, Vlastimil Babka <vbabka@suse.cz>,
        syzbot <syzbot+5e28cdb7ebd0f2389ca4@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, davem@davemloft.net,
        edumazet@google.com, elver@google.com, ericvh@gmail.com,
        hdanton@sina.com, k.kahurani@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, lucho@ionkov.net,
        netdev@vger.kernel.org, pabeni@redhat.com, rientjes@google.com,
        syzkaller-bugs@googlegroups.com, torvalds@linux-foundation.org,
        v9fs-developer@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Jul 2022 at 14:10, Christian Schoenebeck
<linux_oss@crudebyte.com> wrote:
>
> On Montag, 25. Juli 2022 14:45:08 CEST Dmitry Vyukov wrote:
> > On Mon, 25 Jul 2022 at 13:51, <asmadeus@codewreck.org> wrote:
> > > Vlastimil Babka wrote on Mon, Jul 25, 2022 at 12:15:24PM +0200:
> > > > On 7/24/22 15:17, syzbot wrote:
> > > > > syzbot has bisected this issue to:
> > > > >
> > > > > commit 7302e91f39a81a9c2efcf4bc5749d18128366945
> > > > > Author: Marco Elver <elver@google.com>
> > > > > Date:   Fri Jan 14 22:03:58 2022 +0000
> > > > >
> > > > >     mm/slab_common: use WARN() if cache still has objects on destroy
> > > >
> > > > Just to state the obvious, bisection pointed to a commit that added the
> > > > warning, but the reason for the warning would be that p9 is destroying a
> > > > kmem_cache without freeing all the objects there first, and that would
> > > > be
> > > > true even before the commit.
> > >
> > > Probably true from the moment that cache/idr was introduced... I've got
> > > a couple of fixes in next but given syzcaller claims that's the tree it
> > > was produced on I guess there can be more such leaks.
> > > (well, the lines it sent in the backtrace yesterday don't match next,
> > > but I wouldn't count on it)
> > >
> > > If someone wants to have a look please feel free, I would bet the
> > > problem is just that p9_fd_close() doesn't call or does something
> > > equivalent to p9_conn_cancel() and there just are some requests that
> > > haven't been sent yet when the mount is closed..
> > > But I don't have/can/want to take the time to check right now as I
> > > consider such a leak harmless enough, someone has to be root or
> > > equivalent to do 9p mounts in most cases.
> >
> > FWIW with KASAN we have allocation stacks for each heap object. So
> > when KASAN is enabled that warning could list all live object
> > allocation stacks.
>
> With allocation stack you mean the backtrace/call stack at the point in time
> when the memory originally was acquired?
>
> If the answer is yes, then sure, if someone had a chance to post those
> backtraces, then that would help us to take a closer look at where this leak
> might happen. Otherwise I fear it will end up among those other "lack of
> priority" issues.

Yes, I meant providing allocation stacks for leaked objects.
Filed https://bugzilla.kernel.org/show_bug.cgi?id=216306 for this feature.
