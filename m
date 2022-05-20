Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BAC352EF46
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 17:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350684AbiETPbh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 11:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350879AbiETPbe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 11:31:34 -0400
X-Greylist: delayed 64 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 20 May 2022 08:31:26 PDT
Received: from mailrelay2-1.pub.mailoutpod1-cph3.one.com (mailrelay2-1.pub.mailoutpod1-cph3.one.com [46.30.210.183])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C5B57B0B
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 08:31:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ravnborg.org; s=rsa1;
        h=in-reply-to:content-type:mime-version:references:message-id:subject:cc:to:
         from:date:from;
        bh=kwToCduxEHKRlf6xTfLStwKuhJjU+lyECx++Tp7rwBg=;
        b=dKidBF+iQ7d11gWNT/UoyXW+3Hs3JRy8MCTHjV+5ua+Tg8M5cogj66cbemiXXWJkpK0zsojA7lQyE
         +WqVoFZWQ6MJXXhEGgSw5lyAml+bPL2Bob4FIJw5qswzhyuzPAS6nncjClEcmRp8/q5uuFnaXkNE2d
         CPuaLrtvtWobbmHB9tsxsDLdpABvzpEFwrP2Hjj7G7q9P4zXpqd59UkkCfAXbqYiZX0JhO/0Al924K
         wFSjZf6TdiexU83WgAFrBKHbEHcVNpQIMy29BaLvT2CXdB5WMu+1QWT1QpW5jqN1dCLHfvlGz7DBJM
         XMgEyhF4mJWi5tS9mXMNT9APf2Wijnw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed;
        d=ravnborg.org; s=ed1;
        h=in-reply-to:content-type:mime-version:references:message-id:subject:cc:to:
         from:date:from;
        bh=kwToCduxEHKRlf6xTfLStwKuhJjU+lyECx++Tp7rwBg=;
        b=n6agCsCBqaR8eTktbf5YnuH91+U1tOyO7hFP5kGyWriJEdb5PGp+30pFXfAEW1f4wny+jHMBg9N+G
         uHm+DFOBg==
X-HalOne-Cookie: 6d6a2faa20e68cf1e8fd7d3b59daf8d1323c09c1
X-HalOne-ID: c1025af6-d851-11ec-a909-d0431ea8a290
Received: from mailproxy2.cst.dirpod4-cph3.one.com (80-162-45-141-cable.dk.customer.tdc.net [80.162.45.141])
        by mailrelay2.pub.mailoutpod1-cph3.one.com (Halon) with ESMTPSA
        id c1025af6-d851-11ec-a909-d0431ea8a290;
        Fri, 20 May 2022 15:30:19 +0000 (UTC)
Date:   Fri, 20 May 2022 17:30:17 +0200
From:   Sam Ravnborg <sam@ravnborg.org>
To:     Rob Herring <robh@kernel.org>
Cc:     devicetree@vger.kernel.org,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Benson Leung <bleung@chromium.org>,
        Guenter Roeck <groeck@chromium.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Peter Rosin <peda@axentia.se>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Kalle Valo <kvalo@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sebastian Reichel <sre@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@kernel.org>,
        Maxime Ripard <mripard@kernel.org>,
        chrome-platform@lists.linux.dev, alsa-devel@alsa-project.org,
        linux-pm@vger.kernel.org, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-pci@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-gpio@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-input@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: Fix properties without any type
Message-ID: <Yoe0CRhygXOIrYJc@ravnborg.org>
References: <20220519211411.2200720-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220519211411.2200720-1-robh@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 19, 2022 at 04:14:11PM -0500, Rob Herring wrote:
> Now that the schema tools can extract type information for all
> properties (in order to decode dtb files), finding properties missing
> any type definition is fairly trivial though not yet automated.
> 
> Fix the various property schemas which are missing a type. Most of these
> tend to be device specific properties which don't have a vendor prefix.
> A vendor prefix is how we normally ensure a type is defined.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
Acked-by: Sam Ravnborg <sam@ravnborg.org> # for everything in .../bindings/display/
