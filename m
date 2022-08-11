Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9423E5908CD
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 00:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236454AbiHKWz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 18:55:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbiHKWz5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 18:55:57 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DE4E5B79D
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 15:55:56 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id t22so18971799pjy.1
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 15:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=PPCfKOqd9fDC1yG+vZyAdiqrSEfpKOxd2t3iixZr7Ls=;
        b=s78Lu2VcQTHfvs4HonL6YNgmkaptCcWFlwKqOEzNeLzaW8efWdlKL2Dmlukf1+nBLB
         TjV1g3Yxg+TCdRUI75vmAPZURX+SD/WSC9dPeoQwCtP4jA7FLhfUK3NZl8hqokAMsveP
         DKEW96nwDdVg1PWcsnCYc6GZdeEt3DtbwotieP7OUqTY4g5Tn4n55zD33xvMK//2y91e
         cfMqQ9atRjL0k7C6Ov+CUf3yBWvXikTP6mvVPiSmSTaXxHHcUqYJoRFGcoGeB++Z04uX
         u7SxG9a375oMcleExKv/Gkl5d6beG0kmq2k1VvdYbzda0LpP9YPTO+lISVpvGnOFv9p0
         jQKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=PPCfKOqd9fDC1yG+vZyAdiqrSEfpKOxd2t3iixZr7Ls=;
        b=fBrnGLdLflSwOiW+/JMTJxEdhrsIBtrhsmz/jyCUE/V2tSp7hpAxRZniRx979HUAaQ
         MbC8Y6uvdiWELSVhKWdLMmxErKrSQXiWtY/j9GFJMtZ0J6xVew4anlaI/X6t8pgFsm3a
         grDPXgFAi/U8CPU1gkOw0jhN1BUGFjKhkchdOjTmnibPQ/4Xd1/fteBoViFQ6ldJ3jT6
         9sHRteldhL0PCMdwVkzj1/Jsa1yIRL0efbUh3UXrImgoX5P/Gyy1EHOvsGzRclL9N+Db
         NHzunpus9LNc/w8qJTvLEdEC5yw/rH1DAc4i6hAVsVqjA07yghzn5Bg+FvH8TlhtpRno
         7lWQ==
X-Gm-Message-State: ACgBeo2jEg6sTTw8BlqKluE4RBeB4lnk3/PZqOaDNWP7apEQ72up0Bp6
        mUjDBmi3m/qbxQEhj0b4HE4LlRz9TXfHewYyuBjkXg==
X-Google-Smtp-Source: AA6agR48AwKso6gbHlt6bAk+3m4vu9dmqx22vT5YkDU+WfwhIED81kci3bcndDR180zkiApJvvKZ7SMSZzAw0xeO4eM=
X-Received: by 2002:a17:902:70c7:b0:170:9030:2665 with SMTP id
 l7-20020a17090270c700b0017090302665mr1289152plt.73.1660258555583; Thu, 11 Aug
 2022 15:55:55 -0700 (PDT)
MIME-Version: 1.0
References: <20220811022304.583300-1-kuba@kernel.org> <20220811022304.583300-5-kuba@kernel.org>
 <YvUru3QvN/LuYgnq@google.com> <20220811123515.4ef1a715@kernel.org>
In-Reply-To: <20220811123515.4ef1a715@kernel.org>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Thu, 11 Aug 2022 15:55:44 -0700
Message-ID: <CAKH8qBs54kX_MjA2xHM1sSa_zvNYDEPhiZcwEVWV4kP1dEPcEw@mail.gmail.com>
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
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 11, 2022 at 12:35 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Thu, 11 Aug 2022 09:18:03 -0700 sdf@google.com wrote:
> > > +attr-cnt-suffix: CNT
> >
> > Is it a hack to make the generated header fit into existing
> > implementation?
>
> Yup.
>
> > Should we #define ETHTOOL_XXX_CNT ETHTOOL_XXX in
> > the implementation instead? (or s/ETHTOOL_XXX_CNT/ETHTOOL_XXX/ the
> > source itself?)
>
> We could, I guess. To be clear this controls the count, IOW:
>
> enum {
>         PREFIX_A_BLA_ATTR = 1,
>         PREFIX_A_ANOTHER_ATTR,
>         PREFIX_A_AND_ONEMORE,
>         __PFREIX_A_CNT, // <--- This thing
> };
> #define PREFIX_A_MAX (__PFREIX_A_CNT - 1)
>
> It's not used in the generated code, only if we codegen the uAPI,
> AFAIR. So we'd need a way to tell the generator of the uAPI about
> the situation, anyway. I could be misremembering.

My worry is that we'll have more hacks like these and it's hard, as a
spec reader/writer, to figure out that they exist..
So I was wondering if it's "easier" (from the spec reader/writer pov)
to have some c-header-fixup: section where we can have plain
c-preprocessor hacks like these (where we need to redefine something
to match the old behavior).

> > > +attribute-spaces:
> >
> > Are you open to bike shedding? :-)
>
> I can't make promises that I'll change things but I'm curious
> to hear it!
>
> > I like how ethtool_netlink.h calls these 'message types'.
>
> It calls operation types message types, not attr spaces.
> I used ops because that's what genetlink calls things.

Coming from stubby/grpc, I was expecting to see words like
message/field/struct. The question is what's more confusing: sticking
with netlink naming or trying to map grpc/thrift concepts on top of
what we have. (I'm assuming more people know about grpc/thrift than
netlink)

