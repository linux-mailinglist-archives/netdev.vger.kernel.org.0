Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 900A92CFFEC
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 01:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbgLFAYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Dec 2020 19:24:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725784AbgLFAYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Dec 2020 19:24:53 -0500
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com [IPv6:2607:f8b0:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF5E6C0613CF;
        Sat,  5 Dec 2020 16:24:12 -0800 (PST)
Received: by mail-oi1-x241.google.com with SMTP id h3so11026647oie.8;
        Sat, 05 Dec 2020 16:24:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ozoOEGyXNAJPWGG/Kv/VpUBzoqD5amv+PBFTvR4oIGU=;
        b=V2GXwAnRwkd7DQuxKUi6KY52LNEvDSzMrdXyk5ykHgFrDfIug2s0+erW5wVyoRQR5D
         DVM1pFySD1n5zPmS7uNOFC/+Qda0PZKS/bUDg8X/IpUsis/J5qsNqx5BTt2e6OW6f8Wl
         YOOKKv6dnxFc4ZPYnlPTANLPUyXNuHB1merK55jgHF9KLXj43VPvJwgOjEWMwVB8iNvf
         2ez2TkrhxjaDBapAyjiwI3A8Ks0a5VtaphDhecaDttojklrj+REWhDXrz6uBY0aVmnrR
         R+gYuU3fEQqm0nuCkHT/9o8B+8xjJRK95krvWk08VZzGdKFsX/QockNxXl13cPNIt+sk
         fIYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ozoOEGyXNAJPWGG/Kv/VpUBzoqD5amv+PBFTvR4oIGU=;
        b=TBzPCltvVbptoHrS6Rzq0d36FBfL6NaeXPiBtQG3tppUn76/RpGPZa+byGTl4p1sRe
         pFnmCFWAjXDfqho2ym9IqHLUhuKv4L/3k0TMB1J5wnxR7wkBa4h0u+z9CjnZEtYUuaMZ
         sB4upzjBHEl9Jx7EwCOWkr7ADsF68fTaEuXqG7+9InGpFGkVgzRz7DoMYTkOoAiWalJI
         JNk15iCaMZ9o9xfQCGMcDqSXRQbAWwNRyzpasuL2KYNs5JhPNSBn/cjFpi3TVrUFSTze
         D2c5YE4LnfUIZ9W7NEimfDeJFqy+0oe42JHWnTnjjgiIToCIagwDeXqb7NwFAj/TeBn2
         4SAQ==
X-Gm-Message-State: AOAM5321H979PTrpptrW7tHKT4lwKg+7gXVFLnYGNuCx4/kMbvQSXRjD
        m6KZEU531bzuF2D4pyJ86OUh0OJaDvs=
X-Google-Smtp-Source: ABdhPJx/Ecgi7gj61cm8Z6U+yShJ4+mobMZavq+zzJyD0QSQmwY8zY9j35WuYSlTunGP1owbLSoOog==
X-Received: by 2002:aca:4c4f:: with SMTP id z76mr7855249oia.1.1607214251955;
        Sat, 05 Dec 2020 16:24:11 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.51])
        by smtp.googlemail.com with ESMTPSA id q3sm1666069oot.33.2020.12.05.16.24.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Dec 2020 16:24:11 -0800 (PST)
Subject: Re: [resend/standalone PATCH v4] Add auxiliary bus support
To:     Dan Williams <dan.j.williams@intel.com>, broonie@kernel.org,
        lgirdwood@gmail.com, davem@davemloft.net, kuba@kernel.org,
        jgg@nvidia.com
Cc:     Kiran Patil <kiran.patil@intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Fred Oh <fred.oh@linux.intel.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Dave Ertman <david.m.ertman@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Parav Pandit <parav@mellanox.com>,
        Martin Habets <mhabets@solarflare.com>,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        alsa-devel@alsa-project.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
References: <160695681289.505290.8978295443574440604.stgit@dwillia2-desk3.amr.corp.intel.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a24b3044-1379-6331-c171-be8d95f21353@gmail.com>
Date:   Sat, 5 Dec 2020 17:24:08 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <160695681289.505290.8978295443574440604.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/2/20 5:54 PM, Dan Williams wrote:
> diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
> index 8d7001712062..040be48ce046 100644
> --- a/drivers/base/Kconfig
> +++ b/drivers/base/Kconfig
> @@ -1,6 +1,9 @@
>  # SPDX-License-Identifier: GPL-2.0
>  menu "Generic Driver Options"
>  
> +config AUXILIARY_BUS
> +	bool
> +
>  config UEVENT_HELPER
>  	bool "Support for uevent helper"
>  	help

Missing a description and without it does not appear in menuconfig or in
the config file.

Could use a blurb in the help as well.
