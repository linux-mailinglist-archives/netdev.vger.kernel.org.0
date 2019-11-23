Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27738107DD7
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 10:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726487AbfKWI5e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 03:57:34 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:23469 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726141AbfKWI5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 03:57:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574499452;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ALroEYY/Jkr/wBe0jUw7qlkqhNRApKqNALcmtx/6f8c=;
        b=ExZF1U+h+GaR80hR4TlY7+tzcnavW6GiCLaAClWCWLt6Nds5Ivzi2h91nnpUV/1A3bwvK+
        EJfOdOnmBiO3A5Uo4cWBzT3WGLjowOk/vhrTv3MWsOQXlJXySv1ZPWZGQAQxwKo450pUn6
        VB6wdibdmir8B1vbjKbafdhlgrlHo08=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-345-1FrB7f-7Pya0lfspaeS9cQ-1; Sat, 23 Nov 2019 03:57:29 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E88F9DB20;
        Sat, 23 Nov 2019 08:57:26 +0000 (UTC)
Received: from krava (ovpn-204-28.brq.redhat.com [10.40.204.28])
        by smtp.corp.redhat.com (Postfix) with SMTP id 5AA9D5D6A0;
        Sat, 23 Nov 2019 08:57:19 +0000 (UTC)
Date:   Sat, 23 Nov 2019 09:57:19 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        linux-audit@redhat.com, Jiri Olsa <jolsa@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Steve Grubb <sgrubb@redhat.com>,
        David Miller <davem@redhat.com>,
        Eric Paris <eparis@redhat.com>, Jiri Benc <jbenc@redhat.com>
Subject: Re: [PATCH] bpf: emit audit messages upon successful prog load and
 unload
Message-ID: <20191123085719.GA1673@krava>
References: <20191120213816.8186-1-jolsa@kernel.org>
 <8c928ec4-9e43-3e2a-7005-21f40fcca061@iogearbox.net>
 <CAADnVQKu-ZgFTaSMH=Q-jMOYYvE32TF2b2hq1=dmDV8wAf18pg@mail.gmail.com>
 <CAHC9VhQbQoXacbTCNJPGNzFOv30PwLeiWu4ROQFU46=saTeTNQ@mail.gmail.com>
 <20191122002257.4hgui6pylpkmpwac@ast-mbp.dhcp.thefacebook.com>
 <CAHC9VhRihMi_d-p+ieXyuVBcGMs80SkypVxF4gLE_s45GKP0dg@mail.gmail.com>
 <20191122192353.GA2157@krava>
 <CAHC9VhRi0JtKgHyAOdAJ=_--vL1VbK7BDq1FnRQ_GwW9P4J_zA@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAHC9VhRi0JtKgHyAOdAJ=_--vL1VbK7BDq1FnRQ_GwW9P4J_zA@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: 1FrB7f-7Pya0lfspaeS9cQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 22, 2019 at 04:19:55PM -0500, Paul Moore wrote:
