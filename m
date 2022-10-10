Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 918705F9CC8
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 12:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbiJJK3Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 06:29:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231853AbiJJK3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 06:29:21 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E011B2BB32;
        Mon, 10 Oct 2022 03:29:19 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id d26so16781850eje.10;
        Mon, 10 Oct 2022 03:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=njppD24n5PIRmmY3cy/ZzK4o8fKv+xhzrU1bZQKEb9Y=;
        b=boFeSypNiz4u7dhczuzC640JQsjk2byVSqAtDrQCAEG1/lcNSPo0AUqc3Dck7yZIDN
         p0jS/ThrskTtgEyDGMOgU+AvIDBceIUYkhFlBiMsXLzTRnzJ6tVrQF9fej/bSUiib5ba
         mwqfJ/xnplw7PeBfeMlYYDHxnyGwQ99U/E3F4dj6FPN1DIpVccWaRCTW4EHLUfzDauxu
         EbIdo+9saWUiddQyYJ6XpDW3Ofs/sa0+rVZM3MXbhjJjlJeK8tD9cwYLRypE28UfB+BZ
         Lzplf0UbWf+i793hTiTMI3uLUOjUaLDR93tPNzkHdRA7lPM/PS/T4/vOHunnktuwxSxw
         ld7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=njppD24n5PIRmmY3cy/ZzK4o8fKv+xhzrU1bZQKEb9Y=;
        b=w0uSFWq8X4v2LE0f7pepBg0cDWjeQ4PlOWKvOzytWdvtzRwrnDejrAJJNhSzlVB4tP
         9GtHYmp3APaeQn3PRpTgCBaXQhZPuy/Y1LBdscf5xRkI5TklV9yW8aC+gprpBpwUKhNL
         tQWIfZBHUwERGFVjNA3ngTQ+jMQ0dXZ3QZtvDWmPUnUkiWcpplGVS+ql130nwckRZmTZ
         CtTWHH27LNzGOHC27+fLGVb0qH9q6oeBlc/pUwRNdH35RUsxnlLZr2ZFus136VCYcjjh
         1fUPTMtNj4tMaVZg3PCx2ygwU/8sap7gYJQcWlJxP8ubuB2DpyPdrgDKTl+4eC2j3aIc
         b1nw==
X-Gm-Message-State: ACrzQf0jNcXMxYWYaopghYwnw391KetAf4uDAht7TBVMlX2ZCPSh+zGs
        yr+8kqV/7V3m4Q8W/1BSUg8=
X-Google-Smtp-Source: AMsMyM70nNI2Ly3JYMHMxaxpeMQx76PthktJ7R25K6o1CQZ6bcoHPEHp/HVV0bQQyjLZiU4AP52oKg==
X-Received: by 2002:a17:907:72c1:b0:783:34ce:87b9 with SMTP id du1-20020a17090772c100b0078334ce87b9mr14032357ejc.115.1665397758147;
        Mon, 10 Oct 2022 03:29:18 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id cn22-20020a0564020cb600b00459012e5145sm6786119edb.70.2022.10.10.03.29.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Oct 2022 03:29:16 -0700 (PDT)
Date:   Mon, 10 Oct 2022 13:29:14 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc:     Jerry Ray <jerry.ray@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [net-next][PATCH v4] dt-bindings: dsa: Add lan9303 yaml
Message-ID: <20221010102914.ut364d57sjhnb3lj@skbuf>
References: <20221003164624.4823-1-jerry.ray@microchip.com>
 <20221003164624.4823-1-jerry.ray@microchip.com>
 <20221008225628.pslsnwilrpvg3xdf@skbuf>
 <e49eb069-c66b-532c-0e8e-43575304187b@linaro.org>
 <20221009222257.f3fcl7mw3hdtp4p2@skbuf>
 <551ca020-d4bb-94bf-7091-755506d76f58@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <551ca020-d4bb-94bf-7091-755506d76f58@linaro.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 10, 2022 at 06:23:24AM -0400, Krzysztof Kozlowski wrote:
> On 09/10/2022 18:22, Vladimir Oltean wrote:
> > On Sun, Oct 09, 2022 at 05:20:03PM +0200, Krzysztof Kozlowski wrote:
> >> On 09/10/2022 00:56, Vladimir Oltean wrote:
> >>>>  
> >>>> +MICROCHIP LAN9303/LAN9354 ETHERNET SWITCH DRIVER
> >>>> +M:	Jerry Ray <jerry.ray@microchip.com>
> >>>> +M:	UNGLinuxDriver@microchip.com
> >>>> +L:	netdev@vger.kernel.org
> >>>> +S:	Maintained
> >>>> +F:	Documentation/devicetree/bindings/net/dsa/microchip,lan9303.yaml
> >>>> +F:	drivers/net/dsa/lan9303*
> >>>> +
> >>>
> >>> Separate patch please? Changes to the MAINTAINERS file get applied to
> >>> the "net" tree.
> >>
> >> This will also go via net tree, so there is no real need to split it.
> > 
> > I meant exactly what I wrote, "net" tree as in the networking tree where
> > fixes to the current master branch are sent:
> > https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git, or in
> > other words, not net-next.git where new features are sent:
> > https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git
> 
> Ah, but how it can go to fixes? It has invalid path (in the context of
> net-fixes) and it is not related to anything in the current cycle.

Personally I'd split the patch into 2 pieces, the MAINTAINERS entry for
the drivers/net/dsa/lan9303* portion, plus the current .txt schema,
which goes to "net" right away, wait until the net tree gets merged back
into net-next (happens when submissions for net-next reopen), then add
the dt-bindings and rename the .txt schema from MAINTAINERS to .yaml.
