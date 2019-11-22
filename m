Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43A001077FB
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 20:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbfKVTYI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 14:24:08 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:20568 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726703AbfKVTYI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 14:24:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574450646;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9D++jXh0jJ0wfnyL1HUr4hKwfCiMd6Jte1ZXhWGcn3U=;
        b=LX3bRf16sbPJBXSy0vC0Pk1UPayj7z7Kzc1eogGiifD0ocaO48K/eUeDcmaXCaXTN8pKeh
        Hidd5WGUe8puq3oozum/w0UYmXrUL/dISkWqL/vGgxrjO0uh+pQW+mAbL5gNOW0R2EfAdT
        QFzQl/DO1G8vyatjPVjqafG9yAG1NKA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-128-px9FBABoNPqrMQ9AyTv-fw-1; Fri, 22 Nov 2019 14:24:02 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 831151005512;
        Fri, 22 Nov 2019 19:24:00 +0000 (UTC)
Received: from krava (ovpn-204-245.brq.redhat.com [10.40.204.245])
        by smtp.corp.redhat.com (Postfix) with SMTP id 9310E60468;
        Fri, 22 Nov 2019 19:23:54 +0000 (UTC)
Date:   Fri, 22 Nov 2019 20:23:53 +0100
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
Message-ID: <20191122192353.GA2157@krava>
References: <20191120213816.8186-1-jolsa@kernel.org>
 <8c928ec4-9e43-3e2a-7005-21f40fcca061@iogearbox.net>
 <CAADnVQKu-ZgFTaSMH=Q-jMOYYvE32TF2b2hq1=dmDV8wAf18pg@mail.gmail.com>
 <CAHC9VhQbQoXacbTCNJPGNzFOv30PwLeiWu4ROQFU46=saTeTNQ@mail.gmail.com>
 <20191122002257.4hgui6pylpkmpwac@ast-mbp.dhcp.thefacebook.com>
 <CAHC9VhRihMi_d-p+ieXyuVBcGMs80SkypVxF4gLE_s45GKP0dg@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAHC9VhRihMi_d-p+ieXyuVBcGMs80SkypVxF4gLE_s45GKP0dg@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: px9FBABoNPqrMQ9AyTv-fw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 07:36:29PM -0500, Paul Moore wrote:
> On Thu, Nov 21, 2019 at 7:23 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> > On Thu, Nov 21, 2019 at 06:41:31PM -0500, Paul Moore wrote:
> > > On Wed, Nov 20, 2019 at 4:49 PM Alexei Starovoitov
> > > <alexei.starovoitov@gmail.com> wrote:
> > > > On Wed, Nov 20, 2019 at 1:46 PM Daniel Borkmann <daniel@iogearbox.n=
et> wrote:
> > > > > On 11/20/19 10:38 PM, Jiri Olsa wrote:
> > > > > > From: Daniel Borkmann <daniel@iogearbox.net>
> > > > > >
> > > > > > Allow for audit messages to be emitted upon BPF program load an=
d
> > > > > > unload for having a timeline of events. The load itself is in
> > > > > > syscall context, so additional info about the process initiatin=
g
> > > > > > the BPF prog creation can be logged and later directly correlat=
ed
> > > > > > to the unload event.
> > > > > >
> > > > > > The only info really needed from BPF side is the globally uniqu=
e
> > > > > > prog ID where then audit user space tooling can query / dump al=
l
> > > > > > info needed about the specific BPF program right upon load even=
t
> > > > > > and enrich the record, thus these changes needed here can be ke=
pt
> > > > > > small and non-intrusive to the core.
> > > > > >
> > > > > > Raw example output:
> > > > > >
> > > > > >    # auditctl -D
> > > > > >    # auditctl -a always,exit -F arch=3Dx86_64 -S bpf
> > > > > >    # ausearch --start recent -m 1334
> > > > > >    [...]
> > > > > >    ----
> > > > > >    time->Wed Nov 20 12:45:51 2019
> > > > > >    type=3DPROCTITLE msg=3Daudit(1574271951.590:8974): proctitle=
=3D"./test_verifier"
> > > > > >    type=3DSYSCALL msg=3Daudit(1574271951.590:8974): arch=3Dc000=
003e syscall=3D321 success=3Dyes exit=3D14 a0=3D5 a1=3D7ffe2d923e80 a2=3D78=
 a3=3D0 items=3D0 ppid=3D742 pid=3D949 auid=3D0 uid=3D0 gid=3D0 euid=3D0 su=
