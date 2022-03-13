Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41E794D7820
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 21:07:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235523AbiCMUIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 16:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232809AbiCMUIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 16:08:21 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1882A4B426;
        Sun, 13 Mar 2022 13:07:13 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id g19so12512805pfc.9;
        Sun, 13 Mar 2022 13:07:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=tcuZyofv7oRF8b30riFV2CypFagiRwrqjLETjMU5Up0=;
        b=TdUKBZe9mlv/TGSrI6f7l5jL0X7FQNS3G8Y+6kjkjAGCi3mOZoWxLr+Y6wVRJWyjLd
         tXVQw1XEA3/V9USTwFZHAYvgsosAcfVgsih+ioDXVnmxsqO19Tg7s8v32e2JhJrOHl6L
         Sm6l671o8zlkNVgcnIt1qGxCDd3hs8mksaDpTzIg8aFT9Wt9CRWIA14knnp7O4Tr8Z5F
         /SWWxZR5WpRTiy4kLcBg5Ht6Que/DUBwnqp00sBCzzwq6cQsNW/JbeNJOIlGn8QofC5i
         M26uHOKWUe8P8zq6xRF0Woz+P4DrkFgBnAIIppnx50ZiP0IA1BLi59dT5hjFPNYJ0HxR
         jXFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=tcuZyofv7oRF8b30riFV2CypFagiRwrqjLETjMU5Up0=;
        b=bPZ7V8cAKO+gVNjv9LsUKwcStMT7/bwkd3eEUKFI4a7tm2Rpz8CvACmZMFIpofXnLA
         fuOKscNMkbPIPBGAjM/EjNQvxNqEJAeJ1Jwx+o1ttLnJNz0GCAM9r/usq26Ec3CggUC1
         /CdFXBTRyrcRhjfEHmqWcLWy6oVD5NUmZ75eGGL73Ae1t/yPiyekIfUAgLYPmdKM3uHx
         9diaZy7IJbmv9Y3ptl/3A81IL6D4sIaXRH7H48DPWEhPco2rWJ0ecDB3cuw+QtV02MFo
         PvDwvMmc0PisK4zLoCx1hnARkF9q9j5HfRqr32wLv68OsoS89cBajF9bBRqxO5Pg7pAU
         GIgg==
X-Gm-Message-State: AOAM532Bu8Lo1o91BhUDdNfkOkFUrO/pmYcPb2XHRCUVLPlil7kkIBsb
        YIK7uyLfgD34xnRjVEO8Eqs=
X-Google-Smtp-Source: ABdhPJxVDYop0QnOkZ08+FM1z6M5y92ltHBQdtrfbUTmf0XZ0eO+Dw0I2GiROmxqooZk0Ms1YEYsVQ==
X-Received: by 2002:a63:8441:0:b0:380:5d50:ba71 with SMTP id k62-20020a638441000000b003805d50ba71mr17597308pgd.107.1647202032290;
        Sun, 13 Mar 2022 13:07:12 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id u12-20020a17090a890c00b001b8efcf8e48sm18856717pjn.14.2022.03.13.13.07.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Mar 2022 13:07:11 -0700 (PDT)
Date:   Sun, 13 Mar 2022 13:07:09 -0700
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
Message-ID: <20220313200709.GD7471@hoboy.vegasvil.org>
References: <20220308221404.bwhujvsdp253t4g3@soft-dev3-1.localhost>
 <YifoltDp4/Fs+9op@lunn.ch>
 <20220309132443.axyzcsc5kyb26su4@soft-dev3-1.localhost>
 <Yii/9RH67BEjNtLM@shell.armlinux.org.uk>
 <20220309195252.GB9663@hoboy.vegasvil.org>
 <BL0PR11MB291347C0E4699E3B202B96DDE70C9@BL0PR11MB2913.namprd11.prod.outlook.com>
 <20220312024828.GA15046@hoboy.vegasvil.org>
 <Yiz8z3UPqNANa5zA@lunn.ch>
 <20220313024646.GC29538@hoboy.vegasvil.org>
 <Yi4IrO4Qcm1KVMaa@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yi4IrO4Qcm1KVMaa@lunn.ch>
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

On Sun, Mar 13, 2022 at 04:07:24PM +0100, Andrew Lunn wrote:
> Anyway, it is clear you don't want the driver doing any correction, so
> lets stop this discussion.

Okay.  Just to be clear, as an end user, I've already been burnt by
well meaning but false corrections in the driver.  As maintainer I
must advocate for the end users.

Thanks,
Richard
