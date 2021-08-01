Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F389B3DCCB1
	for <lists+netdev@lfdr.de>; Sun,  1 Aug 2021 18:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbhHAQ0L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 12:26:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbhHAQ0K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Aug 2021 12:26:10 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE8A2C0613D3
        for <netdev@vger.kernel.org>; Sun,  1 Aug 2021 09:26:01 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id b11so13124579wrx.6
        for <netdev@vger.kernel.org>; Sun, 01 Aug 2021 09:26:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jkQ2i4n+v6uFFsrpGi7+MIjFv4KLYeIgFRlmb5kYCiA=;
        b=Fh88jDnaDs/CAA/a2n8hQbyx1msHdHxbU+YF8XLPI2Imb9YV9yLbL01x/jvMHUtRYk
         KqaQ7QD26lmKwWTKRuVeBGAjDNW59Q5ycH4bbXu20ZgYBuzLxqf3o1rY0skrLsUSPZrE
         YeDDMlJQHSIjNQzzYTdxHn3wdQnaMErXbezUKIVTLNc6YNwjM5oNHoZOsfS+/wZKzhPt
         wLU6tnr3KnjNk90N1sOMFrJ8xGMvfFjn8yoSR3RwYFKtJtnw7LwW7FkazgU1jaM0cf7f
         ji+ApG8GSwnayyBLFkqNKr0sa/200MAWuW/zozv+BuwPghclBVI+5F3jPcwB4JgUqFT6
         X9PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jkQ2i4n+v6uFFsrpGi7+MIjFv4KLYeIgFRlmb5kYCiA=;
        b=HP5GEEU9u0+q1bfUBdeYwdVH6MBd2pDjU7AaodOLnUtv4kQW9NgnIQFGKv80MYvzNm
         f5YhKEJ36bvVjeEcL68qcXd4bxpQimizAVA5hXih2F7ePMa5+Mg4XWh6lZgi0UnT37to
         9+Qba2NbD/L/cCKA2flMfJA5C+D1fonjsD36CQ9DpxlALpL/+gH1atHJlyJRznOGwg6n
         gUHJuJrpmFJFEYIl9dvrUeywFf1TsaJQEbHnlfF1t/sIRO1ZGyLiQtJYWLTokeBFjVOV
         fmmrKH+sQS8EWxvzD92P7qx444hU/nCtG7IOwYHSy88pyeru1RTNku1f8Gt5pmx+jZk0
         6jNA==
X-Gm-Message-State: AOAM532HE7kwu0J0ux1yfoqDaGVjJI2NvRZ2GI2ZTI99Gysfl2Gpdj10
        nn+O8OkRYzo9GLsfzDzlIBgYnKAiGwNSXQ==
X-Google-Smtp-Source: ABdhPJwzNcPQiYuiwL0Xp3b0LxrjfTmQNHUiYmTtHKA6MvRcR94fJRNOwyGwdTceIuaLboSXqZXEag==
X-Received: by 2002:adf:db07:: with SMTP id s7mr13906546wri.106.1627835159920;
        Sun, 01 Aug 2021 09:25:59 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f10:c200:9d9e:757:f317:c524? (p200300ea8f10c2009d9e0757f317c524.dip0.t-ipconnect.de. [2003:ea:8f10:c200:9d9e:757:f317:c524])
        by smtp.googlemail.com with ESMTPSA id a16sm8624267wrx.7.2021.08.01.09.25.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 01 Aug 2021 09:25:59 -0700 (PDT)
Subject: Re: [PATCH net-next 0/4] ethtool: runtime-resume netdev parent before
 ethtool ops
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <106547ef-7a61-2064-33f5-3cc8d12adb34@gmail.com>
Message-ID: <8bcca610-601d-86d0-4d74-0e5055431738@gmail.com>
Date:   Sun, 1 Aug 2021 18:25:52 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <106547ef-7a61-2064-33f5-3cc8d12adb34@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.08.2021 12:35, Heiner Kallweit wrote:
> If a network device is runtime-suspended then:
> - network device may be flagged as detached and all ethtool ops (even if
>   not accessing the device) will fail because netif_device_present()
>   returns false
> - ethtool ops may fail because device is not accessible (e.g. because being
>   in D3 in case of a PCI device)
> 
> It may not be desirable that userspace can't use even simple ethtool ops
> that not access the device if interface or link is down. To be more friendly
> to userspace let's ensure that device is runtime-resumed when executing
> ethtool ops in kernel.
> 
> This patch series covers the typical case that the netdev parent is power-
> managed, e.g. a PCI device. Not sure whether cases exist where the netdev
> itself is power-managed. If yes then we may need an extension for this.
> But the series as-is at least shouldn't cause problems in that case.
> 
> Heiner Kallweit (4):
>   ethtool: runtime-resume netdev parent before ethtool ioctl ops
>   ethtool: move implementation of ethnl_ops_begin/complete to netlink.c
>   ethtool: move netif_device_present check from
>     ethnl_parse_header_dev_get to ethnl_ops_begin
>   ethtool: runtime-resume netdev parent in ethnl_ops_begin
> 
>  net/ethtool/ioctl.c   | 18 ++++++++++++++---
>  net/ethtool/netlink.c | 45 +++++++++++++++++++++++++++++++++++++------
>  net/ethtool/netlink.h | 15 ++-------------
>  3 files changed, 56 insertions(+), 22 deletions(-)
> 

Patchwork is showing the following warning for all patches in the series.

netdev/cc_maintainers	warning	7 maintainers not CCed: ecree@solarflare.com andrew@lunn.ch magnus.karlsson@intel.com danieller@nvidia.com arnd@arndb.de irusskikh@marvell.com alexanderduyck@fb.com

This seems to be a false positive, e.g. address ecree@solarflare.com
doesn't exist at all in MAINTAINERS file.
