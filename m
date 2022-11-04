Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 754E7619DCE
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 17:52:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232204AbiKDQwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 12:52:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232223AbiKDQv7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 12:51:59 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DDCE40470
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 09:50:58 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id v17so5436088plo.1
        for <netdev@vger.kernel.org>; Fri, 04 Nov 2022 09:50:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sartura.hr; s=sartura;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aqKbKXfN/Kl/YBsSZhr+kY7w2JlUTQv8fAKnX9kUxlA=;
        b=b/3iL1f/roPLiVYau8lWmUdsgyXVhz1ZRPy+8G4hoaTQqtW0h3EaZfmoc8Ow6q9V5E
         UrSK87SpMViwfhalfKsSp+zq/9c+Ds8iNA+PM6C/VLk3LcOyeL0IlGdGuN7U3FfTU6c1
         2He8bVTOAiS8kWDcL5qvtNukfsDHjW9rw2rIqE50lPs5obS3zaJ+fh169ccLwOH57fr0
         9IISk/LnemBWAr+/2QEILkPbS17ZNpgr/gAnnKMBLIZJmqzTExI/1M4JLZdHlDIB/qs3
         5bu65dVHMfjE79yli20iTrN2UkUhdwFP/xewnnHQO2HhxHhjaasXx0WCdM+yhlvR1yF7
         0zrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aqKbKXfN/Kl/YBsSZhr+kY7w2JlUTQv8fAKnX9kUxlA=;
        b=qVsvTKuCRL+OijPOHdRZw2uuNhoTYZB+i3znYw7T1UjBLCDa5YuSvrY9rk9GLrP39b
         38oOlJKHqcSR0BlhCnKfkK6HdFngam1NsrrdIdLEUBJoZVoTxBF1IvYCPmQPCXjnJdJq
         3vIvv22loxSSRwTihIZlL/cNU2Hs1bR4WgzOBbXr32LTI6PcvbqEgji2CgKaCHTN/jkM
         UOYMeNLQfp51vbc+8aQKANIRsiNgdNIn8QQK89397V2PJ3w08XrthDmBpO+LyGZGGekM
         1P7IHUSwJVyOBu7Fu/PNoH/0byWK8DpZq7dfWDojIR9f45wV1uSF+0WhJuugz8dXLoFp
         PZUw==
X-Gm-Message-State: ACrzQf05dMz3UvIAQzFc7Wv3JcPPQG9/ENYls9/6KOjx4s1A7yJRIZ7D
        aObblaaArOe/cT6tfE0vZBuNBbsHZycnbvgvZ5Nnnw==
X-Google-Smtp-Source: AMsMyM5zpsMoVDTMaHJllLSmylVIhwIeZd51qqJEfE7RifMDbeUGSm3zFSFKMppSGCyECqWLItWme2sq81z8jYgzrS4=
X-Received: by 2002:a17:90b:4c8c:b0:214:9a:1fd0 with SMTP id
 my12-20020a17090b4c8c00b00214009a1fd0mr22996063pjb.219.1667580657660; Fri, 04
 Nov 2022 09:50:57 -0700 (PDT)
MIME-Version: 1.0
References: <20221104142746.350468-1-maxime.chevallier@bootlin.com>
 <20221104142746.350468-6-maxime.chevallier@bootlin.com> <CA+HBbNHTmpPJqzja11OqS9J-37vdDiDLubrimke73x+oQKuoJA@mail.gmail.com>
 <20221104164533.32qelsphhcmnm2gi@skbuf>
In-Reply-To: <20221104164533.32qelsphhcmnm2gi@skbuf>
From:   Robert Marko <robert.marko@sartura.hr>
Date:   Fri, 4 Nov 2022 17:50:46 +0100
Message-ID: <CA+HBbNGZ5WsJFuz69CLrr=-vLaev97__NRjDwDRSMN0gJvi=uw@mail.gmail.com>
Subject: Re: [PATCH net-next v7 5/5] ARM: dts: qcom: ipq4019: Add description
 for the IPQESS Ethernet controller
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 4, 2022 at 5:45 PM Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
>
> On Fri, Nov 04, 2022 at 05:42:30PM +0100, Robert Marko wrote:
> > > +                       phy-mode = "internal";
> > > +                       status = "disabled";
> >
> > The fixed-link should be defined here AFAIK, otherwise it will fail probing with
> > just internal PHY mode.
>
> It wouldn't fail to probe because it has status = "disabled" by default,
> and who enables that would also provide the fixed-link presumably.
> But if the speed of the pseudo-MAC that goes to the switch is not board
> specific, indeed the fixed-link belongs to the SoC dtsi.

Yes, its directly connected to the switch CPU port and its a part of the SoC,
so it should be defined in the SoC DTSI as it cannot really be changed on
boards.

Regards,
Robert
-- 
Robert Marko
Staff Embedded Linux Engineer
Sartura Ltd.
Lendavska ulica 16a
10000 Zagreb, Croatia
Email: robert.marko@sartura.hr
Web: www.sartura.hr
