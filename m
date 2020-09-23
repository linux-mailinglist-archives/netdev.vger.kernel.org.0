Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 824D12763CB
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 00:28:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbgIWW2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Sep 2020 18:28:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726199AbgIWW2T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Sep 2020 18:28:19 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0864C0613CE;
        Wed, 23 Sep 2020 15:28:19 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id mn7so458568pjb.5;
        Wed, 23 Sep 2020 15:28:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sJ2mZrlECHBGc2a4+45pHky1WLWiPGvoUFxfZgT87hc=;
        b=W5G9Loej5h/m/wYHmX+rVTxiw9/qNIffGs8Qmi5NvIITo9hW/0M6GC/onU3f5FSg6V
         JAjLt3eNdGHtrz/BO5bCV7Fc5RFWUrbKRo0t93L6PaHvpuFLoAWhJAFbc+xqbco6BCT5
         wbVWB+YQicqtwQGEfPAaa7JvJfUj566PMG3HnSCsmZX6MtNFrf0ZqLDXFDaCMJufU8zQ
         lt3wRubRyd9eGUQOfQEQGJRKqnkAWZF2sK3ZQCv2uVLJeLAEay1o+BGaAmZLWJWSH9vl
         RllZfuXbeuYlNULObFJbtzr/6g98edQ5rLS3PmrbvlK906WRLDtU/0VG8c7xBYBhVGTa
         CzsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sJ2mZrlECHBGc2a4+45pHky1WLWiPGvoUFxfZgT87hc=;
        b=h4xF7+e5I5/m28qFm8qRv2qhmXlNkRYRQkluV+iKZAyGe15qBFN9ljrGz1bt8uh2Ot
         1QuIGOuLK0H6RXh3Mkhim3FY0icNZCvkx1xsAUacAdn4leOXOjGkF7S6zCpj1mUpgvnh
         uOkzsxFJOHKytBQYsgAwNo4cAUiFhjJzeRiTrmafJz3II79oVVRQEPNe5A6CpLCIsVSd
         z5yZ2bysWPKJBuQ+XelSh2iCPxkfm7jplV05phQD33JnjXAhtAc7p6n+CQgUG8A3JsFw
         OFzeXkr3zOB1jRDki0oI3WBIcvRw0sBVrtkrQCT1yziIvwL9u/pT5HC2lGXxRwpP0tqA
         ZevQ==
X-Gm-Message-State: AOAM533VLvZG52TxLxyDECknKxvWb/QB4kGxHS85BfrK/1RwnrJsanx+
        jxrhiHSFzB1zpBPaJcd+NLI=
X-Google-Smtp-Source: ABdhPJwMz08V21Thf8KfK8lnUcLBOsj6yxA2QG4Wq0J3l5/LR3f2eLzenMzdgFPukzFG1tX2xi48HQ==
X-Received: by 2002:a17:902:7c01:b029:d2:29fc:9a93 with SMTP id x1-20020a1709027c01b02900d229fc9a93mr1724786pll.84.1600900098685;
        Wed, 23 Sep 2020 15:28:18 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:1807])
        by smtp.gmail.com with ESMTPSA id m12sm405916pjs.34.2020.09.23.15.28.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2020 15:28:17 -0700 (PDT)
Date:   Wed, 23 Sep 2020 15:28:12 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Song Liu <songliubraving@fb.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: Keep bpf-next always open
Message-ID: <20200923222812.oxhp6zznwdnkiffs@ast-mbp.dhcp.thefacebook.com>
References: <CAADnVQ+DQ9oLXXMfmH1_p7UjoG=p9x7y0GDr7sWhU=GD8pj_BA@mail.gmail.com>
 <CAEf4BzbqXHQmwJstrxU3ji5Vrb0XVwp17b7bGjRAy=jCOtaUfQ@mail.gmail.com>
 <20200923221415.jxy6hcpqusodpqsr@ast-mbp.dhcp.thefacebook.com>
 <7DAA1D76-860C-4058-9D5F-7A87DB45B8C8@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7DAA1D76-860C-4058-9D5F-7A87DB45B8C8@fb.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 23, 2020 at 10:23:51PM +0000, Song Liu wrote:
> 
> 
> > On Sep 23, 2020, at 3:14 PM, Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> > 
> > On Wed, Sep 23, 2020 at 02:48:24PM -0700, Andrii Nakryiko wrote:
> >> On Wed, Sep 23, 2020 at 2:20 PM Alexei Starovoitov
> >> <alexei.starovoitov@gmail.com> wrote:
> >>> 
> >>> BPF developers,
> >>> 
> >>> The merge window is 1.5 weeks away or 2.5 weeks if rc8 happens. In the past we
> >>> observed a rush of patches to get in before bpf-next closes for the duration of
> >>> the merge window. Then there is a flood of patches right after bpf-next
> >>> reopens. Both periods create unnecessary tension for developers and maintainers.
> >>> In order to mitigate these issues we're planning to keep bpf-next open
> >>> during upcoming merge window and if this experiment works out we will keep
> >>> doing it in the future. The problem that bpf-next cannot be fully open, since
> >>> during the merge window lots of trees get pulled by Linus with inevitable bugs
> >>> and conflicts. The merge window is the time to fix bugs that got exposed
> >>> because of merges and because more people test torvalds/linux.git than
> >>> bpf/bpf-next.git.
> >>> 
> >>> Hence starting roughly one week before the merge window few risky patches will
> >>> be applied to the 'next' branch in the bpf-next tree instead of
> >> 
> >> Riskiness would be up to maintainers to determine or should we mark
> >> patches with a different tag (bpf-next-next?) explicitly?
> > 
> > "Risky" in a sense of needing a revert. The bpf tree and two plus -rc1 to -rc7
> > weeks should be enough to address any issues except the most fundamental ones.
> > Something like the recent bpf_tail_call support in subprograms I would consider
> > for the "next" branch if it was posted a day before the merge window.
> > In practice, I suspect, such cases will be rare.
> > 
> > I think bpf-next-next tag should not be used. All features are for [bpf-next].
> > Fixes are for [bpf]. The bpf-next/next is a temporary parking place for patches
> > while the merge window is ongoing.
> 
> I wonder whether we can move/rename the branch around so that the developers can 
> always base their work on bpf-next/master. Something like:
> 
> Long before merge window for 5.15:	
> We only have bpf-next/master
> 
> 1 week before merge window for 5.15:	
> Clone bpf-next/master as bpf-next/for-5.15
> 
> From -1 week to the end of merge window
> Risky features only goes to bpf-next/master, bug fix goes in both master and for-5.15
> 
> After merge window:
> Fast forward bpf-next/master based on net-next. Deprecate for-5.15.
> 
> Would this work? 

It will create headaches for linux-next that merges bpf-next/master.
All linux-next trees should not add patches to those trees that are not going
into the merge window.
