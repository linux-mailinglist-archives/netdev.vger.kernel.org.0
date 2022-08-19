Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76AE059A565
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 20:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350193AbiHSSHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 14:07:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350270AbiHSSHQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 14:07:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96535118CBE;
        Fri, 19 Aug 2022 10:54:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C5676189A;
        Fri, 19 Aug 2022 17:54:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D23DCC433D6;
        Fri, 19 Aug 2022 17:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660931693;
        bh=FOm/jGItA30JTliEee4R75TC9WfbTP2C00CqnQEJStY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tuiCogj2+6FGsTEoWsqQ6chTrcUGeVc6PoLfBblTILUlICEzYC11JcFGM0cDBU4dJ
         36cmD++KdIpDmJLbeMvXPwVV9Li+jGYvX4nrrRpt95BRlKcf/hmy0XzEpnm7A6FSxw
         PEA62BC/vxfyeZFRUUx150+JWDLBq2kB8N5VhbuNGryJXpFrhcDAnTScUO+r/e2rlB
         +y5fSLAiYChtIQn3pO9cpZQg4gpLjlgf8SGkvKawsvqE17l7ZvekBRtifAgQbcLEO0
         /pmhtn2Bu95cV3Aq3uhojI3qoZ4L6dh0TdGgoVcQUUS4ZPpHTw2/gbEG+88YRdbsX3
         1pXvjXKrLJSCg==
Date:   Fri, 19 Aug 2022 10:54:51 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, corbet@lwn.net,
        stephen@networkplumber.org, sdf@google.com, ecree.xilinx@gmail.com,
        benjamin.poirier@gmail.com, idosch@idosch.org,
        f.fainelli@gmail.com, jiri@resnulli.us, dsahern@kernel.org,
        fw@strlen.de, linux-doc@vger.kernel.org, jhs@mojatatu.com,
        tgraf@suug.ch, jacob.e.keller@intel.com, svinota.saveliev@gmail.com
Subject: Re: [PATCH net-next 2/2] docs: netlink: basic introduction to
 Netlink
Message-ID: <20220819105451.1de66044@kernel.org>
In-Reply-To: <959012cfd753586b81ff60b37301247849eb274c.camel@sipsolutions.net>
References: <20220818023504.105565-1-kuba@kernel.org>
        <20220818023504.105565-2-kuba@kernel.org>
        <6350516756628945f9cc1ee0248e92473521ed0b.camel@sipsolutions.net>
        <20220819092029.10316adb@kernel.org>
        <959012cfd753586b81ff60b37301247849eb274c.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Aug 2022 18:57:01 +0200 Johannes Berg wrote:
> > Theoretically I think we also align what I called "fixed metadata
> > headers", practically all of those are multiple of 4 :S =20
>=20
> But they're not really aligned, are they? Hmm. Well I guess practically
> it doesn't matter. I just read this and wasn't really sure what the
> mention of "[h]eaders" was referring to in this context.

Aligned in what sense? Absolute address? My understanding
was that every layer of fixed headers should round itself
off with NLMSG_ALIGN().

But you're right, I think it will be easier to understand
if I say "attribute", and it's practically equivalent.

> > True, it's not strictly necessary AFAIU. Should I mention it=20
> > or would that be over-complicating things?
> >=20
> > I believe that kernel will accept both forms (without tripping=20
> > the trailing data warning), and both the kernel and mnl will pad=20
> > out the last attr. =20
>=20
> Yeah, probably not worth mentioning it.
>=20
> I think what threw me off was the explicit mention of "at the end of the
> message" - perhaps just say "after the family name attribute"?

Good point, I replaced with "after ``CTRL_ATTR_FAMILY_NAME``".

> > Some of the text is written with the implicit goal of comforting=20
> > the newcomer ;) =20
>=20
> :-)
>=20
> In this document it just feels like saying it _should_ be rare, but I'm
> not sure it should? We ignore it a lot in practice, but maybe we should
> be doing it more?

OK, I'll drop the "rare".

> > I'll rewrite. The only use I'm aware of is OvS upcalls, are there more?=
 =20
>=20
> In nl80211 we have quite a few "unicast an event message to a specific
> portid" uses, e.g. if userspace subscribes to certain action frames, the
> frame notification for it would be unicast to the subscribed socket, or
> the TX status response after a frame was transmitted, etc. etc.

Interesting! So there is a "please subscribe me" netlink message=20
in addition to NETLINK_ADD_MEMBERSHIP? Does the port ID get passed
explicitly or the kernel takes it from the socket by itself? Or I=20
guess you may not use the Port ID at all if you're hooking up to=20
socket destruction..

