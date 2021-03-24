Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D3D6347B8D
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 16:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236424AbhCXPDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 11:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236290AbhCXPC4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 11:02:56 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1689C061763
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 08:02:55 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id o126so22951340lfa.0
        for <netdev@vger.kernel.org>; Wed, 24 Mar 2021 08:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=V5GwcDMvbaXxFAhYGvN7DXehnPHfkjr8U1lrokIw4NA=;
        b=fBFnUWqf2skBlWu1e9J0BXREF5JdELQ8ewl5ZpfsxsE/8myNELKyVrsu3JmHtFLNsu
         U3EnMAMfJrBnB6xfUOw1V0y+tkvnqPe84EizRKHypq1pJOghoX89ud08PxyB1Db8Enlw
         hA1a9IQU+JrRo1Adwye1/jazl+2IpRU39Ikkr+1OuxbSwjixbqy9NRn6hprTP18FUFjM
         MCRdRxrGzRqli+zbBFB6HMvpoL37SqM+e/XcZs1lXo/h+SlwuZbYf7DqtVOnHliF10tS
         +1PcXfKx5Xlqb1pE1He6m8pUh+yuWGfLXmEJu9UA3h7yi4UBrJdRwX6jX2gCSlVS8Ar/
         Sdpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=V5GwcDMvbaXxFAhYGvN7DXehnPHfkjr8U1lrokIw4NA=;
        b=FPiCZ1YgBhYFtoKh6e4Dq2PkKAfJKRdNSxEGBI2tF0lOZ5vfixqPcQPasA1i5784/J
         ci2LCh4eG0Rzlie/Y32XwjKFfBs2UimXLXH5LQS2ynvYLOWZXMFrHUI3q3U7FforSPf+
         xffqnXJ5NdcLwmekYnA1Z7ctmNKG0LgA6dYQARC7/gDXS0joYN4mRI3GiugXgWiVLdko
         /Ielqgux6SSmJXBN9uWKwyFLB07OarGVO4Tvl2to/nzT5cY5cd2mXIXw6/dBQpe6Uf8b
         auJEXSWzAiGTuLa5RnRvJUVJ/U1+0DqRICKovLpS3IRC+wIK5n0iokkvcSfyjnS86I0f
         Ta2A==
X-Gm-Message-State: AOAM530fbYtKXuwqbdzF50tGZCpwyP0/IkKUbiRvuGR8hNmtjDH/vIty
        yHhHZZPsOhvagtJuqpd3QdufHBkzdN4rYZta
X-Google-Smtp-Source: ABdhPJxtI4bB3zWlCpzLN1wkndmgGN8zJYCCFooEM/vrVthokq8Ctqej5Db1DVlqcwOU2d4MU13iRQ==
X-Received: by 2002:a05:6512:405:: with SMTP id u5mr2144074lfk.574.1616598174001;
        Wed, 24 Mar 2021 08:02:54 -0700 (PDT)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id f23sm338441lja.43.2021.03.24.08.02.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Mar 2021 08:02:53 -0700 (PDT)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: mv88e6xxx: Allow dynamic reconfiguration of tag protocol
In-Reply-To: <20210324140317.amzmmngh5lwkcfm4@skbuf>
References: <20210323102326.3677940-1-tobias@waldekranz.com> <20210323113522.coidmitlt6e44jjq@skbuf> <87blbalycs.fsf@waldekranz.com> <20210323190302.2v7ianeuwylxdqjl@skbuf> <8735wlmuxh.fsf@waldekranz.com> <20210324140317.amzmmngh5lwkcfm4@skbuf>
Date:   Wed, 24 Mar 2021 16:02:52 +0100
Message-ID: <87pmzolhlv.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 24, 2021 at 16:03, Vladimir Oltean <olteanv@gmail.com> wrote:
> On Tue, Mar 23, 2021 at 10:17:30PM +0100, Tobias Waldekranz wrote:
>> > I don't see any place in the network stack that recalculates the FCS if
>> > NETIF_F_RXALL is set. Additionally, without NETIF_F_RXFCS, I don't even
>> > know how could the stack even tell a packet with bad FCS apart from one
>> > with good FCS. If NETIF_F_RXALL is set, then once a packet is received,
>> > it's taken for granted as good.
>> 
>> Right, but there is a difference between a user explicitly enabling it
>> on a device and us enabling it because we need it internally in the
>> kernel.
>> 
>> In the first scenario, the user can hardly complain as they have
>> explicitly requested to see all packets on that device. That would not
>> be true in the second one because there would be no way for the user to
>> turn it off. It feels like you would end up in a similar situation as
>> with the user- vs. kernel- promiscuous setting.
>> 
>> It seems to me if we enable it, we are responsible for not letting crap
>> through to the port netdevs.
>
> I think there exists an intermediate approach between processing the
> frames on the RX queue and installing a soft parser.
>
> The BMI of FMan RX ports has a configurable pipeline through Next
> Invoked Actions (NIA). Through the FMBM_RFNE register (Rx Frame Next
> Engine), it is possible to change the Next Invoked Action from the
> default value (which is the hardware parser). You can choose to make the
> Buffer Manager Interface enqueue the packet directly to the Queue
> Manager Interface (QMI). This will effectively bypass the hardware
> parser, so DSA frames will never be sent to the error queue if they have
> an invalid EtherType/Length field.
>
> Additionally, frames with a bad FCS should still be discarded, as that
> is done by the MAC (an earlier stage compared to the BMI).

Yeah this sounds like the perfect middle ground. I guess that would then
be activated with an `if (netdev_uses_dsa(dev))`-guard in the driver,
like how Florian solved it for stmmac? Since it is not quite "rx-all".
