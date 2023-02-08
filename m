Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 446CD68F10A
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 15:43:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230246AbjBHOnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 09:43:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjBHOnK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 09:43:10 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C120D72BA
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 06:43:09 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id u21so20770770edv.3
        for <netdev@vger.kernel.org>; Wed, 08 Feb 2023 06:43:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MKHoWeZWs7NiJLRpEy7LvZgHUCoaDkqtAp1qmSHZ7Oo=;
        b=TmDoYGNQZQSCkJX0fXqdV6WQnyLKrGnmsRbOWLlw+2SNvU06zBA3oLrdqSj02345Fr
         GJjS61SpRxzf7z2uGOPzXE3HkEm1DBFXiXSBYd/XV5ETcgFw73gX2EjMklV6feztJRdt
         K0ufNGWBS89sH8KAxTFg+ngESHjS1BEV6cmUYGvF0vShuUbZNME36s5t4zAkmE8h0wdg
         +7Ly+QR6LoRSD2kr+fD1R8LsbJk8V7OPawidj5Xfab/jXfINTf7vYtNK7Ujp751yxueD
         +Sku641YrKoQgyzVPx1LiwrhDtYJFxkF3tK9bM6hBDTMniWARIPlKhZL3ErAZPFwCn3f
         SaOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MKHoWeZWs7NiJLRpEy7LvZgHUCoaDkqtAp1qmSHZ7Oo=;
        b=kSRrhYrml6DzU+8tKXatwQhSFDGbGCMIynRkmUxLdSzcLbesLeLYLaejA1BTayefUk
         MK2GSFmtBWdVMSv+zrb35em+Q+41INvM/6OmEaadC2pou31dqhAqQxURMcdjNLEEXgf6
         0zGq+SAfHQ95KneyUcerw1PKbY1XvHqottrwkVg8qQzjvHcdHIEs0iHiCpa9WSQadp+q
         Rhr0oDj8738ZtPfPxmNb4ItXoqQ8+VsF/bdkuTcuX1rgIsiR0jd4/ZEUqMHPXQBrfEwl
         nUSzTGgroEBFVd0KQFwlFF9ft/PjqK3Vk6LPXzXKjLzHcpwDWeRTurgQ/pOTY5eeUHGR
         jc7Q==
X-Gm-Message-State: AO0yUKUw7FbDuNWXzZEIZbVrU60dduCislZHJBO825NQ8zAmJVaKcP/3
        aPrxFrPKXPjrmUrzk8MBPx07iA==
X-Google-Smtp-Source: AK7set/bpf7e9aUKvSQRcvRBfG8qmWZwOhr+j9JI5dBi0DLWS3AlaY3I1mr1+RGewqtGBi3LY8G/xg==
X-Received: by 2002:a50:ab0d:0:b0:4aa:a39f:65af with SMTP id s13-20020a50ab0d000000b004aaa39f65afmr7275537edc.42.1675867388414;
        Wed, 08 Feb 2023 06:43:08 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id u20-20020a056402111400b0049e1f167956sm7929366edv.9.2023.02.08.06.43.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 06:43:07 -0800 (PST)
Date:   Wed, 8 Feb 2023 15:43:06 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Xin Long <lucien.xin@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        dev@openvswitch.org, tipc-discussion@lists.sourceforge.net,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: Re: [PATCH net-next v3 1/3] string_helpers: Move string_is_valid()
 to the header
Message-ID: <Y+O0+ngPHklhtx6k@nanopsycho>
References: <20230208133153.22528-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230208133153.22528-1-andriy.shevchenko@linux.intel.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Feb 08, 2023 at 02:31:51PM CET, andriy.shevchenko@linux.intel.com wrote:
>Move string_is_valid() to the header for wider use.
>
>While at it, rename to string_is_terminated() to be
>precise about its semantics.

While at it, you could drop the ternary operator and return memchr()
directly.

With or without it:
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
