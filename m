Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63102557D71
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 16:00:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231745AbiFWOAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 10:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231451AbiFWOAw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 10:00:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 05DD83D1D1
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 07:00:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655992848;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FIDrWoNXXD1PHIZYzo4DYWm2aBEzjNbcfWPceT1SHR0=;
        b=RZixALIzvjMK2B9ya6WJT+Qoo6azYAtBmLbjO/gsABdzcJDMvLgqi6BYr+Ok/ppnzSjaXj
        e5uaAAXNgP+24Vv6yjiFOO4EinymdLdWgtYx+jZY9bfvvw8xNz6M/22diMqyac3KD1GBUs
        1f+HbswJdnneFWjYgJC2+RaKKx9FEBM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-312-Ah11GAWaMp-bdq2-MMePIQ-1; Thu, 23 Jun 2022 10:00:46 -0400
X-MC-Unique: Ah11GAWaMp-bdq2-MMePIQ-1
Received: by mail-wm1-f69.google.com with SMTP id r205-20020a1c44d6000000b003a02cd754d1so432012wma.9
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 07:00:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=FIDrWoNXXD1PHIZYzo4DYWm2aBEzjNbcfWPceT1SHR0=;
        b=lxkBkA+SHMzQxy8pi1E8aFIHNnzZRozf5Gmc5jvDqbM42RpRCQJQT/5s44voDwDgxY
         9UF5Wp/qMcJRgEdmVHJl7Uc0XKVoGHiPGSxMWyCmtDTGz70SH4a7pA+fNn3ClQYtQXbO
         XNfmSaa43VrgAY2NfCq8bgV2tQ2lTesm8ymGDu1/YTqWpsxiTeDvxCIyJc0+guDC7LQJ
         3LtpsHnB6RGa3hOWvu4IV7akb5XHGli5x28DvX1/pjKcEuw6B7Q2oPtk/IBHWHtpvrGC
         KPzKmAdmPPJQuWm9CAGRMRbGH4CVeZcP+/9V1Wuve7CTGyuILGMlp6oaZEqglsUmk2Hg
         +yyQ==
X-Gm-Message-State: AJIora8Wo3tZHWzjJwaRJsL/d3Gjcs8tcEWQEpTUyHLXdeEDsdMeJlRq
        CJw8+A46wXa83NmvGk9EZPNTf05OVzQio1ANJ+rQ0SNcQqtwav7nZ1UgKQ9VexuyogYMvK6dDAj
        r7f/L9fAxN/OI4WRO
X-Received: by 2002:a05:600c:3d09:b0:39c:8244:f0 with SMTP id bh9-20020a05600c3d0900b0039c824400f0mr4303005wmb.118.1655992845562;
        Thu, 23 Jun 2022 07:00:45 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1sZgu54O5maLiFhJnCPDBillzzSuX+2OsRQefug8MZKWJFvd10Eqs7zMaLB3SExGfEcCgksGg==
X-Received: by 2002:a05:600c:3d09:b0:39c:8244:f0 with SMTP id bh9-20020a05600c3d0900b0039c824400f0mr4302961wmb.118.1655992845189;
        Thu, 23 Jun 2022 07:00:45 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-113-202.dyn.eolo.it. [146.241.113.202])
        by smtp.gmail.com with ESMTPSA id u6-20020a7bc046000000b0039c45fc58c4sm3298656wmc.21.2022.06.23.07.00.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 07:00:44 -0700 (PDT)
Message-ID: <85edfdae247e0854be09dba16e18ca5d4a4f61cc.camel@redhat.com>
Subject: Re: [PATCH net-next] net: pcs: xpcs: depends on PHYLINK in Kconfig
From:   Paolo Abeni <pabeni@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux@armlinux.org.uk, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, davem@davemloft.net,
        Eric Dumazet <edumazet@google.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        Masahiro Yamada <masahiroy@kernel.org>
Date:   Thu, 23 Jun 2022 16:00:43 +0200
In-Reply-To: <20220622161229.3a08de6b@kernel.org>
References: <6959a6a51582e8bc2343824d0cee56f1db246e23.1655797997.git.pabeni@redhat.com>
         <20220621125045.7e0a78c2@kernel.org>
         <YrMkEp6EWDvd3GT/@shell.armlinux.org.uk>
         <20220622083521.0de3ea5c@kernel.org>
         <cebed632d3337a40cedbf3da78ff1e1154b1ae3a.camel@redhat.com>
         <20220622161229.3a08de6b@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-06-22 at 16:12 -0700, Jakub Kicinski wrote:
> On Wed, 22 Jun 2022 17:42:13 +0200 Paolo Abeni wrote:
> > @Jakub: please let me know if you prefer to go ahead yourself, or me
> > sending a v3 with 'depends PHYLINK' + the above (or any other option ;)
> 
> [resending, sorry, Russell let me know that my MUA broke the headers]
> 
> Well, IDK. You said "depends PHYLINK" which makes me feel like I
> haven't convinced you at all :)  Unless you mean add the dependency
> on the consumers not on PCS_XPCS itself, but that's awkward.

Well, I have misread your previous email.
> 
> What I was saying is that "depends" in a symbol which is only
> "select"ed by other symbols makes no sense. IIUC "select" does not
> visit dependencies, so putting "depends" on an user-invisible symbol
> (i.e. symbol without a prompt) achieves nothing.
> 
> So PCS_XPCS can have no "depends" if we hide it.
> 
> The way I see it - PHYLINK already selects MDIO_DEVICE. So we can drop
> the MDIO business from PCS_XPCS, add "select PHYLINK", hide it by
> removing the prompt, and we're good. Then again, I admit I have not
> tested this at all so I could be speaking gibberish...
> 
> diff --git a/drivers/net/pcs/Kconfig b/drivers/net/pcs/Kconfig
> index 22ba7b0b476d..f778e5155fae 100644
> --- a/drivers/net/pcs/Kconfig
> +++ b/drivers/net/pcs/Kconfig
> @@ -6,8 +6,8 @@
>  menu "PCS device drivers"
>  
>  config PCS_XPCS
> -       tristate "Synopsys DesignWare XPCS controller"
> -       depends on MDIO_DEVICE && MDIO_BUS
> +       tristate
> +       select PHYLINK
>         help
>           This module provides helper functions for Synopsys DesignWare XPCS
> 

AFAICS it should works, thanks

Paolo

