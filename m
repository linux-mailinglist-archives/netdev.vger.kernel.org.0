Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69C912FDEB
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 16:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726688AbfE3Oeh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 10:34:37 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:41077 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725934AbfE3Oeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 10:34:37 -0400
Received: by mail-lj1-f194.google.com with SMTP id q16so6272582ljj.8
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 07:34:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LvgFttjwD8tpRb4Jny1liBYRgYtyF5gETJat0Y6PZj0=;
        b=q3wQyXDPkal/vbviUhmSsus3N1NxrIZmQgfZu7EO565zOv9aRNeYWHTdfey/MLFGeh
         u41nVQ/vy4O+cZe9sliGlYVDpuvuuBfZ2UCFXtI6RgTjNhJb7DYbdM2SO/NCpkksto5C
         roCPGZJWmHUfoDVyKX9dtsxOh+iwtrsqiqc5rvFw9fNoRX0dcZ+TC/YO/PzGI+QdrDDX
         HQUkFj02JNl0X/EuTmkbm08dH2+9gvOwVC3UaYlZiFTdp76nkd8ih+Y9+XEM3yrDOLVo
         KPX2U6QS5I6g0EtJnwfrfdorXlRKGU3I1dA/DtKQXbjNEyGsWZvxcbbywx/hN6zbdMyX
         2zHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LvgFttjwD8tpRb4Jny1liBYRgYtyF5gETJat0Y6PZj0=;
        b=lW2BCR9NPylojMcy/xBVuDuzg7IfNbcti2o57l0Ti0rgSFyHmJX3biKc7ivGWHI3iN
         m/PMCzIncOVhhaFM17x/IRFo66w2Hl8seSIkT2N3t3lrCzKwHvcSRhqHzoDGk5eL3/3S
         xcAaK4GC2hl0NdDJ0evNvzcT3mHp1zRJ2EMQ8T83Q/zhrbbAuaPH4wEJ1rEqBKB/FtAZ
         6OfjfowMA3kM0R+s9l4MhDMVxkG2XzZT3W7GK4zCWoenO/3eXbo+RS7VeaCLYv7NZ65i
         Z3YaC68jAhoFM4JU02dGOJO/O99crq/+s06JPIjQuVlKOxiebdRRRso+PD95T+5ZSzXI
         n1uQ==
X-Gm-Message-State: APjAAAWtnzJSUSu4k178wn59xkbnyua/wX4Tc+utvyqnSNy4dGct8+im
        NzTUIl50eoDTvd745ZqC4hcP7xkPe6TD4vBk9Vdi
X-Google-Smtp-Source: APXvYqyjvx+X9oscT0G4c8PQ+mVJEW5ymbmBDFkXIm1AiMAVU6LeKUfdKbw4F+bsXGSGzh/ysbZI7qzRbZPtkRVsVHE=
X-Received: by 2002:a2e:900e:: with SMTP id h14mr2326343ljg.77.1559226874389;
 Thu, 30 May 2019 07:34:34 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1554732921.git.rgb@redhat.com> <f4a49f7c949e5df80c339a3fe5c4c2303b12bf23.1554732921.git.rgb@redhat.com>
 <CAHC9VhRfQp-avV2rcEOvLCAXEz-MDZMp91UxU+BtvPkvWny9fQ@mail.gmail.com>
 <CAFqZXNsK6M_L_0dFzkEgh_QVP-fyb+fE0MMRsJ2kXxtKM3VUKA@mail.gmail.com> <20190530140849.zdxvlvkefwpngfil@madcap2.tricolour.ca>
In-Reply-To: <20190530140849.zdxvlvkefwpngfil@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 30 May 2019 10:34:22 -0400
Message-ID: <CAHC9VhQd0FHyPWaN9YyGctJAL+KGL57YxyVJctshUgTt8L=tJA@mail.gmail.com>
Subject: Re: [PATCH ghak90 V6 04/10] audit: log container info of syscalls
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Ondrej Mosnacek <omosnace@redhat.com>,
        Neil Horman <nhorman@tuxdriver.com>, linux-api@vger.kernel.org,
        containers@lists.linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>,
        David Howells <dhowells@redhat.com>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        netfilter-devel@vger.kernel.org,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Simo Sorce <simo@redhat.com>, netdev@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 30, 2019 at 10:09 AM Richard Guy Briggs <rgb@redhat.com> wrote:
