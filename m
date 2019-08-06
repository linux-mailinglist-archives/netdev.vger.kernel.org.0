Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A58682B3D
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 07:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731656AbfHFFrY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 01:47:24 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:46369 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfHFFrX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 01:47:23 -0400
Received: by mail-yb1-f196.google.com with SMTP id w196so2283553ybe.13;
        Mon, 05 Aug 2019 22:47:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7HC4POCzIDqskggOt6lQiYyg5UHZw5xvry3RRGbyMKo=;
        b=ouKGS64yoOJQTRYB9zwz/Gj5gXNcTLUQ5X+5qynHGcnj8cFiEeFRBxStgdquY9d2j+
         CweBdYGs9UX/xFzRV5T5W88gfg0CXBeTz4BEjYECPr675MFWlNmWeGRn1MDC0BY8iVHb
         nxpiSeikHUxVgeRkfQwLASUr1cfmn4ibOvJqb3MkS6oz3xUHrBujIhNPmjA+VIS6Q/tV
         EbjSs9vhrTHPj5DWltHAp+IzhTM3aPQysb78Nro+XCzKnyKVjw82xwdLxm3XHflXPT6T
         oKZMhs7BCyMokIFBdXgp1QlEAHhjb0U3wJL1XBW4JR7834OfmwNciiVfI7B7XzV41hV+
         Vy1g==
X-Gm-Message-State: APjAAAU9D8Kn9d5hH09hDnYK8muU5i9P/U7uZY+SpMCnGp0Qf7qDE1Y7
        RF/6DCLthZSSXBWR94d9MStu4NHOXtU2E2yy8/I=
X-Google-Smtp-Source: APXvYqz3tYY7LUGGqsLQ1LpzPu4Cmx1TthFxzfD6TolHMI4FXEVi365AamdDKilNrXz+SkYAN9dOjSMG8xBO9sIRKe8=
X-Received: by 2002:a25:5f06:: with SMTP id t6mr1194536ybb.325.1565070442867;
 Mon, 05 Aug 2019 22:47:22 -0700 (PDT)
MIME-Version: 1.0
References: <1564566033-676-1-git-send-email-harini.katakam@xilinx.com>
 <1564566033-676-2-git-send-email-harini.katakam@xilinx.com>
 <20190804145633.GB6800@lunn.ch> <CAFcVECL6cvCjeo+fn1NDyMDZyZXDrWyhD9djvcVXiLVLiLgGeA@mail.gmail.com>
 <20190805132045.GC24275@lunn.ch> <CAFcVECLUNYRC-iZbKvvq2_XMLfXg7E10yAU5J_8GaEB3ExWRxg@mail.gmail.com>
 <CAFcVECLVHY5X=wctxVqRqDTDyG7Zavkt5ui4RtFBLP8g8MW1SA@mail.gmail.com> <20190805171639.GV24275@lunn.ch>
In-Reply-To: <20190805171639.GV24275@lunn.ch>
From:   Harini Katakam <harinik@xilinx.com>
Date:   Tue, 6 Aug 2019 11:17:11 +0530
Message-ID: <CAFcVECKp0N-82WX-mtT_J_jZ0u8C221bwLRrrSELZ1jgMKs-wA@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] dt-bindings: net: macb: Add new property for PS
 SGMII only
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Harini Katakam <harini.katakam@xilinx.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        David Miller <davem@davemloft.net>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Michal Simek <michal.simek@xilinx.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Mon, Aug 5, 2019 at 10:47 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > Even with the use of this interrupt, the link status actions (link print and
> > netif ops) will still be required. And also the need for macb_open to
> > proceed without phydev. Could you please let me know if that is acceptable
> > to patch or if there's a cleaner way to
> > report this link status?
>
> It sounds like you need to convert to phylink, so you get full sfp
> support. phylib does not handle hotplug of PHYs.
>
> Please look at the comments Russell gave the last time this was
> attempted.

Yes, I looked at the comments from Russell and wasn't sure if this
case qualified for phylink.

Regards,
Harini
