Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9CA8608D0A
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 13:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbiJVLzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 07:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiJVLzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 07:55:13 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3085757575;
        Sat, 22 Oct 2022 04:55:11 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id t16so15013681edd.2;
        Sat, 22 Oct 2022 04:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lb9/zjqYRw+NBkGo45ll85eULcpfPgNmAc+gmZ4GdK8=;
        b=Zn6DNUW7Q97y/Bj/MSIzEC49CS64UT31QlzoAD6wLkmrUxwL1opBKx7FXFWrSqbXaY
         Kr1KrFPsJ5JFxz0E1ldEufc0LNrVaS6CfxrDGIytU7fsPoRNSf7b8USeKEUhwUXCscFM
         a2eyfsGFdsJkoxvamtodBneDSb4qhyXHHlRu7IuxYnRTevp2bmD1yAVHZeigULn1T3uo
         SomsjVAH+PAFo+dUSfG7fdu4CcnjNb6zpwlwRsUS2LdACbuiopa+fiVo3Kp3Y0SXSwg0
         sJQXpsxD9lNfpN8JbakSleno2DDivomz9MFdYdzSmr8s6ium2N25Al1S20hCR2OOVz/t
         QzOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lb9/zjqYRw+NBkGo45ll85eULcpfPgNmAc+gmZ4GdK8=;
        b=ABuwE8rArrEVe/VMJI+B+/Y/6xkS5tbsBgqA+j927Rz890gVC2IwCsRUT11Jrzjr5X
         AHvloeh5tDHTLLlnLFKQi7KVSNrqpaqEurraORVbbyJOenOs5HzOcLIv1+ud/34/CZQ1
         BA1VJy6ndSYR5nPB7aMv8yFy5XPsh4LeWxWAE+qVb5dIRK5jE0t9KXRdv9rWgy0FHkg9
         wfd8zEVJJZYg54aUzmRZPrE6+uAeVnR4Yk4TmdOSbo/wxXe2Ok9qzOwnTIITNF8gKbdi
         /E3SsPkKt1kFt9gbKQMaGsASKf7M6OqJqHx5JjF0Kh1ZNHY/MV/gpNG+yI0PF/94ipl4
         H86g==
X-Gm-Message-State: ACrzQf3Hx9ZAQS+hKAC5FETHC8HPGVZL/9cVHIlZVXfdmlwjYPdRzA3R
        kK34YM5dJdf0kzgTCre6g4U=
X-Google-Smtp-Source: AMsMyM5sZekC9ebEG4UlcVJhjIzJk4B8pbY2EdSY2DXkIQxcMmosxQTI6bWhf1D8BYOHHlCeocAkpw==
X-Received: by 2002:a05:6402:1cca:b0:460:7d72:8f2 with SMTP id ds10-20020a0564021cca00b004607d7208f2mr12435625edb.205.1666439709061;
        Sat, 22 Oct 2022 04:55:09 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id fd13-20020a056402388d00b0045b3853c4b7sm14906421edb.51.2022.10.22.04.55.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Oct 2022 04:55:08 -0700 (PDT)
Date:   Sat, 22 Oct 2022 14:55:05 +0300
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
Message-ID: <20221022115505.nlnkfy2xrgrq74li@skbuf>
References: <20221018165619.134535-1-netdev@kapio-technology.com>
 <20221018165619.134535-1-netdev@kapio-technology.com>
 <20221018165619.134535-11-netdev@kapio-technology.com>
 <20221018165619.134535-11-netdev@kapio-technology.com>
 <20221020132538.reirrskemcjwih2m@skbuf>
 <a0269818b270ad0537b991bd98725260@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a0269818b270ad0537b991bd98725260@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 22, 2022 at 09:31:06AM +0200, netdev@kapio-technology.com wrote:
> But I think it should be so that turning MAB off will clear the ALE entries
> regardless, as the port can continue to be locked and needing port association,
> or you want them to just age out normally in that case, thus lingering for
> up to bridge ageing time?

Even without BR_PORT_LOCKED, I find it normal that dynamically learned
FDB entries are forcefully aged out when BR_LEARNING is turned off,
instead of lingering on until they expire.

This does not happen in the software bridge, and I did not understand
why (I suspected some backwards compatibility reasons), and for this
reason, it is only from within DSA that we are forcing this behavior to
take place. In dsa_port_bridge_flags(), when BR_LEARNING is turned off,
we call dsa_port_fast_age() which also calls SWITCHDEV_FDB_FLUSH_TO_BRIDGE
(and this clears the bridge software FDB of dynamically learned entries).

I very much expect the same thing with MAB and BR_FDB_LOCKED entries,
that they go away when the BR_PORT_MAB/BR_LEARNING flag (whichever way
we call it) is unset.

Now, if the bridge should initiate the flushing, or still DSA, is
perhaps a topic for further discussion. Given that BR_FDB_LOCKED entries
are new, maybe the bridge could do it in this case (no backwards
compatibility to handle).

Currently the DSA logic mentioned above is bypassed, because we treat
MAB and autonomous learning differently. If we accepted that MAB is
still a form of learning (managed through BR_LEARNING+BR_PORT_LOCKED),
then the DSA logic would kick in, and both the software bridge and the
hardware driver would have a hook to clean up the BR_FDB_LOCKED entries,
plus anything else that is dynamic. The DSA logic would also kick in if
we treated BR_PORT_MAB within DSA like BR_LEARNING, which basically
amounts to the same thing, except for the confusing (IMO) UAPI of having
a flag (BR_PORT_MAB) which is basically a form of learning that isn't
controlled by the BR_LEARNING flag (which is undefined and unclear if it
should be set or not, in BR_PORT_LOCKED mode).
