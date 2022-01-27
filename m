Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8ED849D782
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 02:36:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234550AbiA0Bf6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 20:35:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231694AbiA0Bf5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 20:35:57 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF4A9C06161C;
        Wed, 26 Jan 2022 17:35:57 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id y27so1312905pfa.0;
        Wed, 26 Jan 2022 17:35:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YGeQibo141N0DXeCq178P+dmKawAPL71KRhdN2QxS1E=;
        b=gDkIdCriLd2jkQ0wgYezc5YgKHbAoj3XuKv4Rf8wdPYWgkZKKAszFr5oAoScwHqpKV
         OtWGKjWk5OmhWCOZUu5y5okfRH9OnoxX33ImJh82bCjOpwW7E79yvzlvyRZLF4ZWgurO
         VmnjA8LQJ4yYVU4LfJxNbMczEGjQXZYNj1pjPW6RWK8xIggYZzFtsQLOlxa5TOSYcvDn
         fT9sfj47SfdpMY35SD+GcMJxvxm0l/EXqOtpK5ols1oYdG71qaTaNK7h6ULZT7RxFE9C
         Fgy0oG9xKSg75iJ7IHRLRsa6aHVadEBGxkUbQ+d+w7hz6iy8IbUiXbwqbg3M+WGjhLYZ
         5q+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=YGeQibo141N0DXeCq178P+dmKawAPL71KRhdN2QxS1E=;
        b=vTGAwh16cNT2pWtcACCs2FEmH6kRnQyb6vI46JKl1FC20QQkfw/YccRS2hc3uv5DqF
         yjqLsSzk1ATZAIKTM5jxWlaBnGuedBcQN5G8Nzqsg7tX1vRZm3Q+amqtQsdn4rPrP+Qv
         d2dnI846COdvHIsD7iBW5I3Ahs1adeIfgphFszxm1u0eSDK9t9j1QBXIyblC2F3cm8wG
         GRqDtiJ2f1ebV+8kf2boUgh76Wjt51DKUc2qy6KTbghViMuDLJRilssxhGSZq9yd6YxB
         6V4Ia4aYSZwVcgr+sKYzN2au4Mcu6L5SmhSw28L+UkNRc6YUsi+/tmpt3yhXC4APvU/r
         KIGg==
X-Gm-Message-State: AOAM533XSt5n6fEvwoV7rWwSSO6t5qY4gVivgACEXN/oCcgh1wtmbaEa
        CwRUXzASlLy7S0xDSeV1iPfpMJEM4Ck=
X-Google-Smtp-Source: ABdhPJxY4izhUzo0WA3RAbftmr25C/cB3NqL+IFF9Rd0H9PNDhDSNE9+H2K/6r4aKYDB274Ptu6M5A==
X-Received: by 2002:a65:5a8c:: with SMTP id c12mr1152901pgt.238.1643247357195;
        Wed, 26 Jan 2022 17:35:57 -0800 (PST)
Received: from hoboy.vegasvil.org ([2601:640:8200:33:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id z8sm3547632pfe.42.2022.01.26.17.35.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 17:35:56 -0800 (PST)
Date:   Wed, 26 Jan 2022 17:35:54 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     davidcomponentone@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yang Guang <yang.guang5@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] ptp: replace snprintf with sysfs_emit
Message-ID: <20220127013554.GA943@hoboy.vegasvil.org>
References: <e4fa9680b8b939901adcf91123ab1778a0a7a38d.1643182187.git.yang.guang5@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e4fa9680b8b939901adcf91123ab1778a0a7a38d.1643182187.git.yang.guang5@zte.com.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 27, 2022 at 08:02:36AM +0800, davidcomponentone@gmail.com wrote:
> From: Yang Guang <yang.guang5@zte.com.cn>
> 
> coccinelle report:
> ./drivers/ptp/ptp_sysfs.c:17:8-16:
> WARNING: use scnprintf or sprintf
> ./drivers/ptp/ptp_sysfs.c:390:8-16:
> WARNING: use scnprintf or sprintf
> 
> Use sysfs_emit instead of scnprintf or sprintf makes more sense.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Yang Guang <yang.guang5@zte.com.cn>
> Signed-off-by: David Yang <davidcomponentone@gmail.com>

Acked-by: Richard Cochran <richardcochran@gmail.com>
