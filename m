Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3090CF52BE
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 18:42:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729443AbfKHRlc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 12:41:32 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:45903 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727477AbfKHRlb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 12:41:31 -0500
Received: by mail-lj1-f196.google.com with SMTP id n21so7068002ljg.12
        for <netdev@vger.kernel.org>; Fri, 08 Nov 2019 09:41:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2QJNYK/K5bdE2+Gkhht7sK48ftHkXUxqx+uBQkHd5Ts=;
        b=QypV/fGwmulAvg9MruUmhTnYlDA5c5MJNSURS6J4En6OmXgJCg+YzoAsYTaRujB1z2
         hP3WmSV5DjQioueVpPG3QmHbeJLut69f9I+1DQgPU/BD2+aGZ3ejRua7P1liI5dYyec1
         VbTAEROuyB6wd7DALgpKJp9LL/KaJ9AMfqXycwbHkU2tANkyllLPDuAhNMhMqpaYReqf
         jnxNC1z4Yt9DaALjdUk7R96nLeV8nV9MqdftZRgTPy97YQp3GAW3PvqRpPilOY8+Kgbs
         IlHk8zyie1aSeWSxTd7bQdJ0hzRGPU1XmE2G6lwTktuXjEodiYlwA3s2YIRwBwdtJYVc
         SV0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2QJNYK/K5bdE2+Gkhht7sK48ftHkXUxqx+uBQkHd5Ts=;
        b=nn7btKBg93Q6w9Jry4wAMl4pL34nqbg0u026N9qjM5ML+fRB2IwNuzJWPk7UoomYZS
         m+hVqnDdS4PQ7ecCoBmIvEhSYlUa+TeZPSbUkfe2nNMXrV97uz5tXveh1ITBQqG5Fw9F
         jNcAVvlX/wX8Tjj8GGRKaIIVsIXBprjx1ri81CKoXLqhjHrzhVJ3+9XexiYCKwVjCl45
         H7t5YyXgguiLcWY8AnEyRZzWcInZUyD+9m2De5vRC7HLCg9L/zjh30weLlTQwClzejGP
         +g18ksiDXR0C/XAwYOBL9l3ud+h7Zf4LlQ5f/kiZQMr3LG+V1zMHWUoR5EpAp0iui5EX
         jE1Q==
X-Gm-Message-State: APjAAAXjsiIy3w0J+AKE8fFKEsjze2V3lswagDq/ry4he41WHWqozoq9
        FDRf0DMXVlG78LUYfT/yKS0KHRZJUpnMI2GAuxIZ
X-Google-Smtp-Source: APXvYqygpkXBVo+V/0rCDrfRnTBOydni+js2TBbay/jXRxqEePu5DxdbEDyaefBi0zEpgdxZttma4OhRzmRZQpH1wy4=
X-Received: by 2002:a2e:4703:: with SMTP id u3mr584888lja.126.1573234887049;
 Fri, 08 Nov 2019 09:41:27 -0800 (PST)
MIME-Version: 1.0
References: <cover.1568834524.git.rgb@redhat.com> <0850eaa785e2ff30c8c4818fd53e9544b34ed884.1568834524.git.rgb@redhat.com>
 <CAHC9VhQoFFaQACbV4QHG_NPUCJu1+V=x3=i-yyGjbsYq8HuPtg@mail.gmail.com> <20191025192031.ul3yjy2q57vsvier@madcap2.tricolour.ca>
In-Reply-To: <20191025192031.ul3yjy2q57vsvier@madcap2.tricolour.ca>
From:   Paul Moore <paul@paul-moore.com>
Date:   Fri, 8 Nov 2019 12:41:16 -0500
Message-ID: <CAHC9VhQTz3f9p9knMP0Rsz=zH5HTEXBb7iN7o_jr=FN9sGWp8g@mail.gmail.com>
Subject: Re: [PATCH ghak90 V7 08/21] audit: add contid support for signalling
 the audit daemon
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        nhorman@tuxdriver.com, Dan Walsh <dwalsh@redhat.com>,
        mpatel@redhat.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 3:20 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> On 2019-10-10 20:39, Paul Moore wrote:
