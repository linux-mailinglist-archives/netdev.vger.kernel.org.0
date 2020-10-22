Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C98A295B2B
	for <lists+netdev@lfdr.de>; Thu, 22 Oct 2020 11:01:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2509935AbgJVJBc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Oct 2020 05:01:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2509188AbgJVJBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Oct 2020 05:01:32 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AC3EC0613CE;
        Thu, 22 Oct 2020 02:01:30 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id z5so1157994ejw.7;
        Thu, 22 Oct 2020 02:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=biKYzJ6rw5v7zotuxQlwelGlaL61xs7Y0POZsNN6hQ0=;
        b=G0lOaK/oWzaiYS1X4nfuWV2b9kpCSeHlywHLk4cWIaxwxW8oHkY4+VPazQDpqLbNHs
         xKzSmZHqodXCuFS4okFcUq7clRYkdnp7pr/dzSTeuXm2kzveGdU9KqYURkWu3Wnkum0O
         xJZntcnyb1wh6U4SHVkW2Px4ySD5TgNc7juOUxpprAcV4MvB1BYlpminey55jc9ehSWz
         IchM2mQK4+MKYEC+GZ5g4VY5ohooABNX1mWtg+JLUPmaRpqDUnvf4qAF8ANZ7OeE0Ju1
         JRsvKU9VG5AnzeAL3LCjlInbIv6/3LpaZqdhKce32p5ctplC7glIhz1/svnMWS3T+y3V
         PpcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=biKYzJ6rw5v7zotuxQlwelGlaL61xs7Y0POZsNN6hQ0=;
        b=XlqKZo2IkarFwFEhotu/Zvc6+7qiUylgCRo7xx83aaBnsnCG5IbXrjvlDjnd5Y0PJw
         KoOahQYnQZwLtRjWId32XwfflwD+EKl+8T+q25YzhaxOrKGgonWSRlpctNGndHDfPh+S
         GoKRQ4THSVk20QbjWX8cA1Z42cqbbgQVxSlhH/yg2Jr6hKQ4o5gLwzl1+BTkgoFGeKK9
         8TUhRSOTuU/N8BqB40lMSMOYjpRVpV6MKiVWZ/F0N2T3axFuRx7kvnkWZag46D35aF2g
         +UGTdelkze75R1vGE2lvFM1ExgiSIyuM+SZel6QRshOSQPCTWMCSBJyUpOFB0LSUDybG
         PSRg==
X-Gm-Message-State: AOAM532Ovhx+ty7R4q7uHzKou7uA6aaDYvGjzS4IVN53bSfRi6glpeL2
        NW4dsTq8P618Tq06BYcxN7M=
X-Google-Smtp-Source: ABdhPJzuUK4ka/iRomK+tIFIGOiAes2PQTeTEaI8Tr9CXPZvwjfYQxfMyqGn4bjP3MRbT+QVSs2Ihw==
X-Received: by 2002:a17:906:444:: with SMTP id e4mr1409273eja.218.1603357288909;
        Thu, 22 Oct 2020 02:01:28 -0700 (PDT)
Received: from skbuf ([188.26.174.215])
        by smtp.gmail.com with ESMTPSA id j3sm388785edh.25.2020.10.22.02.01.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2020 02:01:28 -0700 (PDT)
Date:   Thu, 22 Oct 2020 12:01:26 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Christian Eggers <ceggers@arri.de>,
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
Message-ID: <20201022090126.h64hfnlajqelveku@skbuf>
References: <20201019172435.4416-1-ceggers@arri.de>
 <20201019172435.4416-8-ceggers@arri.de>
 <20201021233935.ocj5dnbdz7t7hleu@skbuf>
 <20201022030217.GA2105@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201022030217.GA2105@hoboy.vegasvil.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 21, 2020 at 08:02:17PM -0700, Richard Cochran wrote:
> On Thu, Oct 22, 2020 at 02:39:35AM +0300, Vladimir Oltean wrote:
> > So how _does_ that work for TI PHYTER?
> >
> > As far as we understand, the PHYTER appears to autonomously mangle PTP packets
> > in the following way:
> > - subtracting t2 on RX from the correctionField of the Pdelay_Req
> > - adding t3 on TX to the correctionField of the Pdelay_Resp
>
> The Phyter does not support peer-to-peer one step.

Ok, that's my mistake for not double-checking, sorry.

> The only driver that implements it is ptp_ines.c.
>
> And *that* driver/HW implements it correctly.

Is there documentation available for this timestamping block? I might be
missing some data, as the kernel driver is fairly pass-through for the
TX timestamping of the Pdelay_Resp, so the hardware might just 'do the
right thing'. I believe the answer lies within the timestamper's
per-port RX FIFO. Just guessing here, but I suspect that the RX FIFO
doesn't get cleared immediately after the host queries it, and the
hardware caches the last 100 events from the pool and uses the RX
timestamps of Pdelay_Req as t2 in the process of updating the
correctionField of Pdelay_Resp on TX. Would that be correct?
