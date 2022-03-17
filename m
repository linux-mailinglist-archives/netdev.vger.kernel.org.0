Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E432F4DCDCA
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 19:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237542AbiCQSn2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 14:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237534AbiCQSn0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 14:43:26 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A249D21351F;
        Thu, 17 Mar 2022 11:42:08 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id p15so12605081ejc.7;
        Thu, 17 Mar 2022 11:42:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oXxajodOegFpu3qLtW7meKAMsmhaC7A4cIBe9jeyyy8=;
        b=T1CXfgoLZaxde5dXFF4LTNE2qLUFot42LriRrOoKQgCswwyNCHb6anbnIZ/6Gvsqb4
         vmwMIhiVo7o5dlgWLclkHWo/VuqWp19QoWTUmVOdLyIxFs2qubQmR/wJrqOAKwyizCL+
         GGzDyV6Y04zs11XcJL8FLm0IQ9NUA3LGAErmZxba7krGizP2TtvcI4V+tiiAnL/g+7W0
         d+8z/Secp8G0iFoukRBbcCkDVfxNZCfccCC9S8ASJzhefj5KjNmOHKTUnNxGoP4ngWZF
         r3cuM+OGw1wWW+5g6LlM+EWzfDWy9Hebr25O9RlbPEtwvSJuDR9VyCV6u6zY+YSfZRsA
         Nm7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oXxajodOegFpu3qLtW7meKAMsmhaC7A4cIBe9jeyyy8=;
        b=Pq+518DrjBvpisgbmB8BX2gm/2NV/YBAowaMRFWFCDqDpcnuvVZvNaJgmm2u/yQ/KQ
         ZhTNbvb+KzcfZaGiktxcVDH9Ysr23IGQCf9WHjzlFpcawbn0umrY982T6IswMybPHPkC
         GAIoeeC4AHU7XwsInYRk4NX/K0dk2GWTSNVdKHF8jbpFbdpUAZPNJCV7LYofGwW0EVkb
         iJWab+we3B4fOrGMty5w2X3kivS0qRbCajApdOiyBFh8nZoEK+KYVhLy+s5nUsy87Q2N
         IVno8VSllqUK6uiKJpRtdCE1Bxf/Cv2ME1Li1MmFvl+obeR7kft3ETEWKQUvi2rntSnj
         s/ww==
X-Gm-Message-State: AOAM530srT1KQPzcwCDBMjHErZDumb5LKJjHQzJGyxsfBuR8s+za7MX9
        SWGgJxG2vSC4L1jKnHimm/I=
X-Google-Smtp-Source: ABdhPJyI7FbCW2YhqjttBaWbUwZA3WvvirdR9td3755YlbQ0QHnT8pu0jP7DlVdmg4nQ31ePLujjcg==
X-Received: by 2002:a17:906:d54f:b0:6df:a9d8:cbaa with SMTP id cr15-20020a170906d54f00b006dfa9d8cbaamr1943701ejc.183.1647542526979;
        Thu, 17 Mar 2022 11:42:06 -0700 (PDT)
Received: from skbuf ([188.26.57.45])
        by smtp.gmail.com with ESMTPSA id w14-20020a170906d20e00b006cee22553f7sm2780238ejz.213.2022.03.17.11.42.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Mar 2022 11:42:06 -0700 (PDT)
Date:   Thu, 17 Mar 2022 20:42:04 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Hans Schultz <schultz.hans@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ido Schimmel <idosch@nvidia.com>, linux-kernel@vger.kernel.org,
        bridge@lists.linux-foundation.org
Subject: Re: [PATCH net-next 0/3] Extend locked port feature with FDB locked
 flag (MAC-Auth/MAB)
Message-ID: <20220317184204.wehqmziioscdz33t@skbuf>
References: <20220310142320.611738-1-schultz.hans+netdev@gmail.com>
 <f9b3ecf5-c2a4-3a7a-5d19-1dbeae5acb69@gmail.com>
 <86o825htih.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <86o825htih.fsf@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 17, 2022 at 09:29:10AM +0100, Hans Schultz wrote:
> On ons, mar 16, 2022 at 17:18, Florian Fainelli <f.fainelli@gmail.com> wrote:
> > On 3/10/2022 6:23 AM, Hans Schultz wrote:
> >> This patch set extends the locked port feature for devices
> >> that are behind a locked port, but do not have the ability to
> >> authorize themselves as a supplicant using IEEE 802.1X.
> >> Such devices can be printers, meters or anything related to
> >> fixed installations. Instead of 802.1X authorization, devices
> >> can get access based on their MAC addresses being whitelisted.
> >> 
> >> For an authorization daemon to detect that a device is trying
> >> to get access through a locked port, the bridge will add the
> >> MAC address of the device to the FDB with a locked flag to it.
> >> Thus the authorization daemon can catch the FDB add event and
> >> check if the MAC address is in the whitelist and if so replace
> >> the FDB entry without the locked flag enabled, and thus open
> >> the port for the device.
> >> 
> >> This feature is known as MAC-Auth or MAC Authentication Bypass
> >> (MAB) in Cisco terminology, where the full MAB concept involves
> >> additional Cisco infrastructure for authorization. There is no
> >> real authentication process, as the MAC address of the device
> >> is the only input the authorization daemon, in the general
> >> case, has to base the decision if to unlock the port or not.
> >> 
> >> With this patch set, an implementation of the offloaded case is
> >> supplied for the mv88e6xxx driver. When a packet ingresses on
> >> a locked port, an ATU miss violation event will occur. When
> >> handling such ATU miss violation interrupts, the MAC address of
> >> the device is added to the FDB with a zero destination port
> >> vector (DPV) and the MAC address is communicated through the
> >> switchdev layer to the bridge, so that a FDB entry with the
> >> locked flag enabled can be added.
> >
> > FWIW, we may have about a 30% - 70% split between switches that will 
> > signal ATU violations over a side band interrupt, like mv88e6xxx will, 
> > and the rest will likely signal such events via the proprietary tag
> > format.
> 
> I guess that the proprietary tag scheme a scenario where the packet can
> be forwarded to the bridge module's ingress queue on the respective
> port?

I'm not sure what you mean by forwarding to the bridge module's ingress
queue. I expect that both cases of drivers to interact with the bridge
in the exact same way, expect one of them calls call_switchdev_notifiers()
from an interrupt context, and the other from NET_RX softirq context,
from the tagging protocol driver (ok, maybe not directly, it depends
upon whether we need rtnl_lock which sleeps, things like that).

I might be just projecting based on what I know, but the way I interpret
what Florian has said is by thinking of "learn frames" as described here:
https://patchwork.kernel.org/project/netdevbpf/cover/20220209130538.533699-1-schultz.hans+netdev@gmail.com/#24734685
The advantage of signaling ATU misses or membership violations via learn
frames is that you have a much wider toolbox of mitigations for denial
of service. Instead of one ATU interrupt per packet, you have NAPI on
the DSA master, interrupt coalescing, policers on the DSA master, rate
limiting for learn frames in the switch...
