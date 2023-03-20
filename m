Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BABDB6C1F21
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 19:10:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbjCTSKc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 14:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231177AbjCTSJs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 14:09:48 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68B6133445
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 11:03:45 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id w4so5297782plg.9
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 11:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679335424;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2GEVX58UiIupKov02rk4VJPVXKdrpVrAq3jro87jEEM=;
        b=BGVLtCvL1Z8/agaPZz5sVL9wlCa/F5hRs3hca+KweRh3eytSYd3npYtMCyreifAz9P
         AUaLUv1Fq/UiGDivrG9AOaK68dUNmvhFice8yPGmhaj5jwRMjfLAUkx7/00/G+US/kOq
         fEWNI6RDJwu52ZXOutKQ4fR4frIXTpjWyP/S5Tey4roeZ3mS1odgdJDAxB5FwAo1pgCk
         LVdss6/v5fAotg//oabc7K6EgCCx4yLxnKrPTZh2/bGeq8S2fYDtk1IVVKvFdIPEt3Q6
         NdmSDVci3GnGTJ1Fc6qkxLsexehy7yEkijvjJ0EOQ0JDp+KjTlWiRAW7Yj+KmWDnq6s6
         fB6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679335424;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2GEVX58UiIupKov02rk4VJPVXKdrpVrAq3jro87jEEM=;
        b=ck57jnnfOmo4yrZGfwxKYlBnxyS501CcPNZojwr3KJSt3bTRMUkoDSkSeUZUFnuYXb
         L29vztA5TrVU76v+bTmtUx2oBz+22TqmXuANVJWKRdn8+3g4hkncgQ5t66YBWg+fpNkb
         bXsN9LstTR51FrzEozeGNH4PAw5Kxe/DT6O8BvH+pVjhVeY3RSrZleYxVSRBM8QUHYxX
         CzFEIxByvEJ87zyx+v+JjTuWwiGGDyVX/Kaj0U/3MMQzGok9aRGm89GS7fxHlRLjFuau
         UQLRz6HECGJRQs9iZNMJM3xzr842E7rpfG90sjkJq57alwAph1yTm5vt6xK7D3iwnfco
         fD1A==
X-Gm-Message-State: AO0yUKUXBpgp14JKsfcj1MZ7hEZ2Yr0wc4n2tyPeAiHpKjnkqZSk90nT
        sTh5Ghnc9tDB+LoXI8nDzw7AKCZT8orMKr1UTM949A==
X-Google-Smtp-Source: AK7set9a0Q/TE0au/PDBPvx3z9exJKWAK+nf7I1GsTl4W56uI4t+KojKyyNAoq/ppw28ykNFnyZZbQQNXM/fPJxe3RA=
X-Received: by 2002:a17:902:c40c:b0:19c:d14b:ee20 with SMTP id
 k12-20020a170902c40c00b0019cd14bee20mr7028977plk.8.1679335424439; Mon, 20 Mar
 2023 11:03:44 -0700 (PDT)
MIME-Version: 1.0
References: <20230318002340.1306356-1-sdf@google.com> <20230318002340.1306356-3-sdf@google.com>
 <20230317213304.2010ed71@kernel.org>
In-Reply-To: <20230317213304.2010ed71@kernel.org>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Mon, 20 Mar 2023 11:03:33 -0700
Message-ID: <CAKH8qBvkFvyyPwah7uDiJP2tm7k4NZ10Kgw2ykDs8jqOs4gXtg@mail.gmail.com>
Subject: Re: [PATCH net-next 2/4] ynl: populate most of the ethtool spec
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"

On Fri, Mar 17, 2023 at 9:33=E2=80=AFPM Jakub Kicinski <kuba@kernel.org> wr=
ote:
>
> On Fri, 17 Mar 2023 17:23:38 -0700 Stanislav Fomichev wrote:
> > Things that are not implemented:
> > - cable tests
> > - bitmaks in the requests don't work (needs multi-attr support in ynl.p=
y)
> > - stats-get seems to return nonsense
>
> Hm. What kind of nonsense?

{'grp': {'id': 1, 'ss-id': 18}}

But I guess that's because I'm not passing the group bitmask correctly?

> > - notifications are not tested
> > - features-nft has hard-coded value:13, not sure why it skews
>
> ETHTOOL_MSG_FEATURES_SET_REPLY exists but there is no reply:
> section in the spec.

Ah, good catch, I guess something like this would do? It doesn't have
to be a new empty msg?
reply:
  attributes: *feature

> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  Documentation/netlink/specs/ethtool.yaml | 1473 ++++++++++++++++++++--
> >  1 file changed, 1362 insertions(+), 111 deletions(-)
> >
> > diff --git a/Documentation/netlink/specs/ethtool.yaml b/Documentation/n=
etlink/specs/ethtool.yaml
> > index 4727c067e2ba..ba9ee9b6e5ad 100644
> > --- a/Documentation/netlink/specs/ethtool.yaml
> > +++ b/Documentation/netlink/specs/ethtool.yaml
> > @@ -6,6 +6,12 @@ protocol: genetlink-legacy
> >
> >  doc: Partial family for Ethtool Netlink.
> >
> > +definitions:
> > +  -
> > +    name: udp-tunnel-type
> > +    type: enum
> > +    entries: [ vxlan, geneve, vxlan_gpe ]
>
> s/_/-/ everywhere
>
> > +
> >  attribute-sets:
> >    -
> >      name: header
> > @@ -38,6 +44,7 @@ doc: Partial family for Ethtool Netlink.
> >        -
> >          name: bit
> >          type: nest
> > +        multi-attr: true
> >          nested-attributes: bitset-bit
> >    -
> >      name: bitset
> > @@ -53,6 +60,21 @@ doc: Partial family for Ethtool Netlink.
> >          type: nest
> >          nested-attributes: bitset-bits
> >
> > +  -
> > +    name: u64-array
> > +    attributes:
> > +      -
> > +        name: u64
> > +        type: nest
> > +        multi-attr: true
> > +        nested-attributes: u64
> > +    name: s32-array
>
> missing
>
>     -
>
> before this line? the u64-array and s32-array should be separate?

Right. I guess the fact that I've never exercised "phc-vclocks-get" shows :=
-/



> > +    attributes:
> > +      -
> > +        name: s32
> > +        type: nest
> > +        multi-attr: true
> > +        nested-attributes: s32
> >    -
> >      name: string
> >      attributes:
>
> > +    -
> > +      name: features-get
> > +      doc: Get features.
> > +
> > +      attribute-set: features
> > +
> > +      do: &feature-get-op
> > +        request:
> > +          attributes:
> > +            - header
> > +        reply:
> > +          attributes: &feature
> > +            - header
> > +            # User-changeable features.
> > +            - hw
> > +            # User-requested features.
> > +            - wanted
> > +            # Currently active features.
> > +            - active
> > +            # Unchangeable features.
> > +            - nochange
> > +      dump: *feature-get-op
> > +    -
> > +      name: features-set
> > +      doc: Set features.
> > +
> > +      attribute-set: features
> > +
> > +      do:
> > +        request:
> > +          attributes: *feature
>
>         reply:
>
> here. Not sure if it needs an empty attributes: or not.
>