>
> On 2019-05-30 15:08, Ondrej Mosnacek wrote:
> > On Thu, May 30, 2019 at 12:16 AM Paul Moore <paul@paul-moore.com> wrote=
:
> > > On Mon, Apr 8, 2019 at 11:40 PM Richard Guy Briggs <rgb@redhat.com> w=
rote:
> > > >
> > > > Create a new audit record AUDIT_CONTAINER_ID to document the audit
> > > > container identifier of a process if it is present.
> > > >
> > > > Called from audit_log_exit(), syscalls are covered.
> > > >
> > > > A sample raw event:
> > > > type=3DSYSCALL msg=3Daudit(1519924845.499:257): arch=3Dc000003e sys=
call=3D257 success=3Dyes exit=3D3 a0=3Dffffff9c a1=3D56374e1cef30 a2=3D241 =
a3=3D1b6 items=3D2 ppid=3D606 pid=3D635 auid=3D0 uid=3D0 gid=3D0 euid=3D0 s=
uid=3D0 fsuid=3D0 egid=3D0 sgid=3D0 fsgid=3D0 tty=3Dpts0 ses=3D3 comm=3D"ba=
sh" exe=3D"/usr/bin/bash" subj=3Dunconfined_u:unconfined_r:unconfined_t:s0-=
s0:c0.c1023 key=3D"tmpcontainerid"
> > > > type=3DCWD msg=3Daudit(1519924845.499:257): cwd=3D"/root"
> > > > type=3DPATH msg=3Daudit(1519924845.499:257): item=3D0 name=3D"/tmp/=
" inode=3D13863 dev=3D00:27 mode=3D041777 ouid=3D0 ogid=3D0 rdev=3D00:00 ob=
j=3Dsystem_u:object_r:tmp_t:s0 nametype=3D PARENT cap_fp=3D0 cap_fi=3D0 cap=
_fe=3D0 cap_fver=3D0
> > > > type=3DPATH msg=3Daudit(1519924845.499:257): item=3D1 name=3D"/tmp/=
tmpcontainerid" inode=3D17729 dev=3D00:27 mode=3D0100644 ouid=3D0 ogid=3D0 =
rdev=3D00:00 obj=3Dunconfined_u:object_r:user_tmp_t:s0 nametype=3DCREATE ca=
p_fp=3D0 cap_fi=3D0 cap_fe=3D0 cap_fver=3D0
> > > > type=3DPROCTITLE msg=3Daudit(1519924845.499:257): proctitle=3D62617=
368002D6300736C65657020313B206563686F2074657374203E202F746D702F746D70636F6E=
7461696E65726964
> > > > type=3DCONTAINER_ID msg=3Daudit(1519924845.499:257): contid=3D12345=
8
> > > >
> > > > Please see the github audit kernel issue for the main feature:
> > > >   https://github.com/linux-audit/audit-kernel/issues/90
> > > > Please see the github audit userspace issue for supporting addition=
s:
> > > >   https://github.com/linux-audit/audit-userspace/issues/51
> > > > Please see the github audit testsuiite issue for the test case:
> > > >   https://github.com/linux-audit/audit-testsuite/issues/64
> > > > Please see the github audit wiki for the feature overview:
> > > >   https://github.com/linux-audit/audit-kernel/wiki/RFE-Audit-Contai=
ner-ID
> > > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > > Acked-by: Serge Hallyn <serge@hallyn.com>
> > > > Acked-by: Steve Grubb <sgrubb@redhat.com>
> > > > Acked-by: Neil Horman <nhorman@tuxdriver.com>
> > > > Reviewed-by: Ondrej Mosnacek <omosnace@redhat.com>
> > > > ---
> > > >  include/linux/audit.h      |  5 +++++
> > > >  include/uapi/linux/audit.h |  1 +
> > > >  kernel/audit.c             | 20 ++++++++++++++++++++
> > > >  kernel/auditsc.c           | 20 ++++++++++++++------
> > > >  4 files changed, 40 insertions(+), 6 deletions(-)
> > >
> > > ...
> > >
> > > > diff --git a/kernel/audit.c b/kernel/audit.c
> > > > index 182b0f2c183d..3e0af53f3c4d 100644
> > > > --- a/kernel/audit.c
> > > > +++ b/kernel/audit.c
> > > > @@ -2127,6 +2127,26 @@ void audit_log_session_info(struct audit_buf=
fer *ab)
> > > >         audit_log_format(ab, "auid=3D%u ses=3D%u", auid, sessionid)=
;
> > > >  }
> > > >
> > > > +/*
> > > > + * audit_log_contid - report container info
> > > > + * @context: task or local context for record
> > > > + * @contid: container ID to report
> > > > + */
> > > > +void audit_log_contid(struct audit_context *context, u64 contid)
> > > > +{
> > > > +       struct audit_buffer *ab;
> > > > +
> > > > +       if (!audit_contid_valid(contid))
> > > > +               return;
> > > > +       /* Generate AUDIT_CONTAINER_ID record with container ID */
> > > > +       ab =3D audit_log_start(context, GFP_KERNEL, AUDIT_CONTAINER=
_ID);
> > > > +       if (!ab)
> > > > +               return;
> > > > +       audit_log_format(ab, "contid=3D%llu", (unsigned long long)c=
ontid);
> > >
> > > We have a consistency problem regarding how to output the u64 contid
> > > values; this function uses an explicit cast, others do not.  Accordin=
g
> > > to Documentation/core-api/printk-formats.rst the recommendation for
> > > u64 is %llu (or %llx, if you want hex).  Looking quickly through the
> > > printk code this appears to still be correct.  I suggest we get rid o=
f
> > > the cast (like it was in v5).
> >
> > IIRC it was me who suggested to add the casts. I didn't realize that
> > the kernel actually guarantees that "%llu" will always work with u64.
> > Taking that into account I rescind my request to add the cast. Sorry
> > for the false alarm.
>
> Yeah, just remove the cast.

Okay, this is trivial enough I'll take care of this during the merge
with a note.

--=20
paul moore
www.paul-moore.com
