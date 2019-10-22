Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC03E0D07
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 22:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388573AbfJVUHA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 16:07:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:30682 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1731769AbfJVUG7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Oct 2019 16:06:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571774817;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/PiRJCNLGvnO+cq8W87jW4K+Id7+0dBbGrIRPQYjd1k=;
        b=I0ppeT7SUxkNfefprVzwfgH/3wWhxlPerY21IOXZuuLvogL3U+JvPj34gsdYV10mopT+47
        EnGIbxT4LzNSpXsjvkdbjxUD2TsvQ8e0BuhcfsWCZds9dzIeyMuwYtvnBN7TbnHBo3AaYW
        HIqiFm7iFFodaFaTiR8zRvDw1ih9Ry0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-119-OCp1J3PgPBakYjcmJwxnXQ-1; Tue, 22 Oct 2019 16:06:52 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E357380183D;
        Tue, 22 Oct 2019 20:06:49 +0000 (UTC)
Received: from madcap2.tricolour.ca (ovpn-112-19.phx2.redhat.com [10.3.112.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9DF6660856;
        Tue, 22 Oct 2019 20:06:35 +0000 (UTC)
Date:   Tue, 22 Oct 2019 16:06:32 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     Paul Moore <paul@paul-moore.com>,
        containers@lists.linux-foundation.org, linux-api@vger.kernel.org,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        sgrubb@redhat.com, omosnace@redhat.com, dhowells@redhat.com,
        simo@redhat.com, Eric Paris <eparis@parisplace.org>,
        Serge Hallyn <serge@hallyn.com>, ebiederm@xmission.com,
        Dan Walsh <dwalsh@redhat.com>, mpatel@redhat.com
Subject: Re: [PATCH ghak90 V7 20/21] audit: add capcontid to set contid
 outside init_user_ns
Message-ID: <20191022200632.al5ajlaahsvjeuma@madcap2.tricolour.ca>
References: <cover.1568834524.git.rgb@redhat.com>
 <214163d11a75126f610bcedfad67a4d89575dc77.1568834525.git.rgb@redhat.com>
 <20191019013904.uevmrzbmztsbhpnh@madcap2.tricolour.ca>
 <CAHC9VhRPygA=LsHLUqv+K=ouAiPFJ6fb2_As=OT-_zB7kGc_aQ@mail.gmail.com>
 <20191021213824.6zti5ndxu7sqs772@madcap2.tricolour.ca>
 <CAHC9VhRdNXsY4neJpSoNyJoAVEoiEc2oW5kSscF99tjmoQAxFA@mail.gmail.com>
 <20191021235734.mgcjotdqoe73e4ha@madcap2.tricolour.ca>
 <CAHC9VhSiwnY-+2awxvGeO4a0NgfVkOPd8fzzBVujp=HtjskTuQ@mail.gmail.com>
 <20191022121302.GA9397@hmswarspite.think-freely.org>
MIME-Version: 1.0
In-Reply-To: <20191022121302.GA9397@hmswarspite.think-freely.org>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: OCp1J3PgPBakYjcmJwxnXQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-10-22 08:13, Neil Horman wrote:
> On Mon, Oct 21, 2019 at 08:31:37PM -0400, Paul Moore wrote:
> > On Mon, Oct 21, 2019 at 7:58 PM Richard Guy Briggs <rgb@redhat.com> wro=
te:
> > > On 2019-10-21 17:43, Paul Moore wrote:
> > > > On Mon, Oct 21, 2019 at 5:38 PM Richard Guy Briggs <rgb@redhat.com>=
 wrote:
> > > > > On 2019-10-21 15:53, Paul Moore wrote:
> > > > > > On Fri, Oct 18, 2019 at 9:39 PM Richard Guy Briggs <rgb@redhat.=
com> wrote:
> > > > > > > On 2019-09-18 21:22, Richard Guy Briggs wrote:
> > > > > > > > Provide a mechanism similar to CAP_AUDIT_CONTROL to explici=
tly give a
> > > > > > > > process in a non-init user namespace the capability to set =
audit
> > > > > > > > container identifiers.
> > > > > > > >
> > > > > > > > Use audit netlink message types AUDIT_GET_CAPCONTID 1027 an=
d
> > > > > > > > AUDIT_SET_CAPCONTID 1028.  The message format includes the =
data
> > > > > > > > structure:
> > > > > > > > struct audit_capcontid_status {
> > > > > > > >         pid_t   pid;
> > > > > > > >         u32     enable;
> > > > > > > > };
> > > > > > >
> > > > > > > Paul, can I get a review of the general idea here to see if y=
ou're ok
> > > > > > > with this way of effectively extending CAP_AUDIT_CONTROL for =
the sake of
> > > > > > > setting contid from beyond the init user namespace where capa=
ble() can't
> > > > > > > reach and ns_capable() is meaningless for these purposes?
> > > > > >
> > > > > > I think my previous comment about having both the procfs and ne=
tlink
> > > > > > interfaces apply here.  I don't see why we need two different A=
PIs at
> > > > > > the start; explain to me why procfs isn't sufficient.  If the a=
rgument
> > > > > > is simply the desire to avoid mounting procfs in the container,=
 how
> > > > > > many container orchestrators can function today without a valid=
 /proc?
> > > > >
> > > > > Ok, sorry, I meant to address that question from a previous patch
> > > > > comment at the same time.
> > > > >
> > > > > It was raised by Eric Biederman that the proc filesystem interfac=
e for
> > > > > audit had its limitations and he had suggested an audit netlink
> > > > > interface made more sense.
> > > >
> > > > I'm sure you've got it handy, so I'm going to be lazy and ask: arch=
ive
> > > > pointer to Eric's comments?  Just a heads-up, I'm really *not* a fa=
n
> > > > of using the netlink interface for this, so unless Eric presents a
> > > > super compelling reason for why we shouldn't use procfs I'm incline=
d
> > > > to stick with /proc.
> > >
> > > It was actually a video call with Eric and Steve where that was
> > > recommended, so I can't provide you with any first-hand communication
> > > about it.  I'll get more details...
> >=20
> > Yeah, that sort of information really needs to be on the list.
> >=20
> > > So, with that out of the way, could you please comment on the general
> > > idea of what was intended to be the central idea of this mechanism to=
 be
> > > able to nest containers beyond the initial user namespace (knowing th=
at
> > > a /proc interface is available and the audit netlink interface isn't
> > > necessary for it to work and the latter can be easily removed)?
> >=20
> > I'm not entirely clear what you are asking about, are you asking why I
> > care about nesting container orchestrators?  Simply put, it is not
> > uncommon for the LXC/LXD folks to see nested container orchestrators,
> > so I felt it was important to support that use case.  When we
> > originally started this effort we probably should have done a better
> > job reaching out to the LXC/LXD folks, we may have caught this
> > earlier.  Regardless, we caught it, and it looks like we are on our
> > way to supporting it (that's good).
> >=20
> > Are you asking why I prefer the procfs approach to setting/getting the
> > audit container ID?  For one, it makes it easier for a LSM to enforce
> > the audit container ID operations independent of the other audit
> > control APIs.  It also provides a simpler interface for container
> > orchestrators.  Both seem like desirable traits as far as I'm
> > concerned.
>=20
> I agree that one api is probably the best approach here, but I actually
> think that the netlink interface is the more flexible approach.  Its a
> little more work for userspace (you have to marshal your data into a
> netlink message before sending it, and wait for an async response), but
> thats a well known pattern, and it provides significantly more
> flexibility for the kernel.  LSM already has a hook to audit netlink
> messages in sock_sendmsg, so thats not a problem, and if you use
> netlink, you get the advantage of being able to broadcast messages
> within your network namespaces, facilitating any needed orchestrator
> co-ordination.  To do the same thing with a filesystem api, you need to
> use the fanotify api, which IIRC doesn't work on proc.

One api was the intent, deprecating proc for loginuid and sessionid if
netlink was the chosen way to go.

I don't think we had discussed the possibility or need to use netlink
multicast for this purpose and see it as a liability to limiting access
to only those processes that need it.

> Neil
>=20
> > > > > The intent was to switch to the audit netlink interface for conti=
d,
> > > > > capcontid and to add the audit netlink interface for loginuid and
> > > > > sessionid while deprecating the proc interface for loginuid and
> > > > > sessionid.  This was alluded to in the cover letter, but not very=
 clear,
> > > > > I'm afraid.  I have patches to remove the contid and loginuid/ses=
sionid
> > > > > interfaces in another tree which is why I had forgotten to outlin=
e that
> > > > > plan more explicitly in the cover letter.
> >=20
> > paul moore

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

