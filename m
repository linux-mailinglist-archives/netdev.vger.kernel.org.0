Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBE43F426B
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 01:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234004AbhHVXqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 19:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbhHVXqB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 19:46:01 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB4DC061575;
        Sun, 22 Aug 2021 16:45:19 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id s3so11166298edd.11;
        Sun, 22 Aug 2021 16:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=qxXGJe1FSn6RtF/WGjSHOTG/s7YAlIaSVZM+cFk7PUU=;
        b=suhAQUSn0kv8uBzZv2/PXveZc7+AJ1hAPqi2GGlJx7Hc8HX9hxYIqOzLxYj4cXgZEI
         lbtJ/bYKohIp37YKssxuK8tZ++ZIEdfkfHSX/QwG5z8O9c4W6ZWp7sr9kz0RGRVcJisH
         sVP2rEp5eO+ZVHgGCrDIaH5kKpsh987lpUryb+WU0wk1NXZuxVw6T5m/zydwiXY3nKzA
         x5TvnKfFpT3fwPweHozCvPv3M6GA5w/boWSahx9Ds/GZGfT1rg+h6DA+QPapHw5h5wcV
         Rkif2jkySMaNbBbBq54bwKO800IlARJ/OFLSLhWS1dQujFOdBscsneZvcld8xp6nrmmp
         937Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=qxXGJe1FSn6RtF/WGjSHOTG/s7YAlIaSVZM+cFk7PUU=;
        b=ZgoKxwx4B4C3IcvxIR/pyuTQGLjGVxVwDW7nIZleqZOWfbBd2UwoxI1DEosLR7kSpA
         MvocjUcHLNgKKrpwXmibSHzy0VpkLx5hoQoHglZxU/O+oAVVDnMNYcgX6hyC0f2zWQnc
         KbI+pgWpJMLMRCzasS5FJslNxePmzxU7k9134G7S7ZWAEXM2O86traYx6HnAJ5Kpjn9l
         ci2fpbmjn7gnbths/pWs7xOtMubzPqbl26aN0ZM3HxlOuJgjOw6PEiGYv2ar5QHPRqTo
         yUHmUqKt4S7W0hx+xhG6GSHiC1r/3OJZkGsEtnJgG3HC2o3KJ8pgnDvhREdloVNsQPh3
         9K8w==
X-Gm-Message-State: AOAM531x7esSPdcJ8OKTmudb6haDV1gk6ay8zpOPAUvao+D10VMYkUMr
        IaIxCxZLRk2tG0pDs56wVfU=
X-Google-Smtp-Source: ABdhPJymO9gyO46EfKS5zLML967o8jbsJarH3aSWDveQrhDy8Asy8rZVfEuht1YaQJ6V02pxJAk4Dg==
X-Received: by 2002:a05:6402:d4f:: with SMTP id ec15mr35095545edb.353.1629675917932;
        Sun, 22 Aug 2021 16:45:17 -0700 (PDT)
Received: from skbuf ([188.25.144.60])
        by smtp.gmail.com with ESMTPSA id r19sm8010981edd.49.2021.08.22.16.45.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Aug 2021 16:45:17 -0700 (PDT)
Date:   Mon, 23 Aug 2021 02:45:16 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Alvin =?utf-8?Q?=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Alvin =?utf-8?Q?=C5=A0ipraga?= <alvin@pqrs.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Michael Rasmussen <MIR@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 3/5] net: dsa: tag_rtl8_4: add realtek 8
 byte protocol 4 tag
Message-ID: <20210822234516.pwlu4wk3s3pfzbmi@skbuf>
References: <20210822193145.1312668-1-alvin@pqrs.dk>
 <20210822193145.1312668-4-alvin@pqrs.dk>
 <20210822221307.mh4bggohdvx2yehy@skbuf>
 <9d6af614-d9f9-6e7b-b6b5-a5f5f0eb8af2@bang-olufsen.dk>
 <20210822232538.pkjsbipmddle5bdt@skbuf>
 <0606e849-5a4e-08c9-fcd1-d4661c10a51c@bang-olufsen.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0606e849-5a4e-08c9-fcd1-d4661c10a51c@bang-olufsen.dk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 22, 2021 at 11:37:28PM +0000, Alvin Šipraga wrote:
> >>>> +	skb->offload_fwd_mark = 1;
> >>>
> >>> At the very least, please use
> >>>
> >>> 	dsa_default_offload_fwd_mark(skb);
> >>>
> >>> which does the right thing when the port is not offloading the bridge.
> >>
> >> Sure. Can you elaborate on what you mean by "at the very least"? Can it
> >> be improved even further?
> >
> > The elaboration is right below. skb->offload_fwd_mark should be set to
> > zero for packets that have been forwarded only to the host (like packets
> > that have hit a trapping rule). I guess the switch will denote this
> > piece of info through the REASON code.
>
> Yes, I think it will be communicated in REASON too. I haven't gotten to
> deciphering the contents of this field since it has not been needed so
> far: the ports are fully isolated and all bridging is done in software.

In that case, setting skb->offload_fwd_mark to true is absolutely wrong,
since the bridge is told that no software forwarding should be done
between ports, as it was already done in hardware (see nbp_switchdev_allowed_egress).

I wonder how this has ever worked? Are you completely sure that bridging
is done in software?
