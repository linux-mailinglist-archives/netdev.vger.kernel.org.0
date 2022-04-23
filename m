Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC6E50CCD6
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 20:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236694AbiDWSTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 14:19:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235469AbiDWSTw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 14:19:52 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A26251E067E
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 11:16:51 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id y14so10240511pfe.10
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 11:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=2BFEKoGE3aIHZ7kbkHDPSXd8gYbR8pB57bfezObBHTI=;
        b=O+Wr9a9VDX3SBnGQcyxsJEyPyz3GTQEfyBk8UCbJeBJjiemxtxhzxK7+BoUqPRMDhW
         WrPCYagQ3NjNFEI6ihfT/WZL3HaskqBLRQXXNKrmD1H504D2LKDzhz2ak00mNrf24WZl
         7aO4+VdCiW7K1EPEBXT/Jz/AKzMSxlyDCQmpUKLq/yUNZjYctpCzrIME9BHredh0Z5zA
         fC1oo0vDPdkBJqRbdHXOH7TIy8Dvnqa86V5J5G1rEC8UHxwk7p0lNFKyOqvtuiusgD25
         TgjLeSN504+I1k2gBLl/ZSYngt6qc9ZKjt0sCAwCEomXShelH5XInflang56VbS3jPGK
         YN2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2BFEKoGE3aIHZ7kbkHDPSXd8gYbR8pB57bfezObBHTI=;
        b=LXSSbz8zI15BurtPFCW9IO2qzJAso8oh36d0IzMCPbWi7bnk87TR+GSZOIOSH+UZ+L
         0TwOTLiJy0Pv2YIETtfGsXURp8iQ6iQ88zGDJD4K2NFjT8w1wPf2Ih68LpLIQkUFAOAo
         73vLRHToh8Va4dejNCuy6coySu2KiivWhYAWugmXvom4z2uFxFr0v0ZMWyZs40Kbtsn2
         xa2OY+oHiRP4KP544E+45cg/lHk/2CSvxJpLR3Fq3uyZDeG7Jc8kgLWzW6uajxRO4HEn
         tuhAWIuLfwkApJe+vNzcPCz4Tn6ckxj1nisqMOYAVCJjNpl3N3O3irmsM/z4JnJLw1q0
         84eg==
X-Gm-Message-State: AOAM532Sh3mbmA7rNoQc1LxCX1lUCMy8GhP/2HcnqeCZX4HA75WofL+9
        ChkejF6RE8/7wUROojIPYDg=
X-Google-Smtp-Source: ABdhPJwlUOeZrLneKlj9aOJwQwld9ptRdQ9RvyQmIQI89yZ3CgygAyM0lKqAuWXVHurZx60HCzgpIg==
X-Received: by 2002:a05:6a00:e0e:b0:50a:cb86:883c with SMTP id bq14-20020a056a000e0e00b0050acb86883cmr11097586pfb.11.1650737811111;
        Sat, 23 Apr 2022 11:16:51 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id v27-20020aa799db000000b00509fbf03c91sm6745465pfi.171.2022.04.23.11.16.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Apr 2022 11:16:50 -0700 (PDT)
Date:   Sat, 23 Apr 2022 11:16:47 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, Lasse Johnsen <lasse@timebeat.app>,
        netdev@vger.kernel.org,
        Gordon Hollingworth <gordon@raspberrypi.com>,
        Ahmad Byagowi <clk@fb.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com
Subject: Re: [PATCH net-next] 1588 support on bcm54210pe
Message-ID: <20220423181647.GA23869@hoboy.vegasvil.org>
References: <928593CA-9CE9-4A54-B84A-9973126E026D@timebeat.app>
 <YmBc2E2eCPHMA7lR@lunn.ch>
 <C6DCE6EC-926D-4EDF-AFE9-F949C0F55B7F@timebeat.app>
 <YmLC98NMfHUxwPF6@lunn.ch>
 <20220422194810.GA9325@hoboy.vegasvil.org>
 <01f35484-e8b6-d0bb-dba7-d1e0407c00ca@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01f35484-e8b6-d0bb-dba7-d1e0407c00ca@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Apr 23, 2022 at 07:40:49AM -0700, Florian Fainelli wrote:
> I would prefer that we just stick to adding that code to bcm-phy-lib.[ch]
> which all Broadcom PHY drivers can use and we can decide whether we want to
> add a Kconfig option specifically for PTP.

Sounds good.

Thanks,
Richard
