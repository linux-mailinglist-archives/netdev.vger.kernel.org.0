Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA7868A463
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 22:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233477AbjBCVPA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 16:15:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233703AbjBCVO7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 16:14:59 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 266D138EAA;
        Fri,  3 Feb 2023 13:14:57 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id r27so1954325wrr.1;
        Fri, 03 Feb 2023 13:14:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=v8UifT5o8QIL+1ZOw+vxMKGXi/nfDw7qQB6T6ClS8Ic=;
        b=pd4JdGeGvQ+bwoWBkvvdDb0hhyE/Bxhta6bcG3jxt0dWu7ZCdJQHLjZUYh/neaf8kv
         E2vN7hCsLGKW2de3K6muUrxk3KJCGwOsziVlBtiWxe9afhV1sVgLOZTGjzEZ986sCAQE
         fKtMsX5U/ln9C0+q5QNHGuB2n94r0ojW3gCL6ueoVBlSVA0i1kk9DA76BLAopPpz5a+r
         +w+xc49sVxrSI6XphvcS8f9anBNzfLSR2DfW9+hI22SIZJYNLUdgyFra+/+vBm50At92
         l5Es6QjHbL5/d/8HlTu0B/cTjn6/Uqmc6dzhzy8HEN0z3ioILJcKrb0mAt/0BQo+hytZ
         2vtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v8UifT5o8QIL+1ZOw+vxMKGXi/nfDw7qQB6T6ClS8Ic=;
        b=WEaLGFT7pd1u48TvwOFgqRIGmXN2klYQFPU8BmKVoHbMs77vwkqcY4ot7Ughleqjru
         FJPjBZZIzLVLjPJDrroluXH4InXRRegKcLRW1RM6UkQ/pJbsLyrQjd1b8f9Jn8PhayM6
         U2vTbP22iJDkvofn2ZYEWwKowwifTpkLZHMa7MjTh+w74/23H9QncNRZhJCYh464PPo0
         AurgA6rkV3h4VoNhT+FyRi455wW530NDeMXhz9+7PZrEq8it2Eyou8Yc7vaXWUf/KvZE
         uJN69i8UnGk75ray5rdFqUAFhzRD/bDAV7cSlMLrTV81UFC9dP+ao5T1GkQdVjw27ell
         TlnQ==
X-Gm-Message-State: AO0yUKWwj86BRKmJ50y5p/UZ8x4HAwwcc3J03cENqj+tfx3TzM3FBoMN
        y0AAq8lGjdaxF+s7fh1BTKU=
X-Google-Smtp-Source: AK7set+hBed4Vs81Op6a8Moc0ZYf2TGrkIyuIwn9zkILCDF+4akhZ0fn2PUit7H3sH6BdDxxPfJo6w==
X-Received: by 2002:a05:6000:1f0f:b0:2bf:bbd1:1db3 with SMTP id bv15-20020a0560001f0f00b002bfbbd11db3mr10247467wrb.44.1675458895502;
        Fri, 03 Feb 2023 13:14:55 -0800 (PST)
Received: from skbuf ([188.26.57.116])
        by smtp.gmail.com with ESMTPSA id w7-20020adff9c7000000b002be546f947asm2835380wrr.61.2023.02.03.13.14.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Feb 2023 13:14:55 -0800 (PST)
Date:   Fri, 3 Feb 2023 23:14:51 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@kapio-technology.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        "maintainer:MICROCHIP KSZ SERIES ETHERNET SWITCH DRIVER" 
        <UNGLinuxDriver@microchip.com>, Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Russell King <linux@armlinux.org.uk>,
        Christian Marangi <ansuelsmth@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        "open list:RENESAS RZ/N1 A5PSW SWITCH DRIVER" 
        <linux-renesas-soc@vger.kernel.org>,
        "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>
Subject: Re: [PATCH net-next 0/5] ATU and FDB synchronization on locked ports
Message-ID: <20230203211451.3rhg2kg6tjmmhfmp@skbuf>
References: <20230130173429.3577450-1-netdev@kapio-technology.com>
 <Y9lrIWMnWLqGreZL@shredder>
 <e2535b002be9044958ab0003d8bd6966@kapio-technology.com>
 <Y9vaIOefIf/gI0BR@shredder>
 <3cecf4425b0e6f38646e25e40fd8f0fd@kapio-technology.com>
 <Y9vmfoaFxPdKvgxt@shredder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9vmfoaFxPdKvgxt@shredder>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 06:36:14PM +0200, Ido Schimmel wrote:
> On Thu, Feb 02, 2023 at 05:19:07PM +0100, netdev@kapio-technology.com wrote:
> > On 2023-02-02 16:43, Ido Schimmel wrote:
> > > On Thu, Feb 02, 2023 at 08:37:08AM +0100, netdev@kapio-technology.com wrote:
> > > > On 2023-01-31 20:25, Ido Schimmel wrote:
> > > > >
> > > > > Will try to review tomorrow, but it looks like this set is missing
> > > > > selftests. What about extending bridge_locked_port.sh?
> > > > 
> > > > I knew you would take this up. :-)
> > > > But I am not sure that it's so easy to have selftests here as it is timing
> > > > based and it would take the 5+ minutes just waiting to test in the stadard
> > > > case, and there is opnly support for mv88e6xxx driver with this
> > > > patch set.
> > > 
> > > The ageing time is configurable: See commit 081197591769 ("selftests:
> > > net: bridge: Parameterize ageing timeout"). Please add test cases in the
> > > next version.
> > 
> > When I was looking at configuring the ageing time last time, my finding was
> > that the ageing time could not be set very low as there was some part in the
> > DSA layer etc, and confusion wrt units. I think the minimum secured was like
> > around 2 min. (not validated), which is not that much of an improvement for
> > fast testing. If you know what would be a good low timeout to set, I would
> > like to know.
> 
> My point is that the ageing time is parametrized via 'LOW_AGEING_TIME'
> in forwarding.config so just use '$LOW_AGEING_TIME' in the selftest and
> set it as high as it needs to be for mv88e6xxx in your own
> forwarding.config.

FWIW, we have a forwarding.config file in tools/testing/selftests/drivers/net/dsa/.
So you could cd to that folder, edit the file with your variable, and run the symlinked
script from there.

> as there was some part in the DSA layer etc

	if (ds->ageing_time_min && ageing_time < ds->ageing_time_min)
		return -ERANGE;

High tech, advanced software.....

You could print the ds->ageing_time_min variable. For mv88e6xxx, my 6390
and 6190 report 3750. I have to admit the ageing time units are confusing,
but Tobias Waldekranz kindly explained in one of those commit messages
that Ido linked to that these represent "centiseconds" (or 37.5 seconds).
And I think we discussed the units with you before. And in general, it's
not hard to find the answer if you search for it, I know I could find it.

Please stop trying to find silly excuses to always go through the path
of minimal resistance.
