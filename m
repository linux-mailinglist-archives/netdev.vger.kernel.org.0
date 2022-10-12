Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E59B5FC3EA
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 12:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiJLKrt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 06:47:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229972AbiJLKr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 06:47:27 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BA561902A
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 03:47:25 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id z3so22917286edc.10
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 03:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PRLFl99z4Qh40hibjlbXNBI2f8AmJHV10KT8Ud2jnW0=;
        b=RPFFAFkuF3ZmnOxRRJG+vn+gmsZAkgduOtz1BYhrrSJ2vEE+IpB8yYapYpc+uAPj9U
         sajuVEdVGpYFWRCBmiCXo6e+uLeBEcYIIl79v566ZnOxY3Z3ThmvCTo6OHmuoKjYzb/H
         AL96kjatOeq1qIjlaQ2EAuJnn+xTdqAgktKT53WM7BvPjECaiA2zeNRfcVD9U2EAIghk
         7kkJEjjmu2vHK1gTVgQm08fUTByqXku64zMZCmzGImU3Loj3hHaGZXvIXBGzE0g4Q/Kx
         ySh2dfVO7KDRC79gH9ieV+kpLG2Ktnq1kIJyV8+GeboQfDICTBGyN5p0oPD4ZSwBmQvW
         AHJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PRLFl99z4Qh40hibjlbXNBI2f8AmJHV10KT8Ud2jnW0=;
        b=KDM5drlny9/I+aZvXfdLbmh8dbpEH2msKMHmxTmH7JezNnzjUbFnHCgh/accZjRB2V
         +lZXpu23Zt0DfjkE3uJwTZDP0CuKxFCZAaqD2LTqpBS6qLuHpustGdT5VElyw9duCSYl
         NAkCW5uEIP69H12vBx3lC67Xk8l3e9c7VzP75YmemFQ6bFx74U0WGvwGc2Ya5W5b3yp0
         TY6GsSIR2eon5tL36Jx8MaCQ3LQILKcQQ5n6EUIjEFbujQq5wT3R+YvElYyjC/MlF0Z8
         SvercWawRgC4n1Em/UnRxYKa6NvdE8escAHBbGVeZQMru4ys859bl/R78INmmxxA7uKr
         04aA==
X-Gm-Message-State: ACrzQf1sIa7o9dBOMjZRrzKyX0YLsgoSthRKIbaqfCpXyiF+3e0oH1F6
        0uQo957WXnMr0yUNt6D3qfh5Kw==
X-Google-Smtp-Source: AMsMyM4XHfzQus1ejr44JBZ2/TPhSNrH6RZcu94S008EEyxLRWK1ouOJ0dGW28vuigQi/4wcq488IQ==
X-Received: by 2002:a05:6402:1f06:b0:457:149d:beaa with SMTP id b6-20020a0564021f0600b00457149dbeaamr26396394edb.238.1665571643571;
        Wed, 12 Oct 2022 03:47:23 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id jg29-20020a170907971d00b00788c820e630sm1025093ejc.121.2022.10.12.03.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 03:47:22 -0700 (PDT)
Date:   Wed, 12 Oct 2022 12:47:22 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-clk@vger.kernel.org, Vadim Fedorenko <vadfed@fb.com>
Subject: Re: [RFC PATCH v3 1/6] dpll: Add DPLL framework base functions
Message-ID: <Y0abOsYjGapUTJHv@nanopsycho>
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


[...]


>+struct dpll_device *dpll_device_alloc(struct dpll_device_ops *ops, const char *name,
>+				      int sources_count, int outputs_count, void *priv)

Having constant array of "pins" would not work for SyncE. For example in
mlxsw driver, netdevs can appear and disappear within the device
lifetime (for example port splits, linecard provision). We need to
register/unregister pins dynamically.

[...]

