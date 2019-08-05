Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB6D081F37
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 16:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729444AbfHEOhE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 10:37:04 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:39848 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728149AbfHEOhD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 10:37:03 -0400
Received: by mail-yb1-f194.google.com with SMTP id z128so7146123yba.6;
        Mon, 05 Aug 2019 07:37:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sXsgL2SZ4lUI561fxMT7MxM61cpGXMRE+ycWcBzTejM=;
        b=E5Os+v+XWKIvghYaPc4ImOOD3Mi5VmkoLqUtbDov2Wi6Ntf7ZdPEvPeXsXaD0tbR8r
         6BtNyByte9myzm3OhmTKo9lgr742sdvyGQ6Gncnf4BkQJ8abLUGNJu6yPcOmTXQF13nU
         unvL0othKMuVNkSmPTwN+zXMwpXyOA5CaohPayfhb63PK0wTB9k+Luk9446aEmRuAYF7
         AYZSfpT3PWTJ8+B8C/OkuRr/3iqZBbO6flSOANUhnk0OGrSzSrUGMgMitv7CQSPJ9sNe
         O+PA7h0lcZ9aIPkYRuH33ceso9jpMX4KPTLB2DFuZi/glxkhpA0vmvQDyLFfshHwIfPV
         CTpg==
X-Gm-Message-State: APjAAAXk0u6u6CSIZetOASDzpbXnh587YUjoE87TsCZ7/42U//F7gYMa
        SYMvPYTIZKGv1RTpUvs/TNi0YYbzT/wooXVohkQ=
X-Google-Smtp-Source: APXvYqxecEi6dBsfCGkzVUeMnKyUWiwSh30cKobG8N23AtZqWO8NMydcrerDzIB36fjz1DnIpERnoiHKMZh8D70r++s=
X-Received: by 2002:a25:9943:: with SMTP id n3mr2240341ybo.174.1565015823004;
 Mon, 05 Aug 2019 07:37:03 -0700 (PDT)
MIME-Version: 1.0
References: <1564566033-676-1-git-send-email-harini.katakam@xilinx.com>
 <1564566033-676-2-git-send-email-harini.katakam@xilinx.com>
 <20190804145633.GB6800@lunn.ch> <CAFcVECL6cvCjeo+fn1NDyMDZyZXDrWyhD9djvcVXiLVLiLgGeA@mail.gmail.com>
 <20190805132045.GC24275@lunn.ch>
In-Reply-To: <20190805132045.GC24275@lunn.ch>
From:   Harini Katakam <harinik@xilinx.com>
Date:   Mon, 5 Aug 2019 20:06:51 +0530
Message-ID: <CAFcVECLUNYRC-iZbKvvq2_XMLfXg7E10yAU5J_8GaEB3ExWRxg@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] dt-bindings: net: macb: Add new property for PS
 SGMII only
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Harini Katakam <harini.katakam@xilinx.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        David Miller <davem@davemloft.net>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Michal Simek <michal.simek@xilinx.com>,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Mon, Aug 5, 2019 at 7:00 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Mon, Aug 05, 2019 at 11:45:05AM +0530, Harini Katakam wrote:
> > Hi Andrew,
> >
> > On Sun, Aug 4, 2019 at 8:26 PM Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > On Wed, Jul 31, 2019 at 03:10:32PM +0530, Harini Katakam wrote:
> > > > Add a new property to indicate when PS SGMII is used with NO
> > > > external PHY on board.
> > >
> > > Hi Harini
> > >
> > > What exactly is you use case? Are you connecting to a Ethernet switch?
> > > To an SFP cage with a copper module?
> >
> > Yes, an SFP cage is the common HW target for this patch.
>
> Hi Harini
>
> So you have a copper PHY in the SFP cage. It will talk SGMII
> signalling to your PS SGMII. When that signalling is complete i would
> expect the MAC to raise an interrupt, just as if the SGMII PHY was
> soldered on the board. So i don't see why you need this polling?
>

Thanks. Sorry, I overlooked this interrupt. Let me try that.

Regards,
Harini
