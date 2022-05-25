Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 864835341E9
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 19:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240960AbiEYRCo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 13:02:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229551AbiEYRCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 13:02:42 -0400
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FBBD35A99;
        Wed, 25 May 2022 10:02:38 -0700 (PDT)
Received: by mail-qt1-x82a.google.com with SMTP id v6so14471923qtx.12;
        Wed, 25 May 2022 10:02:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LladUyPXqhvy6xFCV+qprs26wq5bXjZ7GMD9uy8dOjU=;
        b=IDu79vMCzRFhfyNiIh9umbhUvNvLwQDbwqdO72XBwpGHybDDImX0nn3JEQFpbppHmV
         vVZY/7N32Pflxnga9o13wF6zOWXE8P23YXXk6+BAWj7iuLqpM+yM4Syk4rz6R4AzVNHg
         HllxDXVz/OyGe95E6fAMy5UQDIIDZZTpqGxwDfYZEpRYjSjLb/TLvQCP58MKQzpKT+Ha
         lR9kPb6SNIjnnlIk6NGstK2c3xys27hWmkIqCPEUfvnTh1A9MmAgEecp/rWOsZsoZT/I
         UovQxsDsC19lCZNZUK7ESdanZshG44xMHYI4Ru4whr3uzt3mcbRwIMi7rdctqA2v20S7
         LKDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LladUyPXqhvy6xFCV+qprs26wq5bXjZ7GMD9uy8dOjU=;
        b=BXYbdQvRktTk8LdJHQ8g+MHIyU6rVnXaFLdaTB6LBL+/TOaBAg0M2bD3X6godCSkVn
         FVyYYoKFAPfmSp5s04uVu9HvtWTW3Sml45cFPRJeMTahlGAMeGawBnjGvllPScGk7/ab
         0hQ0BvOBJ5o1UrZhpIv1oldlv1gOezMfDtq16B0mCyxHhLTFPH/ULGa0iBeS9BWnBy5I
         ToEnYFSEBZxVy+FTFNNwt2Kw4QKlMRxQdoiDLxiqYGkJT/FC3rUJ/XWz+y2zJIgLLyMM
         XsN16ro0cAYfABVplzksKvCyudAEVwk5kJZGJY3m3JU5zduHRF8HaddSBe+XJw2VzfUh
         +lMw==
X-Gm-Message-State: AOAM531IWNjIRXPYy1O3ioDMnf899ikLdGe0FSeVp7UlCkStWZ243TX3
        Hfw5jJIw+NFayR7gnSDWvw==
X-Google-Smtp-Source: ABdhPJywYwBXdqkjWfR3nmyH3B8L06YY/+Y8tE7ULDUzYsdGvA/vpWGoCQ+aannrrdQ65JGPhjLdfg==
X-Received: by 2002:ac8:7dc3:0:b0:2fa:6788:4fca with SMTP id c3-20020ac87dc3000000b002fa67884fcamr4662969qte.168.1653498155984;
        Wed, 25 May 2022 10:02:35 -0700 (PDT)
Received: from moria.home.lan (c-73-219-103-14.hsd1.vt.comcast.net. [73.219.103.14])
        by smtp.gmail.com with ESMTPSA id y3-20020a37f603000000b0069fc13ce1ffsm1579313qkj.48.2022.05.25.10.02.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 10:02:35 -0700 (PDT)
Date:   Wed, 25 May 2022 13:02:33 -0400
From:   Kent Overstreet <kent.overstreet@gmail.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        netdev@vger.kernel.org, mcgrof@kernel.org, tytso@mit.edu
Subject: Re: RFC: Ioctl v2
Message-ID: <20220525170233.2yxb5pm75dehrjuj@moria.home.lan>
References: <20220520161652.rmhqlvwvfrvskg4w@moria.home.lan>
 <Yof6hsC1hLiYITdh@lunn.ch>
 <20220521164546.h7huckdwvguvmmyy@moria.home.lan>
 <20220521124559.69414fec@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220521124559.69414fec@hermes.local>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 21, 2022 at 12:45:59PM -0700, Stephen Hemminger wrote:
> On Sat, 21 May 2022 12:45:46 -0400
> Kent Overstreet <kent.overstreet@gmail.com> wrote:
> 
> > On Fri, May 20, 2022 at 10:31:02PM +0200, Andrew Lunn wrote:
> > > > I want to circulate this and get some comments and feedback, and if
> > > > no one raises any serious objections - I'd love to get collaborators
> > > > to work on this with me. Flame away!  
> > > 
> > > Hi Kent
> > > 
> > > I doubt you will get much interest from netdev. netdev already
> > > considers ioctl as legacy, and mostly uses netlink and a message
> > > passing structure, which is easy to extend in a backwards compatible
> > > manor.  
> > 
> > The more I look at netlink the more I wonder what on earth it's targeted at or
> > was trying to solve. It must exist for a reason, but I've written a few ioctls
> > myself and I can't fathom a situation where I'd actually want any of the stuff
> > netlink provides.
> 
> Netlink was built for networking operations, you want to set something like a route with a large
> number of varying parameters in one transaction. And you don't want to have to invent
> a new system call every time a new option is added.
> 
> Also, you want to monitor changes and see these events for a userspace control
> application such as a routing daemon.

That makes sense - perhaps the new mount API could've been done as a netlink
interface :)

But perhaps it makes sense to have both - netlink for the big complicated
stateful operations, ioctl v2 for the simpler ones. I haven't looked at netlink
usage at all, but most of the filesystem ioctls I've looked at fall into the the
simple bucket, for me.

Actually, I have one in bcachefs that might fit better into the netlink bucket -
maybe while I've got your attention you could tell me what this is like in
netlink land.

In bcachefs, we have "data jobs", where userspace asks us to do something that
requires walking data and performing some operation on them - this is used for
manual rebalance, evacuating data off a device, scrub (when that gets
implemented), etc.

The way I did this was with an ioctl that takes as a parameter the job to
perform, then it kicks off a kernel thread to do the work and returns a file
descriptor, which userspace reads from to find out the current status of the job
(which it uses to implement a progress indicator). We kill off the kthread if
the file descriptor is closed, meaning ctrl-c works as expected.

I really like how this turned out, it's not much code and super slick - I was
considering abstracting it out as generic functionality. But this definitely
sounds like what netlink is targeted at - thoughts?
