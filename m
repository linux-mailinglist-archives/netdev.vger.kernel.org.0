Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D44A520767F
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 17:04:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390702AbgFXPDV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 11:03:21 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:38317 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2390817AbgFXPDP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 11:03:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593010993;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=30pDYT8Ng0r81IjliuA72I3zqGk4RwbQRfnCaFsaG64=;
        b=PjSUIQ1ThQBnwz32YzxwhwpDerzmBcxXlMe150Ma+JzVQuFZ/j0+h4hCFAz3ctkmS0mJFL
        p1gbQSbuJXBXJ9BUtuqaBiqtVj+yXcxCe9B4+onl6gtzvB6ehK4VbVxJ9wnNtW91sZZ5St
        2S85CJ+bj/sL0T0hcnLOV7DfP2WOmEM=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-228-fhyn6TFdPk-1_EmMGpQt9w-1; Wed, 24 Jun 2020 11:03:08 -0400
X-MC-Unique: fhyn6TFdPk-1_EmMGpQt9w-1
Received: by mail-wr1-f72.google.com with SMTP id m14so3074372wrj.12
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 08:03:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=30pDYT8Ng0r81IjliuA72I3zqGk4RwbQRfnCaFsaG64=;
        b=gZFu3bO6LYOK0BMUVmtxgceTYP/BoapHli6SbMFSzICClaxHeM3vj4676wsNHoFw15
         JlWlqVv4X/jp1IsuOU/LV2BsJcOr4O3t4NklUGmwQ/0ma9zihH5Pis1ofiYKextl0VhC
         3yfsABzQrdOv6UpAfLhCLixkwQbBRMhb+WTl0MgM9do3anUK0pUT1NzLEot8h13DhqPh
         /P+J3KUl5aUwd1oaK0cxO4oFFqVHjakSkHDoYKrwQvVk8SFfZ9aJl6Yvrs2hhvEcQRJF
         Bmx8lb+Bbx3/HuYPj9d0c8tHdjaEvvGVGbM26TpL5a0dswRe5tWxhk6TMcLWqcW4CYte
         U1rA==
X-Gm-Message-State: AOAM531H6KrqMRqCtEF5x/RZAfYJFiTSzYYfpGIpZSrI+JQH4J6u5Ggr
        J0nyehucTzU08/0yZ+m8vk0amQJOne0ROrrnGD9Z3pyCxXihGC07kAngikNJWi/YuJ+zwTWEqbv
        Zbx+MMR1Y15cd0WuT
X-Received: by 2002:adf:f30a:: with SMTP id i10mr30039939wro.134.1593010987331;
        Wed, 24 Jun 2020 08:03:07 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJziWv81T1I6WoyMbAjknlqxHwvb5Nf0z9o3gQiF5tywoAcO3lD3zeSKSYJ/YBL+Rj/NtIlz+w==
X-Received: by 2002:adf:f30a:: with SMTP id i10mr30039915wro.134.1593010987082;
        Wed, 24 Jun 2020 08:03:07 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id e4sm1191951wrt.97.2020.06.24.08.03.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 08:03:06 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 1DF741814F2; Wed, 24 Jun 2020 17:03:06 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] libbpf: add debug message for each created program
In-Reply-To: <20200624145235.73mysssbdew7eody@ast-mbp.dhcp.thefacebook.com>
References: <20200624003340.802375-1-andriin@fb.com> <CAADnVQJ_4WhyK3UvtzodMrg+a-xQR7bFiCCi5nz_qq=AGX_FbQ@mail.gmail.com> <CAEf4BzYKV=A+Sd1ByA2=7CG7WJedB0CRAU7RGN6jO8B9ykpHiA@mail.gmail.com> <20200624145235.73mysssbdew7eody@ast-mbp.dhcp.thefacebook.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 24 Jun 2020 17:03:06 +0200
Message-ID: <874kr0jyl1.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Tue, Jun 23, 2020 at 11:59:40PM -0700, Andrii Nakryiko wrote:
>> On Tue, Jun 23, 2020 at 11:47 PM Alexei Starovoitov
>> <alexei.starovoitov@gmail.com> wrote:
>> >
>> > On Tue, Jun 23, 2020 at 5:34 PM Andrii Nakryiko <andriin@fb.com> wrote:
>> > >
>> > > Similar message for map creation is extremely useful, so add similar for BPF
>> > > programs.
>> >
>> > 'extremely useful' is quite subjective.
>> > If we land this patch then everyone will be allowed to add pr_debug()
>> > everywhere in libbpf with the same reasoning: "it's extremely useful pr_debug".
>> 
>> We print this for maps, making it clear which maps and with which FD
>> were created. Having this for programs is just as useful. It doesn't
>> overwhelm output (and it's debug one either way). "everyone will be
>> allowed to add pr_debug()" is a big stretch, you can't just sneak in
>> or force random pr_debug, we do review patches and if something
>> doesn't make sense we can and we do reject it, regardless of claimed
>> usefulness by the patch author.
>> 
>> So far, libbpf debug logs were extremely helpful (subjective, of
>> course, but what isn't?) to debug "remotely" various issues that BPF
>> users had. They don't feel overwhelmingly verbose and don't have a lot
>> of unnecessary info. Adding a few lines (how many BPF programs are
>> there per each BPF object?) for listing BPF programs is totally ok.
>
> None of the above were mentioned in the commit log.
> And no examples were given where this extra line would actually help.
>
> I think libbpf pr_debug is extremely verbose instead of extremely useful.
> Just typical output:
> ./test_progs -vv -t lsm
> libbpf: loading object 'lsm' from buffer
> libbpf: section(1) .strtab, size 306, link 0, flags 0, type=3
> libbpf: skip section(1) .strtab
> libbpf: section(2) .text, size 0, link 0, flags 6, type=1
> libbpf: skip section(2) .text
> libbpf: section(3) lsm/file_mprotect, size 192, link 0, flags 6, type=1
> libbpf: found program lsm/file_mprotect
> libbpf: section(4) .rellsm/file_mprotect, size 32, link 25, flags 0, type=9
> libbpf: section(5) lsm/bprm_committed_creds, size 104, link 0, flags 6, type=1
> libbpf: found program lsm/bprm_committed_creds
> libbpf: section(6) .rellsm/bprm_committed_creds, size 32, link 25, flags 0, type=9
>
> How's above useful for anyone?
> libbpf says that there are '.strtab' and '.text' sections in the elf file.
> That's wet water. Any elf file has that.
> Then it says it's skipping '.text' ?
> That reads surprising. Why library would skip the code?
> And so on and so forth.
> That output is useful to only few core libbpf developers.
>
> I don't mind more thought through debug prints, but
> saying that existing pr_debugs are 'extremely useful' is a stretch.

Agreed. I had to demote libbpf debug output to an (additional) 'verbose'
level in xdp-tools because there was just too much output.

Personally I think the additional 'program loading succeeded' message
would be useful *if* some of the more verbose stuff (like what you
posted above) was cleared out.

-Toke