> > On Wed, Sep 18, 2019 at 9:25 PM Richard Guy Briggs <rgb@redhat.com> wrote:
> > > Add audit container identifier support to the action of signalling the
> > > audit daemon.
> > >
> > > Since this would need to add an element to the audit_sig_info struct,
> > > a new record type AUDIT_SIGNAL_INFO2 was created with a new
> > > audit_sig_info2 struct.  Corresponding support is required in the
> > > userspace code to reflect the new record request and reply type.
> > > An older userspace won't break since it won't know to request this
> > > record type.
> > >
> > > Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> > > ---
> > >  include/linux/audit.h       |  7 +++++++
> > >  include/uapi/linux/audit.h  |  1 +
> > >  kernel/audit.c              | 28 ++++++++++++++++++++++++++++
> > >  kernel/audit.h              |  1 +
> > >  security/selinux/nlmsgtab.c |  1 +
> > >  5 files changed, 38 insertions(+)
> > >
> > > diff --git a/include/linux/audit.h b/include/linux/audit.h
> > > index 0c18d8e30620..7b640c4da4ee 100644
> > > --- a/include/linux/audit.h
> > > +++ b/include/linux/audit.h
> > > @@ -23,6 +23,13 @@ struct audit_sig_info {
> > >         char            ctx[0];
> > >  };
> > >
> > > +struct audit_sig_info2 {
> > > +       uid_t           uid;
> > > +       pid_t           pid;
> > > +       u64             cid;
> > > +       char            ctx[0];
> > > +};
> > > +
> > >  struct audit_buffer;
> > >  struct audit_context;
> > >  struct inode;
> > > diff --git a/include/uapi/linux/audit.h b/include/uapi/linux/audit.h
> > > index 4ed080f28b47..693ec6e0288b 100644
> > > --- a/include/uapi/linux/audit.h
> > > +++ b/include/uapi/linux/audit.h
> > > @@ -72,6 +72,7 @@
> > >  #define AUDIT_SET_FEATURE      1018    /* Turn an audit feature on or off */
> > >  #define AUDIT_GET_FEATURE      1019    /* Get which features are enabled */
> > >  #define AUDIT_CONTAINER_OP     1020    /* Define the container id and info */
> > > +#define AUDIT_SIGNAL_INFO2     1021    /* Get info auditd signal sender */
> > >
> > >  #define AUDIT_FIRST_USER_MSG   1100    /* Userspace messages mostly uninteresting to kernel */
> > >  #define AUDIT_USER_AVC         1107    /* We filter this differently */
> > > diff --git a/kernel/audit.c b/kernel/audit.c
> > > index adfb3e6a7f0c..df3db29f5a8a 100644
> > > --- a/kernel/audit.c
> > > +++ b/kernel/audit.c
> > > @@ -125,6 +125,7 @@ struct audit_net {
> > >  kuid_t         audit_sig_uid = INVALID_UID;
> > >  pid_t          audit_sig_pid = -1;
> > >  u32            audit_sig_sid = 0;
> > > +u64            audit_sig_cid = AUDIT_CID_UNSET;
> > >
> > >  /* Records can be lost in several ways:
> > >     0) [suppressed in audit_alloc]
> > > @@ -1094,6 +1095,7 @@ static int audit_netlink_ok(struct sk_buff *skb, u16 msg_type)
> > >         case AUDIT_ADD_RULE:
> > >         case AUDIT_DEL_RULE:
> > >         case AUDIT_SIGNAL_INFO:
> > > +       case AUDIT_SIGNAL_INFO2:
> > >         case AUDIT_TTY_GET:
> > >         case AUDIT_TTY_SET:
> > >         case AUDIT_TRIM:
> > > @@ -1257,6 +1259,7 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
> > >         struct audit_buffer     *ab;
> > >         u16                     msg_type = nlh->nlmsg_type;
> > >         struct audit_sig_info   *sig_data;
> > > +       struct audit_sig_info2  *sig_data2;
> > >         char                    *ctx = NULL;
> > >         u32                     len;
> > >
> > > @@ -1516,6 +1519,30 @@ static int audit_receive_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
> > >                                  sig_data, sizeof(*sig_data) + len);
> > >                 kfree(sig_data);
> > >                 break;
> > > +       case AUDIT_SIGNAL_INFO2:
> > > +               len = 0;
> > > +               if (audit_sig_sid) {
> > > +                       err = security_secid_to_secctx(audit_sig_sid, &ctx, &len);
> > > +                       if (err)
> > > +                               return err;
> > > +               }
> > > +               sig_data2 = kmalloc(sizeof(*sig_data2) + len, GFP_KERNEL);
> > > +               if (!sig_data2) {
> > > +                       if (audit_sig_sid)
> > > +                               security_release_secctx(ctx, len);
> > > +                       return -ENOMEM;
> > > +               }
> > > +               sig_data2->uid = from_kuid(&init_user_ns, audit_sig_uid);
> > > +               sig_data2->pid = audit_sig_pid;
> > > +               if (audit_sig_sid) {
> > > +                       memcpy(sig_data2->ctx, ctx, len);
> > > +                       security_release_secctx(ctx, len);
> > > +               }
> > > +               sig_data2->cid = audit_sig_cid;
> > > +               audit_send_reply(skb, seq, AUDIT_SIGNAL_INFO2, 0, 0,
> > > +                                sig_data2, sizeof(*sig_data2) + len);
> > > +               kfree(sig_data2);
> > > +               break;
> > >         case AUDIT_TTY_GET: {
> > >                 struct audit_tty_status s;
> > >                 unsigned int t;
> > > @@ -2384,6 +2411,7 @@ int audit_signal_info(int sig, struct task_struct *t)
> > >                 else
> > >                         audit_sig_uid = uid;
> > >                 security_task_getsecid(current, &audit_sig_sid);
> > > +               audit_sig_cid = audit_get_contid(current);
> > >         }
> >
> > I've been wondering something as I've been working my way through
> > these patches and this patch seems like a good spot to discuss this
> > ... Now that we have the concept of an audit container ID "lifetime"
> > in the kernel, when do we consider the ID gone?  Is it when the last
> > process in the container exits, or is it when we generate the last
> > audit record which could possibly contain the audit container ID?
> > This patch would appear to support the former, but if we wanted the
> > latter we would need to grab a reference to the audit container ID
> > struct so it wouldn't "die" on us before we could emit the signal info
> > record.
>
> Are you concerned with the availability of the data when the audit
> signal info record is generated, when the kernel last deals with a
> particular contid or when userspace thinks there will be no more
> references to it?
>
> I've got a bit of a dilemma with this one...
>
> In fact, the latter situation you describe isn't a concern at present to
> be able to deliver the information since the value is copied into the
> audit signal global internal variables before the signalling task dies
> and the audit signal info record is created from those copied (cached)
> values when requested from userspace.
>
> So the issue raised above I don't think is a problem.  However, patch 18
> (which wasn't reviewed because it was a patch to a number of preceeding
> patches) changes the reporting approach to give a chain of nested
> contids which isn't reflected in the same level of reporting for the
> audit signal patch/mechanism.  Solving this is a bit more complex.  We
> could have the audit signal internal caching store a pointer to the
> relevant container object and bump its refcount to ensure it doesn't
> vanish until we are done with it, but the audit signal info binary
> record format already has a variable length due to the selinux context
> at the end of that struct and adding a second variable length element to
> it would make it more complicated (but not impossible) to handle.

[side note #1: Sorry for the delay, travel/conferences have limited my
time and I felt we needed to focus on the larger issue of
netlink/procfs first.  Back to the other topics ...]

[side note #2: I just realized that one can shorten "audit container
ID" to ACID, I think that's going to be my favorite realization of the
day :)]

My concern wasn't really about the availability of the data, since as
you said, it is copied into the record buffer, but rather a delay
between when the audit container ID (ACID) disappears from the
tracking/list db in the kernel to when it is emitted in an audit
record from the kernel.  During this time is seems like it could be
possible for the orchestrator to reintroduce the same ACID value and
if someone is not taking into account the full audit history they
could get confused (the full audit history should show the proper
creation/destruction events in the correct order).  Ultimately I'm not
sure it is a major issue, and fixing it is likely to be really ugly,
but I think it would be good to add some comments in the code
regarding what we guarantee as far as ACID lifetimes are concerned.

-- 
paul moore
www.paul-moore.com
