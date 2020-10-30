Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DAB52A0D51
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 19:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726522AbgJ3SYv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 14:24:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbgJ3SYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 14:24:51 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 156E5C0613CF;
        Fri, 30 Oct 2020 11:24:51 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id j24so9833712ejc.11;
        Fri, 30 Oct 2020 11:24:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1GiuXwACspAwUSLnSPZJpvg6PgQyL8EK07COgwjeSeo=;
        b=RxVlWt0YJULnLaCMp1skZbYCy9kyBPWrcjYb2YLiaOvGsKmUHravyblcgO2AEe1Mxy
         g4lmhctwhVkLj7WTOz9iQ9VZ9ATYUcbIun+SLMJlQmMgFrtdoWLq/VIwpxeX6HSNBlSR
         KjmV4zJWrMEy0mPll8SwxMCNihB+rtWuneEcFWKYO/PrqlGA4hdnWSJnifa+NIntrzxs
         XhCa92gXwkUtkQuUaIPzTpd0no+HquQpHhn4Zfvdcev0SoFJbT6uczuWO7idm5gIfDp9
         M70JOlPL7c01khJ20sgqm+KbPajd1qHmJKiLN1m5zb1iUSN0MJ+5V5yhsJKCRQ9kyimx
         OvuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1GiuXwACspAwUSLnSPZJpvg6PgQyL8EK07COgwjeSeo=;
        b=Puif4QZCXNoKZs5b0v8qeN2eegEfKGftY8d2GUnkknvXNsPvcajcm4wD6er3tVZDLh
         Y45dk9mjQ72SeEqsqvqb1SOoR2HFTNqavhz/obX5dFIKLcD9fMeEoF60VDxVR0uawTDv
         oWKLvi3Wegwj0IxJ9Y3qoOcLWr14ZkTvlKRQ4w4ajd1Cng8Mx6tnX4xGvqhqdXlS+xZw
         3P3iF+TOMtwd/FyJraPJ2UnwvcjJ4wQhxETkuJw529tOjbx3YpEvvsT3NP+dZzvtZt1Q
         Cd0vLy020BefUbiP13nIhmzsCmRZw4IbTn64wKxWTtu8OV8RVjV6FddDk4HEVYld89aN
         fNLw==
X-Gm-Message-State: AOAM530Jlw9Gsqq7Ux8tJFx15e0yWoQzEnRqp99bV1U6oQgcjEddiUk1
        kwALcc+dfa00lpXaiQgaTmHMa5tcE/g=
X-Google-Smtp-Source: ABdhPJzZcIgLqrMs+1siG0FP3QZcbHqAccvNY+Ug5zMwXN30nN4+SfRnVv7wAdLLiUAriF5KqTR+4Q==
X-Received: by 2002:a17:906:5618:: with SMTP id f24mr3769064ejq.86.1604082289662;
        Fri, 30 Oct 2020 11:24:49 -0700 (PDT)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id df12sm3464504edb.8.2020.10.30.11.24.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 11:24:49 -0700 (PDT)
Date:   Fri, 30 Oct 2020 20:24:47 +0200
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
Message-ID: <20201030182447.2day7x3vad7xgcah@skbuf>
References: <20201019172435.4416-1-ceggers@arri.de>
 <20201022023233.GA904@hoboy.vegasvil.org>
 <2975985.V79r5fVmzq@n95hx1g2>
 <1680734.pGj3N1mgWS@n95hx1g2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1680734.pGj3N1mgWS@n95hx1g2>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 22, 2020 at 12:17:48PM +0200, Christian Eggers wrote:
> I tried to study the effect of setting the ocmode bit on the KSZ either to
> master or to slave. The main visible change is, that some PTP message types
> are be filtered out on RX:
> - in "master" mode, "Sync" messages from other nodes will not be received
> (but everything else like "Announce" seem to work)
> - in "slave" mode, "Delay_Req" messages from other nodes will not be received

Could you dump the contents of your REG_PTP_MSG_CONF2 register?
