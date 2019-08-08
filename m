Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA52586905
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 20:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390196AbfHHSsl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 14:48:41 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:35769 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733248AbfHHSsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 14:48:41 -0400
Received: by mail-qt1-f196.google.com with SMTP id d23so93318037qto.2;
        Thu, 08 Aug 2019 11:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f80HuJ3dcEKodY0RtmqfOb/w0vbYOhv7LftMqAtR93k=;
        b=Lot3kI1jX2GfwMlD1yVgU+tjLRmJ7gUCD3AiqHhA91IWXyIespsd7NqAHyVIrWNqvy
         oGxxtChmpGuEDXUUHvdbCAN7kJHO0us+CKCUcQT2UE58/SiUs5ZMFuyw4D6q9E6XtqCQ
         xoWpfHsFOQKV0zvgwkl3bZBHSL6RyCEmuhCDIFANNCsqzhyEYy7+2NBaaQxkjMU0/x8+
         DcCvoUK3UYGa1wuPfeJxxoux/sg01sL0OZjJ9NKaLS8A6LuQLd4bfk0txyIoVznbJ1im
         K34/YQuvtDM8AQ+dMw4xj+Fr6gyhxH5VEpHQPKylOgR1xVmDaSHJZNzePVL46aOZt4Qp
         vdIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f80HuJ3dcEKodY0RtmqfOb/w0vbYOhv7LftMqAtR93k=;
        b=iA7lxL060NEB2AjyHLfCp/teiXQGiA6391J932DW8wgcaLXYGS0E/ERLyliMogDn3t
         Xd1vW2vYjGV4SZRAicOXCZ3DfgPdApLSYQDov/qTn54cD8ldCovXzm5Lx6BzCSaVctQ8
         N9uFkSaAteqyhivh23C93Px6kLGEr2p/PxozMqN+Fi2l3xXSkS5DJFoGiZQz5XBzLbtu
         YqYbZ/PHikAP18GJxbHaYC8QOyH4C2GJaJOuWua0vvTlB/goiS76KQsX63Lg837e7Nqa
         CPR3rQmcDHbx65eO80IQE4zf7ymaLmlzsEuE0xj8flG+AJ2E9OAPUQUVUSk1yWwUfEto
         aoew==
X-Gm-Message-State: APjAAAXi7L6tghIBYE5l/+FXxRdq1A3+34g6Ef88MEjmUvhMehCCYQa8
        nZhDMpFFK1XdaMPUzcn5OVGl8JePgPN0vwW42jQ=
X-Google-Smtp-Source: APXvYqyt0+AS5Aw8s3QHlyYncWrVCjjgAHZiEOkMR/34wXpiw3zhs6G9mpScPvM3XmdzF1gCMfhcu806xqwWSKBBVVc=
X-Received: by 2002:ac8:290c:: with SMTP id y12mr14345594qty.141.1565290120525;
 Thu, 08 Aug 2019 11:48:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190803044320.5530-1-farid.m.zakaria@gmail.com>
 <20190803044320.5530-2-farid.m.zakaria@gmail.com> <CAH3MdRXTEN-Ra+61QA37hM2mkHx99K5NM7f+H6d8Em-bxvaenw@mail.gmail.com>
 <20190805171036.5a5bf790@cakuba.netronome.com>
In-Reply-To: <20190805171036.5a5bf790@cakuba.netronome.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 8 Aug 2019 11:48:29 -0700
Message-ID: <CAEf4Bzb5bvK3+HLGgFi3o7GttQ3FPP0aFS7mB0e9yjmAqG4Feg@mail.gmail.com>
Subject: Re: [PATCH 1/1] bpf: introduce new helper udp_flow_src_port
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Y Song <ys114321@gmail.com>, Alexei Starovoitov <ast@kernel.org>,
        Farid Zakaria <farid.m.zakaria@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 5, 2019 at 5:11 PM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Sat, 3 Aug 2019 23:52:16 -0700, Y Song wrote:
> > >  include/uapi/linux/bpf.h                      | 21 +++++++--
> > >  net/core/filter.c                             | 20 ++++++++
> > >  tools/include/uapi/linux/bpf.h                | 21 +++++++--
> > >  tools/testing/selftests/bpf/bpf_helpers.h     |  2 +
> > >  .../bpf/prog_tests/udp_flow_src_port.c        | 28 +++++++++++
> > >  .../bpf/progs/test_udp_flow_src_port_kern.c   | 47 +++++++++++++++++++
> > >  6 files changed, 131 insertions(+), 8 deletions(-)
> > >  create mode 100644 tools/testing/selftests/bpf/prog_tests/udp_flow_src_port.c
> > >  create mode 100644 tools/testing/selftests/bpf/progs/test_udp_flow_src_port_kern.c
> >
> > First, for each review, backport and sync with libbpf repo, in the future,
> > could you break the patch to two patches?
> >    1. kernel changes (net/core/filter.c, include/uapi/linux/bpf.h)
> >    2. tools/include/uapi/linux/bpf.h
> >    3. tools/testing/ changes
>
> A lot of people get caught off by this, could explain why this is
> necessary?

We are using script [0] to sync libbpf sources from linux repo to
Github. It does a lot of things to make this happen, given that Github
structure is not a simple copy/move into subdirectory. Instead it does
a bunch of cherry-picking and tree rewrites, so when there are patches
that touched both libbpf sources (including those tools/include/...
files) and some sources that we don't sync (e.g., just include/...),
then script/git gets confused which breaks the flow and requires more
manual work. Which is why we are asking to split those changes. Hope
this helps to clarify.

  [0] https://github.com/libbpf/libbpf/blob/master/scripts/sync-kernel.sh

>
> git can deal with this scenario without missing a step, format-patch
> takes paths:
>
> $ git show --oneline -s
> 1002f3e955d7 (HEAD) bpf: introduce new helper udp_flow_src_port
>
> $ git format-patch HEAD~ -- tools/include/uapi/linux/bpf.h
> 0001-bpf-introduce-new-helper-udp_flow_src_port.patch
>
> $ grep -B1 changed 0001-bpf-introduce-new-helper-udp_flow_src_port.patch
>  tools/include/uapi/linux/bpf.h | 21 +++++++++++++++++----
>  1 file changed, 17 insertions(+), 4 deletions(-)
>
> $ cd ../libbpf
> $ git am -p2 ../linux/0001-bpf-introduce-new-helper-udp_flow_src_port.patch
> Applying: bpf: introduce new helper udp_flow_src_port
> error: patch failed: include/uapi/linux/bpf.h:2853
> error: include/uapi/linux/bpf.h: patch does not apply
> ...
>
> Well, the patch doesn't apply to libbpf right now, but git finds the
> right paths and all that.
>
> IMO it'd be good to not have this artificial process obstacle and all
> the "sync headers" commits in the tree.

It might be the case that script can be written in some different way
to bypass this limitation, but someone has to dedicate time to write
it and test it. Feel free to contribute.
