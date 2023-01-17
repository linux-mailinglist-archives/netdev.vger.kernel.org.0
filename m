Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEBEF66E3AB
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 17:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232266AbjAQQfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 11:35:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232523AbjAQQfE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 11:35:04 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5D0640BC9;
        Tue, 17 Jan 2023 08:34:58 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id tz11so12268880ejc.0;
        Tue, 17 Jan 2023 08:34:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Qe6RxtFMgOj3bRq8rDugBk3dzDUP6KRit4SBct3uCQU=;
        b=ZeAZQLAxglvNrRPh2JtfeaDM20pmym07ZKLZidBL7nlMD7d97j5A1g+iqZwob1ifh7
         i3+HaU8qrQuQt+EoG4BoR0NH6HXo8jx0GdoOHmb8S+dHIC8yuqg5kI3AGl8ktu1Ohu0O
         dn2u+zKsCZyqo7G9xQyX9bhNgNcK7ZvBlIBfMqFUk4AnmvmbRbj5kUTYdrg9HQHfdozD
         OFEz5JrYbwkMt5LLOYCIxwp4iL4vc39Z6Bx0WsmlJCwIPYjYfO9FmbTlNItXbu2mR++M
         DOVqPRYrue1DvJphBHylmK0APmUiBojTkbeLV62ONeZa3Sb8xnYUSDEkoXl/rv62M1mB
         06aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Qe6RxtFMgOj3bRq8rDugBk3dzDUP6KRit4SBct3uCQU=;
        b=5C2eYFLLRJ8IVePhCFjU0WxNcH4VyuM/h+MZzVgPuBxlv5421jCGwlSP+7kZCnYtdc
         is/4MBxQ9tEguPpBX8RALjOlD8jhvsUBTJKhE+LvlQew+QbBb9Ve+XAy5cPILCRSYnZN
         aL3Hf6/lNfNEVaokJBi9n/tLvBIl58oT9fstgHPpr7VD9otWooA8QFEOulyxqK08PeNi
         E+YWUhIhT3GP2DI5rrg88B8OGugE5eg65oFAamN/z288nEoBbXYtUyJPk0gL/5BoEIAL
         XNPEolq35MqAKxVsp8mFXAZ0hqTT+MCeRiYfK1vL2dGSUOJhQZRVxEim/QzwqeF848tv
         FL0w==
X-Gm-Message-State: AFqh2kqT1QCUMFVuVV30GvmXnYPgMm1ftbItj1faJftkdN+4cV7y9loY
        v0AiyPpxO4GAoAgJFVV6VR8=
X-Google-Smtp-Source: AMrXdXs4/slisBfscth/7jRP56KRh3W779krulsU4g+R5ywkvNSjw2+RVJ8k+nZyhgQtOYwGPgrVQA==
X-Received: by 2002:a17:906:8c3:b0:7c4:f6e4:3e92 with SMTP id o3-20020a17090608c300b007c4f6e43e92mr16741876eje.31.1673973297179;
        Tue, 17 Jan 2023 08:34:57 -0800 (PST)
Received: from skbuf ([188.27.184.249])
        by smtp.gmail.com with ESMTPSA id p3-20020a056402500300b00488abbbadb3sm13005064eda.63.2023.01.17.08.34.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 08:34:56 -0800 (PST)
Date:   Tue, 17 Jan 2023 18:34:53 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marcin Wojtas <mw@semihalf.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org,
        andriy.shevchenko@linux.intel.com, sean.wang@mediatek.com,
        Landen.Chao@mediatek.com, linus.walleij@linaro.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, hkallweit1@gmail.com, jaz@semihalf.com,
        tn@semihalf.com, Samer.El-Haj-Mahmoud@arm.com
Subject: Re: [net-next: PATCH v4 2/8] net: mdio: switch fixed-link PHYs API
 to fwnode_
Message-ID: <20230117163453.o7pv7cdvgeobne4b@skbuf>
References: <20230116173420.1278704-1-mw@semihalf.com>
 <20230116173420.1278704-3-mw@semihalf.com>
 <Y8WOVVnFInEoXLVX@shell.armlinux.org.uk>
 <20230116181618.2iz54jywj7rqzygu@skbuf>
 <Y8XJ3WoP+YKCjTlF@lunn.ch>
 <CAPv3WKc8gfBb7BDf5kwyPCNRxmS_H8AgQKRitbsqvL7ihbP1DA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPv3WKc8gfBb7BDf5kwyPCNRxmS_H8AgQKRitbsqvL7ihbP1DA@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 17, 2023 at 05:05:53PM +0100, Marcin Wojtas wrote:
> In the past couple of years, a number of subsystems have migrated to a
> more generic HW description abstraction (e.g. a big chunk of network,
> pinctrl, gpio). ACPI aside, with this patchset one can even try to
> describe the switch topology with the swnode (I haven't tried that
> though). I fully agree that there should be no 0-day baggage in the
> DSA ACPI binding (FYI the more fwnode- version of the
> dsa_shared_port_validate_of() cought one issue in the WIP ACPI
> description in my setup). On the other hand, I find fwnode_/device_
> APIs really helpful for most of the cases - ACPI/OF/swnode differences
> can be hidden to a generic layer and the need of maintaining separate
> code paths related to the hardware description on the driver/subsystem
> level is minimized. An example could be found in v1 of this series,
> the last 4 patches in [1] show that it can be done in a simple /
> seamless way, especially given the ACPI (fwnode) PHY description in
> phylink is already settled and widely used. I am aware at the end of
> the day, after final review all this can be more complex.
> 
> I expect that the actual DSA ACPI support acceptance will require a
> lot of discussions and decisions, on whether certain solutions are
> worth migrating from OF world or require spec modification. For now my
> goal was to migrate to a more generic HW description API, and so to
> allow possible follow-up ACPI-related modifications, and additions to
> be extracted and better tracked.

I have a simple question.

If you expect that the DSA ACPI bindings will require a lot of
discussions, then how do you know that what you convert to fwnode now
will be needed later, and why do you insist to mechanically convert
everything to fwnode without having that discussion first?

You see the lack of a need to maintain separate code paths between OF
and ACPI as useful. Yet the DSA maintainers don't, and in some cases
this is specifically what they want to avoid. So a mechanical conversion
will end up making absolutely no progress.
