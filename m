Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 25E11198977
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 03:18:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729429AbgCaBSA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 21:18:00 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46615 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729129AbgCaBSA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 21:18:00 -0400
Received: by mail-pf1-f195.google.com with SMTP id q3so9493133pff.13;
        Mon, 30 Mar 2020 18:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DSaOJ3abayD3uGemvDsixWnPIKpqupYRWw3fhQo7n4s=;
        b=dYOMM7Vj6fU+DQoy+rs2zDpNXacWuFjsZN4+ECwqTvDikH0cbcAymLZIrEuvXvjd5u
         sVipVQ5LLJYPaecxrU2InmhZ+KdyOZ3gXew90hMU5U7ER4azlnpncbpb8saQcX+lv+D2
         BI7Tbb5l6xsr7LVY6SP2ZzzCq+u182CsAzK7f4wg5uTZNfsb2qJG1EenGuIV30VeVSEW
         oHQwXqGbjl+TyP9n3lCMY7TBknYbVkkKx9UxstpC9t7SuZg1GZEcZbEnsKGTnlWSjEXn
         Y8XEqzQ7A2MV6eGK8M8hJsI8GyThC4Vr5zc1eN11yr653EkSZhWVT51QsQrFsTgRNF5W
         APrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DSaOJ3abayD3uGemvDsixWnPIKpqupYRWw3fhQo7n4s=;
        b=t6O3H/9ag8291djowV99O6WQu2EzO4xChWHLTK3oBHa8gLhCK85FKOM4SVo8tUZDzg
         KVpfPZhoxqVSyymfRWgJd3aATHiShCWkHcu0z9dcnNwJQXD9pivbjlOYB0LQgcqmyHHQ
         umqVMel/5e0f4ZcQp9BfkXiJxEExVcY1wP25+X/FYf1qrUw8/HeEqrFSEq6I4TCJTiO+
         wOvYIm9O/ryJMNREfaSIMHRlq5oJsuYLZMLMy0r5QbpjA69q+N5+XTbDpC2sUDvchO4Q
         aR3AAgp/SE/vfs6iBzJscAOSBSK7PtzId/f+CyvnrgaBWRozgAOIjZiNn0XwIztB3lvj
         gGUg==
X-Gm-Message-State: ANhLgQ3Y+28/igEDnwkyOQUEegg5BZOYg+3Vr2cb9wwVNe5KcEWOdejR
        sQF9SVXXQHcu/Py+qdvJixhvCYjN
X-Google-Smtp-Source: ADFU+vvMlpryZZFebgAPAsMNe1n+/3VmOc33RWh8F4BpGhMGQmZFY8xCOHrMnaR9VPamYB2CMzSgnQ==
X-Received: by 2002:a62:834c:: with SMTP id h73mr15849495pfe.59.1585617479048;
        Mon, 30 Mar 2020 18:17:59 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:3558])
        by smtp.gmail.com with ESMTPSA id s22sm97462pfh.18.2020.03.30.18.17.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Mar 2020 18:17:57 -0700 (PDT)
Date:   Mon, 30 Mar 2020 18:17:53 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrey Ignatov <rdna@fb.com>, Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v3 bpf-next 0/4] Add support for cgroup bpf_link
Message-ID: <20200331011753.qxo3pq6ldqm43bo7@ast-mbp>
References: <20200330030001.2312810-1-andriin@fb.com>
 <c9f52288-5ea8-a117-8a67-84ba48374d3a@gmail.com>
 <CAEf4BzZpCOCi1QfL0peBRjAOkXRwGEi_DAW4z34Mf3Tv_sbRFw@mail.gmail.com>
 <662788f9-0a53-72d4-2675-daec893b5b81@gmail.com>
 <CAADnVQK8oMZehQVt34=5zgN12VBc2940AWJJK2Ft0cbOi1jDhQ@mail.gmail.com>
 <cdd576be-8075-13a7-98ee-9bc9355a2437@gmail.com>
 <20200331003222.gdc2qb5rmopphdxl@ast-mbp>
 <58cea4c7-e832-2632-7f69-5502b06310b2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <58cea4c7-e832-2632-7f69-5502b06310b2@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 30, 2020 at 06:57:44PM -0600, David Ahern wrote:
> On 3/30/20 6:32 PM, Alexei Starovoitov wrote:
> >>
> >> This is not a large feature, and there is no reason for CREATE/UPDATE -
> >> a mere 4 patch set - to go in without something as essential as the
> >> QUERY for observability.
> > 
> > As I said 'bpftool cgroup' covers it. Observability is not reduced in any way.
> 
> You want a feature where a process can prevent another from installing a
> program on a cgroup. How do I learn which process is holding the
> bpf_link reference and preventing me from installing a program? Unless I
> have missed some recent change that is not currently covered by bpftool
> cgroup, and there is no way reading kernel code will tell me.

No. That's not the case at all. You misunderstood the concept.

> That is my point. You are restricting what root can do and people will
> not want to resort to killing random processes trying to find the one
> holding a reference. 

Not true either.
bpf_link = old attach with allow_multi (but with extra safety for owner)
The only thing bpf_link protects is the owner of the link from other
processes of nuking that link.
It does _not_ prevent other processes attaching their own cgroup-bpf progs
either via old interface or via bpf_link.

It will be different for xdp where only one prog is allowed per xdp hook.
There it will prevent other xdp progs. And there link_queury and
"human override" will be necessary.
