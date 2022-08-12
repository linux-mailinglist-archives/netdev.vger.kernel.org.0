Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D847859176D
	for <lists+netdev@lfdr.de>; Sat, 13 Aug 2022 00:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236630AbiHLWsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 18:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbiHLWsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 18:48:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50EAF83BDA;
        Fri, 12 Aug 2022 15:48:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E52DE61753;
        Fri, 12 Aug 2022 22:48:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEB1AC433D6;
        Fri, 12 Aug 2022 22:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660344532;
        bh=pgabqeO9dlPyxmnp6++1rkwUZvfvpA2pdXqZxD4+F3s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=T11cmz6VFefbO6Q35RGOqUvKuh1EmuaAsRIqNLxdUILS3gRfH7zeToXDV9AItatFm
         ft+kq0gsekl8zOrhyE3xqop7Jm3haPbI8ykRCX2BYHCF/AAPf3WBnzGOlNA/YD2P1w
         QGwJkc7TLJXDxOKAkWsTwbYptyIFgK+SNPCkl1JywTfH4gz4116sER4+e5niNUmpwS
         5FY2/QkczhJq5UIZu9W2gA3eT+nnazKI6rilU9LK1F9DSKcYlx3LvFTIdjfqRJMAQU
         COlfW3TIhCIZGEvH6IB9BWLjYTKmKJrzdMJb7YWyAaMIa/t0McMEVwXW6TYLJTa0n8
         bIdwho5Wq3pQQ==
Date:   Fri, 12 Aug 2022 15:48:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com, vadfed@fb.com,
        johannes@sipsolutions.net, jiri@resnulli.us, dsahern@kernel.org,
        stephen@networkplumber.org, fw@strlen.de, linux-doc@vger.kernel.org
Subject: Re: [RFC net-next 4/4] ynl: add a sample user for ethtool
Message-ID: <20220812154850.74aa33ad@kernel.org>
In-Reply-To: <CAKH8qBuzHMMG8T3mD5mZmY0N1Tit+yp1H-EQebmUsutAma9yCw@mail.gmail.com>
References: <20220811022304.583300-1-kuba@kernel.org>
        <20220811022304.583300-5-kuba@kernel.org>
        <YvUru3QvN/LuYgnq@google.com>
        <20220811123515.4ef1a715@kernel.org>
        <CAKH8qBs54kX_MjA2xHM1sSa_zvNYDEPhiZcwEVWV4kP1dEPcEw@mail.gmail.com>
        <20220811163111.56d83702@kernel.org>
        <CAKH8qBuzHMMG8T3mD5mZmY0N1Tit+yp1H-EQebmUsutAma9yCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 12 Aug 2022 09:26:13 -0700 Stanislav Fomichev wrote:
> On Thu, Aug 11, 2022 at 4:31 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > Let me think about it some more. My main motivation is people writing
> > new families, I haven't sent too much time worrying about the existing
> > ones with all their quirks. It's entirely possible that the uAPI quirks
> > can just go and we won't generate uAPI for existing families as it
> > doesn't buy us anything.  
> 
> Ack. Although, we have to have some existing examples for people to
> write new families. So you might still have to convert something :-)

We do seem to have at least a couple on the horizon for 6.1.

Another thought I had yesterday was that maybe we want to have two
schemas - one "full" with all the historical baggage. And one "blessed"
for new families which narrows the options?

> > Still not convinced about messages, as it makes me think that every
> > "space" is then a definition of a message rather than just container
> > for field definitions with independent ID spaces.
> >
> > Attribute-sets sounds good, happy to rename.
> >
> > Another thought I just had was to call it something like "data-types"
> > or "field-types" or "type-spaces". To indicate the split into "data"
> > and "actions"/"operations"?  
> 
> I like attribute-set better than attribute-space :-)

OK!

> > Herm, looking at my commits where I started going with the C codegen
> > (which I haven't posted here) is converting the values to the same
> > format as keys (i.e. YAML/JSON style with dashes). So the codegen does:
> >
> >         c_name = attr['name']
> >         if c_name in c_keywords:
> >                 c_name += '_'
> >         c_name = c_name.replace('-', '_')
> >
> > So the name would be "dev-index", C will make that dev_index, Java will
> > make that devIndex (or whatever) etc.
> >
> > I really don't want people to have to prefix the names because that's
> > creating more work. We can slap a /* header.dev_index */ comment in
> > the generated uAPI, for the grep? Dunno..  
> 
> Yeah, dunno as well, not sure how much of the per-language knowledge
> you should bake into the tool itself..

By "the tool" you mean the codegen? I assumed that's gotta be pretty
language specific. TBH I expected everyone will write their own codegen
or support library. Like I don't think Rust people will want to look at
my nasty Python C generator :S

I'd prefer to keep as much C-ness out of the spec as possible but
some may have to leak in because of the need to gen the uAPI.

> I think my confusion mostly
> comes from the fact that 'name' is mixed together with 'name-prefix'
> and one is 'low_caps' while the other one is 'ALL_CAPS'. Too much
> magic :-)

Fair point, at the very least they should be consistent, I'll fix.

> Thinking out loud: maybe these transformations should all go via some
> extra/separate yaml (or separate sections)? Like:
> 
> fixup-attribute-sets:
>   - name: header
>     canonical-c-name: "ETHTOOL_A_HEADER_{name.upper()}"
>   - name: channels
>     canonical-c-name: "ETHTOOL_A_CHANNELS_{name.upper()}"
> 
> fixup-operations:
>   canonical-c-name: "ETHTOOL_MSG_{name.upper()}"
> 
>   # in case the "generic" catch-all above doesn't work
>   - name: channgels_get
>      canonical-c-name: "ETHTOOL_MSG_CHANNELS_GET"
> 
> We can call it "compatibility" yaml and put all sorts of weird stuff in it.
> New users hopefully don't need to care about it and don't need to
> write any of the -prefix/-suffix stuff.

Let me chew on this for a little bit.

> > Why does Python need to know the length of the string tho?
> > On receive if kernel gives you a longer name - great, no problem.
> > On send the kernel will tell you so also meh.  
> 
> I was thinking that you wanted to do some client size validation as
> well? As in sizeof(rx_buf) > ALTIFNAMSIZ -> panic? But I agree that
> there is really no value in that, the kernel will do the validation
> anyway..

Yup, I don't see the point, the ext_ack handling must be solid anyway,
so the kernel error is as good as local panic for cases which should
"never happen" (famous last words, maybe, we'll see)

