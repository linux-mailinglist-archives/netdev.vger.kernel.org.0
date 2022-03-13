Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FBB44D7573
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 14:32:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232755AbiCMNdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 09:33:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229691AbiCMNdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 09:33:40 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 742F018887D
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 06:32:32 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id kt27so28739941ejb.0
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 06:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=ZxCfoc657oWnTG/B5MQBWW1lEpYUV1DF7imMaef10wk=;
        b=hkPCE9bqL/ux5oRqKlngv6w4mBt8lOr7gwLojlG5XTaWAh5g3adFxLkduGGI+eeFRa
         gO65p8tHffm/KmyADLMHgHdx87GjFejVElLnscP8I5voPv3n/3enj94tP7GB2jUU6idA
         jxDzTkOkSL6rlzeVXTssf+H4h4BswS95uFLqKcXvavBMV89c2TmxcT15+IZcddI5VqZ8
         7P02fdWDWREQab86VZK/vpvdcmQCSWmJe81t1WRZnPDqL+87B1vLOhr616rd1VwEsEzE
         P5Ms1uUGOMKiKtacGbWupCBECmw5abiHsL1FA59T+hysFseEVGaFDnChpy8pH/CasCl3
         XL2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=ZxCfoc657oWnTG/B5MQBWW1lEpYUV1DF7imMaef10wk=;
        b=7CqQp8W7cPS8NCr259rBrEdS0tIKZH7/lTyVF0hmUQXEYx7BMmG9ZvX7gfmypvOo6u
         GjqJpr+9lCvVbnNGXJMBqB3OkmmgeZ+UrivanmIOZVF7BrLlmfHZed3rWct9OxXqjG/G
         0wMx0KSVlYdAtnb258icRqibbBSePfgaIs/N+EO1lHIFAx9qQWxsj5APW1YdkQXT7ggK
         nRn0oJfhWAeeYVzdsw9SVGHjj+MTHjFZdZtj6QIlRwziM0UhzteP7YqoKGdVS/X0AZTp
         AqxZ49OLlKj0ZCwaTzR+GqP/8mvvVT2ZZentIQ/HiKDtfKwV1AOMvSNJukZcbHOJw/I1
         Ep0g==
X-Gm-Message-State: AOAM530q3OArNfe3gjwkCAPQcXKnHWWdGUzNdYb087mU8TPX+4qh7SEs
        56a6Hv65W5xXXqSZ/2uyWng=
X-Google-Smtp-Source: ABdhPJyjSxkrZcmPs2RTZCXsAOfZyB5HwOKmtOn3dQKJdbtCzeeK1vcYFi1vhV7WzBJfG2Q2upvTAw==
X-Received: by 2002:a17:906:a20c:b0:6ce:a87e:5013 with SMTP id r12-20020a170906a20c00b006cea87e5013mr15008626ejy.379.1647178350754;
        Sun, 13 Mar 2022 06:32:30 -0700 (PDT)
Received: from skbuf ([188.25.231.156])
        by smtp.gmail.com with ESMTPSA id y19-20020a1709064b1300b006dabe44a6edsm5560599eju.141.2022.03.13.06.32.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Mar 2022 06:32:30 -0700 (PDT)
Date:   Sun, 13 Mar 2022 15:32:28 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>, erkin.bozoglu@xeront.com,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Isolating DSA Slave Interfaces on a Bridge with Bridge Offloading
Message-ID: <20220313133228.iff4tbkod7fmjgqn@skbuf>
References: <7c046a25-1f84-5dc6-02ad-63cb70fbe0ec@arinc9.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7c046a25-1f84-5dc6-02ad-63cb70fbe0ec@arinc9.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Arınç,

On Sun, Mar 13, 2022 at 02:23:47PM +0300, Arınç ÜNAL wrote:
> Hi all,
> 
> The company I work with has got a product with a Mediatek MT7530 switch.
> They want to offer isolation for the switch ports on a bridge. I have run a
> test on a slightly modified 5.17-rc1 kernel. These commands below should
> prevent communication between the two interfaces:
> 
> bridge link set dev sw0p4 isolated on
> 
> bridge link set dev sw0p3 isolated on
> 
> However, computers connected to each of these ports can still communicate
> with each other. Bridge TX forwarding offload is implemented on the MT7530
> DSA driver.
> 
> What I understand is isolation works on the software and because of the
> bridge offloading feature, the frames never reach the CPU where we can block
> it.
> 
> Two solutions I can think of:
> 
> - Disable bridge offloading when isolation is enabled on a DSA slave
> interface. Not the best solution but seems easy to implement.
> 
> - When isolation is enabled on a DSA slave interface, do not mirror the
> related FDB entries to the switch hardware so we can keep the bridge
> offloading feature for other ports.
> 
> I suppose this could only be achieved on switch specific DSA drivers so the
> implementation would differ by each driver.
> 
> Cheers.
> Arınç

To be clear, are you talking about a patched or unpatched upstream
kernel? Because mt7530 doesn't implement bridge TX forwarding offload.
This can be seen because it is missing the "*tx_fwd_offload = true;"
line from its ->port_bridge_join handler (of course, not only that).

You are probably confused as to why is the BR_ISOLATED brport flag is
not rejected by a switchdev interface when it will only lead to
incorrect behavior.

In fact we've had this discussion with Qingfang, who sent this patch to
allow switchdev drivers to *at the very least* reject the flag, but
didn't want to write up a correct commit description for the change:
https://lore.kernel.org/all/CALW65jbotyW0MSOd-bd1TH_mkiBWhhRCQ29jgn+d12rXdj2pZA@mail.gmail.com/T/
https://patchwork.kernel.org/project/netdevbpf/patch/20210811135247.1703496-1-dqfext@gmail.com/
https://patchwork.kernel.org/project/netdevbpf/patch/20210812142213.2251697-1-dqfext@gmail.com/

As a result, currently not even the correctness issue has still not yet
been fixed, let alone having any driver act upon the feature correctly.

In my opinion, it isn't mandatory that bridge ports with BR_ISOLATED
have forwarding handled in software. All that needs to change is that
their forwarding domain, as managed by the ->port_bridge_join and
->port_bridge_leave callbacks, is further restricted. Isolated ports can
forward only to non-isolated ports, and non-isolated ports cannot
forward to isolated ports. Things may become more interesting with
bridge TX forwarding offload though, but as I mentioned, at least
upstream this isn't a concern for mt7530 (yet).
