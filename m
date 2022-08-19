Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0132E59A35F
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 20:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354628AbiHSRjr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 13:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354686AbiHSRj3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 13:39:29 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED3D47648;
        Fri, 19 Aug 2022 09:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=93je+l32fhwUksUv1r9NXWNteIJ3BkxxqgdUUZ0C+Dk=;
        t=1660928247; x=1662137847; b=RzL3IM0Bz7C4o1a9ixy/R54/8WsUz8quImRoAl9gJ9pOuz2
        xfao62M8WACFfC0rvSRHikB6LcH60JeblvoIZbjJHZIzLNqM4mrVNcmP0iqynvAPmlpaRmhIDwzer
        csn+txFh4JL1G44z93NaAGB7w2EfLlAIpdSkGOcjqD8EFJ9OoT/21Wy8yl/4R01QB+m8iKgaKVmU9
        xgDRURLOa9l7wQnlWnsz3P3F9Ov2ipaCqsKYQn7beuKjzMP1edAHAvTjxpkE1khHg+JD5kyTEu/Uf
        q24aI3WLgx/3fTdHFxA6Pv0A+zTdet3Acy0p0T7F8T2F2zCimIwqCY7qKbiQikSw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oP5Is-00C6UM-10;
        Fri, 19 Aug 2022 18:57:02 +0200
Message-ID: <959012cfd753586b81ff60b37301247849eb274c.camel@sipsolutions.net>
Subject: Re: [PATCH net-next 2/2] docs: netlink: basic introduction to
 Netlink
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, corbet@lwn.net,
        stephen@networkplumber.org, sdf@google.com, ecree.xilinx@gmail.com,
        benjamin.poirier@gmail.com, idosch@idosch.org,
        f.fainelli@gmail.com, jiri@resnulli.us, dsahern@kernel.org,
        fw@strlen.de, linux-doc@vger.kernel.org, jhs@mojatatu.com,
        tgraf@suug.ch, jacob.e.keller@intel.com, svinota.saveliev@gmail.com
Date:   Fri, 19 Aug 2022 18:57:01 +0200
In-Reply-To: <20220819092029.10316adb@kernel.org>
References: <20220818023504.105565-1-kuba@kernel.org>
         <20220818023504.105565-2-kuba@kernel.org>
         <6350516756628945f9cc1ee0248e92473521ed0b.camel@sipsolutions.net>
         <20220819092029.10316adb@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4 (3.44.4-1.fc36) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-08-19 at 09:20 -0700, Jakub Kicinski wrote:
> > >=20
> > > +Headers in netlink must be aligned to 4 bytes from the start of the =
message, =20
> >=20
> > s/Headers/Attribute headers/ perhaps?
>=20
> Theoretically I think we also align what I called "fixed metadata
> headers", practically all of those are multiple of 4 :S

But they're not really aligned, are they? Hmm. Well I guess practically
it doesn't matter. I just read this and wasn't really sure what the
mention of "[h]eaders" was referring to in this context.

> > > +hence the extra ``\0\0`` at the end of the message.
> >=20
> > And I think technically for the _last_ attribute it wouldn't be needed?
>=20
> True, it's not strictly necessary AFAIU. Should I mention it=20
> or would that be over-complicating things?
>=20
> I believe that kernel will accept both forms (without tripping=20
> the trailing data warning), and both the kernel and mnl will pad=20
> out the last attr.

Yeah, probably not worth mentioning it.

I think what threw me off was the explicit mention of "at the end of the
message" - perhaps just say "after the family name attribute"?

> > > +``NLMSGERR_ATTR_MSG`` carries a message in English describing
> > > +the encountered problem. These messages are far more detailed
> > > +than what can be expressed thru standard UNIX error codes. =20
> >=20
> > "through"?
>=20
> How much do you care? Maybe Jon has guidelines?

Hah, not much really.

> > > +Querying family information is useful in rare cases when user space =
needs =20
> >=20
> > debatable if that's "rare", but yeah, today it's not done much :)
>=20
> Some of the text is written with the implicit goal of comforting=20
> the newcomer ;)

:-)

In this document it just feels like saying it _should_ be rare, but I'm
not sure it should? We ignore it a lot in practice, but maybe we should
be doing it more?

> > I think this could be written a bit better - we call this thing a "port
> > ID" internally now, and yes, it might default to a process ID (more
> > specifically task group ID) ... but it feels like this could explain
> > bind vs. autobind etc. a bit more? And IMHO it should focus less on the
> > process ID/PID than saying "port ID" with a (historical) default of
> > using the PID/TGID.
>=20
> I'll rewrite. The only use I'm aware of is OvS upcalls, are there more?

