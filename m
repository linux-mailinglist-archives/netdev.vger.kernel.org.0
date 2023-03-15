Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 505F66BB7C9
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 16:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbjCOP3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 11:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231669AbjCOP3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 11:29:36 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB2219F1D
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 08:29:34 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id v16so17738175wrn.0
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 08:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112; t=1678894172;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XYhBeu/notvz82UgfkzH+YbK5CCJXB0MnLkpf5cNHAI=;
        b=kRTHqzm153zu/Zc9NERe8ET2dWnkhROx09XiOifwd5oZvospmfGhysr6lgkUn1JFDn
         OKTe/gvetQCDLDIePfi+W3lqVQUjhwlG9sYj9vX2lGl4M4O9IgXC66Iq9vJkTnN0daVu
         OEmOT4sZkVH5whFbyf6o9UYCjHHTX7AeqahToseLy3ew/rQdWT2WtAdi3DUoNTjviJha
         HUSZ+xeXwGN4MTDX5XRAnbijQw19nax8wTq8qyGQkrhBESKAgRgLuaog2UnPxqNMruat
         FppK/AXaWfEStCKJlFEs2BuHGv+z5urycEjATQC0Zc5W+boeOQ5hHdFRFIbq1l/waU7k
         bGrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678894172;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XYhBeu/notvz82UgfkzH+YbK5CCJXB0MnLkpf5cNHAI=;
        b=Xrt+LAfkT/QtOUMPItU89VFXG0+taksyWVkHmgMAZMUVWjcTxVY5mo1KNkiMGBH96I
         yMHSitppVPSv0vRGch6CTjZ9Ek80BP8LJn2GX9658V/7QRWWhferx8r3mksLfagow8qs
         xE8sGNEwNU3t7Vp1VXUMmptWrvLI78MrO0MVI3Wtn5lcKqdtblXjDeyC0zyg9lo2/Zlk
         8yTSfjg5WJAdKM9wcwwaKY1EJgzEIdMHhsKsAY8rSA6KDIEH2mlm1xeQJZLAyWT3+kdJ
         mAgzYPZvmzEJRCkunj+btRW7npoSEVNCOH0OtPgwDz8k+6EP7Osi9CtcaVJdPHansAPg
         jeMg==
X-Gm-Message-State: AO0yUKXL//Vkt0/xLalPROIuOUdiu7Bu5m7mOTvRXilz4rmfgbglPT32
        EcRxKTUmX0aR6pW25hKyGd02tA==
X-Google-Smtp-Source: AK7set8qri9bTR6kXZCDIDLsIRR7ZhcP+VRrtZ/y7MfYtf3hUI4jwn6GWBEtEAhFV/gvCoQZxvPD1g==
X-Received: by 2002:a5d:448c:0:b0:2d0:bba8:3901 with SMTP id j12-20020a5d448c000000b002d0bba83901mr1647969wrq.62.1678894172494;
        Wed, 15 Mar 2023 08:29:32 -0700 (PDT)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id z4-20020a5d6544000000b002c56013c07fsm4931457wrv.109.2023.03.15.08.29.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Mar 2023 08:29:31 -0700 (PDT)
Date:   Wed, 15 Mar 2023 16:29:30 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadim Fedorenko <vadfed@meta.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vadim Fedorenko <vadim.fedorenko@linux.dev>, poros@redhat.com,
        mschmidt@redhat.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        Milena Olech <milena.olech@intel.com>,
        Michal Michalik <michal.michalik@intel.com>
Subject: Re: [PATCH RFC v6 2/6] dpll: Add DPLL framework base functions
Message-ID: <ZBHkWiglP70VMm3B@nanopsycho>
References: <20230312022807.278528-1-vadfed@meta.com>
 <20230312022807.278528-3-vadfed@meta.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230312022807.278528-3-vadfed@meta.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Mar 12, 2023 at 03:28:03AM CET, vadfed@meta.com wrote:

[...]

>+struct dpll_device
>+*dpll_device_get(u64 clock_id, u32 dev_driver_id, struct module *module);

[...]

>+struct dpll_pin
>+*dpll_pin_get(u64 clock_id, u32 dev_driver_id, struct module *module,
>+	      const struct dpll_pin_properties *pin_prop);

Small tweak, please use the same trick as shown for example here:
/* pci_register_driver() must be a macro so KBUILD_MODNAME can be expanded */
#define pci_register_driver(driver)             \
        __pci_register_driver(driver, THIS_MODULE, KBUILD_MODNAME)

The driver calls header helper which fills up the "THIS_MODULE" for it.

Thanks!
