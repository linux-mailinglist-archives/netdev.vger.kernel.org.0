Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11A9D25B603
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 23:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgIBVij (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 17:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726355AbgIBVig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 17:38:36 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 922C7C061244;
        Wed,  2 Sep 2020 14:38:36 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id o68so456158pfg.2;
        Wed, 02 Sep 2020 14:38:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BlMBCDtq2IAhHJSi3TJv+B6UPJ/84fOkMMchbksCaC4=;
        b=K4Nt+d1WRBNGCjC6xnIKYHR/QQzo6k44lq9ceRInfB0/1OgiBGhI4XkA0i6Ow4RKYe
         aEYDDfykLPquRBCRubcLnLiXiuKMurs99l5fTGDp8+Rg0awtNwytLxYLfqMAuzH3rzrT
         cHKTiIcrvrVMFW29Jf1XusEdrNqy/eGkB3DfvID5stKmUa0DTGbbncVs0uynK0M3ME29
         q/9RE13Kb2R9g609KeUe1rKoLqr6qB1P6bFVOxWpBiIwdguPsJAN2jJK4IDQTODdGCNp
         nKcM5JfHBB8t9/wkyJzcPwQ2Fv3bsdsXGj9BS7zVnOiUKg3k+g+eB+TiDGArL1clKesH
         RWsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BlMBCDtq2IAhHJSi3TJv+B6UPJ/84fOkMMchbksCaC4=;
        b=qHTgxJPRFDWJPikCfFTCwJPU79yGhsP/GV/woVBfUBbxYKF4tcXBM3uizphKbW3sZv
         UsZstdoYcRhOZMP3qOKam5z6NvbRjNOWN8UuQOmCaEjXOlUhu6ePvmxiCdjG2uag87Ox
         58RFrLzFd9JewfXCutjrXciOiJbjSl7fIyCaoZf7RaZlqgh0jDZ/GQBx/aVJMBKuC7Ri
         XG2U+RRLV4zbh+2y/AMlCcSHskxoYM+8WzVt2NNXzpsA5Js9dKSehp32UxRitOHBfTrL
         HUwdV/Kf9VrjXFblGtH//RcBJcJN+4TrQBjgj0DXBJtnleGM0IFRzb8D0nUV7l9BKJv0
         Q01Q==
X-Gm-Message-State: AOAM530Nzm08N2UYwVsU3H/xO1Efj6JAshNwibW6bQJVjBgLNFUHrCjW
        LcAz6/zN+U+Bp3f+fBYGNsk=
X-Google-Smtp-Source: ABdhPJw7QNCG9pmgCTd8wVSL9rngdcktpkXYlExL/GNstovYY5waWD5K3SNhKcefHvqCBELXAKKCsQ==
X-Received: by 2002:a05:6a00:23c5:: with SMTP id g5mr428877pfc.160.1599082715555;
        Wed, 02 Sep 2020 14:38:35 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a15sm286105pgi.69.2020.09.02.14.38.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2020 14:38:33 -0700 (PDT)
Subject: Re: [RFC net-next 1/2] net: phy: Support enabling clocks prior to bus
 probe
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, adam.rudzinski@arf.net.pl, m.felsch@pengutronix.de,
        hkallweit1@gmail.com, richard.leitner@skidata.com,
        zhengdejin5@gmail.com, devicetree@vger.kernel.org,
        kernel@pengutronix.de, kuba@kernel.org, robh+dt@kernel.org
References: <20200902213347.3177881-1-f.fainelli@gmail.com>
 <20200902213347.3177881-2-f.fainelli@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <265dbcdb-6a56-0db8-73f9-7b643f5d95cf@gmail.com>
Date:   Wed, 2 Sep 2020 14:38:32 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200902213347.3177881-2-f.fainelli@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/2/2020 2:33 PM, Florian Fainelli wrote:
> Some Ethernet PHYs may require that their clock, which typically drives
> their logic to respond to reads on the MDIO bus be enabled before
> issusing a MDIO bus scan.
> 
> We have a chicken and egg problem though which is that we cannot enable
> a given Ethernet PHY's device clock until we have a phy_device instance
> create and called the driver's probe function. This will not happen
> unless we are successful in probing the PHY device, which requires its
> clock(s) to be turned on.
> 
> For DT based systems we can solve this by using of_clk_get() which
> operates on a device_node reference, and make sure that all clocks
> associaed with the node are enabled prior to doing any reads towards the
> device. In order to avoid drivers having to know the a priori reference
> count of the resources, we drop them back to 0 right before calling
> ->probe() which is then supposed to manage the resources normally.

That last part is actually not in this patch series, I had it in an 
intermediate version, but after chasing a clock enabling/disabling race 
that appears specific to the platforms I am using, I eventually removed 
it but left that part in the commit message.
-- 
Florian
