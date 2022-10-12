Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87DA15FC544
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 14:26:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbiJLM0K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 08:26:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbiJLM0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 08:26:08 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82DD3B7EE3;
        Wed, 12 Oct 2022 05:26:07 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id m16so1159969edc.4;
        Wed, 12 Oct 2022 05:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Jgt7h+7zEf+su2CjtW/uMJnyivJolNg+cF0vxRW9Nzk=;
        b=p16oZuIM89LYxVRriJlesnrSaZE3tE22QHSG5z5k4rpdN0LDqhZxuWXSzoyrZRIzoB
         llm0fkaSl7G7IdjmHM2iHsvCKqEUhwhL7B1sTy5oHyPGAAt+F+LNLPN7JNMh3clDoCq4
         ChWsMssRSpFaer0dImKpo2qwUP7sK4xOQx6ggfHhLUmXzAimV3yT3YkIxz5JuywhGOP+
         mhjfS7bqvmp7lL1CwkzsFd6TntVpz2cw9xz+NHShk5erIJim8DDvICmLtKZlXyA1mr0M
         3RXM6XfxkURXFM24HhwcD3zuxGnkYtucdh1uoTh6aQajNf2qTB5+e1GmxWFfyXJB1ZYD
         arBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jgt7h+7zEf+su2CjtW/uMJnyivJolNg+cF0vxRW9Nzk=;
        b=Ow9wiVG3Uaia4OIp3Rhhpn1dhPgf87ATSu0Ka4Cr5jN1seYm13LScHBF1qD19Bv7fN
         JLrwz9xyxv6agtjnKIDfNU4onuELV1DdxNRgfgm35abjeJR2Zp6E6VJaN2FQDalzlq/n
         cEtTyObra900nMJC337EOfWUCnkgw/13PQ+CUy+fW2tio8iixhizw5NgmnAiICuAN2nz
         S05Bi6KTCc+xFgLBJ+EPVsC4WbgbkBZQP/th5nSj+oYb++Ifl5cZr3sAbnAOjffhpbOh
         XVPO9/VcGI4qyzIDwPCgp8oRfQryv0dGmh93iduR6O/OOChbtD4Hwi5A5ClGzsKELZzW
         PEmw==
X-Gm-Message-State: ACrzQf0WwTFpvwgjEuMFYctZC5P2CT2jtpyeFVgFmUyDrfHGVV1XqKrG
        t+Gyrv+fVzvr+5bqSVEMJpCbbeVeWGo=
X-Google-Smtp-Source: AMsMyM5FbzchDPKJfJY27Af9c9FuOxTsjTFWfwyGfCsHkJ65C9WioS6xg2i7l/q/vZHC5HTt3NfAUA==
X-Received: by 2002:a05:6402:42c3:b0:459:cebb:8d3a with SMTP id i3-20020a05640242c300b00459cebb8d3amr27762688edc.421.1665577565819;
        Wed, 12 Oct 2022 05:26:05 -0700 (PDT)
Received: from Ansuel-xps. (93-42-70-134.ip85.fastwebnet.it. [93.42.70.134])
        by smtp.gmail.com with ESMTPSA id bt6-20020a0564020a4600b00458dda85495sm11243997edb.0.2022.10.12.05.26.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 05:26:05 -0700 (PDT)
Message-ID: <6346b25d.050a0220.37e6e.99cf@mx.google.com>
X-Google-Original-Message-ID: <Y0ayWkCVNIBp4ITm@Ansuel-xps.>
Date:   Wed, 12 Oct 2022 14:26:02 +0200
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pawel Dembicki <paweldembicki@gmail.com>,
        Lech Perczak <lech.perczak@gmail.com>
Subject: Re: [net PATCH 1/2] net: dsa: qca8k: fix inband mgmt for big-endian
 systems
References: <20221010111459.18958-1-ansuelsmth@gmail.com>
 <20221012072717.nuybkswd7zuwvqsp@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221012072717.nuybkswd7zuwvqsp@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 12, 2022 at 10:27:17AM +0300, Vladimir Oltean wrote:
> On Mon, Oct 10, 2022 at 01:14:58PM +0200, Christian Marangi wrote:
> > The header and the data of the skb for the inband mgmt requires
> > to be in little-endian. This is problematic for big-endian system
> > as the mgmt header is written in the cpu byte order.
> > 
> > Fix this by converting each value for the mgmt header and data to
> > little-endian, and convert to cpu byte order the mgmt header and
> > data sent by the switch.
> 
> By any chance, is the endianness of the data configurable?

By checking the documentation and the regs relevant to global switch
settings it doesn't look like the switch supports any kind of option
about endianess...

-- 
	Ansuel
