Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6E618BE2D
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 18:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727947AbgCSRgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 13:36:46 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:39013 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726867AbgCSRgq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Mar 2020 13:36:46 -0400
Received: by mail-qk1-f195.google.com with SMTP id t17so3960122qkm.6;
        Thu, 19 Mar 2020 10:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AVPQmNN6NOetLUTJP0zJyZMmuFDmpCdhFUrOcvJMIJ4=;
        b=etyYE6VTgsaBM9TTdddNMCH81IqedG+nddjYjXybjV/rsz17al/MAMs23KvvSqu5Qq
         KSGLV7WgWN/cQu+ACaUfxk6wqGX0yMKh/EHNQkQQYq9SYTttdRbg2TBXfK2Agsh2mDX+
         N1bILjJg5pOqApqLFf0lz9x6rkUv5YpkFL5XdSu3ROiVAbW8H+jj08629M0yFnlJTYHS
         Fih1/gmT+SnhwGxu5OKoy65VGO148NWJwaUHPoiPNmLDJcboMDBpmQCPCUNIO6jybaV8
         kicXQBG48/MjNUX2bSkavZdw6Q4wmtBtMmw7ZOVhckkIFZDGzINvcTQ9UP4AFKMYXNfx
         l9FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AVPQmNN6NOetLUTJP0zJyZMmuFDmpCdhFUrOcvJMIJ4=;
        b=cevlyro+lvL+4zu34c/T01FzBxi9+9ZHPVMYLG1mssDM7VYSNoUHUMXh5T1Wrzyxcq
         YZaimHNA6KIY6zpWJKj8ScYGe4CUwDG0vAwW6Zp8I/AsE8FB8a5E1bq5vbfIVEJieUlg
         Dzjwf+NXka9zxFVxjIkOgAxcvJ0RB6F/vtuXSX1vMGI2hwlQFI/JpUvO2ytBwf3uV77n
         KE0ZyT7zfg3y4tjmUF+xlfkVKjKWjmAciy1HXd0953Juubs42RS7SEpgJG8LKkg91nOG
         /LElV2K/5g+R00doILP+ir1a5Qol8DGnsTVmrUvkqWu1Y1YVvO45CqQFxkChyxJL34US
         hLDQ==
X-Gm-Message-State: ANhLgQ39rRbtwBQ7JbtC11mtYgI/3ssdMtN/y59zOf8TF4daGv+pSdGf
        /n8OWIHCLNeiFQGjsh9ouHWUSKZ3+Rw5mGbOVQ8=
X-Google-Smtp-Source: ADFU+vu9D4nXykVRUzbWkzjcrGoYTST/puv5r5aKrjlYxbPYE3ll6jQayPEUOmy09eLaZqKi8R5ayh86ZpK0G9TtQt0=
X-Received: by 2002:a37:992:: with SMTP id 140mr4241452qkj.36.1584639405174;
 Thu, 19 Mar 2020 10:36:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200312233648.1767-1-joe@wand.net.nz> <20200312233648.1767-6-joe@wand.net.nz>
 <20200317063044.l4csdcag7l74ehut@kafai-mbp> <CAOftzPjBo6r2nymjUn4qr=N4Zd7rF=03=n45HDvyXfSXfDnBtg@mail.gmail.com>
 <20200318172735.kxwuvccegquupkwh@kafai-mbp> <CAOftzPguUws6sVKg0PQ4pQNhOQL5Q14XiwpHb60=271Jcw+pnA@mail.gmail.com>
In-Reply-To: <CAOftzPguUws6sVKg0PQ4pQNhOQL5Q14XiwpHb60=271Jcw+pnA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 19 Mar 2020 10:36:34 -0700
Message-ID: <CAEf4BzZWdJf6yWhfJSd8UEgu9i8KrYVaeBhoK-QXcdqzvE_h1Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 5/7] selftests: bpf: add test for sk_assign
To:     Joe Stringer <joe@wand.net.nz>
Cc:     Martin KaFai Lau <kafai@fb.com>, bpf <bpf@vger.kernel.org>,
        Lorenz Bauer <lmb@cloudflare.com>,
        netdev <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 18, 2020 at 10:46 PM Joe Stringer <joe@wand.net.nz> wrote:
>
> On Wed, Mar 18, 2020 at 10:28 AM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Tue, Mar 17, 2020 at 01:56:12PM -0700, Joe Stringer wrote:
> > > On Tue, Mar 17, 2020 at 12:31 AM Martin KaFai Lau <kafai@fb.com> wrote:
> > > >
> > > > On Thu, Mar 12, 2020 at 04:36:46PM -0700, Joe Stringer wrote:
> > > > > From: Lorenz Bauer <lmb@cloudflare.com>
> > > > >
> > > > > Attach a tc direct-action classifier to lo in a fresh network
> > > > > namespace, and rewrite all connection attempts to localhost:4321
> > > > > to localhost:1234.
> > > > >
> > > > > Keep in mind that both client to server and server to client traffic
> > > > > passes the classifier.
> > > > >
> > > > > Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
> > > > > Signed-off-by: Joe Stringer <joe@wand.net.nz>
> > > > > ---
> > > > >  tools/testing/selftests/bpf/.gitignore        |   1 +
> > > > >  tools/testing/selftests/bpf/Makefile          |   3 +-
> > > > >  .../selftests/bpf/progs/test_sk_assign.c      | 127 +++++++++++++
> > > > >  tools/testing/selftests/bpf/test_sk_assign.c  | 176 ++++++++++++++++++
> > > > Can this test be put under the test_progs.c framework?
> > >
> > > I'm not sure, how does the test_progs.c framework handle the logic in
> > > "tools/testing/selftests/bpf/test_sk_assign.sh"?
> > >
> > > Specifically I'm looking for:
> > > * Unique netns to avoid messing with host networking stack configuration
> > > * Control over routes
> > > * Attaching loaded bpf programs to ingress qdisc of a device
> > >
> > > These are each trivial one-liners in the supplied shell script
> > > (admittedly building on existing shell infrastructure in the tests dir
> > > and iproute2 package). Seems like maybe the netns parts aren't so bad
> > > looking at flow_dissector_reattach.c but anything involving netlink
> > > configuration would either require pulling in a netlink library
> > > dependency somewhere or shelling out to the existing binaries. At that
> > > point I wonder if we're trying to achieve integration of this test
> > > into some automated prog runner, is there a simpler way like a place I
> > > can just add a one-liner to run the test_sk_assign.sh script?
> > I think running a system(cmd) in test_progs is fine, as long as it cleans
> > up everything when it is done.  There is some pieces of netlink
> > in tools/lib/bpf/netlink.c that may be reuseable also.
> >
> > Other than test_progs.c, I am not aware there is a script to run
> > all *.sh.  I usually only run test_progs.
> >
> > Cc: Andrii who has fixed many selftest issues recently.
>
> OK, unless I get some other guidance I'll take a stab at this.

Having tests in test_progs makes sure it's executed constantly, both
by maintainers, automated testing and, hopefully, developers. Having
some .sh script has much more coverage in that sense. So if at all
possible, please add new tests to test_progs.
