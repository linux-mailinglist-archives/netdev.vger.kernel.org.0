Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 123916CBE10
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 13:49:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232934AbjC1Ltv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 07:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230073AbjC1Ltt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 07:49:49 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C816B4EE7;
        Tue, 28 Mar 2023 04:49:48 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id m6-20020a05600c3b0600b003ee6e324b19so7242338wms.1;
        Tue, 28 Mar 2023 04:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680004187;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=d/r365YzR4z2GUjbK/bi1SZFXqHlnLKc6PIvPNZ2lRc=;
        b=iO58f6tcmkzPWSbg7kupiEHtiApSvwACv57rpe3rm8RiJ8ouJG59UwXU2DToee2okr
         IUcYWKye6jJmJYfvu8eeByd1gtdC96vRX3/BCxhGs4KBB4vGDv0S0sCZHvk0eYBn69ov
         DcIjL4WpuncS0QlGPlBdg+C1Br3J70PkHveOmrnjimVIIMLw9HqmvqulopAjRdWAmEza
         AyVJoxGQYq5mBYBpvZVkYVsLfS8aBpjvkPZanvSjSmzb6xDTVCLb1so2EId6nM29koss
         74FFqqK2KtSZzXaFwagq5m/p/yrL+kpn7s0ykdfZInmR9zV5ehKdmn0DDBgYgvfVxhbf
         V/hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680004187;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d/r365YzR4z2GUjbK/bi1SZFXqHlnLKc6PIvPNZ2lRc=;
        b=mwaZyL++Geww5Rz2Lr6auJGQ25OFGJGw4KPJNMT0qzMYoToajQ6EJ2XknNOvO84b06
         xtx8SarV7J1ZkZofDttShQxp+vc9abMIUK4rbFHHmzFs4hSXLNjhUkAg830hGqojqkoZ
         aBusgX8SZj4EMDZyXQOMXMw62+IraAcAee+3xzK5q9KA8pdlxGsxiZYmKjyYOqWxdLpb
         FK8f5XFYr38Eo0gdWbW54gzesNehVMaaLu8n8IQfU/mX/nYTcXVRBRkxZdsZgVoL62RP
         d0YmlV6STgSCUzcl4WIz08TafQupLn+PHRn54H8N1RNhrVWsK5+H5ipK68ecmHUFk1h0
         b9Og==
X-Gm-Message-State: AO0yUKURt9aipupSx6KEiZSMZjvnw6ApgwG94O3/B9XxigQ+woiiUQnI
        ObpiIKMtZUKjmHuAsSCn+qY=
X-Google-Smtp-Source: AK7set+zTszhDgDoSbIPu4QLbK7SYfkBZiuqVsVMkXIAf2QkJVEAEbWd1vEqziskOOvC8WeShKxd4A==
X-Received: by 2002:a05:600c:3795:b0:3ed:a82d:dffb with SMTP id o21-20020a05600c379500b003eda82ddffbmr11330072wmr.40.1680004187137;
        Tue, 28 Mar 2023 04:49:47 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id u15-20020a05600c210f00b003ed2433aa4asm17097652wml.41.2023.03.28.04.49.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 04:49:46 -0700 (PDT)
Date:   Tue, 28 Mar 2023 14:49:43 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Hans Schultz <netdev@kapio-technology.com>
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
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        Ido Schimmel <idosch@nvidia.com>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>,
        "open list:RENESAS RZ/N1 A5PSW SWITCH DRIVER" 
        <linux-renesas-soc@vger.kernel.org>,
        "moderated list:ETHERNET BRIDGE" <bridge@lists.linux-foundation.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 2/6] net: dsa: propagate flags down towards
 drivers
Message-ID: <20230328114943.4mibmn2icutcio4m@skbuf>
References: <20230318141010.513424-1-netdev@kapio-technology.com>
 <20230318141010.513424-3-netdev@kapio-technology.com>
 <20230327115206.jk5q5l753aoelwus@skbuf>
 <87355qb48h.fsf@kapio-technology.com>
 <20230327160009.bdswnalizdv2u77z@skbuf>
 <87pm8tooe1.fsf@kapio-technology.com>
 <20230327225933.plm5raegywbe7g2a@skbuf>
 <87ileljfwo.fsf@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ileljfwo.fsf@kapio-technology.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 01:04:23PM +0200, Hans Schultz wrote:
> On Tue, Mar 28, 2023 at 01:59, Vladimir Oltean <olteanv@gmail.com> wrote:
> >
> > which idea is that, again?
> 
> So I cannot us the offloaded flag as it is added by DSA in the common
> case when using 'bridge fdb replace ... dynamic'.

Why not? I find it reasonable that the software bridge does not age out
a dynamic FDB entry that is offloaded to hardware... the hardware should
do that ("dynamic" being the key). At least, I find it more reasonable
than the current behavior, where the bridge notifies dynamic FDB entries
to switchdev, but doesn't say they're dynamic, and switchdev treats them
as static, so they don't roam from one bridge port to another until
software sees a packet with that MAC DA, and they have the potential of
blocking traffic because of that.

If for some reason you do think that behavior is useful and still want
to keep it (I'm not sure I would), I would consider extending struct
switchdev_notifier_fdb_info with a "bool pls_dont_age_out", and I would
make dsa_fdb_offload_notify() set this to true if the driver did
actually install the dynamic FDB entry as dynamic in the ATU.

> 
> The idea is then to use the ext_learn flag instead, which is not aged by
> the bridge. To do this the driver (mv88e6xxx) will send a
> SWITCHDEV_FDB_ADD_TO_BRIDGE switchdev event when the new dynamic flag is
> true. The function sending this event will then be named
> mv88e6xxx_add_fdb_synth_learned() in
> drivers/net/dsa/mv88e6xxx/switchdev.c, replacing the
> mv88e6xxx_set_fdb_offloaded() function but in most part the same
> content, just another event type.

Basically you're suggesting that the hardware driver, after receiving a
SWITCHDEV_FDB_ADD_TO_DEVICE and responding to it with SWITCHDEV_FDB_OFFLOADED,
emits a SWITCHDEV_FDB_ADD_TO_BRIDGE which takes over that software
bridge FDB entry, with the advantage that the new one already has the
semantics of not being aged out by the software bridge.

hmmm... I'd say that the flow should work even with a single notifier
emitted from the driver side, which would be SWITCHDEV_FDB_OFFLOADED,
perhaps annotated with some qualifiers that would inform the bridge a
certain behavior is required. Although, as mentioned, I think that in
principle, "pls_dont_age_out" should be unnecessary, because it just
papers over the issue that switchdev drivers treat static and dynamic
FDB entries just the same, and "pls_dont_age_out" would be the
differentiator for an issue that should have been solved elsewhere, as
it could lead to other problems of its own.

Basically we're designing around a workaround to a problem to which
we're turning a blind eye. These are my 2c.
