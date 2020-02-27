Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 103041727BF
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 19:38:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729869AbgB0ShI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 13:37:08 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:43350 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729631AbgB0ShI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 13:37:08 -0500
Received: by mail-pg1-f196.google.com with SMTP id u12so120464pgb.10
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 10:37:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=eXGLttUXBQFp+AFTlJgyd1ALZHBMCAVpkgUIjEkYHnA=;
        b=MDb+G4KWRQun93CKXunu73VZHZRwJ8Dy4h3cCac2OhtN9rrr4WM0jL9vfcWoF8B4E7
         LDqaumXs2zR2fLfrQo94f/oavDGkLTOIr1/J1O931XZjWch463CU3Z58cvs1DUVkwrFC
         QFDv2bAovitI39LkzYj1PPBl4YhqK0MpkjaMNX5BROSFyo9QF2KO8ocds3HH3sseDIpF
         +DkELFNPjRVK8m4dN/xsCpC7i8jk0wKGGVVPyaicXjhCHn4sFKk2Ls68MYQmJIgEuQg1
         pSxvmNAr2OXqcYRAQAUF3dwWXkeVTNMhB5tkhMLMEX0G0EG2K/sBXbMdTR3wEcrbSVT1
         p8Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=eXGLttUXBQFp+AFTlJgyd1ALZHBMCAVpkgUIjEkYHnA=;
        b=IMYVpIJoEw0IgPh+sNCybm5DekLGJyp27UJnyHv+PgyHo0iYCfEcfu+tXaTV2AW3fH
         8vvyhR5oGzanDtxkYgrr7tkaSI8mPi0vpNDjvrCdi0Ra0eJa4NAtqI+UH7gygPUiU6qD
         XrEYkngsYLDWYzmgkvG2ZSQ014WF2lawBkKQSb89Yf3BghNC4IkmRDAQiibx3B9hT4pC
         79Id1104yYSTXc2s40sX0MMJ4i0Pi4wQSZkemHJdgB4TvJ3a7vlYFhAw5tqApdfajHC0
         VeRIW/KrruwU+yw5nhut/lFzaxV+q3xlzS2QIcinwAmfgemmBSqnIbxHAz0x1lxAGqSN
         1ZwQ==
X-Gm-Message-State: APjAAAVvcGRVKMpl7GwtXmpW74klmG0maG5YusFjDxkvcte88jOZ1EI6
        +dVQ05a/0V4lygSzqpgzRYY=
X-Google-Smtp-Source: APXvYqwiafEs0JyXtI57JIeixjQh7fzLfYaFI8q6h92gwLqMLtThYvmMkXsCw64DjXuZGqmo4nVn2g==
X-Received: by 2002:a63:1503:: with SMTP id v3mr651132pgl.295.1582828627121;
        Thu, 27 Feb 2020 10:37:07 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:500::6:79da])
        by smtp.gmail.com with ESMTPSA id y10sm8234670pfq.110.2020.02.27.10.37.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 27 Feb 2020 10:37:06 -0800 (PST)
Date:   Thu, 27 Feb 2020 10:37:03 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Prashant Bhole <prashantbhole.linux@gmail.com>,
        Jason Wang <jasowang@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Toshiaki Makita <toshiaki.makita1@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH RFC v4 bpf-next 00/11] Add support for XDP in egress path
Message-ID: <20200227183702.5aaprwthg3tvuvyu@ast-mbp>
References: <20200227032013.12385-1-dsahern@kernel.org>
 <87a754w8gr.fsf@toke.dk>
 <CAADnVQJOZNP+=woGk8OjUgT8yApkrZ1mCKOgzD1mdqi91F1AYw@mail.gmail.com>
 <87r1ygufgu.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87r1ygufgu.fsf@toke.dk>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 27, 2020 at 06:06:57PM +0100, Toke Høiland-Jørgensen wrote:
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> 
> > On Thu, Feb 27, 2020 at 3:55 AM Toke Høiland-Jørgensen <toke@redhat.com> wrote:
> >>
> >> However, my issue with this encoding is that it is write-only: You can't
> >> inspect a BPF program already loaded into the kernel and tell which type
> >> it is. So my proposal would be to make it explicit: Expose the
> >> expected_attach_type as a new field in bpf_prog_info so userspace can
> >> query it, and clearly document it as, essentially, a program subtype
> >> that can significantly affect how a program is treated by the kernel.
> >
> > You had the same request for "freplace" target prog.
> 
> Yes, and for the same reason; I'm being consistent here :)
> 
> > My answer to both is still the same:
> > Please take a look at drgn and the script that Andrey posted.
> > All this information is trivial to extract from the kernel
> > without introducing new uapi.
> 
> I'm sorry, but having this kind of write-only data structure is a
> horrible API design; and saying "you can just parse the internal kernel
> data structures to see what is going on" is a cop-out. The whole point
> of having a stable UAPI is to make it possible for people to write
> applications that make use of kernel features with an expectation that
> those applications will keep working. XDP is a networking feature;
> people building networking applications shouldn't have to chase internal
> kernel APIs just to keep their packet processing programs working.

You're mistaking human needs for tooling needs.
Humans want to see all sorts of internal things and they can tweak drgn
script to look at them on the live kernel and examine kdump's vmcore
with the same drgn script.
Tooling needs uapi to work on a live system.
There are 26 attach_types that are used by various cgroup based progs,
sockmap, lirc, flow_dissector and tracing. Many of these attach types
are used in production and not a single time _tools_ had a need to
retrieve that field from the kernel.
Show me the tool that needs to read expected_attach_type back and
then we can discuss how to expose it in uapi.

There is another side of this. struct bpf_prog->pages field currently
is not exposed in uapi and I've seen tools doing
cat /proc/pid/fdinfo/fd|grep "memlock:"
just to retrive 'pages' field. That's the case where 'struct bpf_prog_info'
should be extended.
