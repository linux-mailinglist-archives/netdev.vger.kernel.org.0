Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C47B24CE7DE
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 01:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbiCFAIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 19:08:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiCFAIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 19:08:04 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D28AE4D26F
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 16:07:13 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id f8so247932pfj.5
        for <netdev@vger.kernel.org>; Sat, 05 Mar 2022 16:07:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=H1RdEWEaF2zY+XlOMcL2u5K+sdiH2CHF53ci4CS51Po=;
        b=VTe+rIQubwkxo+4xk4BYAKZVQccNxzGklZMQxJLWoUD3kGPt2M+4y57xLhVnqj2bVL
         qrnWPSPYa5LrLyhWi+hjKgYRWhcO/4wxvyPWhodiHp6fLzTKtVBtyznndU4IEjeJPwaA
         GpqVa2uCAv7s45LXe18qiaVCXcJj+GNvOSFZgLaRdAN9ro5SJge+92AOIJ4O1/D7LabV
         VwyZrlO7d5zPu++CyETG20M6t7W5WKViN7CcAieUeSK8YGM1IKELT3qneJeElofCKq/t
         jiGRssIx3dCMcFanCcxOyt0K1ohzsdT//fCUNRPwYP0orFoac0BDlahMMrX8LrM7sjwZ
         GfiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=H1RdEWEaF2zY+XlOMcL2u5K+sdiH2CHF53ci4CS51Po=;
        b=TFb02spf/hG2FQTssrCANYYuD6QdowEn4o5/D9qUjjXt+5FhRc+OmO4OaCZPmQl3t1
         Tb9MFJLmlf1ZQ+XOgijbBBs73pfZgGIASuxBpdGsWxLk+CZzv7j4QAqIsSjZOVVebJrf
         rKBILfIBAEJSVXMqEcYpgAxFA5g4aQViMPNGZOJhyg+rRbiXjnpxft9/hrLLX2iCk8IV
         yA/HOJSdvmtm6yn7LOxwAeC0JccTI4iqgaw85uHlgvQg6QyMilsS9ogK63q3rM5Losok
         zGMe0+dBJ9GlFuZz2I9adtzXO8T1ytTbxRIiJzCwHmBMT7YDVd0rOP8XGRXMRGXnPaMy
         rIkg==
X-Gm-Message-State: AOAM530FH6Jr8mXPGt0vz/vyx6tSsGu+5D8/qJGqf6131cBADC576ipy
        IDSmLBoh2bgUijXq+krS5C0=
X-Google-Smtp-Source: ABdhPJyLc7d/MtVa5AKd+qlLxneGXiOseOk+PWP9gIUfjtr7nCRBipjJ59kOpiOLwkbG5DetGCNPxQ==
X-Received: by 2002:aa7:8882:0:b0:4df:7b9e:1ccb with SMTP id z2-20020aa78882000000b004df7b9e1ccbmr6052639pfe.41.1646525233306;
        Sat, 05 Mar 2022 16:07:13 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id g9-20020a056a0023c900b004e10365c47dsm10374011pfc.192.2022.03.05.16.07.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Mar 2022 16:07:12 -0800 (PST)
Date:   Sat, 5 Mar 2022 16:07:10 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Divya Koppera <Divya.Koppera@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] ptp: Add generic is_sync() function
Message-ID: <20220306000710.GA28085@hoboy.vegasvil.org>
References: <20220305112127.68529-1-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220305112127.68529-1-kurt@linutronix.de>
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

On Sat, Mar 05, 2022 at 12:21:24PM +0100, Kurt Kanzenbach wrote:
> Hi,
> 
> as multiple PHY drivers such as micrel or TI dp83640 need to inspect whether a
> given skb represents a PTP Sync message, provide a generic function for it. This
> avoids code duplication and can be reused by future PHY IEEE 1588 implementations.
> 
> Thanks,
> Kurt
> 
> Kurt Kanzenbach (3):
>   ptp: Add generic PTP is_sync() function
>   dp83640: Use generic ptp_msg_is_sync() function
>   micrel: Use generic ptp_msg_is_sync() function

For the series:

Acked-by: Richard Cochran <richardcochran@gmail.com>
