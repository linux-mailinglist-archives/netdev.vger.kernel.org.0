Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33406100201
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 11:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbfKRKEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 05:04:07 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:36887 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbfKRKEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 05:04:06 -0500
Received: by mail-qk1-f194.google.com with SMTP id e187so13858800qkf.4;
        Mon, 18 Nov 2019 02:04:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NtQxqImxwG5Gkl+gjb24/9kDbX1IEiB4sD+MZB0qlbE=;
        b=A6oNDUKAaZvb7J2KaX5xkUzbp8hi+5ElRFsjcJcbpIPei8N2XDDstF1hlxOlEKIop7
         MVXfBa6wBhVlEdojLdFLEecNfgeVReA0LUFAYd9OCKTkwHjOVjOkzamI6djwnNO67EnW
         xMS4LGASwj3ufpjtssoJSfv9DWmV3b8kKjjE91MRGOloo8/hFMRoRdnd81WpGTcODA83
         y3NWugqBxmLA0U4CnYXelWloDci0o0v83l4IrgXHyHlqq1qX0iEf3op5ZmtQ/FW0kqMN
         IzGbLtvY7VFfb+ujAQq4VVhCBgSc1RI+snrq03QpZWNxpmum9Cvs6/Q5OYbLOMpD9nsG
         udWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NtQxqImxwG5Gkl+gjb24/9kDbX1IEiB4sD+MZB0qlbE=;
        b=YhXZSjI8R121nQ58mWvxcmIzrIgF4gjiZkAlhfuo3m4OJQHO2Nns2Z5fm8VRPOYvPL
         SDBHQPOLLoSxP8HXx9Phoiucaus+FFk5Y17kj1JgFhifTfZFJREhsPvzoUnD0qcxI9Wj
         NIrxJQItVqR4e8N0EB36wGy6ZzEapDsFp+yTFreuh72lynsjpPRVqzibIaR4f/cRmTOP
         7cEtuxAdbSRe/TrP7DxXktvFRN0dzFZgT1jq1/0UxQ4HORRphifxCfpqVUDhSqQgnpmc
         DcQLekdHO1Mt3GGnNOaX4U807zYr0l4NnQLFB89Csosj0EvfZDaSbKVKplm5yKI0RIKs
         gp8A==
X-Gm-Message-State: APjAAAXC1naAEzrzS66PXB/N5tA602fo8oqj+ogQ7a99PGyTYAw4lT1a
        we9dwBQypBp0yeKCqS+J/tXa07sFHQbp1hRC55U=
X-Google-Smtp-Source: APXvYqyCRqNj9Wg2A7hGA2r+8YzHH97iI4ICE5MVxqlFb0NQjBUMcZsIsIVKxFwPAeszu6yUWctrv0UEPvM7hYyZOcY=
X-Received: by 2002:a37:c44c:: with SMTP id h12mr23379421qkm.218.1574071444584;
 Mon, 18 Nov 2019 02:04:04 -0800 (PST)
MIME-Version: 1.0
References: <20191113204737.31623-1-bjorn.topel@gmail.com> <20191113204737.31623-3-bjorn.topel@gmail.com>
 <20191115003024.h7eg2kbve23jmzqn@ast-mbp.dhcp.thefacebook.com>
 <CAJ+HfNhKWND35Jnwe=99=8rWt81fhy9pRpXCVRYTu=C=aj13KQ@mail.gmail.com> <20191115215832.6d3npfegpp5vhq6u@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191115215832.6d3npfegpp5vhq6u@ast-mbp.dhcp.thefacebook.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Mon, 18 Nov 2019 11:03:53 +0100
Message-ID: <CAJ+HfNhFFkZ+uC+UPdJELgbGoQDbf-t1mqwgqSLOZw_Duk=8Vg@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next 2/4] bpf: introduce BPF dispatcher
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Edward Cree <ecree@solarflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 15 Nov 2019 at 22:58, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
[...]
> > Another thought; I'm using the fentry nop as patch point, so it wont
> > play nice with other users of fentry atm -- but the plan is to move to
> > Steve's *_ftrace_direct work at some point, correct?
>
> Yes. I'll start playing with reg/mod/unreg_ftrace_direct on Monday.
> Steven has a bunch more in his tree for merging, so I cannot just pull
> all of ftrace api features into bpf-next. So "be nice to other fentry users"
> would have to be done during merge window or shortly after in bpf-next tree
> after window closes. I think it's fine.

Yup, I agree.

> In bpf dispatch case it's really
> one dummy function we're talking about. If it was marked 'notrace'
> from get go no one would blink. It's a dummy function not interesting
> for ftrac-ing and not interesting from live patching pov.
>

...but marking it with 'notrace' would remove the __fentry__ nop.
Anyways, the "be nice" approach is OK.
