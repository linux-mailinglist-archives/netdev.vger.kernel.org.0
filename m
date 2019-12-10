Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 792DD119934
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 22:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729929AbfLJVoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 16:44:12 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33654 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728196AbfLJVoJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 16:44:09 -0500
Received: by mail-pf1-f195.google.com with SMTP id y206so500759pfb.0
        for <netdev@vger.kernel.org>; Tue, 10 Dec 2019 13:44:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fomichev-me.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rbDSY7BhbJlGS6xc6VP5L8tKfoVk8+COFSDA6dXVjXU=;
        b=Opz6Maozl5h7QbetuxnDAJFYxvAdJLiYDedHjKHToRukFk/7EvtjEfzg7QPPlJOYrZ
         MJUbx2xz2D/RAp5XlyqcTD2ZSWAW7H/qg/5L3B3tTvJHIWER9e/6ND8Szlxqk2xHJhzi
         5o5Jl/4oQugEo6HZ/8FxbUR7h//v2UGEm0l+BEG+roaUApZiOOTtdVoDRpJjhdnyGUKT
         /7z8OXhudAgyNoLlFZ+VVWxFiumpQALAlStmZ/sYhgygl/kp7kYmejfV0/7fKvWvCFfc
         yXtWaVd3u+FscEs2zprTWQuN4XWNGe7QtIBmZJ+aBVhzud87lVTWdAsmxmGEkDlCVHlU
         vrgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rbDSY7BhbJlGS6xc6VP5L8tKfoVk8+COFSDA6dXVjXU=;
        b=PsgYRmQefiyqcc+j6k2uWZgAySE2XCNYhXFSaJMBdFgAMKaQmkC0YLleo1OCx8BUJR
         vfYbM8NwdxL/cYJ/S2XYxzfkdy7iHRafbhI//4e55+dJWqKkN0osd8qJwM+ha+Fhx1v5
         iVMjM6tw+9b7ZoadQNBbQYKKbd6WzxTUnEWSX45K3dINsNeYxEoLEbDK3iZOQcuKC+uc
         iApqqa8nvzjgmg5Ns18iGYAkpvD2FYP2UgaCc95Orhgg/gv7+gNb7lL2fW+PnobT4vug
         XMKu5tOwiP45e3fPa/uN/8hEi002HES6dMAyGDSbHMb5h7Q5Bt8FDmgkuyhWSt4VxKZM
         0cBg==
X-Gm-Message-State: APjAAAW41oarPhSDLdiOxp7a1GaSa8IxennH+79uns53FWwExz9omNTF
        k+UiqQhatDk2zHPAySbl3rDEgg==
X-Google-Smtp-Source: APXvYqzFb8FwEWyCqj/CK3r9T7XNwfUPPcS3Ncv1VkU4Br0WAOSshQ59ny7UTrZIkpCSpfrnXnY7aw==
X-Received: by 2002:a63:696:: with SMTP id 144mr294509pgg.260.1576014249158;
        Tue, 10 Dec 2019 13:44:09 -0800 (PST)
Received: from localhost ([2601:646:8f00:18d9:d0fa:7a4b:764f:de48])
        by smtp.gmail.com with ESMTPSA id q13sm3900429pjc.4.2019.12.10.13.44.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Dec 2019 13:44:08 -0800 (PST)
Date:   Tue, 10 Dec 2019 13:44:07 -0800
From:   Stanislav Fomichev <sdf@fomichev.me>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 11/15] bpftool: add skeleton codegen command
Message-ID: <20191210214407.GA3105713@mini-arch>
References: <20191210011438.4182911-1-andriin@fb.com>
 <20191210011438.4182911-12-andriin@fb.com>
 <20191209175745.2d96a1f0@cakuba.netronome.com>
 <CAEf4Bzaow7w+TGyiF67pXn42TumxFZb7Q4BOQPPGfRJdyeY-ig@mail.gmail.com>
 <20191210100536.7a57d5e1@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191210100536.7a57d5e1@cakuba.netronome.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/10, Jakub Kicinski wrote:
> On Tue, 10 Dec 2019 09:11:31 -0800, Andrii Nakryiko wrote:
> > On Mon, Dec 9, 2019 at 5:57 PM Jakub Kicinski wrote:
> > > On Mon, 9 Dec 2019 17:14:34 -0800, Andrii Nakryiko wrote:  
> > > > struct <object-name> {
> > > >       /* used by libbpf's skeleton API */
> > > >       struct bpf_object_skeleton *skeleton;
> > > >       /* bpf_object for libbpf APIs */
> > > >       struct bpf_object *obj;
> > > >       struct {
> > > >               /* for every defined map in BPF object: */
> > > >               struct bpf_map *<map-name>;
> > > >       } maps;
> > > >       struct {
> > > >               /* for every program in BPF object: */
> > > >               struct bpf_program *<program-name>;
> > > >       } progs;
> > > >       struct {
> > > >               /* for every program in BPF object: */
> > > >               struct bpf_link *<program-name>;
> > > >       } links;
> > > >       /* for every present global data section: */
> > > >       struct <object-name>__<one of bss, data, or rodata> {
> > > >               /* memory layout of corresponding data section,
> > > >                * with every defined variable represented as a struct field
> > > >                * with exactly the same type, but without const/volatile
> > > >                * modifiers, e.g.:
> > > >                */
> > > >                int *my_var_1;
> > > >                ...
> > > >       } *<one of bss, data, or rodata>;
> > > > };  
> > >
> > > I think I understand how this is useful, but perhaps the problem here
> > > is that we're using C for everything, and simple programs for which
> > > loading the ELF is majority of the code would be better of being
> > > written in a dynamic language like python?  Would it perhaps be a
> > > better idea to work on some high-level language bindings than spend
> > > time writing code gens and working around limitations of C?  
> > 
> > None of this work prevents Python bindings and other improvements, is
> > it? Patches, as always, are greatly appreciated ;)
> 
> This "do it yourself" shit is not really funny :/
> 
> I'll stop providing feedback on BPF patches if you guy keep saying 
> that :/ Maybe that's what you want.
> 
> > This skeleton stuff is not just to save code, but in general to
> > simplify and streamline working with BPF program from userspace side.
> > Fortunately or not, but there are a lot of real-world applications
> > written in C and C++ that could benefit from this, so this is still
> > immensely useful. selftests/bpf themselves benefit a lot from this
> > work, see few of the last patches in this series.
> 
> Maybe those applications are written in C and C++ _because_ there 
> are no bindings for high level languages. I just wish BPF programming
> was less weird and adding some funky codegen is not getting us closer
> to that goal.
> 
> In my experience code gen is nothing more than a hack to work around
> bad APIs, but experiences differ so that's not a solid argument.
*nod*

We have a nice set of C++ wrappers around libbpf internally, so we can do
something like BpfMap<key type, value type> and get a much better interface
with type checking. Maybe we should focus on higher level languages instead?
We are open to open-sourcing our C++ bits if you want to collaborate.

(I assume most of the stuff you have at fb is also non-c and one of
c++/python/php/rust/go/whatver).
