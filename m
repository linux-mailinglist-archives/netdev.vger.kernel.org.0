Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13E4F60E9E3
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 22:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234018AbiJZUH6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 16:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234828AbiJZUHk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 16:07:40 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E371613332A;
        Wed, 26 Oct 2022 13:07:34 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id b12so43511123edd.6;
        Wed, 26 Oct 2022 13:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=SMe4ztje59yCgYCGVuiDIj/z3i7JsmR1qOmIgpndbO0=;
        b=P8SRkqp6J2kS9c6yqxbdaEGejFc1UkHRd5VKkpWFuxTonKGK/AWQSH5tjDtlBvZUbv
         49dn3GZYrRB9iuoJhzQLcrKrVUXsj/k8DmZAvJaDQm4JkLrX0kXt98OM8SI8Kxcl6RQe
         TyFculnQAaC7xKxSpkj5wos+xsi1eBM0GwYxfdeiPnSvuDq4aazqVaAw9peM6GgGaTye
         xTNQ/hzCZHVMi5NS4if74U8kqUdjsPMQqF38zzz+JOF19q9W2myoHgRDm/5sRzWrZxgU
         QV1dBlfHwKrqlHCLXYNGCQHPCZ02RsAveb6/oXGvv/E7UhIy8oL/cZR+V3b8iEqaPfSZ
         mzqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SMe4ztje59yCgYCGVuiDIj/z3i7JsmR1qOmIgpndbO0=;
        b=wwhSnNfSuYdOVvFLcIBnAaJf8Ul5sgLzEYdpznvJQSLLjtm17hT47+02ElDSa8ubwo
         UHEfWJtkVLs5vDJ/QUV1qr71qHSpzokeyvOcD+BPdgIFwXWxHG6L2Q2FfTFRYNmeozAG
         YBg8lNskrcjJWt7G38aYcPmaa/CJRzLLneyrqjqZumR/B2YlEyqGmQxi3RMpokNGXxVk
         srz01L4PXeDbyU9Y77Y0dD0o89ihbwEMkGNhikdh/6CqUzoxrRsimUh3FBOBNmqK2EUK
         kDm/sKbOecc37z52M5Am06pom0AqkLeTQBti08qkHZMluk2p86F31MeHOm3kIbjywc4h
         YNFw==
X-Gm-Message-State: ACrzQf1q+r/T0xzP0SkAWwlTbjOw0Xrd291qwAUMh8O62lOy3k4ZbIK4
        +ekUwro293WIqxbjZpNFfEs=
X-Google-Smtp-Source: AMsMyM4OXkYCOQgAPOhMmMMEOl9fW/cznVnimULGHVkhPK0Bj2s2CUq64sqHEGr1YOe6DJAhzxjSDQ==
X-Received: by 2002:aa7:cd92:0:b0:456:cbb5:2027 with SMTP id x18-20020aa7cd92000000b00456cbb52027mr42171665edv.384.1666814853248;
        Wed, 26 Oct 2022 13:07:33 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id n26-20020aa7c69a000000b0045bef7cf489sm4008353edq.89.2022.10.26.13.07.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Oct 2022 13:07:32 -0700 (PDT)
Date:   Wed, 26 Oct 2022 23:07:30 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun.Ramadoss@microchip.com
Cc:     ceggers@arri.de, andrew@lunn.ch, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, vivien.didelot@gmail.com,
        linux@armlinux.org.uk, Tristram.Ha@microchip.com,
        f.fainelli@gmail.com, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, richardcochran@gmail.com,
        netdev@vger.kernel.org, Woojung.Huh@microchip.com,
        davem@davemloft.net, b.hutchman@gmail.com
Subject: Re: [RFC Patch net-next 0/6] net: dsa: microchip: add gPTP support
 for LAN937x switch
