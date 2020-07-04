Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2E8214234
	for <lists+netdev@lfdr.de>; Sat,  4 Jul 2020 02:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgGDAGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jul 2020 20:06:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbgGDAGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jul 2020 20:06:21 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3E40C061794;
        Fri,  3 Jul 2020 17:06:20 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id 72so2562957ple.0;
        Fri, 03 Jul 2020 17:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7UMg+mEjzy3xVimDZCzvYsyI12zw07nNUOKb1rhadCM=;
        b=sayvllZqvov9e1fBu22meYNRdjUMDn7kR+eHeA+zCkmpQ1hH75bbCfWMT9uV+l2/JT
         bbZX3yaouonPtVmBq9qu/58Rac7ivp+cspN2kpdMNJYsdaSwIviXmsq0i1YDxWwly+7s
         MwQOY/TNQXc8mIOXVLW5o7yJs2aO3WE6fK+kl1CXf88Oqgck/JLHv72y+Y4ZOrgYYTmk
         JoZhGW7tl6Gr21ddt/AWAgtswVpxcRaPFg2s4g2la8oGj9dEzbSVLM7WwbC3xxp4WCli
         dShIbfw82q8uYSY5dHHx+OYfLFEftAVUfbDFKPNJQ0w1H4rC4L0x4HkDGVTJjM/atJfY
         oTgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7UMg+mEjzy3xVimDZCzvYsyI12zw07nNUOKb1rhadCM=;
        b=ewYIDYY2U35ilkA2DOxrdIpVkYf/JqKDLT+pEdk+7Q5m/LqEdQnXO1a99doWUBt8OA
         fXg55HOqFN22NeSFlQuzIme8ZT3/FU9eb+qJhF5e1WEdDxZVPoBCYdvg6sKZlnBaFIYe
         9d9igf5g+l/H/W4RGhFNUYg8QBLV5bguL/u5RUXFYb/h62UkepGaqtLO8pEnWmlVrjHt
         9Iunu/Oiaroj+JcZEeeAoHP7vyApF9ICaLPTrxXATehXTpFWOq6G/aRQ/E6AgwQ2lDiS
         uee6FJiJR2or9PiFxU89xuHWYbyu40T+U5DgHOmsTSj3dpkyaCCORjhImSBrv3PnFLwB
         LsBA==
X-Gm-Message-State: AOAM5339Ufj35Ma2hpOcin7njyp2e8jZSTSUBQ40ozOlx5cDyt2QzOwR
        psa31vnMkAmW7rW9LRpVVf8=
X-Google-Smtp-Source: ABdhPJwdQsoe3BLy3+8W8uel5KTOJGL6fkyp92gLyek3RevEayrbei+Bg+lwJvyxXugERCBTrz2sZg==
X-Received: by 2002:a17:90a:ae14:: with SMTP id t20mr38057450pjq.184.1593821180297;
        Fri, 03 Jul 2020 17:06:20 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:d8c2])
        by smtp.gmail.com with ESMTPSA id q92sm12186901pjh.12.2020.07.03.17.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2020 17:06:19 -0700 (PDT)
Date:   Fri, 3 Jul 2020 17:06:17 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        kernel-team@fb.com
Subject: Re: [PATCH bpf-next 3/3] bpf: Add kernel module with user mode
 driver that populates bpffs.
Message-ID: <20200704000617.mrkwrta2gwywgb7l@ast-mbp.dhcp.thefacebook.com>
References: <20200702200329.83224-1-alexei.starovoitov@gmail.com>
 <20200702200329.83224-4-alexei.starovoitov@gmail.com>
 <CAHk-=wgP8g-9RdVh_AHHi9=Jpw2Qn=sSL8j9DqhqGyTtG+MWBA@mail.gmail.com>
 <20200703023547.qpu74obn45qvb2k7@ast-mbp.dhcp.thefacebook.com>
 <CAHk-=wiBi3sjtL0JNzcPTYEOFomU9Oqz_vD=oHznxyQYGBRi5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wiBi3sjtL0JNzcPTYEOFomU9Oqz_vD=oHznxyQYGBRi5Q@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 02, 2020 at 08:34:17PM -0700, Linus Torvalds wrote:
> On Thu, Jul 2, 2020 at 7:35 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Thu, Jul 02, 2020 at 06:05:29PM -0700, Linus Torvalds wrote:
> > > On Thu, Jul 2, 2020 at 1:03 PM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > >
> > > > The BPF program dump_bpf_prog() in iterators.bpf.c is printing this data about
> > > > all BPF programs currently loaded in the system. This information is unstable
> > > > and will change from kernel to kernel.
> > >
> > > If so, it should probably be in debugfs, not in /sys/fs/
> >
> > /sys/fs/bpf/ is just a historic location where we chose to mount bpffs.
> 
> It's more the "information is unstable and will change from kernel to kernel"
> 
> No such interfaces exist. If people start parsing it and depending it,
> it's suddenly an ABI, whether you want to or not (and whether you
> documented it or not).
> 
> At least if it's in /sys/kernel/debug/bpf/ or something, it's less
> likely that anybody will do that.

I think I will go with "debug" mount option then.
By default nothing will be preloaded, so de-facto /sys/fs/bpf/ will stay empty.
