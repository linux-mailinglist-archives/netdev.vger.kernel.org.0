Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82C4C4D723A
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 03:47:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233478AbiCMCsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 21:48:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232220AbiCMCsB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 21:48:01 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D83BD100768;
        Sat, 12 Mar 2022 18:46:49 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id p17so10844087plo.9;
        Sat, 12 Mar 2022 18:46:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=doSnwMu8htsob8pfOwt7IniOWL6XjgE9eeH6vrd3mUs=;
        b=eXQahQGkeXDwkojYaldQkULuCOdZz4hEAek1HQY2mWksFO1gYZJBzBcRyuaCajKN/h
         qQU0RkVAy+PwKYbvi8danUIs4F+63HNdrg6YcXHzBUAfur44etSmcOP+pSsqTcXsAojH
         dkUavgcjbOOAM4v9dW0fFvRvN1LzXvE374X3swuhL4ADFcyZnT/jOP4TYsYZKGAxiJjN
         U8M3lThX41rEs5wWmJFgNDo0lq9Cn7M1udQoXFT25TH0lusyl/HpK+I2nsKfuAqwVFnS
         54DrpFuOvlQvD3XdHI/ULHbeUIqBT5lRI8xPENZ8JRoQs0ybo7sGMDIrze2DfW3Usytc
         y/vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=doSnwMu8htsob8pfOwt7IniOWL6XjgE9eeH6vrd3mUs=;
        b=6qd1UuUhaKKyfAfxF0bmLsLv8VNWnbHmklyeyvrXT1dPVbzta7uNtW2eJHjMk09D+P
         0LidwwIkBoybO3bIdQ1C9bW1ZlmfVG4R/uov62z0neQrtvAnAqi4gP3le8vociG4Uyc0
         OXC19VZ9jTdhhMFSDT816l6LHDFXaig2yQOMLgglopHVEjf+7WhVyHP7c3H0hldkfQgW
         gXdMnfePzUlsE/S9Khd9muybLc07KeJjEjRP6Dp6q0E1ofm8qL4HzH15jtfIdoMY9Iei
         hKiGi+4BpEJL6fERc+pMXX8oYuE3nFYfeKcnNYHEui/GjdgreJ0kacVe87Uf83aCfOtq
         xDNw==
X-Gm-Message-State: AOAM5327xOKpu0sKGAi5av8ldHu3QJpqx1bXNJx1stHE+jBhslP/rjIR
        K9ImLMltlL3w467CzuyE9qk=
X-Google-Smtp-Source: ABdhPJxnUs3P5hj2nLnRMPNJ9u6MzjkJbAuvZOXRppbA0CQRJv9NqJMjl2CQbrlqH7Cbhna7hI1lmw==
X-Received: by 2002:a17:902:ea08:b0:153:35e8:7947 with SMTP id s8-20020a170902ea0800b0015335e87947mr10466131plg.112.1647139609424;
        Sat, 12 Mar 2022 18:46:49 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id l13-20020a056a00140d00b004e13da93eaasm15245824pfu.62.2022.03.12.18.46.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Mar 2022 18:46:48 -0800 (PST)
Date:   Sat, 12 Mar 2022 18:46:46 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Woojung.Huh@microchip.com, linux@armlinux.org.uk,
        Horatiu.Vultur@microchip.com, Divya.Koppera@microchip.com,
        netdev@vger.kernel.org, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Madhuri.Sripada@microchip.com, Manohar.Puri@microchip.com
Subject: Re: [PATCH net-next 2/3] dt-bindings: net: micrel: Configure latency
 values and timestamping check for LAN8814 phy
Message-ID: <20220313024646.GC29538@hoboy.vegasvil.org>
References: <20220308154345.l4mk2oab4u5ydn5r@soft-dev3-1.localhost>
 <YiecBKGhVui1Gtb/@lunn.ch>
 <20220308221404.bwhujvsdp253t4g3@soft-dev3-1.localhost>
 <YifoltDp4/Fs+9op@lunn.ch>
 <20220309132443.axyzcsc5kyb26su4@soft-dev3-1.localhost>
 <Yii/9RH67BEjNtLM@shell.armlinux.org.uk>
 <20220309195252.GB9663@hoboy.vegasvil.org>
 <BL0PR11MB291347C0E4699E3B202B96DDE70C9@BL0PR11MB2913.namprd11.prod.outlook.com>
 <20220312024828.GA15046@hoboy.vegasvil.org>
 <Yiz8z3UPqNANa5zA@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yiz8z3UPqNANa5zA@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 12, 2022 at 09:04:31PM +0100, Andrew Lunn wrote:
> Do these get passed to the kernel so the hardware can act on them, or
> are they used purely in userspace by ptp4l?

user space only.
 
> If they has passed to the kernel, could we provide a getter as well as
> a setter, so the defaults hard coded in the driver can be read back?

Any hard coded defaults in the kernel are a nuisance.

I mean, do you want user space to say,

   "okay, so I know the correct value is X.  But the drivers may offer
   random values according to kernel version.  So, I'll read out the
   driver value Y, and then apply X-Y."

Insanity.

(not to mention that this fails for older kernels without the proposed
interface)

Thanks,
Richard

