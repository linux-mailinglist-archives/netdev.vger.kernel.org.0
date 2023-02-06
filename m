Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F09D268C368
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 17:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbjBFQb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 11:31:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjBFQb6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 11:31:58 -0500
Received: from soltyk.jannau.net (soltyk.jannau.net [144.76.91.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A701FBBAE;
        Mon,  6 Feb 2023 08:31:56 -0800 (PST)
Received: by soltyk.jannau.net (Postfix, from userid 1000)
        id DDDA626F72A; Mon,  6 Feb 2023 17:31:54 +0100 (CET)
Date:   Mon, 6 Feb 2023 17:31:54 +0100
From:   Janne Grunau <j@jannau.net>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Mailing List <devicetree-spec@vger.kernel.org>,
        Kalle Valo <kvalo@kernel.org>, van Spriel <arend@broadcom.com>,
        =?iso-8859-1?B?Suly9G1l?= Pouiller <jerome.pouiller@silabs.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH RFC 0/3] dt-bindings: net: Add network-class.yaml schema
Message-ID: <20230206163154.GA9004@jannau.net>
References: <20230203-dt-bindings-network-class-v1-0-452e0375200d@jannau.net>
 <CAL_JsqKD7gD86_B93M19rBCWn+rmSw24vOGEhqi9Nvne1Xixwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqKD7gD86_B93M19rBCWn+rmSw24vOGEhqi9Nvne1Xixwg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2023-02-03 08:41:28 -0600, Rob Herring wrote:
> On Fri, Feb 3, 2023 at 7:56 AM Janne Grunau <j@jannau.net> wrote:
> >
> > The Devicetree Specification, Release v0.3 specifies in section 4.3.1
> > a "Network Class Binding". This covers MAC address and maximal frame
> > size properties. "local-mac-address" and "mac-address" with a fixed
> > address-size of 48 bits is already in the ethernet-controller.yaml
> > schema so move those over.
> > I think the only commonly used values for address-size are 48 and 64
> > bits (EUI-48 and EUI-64). Unfortunately I was not able to restrict the
> > mac-address size based on the address-size. This seems to be an side
> > effect of the array definition and I was not able to restrict "minItems"
> > or "maxItems" based on the address-size value in an "if"-"then"-"else"
> > block.
> > An easy way out would be to restrict address-size to 48-bits for now.
> 
> I've never seen 64-bits used...

ZigBee and 6LoWPAN use 64-bits for example. Let's hardcode 48 bits for 
now as that's what all in-tree devicetrees implicitly use. If needed it 
can be changed later.

> > I've ignored "max-frame-size" since the description in
> > ethernet-controller.yaml claims there is a contradiction in the
> > Devicetree specification. I suppose it is describing the property
> > "max-frame-size" with "Specifies maximum packet length ...".
> 
> Please include it and we'll fix the spec. It is clearly wrong. 2 nios
> boards use 1518 and the consumer for them says it is MTU. Everything
> else clearly uses mtu with 1500 or 9000.

Ok, the example in the pdf is 'max-frame-size = <1518>;'. I'll include 
it with the description of ethernet-controller.yaml which specifies it 
as MTU.

Janne
