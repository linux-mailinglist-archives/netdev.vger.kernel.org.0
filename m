Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3278347A25
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 15:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235922AbhCXODs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 10:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235592AbhCXODW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 10:03:22 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B524BC061763
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 07:03:20 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id u21so15089704ejo.13
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 07:03:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=L6pU77ncTueRda3bNpW6dzLS5Gme3yEAkFZNrYFN3bU=;
        b=HPJDdbfRFr9QZ8dcBdJEyx5ZvLYOBq+eg9iNAOV+yCLkv8Svmw8gEYvlRjdnxXna/+
         KcTG2Q8Rn/3qnQXpb57nYaH6mBKbJf5X16B9yHbOCDzaN1B7q8cOr0HbH/LUPVtOvUb2
         vcOWn3mk/bmg983qcVkTYkK5qhS+a5HSi87nS2zCG2K4r/HhFzORYWDWdlRrIrVVEKy5
         ujPbNjDAEtFWc32bx7s+QXFzQa4F13wLwbAQ/7reAtez8p29nkUmi/bsWNPwc6kxAWcb
         hk55UWh2qeOM5JAcg+XMaPI1CyZvyoie2tjvGS60iM91zZtIgtTBa5GsGyzWxEoLot2P
         M1Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=L6pU77ncTueRda3bNpW6dzLS5Gme3yEAkFZNrYFN3bU=;
        b=IrVRa//lwOebTIGx2vuxb3RV1huL4e2gY2TKq7bg46FDChXTF4AM3fAuD7AfHrR8ih
         gy2b+5Y1ooMtRhjwdohzXGcdtUCmfnAUVmqamQaTJiLtv5InbXOC0pUAvl2RMIgtLxnl
         LScx0c41jMblZrvenhcLdSpJdQe0ZmpgATBeb7ulB9yf2y6cJ/ruJ0ZZOZcNLVxGkgMu
         a5Z2G0qxm+HbWWA8mwmLz/8QVuAi6D+Bjdqwpc3q3KwcdDjkox3DhGj8BLUn8MDBrgGy
         K6FlMRy3HQmHcIgC55rSht2xNaQjvcoBHukIB8jIcY4M5Jcx3sM+3BeJ+xqxXfZgmBe0
         UHHA==
X-Gm-Message-State: AOAM532jOGovbTSjCmHeKjhi+zbeoh+svlKm5Ik6NC20FCzBuFLkEghF
        zlw7e14LYnt3qLDDVMzP1YE=
X-Google-Smtp-Source: ABdhPJwMiPDmf/4LN8v5F2GHceaX93m7elaM+OW0sD5RVUBVrY6GPvgLIM58o7QTOE6t0rdKS52rBA==
X-Received: by 2002:a17:906:cb0a:: with SMTP id lk10mr3803305ejb.479.1616594599397;
        Wed, 24 Mar 2021 07:03:19 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id ho11sm929528ejc.112.2021.03.24.07.03.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 07:03:18 -0700 (PDT)
Date:   Wed, 24 Mar 2021 16:03:17 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Allow dynamic
 reconfiguration of tag protocol
Message-ID: <20210324140317.amzmmngh5lwkcfm4@skbuf>
References: <20210323102326.3677940-1-tobias@waldekranz.com>
 <20210323113522.coidmitlt6e44jjq@skbuf>
 <87blbalycs.fsf@waldekranz.com>
 <20210323190302.2v7ianeuwylxdqjl@skbuf>
 <8735wlmuxh.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8735wlmuxh.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 23, 2021 at 10:17:30PM +0100, Tobias Waldekranz wrote:
> > I don't see any place in the network stack that recalculates the FCS if
> > NETIF_F_RXALL is set. Additionally, without NETIF_F_RXFCS, I don't even
> > know how could the stack even tell a packet with bad FCS apart from one
> > with good FCS. If NETIF_F_RXALL is set, then once a packet is received,
> > it's taken for granted as good.
> 
> Right, but there is a difference between a user explicitly enabling it
> on a device and us enabling it because we need it internally in the
> kernel.
> 
> In the first scenario, the user can hardly complain as they have
> explicitly requested to see all packets on that device. That would not
> be true in the second one because there would be no way for the user to
> turn it off. It feels like you would end up in a similar situation as
> with the user- vs. kernel- promiscuous setting.
> 
> It seems to me if we enable it, we are responsible for not letting crap
> through to the port netdevs.

I think there exists an intermediate approach between processing the
frames on the RX queue and installing a soft parser.

The BMI of FMan RX ports has a configurable pipeline through Next
Invoked Actions (NIA). Through the FMBM_RFNE register (Rx Frame Next
Engine), it is possible to change the Next Invoked Action from the
default value (which is the hardware parser). You can choose to make the
Buffer Manager Interface enqueue the packet directly to the Queue
Manager Interface (QMI). This will effectively bypass the hardware
parser, so DSA frames will never be sent to the error queue if they have
an invalid EtherType/Length field.

Additionally, frames with a bad FCS should still be discarded, as that
is done by the MAC (an earlier stage compared to the BMI).