In nl80211 we have quite a few "unicast an event message to a specific
portid" uses, e.g. if userspace subscribes to certain action frames, the
frame notification for it would be unicast to the subscribed socket, or
the TX status response after a frame was transmitted, etc. etc.

> Practically speaking for a person trying to make a ethtool, FOU,
> devlink etc. call to the kernel this is 100% irrelevant.

Fair point, depends on what you're using and what programming model that
has.

> > > +Strict checking
> > > +---------------
> > > +
> > > +The ``NETLINK_GET_STRICT_CHK`` socket option enables strict input ch=
ecking
> > > +in ``NETLINK_ROUTE``. It was needed because historically kernel did =
not
> > > +validate the fields of structures it didn't process. This made it im=
possible
> > > +to start using those fields later without risking regressions in app=
lications
> > > +which initialized them incorrectly or not at all.
> > > +
> > > +``NETLINK_GET_STRICT_CHK`` declares that the application is initiali=
zing
> > > +all fields correctly. It also opts into validating that message does=
 not
> > > +contain trailing data and requests that kernel rejects attributes wi=
th
> > > +type higher than largest attribute type known to the kernel.
> > > +
> > > +``NETLINK_GET_STRICT_CHK`` is not used outside of ``NETLINK_ROUTE``.=
 =20
> >=20
> > However, there are also more generally strict checks in policy
> > validation ... maybe a discussion of all that would be worthwhile?
>=20
> Yeah :( It's too much to describe to a newcomer, I figured. I refer
> those who care to the enum field in the next section. We'd need a full
> table of families and attrs which start strict(er) validation.. bah. Too
> much technical debt.

Yes ... Also sometimes attributes in a dump request are checked,
sometimes not, sometimes just ignored, etc. Certainly not worth handling
here though.

> >  - maybe not the appropriate place here, but maybe some best practices
> >    for handling attributes, such as the multi-attribute array thing we
> >    discussed in the other thread?
>=20
> Right, this doc is meant for the user rather than kernel dev.=C2=A0
>=20

Makes sense. The user anyway will have to look at how their specific
family does things, and do it accordingly.

> I'm planning to write a separate doc for the kernel dev.

Nice, looking forward to that! :)
=20
> I started writing this one as guide for a person who would like to write
> a YAML NL library for their fav user space language but has no prior
> knowledge of netlink and does not know where to start.

Makes sense.

> >  - maybe more userspace recommendations such as using different sockets
> >    for multicast listeners and requests, because otherwise it gets
> >    tricky to wait for the ACK of a request since you have to handle
> >    notifications that happen meanwhile?
>=20
> Hm, good point. I should add a section on multicast and make it part=20
> of that.

True that, multicast more generally is something to know about.

> >  - maybe some mention of the fact that sometimes we now bind kernel
> >    object or state lifetime to a socket, e.g. in wireless you can
> >    connect and if your userspace crashes/closes the socket, the
> >    connection is automatically torn down (because you can't handle the
> >    things needed anymore)
>=20
> =F0=9F=98=8D Can you point me to the code? (probably too advanced for thi=
s doc
> but the idea seems super useful!)

Look at the uses of NL80211_ATTR_SOCKET_OWNER, e.g. you can
 * create a virtual interface and have it disappear if you close the
   socket (_nl80211_new_interface)
 * AP stopped if you close the socket (nl80211_start_ap)
 * some regulatory stuff reset (nl80211_req_set_reg)
 * background ("scheduled") scan stopped (nl80211_start_sched_scan)
 * connection torn down (nl80211_associate)
 * etc.

The actual teardown handling is in nl80211_netlink_notify().

I guess I can agree though it doesn't really belong here - again
something specific to the operations you're doing.

> >  - maybe something about message sizes? we've had lots of trouble with
> >    that in nl80211, but tbh I'm not really sure what we should say abou=
t
> >    it other than making sure you use large enough buffers ...
>=20
> Yes :S What's the error reported when the buffer is too small?
> recv() =3D -1, errno =3D EMSGSIZE? Does the message get discarded=20
> or can it be re-read? I don't have practical experience with
> that one.

Ugh, I repressed all those memories ... I don't remember now, I guess
I'd have to try it. Also it doesn't just apply to normal stuff but also
multicast, and that can be even trickier.

johannes