> > Practically speaking for a person trying to make a ethtool, FOU,
> > devlink etc. call to the kernel this is 100% irrelevant. =20
>=20
> Fair point, depends on what you're using and what programming model that
> has.

Right, my thinking was that the programming model of the family is
opaque to a person implementing the YAML netlink plumbing.

> > Hm, good point. I should add a section on multicast and make it part=20
> > of that. =20
>=20
> True that, multicast more generally is something to know about.

FWIW this is what I typed:

Multicast notifications
-----------------------

One of the strengths of Netlink is the ability to send event notifications
to user space. This is a unidirectional form of communication (kernel ->
user) and does not involve any control messages like ``NLMSG_ERROR`` or
``NLMSG_DONE``.

For example the Generic Netlink family itself defines a set of multicast
notifications about registered families. When a new family is added the
sockets subscribed to the notifications will get the following message::

  struct nlmsghdr:
    __u32 nlmsg_len:	136
    __u16 nlmsg_type:	GENL_ID_CTRL
    __u16 nlmsg_flags:	0
    __u32 nlmsg_seq:	0
    __u32 nlmsg_pid:	0

  struct genlmsghdr:
    __u8 cmd:		CTRL_CMD_NEWFAMILY
    __u8 version:	2
    __u16 reserved:	0

  struct nlattr:
    __u16 nla_len:	10
    __u16 nla_type:	CTRL_ATTR_FAMILY_NAME
    char data: 		test1\0

  (padding:)
    data:		\0\0

  struct nlattr:
    __u16 nla_len:	6
    __u16 nla_type:	CTRL_ATTR_FAMILY_ID
    __u16: 		123  /* The Family ID we are after */

  (padding:)
    char data:		\0\0

  struct nlattr:
    __u16 nla_len:	9
    __u16 nla_type:	CTRL_ATTR_FAMILY_VERSION
    __u16: 		1

  /* ... etc, more attributes will follow. */

The notification contains the same information as the response to the
``CTRL_CMD_GETFAMILY`` request. It is most common for "new object"
notifications to contain the same exact data as the respective ``GET``.

The Netlink headers of the notification are mostly 0 and irrelevant.
The :c:member:`nlmsghdr.nlmsg_seq` may be either zero or an monotonically
increasing notification sequence number maintained by the family.

To receive notifications the user socket must subscribe to the relevant
notification group. Much like the Family ID, the Group ID for a given
multicast group is dynamic and can be found inside the Family information.
The ``CTRL_ATTR_MCAST_GROUPS`` attribute contains nests with names
(``CTRL_ATTR_MCAST_GRP_NAME``) and IDs (``CTRL_ATTR_MCAST_GRP_ID``) of
the groups family.

Once the Group ID is known a setsockopt() call adds the socket to the group:

.. code-block:: c

  unsigned int group_id;

  /* .. find the group ID... */

  setsockopt(fd, SOL_NETLINK, NETLINK_ADD_MEMBERSHIP,
             &group_id, sizeof(group_id));

The socket will now receive notifications. It is recommended to use
a separate sockets for receiving notifications and sending requests
to the kernel. The asynchronous nature of notifications means that
they may get mixed in with the responses making the parsing much
harder.

> > =F0=9F=98=8D Can you point me to the code? (probably too advanced for t=
his doc
> > but the idea seems super useful!) =20
>=20
> Look at the uses of NL80211_ATTR_SOCKET_OWNER, e.g. you can
>  * create a virtual interface and have it disappear if you close the
>    socket (_nl80211_new_interface)
>  * AP stopped if you close the socket (nl80211_start_ap)
>  * some regulatory stuff reset (nl80211_req_set_reg)
>  * background ("scheduled") scan stopped (nl80211_start_sched_scan)
>  * connection torn down (nl80211_associate)
>  * etc.
>=20
> The actual teardown handling is in nl80211_netlink_notify().
>=20
> I guess I can agree though it doesn't really belong here - again
> something specific to the operations you're doing.

I didn't know about the notifier chain, super useful!

> > Yes :S What's the error reported when the buffer is too small?
> > recv() =3D -1, errno =3D EMSGSIZE? Does the message get discarded=20
> > or can it be re-read? I don't have practical experience with
> > that one. =20
>=20
> Ugh, I repressed all those memories ... I don't remember now, I guess
> I'd have to try it. Also it doesn't just apply to normal stuff but also
> multicast, and that can be even trickier.

No worries, let me try myself. Annoyingly I have this doc on a different
branch than my netlink code, that's why I was being lazy :)