id=3D0 fsuid=3D0 egid=3D0 sgid=3D0 fsgid=3D0 tty=3Dpts0 ses=3D2 comm=3D"tes=
t_verifier" exe=3D"/root/bpf-next/tools/testing/selftests/bpf/test_verifier=
" subj=3Dunconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=3D(null)
> > > > > >    type=3DUNKNOWN[1334] msg=3Daudit(1574271951.590:8974): auid=
=3D0 uid=3D0 gid=3D0 ses=3D2 subj=3Dunconfined_u:unconfined_r:unconfined_t:=
s0-s0:c0.c1023 pid=3D949 comm=3D"test_verifier" exe=3D"/root/bpf-next/tools=
/testing/selftests/bpf/test_verifier" prog-id=3D3260 event=3DLOAD
> > > > > >    ----
> > > > > >    time->Wed Nov 20 12:45:51 2019
> > > > > > type=3DUNKNOWN[1334] msg=3Daudit(1574271951.590:8975): prog-id=
=3D3260 event=3DUNLOAD
> > > > > >    ----
> > > > > >    [...]
> > > > > >
> > > > > > Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> > > > > > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > > > >
> > > > > LGTM, thanks for the rebase!
> > > >
> > > > Applied to bpf-next. Thanks!
> > >
> > > [NOTE: added linux-audit to the To/CC line]
> > >
> > > Wait a minute, why was the linux-audit list not CC'd on this?  Why ar=
e
> > > you merging a patch into -next that adds to the uapi definition *and*
> > > creates a new audit record while we are at -rc8?
> > >
> > > Aside from that I'm concerned that you are relying on audit userspace
> > > changes that might not be okay; I see the PR below, but I don't see
> > > any comment on it from Steve (it is his audit userspace).  I also
> > > don't see a corresponding test added to the audit-testsuite, which is
> > > a common requirement for new audit functionality (link below).  I'm
> > > also fairly certain we don't want this new BPF record to look like ho=
w
> > > you've coded it up in bpf_audit_prog(); duplicating the fields with
> > > audit_log_task() is wrong, you've either already got them via an
> > > associated record (which you get from passing non-NULL as the first
> > > parameter to audit_log_start()), or you don't because there is no
> > > associated syscall/task (which you get from passing NULL as the first
> > > parameter).  Please revert, un-merge, etc. this patch from bpf-next;
> > > it should not go into Linus' tree as written.
> >
> > Sorry I didn't realize there was a disagreement.
> >
> > Dave, could you please revert it in net-next?
> >
> > > Audit userspace PR:
> > > * https://github.com/linux-audit/audit-userspace/pull/104
> >
> > This PR does not use this new audit. It's doing everything via existing
> > perf_event notification. My understanding of Jiri's email was that netl=
ink
> > style is preferred vs perf_event. Did I get it wrong?
>=20
> Perhaps confusion on my part regarding the audit-userspace PR.  The
> commit description mentioned the audit userspace (the daemon most
> likely) fetching additional info about the BPF program and this was
> the only outstanding audit-userspace PR that had any mention of BPF.
>=20
> However, getting back to netlink vs perf_event, if you want to
> generate an audit record, it should happen via the audit subsystem
> (and go up to the audit daemon via netlink).

Paul,
would following output be ok:

    type=3DSYSCALL msg=3Daudit(1574445211.897:28015): arch=3Dc000003e sysca=
ll=3D321 success=3Dno exit=3D-13 a0=3D5 a1=3D7fff09ac6c60 a2=3D78 a3=3D6 it=
ems=3D0 ppid=3D1408 pid=3D9266 auid=3D1001 uid=3D0 gid=3D0 euid=3D0 suid=3D=
0 fsuid=3D0 egid=3D0 sgid=3D0 fsgid=3D0 tty=3Dpts0 ses=3D1 comm=3D"test_ver=
ifier" exe=3D"/home/jolsa/linux/tools/testing/selftests/bpf/test_verifier" =
subj=3Dunconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=3D(null)AR=
CH=3Dx86_64 SYSCALL=3Dbpf AUID=3D"jolsa" UID=3D"root" GID=3D"root" EUID=3D"=
root" SUID=3D"root" FSUID=3D"root" EGID=3D"root" SGID=3D"root" FSGID=3D"roo=
t"
    type=3DPROCTITLE msg=3Daudit(1574445211.897:28015): proctitle=3D"./test=
