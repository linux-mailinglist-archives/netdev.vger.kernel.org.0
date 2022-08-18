Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97F72598982
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 19:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344570AbiHRQ7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:59:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344234AbiHRQ67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:58:59 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0DCA25EBA;
        Thu, 18 Aug 2022 09:58:58 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id s36-20020a17090a69a700b001faad0a7a34so5283645pjj.4;
        Thu, 18 Aug 2022 09:58:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=0n9tWOogStpbIbnmWH7Eo4QUmY/hJM++qXM5c0cYsTk=;
        b=Viw8yH65VIqN8l3cnTRg0RzdQHLNDbMjaC+hk2aDzMyaRV+4y8T/DfcCTjijBMt/Je
         OF48l7R8nrZR6jjbPIlrnK/ITMX38ct0vxN22HxBuT3Ol5kI0n+bOLQ5vLwrj1T+91Db
         KSyuy8NLjyJ3iycM/+f1iVDUjS86FdSYvvo2MVp+uLShqGIig4NYZ+3SMWWhm7WvsPCK
         vQrT4EOc2ciWwrCVdeDBzmgsjFKv/QLdEuvAuj5WXLYu3eCj35gl+ZG58x32Wkioi5f8
         1pvNPw/v+Gal6LtPmA/7laVujzgmv1DHd0+dRelmyUsdvLf8LZfobHhAEC8rtDoNUAjN
         4K/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc;
        bh=0n9tWOogStpbIbnmWH7Eo4QUmY/hJM++qXM5c0cYsTk=;
        b=Y2yL/Hx7vi7FpGREqiTlfKEwHp2+KuxkVRG2wrH3w9DnwXUUM8ujvfJ6k0zfwHfFVa
         cuG1bZf/xesYtxmeVR6y0Ig4XiKN3l7Xjm7o847hIPJjEG95RyIlhvZV/K/JNXWp38la
         H+KDlUKYY7wDYZeae6O3eb7hqeqE/k9FCyrAIG69+kT9Ivw6snRdbXC2RyFU5/pYoN/3
         zv9F0TaukR+pYbg+q02akwiDexhiTCB/GpqR5kVWlCyFLial0BXo9iJIoWuIFXLqY7kl
         MZlLPTUVr1R8MKPal86nUJRR8okHmRihWDfa2p+tE4NjbcunFjsppF+O6TpQSbtA0BD9
         WDLQ==
X-Gm-Message-State: ACgBeo24LxaezQIOJOjXuzR+dKi7B4ZvkPATkCx5RjXzgQcw+FFwhryQ
        gsGvH+4aUuMY2MKambFj1Pk=
X-Google-Smtp-Source: AA6agR5lBmspmR10hcKMnwyTbmxXDAGnszViVDrN089oPWq6GKTzSc4CsmlTVi9ldu+vfthJuh1cBQ==
X-Received: by 2002:a17:903:11c7:b0:170:a74e:3803 with SMTP id q7-20020a17090311c700b00170a74e3803mr3550130plh.156.1660841938495;
        Thu, 18 Aug 2022 09:58:58 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n11-20020a63a50b000000b0041c8e489cc2sm1513506pgf.19.2022.08.18.09.58.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 09:58:57 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 18 Aug 2022 09:58:56 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Beniamin Sandu <beniaminsandu@gmail.com>, hkallweit1@gmail.com,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hwmon@vger.kernel.org
Subject: Re: [PATCH] net: sfp: use simplified HWMON_CHANNEL_INFO macro
Message-ID: <20220818165856.GC923105@roeck-us.net>
References: <20220813204658.848372-1-beniaminsandu@gmail.com>
 <20220817085429.4f7e4aac@kernel.org>
 <Yv0TaF+So0euV0DR@shell.armlinux.org.uk>
 <20220817101916.10dec387@kernel.org>
 <Yv2UMcVUSwiaFyH6@lunn.ch>
 <20220817191916.6043f04d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220817191916.6043f04d@kernel.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 17, 2022 at 07:19:16PM -0700, Jakub Kicinski wrote:
> On Thu, 18 Aug 2022 03:21:53 +0200 Andrew Lunn wrote:
> > > > I had a quick look and couldn't see anything obviously wrong, but then
> > > > I'm no expert with the hwmon code.  
> > > 
> > > That makes two of us, good enough! :) Thanks for taking a look.  
> > 
> > It would of been nice to Cc: the HWMON maintainer. His input would of
> > been just as valuable as a PHY Maintainer.
> 
> Fair point, I lazy'd out and only checked that everyone get_maintainers
> asks for was CCed. Perhaps it'd be worth extending the hwmon's keyword
> match to trigger on the structs or the constants if it matters.
> Adding hwmon@ to CC just in case.

And you expect me to dig up the actual patch ?

Guenter
