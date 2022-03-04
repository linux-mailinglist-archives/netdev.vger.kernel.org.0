Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27F7B4CD5B6
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 14:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239725AbiCDN6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 08:58:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239659AbiCDN6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 08:58:45 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 932754EF71;
        Fri,  4 Mar 2022 05:57:56 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id m11-20020a17090a7f8b00b001beef6143a8so8023557pjl.4;
        Fri, 04 Mar 2022 05:57:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ftwBuPlw2e024l25iAc6+EbeaFcs7KnHUkyBDUublUo=;
        b=Dcq5pYomNeChWuLOCkXzM0aSwwHQ3dArZOkqrTAHQw4G85ExBo6zCK0KO1KDcEkzpQ
         FwBRSI2MXFBBNKsSr2E2YF2gs/cau9+6iHyNdviu2bjYVfHrrBY/KwbuTppEnzRARq4W
         pyvEt18SUiY/WQ0PzzmJHQ0Fj3NLefBdFzK77ARK1LgwjESbCNemf4yinsFvKDsQDgyd
         goX7c9bfCzTgh1t75u/cNLFvEcIIEFfxV8OgfU9R9im2pnMSawuKwNHoZrO1l83b5bzP
         X6ATmq2JYf89Y0Op+PruBj8slMccFBxPtM2DX8HmlV7JzG7y7NcGBRJkvNfTWCNhiM0e
         M3Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ftwBuPlw2e024l25iAc6+EbeaFcs7KnHUkyBDUublUo=;
        b=zL75gKiDxcbDNN9bLfIVilfQx4o04R6oRZR7VQsa1XIVx4oWPW2+eFxZAz15JPPnAA
         sfyLcfsX+HPiaAArRQwU/P/+H1HILfQj33ZocZxaw9xqjDz1CAsaJmyEBvTSYSLGu8N1
         RUergxUh31jTNtLIG5VkTV/QsN/rg2M5GjtSEvHQ8qJytRf49t+xlHRijf4tflkFDvMo
         vBcpa8DUMWn1F4eS6XyhVeuiFcI2wY4HJ7rpaJj0bfeMgC0AZR9DEzgat0EOvlDmkXHY
         Yy8mAwifuGXt3r2p+40V95YTSRS5BIvpSm80vbsE/MswPZVtp4Cd6tn0znp0wm2jHjPZ
         DHRQ==
X-Gm-Message-State: AOAM530yBM69P9NpnoPBQvaBjbeqclSH65dcS7c43znvL6poU935gQQV
        sl50wZGS5iKyDEBPivnp108=
X-Google-Smtp-Source: ABdhPJy0FmlLGGxIC2HEbsrvGXi4gzUDRcX0Qws154YPkmU4CZTe6AKZy3yPvGCTztKAeFcSjEE7Sg==
X-Received: by 2002:a17:902:d888:b0:151:6fe8:6e68 with SMTP id b8-20020a170902d88800b001516fe86e68mr22820370plz.158.1646402276114;
        Fri, 04 Mar 2022 05:57:56 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id h17-20020a63df51000000b0036b9776ae5bsm4799852pgj.85.2022.03.04.05.57.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Mar 2022 05:57:55 -0800 (PST)
Date:   Fri, 4 Mar 2022 05:57:53 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Divya Koppera <Divya.Koppera@microchip.com>,
        netdev@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, UNGLinuxDriver@microchip.com,
        madhuri.sripada@microchip.com, manohar.puri@microchip.com
Subject: Re: [PATCH net-next 3/3] net: phy: micrel: 1588 support for LAN8814
 phy
Message-ID: <20220304135753.GE16032@hoboy.vegasvil.org>
References: <20220304093418.31645-1-Divya.Koppera@microchip.com>
 <20220304093418.31645-4-Divya.Koppera@microchip.com>
 <87ee3hde5b.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ee3hde5b.fsf@kurt>
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

On Fri, Mar 04, 2022 at 02:46:08PM +0100, Kurt Kanzenbach wrote:

> Second, this seems like the second driver to use is_sync(). The other
> one is dp83640. Richard, should it be moved to ptp classify?

Sure, why not.

Thanks,
Richard
