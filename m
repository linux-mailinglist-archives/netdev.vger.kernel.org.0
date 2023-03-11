Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 003F26B5F87
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 19:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230389AbjCKSGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 13:06:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230351AbjCKSGr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 13:06:47 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23E9C5B5C9;
        Sat, 11 Mar 2023 10:06:44 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id y4so3759631edo.2;
        Sat, 11 Mar 2023 10:06:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678558002;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=V5tCnOE8V9Mv8kxB/NSSWI+pDp+rSPMb9cOqmvzQPGs=;
        b=gsGm9NK+L0gpC7wfbH3w2/sKAUxreZDtcIBw1whoblX/6cVTpaS4ZZmoYxynMPl98E
         CIMdw/yCMaIx9RdGYnSbet7/EVfb5f/i/GGBCw4d71lPFgwd4+nTSY1wyeiqkWfaqbra
         c8RFgkjfmCNAfZ98TtvT9zTxeXtl2LUf8REWzyoIjdMLzZyZQLCEdhRfm7t/x/F1quA6
         vLHTPyi3XWVwSQI6GKE2CGK5BNlVRAyCGGAYrNvMpLMv6FV9OfLFEnYzJMugdiX6BsBc
         Nx+GIl6pMecbLD+aFenXRGmnhWXGZIHm0UU645zfbV8dr8Oh3EgkbsBA+yhekw8ZnriB
         uOdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678558002;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V5tCnOE8V9Mv8kxB/NSSWI+pDp+rSPMb9cOqmvzQPGs=;
        b=CSmMrPTh1I6keu/n0oQjmYTzxYJPehdvpr2mbpX86JTzNEfLbFry3BjlR6lWOEvZcy
         gzHAHUBLGTAyI/5KgxKJjf9PZeM6sgEoRgGMlvHf2ITkv+UqHhbxIrARwXI+MjMYP0SU
         WSB4rgrXHDOrLQwH4+UmdiwTVVshzzYJXpO7/0mfvpk9ThA1I4mfwvfmu+rJ11x+mmk5
         0yYX25IgB4SLiKjnrR+i6XzR46ifhXS7Gy9yXJDyRgEc1Y87lYK528O9/VWEdhAssbMO
         ioRIQvqnuCU97qf9i1Oqr3O1JNgUZcjBuJjaXxwwTLo2t9VEuGD2abcvUoam9ti0NpRD
         qWcw==
X-Gm-Message-State: AO0yUKURjWzniEybxRQzm232d5ImP2FdMg2m6GlAnEVs0p3+wNZC3k/Q
        n6Yu0bEL+8mqtZKscR42pRIUQiqePV8=
X-Google-Smtp-Source: AK7set8iwhpIf7XplIXhjgdDv83ArykSsX4FBTKteCXNwcWOVbGm94V5S665SSzZGms4xRV+MezDGA==
X-Received: by 2002:a17:906:b04e:b0:89e:8c3d:bb87 with SMTP id bj14-20020a170906b04e00b0089e8c3dbb87mr32205101ejb.71.1678558002449;
        Sat, 11 Mar 2023 10:06:42 -0800 (PST)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id lf17-20020a170907175100b008db605598b9sm1330914ejc.67.2023.03.11.10.06.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 10:06:42 -0800 (PST)
Date:   Sat, 11 Mar 2023 20:06:40 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Klaus Kudielka <klaus.kudielka@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Richard Cochran <richardcochran@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: dsa: mv88e6xxx: move call to
 mv88e6xxx_mdios_register()
Message-ID: <20230311180640.cmvczi7jncbll56e@skbuf>
References: <20230311094141.34578-1-klaus.kudielka@gmail.com>
 <20230311094141.34578-2-klaus.kudielka@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230311094141.34578-2-klaus.kudielka@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 11, 2023 at 10:41:41AM +0100, Klaus Kudielka wrote:
> From commit 1a136ca2e089 ("net: mdio: scan bus based on bus capabilities
> for C22 and C45") onwards, mdiobus_scan_bus_c45() is being called on buses
> with MDIOBUS_NO_CAP. On a Turris Omnia (Armada 385, 88E6176 switch), this
> causes a significant increase of boot time, from 1.6 seconds, to 6.3
> seconds. The boot time stated here is until start of /init.
> 
> Further testing revealed that the C45 scan is indeed expensive (around
> 2.7 seconds, due to a huge number of bus transactions), and called twice.
> 
> It was suggested, to call mv88e6xxx_mdios_register() at the beginning of
> mv88e6xxx_setup(), and mv88e6xxx_mdios_unregister() at the end of
> mv88e6xxx_teardown(). This is accomplished by this patch.
> 
> Testing on the Turris Omnia revealed, that this improves the situation.
> Now mdiobus_scan_bus_c45() is called only once, ending up in a boot time
> of 4.3 seconds.
> 
> Link: https://lore.kernel.org/lkml/449bde236c08d5ab5e54abd73b645d8b29955894.camel@gmail.com/
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Tested-by: Klaus Kudielka <klaus.kudielka@gmail.com>
> Signed-off-by: Klaus Kudielka <klaus.kudielka@gmail.com>
> ---

No objection to the change. However you might want to bundle it up with
another patch for the phy_mask restriction, and resend the series using
Andrew's indications.
