Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D47B59632A
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 21:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237034AbiHPTbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 15:31:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiHPTbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 15:31:14 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1495F86C38;
        Tue, 16 Aug 2022 12:31:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=U25TPYOEeLX9ExDpmpCDFm7VeFIYKkpYVxR743uBycM=;
        t=1660678273; x=1661887873; b=I4GQ0JJQQvdSGoXlIeBHvWVhu9ONhu9ULCu7QJJ0XsrRzoo
        zF+pxWFHmAPe1SQpMY+HmGFK2T1KR6tg77A3Xo6AKEwgHryGYklisIWwBjcy5Ee3KUaweAnGOMTPb
        tR7ibiSNcVUBc8lUOPgBZdxOeMxdBpRXXyW1KTLBfymbwzzl4z0hAPub6XXOXr6vGGDVdmJ5632va
        UYw4FOjJWyu/Gnv67satFwVFUkFAllVsJb4EOsaab/Qr71fPebEDSNj+zBOZ2EcNZoJ5utAGAX1wl
        7c6hLbflASCqy0BuEOn3VAU0raN3jYJg8GTS24hwxUvZ46TDd0ojS54olJNUaa5Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oO2H9-009deu-0U;
        Tue, 16 Aug 2022 21:30:55 +0200
Message-ID: <c4a4744c0f0a86433beec5035f2150b8427eb3d5.camel@sipsolutions.net>
Subject: Re: [RFC net-next 2/4] ynl: add the schema for the schemas
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, sdf@google.com, jacob.e.keller@intel.com,
        vadfed@fb.com, jiri@resnulli.us, dsahern@kernel.org,
        stephen@networkplumber.org, fw@strlen.de, linux-doc@vger.kernel.org
Date:   Tue, 16 Aug 2022 21:30:54 +0200
In-Reply-To: <20220816085316.65fda789@kernel.org>
References: <20220811022304.583300-1-kuba@kernel.org>
         <20220811022304.583300-3-kuba@kernel.org>
         <6b972ef603ff2bc3a3f3e489aa6638f6246c1e48.camel@sipsolutions.net>
         <20220815174742.32b3611e@kernel.org>
         <7241755af778426a2241cacd51119ba8dbd7c136.camel@sipsolutions.net>
         <20220816085316.65fda789@kernel.org>
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

On Tue, 2022-08-16 at 08:53 -0700, Jakub Kicinski wrote:
>=20
> My guess was that some of the wrapping was for ease of canceling here
> (cancel is used both on skip and on error).=C2=A0
>=20

Not sure I'd say that, but can't say I really remember why I did it this
way.

> What I think we should push
> for is multi-attr, so the same attribute happens multiple times.
>=20
> [msg]
>  [ATTR1]
>  [ATTR2] // elem 1
>    [SubATTR1]
>    [SubATTR2]
>  [ATTR2] // elem 2
>    [SubATTR1]
>    [SubATTR2]
>  [ATTR2] // elem 3
>    [SubATTR1]
>    [SubATTR2]
>  [ATTR3]
>  [ATTR4]
>=20
> Instead of wrapping into an array and then elements.

Hmm, ok, I guess that works.

>=20
> As Michal pointed out a number of times - the wrapping ends up limiting=
=20
> the size of the array to U16_MAX,

True.

> and I have a suspicion that most of
> wrapping is done because we tend to parse into a pointer array, which
> makes multi-attr a little tricky. But we shouldn't let one parsing
> technique in a relatively uncommon language like C dictate the format :)

:-)

To be fair, for cases where today we use nla_for_each_nested() we could
also invent an "nlmsg_for_each_attr_of_type()" macro:

#define nlmsg_for_each_attr_of_type(type, pos, nlh, hdrlen, rem) \
	nlmsg_for_each_attr(pos, nlh, hdrlen, rem)               \
		if (pos->nla_type =3D=3D type)

and then that's basically all you need?

In the policy we'd declare it as a normal nested (not array), and I
think that's it because today if you give the same attribute type twice,
the last one wins in the normal parsing anyway (IIRC)...

> I'm leaning heavily towards defining a subset of the YAML spec as=20
> "the way to do things in new family" which will allow only one form=20
> of arrays.

Fair enough.

johannes
