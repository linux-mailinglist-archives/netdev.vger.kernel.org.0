Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5B65949BF
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 02:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345873AbiHOXhO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 19:37:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353852AbiHOXgp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 19:36:45 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A827CBCCF2;
        Mon, 15 Aug 2022 13:09:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=wEAZ4j/EwRC2Q8IOEGnofZgwe8Em+DUCEtJYQy2uUvA=;
        t=1660594163; x=1661803763; b=VE2x1aP/romEGilucS5CwsuvBhxv0qs6+Fqs4ds7AlpQ6M4
        VxBi9V1LJFfUevD2O249gVEEyUEUNt8hYxKk+Pa/mJqRGLdljj7pYp4C2ozHOIJnO6AVvYfAXvyY1
        Wy3le4iMNbITCSVDzMzEPsc0oLBnWWut9iWYPaQHW0lsYtHeKouocqmM0+O2ES7JS2qfy0r2xPDNi
        HlGMhSmOPaQQ/t4Tr2GN2Z2ZWK17pIohqtDQ3Xk0H3UNGDq4UwYu+/mktnQyQ4QssPabCY7lBG4WL
        VhkuEprtwmZv8K5rsyn2G4I7dybMBSMp6w6gIYbKGxJPfexzB9G6qVfl6v/teVrg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1oNgOe-008ol9-0x;
        Mon, 15 Aug 2022 22:09:12 +0200
Message-ID: <6b972ef603ff2bc3a3f3e489aa6638f6246c1e48.camel@sipsolutions.net>
Subject: Re: [RFC net-next 2/4] ynl: add the schema for the schemas
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com
Cc:     sdf@google.com, jacob.e.keller@intel.com, vadfed@fb.com,
        jiri@resnulli.us, dsahern@kernel.org, stephen@networkplumber.org,
        fw@strlen.de, linux-doc@vger.kernel.org
Date:   Mon, 15 Aug 2022 22:09:11 +0200
In-Reply-To: <20220811022304.583300-3-kuba@kernel.org>
References: <20220811022304.583300-1-kuba@kernel.org>
         <20220811022304.583300-3-kuba@kernel.org>
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

On Wed, 2022-08-10 at 19:23 -0700, Jakub Kicinski wrote:
>=20
> +        attributes:
> +          description: List of attributes in the space.
> +          type: array
> +          items:
> +            type: object
> +            required: [ name, type ]
> +            additionalProperties: False
> +            properties:
> +              name:
> +                type: string
> +              type: &attr-type
> +                enum: [ unused, flag, binary, u8, u16, u32, u64, s32, s6=
4,
> +                        nul-string, multi-attr, nest, array-nest, nest-t=
ype-value ]

nest-type-value?

> +              description:
> +                description: Documentation of the attribute.
> +                type: string
> +              type-value:
> +                description: Name of the value extracted from the type o=
f a nest-type-value attribute.
> +                type: array
> +                items:
> +                  type: string
> +              len:
> +                oneOf: [ { type: string }, { type: integer }]
> +              sub-type: *attr-type
> +              nested-attributes:
> +                description: Name of the space (sub-space) used inside t=
he attribute.
> +                type: string

Maybe expand that description a bit, it's not really accurate for
"array-nest"?

> +              enum:
> +                description: Name of the enum used for the atttribute.

typo - attribute

Do you mean the "name of the enumeration" or the "name of the
enumeration constant"? (per C99 concepts) I'm a bit confused? I guess
you mean the "name of the enumeration constant" though I agree most
people probably don't know the names from C99 (I had to look them up too
for the sake of being precise here ...)

johannes
