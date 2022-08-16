Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 512655955E2
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 11:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233140AbiHPJGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 05:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232400AbiHPJGC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 05:06:02 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12ABF4457A;
        Tue, 16 Aug 2022 00:21:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=kPRVEkuL3USlzeDdID3Bh1eQ/ZWQtY4Qu5EPlyiKbaQ=;
        t=1660634502; x=1661844102; b=Po+7yvR+iRNsm8w5WluEmyZ0Bco3Ijni9LLFYOgja+yzBFY
        slQ/3dI3+ohAv6PiutCf2a3xh/DGWTWSTKFsWfCEzh6/qEIkMUEve7woVd/QmPfhtDVX60VGYpPq1
        brhwZm1qeiW1qAxbPZr6147hao3kO1utXTDHK0gcaO8uEoMohSclsaom2wI7w+XsiDWz4um1NKMh2
        3ou64pzWoU0sfI+p4nY8WsCVvjYRWxopu+6NmKiOuFvvBcUnFuKJe+CLMxE0pC/YEAzmyfxI43eFn
        3zFqBdSIQLduzZhGk1iSvoBGcrQBCswIovCBaNYLk4AbCvj7QzKoQ+0tgGsdmuEw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oNqtF-009NvC-09;
        Tue, 16 Aug 2022 09:21:29 +0200
Message-ID: <7241755af778426a2241cacd51119ba8dbd7c136.camel@sipsolutions.net>
Subject: Re: [RFC net-next 2/4] ynl: add the schema for the schemas
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, sdf@google.com, jacob.e.keller@intel.com,
        vadfed@fb.com, jiri@resnulli.us, dsahern@kernel.org,
        stephen@networkplumber.org, fw@strlen.de, linux-doc@vger.kernel.org
Date:   Tue, 16 Aug 2022 09:21:27 +0200
In-Reply-To: <20220815174742.32b3611e@kernel.org>
References: <20220811022304.583300-1-kuba@kernel.org>
         <20220811022304.583300-3-kuba@kernel.org>
         <6b972ef603ff2bc3a3f3e489aa6638f6246c1e48.camel@sipsolutions.net>
         <20220815174742.32b3611e@kernel.org>
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

On Mon, 2022-08-15 at 17:47 -0700, Jakub Kicinski wrote:
> On Mon, 15 Aug 2022 22:09:11 +0200 Johannes Berg wrote:
> > On Wed, 2022-08-10 at 19:23 -0700, Jakub Kicinski wrote:
> > >=20
> > > +        attributes:
> > > +          description: List of attributes in the space.
> > > +          type: array
> > > +          items:
> > > +            type: object
> > > +            required: [ name, type ]
> > > +            additionalProperties: False
> > > +            properties:
> > > +              name:
> > > +                type: string
> > > +              type: &attr-type
> > > +                enum: [ unused, flag, binary, u8, u16, u32, u64, s32=
, s64,
> > > +                        nul-string, multi-attr, nest, array-nest, ne=
st-type-value ] =20
> >=20
> > nest-type-value?
>=20
> It's the incredibly inventive nesting format used in genetlink policy
> dumps where the type of the sub-attr(s there are actually two levels)
> carry a value (index of the policy and attribute) rather than denoting
> a type :S :S :S

Hmm, OK, in the policy dump (not specific to genetlink, btw, can be used
for any policy, but is only generically hooked up for genetlink), we
have

[policy_idx] =3D {
  [attr_idx] =3D {
    [NL_POLICY_TYPE_ATTR_...] =3D ...
  }
}

Is that what you mean?

I guess I never really thought about this format much from a description
POV, no need to have a policy since you simply iterate (for_each_attr)
when reading it, and don't really need to care about the attribute
index, at least.

For future reference, how would you suggest to have done this instead?


> > > +              description:
> > > +                description: Documentation of the attribute.
> > > +                type: string
> > > +              type-value:
> > > +                description: Name of the value extracted from the ty=
pe of a nest-type-value attribute.
> > > +                type: array
> > > +                items:
> > > +                  type: string
> > > +              len:
> > > +                oneOf: [ { type: string }, { type: integer }]
> > > +              sub-type: *attr-type
> > > +              nested-attributes:
> > > +                description: Name of the space (sub-space) used insi=
de the attribute.
> > > +                type: string =20
> >=20
> > Maybe expand that description a bit, it's not really accurate for
> > "array-nest"?
>=20
> Slightly guessing but I think I know what you mean -> the value of the
> array is a nest with index as the type and then inside that is the
> entry of the array with its attributes <- and that's where the space is
> applied, not at the first nest level?

Right.

> Right, I should probably put that in the docs rather than the schema,
> array-nests are expected to strip one layer of nesting and put the
> value taken from the type (:D) into an @idx member of the struct
> representing the values of the array. Or at least that's what I do in
> the C codegen.

Well mostly you're not supposed to care about the 'value'/'type', I
guess?

> Not that any of these beautiful, precious formats should be encouraged
> going forward. multi-attr all the way!

multi-attr?

> > Do you mean the "name of the enumeration" or the "name of the
> > enumeration constant"? (per C99 concepts) I'm a bit confused? I guess
> > you mean the "name of the enumeration constant" though I agree most
> > people probably don't know the names from C99 (I had to look them up to=
o
> > for the sake of being precise here ...)
>=20
> I meant the type. I think. When u32 carries values of an enum.
> Enumeration constant for the attribute type is constructed from
> it's name and the prefix/suffix kludge.
>=20
Indeed, I confused myself too ...

johannes

