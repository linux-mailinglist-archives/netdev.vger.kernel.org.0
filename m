Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6D8B19A30B
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 02:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731506AbgDAApk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 20:45:40 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:44503 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731331AbgDAApk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 20:45:40 -0400
Received: by mail-qk1-f195.google.com with SMTP id j4so25284631qkc.11;
        Tue, 31 Mar 2020 17:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lInkeLeVPg8RdayxzBR5wEOKKIWrd4M72rmiHCOK8cU=;
        b=PeXzD7LR2jCAFe7Ad9eGF5LyuoaEuqef1FeMg61zDgqv5V7YLH4i8k1mEAGNthCru8
         d7hMevqbLc+HRj5d1ngsxavnfA+1razHVhCZXjM42rD//06K1SHBwcUmabsEn8IFHcSH
         LHLe4zuA2AW5qxy5w4adkQXBLALSdZnaP+RNAbLTNfIQdPCFEm+9MbkC1S0a35r13arD
         GI6TLyFragLvAIqQ1lvW5cVdFJsS6gF4ULQpL21ZSh5F4jlPAx9RwdrUBI3CgUQrHHij
         MW83LiZRt3xXRNFOwuK0tTKnXSy0XS/NcZuNYmRHm+y0RKr3ypSLeFouwPM4+fQ+V87D
         ZV4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lInkeLeVPg8RdayxzBR5wEOKKIWrd4M72rmiHCOK8cU=;
        b=FencUNjTnbginSRwc1BoPR4VxOo1RrdzLUfV9nnZvz+8bZRqXNbq3QC0cfQwInRZP5
         qXEyo34zrMbhvwyb4mhXlcED+lskGVGmcmRuErXJNyuo1I3dRLuorbE0Zlz51157sYGD
         vzYILk4l3bGKut8qBVWGnN+q4rnwm8xu73P9yLzEERSqXQlsrF/IRyN+OvcgvhiJUbwP
         yVZHb7vtRawQTC2TftORKZoJDRNb+bwpqhG0wI2bU5Nz3V9NhqRIEgntrGxFUzfFS02G
         DrziSbB46PIv9zX0UixtKF5Q1ZnA+Tgk82paF/ZYkGUfkCa6rS4K7c66fm1Qv8JRlfDD
         +G6Q==
X-Gm-Message-State: ANhLgQ1FBbwf5VVqOLTjlhFpICtR1N1IRBPo6kbGdayL2di8Co2Ycj5/
        d9vV2h6ivmEGAdrX/UvDQ+MGE+Z1TL8uO45RQDM=
X-Google-Smtp-Source: ADFU+vszO/uHs4D9J/ExNjvt4C3TdJmvztbK2irVeWUwOSDSkwj3ORMGpepoCcGb0dkH6/+atvtS30FMTDgKaVDRGjg=
X-Received: by 2002:a37:6411:: with SMTP id y17mr7982753qkb.437.1585701938757;
 Tue, 31 Mar 2020 17:45:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200330030001.2312810-1-andriin@fb.com> <c9f52288-5ea8-a117-8a67-84ba48374d3a@gmail.com>
 <CAEf4BzZpCOCi1QfL0peBRjAOkXRwGEi_DAW4z34Mf3Tv_sbRFw@mail.gmail.com>
 <662788f9-0a53-72d4-2675-daec893b5b81@gmail.com> <CAADnVQK8oMZehQVt34=5zgN12VBc2940AWJJK2Ft0cbOi1jDhQ@mail.gmail.com>
 <cdd576be-8075-13a7-98ee-9bc9355a2437@gmail.com> <20200331003222.gdc2qb5rmopphdxl@ast-mbp>
 <58cea4c7-e832-2632-7f69-5502b06310b2@gmail.com> <CAEf4BzZSCdtSRw9mj2W5Vv3C-G6iZdMJsZ8WGon11mN3oBiguQ@mail.gmail.com>
 <869adb74-5192-563d-0e8a-9cb578b2a601@solarflare.com> <b5526d61-9af9-1f10-bf20-38cf8a2f10fd@gmail.com>
In-Reply-To: <b5526d61-9af9-1f10-bf20-38cf8a2f10fd@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 31 Mar 2020 17:45:27 -0700
Message-ID: <CAEf4Bzb8Lt7xca9OJv-+-jYctypTQV1a7LFhTn6G+cAqEPF_9A@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 0/4] Add support for cgroup bpf_link
To:     David Ahern <dsahern@gmail.com>
Cc:     Edward Cree <ecree@solarflare.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrey Ignatov <rdna@fb.com>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 31, 2020 at 3:44 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 3/31/20 3:51 PM, Edward Cree wrote:
> > On 31/03/2020 04:54, Andrii Nakryiko wrote:
> >> No need to kill random processes, you can kill only those that hold
> >> bpf_link FD. You can find them using drgn tool with script like [0].
> > For the record, I find the argument "we don't need a query feature,
> >  because you can just use a kernel debugger" *utterly* *horrifying*.
> > Now, it seems to be moot, because Alexei has given other, better
> >  reasons why query doesn't need to land yet; but can we please not
> >  ever treat debugging interfaces as a substitute for proper APIs?
> >
> > </scream>
> > -ed
> >
>
> just about to send the same intent. Dev packages and processing
> /proc/kcore is not a proper observability API for production systems.

I'm not against observability. LINK_QUERY is going to be added. I'm
also looking into making bpf_link into "lookup-able by id" object,
similar to bpf_map and bpf_prog, which will allow to easily just say
"show me all the BPF attachments in the system", which is impossible
to do right now, btw.

As for the drgn and /proc/kcore. drgn is an awesome tool to do lots of
inner kernel API observability stuff, which is impractical to expose
through stable APIs. But you don't have to use it to get the same
effect. The problem that script is solving is to show all the
processes that have open FD to bpf_link files. This is the same
problem fuser command is solving for normal files, but solution is
similar. fuser seems to be doing it iterating over all processes and
its FDs in procfs. Not the most efficient way, but it works. Here's
what you can get for cgroup bpf_link file with my last patch set
already:

# cat /proc/1366584/fdinfo/14
pos:    0
flags:  02000000
mnt_id: 14
link_type:      cgroup
prog_tag:       9ad187367cf2b9e8
prog_id:        1649


We can extend that information further with relevant details. This is
a good and bigger discussion for LINK_QUERY API as well, given it and
fdinfo might be treated as two ways to get same information. This is
one reason I didn't do it for cgroup bpf_link, there are already
enough related discussions to keep us all involved for more than a
week now.

But it would be nice to start discussing and figuring out these
relevant details, instead of being horrified and terrified, and
spreading FUD. Or inventing ways to violate good properties of
bpf_link (e.g., by forceful nuking) due to theoretical worries about
the need to detach bpf_link without finding application or pinned file
that holds it. As Alexei mentioned, what's there already (raw_tp,
tracing, and now cgroup bpf_links) is no worse than what we had
before. By the time we get to XDP bpf_link, we'll have even more
observability capabilities.
