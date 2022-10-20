Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 909FB606BC7
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 00:57:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbiJTW5i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Oct 2022 18:57:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiJTW5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Oct 2022 18:57:37 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4AEA22E0D4;
        Thu, 20 Oct 2022 15:57:35 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id k2so3126022ejr.2;
        Thu, 20 Oct 2022 15:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JuxcgTkIRC5WG6rM4q/CSaRgfUH0Ti3MoOBIFAp7H8s=;
        b=XBJzFhduueKPu1ACZxmcj5cXRa0nb0p5dX8b6x8utN2F40sVgNnz2Vwo93T3WLnBcx
         Yx3WwrvmN9Nuh/q4vOjOu0pqXnDTWqYB4KV9B3sCwZOf7c8OCwjoNM/D1TNvmc045ZzX
         Poo3JVc6Gu+DF650q6sVaij7GSbGVXbKX5JW9xSnGo2M+EdB4pcsbE0152s/sylYv+Nc
         ALPztrqDuyQF/Ci2P4snXxWjZKRtHnNH3GhbYR/zFvz6RX+vOKF1y9KazvTME97oRexc
         94w80ZyNJO0Z5bBflaDs/V5ISm1JA/Dg+OYU7d/pyJvJYa/mJ0Vv6e7Q6YanX5FVgqB4
         eYew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JuxcgTkIRC5WG6rM4q/CSaRgfUH0Ti3MoOBIFAp7H8s=;
        b=4kUdMb+u2XRrHmLU+EuuqbCdyOLgAcdkFgOu3kjz+hT63LZn9HJN8JLgOG3m1fcFSs
         ciwI27DxgE7r3MPhcJz+0geVtmW/fyvjfnjkrQVm58QLC3D2cWNLikxhCxe6ijJJwwGc
         i4XoZtEffNkwbqSnazLDctBLW7pTyKVnAFUpfoGcPrH5pUqK/mpKJVIxzzVh4YwjB9C7
         E69LIXrT6zmbMcTGInfAnsdIadX7Jpt63bdJLCvOzkyF0N37QwxGwzWnE/Xw8Vjis6xs
         JCHveLz1vaXGEerP/VAldmnFM/xpr3YerlKqu4jOx7MKtnomlae6WrWIcDF6NOu/Nlnj
         vm0w==
X-Gm-Message-State: ACrzQf1Wqw1ZAfXF4phW1hSUJexp1pXGNAXHSk3DUKopWpm/KP2ag+s0
        toc0VvqFAQ4dydTSKuplXm7zQW6khpPfOQ==
X-Google-Smtp-Source: AMsMyM7/vnHFskrIzjNC7ybOEBIlorfKrTTq/Ou6mds57aeFaKcu+F9HahwfD0wuLF52vhDnh4xpcw==
X-Received: by 2002:a17:906:58cc:b0:78d:ce9c:3787 with SMTP id e12-20020a17090658cc00b0078dce9c3787mr12707611ejs.715.1666306643405;
        Thu, 20 Oct 2022 15:57:23 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id l6-20020a1709062a8600b0073d796a1043sm10750046eje.123.2022.10.20.15.57.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Oct 2022 15:57:22 -0700 (PDT)
Date:   Fri, 21 Oct 2022 01:57:19 +0300
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
Message-ID: <20221020225719.l5iw6vndmm7gvjo3@skbuf>
References: <20221018165619.134535-1-netdev@kapio-technology.com>
 <20221018165619.134535-1-netdev@kapio-technology.com>
 <20221018165619.134535-11-netdev@kapio-technology.com>
 <20221018165619.134535-11-netdev@kapio-technology.com>
 <20221020132538.reirrskemcjwih2m@skbuf>
 <2565c09bb95d69142522c3c3bcaa599e@kapio-technology.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2565c09bb95d69142522c3c3bcaa599e@kapio-technology.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 20, 2022 at 10:20:50PM +0200, netdev@kapio-technology.com wrote:
> In general locked ports block traffic from a host based on if there is a
> FDB entry or not. In the non-offloaded case, there is only CPU assisted
> learning, so the normal learning mechanism has to be disabled as any
> learned entry will open the port for the learned MAC,vlan.

Does it have to be that way? Why can't BR_LEARNING on a BR_PORT_LOCKED
cause the learned FDB entries to have BR_FDB_LOCKED, and everything
would be ok in that case (the port will not be opened for the learned
MAC/VLAN)?

> Thus learning is off for locked ports, which of course includes MAB.
> 
> So the 'learning' is based on authorizing MAC,vlan addresses, which
> is done by userspace daemons, e.g. hostapd or what could be called
> mabd.
