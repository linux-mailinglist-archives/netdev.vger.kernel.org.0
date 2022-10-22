Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28BF4608D15
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 14:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbiJVMCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 08:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiJVMCH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 08:02:07 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA6C22CF3B6;
        Sat, 22 Oct 2022 05:02:05 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id m15so14991331edb.13;
        Sat, 22 Oct 2022 05:02:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=xJswdS7kC+5Dq/oSBvb9hTl0H5TWQ6aU0davE3hjl1Y=;
        b=dvzFO2xkBvm/I20DsGFjUnIHX/SdJqe96jZQplwuGvJpQE4bAzpLO0o/eH7aNuN1tI
         UJcjmOTutwMDaISNJqVGDAnOtGq5GkpDWhHNxclYnyNCg+IdJZLja8Rf55StXWvKatpF
         yKnVmqSOFj+g5UFG75lcNmGxsSmbyHf3MG8LEsvNuYV26gmdyAMDkNCxLEkuM1c+NN+L
         Fa5Qnhk7EKEegtg5NV3PwfHWw5FJPQKv92qfP04bfdV1tdoo6uAuC13WTqfM5Xt3LblO
         BczxEoKr+pCJVLvA1jJ/hm7FlpgtHfG5xa3xhZ3VgL5kca9F+WGw25fyyz++/lAAMFDs
         dXHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xJswdS7kC+5Dq/oSBvb9hTl0H5TWQ6aU0davE3hjl1Y=;
        b=fF6AIFAXmRtNWAQlMl69gk3ITN0kUfAy3P5Qnlye2csNrJsNP/qHXtozrEoXVU5n0O
         jbuLlifvI481tpGVaRIffkHCm/BS2Vd0DE+UzTRGMwmtt32IZvZxarDarOGia9b0WeO/
         o9vDlPd0HSaynoXCVXwVfSV2JlHP0Xs1UHavfhGroYjhXK11Q/kYUdFYs0FFzBH5w4vy
         QHMQiHbaZFy+LOAswed7n8X7HcBPUpf9IQofKjrZjKX1V8Vj4uTuak25UV9VxB2LVbeD
         LKwrY0/QESf6aoOGSLdBadXDg0QU4Q5/2Ezvt6tRA1fAt66OhO8jgdLMjlDlnV3wkXhu
         LyaA==
X-Gm-Message-State: ACrzQf2ggtWWLvpN18St833yosdbnuwQR9LIiv/vihKMFAX1lJbUhIz+
        oXK0JWOyOXZa7scKub+ffWM=
X-Google-Smtp-Source: AMsMyM6Fmdy49HywfzOaMBOmuOmQiypZLiOuHNCnJMuBTRIFt8BiFMip0M63IhGdvg3IsRPPq/Kt0g==
X-Received: by 2002:a17:907:a06e:b0:79f:e42d:8d54 with SMTP id ia14-20020a170907a06e00b0079fe42d8d54mr3497885ejc.72.1666440124277;
        Sat, 22 Oct 2022 05:02:04 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id u13-20020aa7d54d000000b00458478a4295sm15051796edr.9.2022.10.22.05.02.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Oct 2022 05:02:03 -0700 (PDT)
Date:   Sat, 22 Oct 2022 15:02:00 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@kapio-technology.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
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
Message-ID: <20221022120200.no5pl54bcfa3wcnd@skbuf>
References: <20221020225719.l5iw6vndmm7gvjo3@skbuf>
 <82d23b100b8d2c9e4647b8a134d5cbbf@kapio-technology.com>
 <20221021112216.6bw6sjrieh2znlti@skbuf>
 <7bfaae46b1913fe81654a4cd257d98b1@kapio-technology.com>
 <20221021163005.xljk2j3fkikr6uge@skbuf>
 <d1fb07de4b55d64f98425fe66156c4e4@kapio-technology.com>
 <20221021173014.oit3qmpkrsjwzbgu@skbuf>
 <b88e331e016ad3801f1bf1a0dec507f3@kapio-technology.com>
 <20221021181411.sv52q4yxr5r7urab@skbuf>
 <37dc7673fde2b8e166a5ed78431a2078@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37dc7673fde2b8e166a5ed78431a2078@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 22, 2022 at 09:24:56AM +0200, netdev@kapio-technology.com wrote:
> I will not say that you are not making sense as for the mv88e6xxx, as it
> needs port association in all cases with BR_PORT_LOCKED, MAB or not, and
> port association is turned on in the driver with learning turned on.
> 
> That said, there must be some resolution and agreement overall with this
> issue to move on. Right now port association is turned on in the mv88e6xxx
> driver when locking the port, thus setting learning off after locking will
> break things.

This already needs to be treated as a bug and fixed on its own. Forget
about MAB.

You're saying that when BR_LEARNING=on and BR_PORT_LOCKED=on, the
mv88e6xxx driver works properly, but the software bridge is broken
(learns from link-local multicast).

When BR_LEARNING=off and BR_PORT_LOCKED=on, the software bridge is not
broken, but the mv88e6xxx driver is, because it requires the PAV
configured properly.

And you're saying that I'm the one who suggests things should work
differently in software mode vs offloaded mode?!

Why don't you
(a) deny BR_LEARNING + BR_PORT_LOCKED in the bridge layer
(b) fix the mv88e6xxx driver to always keep the assoc_vector set
    properly for the port, if BR_LEARNING *or* BR_PORT_LOCKED is set?