messages: # or maybe 'attribute-sets' ?
  - name: channels
    ...

operations:
  - name: channel_get
    message: channels
    do:
      request:
        fields:
        - header
        - rx_max

Or maybe all we really need is a section in the doc called 'Netlink
for gRPC/Thrift users' where we map these concepts:
- attribute-spaces (attribute-sets?) -> messages
- attributes -> fields

> > > +  -
> > > +    name: header
> > > +    name-prefix: ETHTOOL_A_HEADER_
> >
> > Any issue with name-prefix+name-suffix being non-greppable? Have you tried
> > something like this instead:
> >
> > - name: ETHTOOL_A_HEADER # this is fake, for ynl reference only
> >    attributes:
> >      - name: ETHTOOL_A_HEADER_DEV_INDEX
> >        val:
> >        type:
> >      - name ETHTOOL_A_HEADER_DEV_NAME
> >        ..
> >
> > It seems a bit easier to map the spec into what it's going to produce.
> > For example, it took me a while to translate 'channels_get' below into
> > ETHTOOL_MSG_CHANNELS_GET.
> >
> > Or is it too much ETHTOOL_A_HEADER_?
>
> Dunno, that'd mean that the Python method is called
> ETHTOOL_MSG_CHANNELS_GET rather than just channels_get.
> I don't want to force all languages to use the C naming.
> The C naming just leads to silly copy'n'paste issues like
> f329a0ebeab.

Can we have 'name:' and 'long-name:' or 'c-name:' or 'full-name' ?

- name: header
   attributes:
    - name: dev_index
      full-name: ETHTOOL_A_HEADER_DEV_INDEX
      val:
      type:

Suppose I'm rewriting my c application from uapi to some generated (in
the future) python-like channels_get() method. If I can grep for
ETHTOOL_MSG_CHANNELS_GET, that would save me a bunch of time figuring
out what the new canonical wrapper is.

Also, maybe, at some point we'll have:
- name: dev_index
  c-name: ETHTOOL_A_HEADER_DEV_INDEX
  java-name: headerDevIndex

:-D

> > > +        len: ALTIFNAMSIZ - 1
> >
> > Not sure how strict you want to be here. ALTIFNAMSIZ is defined
> > somewhere else it seems? (IOW, do we want to have implicit dependencies
> > on external/uapi headers?)
>
> Good catch, I'm aware. I was planning to add a "header constants"
> section or some such. A section in "headers" which defines the
> constants which C code will get from the headers.

Define as in 're-define' or define as in 'you need to include some
other header for this to work'?

const:
  - name: ALTIFNAMSIZ
    val: 128

which then does

#ifndef
#define ALTIFNAMSIZ 128
#else
static_assert(ALTIFNAMSIZ == 128)
#endif

?

or:

external-const:
  - name: ALTIFNAMSIZ
    header: include/uapi/linux/if.h

which then might generate the following:

#include <include/uapi/linux/if.h>
#ifndef ALTIFNAMSIZ
#error "include/uapi/linux/if.h does not define ALTIFNAMSIZ"
#endif

?

> For Python it does not matter, as we don't have to size arrays.

Hm, I was expecting the situation to be the opposite :-) Because if
you really have to know this len in python, how do you resolve
ALTIFNAMSIZ?

The simplest thing to do might be to require these headers to be
hermetic (i.e., redefine all consts the spec cares about internally)?

> I was wondering if it will matter for other languages, like Rust?
>
> > > +            - header
> > > +            - rx_count
> > > +            - tx_count
> > > +            - other_count
> > > +            - combined_count
> >
> > My netlink is super rusty, might be worth mentioning in the spec: these
> > are possible attributes, but are all of them required?
>
> Right, will do, nothing is required, or rather requirements are kinda
> hard to express and checked by the code in the kernel.
>
> > You also mention the validation part in the cover letter, do you plan
> > add some of these policy properties to the spec or everything is
> > there already? (I'm assuming we care about the types which we have above and
> > optional/required attribute indication?)
>
> Yeah, my initial plan was to encode requirement in the policy but its
> not trivial. So I left it as future extension. Besides things which are
> required today may not be tomorrow, so its a bit of a strange thing.

That's the hardest part, but it should improve the observability, so
I'm looking forward :-)
As you say, it is probably hard to declaratively define these
requirements at this point for everything, but maybe some parts
(majority?) are doable.

> Regarding policy properties I'm intending to support all of the stuff
> that the kernel policies recognize... but somehow most families I
> converted don't have validation (only mask and length :S).
>
> Actually for DPLL I have a nice validation trick. You can define an
> enum:
>
> constants:
>   -
>     type: flags
>     name: genl_get_flags
>     value-prefix: DPLL_FLAG_
>     values: [ sources, outputs, status ]
>
> Then for an attribute you link it:
>
>       -
>         name: flags
>         type: u32
>         flags-mask: genl_get_flags
>
> And that will auto an enum:
>
> enum dpll_genl_get_flags {
>         DPLL_FLAG_SOURCES = 1,
>         DPLL_FLAG_OUTPUTS = 2,
>         DPLL_FLAG_STATUS = 4,
> };
>
> And a policy with a mask:
>
>         [DPLLA_FLAGS] = NLA_POLICY_MASK(NLA_U32, 0x7),

Yeah, that looks nice!
