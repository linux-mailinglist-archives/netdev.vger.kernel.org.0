Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46FA557BF68
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 23:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230191AbiGTVEL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 17:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbiGTVEK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 17:04:10 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B255D5465B;
        Wed, 20 Jul 2022 14:04:09 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id k30so25285234edk.8;
        Wed, 20 Jul 2022 14:04:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qBbFw1ZzXTyz8cXktrqbhLMBulYSHXFcjiUZp1QOwIo=;
        b=BzFvTJvsKL4FG1GYa6Q+7NtfLeL0wK89LFMMkH2hgRKKLBpLVKGextSPrYHMpGYOYG
         7xgFo2qzLkOvyOKSCNfhANJ9EXsYd0RET/N6JY7AoYRdDj+gp8+cPVeWZTunQtIV466u
         ELjgTHv0ByWjKAzdwmL3Mc0fwbnKcE4lGCCjKxQkzJ1L+le9HYxubexI+74koO8snCtY
         7scvBnIxfxphFqgU8aKbpuMF4VIwE+DhSXmtT8xzxDZk00TFVhj3/FVdvAtfz7kpKAhL
         I0Ko8aQAKp7FXoahOMFBMWPnsjFnk0/JcfEHpjwfQSbXP0jLfPYQJxuBI5pdc5zFFxx9
         Go7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qBbFw1ZzXTyz8cXktrqbhLMBulYSHXFcjiUZp1QOwIo=;
        b=qiF3bWTygdn6n8jkKXu8rqzBzigBQ1v/hgf12QQ39LiR27mYibdZG6VVdKDYWPi5FS
         Pb2Eqx8E+y1Q8AAo1rXEJ4KasmzWN7Oh7WkhAPArTcqppPB9GQur1B9qS/MGPzNHfGM3
         yjCF29Vd445gYi515rQn72DTLJk1efBaSk8qzgpMsGy0l0cw93nG5AG9ZGC3E2oAkg8g
         0DBtHWzRL75mVXO5Ngen5uMSEM5plOcgAAp9KXLTmKEKY6IdqOkXlKN6oTMrhRDajrwn
         CUuyiMaO2mviapgE7CHIwuZ2uG1DdzD+5Vfr9mmne+vr/cSwGE9KbwIz5z2D0DDp/+f6
         yfrA==
X-Gm-Message-State: AJIora/KnOof6E9zvDy3RhGbHSQC5tCDs3CY4d9rGKCUijMSyc0AbiZk
        uKqk5vWkvl5QPXFvpxAUf/g=
X-Google-Smtp-Source: AGRyM1sLRHct8gnE6Y0WQhR4/ucqWyzO//vOE3v98s8caAwHN1r02tMVaC3RUG8zErb45zRCYxrTDg==
X-Received: by 2002:a05:6402:11d3:b0:43a:c43b:7ff9 with SMTP id j19-20020a05640211d300b0043ac43b7ff9mr54388522edw.130.1658351048064;
        Wed, 20 Jul 2022 14:04:08 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id da24-20020a056402177800b0043bbea24595sm24421edb.31.2022.07.20.14.04.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 14:04:07 -0700 (PDT)
Date:   Thu, 21 Jul 2022 00:04:05 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Arun.Ramadoss@microchip.com
Cc:     andrew@lunn.ch, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com, vivien.didelot@gmail.com,
        linux@armlinux.org.uk, f.fainelli@gmail.com, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org,
        Woojung.Huh@microchip.com, davem@davemloft.net
Subject: Re: [RFC Patch net-next 07/10] net: dsa: microchip: apply rgmii tx
 and rx delay in phylink mac config
Message-ID: <20220720210405.6wv6d3fssopnpm7x@skbuf>
References: <20220712160308.13253-1-arun.ramadoss@microchip.com>
 <20220712160308.13253-8-arun.ramadoss@microchip.com>
 <20220719102532.ndny6lrcxwwte7gw@skbuf>
 <d4696bc19472e9efd3a5581ea5c3bca201c90580.camel@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4696bc19472e9efd3a5581ea5c3bca201c90580.camel@microchip.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 20, 2022 at 02:51:42PM +0000, Arun.Ramadoss@microchip.com wrote:
