Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC18428E566
	for <lists+netdev@lfdr.de>; Wed, 14 Oct 2020 19:31:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388774AbgJNRbI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Oct 2020 13:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726111AbgJNRbH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Oct 2020 13:31:07 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD59C061755;
        Wed, 14 Oct 2020 10:31:06 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id dt13so5938538ejb.12;
        Wed, 14 Oct 2020 10:31:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eOQX8qrZdJY6yGgpfPJRyusy5hAy1yUGKjIQzStBmgk=;
        b=ZF+0TZuVsq6Zf4SBlD665r6t80lHJF87yvJwvoiGORx4R4+UEbp0YRSqILp1YdFydt
         4c2Jt97yytoFw8AkPdRZX9s+lcDAsSy81fg4oGfz3Y5DTDaQ5R21U+JVV28UcAplX8K2
         CuNSyCYyuEnl3Wr6BoKducYHMS9sDQUV2O3H7IEq+/GDauBoDOXkjlyZv+KF8fhWAFN7
         ainegRz7TQnQ+3Dm+7ZE8tIsD36yA1xtc5bbNUNGaFTtncebI6qV+oiW1OnaW6crg1ff
         xwJDGUulcAXTjCSw6Tqq6Kf849ACTBbXd4EGCYdGTWqKZDuWtEsx2wSM751WRr4wjQ93
         QzEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eOQX8qrZdJY6yGgpfPJRyusy5hAy1yUGKjIQzStBmgk=;
        b=IckhgKdNAeyyFMQggVDHkvLBeXZ1wxf1muPgrrvzYdsw4JXkDeDLFExJ0HjZHZksvl
         mTm8CRE1nsTrr+fAK/P0tZZkkqy2I8NC3xWIUrLJtxF3nRCDraOhsFS7iq3yfAW7Qn14
         +Q+LgkoFGhADb58WEwLVDAwwSnZ6CvWO00uPgy6KxUjUecULicHodAt/ksHU+1gYpAlX
         V5BtHYLpDn9j5sTmm6J5MBrJb/VRYPiXpryq2P7VwzVvJrR1m4DtjD8ldhyx2m8+x692
         sAykiCMe1jFiR7Gl00njV/od2BNM5sYg6nO17o6A4OSLnAnk4yPZxirJW6tJrhFhJDlA
         KHog==
X-Gm-Message-State: AOAM530IwF6c6d0kjF1bHREWhYYaCvKBfJyLQFEH74MTGrs9V5pml+fP
        gukGLo9gUc0OuyMHlWyIaIY=
X-Google-Smtp-Source: ABdhPJyMwpQ1vrLwSfJsRlp9uBIfdl7ZYVRtLGRBQODeEVSdZVhGwy115UDqJO4FlZYw7C+eBgRMrw==
X-Received: by 2002:a17:906:c0d8:: with SMTP id bn24mr112519ejb.480.1602696664980;
        Wed, 14 Oct 2020 10:31:04 -0700 (PDT)
Received: from skbuf ([188.26.174.215])
        by smtp.gmail.com with ESMTPSA id v1sm106400eds.47.2020.10.14.10.31.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2020 10:31:04 -0700 (PDT)
Date:   Wed, 14 Oct 2020 20:31:03 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [PATCH net] net: dsa: ksz: fix padding size of skb
Message-ID: <20201014173103.26nvgqtrpewqskg4@skbuf>
References: <20201014161719.30289-1-ceggers@arri.de>
 <20201014164750.qelb6vssiubadslj@skbuf>
 <20201014165410.fzvzdk3odsdjljpq@skbuf>
 <3253541.RgjG7ZtOS4@n95hx1g2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3253541.RgjG7ZtOS4@n95hx1g2>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 14, 2020 at 07:02:13PM +0200, Christian Eggers wrote:
> > Otherwise said, the frame must be padded to
> > max(skb->len, ETH_ZLEN) + tail tag length.
> At first I thought the same when working on this. But IMHO the padding must
> only ensure the minimum required size, there is no need to pad to the "real"
> size of the skb. The check for the tailroom above ensures that enough memory
> for the "real" size is available.

Yes, that's right, that's the current logic, but what's the point of
your patch, then, if the call to __skb_put_padto is only supposed to
ensure ETH_ZLEN length?
In fact, __skb_put_padto fundamentally does:
- an extension of skb->len to the requested argument, via __skb_put
- a zero-filling of the extra area
So if you include the length of the tag in the call to __skb_put_padto,
then what's the other skb_put() from ksz8795_xmit, ksz9477_xmit,
ksz9893_xmit going to do? Aren't you increasing the frame length twice
by the length of one tag when you are doing this? What problem are you
actually trying to solve?
Can you show a skb_dump(KERN_ERR, skb, true) before and after your change?
