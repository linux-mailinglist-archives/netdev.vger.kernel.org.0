Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A97524C92EA
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 19:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236933AbiCASWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 13:22:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236881AbiCASWI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 13:22:08 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2EAF652E5
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 10:21:25 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id 15-20020a17090a098f00b001bef0376d5cso512488pjo.5
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 10:21:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fds8Vu27HO3VizdZYZX37G2L0kdPjlGJwjydpAC62lk=;
        b=kbDptrdu0f26KgjbD0o2z38w3lkKGDPgX1iTHeFHCTnyp8GdCq5qMftyKUSBh6duUj
         WfNj/A6u5i3SYTvNHtilrjGbJ7XPB9BN5cThiWBPQtUhCrDH1721OqL04qTC03fUauzy
         3YHA9gzqSMuaks5H7GdDPribo7C8kJL0W2A2s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fds8Vu27HO3VizdZYZX37G2L0kdPjlGJwjydpAC62lk=;
        b=P9KlU5lpPdCv+JUylidDclktlsdYEfbLwt4VHk/1GEPPUilAf9GV5eLAMOOCnSDxAS
         5VqUCL1h5jVQSe7XMvfqVfF0wpFENT28VPBNkMCXw4pmiPGNIc9R2n1ChdsYVcFAV4DJ
         9NVWOf1AwPLqToG7JCYiVIwn5rRP/3p49ZZ/hUv1S3kHfUT4DqJfSzqIS5XFqM48MkLO
         IGajHO7lwvM+DY8WxwX3qyPZvuI/8GApSiKLvHMuY7lgKxYwpIwgmGTsqksmLGn7wOvR
         R5v4UB+0p4Cko7bNaaC4otmT7NEKSm9CJ59Z7rF+DrsfD6dL0ZDuuy0oez0qRogyOAbF
         6VnQ==
X-Gm-Message-State: AOAM530iMHSg83iSUacyd2zfu6QKeEKSsKli+r4Y9x4HzbOaDKGEvhY6
        mpt3A22O+hbCs1PMFBM/RRzKZw==
X-Google-Smtp-Source: ABdhPJxFvMPIFzTXAIIVPlg/eGuYakalp78L+LNg6VrEL06CzJLvdAz6UlqMRKRHGibjFN8E9JB6yg==
X-Received: by 2002:a17:90b:4d86:b0:1bd:223f:6cb5 with SMTP id oj6-20020a17090b4d8600b001bd223f6cb5mr16669777pjb.151.1646158885116;
        Tue, 01 Mar 2022 10:21:25 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id oa2-20020a17090b1bc200b001bcff056f09sm2678996pjb.13.2022.03.01.10.21.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 10:21:24 -0800 (PST)
Date:   Tue, 1 Mar 2022 10:21:24 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Jakob Koschel <jakobkoschel@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        alsa-devel@alsa-project.org, linux-aspeed@lists.ozlabs.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        linux-iio@vger.kernel.org, nouveau@lists.freedesktop.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Cristiano Giuffrida <c.giuffrida@vu.nl>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        samba-technical@lists.samba.org,
        linux1394-devel@lists.sourceforge.net, drbd-dev@lists.linbit.com,
        linux-arch <linux-arch@vger.kernel.org>,
        CIFS <linux-cifs@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        linux-staging@lists.linux.dev, "Bos, H.J." <h.j.bos@vu.nl>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        intel-wired-lan@lists.osuosl.org,
        kgdb-bugreport@lists.sourceforge.net,
        bcm-kernel-feedback-list@broadcom.com,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Arnd Bergman <arnd@arndb.de>,
        Linux PM <linux-pm@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Brian Johannesmeyer <bjohannesmeyer@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        v9fs-developer@lists.sourceforge.net,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-sgx@vger.kernel.org,
        linux-block <linux-block@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, linux-usb@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux F2FS Dev Mailing List 
        <linux-f2fs-devel@lists.sourceforge.net>,
        tipc-discussion@lists.sourceforge.net,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        dma <dmaengine@vger.kernel.org>,
        linux-mediatek@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Mike Rapoport <rppt@kernel.org>
Subject: Re: [PATCH 2/6] treewide: remove using list iterator after loop body
 as a ptr
Message-ID: <202203011016.48A181EE50@keescook>
References: <20220228110822.491923-1-jakobkoschel@gmail.com>
 <20220228110822.491923-3-jakobkoschel@gmail.com>
 <2e4e95d6-f6c9-a188-e1cd-b1eae465562a@amd.com>
 <CAHk-=wgQps58DPEOe4y5cTh5oE9EdNTWRLXzgMiETc+mFX7jzw@mail.gmail.com>
 <CAHk-=wj8fkosQ7=bps5K+DDazBXk=ypfn49A0sEq+7-nZnyfXA@mail.gmail.com>
 <CAHk-=wiTCvLQkHcJ3y0hpqH7FEk9D28LDvZZogC6OVLk7naBww@mail.gmail.com>
 <FC710A1A-524E-481B-A668-FC258F529A2E@gmail.com>
 <CAHk-=whLK11HyvpUtEftOjc3Gup2V77KpAQ2fycj3uai=qceHw@mail.gmail.com>
 <CEDAD0D9-56EE-4105-9107-72C2EAD940B0@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CEDAD0D9-56EE-4105-9107-72C2EAD940B0@gmail.com>
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 01, 2022 at 12:28:15PM +0100, Jakob Koschel wrote:
> Based on the coccinelle script there are ~480 cases that need fixing
> in total. I'll now finish all of them and then split them by
> submodules as Greg suggested and repost a patch set per submodule.
> Sounds good?

To help with this splitting, see:
https://github.com/kees/kernel-tools/blob/trunk/split-on-maintainer

It's not perfect, but it'll get you really close. For example, if you
had a single big tree-wide patch applied to your tree:

$ rm 0*.patch
$ git format-patch -1 HEAD
$ mv 0*.patch treewide.patch
$ split-on-maintainer treewide.patch
$ ls 0*.patch

If you have a build log before the patch that spits out warnings, the
--build-log argument can extract those warnings on a per-file basis, too
(though this can be fragile).

-- 
Kees Cook