_verifier"
    type=3DBPF msg=3Daudit(1574445211.897:28016): prog-id=3D8103 event=3DLO=
AD

    type=3DSYSCALL msg=3Daudit(1574445211.897:28016): arch=3Dc000003e sysca=
ll=3D321 success=3Dyes exit=3D14 a0=3D5 a1=3D7fff09ac6b80 a2=3D78 a3=3D0 it=
ems=3D0 ppid=3D1408 pid=3D9266 auid=3D1001 uid=3D0 gid=3D0 euid=3D0 suid=3D=
0 fsuid=3D0 egid=3D0 sgid=3D0 fsgid=3D0 tty=3Dpts0 ses=3D1 comm=3D"test_ver=
ifier" exe=3D"/home/jolsa/linux/tools/testing/selftests/bpf/test_verifier" =
subj=3Dunconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023 key=3D(null)AR=
CH=3Dx86_64 SYSCALL=3Dbpf AUID=3D"jolsa" UID=3D"root" GID=3D"root" EUID=3D"=
root" SUID=3D"root" FSUID=3D"root" EGID=3D"root" SGID=3D"root" FSGID=3D"roo=
t"
    type=3DPROCTITLE msg=3Daudit(1574445211.897:28016): proctitle=3D"./test=
_verifier"
    type=3DBPF msg=3Daudit(1574445211.897:28017): prog-id=3D8103 event=3DUN=
LOAD

I assume for audit-userspace and audit-testsuite the change will
go in as github PR, right? I have the auditd change ready and will
add test shortly.

thanks,
jirka


---
 include/linux/audit.h | 4 ----
 kernel/auditsc.c      | 2 +-
 kernel/bpf/syscall.c  | 6 +-----
 3 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/include/linux/audit.h b/include/linux/audit.h
index 18925d924c73..c69d2776d197 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -358,8 +358,6 @@ static inline void audit_ptrace(struct task_struct *t)
 =09=09__audit_ptrace(t);
 }
=20
-extern void audit_log_task(struct audit_buffer *ab);
-
 =09=09=09=09/* Private API (for audit.c only) */
 extern void __audit_ipc_obj(struct kern_ipc_perm *ipcp);
 extern void __audit_ipc_set_perm(unsigned long qbytes, uid_t uid, gid_t gi=
d, umode_t mode);
@@ -648,8 +646,6 @@ static inline void audit_ntp_log(const struct audit_ntp=
_data *ad)
 static inline void audit_ptrace(struct task_struct *t)
 { }
=20
-static inline void audit_log_task(struct audit_buffer *ab)
-{ }
 #define audit_n_rules 0
 #define audit_signals 0
 #endif /* CONFIG_AUDITSYSCALL */
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 9bf1045fedfa..4effe01ebbe2 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -2545,7 +2545,7 @@ void __audit_ntp_log(const struct audit_ntp_data *ad)
 =09audit_log_ntp_val(ad, "adjust",=09AUDIT_NTP_ADJUST);
 }
=20
-void audit_log_task(struct audit_buffer *ab)
+static void audit_log_task(struct audit_buffer *ab)
 {
 =09kuid_t auid, uid;
 =09kgid_t gid;
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index b51ecb9644d0..e3a7fa4d7a82 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1334,7 +1334,6 @@ static const char * const bpf_event_audit_str[] =3D {
=20
 static void bpf_audit_prog(const struct bpf_prog *prog, enum bpf_event eve=
nt)
 {
-=09bool has_task_context =3D event =3D=3D BPF_EVENT_LOAD;
 =09struct audit_buffer *ab;
=20
 =09if (audit_enabled =3D=3D AUDIT_OFF)
@@ -1342,10 +1341,7 @@ static void bpf_audit_prog(const struct bpf_prog *pr=
og, enum bpf_event event)
 =09ab =3D audit_log_start(audit_context(), GFP_ATOMIC, AUDIT_BPF);
 =09if (unlikely(!ab))
 =09=09return;
-=09if (has_task_context)
-=09=09audit_log_task(ab);
-=09audit_log_format(ab, "%sprog-id=3D%u event=3D%s",
-=09=09=09 has_task_context ? " " : "",
+=09audit_log_format(ab, "prog-id=3D%u event=3D%s",
 =09=09=09 prog->aux->id, bpf_event_audit_str[event]);
 =09audit_log_end(ab);
 }
--=20
2.23.0

