Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 271316BE9D1
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 14:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230482AbjCQNEm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 09:04:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230429AbjCQNEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 09:04:39 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A7FB79CE;
        Fri, 17 Mar 2023 06:04:38 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id w9so20150160edc.3;
        Fri, 17 Mar 2023 06:04:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679058277;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=MDptrWFTJ9nlAB7MR2bK/F3LXLjgeX5WKUg9YK5v7vg=;
        b=RLkBdquU4k+r2Agg15WtvIcYttF+lGfsQMyB0ObDWOZ3EjTuVZa1VOcH+5dIu/t8gc
         94e1l52RngNPa+zHS4t2tVxkItsmsGzplcH9ObLMH2wo81PfBu3wVcpSLT64BjDvQv1G
         Ng+jgfuwaOOdQWSbtvj7WFfXHlr+ZoJeX4vm1348hyfZ4od5L4RRJnwQUhOVfg3hxYsM
         8W/IUUkHJmhv75R+HOCscaPKiRF0prRj5v3hA9kss96pMG3i9r/gCg3x2yJd3EUTNeXL
         EWTWybP5LZZ6DQxxDbgewOW+uyR58RAKK8IuaURcU2dXSdjQ3KSSjvrHQX0ONobsxWEC
         aUTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679058277;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MDptrWFTJ9nlAB7MR2bK/F3LXLjgeX5WKUg9YK5v7vg=;
        b=gmXETtuFS0H1SU+GBkLfzN+bn9N/24J4HM9GMFrGrOJfrVGlJcggHZ4BBb2LeKKemf
         IdsspljTejV7/6CvGw0/RFo+cTeu1utgDnFNSdKp0glfbut3Pxf3o0MV9w446kgMaE+o
         udqgvlTuuODwoSJhH0zPWKaiqMi+/gmUvEfNsAqMC1IykFQgwqfEBdPG75saalmNMytt
         NYde0xBbAdI0glu5LLcZe5T12LRJKjqS/IVZFRuIZ92t4jPoHnegc9BLu5ADvUYbBiNp
         fiauxiKLNAsXY9JZDhLSzOD1e1maiC9lpOLoXSrc/cN058jR0Fp8FpLWQOswBYubmNLp
         NGHg==
X-Gm-Message-State: AO0yUKVTwUuwtMWs4AIAQJVXrO+SnWvFrmM1ciT07kWN2eEFX2bDX3NR
        ue5yx8m7YNTF48MeSigP2ba+VhGzvon/sw==
X-Google-Smtp-Source: AK7set/Y0wsY2hjPNFYS/dUzNssXbWl/DdqpxADK8i73RfOqfuF6qBEopzr5pektACboiAgAU5m+4A==
X-Received: by 2002:a17:906:6848:b0:931:6921:bdb7 with SMTP id a8-20020a170906684800b009316921bdb7mr3114648ejs.60.1679058276620;
        Fri, 17 Mar 2023 06:04:36 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id k8-20020a17090627c800b008d1693c212csm954800ejc.8.2023.03.17.06.04.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 06:04:36 -0700 (PDT)
Date:   Fri, 17 Mar 2023 15:04:34 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?w4FsdmFybyBGZXJuw6FuZGV6?= Rojas <noltari@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, f.fainelli@gmail.com,
        jonas.gorski@gmail.com, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] net: dsa: b53: mmap: register MDIO Mux bus controller
Message-ID: <20230317130434.7cbzk5gxx5guarcz@skbuf>
References: <20230317113427.302162-1-noltari@gmail.com>
 <20230317113427.302162-3-noltari@gmail.com>
 <20230317115115.s32r52rz3svuj4ed@skbuf>
 <CAKR-sGe3xHkN-1+aLn0ixnskctPK4GTzfXu8O_dkFhHyY1nTeg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKR-sGe3xHkN-1+aLn0ixnskctPK4GTzfXu8O_dkFhHyY1nTeg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 01:06:43PM +0100, Álvaro Fernández Rojas wrote:
> Hi Vladimir,
> 
> El vie, 17 mar 2023 a las 12:51, Vladimir Oltean (<olteanv@gmail.com>) escribió:
> >
> > On Fri, Mar 17, 2023 at 12:34:26PM +0100, Álvaro Fernández Rojas wrote:
> > > b53 MMAP devices have a MDIO Mux bus controller that must be registered after
> > > properly initializing the switch. If the MDIO Mux controller is registered
> > > from a separate driver and the device has an external switch present, it will
> > > cause a race condition which will hang the device.
> >
> > Could you describe the race in more details? Why does it hang the device?
> 
> I didn't perform a full analysis on the problem, but what I think is
> going on is that both b53 switches are probed and both of them fail
> due to the ethernet device not being probed yet.
> At some point, the internal switch is reset and not fully configured
> and the external switch is probed again, but since the internal switch
> isn't ready, the MDIO accesses for the external switch fail due to the
> internal switch not being ready and this hangs the device because the
> access to the external switch is done through the same registers from
> the internal switch.

The proposed solution is too radical for a problem that was not properly
characterized yet, so this patch set has my temporary NACK.

> But maybe Florian or Jonas can give some more details about the issue...

I think you also have the tools necessary to investigate this further.
We need to know what resource belonging to the switch is it that the
MDIO mux needs. Where is the earliest place you can add the call to
b53_mmap_mdiomux_init() such that your board works reliably? Note that
b53_switch_register() indirectly calls b53_setup(). By placing this
function where you have, the entirety of b53_setup() has finished
execution, and we don't know exactly what is it from there that is
needed.
