Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13A1059A607
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 21:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350573AbiHSTIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 15:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351077AbiHSTIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 15:08:00 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A2610A76F;
        Fri, 19 Aug 2022 12:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=zEfdjnHsqwXQF3icSmB8DgvCYCzYVQac1zIeUhhkwZw=;
        t=1660936073; x=1662145673; b=SPypjs8xL+RaCnRoU7OlHuoOD55e8MWMGNkoWagWsU699aV
        zXmrOlcCaSGegKD2ghviw62JOLqJ4T6eNzNx9umREW7WL9EMAF39Ed4zKCKkoIdZYaZDhTsOK/6cf
        v/GlszUoUkmLWsT03U4QPiltdU7JQ7mOoP0iPTYPj9ebWai/YtdVLRf5S0GfGeAG2FtyBHX6B1VoY
        Pju2g0kC/C6/fuR1KJirr0HvrQpRWf4pq5fknh7CfdZsrCEtrZrxcMqCUY3YPCSYLFIZ9JYRLlK0B
        FjUtDsu6SQGrj3W5gI2LAQKZcC95umUXggjOYJWUApdgrgWtfX8riAOLnTdBqiVQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oP7LG-00C8Tn-0M;
        Fri, 19 Aug 2022 21:07:38 +0200
Message-ID: <fa41284993d7e1c629b829ec40fdbbd4d68cbed7.camel@sipsolutions.net>
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
Date:   Fri, 19 Aug 2022 21:07:36 +0200
In-Reply-To: <20220819105451.1de66044@kernel.org>
References: <20220818023504.105565-1-kuba@kernel.org>
         <20220818023504.105565-2-kuba@kernel.org>
         <6350516756628945f9cc1ee0248e92473521ed0b.camel@sipsolutions.net>
         <20220819092029.10316adb@kernel.org>
         <959012cfd753586b81ff60b37301247849eb274c.camel@sipsolutions.net>
         <20220819105451.1de66044@kernel.org>
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

On Fri, 2022-08-19 at 10:54 -0700, Jakub Kicinski wrote:
> On Fri, 19 Aug 2022 18:57:01 +0200 Johannes Berg wrote:
> > > Theoretically I think we also align what I called "fixed metadata
> > > headers", practically all of those are multiple of 4 :S =20
> >=20
> > But they're not really aligned, are they? Hmm. Well I guess practically
> > it doesn't matter. I just read this and wasn't really sure what the
> > mention of "[h]eaders" was referring to in this context.
>=20
> Aligned in what sense? Absolute address? My understanding
> was that every layer of fixed headers should round itself
> off with NLMSG_ALIGN().

Well I think aligned in this context is always towards "start of
message", since that's the only thing that matters anyway (copied into a
- hopefully suitably aligned - buffer on the other side).

But OK, I've basically only dealt with generic netlink, so I don't
really know about the expectations of NLMSG_ALIGN and other kinds of
headers.

What I meant by "are not really aligned" is that I didn't actually _see_
the NLMSG_ALIGN() calls, but that might just be because in practice
they're not needed since everyone uses multiple-of-4 sizes anyway. Or
maybe because I just didn't check very much...

> > > I'll rewrite. The only use I'm aware of is OvS upcalls, are there mor=
e? =20
> >=20
> > In nl80211 we have quite a few "unicast an event message to a specific
> > portid" uses, e.g. if userspace subscribes to certain action frames, th=
e
> > frame notification for it would be unicast to the subscribed socket, or
> > the TX status response after a frame was transmitted, etc. etc.
>=20
> Interesting! So there is a "please subscribe me" netlink message=20
> in addition to NETLINK_ADD_MEMBERSHIP? Does the port ID get passed
> explicitly or the kernel takes it from the socket by itself? Or I=20
> guess you may not use the Port ID at all if you're hooking up to=20
> socket destruction..

Well it depends on the operation, but generally yes.

For example, for certain action frames in wireless, there's an explicit
"I'm going to handle an action frame that starts with the bytes 00 01
02" or something, and then only a single such subscriber is allowed, and
the mere fact that a subscriber exists will actually modify kernel
behaviour.

The reason for this being that if you have an unknown/unhandled action
frame you're supposed to send it back with 0x80 OR'ed into the category
(first byte), indicating that you couldn't handle it. So when userspace
subscribes, it also gets the responsibility for handling it.

Now this might mean userspace actually sends it back with 0x80 (as might
be the case in hostapd which basically subscribes to *all* action frames
with a zero-length "start bytes" filter), or it actually handles it, but
it does absolve the kernel of the responsibility of handling it.

But because there has to be a single handler - otherwise none of them
could return it if unhandled - we simply unicast the received action
frame to the socket that requested the subscription.


> Multicast notifications
> -----------------------

[snip]

> The notification contains the same information as the response to the
> ``CTRL_CMD_GETFAMILY`` request. It is most common for "new object"
> notifications to contain the same exact data as the respective ``GET``.

I might say we should remove that second sentence - this is one of those
murky cases where it's actually sometimes not _possible_ to do due to
message size limitations etc.

That said, it's still common, so maybe that's OK, "common" doesn't mean
"always" and some notifications might obviously differ even if it's
common.

> The socket will now receive notifications. It is recommended to use
> a separate sockets for receiving notifications and sending requests
> to the kernel. The asynchronous nature of notifications means that
> they may get mixed in with the responses making the parsing much
> harder.

Not sure I'd say "parsing" here, maybe "message handling"? I mean, it's
not really about parsing the messages, more about the potentially
interleaved sequence of handling them. But maybe I'm splitting hairs :)

johannes
