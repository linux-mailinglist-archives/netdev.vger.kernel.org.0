Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6470B5ECFA7
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 23:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232138AbiI0V40 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 17:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231986AbiI0V40 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 17:56:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D206E111DD0;
        Tue, 27 Sep 2022 14:56:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 692A461BF2;
        Tue, 27 Sep 2022 21:56:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B4EBC433D6;
        Tue, 27 Sep 2022 21:56:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664315783;
        bh=46pQ7wb08oxLxrr8qqVM4mtCZdTNfRSgRFzM9TGKQug=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=o0ApYIau0AC4RTmd2euJmqiQAN7rja8xdwmbUDhV4yxiBuvsII7ubDG8nr3kNTJ3f
         2v+BpYhTceAT1NLO7Gx8yqiIE6bBNdcQJH0K8HToTaVLDuyeJf/OavRBZ7rtvGOYcM
         QvUr73x0aNQZCHZ6Nx0eL1MGhHShhusH3lBdB8pelBK6rGoT17vlcXUBwqudJTnVuj
         V9sZSZv+m3mxbrmt6vGicXP2d7gHnAcTtfse8B1WC99F23t6lK4SpXF6yuPg4oSOmo
         gkBEGehjDpgC5gyt+9P6kI3FM4GhAVnz785/MnwbhjRcV2IexzV7kBJgOkENUdZ5L8
         +ANtOXY50eklw==
Date:   Tue, 27 Sep 2022 14:56:22 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, sdf@google.com, jacob.e.keller@intel.com,
        vadfed@fb.com, johannes@sipsolutions.net, jiri@resnulli.us,
        dsahern@kernel.org, stephen@networkplumber.org, fw@strlen.de,
        linux-doc@vger.kernel.org
Subject: Re: [RFC net-next 2/4] ynl: add the schema for the schemas
Message-ID: <20220927145622.4e3339a4@kernel.org>
In-Reply-To: <20220926161056.GA2002659-robh@kernel.org>
References: <20220811022304.583300-1-kuba@kernel.org>
        <20220811022304.583300-3-kuba@kernel.org>
        <20220926161056.GA2002659-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Sep 2022 11:10:56 -0500 Rob Herring wrote:
> On Wed, Aug 10, 2022 at 07:23:02PM -0700, Jakub Kicinski wrote:
> > A schema in jsonschema format which should be familiar
> > to dt-bindings writers. It looks kinda hard to read, TBH,
> > I'm not sure how to make it better.  
> 
> This got my attention in the Plumbers agenda though I missed the talk. 
> It's nice to see another jsonschema user in the kernel. I hope you make 
> jsonschema a dependency for everyone before I do. :) Hopefully we don't 
> hit any comflict in required version of jsonschema as I've needed both a 
> minimum version for features as well as been broken by new versions.

I'm a complete noob on this, my jsonschema is really crude.
But thanks to this it's unlikely to depend on any particular version? :)

> I would avoid calling all this 'YAML netlink' as YAML is just the file 
> format you are using. We started with calling things YAML, but I nudge 
> folks away from that to 'DT schema'.

Good point, I'll try to stick to Netlink schema as well.

> Also, probably not an issue here, but be aware that YAML is much
> slower to parse than JSON. 

Fingers crossed. Worst case we can convert formats later.

> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > ---
> >  Documentation/netlink/schema.yaml | 242 ++++++++++++++++++++++++++++++
> >  1 file changed, 242 insertions(+)
> >  create mode 100644 Documentation/netlink/schema.yaml
> > 
> > diff --git a/Documentation/netlink/schema.yaml b/Documentation/netlink/schema.yaml
> > new file mode 100644
> > index 000000000000..1290aa4794ba
> > --- /dev/null
> > +++ b/Documentation/netlink/schema.yaml
> > @@ -0,0 +1,242 @@
> > +# SPDX-License-Identifier: GPL-2.0
> > +%YAML 1.2
> > +---
> > +$id: "http://kernel.org/schemas/netlink/schema.yaml#"
> > +$schema: "http://kernel.org/meta-schemas/core.yaml#"  
> 
> In case there's ever another one: meta-schemas/netlink/core.yaml
> 
> Or something similar.

Ack!

> > +
> > +title: Protocol
> > +description: Specification of a genetlink protocol
> > +type: object
> > +required: [ name, description, attribute-spaces, operations ]
> > +additionalProperties: False
> > +properties:
> > +  name:
> > +    description: Name of the genetlink family
> > +    type: string
> > +  description:  
> 
> It's better if your schema vocabulary is disjoint from jsonschema 
> vocabulary. From what I've seen, it's fairly common to get the 
> indentation off and jsonschema behavior is to ignore unknown keywords. 
> If the vocabularies are disjoint, you can write a meta-schema that only 
> allows jsonschema schema vocabulary at the right levels. Probably less 
> of an issue here as you don't have 1000s of schemas.

Ack, let me s/decription/doc/
 
> > +    description: Description of the family
> > +    type: string
> > +  version:
> > +    description: Version of the family as defined by genetlink.
> > +    type: integer  
> 
> Do you have the need to define the int size? We did our own keyword for 
> this, but since then I've looked at several other projects that have 
> used something like 'format: uint32'. There was some chatter about 
> trying to standardize this, but I haven't checked in a while.

It's 8 bits in theory (struct genlmsghdr::version), in practice it's
never used, and pretty much ignored. The jsonschema I have on Fedora
does not know about uint8.

> > +  attr-cnt-suffix:
> > +    description: Suffix for last member of attribute enum, default is "MAX".
> > +    type: string
> > +  headers:
> > +    description: C headers defining the protocol
> > +    type: object
> > +    additionalProperties: False
> > +    properties:
> > +      uapi:
> > +        description: Path under include/uapi where protocol definition is placed
> > +        type: string
> > +      kernel:
> > +        description: Additional headers on which the protocol definition depends (kernel side)
> > +        anyOf: &str-or-arrstr
> > +          -
> > +            type: array
> > +            items:
> > +              type: string
> > +          -
> > +            type: string
> > +      user:
> > +        description: Additional headers on which the protocol definition depends (user side)
> > +        anyOf: *str-or-arrstr  
> 
> For DT, we stick to a JSON compatible subset of YAML, so no anchors. The 
> jsonschema way to do this is using '$defs' (or 'definitions' before the 
> spec standardized it) and '$ref'.

I need to read up on this. Is it possible to extend a type?
We really need a way to define a narrow set of properties for "going
forward" while the old families have extra quirks. I couldn't find any
jsonschema docs on how the inherit and extend.

> > +  constants:
> > +    description: Enums and defines of the protocol
> > +    type: array
> > +    items:
> > +      type: object
> > +      required: [ type, name ]
> > +      additionalProperties: False
> > +      properties:
> > +        name:
> > +          type: string
> > +        type:
> > +          enum: [ enum, flags ]
> > +        value-prefix:
> > +          description: For enum the prefix of the values, optional.
> > +          type: string
> > +        value-start:
> > +          description: For enum the literal initializer for the first value.
> > +          oneOf: [ { type: string }, { type: integer }]  
> 
> I think you can do just 'type: [ string, integer ]'.

Works, thanks!
