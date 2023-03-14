Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05FD76B9BF5
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:45:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbjCNQoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbjCNQox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:44:53 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABCEA19107;
        Tue, 14 Mar 2023 09:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=ILn+Df8hmXcU6BexUX7ED6C0b5ESBRn++AKEXAdLXrg=;
        t=1678812291; x=1680021891; b=py1b0H4OXpGy/hpkcZaXn6j4GtfX5Y7+xJ/XoqP1yxEYd3q
        QDe77CTiZ8KILsSEhEncl4ICuBFjQLknXe0ncByYcoOmRQC8rG+lJO634fp5NaFWKdSXpgwUzT6um
        eGtYHMcfkLIGX+lFwE3J9xL8jbf4x71V9LhOipzDvlblEZI8qbsaAyyTwo4b2rkuFlmskjmG79/9q
        l3WwpB79Lq1hOuKtrv4JKUQUgB3IvpVNisFNicj7ujLEsgbuCTOpoSYe96XD94THJwywx08zNB2oo
        DxCuvZBxVMmFCm4+OiUuRTfwN6zRRDhqwAOkmwmkFQlqiI3EwO9zE86wPun1m6OA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1pc7lC-003FLV-0z;
        Tue, 14 Mar 2023 17:44:26 +0100
Message-ID: <30b294492e4a328c1bc33f84bc11d32d23b50ed1.camel@sipsolutions.net>
Subject: Re: [PATCH] p54spi: convert to devicetree
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Arnd Bergmann <arnd@kernel.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@kernel.org>
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        linux-gpio@vger.kernel.org, linux-omap@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>,
        Felipe Balbi <balbi@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        =?ISO-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Russell King <linux@armlinux.org.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date:   Tue, 14 Mar 2023 17:44:24 +0100
In-Reply-To: <20230314163201.955689-1-arnd@kernel.org>
References: <20230314163201.955689-1-arnd@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2023-03-14 at 17:30 +0100, Arnd Bergmann wrote:
>=20
> As I don't have an N8x0, this is completely untested.
>=20
> I listed the driver authors (Johannes and Christian) as the maintainers
> of the binding document, but I don't know if they actually have this
> hardware. It might be better to list someone who is actually using it.

Wow, umm, yeah I still have an N810 but ... If anyone wants the device,
shout, I'll give it away. I think I checked fairly recently (within a
year maybe) it still booted :-)

So yeah, it's probably not a great idea to list me there, I don't even
know these details, and probably never did, I'm pretty sure I never
installed a custom kernel on it.

johannes
