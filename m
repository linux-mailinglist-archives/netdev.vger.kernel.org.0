Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB1CA75DE
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 23:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbfICVBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 17:01:33 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39159 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbfICVBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 17:01:32 -0400
Received: by mail-pg1-f193.google.com with SMTP id u17so9887948pgi.6;
        Tue, 03 Sep 2019 14:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/I2e5TZ3s/EGP5RsRiT47mqjf+UrF/Gzo0wfYyDpaaI=;
        b=X/dpUKHv++MPBzNvn4zAjK8IhWSn8gIQ7U0iSjlZ4aKBc8ZafEC9tbypHFG4V7uvw4
         2qo6EIfGHjr9cDKUN4fx1Bs1xylwbu/Ux4ER/386hSoWlpWyDgJaRCp+rfQ2ZdpkiDfM
         +Khy/j8oxyGcfkXgJYJH8mZVzuebWLoCcXo3Ltk3UK0cR/mKMiLArPFTbQdNOhHG80t5
         V2/MeM7QHoDsReyqyScYMH3mVWXQmHHqJe9zkv+1lI64JdCLfpV0E0IF7K/g4tlx32ji
         vbeR8ZMOzwVcSUmrjCQLadRqa/9hV8+To0co0mjoat0pp171q/ih25i0CeupOkytBagR
         XqkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=/I2e5TZ3s/EGP5RsRiT47mqjf+UrF/Gzo0wfYyDpaaI=;
        b=Fj+uCvV8tPk2Q9qPp/OjV4L+T2ZeBbgXCd50OEKftLrZQkfH7ifAZZMS4uRAqKay1X
         6Z6TIXiB1d28WzYi9L2s2dOe2NyQ3j5gTMTVU7d4svulAxoZ33T9Dmh1FU/opJZM6gs+
         jgebNnjyECrfCIDlQZeunojDix1sMfNVGQU2WDMd1FzjnqJqtMbsAyWjwaJWX7RP5ckJ
         9srrY3DsmBF+xC697R+8hmEBhaHO6dwU8oyg95Lz8tq43CXxPnMrc2P5TY0ZGdmDylKv
         56jeAmS8BgAuqnwWvEBlsynKX2V/7FKudeb0R/0YQ73uY6wJ9tDXnRrP79bNVI48Gfr5
         7tVg==
X-Gm-Message-State: APjAAAX2T8CJ5wD/p52Lz1iWTCX35oxZ9kPcUxp+1FA0PSBjhB5+Edwx
        +T3ywCHM3ox+J25Xqm5kJeg=
X-Google-Smtp-Source: APXvYqx+epiJvfw96CKWo6ZMpR/XivQEWPwJFsivkwF5rP/Vk8ST8wBLkSh4ckibAud7gnyxmmsN2Q==
X-Received: by 2002:a63:5c1a:: with SMTP id q26mr15139320pgb.19.1567544491733;
        Tue, 03 Sep 2019 14:01:31 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:200::3:58a9])
        by smtp.gmail.com with ESMTPSA id i137sm19146782pgc.4.2019.09.03.14.01.30
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Sep 2019 14:01:30 -0700 (PDT)
Date:   Tue, 3 Sep 2019 14:01:29 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Yonghong Song <yhs@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Brian Vazquez <brianvv@google.com>,
        Alexei Starovoitov <ast@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 00/13] bpf: adding map batch processing support
Message-ID: <20190903210127.z6mhkryqg6qz62dq@ast-mbp.dhcp.thefacebook.com>
References: <20190829064502.2750303-1-yhs@fb.com>
 <20190829113932.5c058194@cakuba.netronome.com>
 <CAMzD94S87BD0HnjjHVmhMPQ3UijS+oNu+H7NtMN8z8EAexgFtg@mail.gmail.com>
 <20190829171513.7699dbf3@cakuba.netronome.com>
 <20190830201513.GA2101@mini-arch>
 <eda3c9e0-8ad6-e684-0aeb-d63b9ed60aa7@fb.com>
 <20190830211809.GB2101@mini-arch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190830211809.GB2101@mini-arch>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 30, 2019 at 02:18:09PM -0700, Stanislav Fomichev wrote:
> > > 
> > > I personally like Jakub's/Quentin's proposal more. So if I get to choose
> > > between this series and Jakub's filter+dump in BPF, I'd pick filter+dump
> > > (pending per-cpu issue which we actually care about).
> > > 
> > > But if we can have both, I don't have any objections; this patch

I think we need to have both.
imo Jakub's and Yonghong's approach are solving slightly different cases.

filter+dump via program is better suited for LRU map walks where filter prog
would do some non-trivial logic.
Whereas plain 'delete all' or 'dump all' is much simpler to use without
loading yet another prog just to dump it.
bpf infra today isn't quite ready for this very short lived auxiliary progs.
At prog load pages get read-only mapping, tlbs across cpus flushed,
kallsyms populated, FDs allocated, etc.
Loading the prog is a heavy operation. There was a chatter before to have
built-in progs. This filter+dump could benefit from builtin 'allow all'
or 'delete all' progs, but imo that complicates design and asks even
more questions than it answers. Should this builtin progs show up
in 'bpftool prog show' ? When do they load/unload? Same safety requirements
as normal progs? etc.
imo it's fine to have little bit overlap between apis.
So I think we should proceed with both batching apis.

Having said that I think both are suffering from the important issue pointed out
by Brian: when kernel deletes an element get_next_key iterator over hash/lru
map will produce duplicates.
The amount of duplicates can be huge. When batched iterator is slow and
bpf prog is doing a lot of update/delete, there could be 10x worth of duplicates,
since walk will resume from the beginning.
User space cannot be tasked to deal with it.
I think this issue has to be solved in the kernel first and it may require
different batching api.

One idea is to use bucket spin_lock and batch process it bucket-at-a-time.
From api pov the user space will tell kernel:
- here is the buffer for N element. start dump from the beginning.
- kernel will return <= N elements and an iterator.
- user space will pass this opaque iterator back to get another batch
For well behaved hash/lru map there will be zero or one elements per bucket.
When there are 2+ the batching logic can process them together.
If 'lookup' is requested the kernel can check whether user space provided
enough space for these 2 elements. If not abort the batch earlier.
get_next_key won't be used. Instead some sort of opaque iterator
will be returned to user space, so next batch lookup can start from it.
This iterator could be the index of the last dumped bucket.
This idea won't work for pathological hash tables though.
A lot of elements in a single bucket may be more than room for single batch.
In such case iterator will get stuck, since num_of_elements_in_bucket > batch_buf_size.
May be special error code can be used to solve that?

I hope we can come up with other ideas to have a stable iterator over hash table.
Let's use email to describe the ideas and upcoming LPC conference to
sort out details and finalize the one to use.

