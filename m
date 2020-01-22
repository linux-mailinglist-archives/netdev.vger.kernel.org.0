Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61057144AAC
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 05:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728890AbgAVEFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 23:05:00 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37771 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbgAVEE7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 23:04:59 -0500
Received: by mail-wm1-f66.google.com with SMTP id f129so5679933wmf.2;
        Tue, 21 Jan 2020 20:04:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QnP3I9MQH2rjvN4odqaiJfYKIdwE2UEnGytQrH/isCo=;
        b=uhsGKyNygZhXrZu7vjW5rzhzl2zOR80ETGG0fo6Wx++dxDeZPl5EoBK2tzjxMJjxOd
         LeCOLr3vGDWeAVm06DUuLADW5K7S2/+mHDDLpGgRO0THcQL9JHtv7u3BvEBlJr0jP7Ak
         BE0RqXczHjodZn+Vo8L+XL/tls839WQqTk5qM/cWm6LihNu2HGaeeTmQ7BPScl7wWilc
         BaHpHzEbnqUYBFufqdTq8c+gHF7PTC94LXv6YhCXMiIXkJPB8Cb5UrHI5ADMRLjA42zo
         nLMeVAii95vUSkdWBg5b7poNaR1WUrM6yM2b2w7gN2l1Z0s8bZCpIZe+3tTbA8O4xFEI
         DIxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QnP3I9MQH2rjvN4odqaiJfYKIdwE2UEnGytQrH/isCo=;
        b=gQaCzv6aWjELWXkrgEK24S3Tjl5+IBQ12gU4A6zdBh8uRy5OPuhBDRAzhgMvdAOKii
         shXS4SLA9eKbP/4cGU9/DMlJS311r6FWvCXYS5oJDRKyUBBu5w8YySU5/sFXs+LFMSxL
         WAs0ApO+MYFFoWSLUMQweLD31Rljn7jLlnpn6UPJfNGXh/hiNlVVCA+cLsK3MW1GnKOP
         0JQgHk6NJex9yZWw1S5WuwB0bXUFC9R29kRXQx+wHEy7bdlk2NxdbqKwy27nQ5aRQ8+J
         ZGW5xCrk5jHuxnRxsfGBkica5ZaRY2A2z1pvHnVIBKJrq72XrhFGkuKhY8qxuvczYZJ2
         AHag==
X-Gm-Message-State: APjAAAXK1xVqcm2IBY0B64HlJ+8P8+j+uT9Ca6GrvsQrYA9RI/+TcuWI
        Q4hmg0ymMyFvvtpTEzc/Pfn0NVLG
X-Google-Smtp-Source: APXvYqy5KkRy1uXxqtjC4MyYoj8JskrPlSRfUong+9Z73j995d4xccxTBqgnHi3V+SoQVsINzFgxaw==
X-Received: by 2002:a05:600c:2959:: with SMTP id n25mr481678wmd.185.1579665897027;
        Tue, 21 Jan 2020 20:04:57 -0800 (PST)
Received: from [10.230.28.123] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m3sm53812768wrs.53.2020.01.21.20.04.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jan 2020 20:04:55 -0800 (PST)
Subject: Re: [PATCH v2 net-next] net: convert suitable drivers to use
 phy_do_ioctl_running
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        David Miller <davem@davemloft.net>,
        Maxime Ripard <mripard@kernel.org>,
        Chen-Yu Tsai <wens@csie.org>, Doug Berger <opendmb@gmail.com>,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Sylvain Lemieux <slemieux.tyco@gmail.com>,
        Timur Tabi <timur@kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Cc:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        bcm-kernel-feedback-list@broadcom.com,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        linux-renesas-soc@vger.kernel.org,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <2db5d899-a550-456d-a725-f7cf009f53a3@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <9d2dbcc0-7e22-601a-35f6-135f2a9e6f99@gmail.com>
Date:   Tue, 21 Jan 2020 20:04:50 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <2db5d899-a550-456d-a725-f7cf009f53a3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/21/2020 1:09 PM, Heiner Kallweit wrote:
> Convert suitable drivers to use new helper phy_do_ioctl_running.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
The vast majority of drivers that you are converting use the following
convention:

- !netif_running -> return -EINVAL
- !dev->phydev -> return -ENODEV

so it may make sense to change the helper to accommodate the majority
here, not that I believe this is going to make much practical
difference, but if there were test cases that were specifically looking
for such an error code, they could be failing after this changeset.

For bgmac.c, bcmgenet.c and cpmac.c:

Acked-by: Florian Fainelli <f.fainelli@gmail.com>

Whether you decide to spin another version or not.
-- 
Florian
