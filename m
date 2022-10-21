Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BEC560760A
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 13:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbiJULWd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 07:22:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbiJULWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 07:22:31 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 875A6264E44;
        Fri, 21 Oct 2022 04:22:22 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id b12so4572994edd.6;
        Fri, 21 Oct 2022 04:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=y83I/EEj5O1WzvhlqMvy69bC2C3kma+TguYlktElg+U=;
        b=aqI400aFX+Hv1if94yQ/9coImAcoL5xm5EE9Z8Pnq+JQ7MqId0ZuB5eW9kjAqCiUrN
         KMZPlHItsw5EctvNgdlnTcP5laLuqUz+SV1o33najcKCsjf0QARB5ow9Z44sTZTOmSeg
         UrpNC6fH6ciHR2X4rGmdJWOSbH4r9VMHXzYepV/zYSLDnnNwqU+kf3Zv2sg7HE61xVNl
         7t3a9w2kLyvF5PibwmB0qSxZXtgVyxt+2/Ir7YJLUZG06dtskhoVW5tz2mc4jA71zIm4
         UhnubOmNzJl78yCv0QqxYV7AfFoBR+16JycwYyxr/dmdd6j59K4vgycD/Tzgpk9gib2d
         VCVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y83I/EEj5O1WzvhlqMvy69bC2C3kma+TguYlktElg+U=;
        b=Zu7GJbQ5TZlq8kH3vSDfX32h0DpvTIuuQNUkPQ9vNy6ffF/Fdd5NenNwr+hjJd6FQd
         IiRhebil1Oj4gj5stR4NrQLqrwlScAPWbqDicS5XY4hmYIhqoXqkK24EnVNFmaOUryXh
         gL7OGQrXccV2meGHaSrPFXzkUwzoUOP81Lcm71M0YFZF3NWMPWE0FwPiXkile2or1J5D
         dbwMlcnfQ8xX5d3yrMjfYI/K3pnderM4JFhCqAZloZHg76cFzOXg8+e7OWkvthjGde2L
         Ojln8bY0L2m2KBD1q3z2QgFqYYJ3BdhAoc46lMhY1pxfmQIK70KroP4EEvCbETYG/Zf6
         V7dQ==
X-Gm-Message-State: ACrzQf1Ru5sTUk8bEuzce1bgXu9Co2uAzt4h14NqO2T1eR8dgHNC/oOv
        S+BjpNducF+Zbp14uG1BXpI=
X-Google-Smtp-Source: AMsMyM4Ljgcs84MFVGjjaNn1SINn2K1OMLuiOgFc7iq4/CDwKUIaipwaA3YvQFgGhkmQ345GuQJlMw==
X-Received: by 2002:a17:906:db0e:b0:77b:82cf:54a6 with SMTP id xj14-20020a170906db0e00b0077b82cf54a6mr14838182ejb.691.1666351340215;
        Fri, 21 Oct 2022 04:22:20 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id g22-20020a50d5d6000000b00457160c3c77sm13487340edj.20.2022.10.21.04.22.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 04:22:19 -0700 (PDT)
Date:   Fri, 21 Oct 2022 14:22:16 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@kapio-technology.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Hans Schultz <schultz.hans@gmail.com>,
        Joachim Wiberg <troglobit@gmail.com>,
        Amit Cohen <amcohen@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        bridge@lists.linux-foundation.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v8 net-next 10/12] net: dsa: mv88e6xxx: mac-auth/MAB
 implementation
Message-ID: <20221021112216.6bw6sjrieh2znlti@skbuf>
References: <20221018165619.134535-1-netdev@kapio-technology.com>
 <20221018165619.134535-1-netdev@kapio-technology.com>
 <20221018165619.134535-11-netdev@kapio-technology.com>
 <20221018165619.134535-11-netdev@kapio-technology.com>
 <20221020132538.reirrskemcjwih2m@skbuf>
 <2565c09bb95d69142522c3c3bcaa599e@kapio-technology.com>
 <20221020225719.l5iw6vndmm7gvjo3@skbuf>
 <82d23b100b8d2c9e4647b8a134d5cbbf@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <82d23b100b8d2c9e4647b8a134d5cbbf@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 21, 2022 at 08:47:42AM +0200, netdev@kapio-technology.com wrote:
> On 2022-10-21 00:57, Vladimir Oltean wrote:
> > On Thu, Oct 20, 2022 at 10:20:50PM +0200, netdev@kapio-technology.com
> > wrote:
> > > In general locked ports block traffic from a host based on if there
> > > is a
> > > FDB entry or not. In the non-offloaded case, there is only CPU
> > > assisted
> > > learning, so the normal learning mechanism has to be disabled as any
> > > learned entry will open the port for the learned MAC,vlan.
> > 
> > Does it have to be that way? Why can't BR_LEARNING on a BR_PORT_LOCKED
> > cause the learned FDB entries to have BR_FDB_LOCKED, and everything
> > would be ok in that case (the port will not be opened for the learned
> > MAC/VLAN)?
> 
> I suppose you are right that basing it solely on BR_FDB_LOCKED is possible.
> 
> The question is then maybe if the common case where you don't need learned
> entries for the scheme to work, e.g. with EAPOL link local packets, requires
> less CPU load to work and is cleaner than if using BR_FDB_LOCKED entries?

I suppose the real question is what does the bridge currently do with
BR_LEARNING + BR_PORT_LOCKED, and if that is sane and useful in any case?
It isn't a configuration that's rejected, for sure. The configuration
could be rejected via a bug fix patch, then in net-next it could be made
to learn these addresses with the BR_FDB_LOCKED flag.

To your question regarding the common case (no MAB): that can be supported
just fine when BR_LEARNING is off and BR_PORT_LOCKED is on, no?
No BR_FDB_LOCKED entries will be learned.