> > Why not all RGMII modes and only these 2? There was a discussion a long
> > time ago that the "_*ID" values refer to delays applied by an attached PHY.
> > Here you are refusing to apply RGMII TX delays in the "rgmii" and "rgmii-txid"
> > modes.
> 
> I have reused the code of ksz9477 cpu config function and added the dll
> configuration for lan937x family alone. And understood that if device
> tree specificies as rgmii_txid then apply the egress delay, for
> rgmii_rxid apply ingress delay, for rgmii_id apply both.
> From your comment, I am inferring that apply the mac delay for all the
> rgmii interface "rgmii*".
> Can you correct me if am I wrong and bit elaborate on it.

What we are trying is to interpret what's written in
Documentation/devicetree/bindings/net/ethernet-controller.yaml in a way
that is consistent, even though its wording makes it evident that that
it was written in simpler times.

There it says:

      # RX and TX delays are added by the MAC when required
      - rgmii

      # RGMII with internal RX and TX delays provided by the PHY,
      # the MAC should not add the RX or TX delays in this case
      - rgmii-id

      # RGMII with internal RX delay provided by the PHY, the MAC
      # should not add an RX delay in this case
      - rgmii-rxid

      # RGMII with internal TX delay provided by the PHY, the MAC
      # should not add an TX delay in this case
      - rgmii-txid

The fact that the PHY adds delays in the directions specified by the
phy-mode value is established behavior; yet the MAC's behavior is pretty
much subject to interpretation, and this has resulted in varying
implementations in drivers.

The wise words above say that "RX and TX delays are added by the MAC
when required" - ok but when are they required? Determining this is
impossible based on the phy-mode alone, since there aren't just 2
degrees of freedom who may add delays (the PHY and the MAC). There also
exists the possibility of using serpentine traces (PCB delays), which
practically speaking, can't be described in phy-mode because then, a
potential PHY on the same link would also think they're for itself to
apply.

So the modern interpretation of phy-mode is to say that it simply does
not describe whether a MAC should apply delays in a direction or another.

So a separate set of properties was introduced, "rx-internal-delay-ps"
and "tx-internal-delay-ps". These have the advantage of being located
under the OF node of the MAC, and under the OF node of the PHY respectively.
So it's clearer which side is supposed to configure which delays, and
you also have finer control over the clock skew.

Initially when Prasanna first tried to upstream the lan937x, we discusssed
that since it's a new driver, it should support the modern interpretation
of RGMII delays, and we agreed on that strategy.

Now, with your recent refactoring that makes all switches share the same
probing logic (and OF node parsing), things are in a bit of a greyer area.

For one thing, you seem to have involuntarily inherited support for dubious
legacy bindings, such as the "phy-mode under the switch node" that is
described by commit edecfa98f602 ("net: dsa: microchip: look for
phy-mode in port nodes").

For another, you've inherited the existing interpretation of RGMII
delays from the KSZ9477 driver, which is that the driver interprets the
"phy-mode" as if it's a PHY (when in fact it's a MAC).

The KSZ9477 isn't by far the only MAC driver that applies RGMII delays
based on the phy-mode string, however in the past we made an effort to
update existing DSA drivers to the modern interpretation, see commits:

9ca482a246f0 ("net: dsa: sja1105: parse {rx, tx}-internal-delay-ps properties for RGMII delays")
5654ec78dd7e ("net: dsa: qca8k: rework rgmii delay logic and scan for cpu port 6")

There is a possibility to have a transitioning scheme: if the
"rx-internal-delay-ps" or "tx-internal-delay-ps" properties are present
under the MAC OF node, apply delays based on those. Otherwise, apply
delays based on phy-mode, and warn.

I'd appreciate if you could consider updating the KSZ common driver to
this interpretation of RGMII delays, so that the modern interpretation
becomes more widespread, and there are fewer places from which to copy a
non-standard one.
