Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9885D6286F3
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 18:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236989AbiKNRYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 12:24:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236747AbiKNRYD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 12:24:03 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F893AE61;
        Mon, 14 Nov 2022 09:24:02 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id n20so9447244ejh.0;
        Mon, 14 Nov 2022 09:24:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6TuL0Y+rO9fxtmzmyAVa69XJKRgqWPJ2OfFK7yf03Q8=;
        b=YFSnsQf8sjzTuSTT6mTlCVstF8oHuYZEdzipDMt8cUsFTTqvRZFSEEDVqqDe93TP1S
         K7Kp2QoZllY/I/lJWkF9sz47M/SuWDcqsYQgyIdskdg6U+3HZZNdjYBY2PFoBQ0vV1Ed
         tuxPMDsZKPY4KGox8ZZ49QqlWkf/CN3FKfpDNqpIgzILDUFb4kkTKWqFARtbnyPkxalR
         nDwAZwITlDKr/DOEcSEcgEHbVrdpmkyfakblsTFiwGq59M+SuzWDkT2v9mT93khiUS/O
         IBxgICoguQV8gqLVy2zpi7r0Xy0LF4k4OYZwjEPPsd5nRrE4btcz80oFoTdyMO+VgzJQ
         /PCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6TuL0Y+rO9fxtmzmyAVa69XJKRgqWPJ2OfFK7yf03Q8=;
        b=8Hmbm+QVNBpEU3iuYoxA5ZqUmDLWWwvYibyLqQNOx3nA9FcUXRAO1Rebsi76GehbyU
         aMn541jWFpAr1qNMvbLDRdKX9hBXzPx7HBLDLdP7KQPVbocu8h5yAGpPwsU0lMGe4nmF
         aOCoj3QKfZXcZU59zk8YI/Y7IQqt7KgFMOg9Jth7RADeNU4g1skud6yxr8h6XjbSKOot
         VaoKBFiyeiZfjAPY0NXUzBRAEunJGHA+CLAWbfruQ8PHtBcRBG29xg8ZYGSJPEFo8NJ2
         VoRonj7cMNxSe9QFAnK2VCJhXya/ofjF+XYBz11NnNHjTQ+gnRe/Ihxq8RZ6cUHk8l1Z
         v+pw==
X-Gm-Message-State: ANoB5pldGJ1rMRq36LurLwBshmT3S+7JuS1TMu9Fip4ZXc/TDDhrgR11
        7t2PYsTN8DIluU5bEvyvlhPGlhHxpC0IfQ==
X-Google-Smtp-Source: AA0mqf5NU+UWrKjaeZ380Kdx+esoqf/0KQ1RMqDlFFH7/GMR4NAoZ9NpbjGL8EabJ5Pb/MYS6M7Qpw==
X-Received: by 2002:a17:906:c1c6:b0:7ad:7e81:1409 with SMTP id bw6-20020a170906c1c600b007ad7e811409mr11094550ejb.326.1668446641117;
        Mon, 14 Nov 2022 09:24:01 -0800 (PST)
Received: from skbuf ([188.25.170.202])
        by smtp.gmail.com with ESMTPSA id de30-20020a1709069bde00b0073d796a1043sm4388883ejc.123.2022.11.14.09.23.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Nov 2022 09:24:00 -0800 (PST)
Date:   Mon, 14 Nov 2022 19:23:57 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Leo Li <leoyang.li@nxp.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Rob Herring <robh+dt@kernel.org>,
        Saravana Kannan <saravanak@google.com>,
        Shawn Guo <shawnguo@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH net-next v2 00/11] net: pcs: Add support for devices
 probed in the "usual" manner
Message-ID: <20221114172357.hdzua4xo7wixtbgs@skbuf>
References: <20221103210650.2325784-1-sean.anderson@seco.com>
 <20221109224110.erfaftzja4fybdbc@skbuf>
 <bcb87445-d80d-fea0-82f2-a15b20baaf06@seco.com>
 <20221110152925.3gkkp5opf74oqrxb@skbuf>
 <7b4fb14f-1ca0-e4f8-46ca-3884392627c2@seco.com>
 <20221110160008.6t53ouoxqeu7w7qr@skbuf>
 <ce6d6a26-4867-6385-8c64-0f374d027754@seco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce6d6a26-4867-6385-8c64-0f374d027754@seco.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 10, 2022 at 11:56:15AM -0500, Sean Anderson wrote:
> these will probably be in device trees for a year before the kernel
> starts using them. But once that is done, we are free to require them.

Sorry, you need to propose something that is not "we can break compatibility
with today's device trees one year from now".
