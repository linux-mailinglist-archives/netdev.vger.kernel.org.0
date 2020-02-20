Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A88F516633D
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 17:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728331AbgBTQh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 11:37:59 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37228 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728021AbgBTQh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 11:37:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582216678;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JPLN0ouhhg0blmU2M9hGNXZisumAqDkHlC1AmG0Un74=;
        b=Zn8ACb+NJ5bDueqvOY+YJX9o9chqXSejt6t/jNWHnY5ou5kBHR27vwLGbTN6/3NdBVQegt
        GjkfycGKW68JgyONine6ptMJxHcOjAO19F7wziiYApbLVB1AD9cnLI0UuDEf071FpjdA5B
        I1Xg1F8eAfvtHUS1gh4sz5r3ZSEMZlw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-290-8c5kERyLNBuMfxt3ogkWqQ-1; Thu, 20 Feb 2020 11:37:55 -0500
X-MC-Unique: 8c5kERyLNBuMfxt3ogkWqQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0F529477;
        Thu, 20 Feb 2020 16:37:53 +0000 (UTC)
Received: from carbon (ovpn-200-26.brq.redhat.com [10.40.200.26])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F41DF9051B;
        Thu, 20 Feb 2020 16:37:42 +0000 (UTC)
Date:   Thu, 20 Feb 2020 17:37:40 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     shuah <shuah@kernel.org>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel =?UTF-8?B?RMOtYXo=?= <daniel.diaz@linaro.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        BPF-dev-list <bpf@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, brouer@redhat.com
Subject: Re: Kernel 5.5.4 build fail for BPF-selftests with latest LLVM
Message-ID: <20200220173740.7a3f9ad7@carbon>
In-Reply-To: <4a26e6c6-500e-7b92-1e26-16e1e0233889@kernel.org>
References: <20200219133012.7cb6ac9e@carbon>
        <CAADnVQKQRKtDz0Boy=-cudc4eKGXB-yParGZv6qvYcQR4uMUQQ@mail.gmail.com>
        <20200219180348.40393e28@carbon>
        <CAEf4Bza9imKymHfv_LpSFE=kNB5=ZapTS3SCdeZsDdtrUrUGcg@mail.gmail.com>
        <20200219192854.6b05b807@carbon>
        <CAEf4BzaRAK6-7aCCVOA6hjTevKuxgvZZnHeVgdj_ZWNn8wibYQ@mail.gmail.com>
        <20200219210609.20a097fb@carbon>
        <CAEUSe79Vn8wr=BOh0RzccYij_snZDY=2XGmHmR494wsQBBoo5Q@mail.gmail.com>
        <20200220002748.kpwvlz5xfmjm5fd5@ast-mbp>
        <4a26e6c6-500e-7b92-1e26-16e1e0233889@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Feb 2020 17:47:23 -0700
shuah <shuah@kernel.org> wrote:

> On 2/19/20 5:27 PM, Alexei Starovoitov wrote:
> > On Wed, Feb 19, 2020 at 03:59:41PM -0600, Daniel D=C3=ADaz wrote: =20
> >>>
> >>> When I download a specific kernel release, how can I know what LLVM
> >>> git-hash or version I need (to use BPF-selftests)? =20
> >=20
> > as discussed we're going to add documentation-like file that will
> > list required commits in tools.
> > This will be enforced for future llvm/pahole commits.
> >  =20
> >>> Do you think it is reasonable to require end-users to compile their o=
wn
> >>> bleeding edge version of LLVM, to use BPF-selftests? =20
> >=20
> > absolutely. =20
>=20
> + linux-kselftest@vger.kernel.org
>=20
> End-users in this context are users and not necessarily developers.

I agree.  And I worry that we are making it increasingly hard for
non-developer users.


> > If a developer wants to send a patch they must run all selftests and
> > all of them must pass in their environment.
> > "but I'm adding a tracing feature and don't care about networking tests
> > failing"... is not acceptable. =20
>=20
> This is a reasonable expectation when a developers sends bpf patches.

Sure. I have several versions on LLVM that I've compiled manually.

> >  =20
> >>> I do hope that some end-users of BPF-selftests will be CI-systems.
> >>> That also implies that CI-system maintainers need to constantly do
> >>> "latest built from sources" of LLVM git-tree to keep up.  Is that a
> >>> reasonable requirement when buying a CI-system in the cloud? =20
> >=20
> > "buying CI-system in the cloud" ?
> > If I could buy such system I would pay for it out of my own pocket to s=
ave
> > maintainer's and developer's time.

