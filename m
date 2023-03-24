Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A5146C7EA0
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 14:19:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231993AbjCXNTi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 09:19:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjCXNTh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 09:19:37 -0400
X-Greylist: delayed 732 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 24 Mar 2023 06:19:35 PDT
Received: from mailout-taastrup.gigahost.dk (mailout-taastrup.gigahost.dk [46.183.139.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD6A12860;
        Fri, 24 Mar 2023 06:19:35 -0700 (PDT)
Received: from mailout.gigahost.dk (mailout.gigahost.dk [89.186.169.112])
        by mailout-taastrup.gigahost.dk (Postfix) with ESMTP id B303418837C2;
        Fri, 24 Mar 2023 13:07:21 +0000 (UTC)
Received: from smtp.gigahost.dk (smtp.gigahost.dk [89.186.169.109])
        by mailout.gigahost.dk (Postfix) with ESMTP id ACC3F2500B57;
        Fri, 24 Mar 2023 13:07:21 +0000 (UTC)
Received: by smtp.gigahost.dk (Postfix, from userid 1000)
        id A23749B403F4; Fri, 24 Mar 2023 13:07:21 +0000 (UTC)
X-Screener-Id: e32ae469fa6e394734d05373d3a705875723cf1e
Received: from fujitsu (2-104-116-184-cable.dk.customer.tdc.net [2.104.116.184])
        by smtp.gigahost.dk (Postfix) with ESMTPSA id B3AEB9B403E2;
        Fri, 24 Mar 2023 13:07:20 +0000 (UTC)
From:   Hans Schultz <netdev@kapio-technology.com>
To:     Ido Schimmel <idosch@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
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
        =?utf-8?Q?Cl=C3=A9ment_L=C3=A9ger?= <clement.leger@bootlin.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Shuah Khan <shuah@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
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
Subject: Re: [PATCH v2 net-next 1/6] net: bridge: add dynamic flag to
 switchdev notifier
In-Reply-To: <ZBgd1mgO36umXqoj@shredder>
References: <20230318141010.513424-1-netdev@kapio-technology.com>
 <20230318141010.513424-2-netdev@kapio-technology.com>
 <ZBgd1mgO36umXqoj@shredder>
Date:   Fri, 24 Mar 2023 14:04:45 +0100
Message-ID: <87h6ua5mhe.fsf@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-0.7 required=5.0 tests=RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 10:48, Ido Schimmel <idosch@nvidia.com> wrote:
>
> I was under the impression that the consensus was to rename this to
> 'is_static' so that it is consistent with other flags.
>

I think the consensus was that the bridge maintainers would decide if it
should be changed, this according to Oltean. I still think that
is_dyn is more secure codewise in the long run and it is logical as that
is what the feature the flag concerns.

When you say consistent with other flags, I don't understand the
inconsistency. Could you please explain.
