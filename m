Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA3282A2275
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 00:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727517AbgKAX4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Nov 2020 18:56:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727119AbgKAX4D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Nov 2020 18:56:03 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22515C0617A6;
        Sun,  1 Nov 2020 15:56:03 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id p5so16535688ejj.2;
        Sun, 01 Nov 2020 15:56:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hxNCmXN+Np0a9fyk4jNL6uxWJrRHqB5tuMS990NxiFA=;
        b=eNEVhVKuq4LSWiX81LodotFKxhiO06l0LHgrGgBSCmI3o/660wqAWCLwj7vASYoTO0
         mqYrxuGAsnr2iIHSWFGeNpZ4xhJdcN7CWJ0zbhi4NSOJX1wNwrv6rChNizGdaLr/z++9
         y8isFlTl3AhvW/kcvpgsanwttUSXhfWzJOSxhu3N0MYHvfn5OV+ARLgov4UTOOLZFApJ
         MIVniKopBmGpvlbvKooUvMvZwjemXDaL2bh9edZP5QLlne1HfNCCNe841DKRg14FmFYr
         eqbT3g4pTmb2unORLo1CAirM8saJg+EzmFryZqKxXnWiqorHi8XF69IGRjgmn5Ihpqhh
         D36w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hxNCmXN+Np0a9fyk4jNL6uxWJrRHqB5tuMS990NxiFA=;
        b=WxqXyRvNVVHcCth1AgQdxKQfHdOvhnoFGKBJMOK5aeguEz3wfVcL62BT2g8A2o0OXU
         kNFNaTUz0iMSVH+N8McXYlMJj4I0AJmKy4X6j4HGsyU9ALTsdN0J8oxhsevy77I4a2EG
         o94Ax9Sqjde9FH1K5j+9zrTLNsrEdnoJY4YYyLq7O6TSIIRP0pwduwroWrDrkBk+PqoZ
         X2j2Ro2pxoie986Or70XyMBzcxMLzUK30jNXKEl37MB6cwsHVCTiffDaMZ96mKJjq8fO
         sOKokBWl+9Hw5w0wvN1An/WRxKRdRmRoUCXgraIXEXK/wqPfFexUBT2fznU05gNFyNVX
         Si1A==
X-Gm-Message-State: AOAM5329s+DaTzSscbPsrgfonqTETPoZvGKgFEUOIfKf/OJWIJOErvkD
        QywsFfqz8BOosCieSw0v8rE=
X-Google-Smtp-Source: ABdhPJwEYitE1WK+4CHeQD3modQC6TZN69oVu0YWKz1Ht+dHeo8jkIBZ3fFK4SnCLj2PDdrjiLMuUw==
X-Received: by 2002:a17:906:3413:: with SMTP id c19mr12512644ejb.421.1604274961855;
        Sun, 01 Nov 2020 15:56:01 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id k22sm9425259edr.12.2020.11.01.15.56.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Nov 2020 15:56:01 -0800 (PST)
Date:   Mon, 2 Nov 2020 01:55:59 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next 7/9] net: dsa: microchip: ksz9477: add
 hardware time stamping support
Message-ID: <20201101235559.wcdns4kmy6ri7kmz@skbuf>
References: <20201019172435.4416-1-ceggers@arri.de>
 <4928494.XgmExmOR0V@n95hx1g2>
 <20201101111008.vl4lj4iqmqjdpbyg@skbuf>
 <3355013.oZEI4y40TO@n95hx1g2>
 <20201101234149.rrhrjiyt7l4orkm7@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201101234149.rrhrjiyt7l4orkm7@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 02, 2020 at 01:41:49AM +0200, Vladimir Oltean wrote:
> In principle I don't see any reason why this switch would not be able
> to operate as a one-step peer delay BC.

What I meant to say was "one-step E2E BC", since I was talking about
having to receive both Sync and Delay_Req at the same time, of course.
