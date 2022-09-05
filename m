Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 868AC5ADB51
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 00:17:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231715AbiIEWRe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 18:17:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiIEWRd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 18:17:33 -0400
Received: from mail.3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE20359267;
        Mon,  5 Sep 2022 15:17:31 -0700 (PDT)
Received: from 3ffe.de (0001.3ffe.de [IPv6:2a01:4f8:c0c:9d57::1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.3ffe.de (Postfix) with ESMTPSA id CC0F41237;
        Tue,  6 Sep 2022 00:17:29 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2022082101;
        t=1662416249;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IHqwoI5OJwucKGse+LfR+Krmr6ZZMdVFsaeSkgDsr3o=;
        b=is7h4uz/R+0PDgRskheOgM5/6YA8uxXysj7m5fcncfbA4cy5K/7OjT1IGXWgLOOqwOR2gn
        d40Bz2CE1pF0xzmCgwIsKeC7F9vfOeT5+3SlOnm9a2uAQh/T6h2fzFh5nqx54JXDWiVLFB
        mrt9qVCalRIpRQVMx8Jd35O++/WVXFj4SzXS/DDG13hF3CriYXLfWJx2bC1tvvSxoJwk1V
        fCDXxkqyFvq5cNucvdAstNyUoGlGAYcTeP4EPc2ae9VsEj4tFkmmx5C7FZy82uVqyEFi7S
        vycjrzhHZ8dZM67AGgDgcAQCblpO5yGdxB0qCeV8Jh8u+9/qT98sdPd+ngfPNw==
MIME-Version: 1.0
Date:   Tue, 06 Sep 2022 00:17:29 +0200
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH devicetree] arm64: dts: ls1028a-rdb: add more ethernet
 aliases
In-Reply-To: <20220905212458.1549179-1-vladimir.oltean@nxp.com>
References: <20220905212458.1549179-1-vladimir.oltean@nxp.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <d00682d7e7aec2f979236338e7b3a688@walle.cc>
X-Sender: michael@walle.cc
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-09-05 23:24, schrieb Vladimir Oltean:
> Commit "arm64: dts: ls1028a: enable swp5 and eno3 for all boards" which
> Shawn declared as applied, but for which I can't find a sha1sum, has
> enabled a new Ethernet port on the LS1028A-RDB (&enetc_port3), but
> U-Boot, which passes a MAC address to Linux' device tree through the
> /aliases node, fails to do this for this newly enabled port.
> 
> Fix that by adding more ethernet aliases in the only
> backwards-compatible way possible: at the end of the current list.
> 
> And since it is possible to very easily convert either swp4 or swp5 to
> DSA user ports now (which have a MAC address of their own), using these
> U-Boot commands:
> 
> => fdt addr $fdt_addr_r
> => fdt rm /soc/pcie@1f0000000/ethernet-switch@0,5/ports/port@4 ethernet
> 
> it would be good if those DSA user ports (swp4, swp5) gained a valid 
> MAC
> address from U-Boot as well. In order for that to work properly,
> provision two more ethernet aliases for &mscc_felix_port{4,5} as well.

First, let me say, I'm fine with this patch. But I'm not sure,
how many MAC addresses are actually reserved on your
RDB/QDS boards? I guess, they being evaluation boards you
don't care? ;)
On the Kontron sl28 boards we reserve just 8 and that is
already a lot for a board with max 6 out facing ports. 4 of
these ports used to be a switch, so in theory it should work
with 3 MAC addresses, right? Or even just 2 if there is no
need to terminate any traffic on the switch interfaces.

Anyway, do we really need so many addresses? What are the
configurations here? For what is the address of the
internal ports used?

Let's say we are in the "port extender mode" and use the
second internal port as an actual switch port, that would
then be:
2x external enetc
1x internal enetc
4x external switch ports in port extender mode

Which makes 7 addresses. The internal enetc port doesn't
really make sense in a port extender mode, because there
is no switching going on. So uhm, 6 addresses are the
maximum?

This is the MAC address distribution for now on the
sl28 boards:
https://lore.kernel.org/linux-devicetree/20220901221857.2600340-19-michael@walle.cc/

Please tell me if I'm missing something here.

-michael

> The resulting ordering is slightly unusual, but to me looks more 
> natural
> than eno0, eno2, swp0, swp1, swp2, swp3, eno3, swp4, swp5.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
