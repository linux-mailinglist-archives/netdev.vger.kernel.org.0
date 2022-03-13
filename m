Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1751D4D7234
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 03:41:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233433AbiCMCm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 21:42:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233385AbiCMCm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 21:42:57 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD5218E187;
        Sat, 12 Mar 2022 18:41:50 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id n15so10864811plh.2;
        Sat, 12 Mar 2022 18:41:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1fskSP0gHERAtz5LalHkiwzylQjQwe89pEx6fQtp0KU=;
        b=nuaDnykYqpqHHDXkEJjdRwt3rvLdCah9IO+tYgdEVvzbW7oreof2LjyZAYQEEyS37p
         2eiRXF03z+Iu632ooK6v/yptBJLSqWseKc3g4Ok1qmdGW8N6yVaK7rdM/726SckB3OQ4
         8N8E3Xtob+3I9VyVhp+dKXrsq+ERf3YgKP+FbiBBvQAg0pqRc818l+UzTyn6222/q4Yu
         vA57n/tX6gmbV2D0OHdAa2zSyrSDFdQSZOPQI3J1XNgAQ0l6lPr8scqVUJ0AlzWYYaPq
         DjTz/4c478lJp2zM/TO83/b+SXwwD/PB87gnciq/a2Q/5FmvxkQi0XIP49ZAOWmDdpTe
         P0Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=1fskSP0gHERAtz5LalHkiwzylQjQwe89pEx6fQtp0KU=;
        b=LDwvY5KPgOFolH+AoD0zqmuJcXLAtGhwxTdyQqiCeQeenlTfDydCjDdI56rt7t7n8z
         OuWK8+g83nGQ8QcxqDxviMURN/BpD/UVn0dg2J7jPMcN3y+Qfep3Mu7pF4nbDDVd7afD
         b2gj8THFWF2FKpoFGclKht7GdqPHN+V5e7OLmvKr4e+hmdenq6zz/dkqJmN4b1Ac3aFw
         99f5Jk1WgA6M0AmgkW1UgVT82ori09P0LytZUGeZMGCoxLu/83J8dUgOyUEHaVQlQp53
         SbU4SwKAxSoFHYOIn/WJ/PSX+NOHqwAAUqVwthTJYiNpZMmBSMwvMMX7nsxy5B7saNcx
         NoQA==
X-Gm-Message-State: AOAM531V99mbPYcvkeNI4a1AFU3BsgoxjNKAXigp7SJr0FXgvugSaYwp
        5Y21Q7xL2CiJSsGFl5nI3gE=
X-Google-Smtp-Source: ABdhPJwVsLdRl9naAj33/DxeBv99mrEP2FURQlajcdcPPUBf2U9/Q3Vci+rEmwqkSh5FzOBIrRxlsA==
X-Received: by 2002:a17:902:6902:b0:14d:6aa4:f3f5 with SMTP id j2-20020a170902690200b0014d6aa4f3f5mr18008224plk.20.1647139310204;
        Sat, 12 Mar 2022 18:41:50 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id x6-20020a17090aa38600b001bce781ce03sm12825798pjp.18.2022.03.12.18.41.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Mar 2022 18:41:49 -0800 (PST)
Date:   Sat, 12 Mar 2022 18:41:46 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     "Allan W. Nielsen" <allan.nielsen@microchip.com>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, Divya.Koppera@microchip.com,
        netdev@vger.kernel.org, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        Madhuri.Sripada@microchip.com, Manohar.Puri@microchip.com
Subject: Re: [PATCH net-next 2/3] dt-bindings: net: micrel: Configure latency
 values and timestamping check for LAN8814 phy
Message-ID: <20220313024146.GB29538@hoboy.vegasvil.org>
References: <20220308154345.l4mk2oab4u5ydn5r@soft-dev3-1.localhost>
 <YiecBKGhVui1Gtb/@lunn.ch>
 <20220308221404.bwhujvsdp253t4g3@soft-dev3-1.localhost>
 <YifoltDp4/Fs+9op@lunn.ch>
 <20220309132443.axyzcsc5kyb26su4@soft-dev3-1.localhost>
 <Yii/9RH67BEjNtLM@shell.armlinux.org.uk>
 <20220309195252.GB9663@hoboy.vegasvil.org>
 <20220311142814.z3h5nystnrkvbzek@soft-dev3-1.localhost>
 <20220311150842.GC7817@hoboy.vegasvil.org>
 <20220312193620.owhfd43dzzxtytgs@den-dk-m31684h>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220312193620.owhfd43dzzxtytgs@den-dk-m31684h>
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

On Sat, Mar 12, 2022 at 08:36:20PM +0100, Allan W. Nielsen wrote:
> With this in mind, I do agree with you that it does not make much sense
> to compensate they few cm of PCB tracks without also calibrating for
> differences from packet to packet.

The PCB traces AFTER the PHY are part of the network, and if they
contribute to path asymmetry, then that can and should be corrected
using the delayAsymmetry configuration variable.
 
> If we do not offer default delays directly in the driver, everybody will
> have to calibrate all boards just to have decent results, we will not
> have a good way to provide default delay numbers, and this will be
> different from what is done in other drivers.

Who says the other drivers are even remotely reasonable?  Not me.
I've been fighting this voodoo engineering all along, but people seem
to ignore me.

> I do understand that you have a concern that these numbers may change in
> future updates. But this has not been a problem in other drivers doing
> the same.

Wrong.  See the git history of the i210 driver.  Also the data sheets.

> But if this is still a concern, we can add a comment to say
> that these numbers must be treated as UAPI, and chancing them, may
> cause regressions on calibrated PHYs.

Comments will be ignored.  And when the next batch of developers comes
along, they will ignore your prohibition.

Thanks,
Richard
