Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B28C36BF794
	for <lists+netdev@lfdr.de>; Sat, 18 Mar 2023 04:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbjCRDjB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 23:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCRDi6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 23:38:58 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B276424E;
        Fri, 17 Mar 2023 20:38:55 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id x11so5363535pja.5;
        Fri, 17 Mar 2023 20:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679110735; x=1681702735;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=DryAiGtqk9gg/qaUYTCT9ICwZyltKTPJlh9sl25+K3E=;
        b=Mvt0o8C99T9SJCYcpColaDH01yeBOxgunwqoJd8L/pUu4CjI+sq59nJYEHDpUz79Wy
         R0eNymGCbDCNaE/35GpDMp1ZawdtCWOVUki74/rHOZhQiZqXX8gIRmwFDSRR+OjakYzJ
         HRhaQafNXQvru2SbhsU0jxmHitOfUrqG/tnzdH0HHO9/l+OSeZiBsC8uxS8p+H/x3SPT
         ggsPukpkh5Qtk9xDlWkasDnQ3dqVeHv/oDrzApdsbaE8PXIt+JqDjr7ToVfkv2Eozrey
         EMGGQdAjxjtlXJEf2mQb5v7QQvu5MSzwBxcYoAu9nrSZYyEe1C5i6fS/ZhDOvhoiufST
         UkUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679110735; x=1681702735;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DryAiGtqk9gg/qaUYTCT9ICwZyltKTPJlh9sl25+K3E=;
        b=DLwxUEJ3GSNtXdxwtqkMdN2ZJNZtZGwNYyJAJOXJ8LofMyAoW9mqmoQYMFacT4cSCa
         QPGEMpPIWAvVTJySTJyE8lr5agyqgrRwcmECT+iaZLnzUazlYUcgMoHQDfLiDcwBhGNc
         1EfSPGlpQu+NLA7Udcnz+esx2yhTFb8gbDKB51QGE95mPCpgBpW1uh9gIAhy3r45oCsP
         PxiSqP/muWTpKy1s8jJyQ5kZ06ndkn1rsD51McjARe2qSGwTGi3Nb1/spsXcfSy47OHY
         TxbgInSPvxGFtHiuZBk2Gp8hjdhEtKGTuoQz55Ar4iiCWZWkdVAFUtq3HFFs6SIRDdCa
         0B5w==
X-Gm-Message-State: AO0yUKWaM6TXuOATM+YV/gwBtvZiY5WPi6zIkN9HkPPcH/e1bZUnPin1
        0sNvyMhS7KRATT0r2TZD6e8=
X-Google-Smtp-Source: AK7set8vFSOArCcgjJJlhme7kLuMERbPvcbjXADVR1VxwDC4xDe+DSefSPq+09CgfAD79KHSH15dfg==
X-Received: by 2002:a17:90a:fe8b:b0:23d:2b53:1ae2 with SMTP id co11-20020a17090afe8b00b0023d2b531ae2mr8288867pjb.3.1679110734899;
        Fri, 17 Mar 2023 20:38:54 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id q10-20020a17090a304a00b00233acae2ce6sm5590404pjl.23.2023.03.17.20.38.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 20:38:54 -0700 (PDT)
Date:   Fri, 17 Mar 2023 20:38:49 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     =?iso-8859-1?Q?K=F6ry?= Maincent <kory.maincent@bootlin.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Michael Walle <michael@walle.cc>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-omap@vger.kernel.org,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        thomas.petazzoni@bootlin.com, Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Minghao Chi <chi.minghao@zte.com.cn>,
        Jie Wang <wangjie125@huawei.com>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Sean Anderson <sean.anderson@seco.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Marco Bonelli <marco@mebeim.net>
Subject: Re: [PATCH v3 3/5] net: Let the active time stamping layer be
 selectable.
Message-ID: <ZBUyST3kDP1ZE1lF@hoboy.vegasvil.org>
References: <20230308135936.761794-4-kory.maincent@bootlin.com>
 <20230308230321.liw3v255okrhxg6s@skbuf>
 <20230310114852.3cef643d@kmaincent-XPS-13-7390>
 <20230310113533.l7flaoli7y3bmlnr@skbuf>
 <b4ebfd3770ffa5ad1233d2b5e79499ee@walle.cc>
 <20230310131529.6bahmi4obryy5dsx@soft-dev3-1>
 <20230310164451.ls7bbs6pdzs4m6pw@skbuf>
 <20230313084059.GA11063@pengutronix.de>
 <20230316160920.53737d1c@kmaincent-XPS-13-7390>
 <20230317152150.qahrr6w5x4o3eysz@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230317152150.qahrr6w5x4o3eysz@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 05:21:50PM +0200, Vladimir Oltean wrote:
> On Thu, Mar 16, 2023 at 04:09:20PM +0100, Köry Maincent wrote:
> > Was there any useful work that could be continued on managing timestamp through
> > NDOs. As it seem we will made some change to the timestamp API, maybe it is a
> > good time to also take care of this.
> 
> Not to my knowledge. Yes, I agree that it would be a good time to add an
> NDO for hwtimestamping (while keeping the ioctl fallback), then
> transitioning as many devices as we can, and removing the fallback when
> the transition is complete.

Um, user space ABI cannot be removed.

Thanks,
Richard
