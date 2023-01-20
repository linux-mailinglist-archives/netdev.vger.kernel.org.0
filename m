Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F4010675079
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 10:16:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbjATJQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 04:16:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjATJQL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 04:16:11 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FEA88CE4B;
        Fri, 20 Jan 2023 01:15:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=5A4I13EExxh922r+a7QpwP4F+bO//jNwM1OYaKuD8l8=;
        t=1674206150; x=1675415750; b=I/rULaU742ak/BTzG95haSckL8bkiohdZ1GcEoiXVeXLjzv
        2yGqxiDzCLr3FSh4SEzz6wITmY8DLF3idcB2w9H9Ucrm4EJYkfrmFhFjUJ/F1ro92I3p0aLpg6pZk
        TkEFNiFfqVwTRolTym/Xu9TkonatJA596w/TQ41hBzb13oBf+3max90S8h2SyCbrFquLa0Edt9jDc
        WVcmPmj4c/1hhNUIyCrIVku+wVUiqhznzsrBGabKYT39jbS6bw0wWi7/ZgucD2evaZA9TEiiDAwFl
        6fzCeDip1jH9L0NzS2IlDpntHlqbdPDgUYfOZ0CleR1Avmxksg6qY/1EnKRurO6Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pInUr-007NZG-0A;
        Fri, 20 Jan 2023 10:15:41 +0100
Message-ID: <2b7f7f76aac4fcf2a51eb5588e64316b62f27d65.camel@sipsolutions.net>
Subject: Re: [PATCH net-next v3 1/8] docs: add more netlink docs (incl. spec
 docs)
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, robh@kernel.org, stephen@networkplumber.org,
        ecree.xilinx@gmail.com, sdf@google.com, f.fainelli@gmail.com,
        fw@strlen.de, linux-doc@vger.kernel.org, razor@blackwall.org,
        nicolas.dichtel@6wind.com, Bagas Sanjaya <bagasdotme@gmail.com>
Date:   Fri, 20 Jan 2023 10:15:39 +0100
In-Reply-To: <20230119181306.3b8491b1@kernel.org>
References: <20230119003613.111778-1-kuba@kernel.org>
         <20230119003613.111778-2-kuba@kernel.org>
         <96618285a772b5ef9998f638ea17ff68c32dd710.camel@sipsolutions.net>
         <20230119181306.3b8491b1@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2023-01-19 at 18:13 -0800, Jakub Kicinski wrote:
> On Thu, 19 Jan 2023 21:29:22 +0100 Johannes Berg wrote:
> > On Wed, 2023-01-18 at 16:36 -0800, Jakub Kicinski wrote:
> > >=20
> > > +Answer requests
> > > +---------------
> > > +
> > > +Older families do not reply to all of the commands, especially NEW /=
 ADD
> > > +commands. User only gets information whether the operation succeeded=
 or
> > > +not via the ACK. Try to find useful data to return. Once the command=
 is
> > > +added whether it replies with a full message or only an ACK is uAPI =
and
> > > +cannot be changed. It's better to err on the side of replying.
> > > +
> > > +Specifically NEW and ADD commands should reply with information iden=
tifying
> > > +the created object such as the allocated object's ID (without having=
 to
> > > +resort to using ``NLM_F_ECHO``). =20
> >=20
> > I'm a bit on the fence on this recommendation (as written).
> >=20
> > Yeah, it's nice to reply to things ... but!
> >=20
> > In userspace, you often request and wait for the ACK to see if the
> > operation succeeded. This is basically necessary. But then it's
> > complicated to wait for *another* message to see the ID.
>=20
> Maybe you're looking at this from the perspective of a person tired=20
> of manually writing the user space code?

Heh, I guess :)

> If the netlink message handling code is all auto-generated it makes=20
> no difference to the user...

True. And I guess we can hope that'll be the case for most users, though
I doubt it :)

> > We've actually started using the "cookie" in the extack to report an ID
> > of an object/... back, see uses of nl_set_extack_cookie_u64() in the
> > tree.
>=20
> ... and to the middle-layer / RPC / auto-generated library pulling
> stuff out from protocol messages and interpreting them in a special=20
> way is a typical netlink vortex of magic :(

:)

> > So I'm not sure I wholeheartedly agree with the recommendation to send =
a
> > separate answer. We've done that, but it's ugly on both sender side in
> > the kernel (requiring an extra message allocation, ideally at the
> > beginning of the operation so you can fail gracefully, etc.) and on the
> > receiver (having to wait for another message if the operation was
> > successful; possibly actually having to check for that message *before*
> > the ACK arrives.)
>=20
> Right, response is before ACK. It's not different to a GET command,
> really.

True.

> > > +Support dump consistency
> > > +------------------------
> > > +
> > > +If iterating over objects during dump may skip over objects or repea=
t
> > > +them - make sure to report dump inconsistency with ``NLM_F_DUMP_INTR=
``. =20
> >=20
> > That could be a bit more fleshed out on _how_ to do that, if it's not
> > somewhere else?
>=20
> I was thinking about adding a sentence like "To avoid consistency
> issues store your objects in an Xarray and correctly use the ID during
> iteration".. but it seems to hand-wavy. Really the coder needs to
> understand dumps quite well to get what's going on, and then the
> consistency is kinda obvious. IDK. Almost nobody gets this right :(

Yeah agree, it's tricky one way or the other. To be honest I was
thinking less of documenting the mechanics of the underlying code to
ensure that, but rather of the mechanics of using the APIs to ensure
that, i.e. how to use cb->seq and friends.

> > Unrelated to this particular document, but ...
> >=20
> > I'm all for this, btw, but maybe we should have a way of representing i=
n
> > the policy that an attribute is used as multi-attr for an array, and a
> > way of exposing that in the policy export? Hmm. Haven't thought about
> > this for a while.
>=20
> Informational-only or enforced? Enforcing this now would be another
> backward-compat nightmare :(

More informational - for userspace to know from policy dump that certain
attributes have that property. With nested it's easy to know (there's a
special nested-array type), but multi-attr there's no way to distinguish
"is this one" and "is this multiple".

Now ... you might say you don't really care now since you want
everything to be auto-generated and then you have it in the docs
(actually, do you?), and that's a fair point.

> FWIW I have a set parked on a branch to add "required" bit to policies,
> so for per-op policies one can reject requests with missing attrs
> during validation.

Nice. That might yet convince me of per-op policies ;-)

Though IMHO the namespace issue remains - I'd still not like to have 100
definitions of NL80211_ATTR_IFINDEX or similar.

johannes
