Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B94320761C
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 16:52:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404010AbgFXOwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 10:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403998AbgFXOwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 10:52:40 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A201C061573;
        Wed, 24 Jun 2020 07:52:39 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id cm23so1252932pjb.5;
        Wed, 24 Jun 2020 07:52:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fOLDKqzIW3CYjRBee9F+nMiLkzzr2nCu5CkBFKnlBa0=;
        b=avLEVKQmaST9Rweu7Q5bW6VQLtgqRFCjKQ8vSOyLnMZkJECDki6u337HKv+VAXPcGP
         0LUNjDs3jWnno1gpBn0XMfHZ93hh4hsd5fAjbyYPwb1SspY4EzeJXwjKRQdO+pXEurvq
         hzbkhiYWGrzOIBjTaT4d5v6ARvXUV4Mfru7pkofivoX6INrfWVP332eBKZMdw3aoB5uu
         ZTLwMq6s+AXCB8q2fcl0MWh7KhtBFK/Hk+adbxUBmsC2vJ20nPXxcOFb9adqbjMB95Vz
         jd18yKgT29/pmTwZh2ZXP42lk38JaVhG1R3lRqtYXTMMeIL4mNeN+vt91Bm0saWCFzuJ
         4hCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fOLDKqzIW3CYjRBee9F+nMiLkzzr2nCu5CkBFKnlBa0=;
        b=W9tY1H2hFqYvNAfSveVQVvezyxQx+qV0Qf2omQJ+z1n7Q7v6pT1j2AuKZtwcnidDs6
         hNCc51bkUFCZ7x0St8q4VkdPwHtnZ+soYIAADaL8w9X5XPDzhLf6859xafIPHY4FCbgO
         FEieDszC1xxSlwY666vtSTCwzmjnXJSOU1k/kqjqcsRe4LXQ/4T+vacM80MvpLR6T6F6
         4IsxZzEVVtfKDb1kbarQ9l/hc2ZAtH7oUp8X9PKHOCn4Gf9U3yOmO9gKYsfvZx1Zxqb6
         afGeRyZmEdMU6qQY899e3uegTrA1gZ86X2qTzTb9SF6sSK80hGsqGEP736z3AzLG/C+L
         JAng==
X-Gm-Message-State: AOAM533tkzuRwokrtEvxdRR9VDmgyx9sNW+F8aMNJV36T5+PyO1RtBip
        avjBpguhwsCLYB3OpfcY4M4=
X-Google-Smtp-Source: ABdhPJyFswuggpcL8K0lkr1rIgPRkdyMBXVhF9q5QrMG1m1wgMK2EjMjygn0pkS0t9pxXfs1NNz4Bg==
X-Received: by 2002:a17:90a:32cb:: with SMTP id l69mr6791685pjb.205.1593010358852;
        Wed, 24 Jun 2020 07:52:38 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:d17e])
        by smtp.gmail.com with ESMTPSA id o207sm21167315pfd.56.2020.06.24.07.52.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 07:52:38 -0700 (PDT)
Date:   Wed, 24 Jun 2020 07:52:35 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] libbpf: add debug message for each created
 program
Message-ID: <20200624145235.73mysssbdew7eody@ast-mbp.dhcp.thefacebook.com>
References: <20200624003340.802375-1-andriin@fb.com>
 <CAADnVQJ_4WhyK3UvtzodMrg+a-xQR7bFiCCi5nz_qq=AGX_FbQ@mail.gmail.com>
 <CAEf4BzYKV=A+Sd1ByA2=7CG7WJedB0CRAU7RGN6jO8B9ykpHiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYKV=A+Sd1ByA2=7CG7WJedB0CRAU7RGN6jO8B9ykpHiA@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 11:59:40PM -0700, Andrii Nakryiko wrote:
> On Tue, Jun 23, 2020 at 11:47 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > On Tue, Jun 23, 2020 at 5:34 PM Andrii Nakryiko <andriin@fb.com> wrote:
> > >
> > > Similar message for map creation is extremely useful, so add similar for BPF
> > > programs.
> >
> > 'extremely useful' is quite subjective.
> > If we land this patch then everyone will be allowed to add pr_debug()
> > everywhere in libbpf with the same reasoning: "it's extremely useful pr_debug".
> 
> We print this for maps, making it clear which maps and with which FD
> were created. Having this for programs is just as useful. It doesn't
> overwhelm output (and it's debug one either way). "everyone will be
> allowed to add pr_debug()" is a big stretch, you can't just sneak in
> or force random pr_debug, we do review patches and if something
> doesn't make sense we can and we do reject it, regardless of claimed
> usefulness by the patch author.
> 
> So far, libbpf debug logs were extremely helpful (subjective, of
> course, but what isn't?) to debug "remotely" various issues that BPF
> users had. They don't feel overwhelmingly verbose and don't have a lot
> of unnecessary info. Adding a few lines (how many BPF programs are
> there per each BPF object?) for listing BPF programs is totally ok.

None of the above were mentioned in the commit log.
And no examples were given where this extra line would actually help.

I think libbpf pr_debug is extremely verbose instead of extremely useful.
Just typical output:
./test_progs -vv -t lsm
libbpf: loading object 'lsm' from buffer
libbpf: section(1) .strtab, size 306, link 0, flags 0, type=3
libbpf: skip section(1) .strtab
libbpf: section(2) .text, size 0, link 0, flags 6, type=1
libbpf: skip section(2) .text
libbpf: section(3) lsm/file_mprotect, size 192, link 0, flags 6, type=1
libbpf: found program lsm/file_mprotect
libbpf: section(4) .rellsm/file_mprotect, size 32, link 25, flags 0, type=9
libbpf: section(5) lsm/bprm_committed_creds, size 104, link 0, flags 6, type=1
libbpf: found program lsm/bprm_committed_creds
libbpf: section(6) .rellsm/bprm_committed_creds, size 32, link 25, flags 0, type=9

How's above useful for anyone?
libbpf says that there are '.strtab' and '.text' sections in the elf file.
That's wet water. Any elf file has that.
Then it says it's skipping '.text' ?
That reads surprising. Why library would skip the code?
And so on and so forth.
That output is useful to only few core libbpf developers.

I don't mind more thought through debug prints, but
saying that existing pr_debugs are 'extremely useful' is a stretch.
