Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91A745913D8
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 18:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239315AbiHLQ02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 12:26:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238193AbiHLQ01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 12:26:27 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE5648E9A7
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 09:26:25 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id p14-20020a17090a74ce00b001f4d04492faso1340699pjl.4
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 09:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=5oQDGSIVZVIGYXY6TsOM3DcZbNLOECMZXlWwoo8C9Jg=;
        b=mCGar3A5bOQMcQCZCwrvw5Z1T2tuGwbBQFF9qRHr0YO4tXUwHh+q84ekjV2IXuEF97
         lqoND3xRYpX9y7RIYhYB7o23pT64JbAOT+2/hdTx0B0j1D1XCQHu20yQy7D+uW62og/D
         eDBGQ1KDVg/0XRsORWYcoeN0B3pZDGCwySrC+lt7hsyw7MP9mrhJaHUgmjGQ7cdOE1/7
         zoIfqLmnC3fltLXCso/qtfGELvnI4wqu3cw9BRq/yYgQJg20LXdbACuuMTwZft960igd
         mM8WA3TmB/Tj6ZmEvCVnBaHWrXdLzYEEdXiLSffYqKs/riRAamEVlsr+cup0egl0kgfL
         hZKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=5oQDGSIVZVIGYXY6TsOM3DcZbNLOECMZXlWwoo8C9Jg=;
        b=TU+NzHBhG4p7AOIrkdzOe3lbsqaGvOnQXhDlNpD+sgxcle+7KRY1QfBbJ/C8oMSqe2
         NcFFOmS8P813+MN8UDRBVc1ywcVXRdQKbor2w27wiyKeYwvvV8bzBYwZL7aXizK1rKil
         8gz11HQDCBMsjMqopzxMlZyJX2TlUasCtBZH/vLNIcT5qhiTS0AmDv+QsfotUB9cskNg
         LTJ+WBDPR5HJO9e1/H2SVccZr5KUFHOVCAnFLZ0kQX4uFXC+83IFekWo+fZrAN5p4Iod
         tg1ZGjMNukA90JPE0d4mAP4DvEOuePDtv51+4KkyJuaRil80bFGwVYoPY3osXtuZ8LZl
         euzA==
X-Gm-Message-State: ACgBeo1XzmNDXsD4DbGVGnn+d71rlz/UWo1tM/mxXVOfwmQb/NJE8HuO
        ML4rjsHCD97SZVfpJgZUKUL1a06VDYoCAlWm6j2+DA==
X-Google-Smtp-Source: AA6agR4e6k8bFNFctqemjvK+lk3G9WrWwY3/Wj7vTzueF3TsbA4aJL8E1cQrg3bNOV/w65T7UykSpBuhSnXYScw4oio=
X-Received: by 2002:a17:903:2444:b0:16d:baf3:ff06 with SMTP id
 l4-20020a170903244400b0016dbaf3ff06mr4728214pls.148.1660321584913; Fri, 12
 Aug 2022 09:26:24 -0700 (PDT)
MIME-Version: 1.0
References: <20220811022304.583300-1-kuba@kernel.org> <20220811022304.583300-5-kuba@kernel.org>
 <YvUru3QvN/LuYgnq@google.com> <20220811123515.4ef1a715@kernel.org>
 <CAKH8qBs54kX_MjA2xHM1sSa_zvNYDEPhiZcwEVWV4kP1dEPcEw@mail.gmail.com> <20220811163111.56d83702@kernel.org>
In-Reply-To: <20220811163111.56d83702@kernel.org>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 12 Aug 2022 09:26:13 -0700
Message-ID: <CAKH8qBuzHMMG8T3mD5mZmY0N1Tit+yp1H-EQebmUsutAma9yCw@mail.gmail.com>
Subject: Re: [RFC net-next 4/4] ynl: add a sample user for ethtool
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com, vadfed@fb.com,
        johannes@sipsolutions.net, jiri@resnulli.us, dsahern@kernel.org,
        stephen@networkplumber.org, fw@strlen.de, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 11, 2022 at 4:31 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 11 Aug 2022 15:55:44 -0700 Stanislav Fomichev wrote:
> > > We could, I guess. To be clear this controls the count, IOW:
> > >
> > > enum {
> > >         PREFIX_A_BLA_ATTR = 1,
> > >         PREFIX_A_ANOTHER_ATTR,
> > >         PREFIX_A_AND_ONEMORE,
> > >         __PFREIX_A_CNT, // <--- This thing
> > > };
> > > #define PREFIX_A_MAX (__PFREIX_A_CNT - 1)
> > >
> > > It's not used in the generated code, only if we codegen the uAPI,
> > > AFAIR. So we'd need a way to tell the generator of the uAPI about
> > > the situation, anyway. I could be misremembering.
> >
> > My worry is that we'll have more hacks like these and it's hard, as a
> > spec reader/writer, to figure out that they exist..
> > So I was wondering if it's "easier" (from the spec reader/writer pov)
> > to have some c-header-fixup: section where we can have plain
> > c-preprocessor hacks like these (where we need to redefine something
> > to match the old behavior).
>
> Let me think about it some more. My main motivation is people writing
> new families, I haven't sent too much time worrying about the existing
> ones with all their quirks. It's entirely possible that the uAPI quirks
> can just go and we won't generate uAPI for existing families as it
> doesn't buy us anything.

Ack. Although, we have to have some existing examples for people to
write new families. So you might still have to convert something :-)

