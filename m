Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 841324D70AB
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 21:04:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232550AbiCLUFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 15:05:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231804AbiCLUFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 15:05:45 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [185.16.172.187])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68C44532F1;
        Sat, 12 Mar 2022 12:04:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=rGqBRcNw4s56JzIh4WiyNNxrcGXW+DdMyOtuGHG9ozs=; b=Th
        q7cmAGUFE8nRztSu7eUZNV1O7EeMSsqNdrjI7WI0cQIeFuv1kPRsRUaRvYA/UY7L5Tt3Q0ZoidFMw
        XmV+pmrS23Qb/0J6GhIRUbv+cKaLmt2leNehEFa7JYwmSxqNoQzGBgLmhyce+dzrBbqVuKqPKjFlX
        ph1KD5vJHJVUG90=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1nT7yZ-00AVKz-Qt; Sat, 12 Mar 2022 21:04:31 +0100
Date:   Sat, 12 Mar 2022 21:04:31 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Woojung.Huh@microchip.com, linux@armlinux.org.uk,
        Horatiu.Vultur@microchip.com, Divya.Koppera@microchip.com,
        netdev@vger.kernel.org, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Madhuri.Sripada@microchip.com, Manohar.Puri@microchip.com
Subject: Re: [PATCH net-next 2/3] dt-bindings: net: micrel: Configure latency
 values and timestamping check for LAN8814 phy
Message-ID: <Yiz8z3UPqNANa5zA@lunn.ch>
References: <YidgHT8CLWrmhbTW@lunn.ch>
 <20220308154345.l4mk2oab4u5ydn5r@soft-dev3-1.localhost>
 <YiecBKGhVui1Gtb/@lunn.ch>
 <20220308221404.bwhujvsdp253t4g3@soft-dev3-1.localhost>
 <YifoltDp4/Fs+9op@lunn.ch>
 <20220309132443.axyzcsc5kyb26su4@soft-dev3-1.localhost>
 <Yii/9RH67BEjNtLM@shell.armlinux.org.uk>
 <20220309195252.GB9663@hoboy.vegasvil.org>
 <BL0PR11MB291347C0E4699E3B202B96DDE70C9@BL0PR11MB2913.namprd11.prod.outlook.com>
 <20220312024828.GA15046@hoboy.vegasvil.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220312024828.GA15046@hoboy.vegasvil.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>        PTP4l(8)                    System Manager's Manual                   PTP4l(8)
> 
>        NAME
>            ptp4l - PTP Boundary/Ordinary/Transparent Clock
> 
>        ...
> 
>        egressLatency
>               Specifies  the  difference  in  nanoseconds  between  the actual
>               transmission time at the reference plane and the reported trans‐
>               mit  time  stamp. This value will be added to egress time stamps
>               obtained from the hardware.  The default is 0.
> 
>        ingressLatency
>               Specifies the difference in nanoseconds between the reported re‐
>               ceive  time  stamp  and  the  actual reception time at reference
>               plane. This value will be subtracted from  ingress  time  stamps
>               obtained from the hardware.  The default is 0.
> 

Hi Richard

Do these get passed to the kernel so the hardware can act on them, or
are they used purely in userspace by ptp4l?

If they has passed to the kernel, could we provide a getter as well as
a setter, so the defaults hard coded in the driver can be read back?

	Andrew