> On Fri, Nov 22, 2019 at 2:24 PM Jiri Olsa <jolsa@redhat.com> wrote:
> > Paul,
> > would following output be ok:
> >
> >     type=3DSYSCALL msg=3Daudit(1574445211.897:28015): arch=3Dc000003e s=
yscall=3D321 success=3Dno exit=3D-13 a0=3D5 a1=3D7fff09ac6c60 a2=3D78 a3=3D=
6 items=3D0 ppid=3D1408 pid=3D9266 auid=3D1001 uid=3D0 gid=3D0 euid=3D0 sui=
d=3D0 fsuid=3D0 egid=3D0 sgid=3D0 fsgid=3D0 tty=3Dpts0 ses=3D1 comm=3D"test=
_verifier" exe=3D"/home/jolsa/linux/tools/testing/selftests/bpf/test_verifi=
er" subj=3Dunconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=3D(nul=
l)ARCH=3Dx86_64 SYSCALL=3Dbpf AUID=3D"jolsa" UID=3D"root" GID=3D"root" EUID=
=3D"root" SUID=3D"root" FSUID=3D"root" EGID=3D"root" SGID=3D"root" FSGID=3D=
"root"
> >     type=3DPROCTITLE msg=3Daudit(1574445211.897:28015): proctitle=3D"./=
test_verifier"
> >     type=3DBPF msg=3Daudit(1574445211.897:28016): prog-id=3D8103 event=
=3DLOAD
> >
> >     type=3DSYSCALL msg=3Daudit(1574445211.897:28016): arch=3Dc000003e s=
yscall=3D321 success=3Dyes exit=3D14 a0=3D5 a1=3D7fff09ac6b80 a2=3D78 a3=3D=
0 items=3D0 ppid=3D1408 pid=3D9266 auid=3D1001 uid=3D0 gid=3D0 euid=3D0 sui=
d=3D0 fsuid=3D0 egid=3D0 sgid=3D0 fsgid=3D0 tty=3Dpts0 ses=3D1 comm=3D"test=
_verifier" exe=3D"/home/jolsa/linux/tools/testing/selftests/bpf/test_verifi=
er" subj=3Dunconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=3D(nul=
l)ARCH=3Dx86_64 SYSCALL=3Dbpf AUID=3D"jolsa" UID=3D"root" GID=3D"root" EUID=
=3D"root" SUID=3D"root" FSUID=3D"root" EGID=3D"root" SGID=3D"root" FSGID=3D=
"root"
> >     type=3DPROCTITLE msg=3Daudit(1574445211.897:28016): proctitle=3D"./=
test_verifier"
> >     type=3DBPF msg=3Daudit(1574445211.897:28017): prog-id=3D8103 event=
=3DUNLOAD
>=20
> There is some precedence in using "op=3D" instead of "event=3D" (an audit
> "event" is already a thing, using "event=3D" here might get confusing).
> I suppose if we are getting really nit-picky you might want to
> lower-case the LOAD/UNLOAD, but generally Steve cares more about these
> things than I do.
>=20
> For reference, we have a searchable database of fields here:
> * https://github.com/linux-audit/audit-documentation/blob/master/specs/fi=
elds/field-dictionary.csv

I'm fine with "op", Daniel, Alexei?

>=20
> > I assume for audit-userspace and audit-testsuite the change will
> > go in as github PR, right? I have the auditd change ready and will
> > add test shortly.
>=20
> You can submit the audit-testsuite either as a GH PR or as a
> patch(set) to the linux-audit mailing list, both work equally well.  I
> believe has the same policy for his userspace tools, but I'll let him
> speak for himself.

ok

>=20
> > diff --git a/include/linux/audit.h b/include/linux/audit.h
> > index 18925d924c73..c69d2776d197 100644
> > --- a/include/linux/audit.h
> > +++ b/include/linux/audit.h
> > @@ -358,8 +358,6 @@ static inline void audit_ptrace(struct task_struct =
*t)
> >                 __audit_ptrace(t);
> >  }
> >
> > -extern void audit_log_task(struct audit_buffer *ab);
> > -
> >                                 /* Private API (for audit.c only) */
> >  extern void __audit_ipc_obj(struct kern_ipc_perm *ipcp);
> >  extern void __audit_ipc_set_perm(unsigned long qbytes, uid_t uid, gid_=
t gid, umode_t mode);
> > @@ -648,8 +646,6 @@ static inline void audit_ntp_log(const struct audit=
_ntp_data *ad)
> >  static inline void audit_ptrace(struct task_struct *t)
> >  { }
> >
> > -static inline void audit_log_task(struct audit_buffer *ab)
> > -{ }
> >  #define audit_n_rules 0
> >  #define audit_signals 0
> >  #endif /* CONFIG_AUDITSYSCALL */
> > diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> > index 9bf1045fedfa..4effe01ebbe2 100644
> > --- a/kernel/auditsc.c
> > +++ b/kernel/auditsc.c
> > @@ -2545,7 +2545,7 @@ void __audit_ntp_log(const struct audit_ntp_data =
*ad)
> >         audit_log_ntp_val(ad, "adjust", AUDIT_NTP_ADJUST);
> >  }
> >
> > -void audit_log_task(struct audit_buffer *ab)
> > +static void audit_log_task(struct audit_buffer *ab)
>=20
> I'm slightly concerned that this is based on top of your other patch
> which was NACK'ed.  I might not have been clear before, but with the
> merge window set to open in a few days, and this change affecting the
> kernel interface (uapi, etc.) and lacking a test, this isn't something
> that I see as a candidate for the upcoming merge window.  *Please*
> revert your original patch first; if you think I'm cranky now I can
> promise I'll be a lot more cranky if I see the original patch in -rc1
> ;)

no worries, I'm used to cranky ;-)
Alexei already asked Dave to revert this in previous email,
so that should happen

thanks,
jirka