> > Coming from stubby/grpc, I was expecting to see words like
> > message/field/struct. The question is what's more confusing: sticking
> > with netlink naming or trying to map grpc/thrift concepts on top of
> > what we have. (I'm assuming more people know about grpc/thrift than
> > netlink)
> >
> > messages: # or maybe 'attribute-sets' ?
> >   - name: channels
> >     ...
>
> Still not convinced about messages, as it makes me think that every
> "space" is then a definition of a message rather than just container
> for field definitions with independent ID spaces.
>
> Attribute-sets sounds good, happy to rename.
>
> Another thought I just had was to call it something like "data-types"
> or "field-types" or "type-spaces". To indicate the split into "data"
> and "actions"/"operations"?

I like attribute-set better than attribute-space :-)

> > operations:
> >   - name: channel_get
> >     message: channels
> >     do:
> >       request:
> >         fields:
> >         - header
> >         - rx_max
> >
> > Or maybe all we really need is a section in the doc called 'Netlink
> > for gRPC/Thrift users' where we map these concepts:
> > - attribute-spaces (attribute-sets?) -> messages
> > - attributes -> fields
>
> Excellent idea!
>
> > > Dunno, that'd mean that the Python method is called
> > > ETHTOOL_MSG_CHANNELS_GET rather than just channels_get.
> > > I don't want to force all languages to use the C naming.
> > > The C naming just leads to silly copy'n'paste issues like
> > > f329a0ebeab.
> >
> > Can we have 'name:' and 'long-name:' or 'c-name:' or 'full-name' ?
> >
> > - name: header
> >    attributes:
> >     - name: dev_index
> >       full-name: ETHTOOL_A_HEADER_DEV_INDEX
> >       val:
> >       type:
> >
> > Suppose I'm rewriting my c application from uapi to some generated (in
> > the future) python-like channels_get() method. If I can grep for
> > ETHTOOL_MSG_CHANNELS_GET, that would save me a bunch of time figuring
> > out what the new canonical wrapper is.
> >
> > Also, maybe, at some point we'll have:
> > - name: dev_index
> >   c-name: ETHTOOL_A_HEADER_DEV_INDEX
> >   java-name: headerDevIndex
>
> Herm, looking at my commits where I started going with the C codegen
> (which I haven't posted here) is converting the values to the same
> format as keys (i.e. YAML/JSON style with dashes). So the codegen does:
>
>         c_name = attr['name']
>         if c_name in c_keywords:
>                 c_name += '_'
>         c_name = c_name.replace('-', '_')
>
> So the name would be "dev-index", C will make that dev_index, Java will
> make that devIndex (or whatever) etc.
>
> I really don't want people to have to prefix the names because that's
> creating more work. We can slap a /* header.dev_index */ comment in
> the generated uAPI, for the grep? Dunno..

Yeah, dunno as well, not sure how much of the per-language knowledge
you should bake into the tool itself.. I think my confusion mostly
comes from the fact that 'name' is mixed together with 'name-prefix'
and one is 'low_caps' while the other one is 'ALL_CAPS'. Too much
magic :-)

Thinking out loud: maybe these transformations should all go via some
extra/separate yaml (or separate sections)? Like:

fixup-attribute-sets:
  - name: header
    canonical-c-name: "ETHTOOL_A_HEADER_{name.upper()}"
  - name: channels
    canonical-c-name: "ETHTOOL_A_CHANNELS_{name.upper()}"

fixup-operations:
  canonical-c-name: "ETHTOOL_MSG_{name.upper()}"

  # in case the "generic" catch-all above doesn't work
  - name: channgels_get
     canonical-c-name: "ETHTOOL_MSG_CHANNELS_GET"

We can call it "compatibility" yaml and put all sorts of weird stuff in it.
New users hopefully don't need to care about it and don't need to
write any of the -prefix/-suffix stuff.


> > > Good catch, I'm aware. I was planning to add a "header constants"
> > > section or some such. A section in "headers" which defines the
> > > constants which C code will get from the headers.
> >
> > Define as in 're-define' or define as in 'you need to include some
> > other header for this to work'?
> >
> > const:
> >   - name: ALTIFNAMSIZ
> >     val: 128
>
> This one. In most cases the constant is defined in the same uAPI header
> as the proto so we're good. But there's IFNAMSIZ and friends which are
> shared.
>
> > which then does
> >
> > #ifndef
> > #define ALTIFNAMSIZ 128
> > #else
> > static_assert(ALTIFNAMSIZ == 128)
> > #endif
> >
> > ?
> >
> > or:
> >
> > external-const:
> >   - name: ALTIFNAMSIZ
> >     header: include/uapi/linux/if.h
> >
> > which then might generate the following:
> >
> > #include <include/uapi/linux/if.h>
> > #ifndef ALTIFNAMSIZ
> > #error "include/uapi/linux/if.h does not define ALTIFNAMSIZ"
> > #endif
> >
> > > For Python it does not matter, as we don't have to size arrays.
> >
> > Hm, I was expecting the situation to be the opposite :-) Because if
> > you really have to know this len in python, how do you resolve
> > ALTIFNAMSIZ?
>
> Why does Python need to know the length of the string tho?
> On receive if kernel gives you a longer name - great, no problem.
> On send the kernel will tell you so also meh.

I was thinking that you wanted to do some client size validation as
well? As in sizeof(rx_buf) > ALTIFNAMSIZ -> panic? But I agree that
there is really no value in that, the kernel will do the validation
anyway..

> In C the struct has a char bla[FIXED_SIZE] so if we get an oversized
> string we're pooped, that's my point, dunno what other practical use
> the string sizing has.
>
> > The simplest thing to do might be to require these headers to be
> > hermetic (i.e., redefine all consts the spec cares about internally)?
>
> That's what I'm thinking if they are actually needed. But it only C
> cares we can just slap the right includes and not worry. Dunno if other
> languages are similarly string-challenged.
