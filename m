Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8235828EC05
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 06:19:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727753AbgJOET4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 00:19:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbgJOETz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 00:19:55 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD690C061755;
        Wed, 14 Oct 2020 21:19:55 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id a1so1132345pjd.1;
        Wed, 14 Oct 2020 21:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gVSnLUVk1GLB2hVSDu0PLKyzafzGj1nmj4X3nD5D/vc=;
        b=Yc+u9PUa314v+KFHP1i/Y2Dzz43KuXxhiI3i9WXptxvSTQKqIOFSjo6qeo3VewWf1U
         /P4nDASbnUCESHiOeiD1cYE3uNTMlntp4gZbil1otN6jKE2JNn6jXRjv3cJRe1oMXfAZ
         49TaztASJ3dQmds+qUFS6dXat+NRfPV4GvBLDdVQwpeiqHZS1hfx7Zvb7+KdEbowF2fs
         ulqbj3zqQ+hGKbdizVYFtQ0aULDU+UIwbSLOY70Wy680StIzxe3+HjHOFaG/T2VstlTT
         TZoa/ZINutXiq/gcxcSEveVrYE2qthkS/HScQ7yQpSG1Z32bOkBFOa+l/ooXD9B2QPzR
         Ymsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=gVSnLUVk1GLB2hVSDu0PLKyzafzGj1nmj4X3nD5D/vc=;
        b=jbUkGffhp9oxk22pRmnM8/Hr0YY3xVeASeIehdESDIJxjahqdrqH/MH7uAnRUGTvLf
         kp3WeNA+9gBM3XO11TgAfDy+yLCcnJv2UyGYKNI7ghnCymWw/O2iZ+Ok2wTddr6H9xP4
         9bPgfBon1asQFUDkGzS0rQiVC3H3ZqRHqA1u/JRlTW1DBP4S2xhUd/k1r134fiJThbqK
         LWv7Lq3QeosvpvbT+DU75a9CqNBFc5PbV4dwqA7HCPe58HzfPX+PVhFY8gecOTT8NuZ/
         HzsviAMRqm0mdQVCVB4HCb/RW50v5aJZdQmXlHJd7KDJgYHMYtvptg1Vv/WcMD8bLVSs
         AEpA==
X-Gm-Message-State: AOAM532bxI7KKr1jNqQjKCaQRdEOlvfPjChTxlvY7IcgDyPKhJYVd3PS
        8Sb7cw1RmufJZITHscrP7ekoDxEq3EajSQ==
X-Google-Smtp-Source: ABdhPJx9matAhHoVO3jbCVEaA4OB4ByW9uqox2W/pfm9qnboRaExfwLy36OYe0B4NDfDWbXhe0XXlA==
X-Received: by 2002:a17:90b:4c8c:: with SMTP id my12mr2309464pjb.129.1602735595247;
        Wed, 14 Oct 2020 21:19:55 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:f594])
        by smtp.gmail.com with ESMTPSA id w6sm1246354pgw.28.2020.10.14.21.19.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2020 21:19:54 -0700 (PDT)
Date:   Wed, 14 Oct 2020 21:19:52 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] bpf: Fix register equivalence tracking.
Message-ID: <20201015041952.n3crk6kvtbgev6rw@ast-mbp.dhcp.thefacebook.com>
References: <20201014175608.1416-1-alexei.starovoitov@gmail.com>
 <CAEf4BzaF2fDWoRg8h3dUKftvcastYqzEhGS2TG6MoV462fd_8Q@mail.gmail.com>
 <5f87ca47436f3_b7602088f@john-XPS-13-9370.notmuch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f87ca47436f3_b7602088f@john-XPS-13-9370.notmuch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 14, 2020 at 09:04:23PM -0700, John Fastabend wrote:
> Andrii Nakryiko wrote:
> > On Wed, Oct 14, 2020 at 10:59 AM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > From: Alexei Starovoitov <ast@kernel.org>
> > >
> > > The 64-bit JEQ/JNE handling in reg_set_min_max() was clearing reg->id in either
> > > true or false branch. In the case 'if (reg->id)' check was done on the other
> > > branch the counter part register would have reg->id == 0 when called into
> > > find_equal_scalars(). In such case the helper would incorrectly identify other
> > > registers with id == 0 as equivalent and propagate the state incorrectly.
> 
> One thought. It seems we should never have reg->id=0 in find_equal_scalars()
> would it be worthwhile to add an additional check here? Something like,
> 
>   if (known_reg->id == 0)
> 	return
>
> Or even a WARN_ON_ONCE() there? Not sold either way, but maybe worth thinking
> about.

That cannot happen anymore due to
if (dst_reg->id && !WARN_ON_ONCE(dst_reg->id != other_branch_regs[insn->dst_reg].id))
check in the caller.
I prefer not to repeat the same check twice. Also I really don't like defensive programming.
if (known_reg->id == 0)
       return;
is exactly that.
If we had that already, as Andrii argued in the original thread, we would have
never noticed this issue. <, >, <= ops would have worked, but == would be
sort-of working. It would mark one branch instead of both, and sometimes
neither of the branches. I'd rather have bugs like this one hurting and caught
quickly instead of warm feeling of being safe and sailing into unknown.
