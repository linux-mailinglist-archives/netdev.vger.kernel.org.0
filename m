Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC46513833
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 17:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233115AbiD1PZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 11:25:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiD1PZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 11:25:51 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95B3EB6E4D;
        Thu, 28 Apr 2022 08:22:36 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id k23so10278392ejd.3;
        Thu, 28 Apr 2022 08:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7YLVxUVhlKxUfzG1M4jUZxPjD2idjPgG5R3HbRqz7BE=;
        b=flY61dKF+V3AO9rinFt1f0RtFEOiSI3HLHDd8pYo7Tc5Cdv7pdTVy1MFtTvbLmemU0
         njqsyIVOEHyj0Q68iR5jy/FYSAGIbWnU/rNIe5WlhjVPbyyLaYz9DnBhA+23VZ5eQs7U
         5Gm3Tv7m8SVGoU8A6EpJMthOY6vvKugP++q+DgGI8THJiqZXn1OGqg8y6zCvl/RZiSkW
         iAu26+/wpHy9DRWlG2WvT49YH/vyDAwEcoqEPGNRCJXTYY76VjOy0RVxfTtOwektP76Q
         dB+KErukFoHcQ7Zm3t6nDyRiqbAn1Vq9T6bG18K4heIgLTEHYbt8PILAu76pKTGNe3/A
         Iq4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7YLVxUVhlKxUfzG1M4jUZxPjD2idjPgG5R3HbRqz7BE=;
        b=OVjSD8y5a9pvJRY2BXTQ5Uq4FSoIVS+v3azJYlVxyABpQBMuCzPbl8Lb+SlUO7/T19
         lPsPipyiVTgzDiQswMQjhkxFLmg2bjr7Kh9V287pbIrzDtbDyG3ydqWNzKnrNTQhQNzR
         Or+x2gpUTEmbRU+8Zle7+kyyD2Sy3SeQFWpRmb6EAk1GQwnyzVORJ35a5F3x3zbo8znF
         ySKmCIDbL7vAqjoSsePn+dCuT4GZ9U26eeZ6r8Ihf7+UbVAhLaqooTAuwjloiqmacd/q
         qNXkWRdiZqroxVJVG7c/R5riCGgIjisSfMIzOZgnxZplqzui3WbtvgiXYswINRjIUk2a
         QArg==
X-Gm-Message-State: AOAM531vRZahX5xxJoeeYg9SJRC1qVbr6SIB+LSxByCLPUbSk8Iad1nF
        i55U0CsNNaIwIgFyRNXZZIA=
X-Google-Smtp-Source: ABdhPJxG7zOPTw8R+SujDQ7pi73M/dKgb6TPBpGNXMmc1X/UwWzB7VxMNKpM37LbyEQKRpIDeHh8kw==
X-Received: by 2002:a17:907:6e9e:b0:6f3:c3d6:a2e0 with SMTP id sh30-20020a1709076e9e00b006f3c3d6a2e0mr9605770ejc.187.1651159355161;
        Thu, 28 Apr 2022 08:22:35 -0700 (PDT)
Received: from skbuf ([188.25.160.86])
        by smtp.gmail.com with ESMTPSA id u4-20020a170906780400b006ce69ff6050sm107886ejm.69.2022.04.28.08.22.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Apr 2022 08:22:34 -0700 (PDT)
Date:   Thu, 28 Apr 2022 18:22:33 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun.Ramadoss@microchip.com
Cc:     andrew@lunn.ch, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, Woojung.Huh@microchip.com,
        davem@davemloft.net
Subject: Re: [RFC patch net-next 3/3] net: dsa: ksz: moved ksz9477 port
 mirror to ksz_common.c
Message-ID: <20220428152233.tqzbdrqqgydilncw@skbuf>
References: <20220427162343.18092-1-arun.ramadoss@microchip.com>
 <20220427162343.18092-4-arun.ramadoss@microchip.com>
 <20220427165722.vwruo5q63stahkby@skbuf>
 <a6760b49fae3df27d2b337f5212a3f967a015064.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6760b49fae3df27d2b337f5212a3f967a015064.camel@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 28, 2022 at 03:09:50PM +0000, Arun.Ramadoss@microchip.com wrote:
> > > +#define
> > > P_MIRROR_CTRL                        REG_PORT_MRI_MIRROR_CTRL
> > > +
> > > +#define S_MIRROR_CTRL                        REG_SW_MRI_CTRL_0
> > 
> > Small comment: if P_MIRROR_CTRL and S_MIRROR_CTRL are expected to be
> > at
> > the same register offset for all switch families, why is there a
> > macro
> > behind a macro for their addresses?
> 
> ksz8795 and ksz9477 have different address/register for the
> Mirror_ctrl. To make it common for the both, P_MIRROR_CTRL is defined
> in ksz8795_reg.h and ksz9477_reg.h file.
> I just carried forward to ksz_reg.h.

So if P_MIRROR_CTRL has different values for ksz9477 and ksz8795, how
exactly do you plan to mask that difference away through the C preprocessor
at the level of ksz_reg.h included by ksz_common.c, depending on which
switch driver calls ksz_port_mirror_add()?

This can't work, you need to provide the offset of P_MIRROR_CTRL as
argument to the common function. What am I missing?
