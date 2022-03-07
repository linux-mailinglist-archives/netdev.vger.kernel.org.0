Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1402A4CF4F1
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 10:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236633AbiCGJYP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 04:24:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236955AbiCGJXP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 04:23:15 -0500
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C58D066221
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 01:21:31 -0800 (PST)
Received: by mail-lf1-x144.google.com with SMTP id w12so692698lfr.9
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 01:21:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=LRL2ZklcfoQy6V+AXnyP/czeM9Axh+L6lI6RHt3ACyE=;
        b=nJFt7W3R1BeqeKXTKd31Xnh5G+4Pmfa4yLwa8ZQRRDiEglFJX9OVXcuLctvvtlS2on
         N4udubjwgQh2RtXBMmmvsWoOs9Fi+YNiLCDmlqJqpHEFtbBErgBKIrRHIx55Z93nM0IA
         2ArA6jJo6iGkwkm6z/Y63gU+W+BR1thdoK5/fEQYTmvRh9D9Rorol4PPMKToelJkXcgv
         kaQzZvrH7lSbXwBYeOzyGDhsI7zaXWGbDitl+t5TnNCLgbExkCqNHdYMdiDEARCttJUV
         zhzDElspBqslZJMXmBDU5cxkFT3J/S33BGXTMe2P5Sjzddy6XwO+mLmxFw/I2BD+WCvD
         i0PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=LRL2ZklcfoQy6V+AXnyP/czeM9Axh+L6lI6RHt3ACyE=;
        b=VFOfmZ6lr/Rrl8Nluppk2MdyWJFZbUm5guVXWJwT0OxwbysT1TClSOoH21HSSgQIQS
         jHP7Wn26OrRAJDoE6Y7cg5FycIynmhXOzOK7G8j6POK/XlNT5WTXm+vtEMlUzl+nsVSk
         9qYmsG7pG4/Ky95KC4x4SbOiUVRXn8whHh3bUsGu6dlmzAXHz+ovbUg+Y0mfJ+MaHogj
         tEMia3D0bQzW6qxaNiNoIwEjf+Mur50l/a0KnxURDZbdqdCAvF25NwrggDxwriAlc9xs
         t+wLjpFWzGs0cAk63O0y6FkOhEaY1v10r2qFXWsC+UmLiDLgUNIdmKuwyAa+uB5y4IZF
         frgg==
X-Gm-Message-State: AOAM531trywySleLFG0w5VWQQrlechqgYoWP46/qQvpv86execSMarGa
        Ug9ydNLl5CQioLMO08qhPCazo5ljztmmkTbUMMQ=
X-Google-Smtp-Source: ABdhPJyQBR1xWyk9mY9a/Jzq6/QIlvy0OfID8m9+ExpqC4tSuHvevGMTYWSKtgoHEWpKM+HJqq+qOQ==
X-Received: by 2002:a05:6512:10cd:b0:448:224f:ee55 with SMTP id k13-20020a05651210cd00b00448224fee55mr6773620lfg.87.1646644890054;
        Mon, 07 Mar 2022 01:21:30 -0800 (PST)
Received: from wkz-x280 (a124.broadband3.quicknet.se. [46.17.184.124])
        by smtp.gmail.com with ESMTPSA id g4-20020a19ac04000000b00443a532746asm2758460lfc.288.2022.03.07.01.21.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 01:21:29 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        emeric.dupont@zii.aero
Subject: Re: Regression with improved multi chip isolation
In-Reply-To: <YiUIQupDTGwgHE4K@lunn.ch>
References: <YiUIQupDTGwgHE4K@lunn.ch>
Date:   Mon, 07 Mar 2022 10:21:28 +0100
Message-ID: <87cziynmnb.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 06, 2022 at 20:15, Andrew Lunn <andrew@lunn.ch> wrote:
> Hi Tobias
>
> I just found a regression with:
>
> d352b20f4174a6bd998992329b773ab513232880 is the first bad commit
> commit d352b20f4174a6bd998992329b773ab513232880
> Author: Tobias Waldekranz <tobias@waldekranz.com>
> Date:   Thu Feb 3 11:16:56 2022 +0100
>
>     net: dsa: mv88e6xxx: Improve multichip isolation of standalone ports
>     
>     Given that standalone ports are now configured to bypass the ATU and
>     forward all frames towards the upstream port, extend the ATU bypass to
>     multichip systems.

Sorry about that.

> I have a ZII devel B setup:
>
> brctl addbr br0                                                                 
> brctl addif br0 lan0                                                            
> brctl addif br0 lan1                                                            
>                                                                                 
> ip link set br0 up                                                              
> ip link set lan0 up                                                             
> ip link set lan1 up                                                             
>                                                                                 
> ip link add link br0 name br0.11 type vlan id 11                                
> ip link set br0.11 up                                                           
> ip addr add 10.42.11.1/24 dev br0.11
>
> Has it happens, lan0 has link, and i run tcpdump on the link peer. lan1
> does not have link.
>
> I then ping 10.42.11.2.
>
> I found that the ARP Request who-has 10.42.11.2 tell 10.42.11.1 are
> getting dropped. I also see:
>
>      p06_sw_in_filtered: 122
>      p06_sw_out_filtered: 90
>      p06_atu_member_violation: 0
>      p06_atu_miss_violation: 0
>      p06_atu_full_violation: 0
>      p06_vtu_member_violation: 0
>      p06_vtu_miss_violation: 121
>
> port 6 is the CPU port. Both p06_vtu_miss_violation and
> p06_sw_in_filtered are incrementing with each ARP Request broadcast
> from the host.
>
> The bridge should be vlan unaware, vlan_filtering is 0.

Huh, a VLAN upper without filtering enabled; didn't consider that
use-case...

Vladimir has already correctly diagnosed the problem. I'm working on a
fix right now, which I aim to send later today.
