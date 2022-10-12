Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5658F5FC981
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 18:52:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbiJLQwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 12:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiJLQwA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 12:52:00 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8A3CE072C
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 09:51:57 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id e18so25290245edj.3
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 09:51:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/eHg9l9Spros3WG/ZoZz0uKFq6WrSdE+qNQJXriOHqA=;
        b=c/1n3aEQ9AR831fFKEu+GD/Z48ZlJ4p4BzvRu3U8YijRH1RIoa4IqS7Ou0TAkS/Zvy
         mpF9Pze1sLPLi4aQvrr+rp86WQUDyL3oAOfi+Bz5aKZyPzG7Fw/OUuVOg1zUh1ePFTE9
         mD7YN3DeKK93NhqCCvoa1otU0ULGVlkeMZOry2oCHnV1QkZV+l1intUptitH5zxcE6r6
         6v49skDRKGiIZbQFWrPJlmsYkRoCNIW04TBaLC3ti4LxKEBsaP8z1h5xd3JluzNo+tcX
         MpyAOPIKO1WcWkwglAmv6BJAfM5yNeEM6BlpWcOyn7Pcd6Mk18RIpZR3aUeGTz/3L5mF
         3oaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/eHg9l9Spros3WG/ZoZz0uKFq6WrSdE+qNQJXriOHqA=;
        b=UKYI/64/2AdXwVbXHrTHzSsOSDRXT+AJ+7jQ42uyeaPheIK+tAUOjLpewEb8d6f6kN
         nGuSZaplyd/XNVHz6EandiSl2ZMqB5neP0+Vpj0FNC9/6pBcRQDTc8827oLFDw2fZXWX
         /v7gIHMptfHLXk4T4QJQPvO/RG+32E8rBJbJVZ1GZO0YiGQ13DmKpiVuMAqaT9ve9OrL
         UEHwX4NMvcQ0QR5LxDJwDQ9N2NO9HWlBWM9HdoeYvr7RKtqatw0djN/sXid4rWIMd5pN
         VhhrUFxgaiX3NcQAhd4v9t6pYl6Apl/0aYPxslNEmqwSpPiB+kDo77WPNdMLOIa12o62
         mftQ==
X-Gm-Message-State: ACrzQf0JXhGNb1AzUuEo0IJNY2t8pJ/u0TolFQ8jhfEeNuKUiMUDybEc
        G734DPDoBGyTo4H50F6RUBa4iQ==
X-Google-Smtp-Source: AMsMyM5G52U+lKCyotcswU3vFbTXFMyAFRfXefx3vsVFvJjPIBcrqn865PhADCDanoZOofnJnAbtjA==
X-Received: by 2002:a05:6402:430a:b0:459:a049:76da with SMTP id m10-20020a056402430a00b00459a04976damr27455131edc.272.1665593516318;
        Wed, 12 Oct 2022 09:51:56 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id u18-20020a1709061db200b00782fbb7f5f7sm1530624ejh.113.2022.10.12.09.51.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 09:51:55 -0700 (PDT)
Date:   Wed, 12 Oct 2022 18:51:55 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org, Vadim Fedorenko <vadfed@fb.com>
Subject: Re: [RFC PATCH v3 1/6] dpll: Add DPLL framework base functions
Message-ID: <Y0bwq4YyeWsODPjv@nanopsycho>
References: <20221010011804.23716-1-vfedorenko@novek.ru>
 <20221010011804.23716-2-vfedorenko@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221010011804.23716-2-vfedorenko@novek.ru>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Oct 10, 2022 at 03:17:59AM CEST, vfedorenko@novek.ru wrote:
>From: Vadim Fedorenko <vadfed@fb.com>
>
>DPLL framework is used to represent and configure DPLL devices
>in systems. Each device that has DPLL and can configure sources
>and outputs can use this framework.
>
>Signed-off-by: Vadim Fedorenko <vadfed@fb.com>
>Co-developed-by: Jakub Kicinski <kuba@kernel.org>
>Co-developed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
>---

[..]

>+enum dpll_genl_status {
>+	DPLL_STATUS_NONE,
>+	DPLL_STATUS_CALIBRATING,
>+	DPLL_STATUS_LOCKED,
>+
>+	__DPLL_STATUS_MAX,
>+};
>+#define DPLL_STATUS_MAX (__DPLL_STATUS_MAX - 1)
>+

[..]

>+
>+/* DPLL lock status provides information of source used to lock the device */
>+enum dpll_genl_lock_status {
>+	DPLL_LOCK_STATUS_UNLOCKED,
>+	DPLL_LOCK_STATUS_EXT_1PPS,
>+	DPLL_LOCK_STATUS_EXT_10MHZ,
>+	DPLL_LOCK_STATUS_SYNCE,
>+	DPLL_LOCK_STATUS_INT_OSCILLATOR,
>+	DPLL_LOCK_STATUS_GNSS,
>+
>+	__DPLL_LOCK_STATUS_MAX,
>+};
>+#define DPLL_LOCK_STATUS_MAX (__DPLL_LOCK_STATUS_MAX - 1)

In addition to what I wrote in the previous reply where I suggested to
have lock status independent on type or source, I think we should merge
"status" and "lock status" to one attr/enum. Or any reason to have these
separate?

