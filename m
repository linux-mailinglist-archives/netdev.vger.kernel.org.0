Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 631FB1A5819
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 01:28:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730059AbgDKX2D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 19:28:03 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:34511 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729913AbgDKXL3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Apr 2020 19:11:29 -0400
Received: by mail-pg1-f193.google.com with SMTP id l19so760846pgk.1;
        Sat, 11 Apr 2020 16:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xJ+7dDZAFaYEm6wjcx+hXMYxHQMLiS9kCbf4M2RfWXA=;
        b=gsNGDRum/nRnJzPOfEkOGGbfPtBBQa8jla/nY2E2JFPh/C2cNx0epf19r1xuvASvfi
         CctbqG1IqWUfuiggnBcWm5MC/7WKu8boEo5Ok9gcSeF71n3rC0P9L1Cm3slmP+VL9PzB
         +ZYAkbQUnQNjwmKNQGGFAvY9X/q5myrFj6Jw0oljj0Ao8CioH9n8kUCYaizkpiGYJQtd
         Nijokd3UFCP/+vP9x0hbBw1MqUt6XTpdrVcpxuPBWaUBFKNZBp3jcWwaci0x1OxfvEeh
         5kN1++O+8ACQ8lQXoaLOO29+vQxRrOWwKunaxTWoI9uEBybQcHZt/bVhDDZJmKE3gdZ8
         Mm7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xJ+7dDZAFaYEm6wjcx+hXMYxHQMLiS9kCbf4M2RfWXA=;
        b=FFH8S4v2wvRyysutYwJJdZIkIBlXw2T9dz4m8ta3w8Ude6SQ50lZjzCuXNDJJgd/0H
         hjiTbiqxgWAYKV2lB/Wz/T88TowES27QqWvJJ2CnFNRTe5vT7sXqTUO+UTWW97gnsztr
         I12rv8N8axjrgh+jm9YZrqCqJNsa0ruHLj/rjphZiQ4sOb4s3MtezQcMqfqNMr6i1KGI
         k/CYD/yRbQJtmp2uFRLI3ZErEM09HnbL+MEyGKX4e/Svxx3G/Oa2LhSLE1N9j2zk4xJ8
         Dli1bme/niU4gVO1XXo2phwCndb4VTt2g7VhZahG4GCOLPXnkSyydwcI7c9QwGEHIHR9
         F8bw==
X-Gm-Message-State: AGi0PuZNkUFIL++fpJrwuyY26ILgVipgqki13rq+K52BVFTard3R8jYY
        BZQMl7QQndoO4SE38eKIlQU=
X-Google-Smtp-Source: APiQypKzH8Yp2XY3FPt3HOBMNzZYoPOZNixJUZNOdWHf2eI8my1iKzbqJcOEiuWUj2jM4oI/kuq1Vg==
X-Received: by 2002:aa7:9711:: with SMTP id a17mr12219121pfg.143.1586646688670;
        Sat, 11 Apr 2020 16:11:28 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:507f])
        by smtp.gmail.com with ESMTPSA id e10sm4937837pfm.121.2020.04.11.16.11.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Apr 2020 16:11:27 -0700 (PDT)
Date:   Sat, 11 Apr 2020 16:11:25 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [RFC PATCH bpf-next 05/16] bpf: create file or anonymous dumpers
Message-ID: <20200411231125.haqk5by4p34wudn7@ast-mbp>
References: <20200408232520.2675265-1-yhs@fb.com>
 <20200408232526.2675664-1-yhs@fb.com>
 <20200410030017.errh35srmbmd7uk5@ast-mbp.dhcp.thefacebook.com>
 <c34e8f08-c727-1006-e389-633f762106ab@fb.com>
 <CAEf4BzYM3fPUGVmRJOArbxgDg-xMpLxyKPxyiH5RQUbKVMPFvA@mail.gmail.com>
 <2d941e43-72de-b641-22b8-b9ec970ccf52@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d941e43-72de-b641-22b8-b9ec970ccf52@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 10, 2020 at 04:47:36PM -0700, Yonghong Song wrote:
> > 
> > Instead of special-casing dumper_name, can we require specifying full
> > path, and then check whether it is in BPF FS vs BPFDUMP FS? If the
> > latter, additionally check that it is in the right sub-directory
> > matching its intended target type.
> 
> We could. I just think specifying full path for bpfdump is not necessary
> since it is a single user mount...
> 
> > 
> > But honestly, just doing everything within BPF FS starts to seem
> > cleaner at this point...
> 
> bpffs is multi mount, which is not a perfect fit for bpfdump,
> considering mounting inside namespace, etc, all dumpers are gone.

As Yonghong pointed out reusing bpffs for dumpers doesn't look possible
from implementation perspective.
Even if it was possible the files in such mix-and-match file system
would be of different kinds with different semantics. I think that
will lead to mediocre user experience when file 'foo' is cat-able
with nice human output, but file 'bar' isn't cat-able at all because
it's just a pinned map. imo having all dumpers in one fixed location
in /sys/kernel/bpfdump makes it easy to discover for folks who might
not even know what bpf is.
For example when I'm trying to learn some new area of the kernel I might go
poke around /proc and /sys directory looking for a file name that could be
interesting to 'cat'. This is how I discovered /sys/kernel/slab/ :)
I think keeping all dumpers in /sys/kernel/bpfdump/ will make them
similarly discoverable.

re: f_dump flag...
May be it's a sign that pinning is not the right name for such operation?
If kernel cannot distinguish pinning dumper prog into bpffs as a vanilla
pinning operation vs pinning into bpfdumpfs to make it cat-able then something
isn't right about api. Either it needs to be a new bpf syscall command (like
install_dumper_in_dumpfs) or reuse pinning command, but make libbpf specify the
full path. From bpf prog point of view it may still specify only the final
name, but libbpf can prepend the /sys/kernel/bpfdump/.../. May be there is a
third option. Extra flag for pinning just doesn't look right. What if we do
another specialized file system later? It would need yet another flag to pin
there?
