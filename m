Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2586E60B9
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 14:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229453AbjDRMKJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 08:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231409AbjDRMJn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 08:09:43 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50A2FB767;
        Tue, 18 Apr 2023 05:08:38 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-3f17b967bfbso5657865e9.1;
        Tue, 18 Apr 2023 05:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681819717; x=1684411717;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xqD3uLs0akknQuC+1QDW9JQQl0Fj4X33/dPlJQV5jPc=;
        b=XF2+u0j25J/TwSxau1ZWpFxZ5xGvYDu4C59y7b+MOzjIKp/j3lE4ettHlwkDDZTl+7
         0NuRtyEwKEk8ji5r4hyTETXJOarcN2tTcIiPSTdUaOhl5ct0JF72174dIijevvDfBkPJ
         ZWgEYdg3FIG+vp82z7d4bQg/U5d3e/mbvUGNTryr8EUlFrovQ4ny9BlI13g3q2zvffbs
         IUyRCQ3Hla0lppwyVIgVXJ3qp0hqQqYczD2/lDhtfF74aVzl92lsRog7UP5PJRD6LBTs
         swcWHAG0iRWh33bBadFdZhtxKjiC2aHDI5kVeO+GwlO6EuCd+grmNDrz0VRnNPmOGnm8
         22dQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681819717; x=1684411717;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xqD3uLs0akknQuC+1QDW9JQQl0Fj4X33/dPlJQV5jPc=;
        b=Keb2r4WMy7qlOIVoQwfgosjDWXLQ8scDzPqjgV+ACmg09M2zJX1NCkvjFuqBc7+ZnT
         0Dhrs7S03t9gb0ZZ40O3Wnq1gCx84yRLijs/+ng5KTlFJhOaVYXA3FDC2eiCF6Kec/jn
         4hDPv7vGnCgPHqpmu5mLk+hnLI6RW7oa9dihvi0MroMhQWkeHFua8qbMsMmiMOFknqIN
         crLOHaxlrBh9cIeB2Im8TsTWUbDeQldy37uWNFD+FbGjYALwdMBhWsu+LjnRMHAfto8F
         qa1Xr82ALT5nDimwZZblYd6muD9/wX3Jjdf/h8IxmBT9SaIawq6IOVznDpa3TdwYkyCP
         N4yQ==
X-Gm-Message-State: AAQBX9cSlINQteCSBkA/qJr/SuZ7ur45/PUOKuPiicrTeJ10DTc7cGVP
        9lS37EumYisZx3aFPLUcMF0=
X-Google-Smtp-Source: AKy350YTTs8NDSLDbSwNBUhPgu+ySlyTVzqzZPhCyVgNlSXbq/5wLZ7QI31Vv/MOIpgzZMvwn5scUw==
X-Received: by 2002:a5d:61c4:0:b0:2ef:84c:a4bc with SMTP id q4-20020a5d61c4000000b002ef084ca4bcmr1670727wrv.19.1681819716461;
        Tue, 18 Apr 2023 05:08:36 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id m4-20020a5d6a04000000b002f0442a2d3asm12963954wru.48.2023.04.18.05.08.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 05:08:36 -0700 (PDT)
Date:   Tue, 18 Apr 2023 15:08:33 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Arun Ramadoss <arun.ramadoss@microchip.com>,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, UNGLinuxDriver@microchip.com
Subject: Re: [PATCH net-next v1 2/2] net: dsa: microchip: Add partial ACL
 support for ksz9477 switches
Message-ID: <20230418120833.5xzyinqb2utw77qa@skbuf>
References: <20230411172456.3003003-1-o.rempel@pengutronix.de>
 <20230411172456.3003003-3-o.rempel@pengutronix.de>
 <20230413042936.GA12562@pengutronix.de>
 <20230416165904.2y7zwgyxwltjzj7m@skbuf>
 <20230418072450.GC30964@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230418072450.GC30964@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 09:24:50AM +0200, Oleksij Rempel wrote:
> On Sun, Apr 16, 2023 at 07:59:04PM +0300, Vladimir Oltean wrote:
> > On Thu, Apr 13, 2023 at 06:29:36AM +0200, Oleksij Rempel wrote:
> > > According to KSZ9477S 5.2.8.2 Port Priority Control Register
> > > "To achieve the desired functionality, do not set more than one bit at a
> > > time in this register.
> > > ...
> > > Bit 6 - OR’ed Priority
> > > ...
> > > Bit 2 - 802.1p Priority Classification
> > > Bit 1 - Diffserv Priority Classification
> > > Bit 0 - ACL Priority Classification
> > > "
> > > @Arun  what will happen if multiple engines are used for packet
> > > prioritization? For example ACL || Diffserv || 802.1p... ?
> > > If I see it correctly, it is possible but not recommended. Should I
> > > prevent usage of multiple prio sources? 
> > 
> > You could try and find out which one takes priority... we support VLAN
> > PCP and DSCP prioritization through the dcbnl application priority table.
> 
> What will be the mainlineable interface for the DSCP support for KSZ8 series?
> If i see it correctly, it should be possible to use tc:
> tc filter add dev lan2 ingress protocol ip flower ip_tos 0x28 skip_sw skbedit priority 7
> or dcb:
> dcb app add dev lan2 dscp-prio 28:7
> 
> dcb implementation seems to have some advantages, since it will
> allow to use OpenLLDP to configure traffic priorities. Correct?

Switch driver writers (DSA/felix/ocelot, sparx5, mlxsw/spectrum) seem to
have decided that basic QoS classification (VLAN PCP, IP DSCP) should go
through something more simple for the user to digest than tc, which
should be used only for advanced QoS classification, and which, in
general, can have all sorts of gotchas preventing easy portability
(I'm thinking of chains, for example). I would say go for dcbnl.
Daniel Machon, with Petr's help, added support for VLAN PCP
prioritization there as well, so it should be fairly usable now.
