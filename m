Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4482673A8F
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 14:41:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbjASNlZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 08:41:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231377AbjASNky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 08:40:54 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9451278AB4;
        Thu, 19 Jan 2023 05:40:50 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id b4so2971285edf.0;
        Thu, 19 Jan 2023 05:40:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2sA9EhPclZO6+f6VLQzu+GI/zukGWQQoz8R1Dt12GsI=;
        b=Ssrumq6PQhx2e/g4Bd6SuNl23SQH9Qv/nzp1Uy9v//x8kEfruuqhhMNDkoX0H6ubCI
         MaR+SU/RqMNRmjwnNWDMEcpz5GjfoleC+3BNcTsopxhWnVzJ1nwvkgl4GUS7gqR9n1Fq
         izOLXvz1I0ML3IDmv7IE1eUXRtk1Yci1fVgckWGdmoTrtO/ZlMVH35H0a2v/yyavFMTI
         dgIH49auVy3dEz1m78McldLsu3o9041upq0t+vH0lbSnrUxZ+kOG4XyhlXJ82KOUrTZk
         0WYx/93yCnKvBMWzXt48IicEnnzHqiPpFmQESj7PjC1dRCf2NXHPeU7yGmFs8AcDl6o1
         hazw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2sA9EhPclZO6+f6VLQzu+GI/zukGWQQoz8R1Dt12GsI=;
        b=1j2NJZidS+By0h6XrS1PaKz9g1mTACRpTRZsGCy43VMDrwigaxcvy4OFKlATijmUCU
         zZrPu3uiijCxj9lQdBcuD+Q+eBDcPsqujX65ux27AhANawMuodujkCREoZvmWMi8Nnqa
         5KKbEqtPi7WUV4nM/hlicpP+7NVIrIHTf/tpONaYcqEvFgPNAmjiwEYPzLMAnUxpidO6
         QEfsZdZa8hdtWDT/lQMjG2qGngZSU4hl5LhXb93I8kQo5g7kk/nSJM4kXpr+A6Z3jk0R
         RKMZKrijD30Qdi/u0PEVRKTc2fF1nFpkUamFgysPJOO2LjNvHPzWsHmuOCIQ1ZnkB7Ic
         naOw==
X-Gm-Message-State: AFqh2kqd8mXHy7ImjY30cZyxBsZWtSz1QID0fSlCZOq9g7qTquh/9ttF
        5Al/Ct/AKrG0Bb1zXcij87s=
X-Google-Smtp-Source: AMrXdXvXkuKoZFQFQT4KXsKjMumQ66Scy56M1tiUgcqYCQA/AY3QpuuZlRLh4qPLSeGgenAVe3KP+g==
X-Received: by 2002:a05:6402:cba:b0:49d:25f3:6b4e with SMTP id cn26-20020a0564020cba00b0049d25f36b4emr10522051edb.28.1674135648960;
        Thu, 19 Jan 2023 05:40:48 -0800 (PST)
Received: from skbuf ([188.27.185.85])
        by smtp.gmail.com with ESMTPSA id sb25-20020a1709076d9900b0084c6581c16fsm16304907ejc.64.2023.01.19.05.40.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Jan 2023 05:40:48 -0800 (PST)
Date:   Thu, 19 Jan 2023 15:40:45 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     netdev@kapio-technology.com
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
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
Subject: Re: [RFC PATCH net-next 1/5] net: bridge: add dynamic flag to
 switchdev notifier
Message-ID: <20230119134045.fqdt6zrna5x3iavt@skbuf>
References: <20230117185714.3058453-1-netdev@kapio-technology.com>
 <20230117185714.3058453-2-netdev@kapio-technology.com>
 <20230117230806.ipwcbnq4jcc4qs7z@skbuf>
 <a3bba3eb856a00b5e5e0c1e2ffe8749a@kapio-technology.com>
 <20230119093358.gbyka2x4qbxxr43b@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230119093358.gbyka2x4qbxxr43b@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 19, 2023 at 11:33:58AM +0200, Vladimir Oltean wrote:
> On Wed, Jan 18, 2023 at 11:14:00PM +0100, netdev@kapio-technology.com wrote:
> > > > +	item->is_dyn = !test_bit(BR_FDB_STATIC, &fdb->flags);
> > > 
> > > Why reverse logic? Why not just name this "is_static" and leave any
> > > further interpretations up to the consumer?
> > 
> > My reasoning for this is that the common case is to have static entries,
> > thus is_dyn=false, so whenever someone uses a switchdev_notifier_fdb_info
> > struct the common case does not need to be entered.
> > Otherwise it might also break something when someone uses this struct and if
> > it was 'is_static' and they forget to code is_static=true they will get
> > dynamic entries without wanting it and it can be hard to find such an error.
> 
> I'll leave it up to bridge maintainers if this is preferable to patching
> all callers of SWITCHDEV_FDB_ADD_TO_BRIDGE such that they set is_static=true.

Actually, why would you assume that all users of SWITCHDEV_FDB_ADD_TO_BRIDGE
want to add static FDB entries? You can't avoid inspecting the code and
making sure that the is_dyn/is_static flag is set correctly either way.
