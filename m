Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC9F54D7263
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 05:04:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233512AbiCMEFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Mar 2022 23:05:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229796AbiCMEFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Mar 2022 23:05:24 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD5D28BF3A;
        Sat, 12 Mar 2022 20:04:16 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id bx5so11542742pjb.3;
        Sat, 12 Mar 2022 20:04:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=uksUDscG18pH8EI9uIGKs4R4Dd0p9gKfak1RBaRXBys=;
        b=AHhiVJ3UBkF49PV21p3KrPS9TLHac4Wb9F+3IGlTDZiDKwNLoLSCK7ymCrBjA/FB8g
         ymqHVMjFIl9JYl7Iu1Ge3wb3XNw1xesgT+ryR1GjrpuDxeEHCCnl/042FiL+/OS2evHF
         H2V5167S7Y3CWJhqaFveCWGFGyVfHP0NcfRZJhxMby5oCauTRuR1WBhhdjKstiqu2YSn
         WPfwG36Ugd7IBxh6uLZbE5y06m7q3+bl68he0wEMpT387ke8irt00/kGEHuLMJjmB82o
         qUlZlOvCSgw0wcF4AOuTUkD5jDpebm8oh77B/OQEvPMro3s/wrqUTUbCNGnRB9EeSHsJ
         kuYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=uksUDscG18pH8EI9uIGKs4R4Dd0p9gKfak1RBaRXBys=;
        b=c8WkZiLo0k3jBta5YwQVQJ1rhPBO+Bw0yC2xA/8jbBgpfYmYfZqrFF8JQp5BLXNv1a
         fOU1aeWRza6MGH+3qHby3+G5iVKZXv8A7t+GNhVbVCMtuXRl/MRjKVW4iSVqCBGPIM35
         ZW4olnH2BPpD+u+K+Bp6J04bH6Sr5lwQv42MRs3VrOrU4OP6b1xPS4GlkoRJUOliAvk2
         EjY/mQj1se9X4gcvJXtSSgheqn3YjY0m836/WTZF/oSR6NJv/Jw1klEi1kz3A9rqd+Oq
         SFezF/uibq69uQSFz24vxel6zxsLaMJtZfhGbf8x0D4CsLLzdjYpKcsPACq1wEdgowA3
         5ncw==
X-Gm-Message-State: AOAM530LgWfI2jgjbvMih3+gjVHZ1bbtVMyiyhi6gbhyg+/Da1GrN3yE
        xXlnhudAr9+dTTpnCb4/PRI=
X-Google-Smtp-Source: ABdhPJwpTnJVzXK4pQicWpojH8vBxMFMcbQP0DV2GLcxezgDZ5yuqgt8CS65wXuElZO48wwKZGX+vg==
X-Received: by 2002:a17:903:124a:b0:153:47d7:de49 with SMTP id u10-20020a170903124a00b0015347d7de49mr5921852plh.81.1647144256165;
        Sat, 12 Mar 2022 20:04:16 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id oo17-20020a17090b1c9100b001bf0ccc59c2sm18337904pjb.16.2022.03.12.20.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Mar 2022 20:04:15 -0800 (PST)
Date:   Sat, 12 Mar 2022 20:04:12 -0800
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
Message-ID: <20220313040412.GA30488@hoboy.vegasvil.org>
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
> I did skim through the articles, and as you hinted he does find small
> latency differences across different packets. (but as I understood, very
> few PHYs was tested).

There is also previous work cited in those articles.
 
> But this is not really an argument for not having _default_ values
> hard-coded in the driver (or DT, but lets forget about DT for now).

You put them in the DTS.  That means you expect them to need changes.

DTS is the WRONG place for such things.

If your numbers are perfect, then do the corrections in silicon/firmware.

If the numbers aren't 100% perfect, then provide your customers with a
test report providing the recommended numbers.  Include a proper
explanation of the test methodology and assumptions used in your
analysis.  Heck, you can even given them linuxptp config snippets (and
other for other popular PTP stacks, Oregano, ixat, ptpd, etc)

Don't hard code random, changing numbers into kernel drivers.

Thanks,
Richard