Message-ID: <20221026200730.ggyd4jhhbwpezmhs@skbuf>
References: <20221014152857.32645-1-arun.ramadoss@microchip.com>
 <20221018102924.g2houe3fz6wxlril@skbuf>
 <d8459511785de2f6d503341ce5f87c6e6064d7b5.camel@microchip.com>
 <1843632.tdWV9SEqCh@n95hx1g2>
 <42c713fb7ad6aebe8ad2d3e0740f1e4678b10902.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42c713fb7ad6aebe8ad2d3e0740f1e4678b10902.camel@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Arun,

On Tue, Oct 25, 2022 at 03:41:26AM +0000, Arun.Ramadoss@microchip.com wrote:
> > CONFIG_PTP_1588_CLOCK=m
> > CONFIG_NET_DSA=m
> > CONFIG_NET_DSA_MICROCHIP_KSZ_COMMON=m [ksz_switch.ko]
> > CONFIG_NET_DSA_MICROCHIP_KSZ9477_I2C=m
> > CONFIG_NET_DSA_MICROCHIP_KSZ_PTP=y [builtin]
> > 
> > With this configuration, kbuild doesn't even try to compile
> > ksz_ptp.c:
> > 
> > ERROR: modpost: "ksz_hwtstamp_get"
> > [drivers/net/dsa/microchip/ksz_switch.ko] undefined!
> > ERROR: modpost: "ksz_hwtstamp_set"
> > [drivers/net/dsa/microchip/ksz_switch.ko] undefined!
> > ERROR: modpost: "ksz_port_txtstamp"
> > [drivers/net/dsa/microchip/ksz_switch.ko] undefined!
> > ERROR: modpost: "ksz_ptp_clock_register"
> > [drivers/net/dsa/microchip/ksz_switch.ko] undefined!
> > ERROR: modpost: "ksz_port_deferred_xmit"
> > [drivers/net/dsa/microchip/ksz_switch.ko] undefined!
> > ERROR: modpost: "ksz_ptp_clock_unregister"
> > [drivers/net/dsa/microchip/ksz_switch.ko] undefined!
> > ERROR: modpost: "ksz_ptp_irq_free"
> > [drivers/net/dsa/microchip/ksz_switch.ko] undefined!
> > ERROR: modpost: "ksz_tstamp_reconstruct"
> > [drivers/net/dsa/microchip/ksz_switch.ko] undefined!
> > ERROR: modpost: "ksz_get_ts_info"
> > [drivers/net/dsa/microchip/ksz_switch.ko] undefined!
> > ERROR: modpost: "ksz_ptp_irq_setup"
> > [drivers/net/dsa/microchip/ksz_switch.ko] undefined!
> > 
> > After setting all of the above to 'y', the build process works (but
> > I would prefer being able to build as modules). 
> 
> May be this is due to kconfig of config_ksz_ptp  defined bool instead
> of tristate. Do I need to change the config_ksz_ptp to tristate in
> order to compile as modules?

You don't want a separate kernel module for PTP support, so no, you
don't want to make CONFIG_NET_DSA_MICROCHIP_KSZ_PTP tristate.

But what you want is for the ksz_ptp.o object file to be included into
ksz_switch-objs when CONFIG_NET_DSA_MICROCHIP_KSZ_PTP is enabled.

See how sja1105 does it:

ifdef CONFIG_NET_DSA_SJA1105_PTP
sja1105-objs += sja1105_ptp.o
endif

You'll also want to make NET_DSA_MICROCHIP_KSZ9477_I2C and
NET_DSA_MICROCHIP_KSZ_SPI to depend on PTP_1588_CLOCK_OPTIONAL, because
CONFIG_PTP_1588_CLOCK can be compiled as module (as Christian shows),
and in that case, you'll want the KSZ drivers to also be built as
modules (otherwise they're built-in, and built-in code cannot depend on
symbols exported from modules, because the modules may never be inserted).

It's best to actually experiment with this, you cannot get it right if
you don't experiment.