And Daniel D=C3=ADaz want to provide his help below (to tests it on arch
that you likely don't even have access to). That sounds like a good
offer, and you don't even have to pay.

> >  =20
> >> We [1] are end users of kselftests and many other test suites [2]. We
> >> run all of our testing on every git-push on linux-stable-rc, mainline,
> >> and linux-next -- approximately 1 million tests per week. We have a
> >> dedicated engineering team looking after this CI infrastructure and
> >> test results, and as such, I can wholeheartedly echo Jesper's
> >> sentiment here: We would really like to help kernel maintainers and
> >> developers by automatically testing their code in real hardware, but
> >> the BPF kselftests are difficult to work with from a CI perspective.
> >> We have caught and reported [3] many [4] build [5] failures [6] in the
> >> past for libbpf/Perf, but building is just one of the pieces. We are
> >> unable to run the entire BPF kselftests because only a part of the
> >> code builds, so our testing is very limited there.
> >>
> >> We hope that this situation can be improved and that our and everyone
> >> else's automated testing can help you guys too. For this to work out,
> >> we need some help. =20
> >  =20
>=20
> It would be helpful understand what "help" is in this context.
>=20
> > I don't understand what kind of help you need. Just install the
> > latest tools. =20

I admire that you want to push *everybody* forward to use the latest
LLVM, but saying latest is LLVM devel git tree HEAD is too extreme.
I can support saying latest LLVM release is required.

As soon as your LLVM patches are accepted into llvm-git-tree, you will
add some BPF selftests that util this. Then CI-systems pull latest
bpf-next they will start to fail to compile BPF-selftests, and CI
stops.  Now you want to force CI-system maintainer to recompile LLVM
from git.  This will likely take some time.  Until that happens
CI-system doesn't catch stuff. E.g. I really want the ARM tests that
Linaro can run for us (which isn't run before you apply patches...).


> What would be helpful is to write bpf tests such that older tests that
> worked on older llvm versions continue to work and with some indication
> on which tests require new bleeding edge tools.
>=20
> > Both the latest llvm and the latest pahole are required. =20
>=20
> It would be helpful if you can elaborate why latest tools are a
> requirement.
>=20
> > If by 'help' you mean to tweak selftests to skip tests then it's a nack.
> > We have human driven CI. Every developer must run selftests/bpf before
> > emailing the patches. Myself and Daniel run them as well before applyin=
g.
> > These manual runs is the only thing that keeps bpf tree going.
> > If selftests get to skip tests humans will miss those errors.
> > When I don't see '0 SKIPPED, 0 FAILED' I go and investigate.
> > Anything but zero is a path to broken kernels.
> >=20
> > Imagine the tests would get skipped when pahole is too old.
> > That would mean all of the kernel features from year 2019
> > would get skipped. Is there a point of running such selftests?
> > I think the value is not just zero. The value is negative.
> > Such selftests that run old stuff would give false believe
> > that they do something meaningful.
> > "but CI can do build only tests"... If 'helping' such CI means hurting =
the
> > key developer/maintainer workflow such CI is on its own.
> >  =20
>=20
> Skipping tests will be useless. I am with you on that. However,
> figuring out how to maintain some level of backward compatibility
> to run at least older tests and warn users to upgrade would be
> helpful.

What I propose is that a BPF-selftest that use a new LLVM feature,
should return FAIL (or perhaps SKIP), when it is compiled with say one
release old LLVM. This will allow new-tests to show up in CI-systems
reports as FAIL, and give everybody breathing room to upgrade their LLVM
compiler.

> I suspect currently users are ignoring bpf failures because they
> are unable to keep up with the requirement to install newer tools
> to run the tests. This isn't great either.

Yes, my worry is also that we are simply making it too difficult for
non-developer users to run these tests.  And I specifically want to
attract CI-systems to run these.  And especially Linaro, who have
dedicated engineering team looking after their CI infrastructure, and
they explicitly in this email confirm my worry.


> Users that care are sharing their pain to see if they can get some
> help or explanation on why new tools are required every so often.
> I don't think everybody understands why. :)

--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

