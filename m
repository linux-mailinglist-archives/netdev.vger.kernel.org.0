Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F13928DC6A
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 19:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728774AbfHNRy2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 13:54:28 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39487 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727791AbfHNRy2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 13:54:28 -0400
Received: by mail-pg1-f193.google.com with SMTP id u17so53452174pgi.6;
        Wed, 14 Aug 2019 10:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bykeZE8BCmNlHEXlGnRvq6Ot00PEYW0pXG06m1NWsOU=;
        b=K+aDcvpRMOpF3igF4pjSYIveLHcc1KXkwSCoadQIX2DFaKEWMI+vfJB79daC4MNQSC
         ISvZrp/x+f+vACHHpVepn4vDTFSfoHeTQ+TggXZGjGRyUaafguPpzppVzOHgQbWGhixU
         vxNP/YLtjeXvHh2o+aNMjClL/9/B/MaZbP1fYrVU1cmYyYX+1OvC254YtYaCRQGIf/bS
         Yvj3NieVka4nvTAlGWiJ6NuIbYP2l68c2HMaUR4H6mvUYGfrCGVK3qWCiTBen6iK14Pk
         pIw+sfUkw2hNlQlo2P8LCdGtzP00S4e0DTBVW5cimvcJp/hSaKKaEmEWBExLQ7giPGOX
         K4HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bykeZE8BCmNlHEXlGnRvq6Ot00PEYW0pXG06m1NWsOU=;
        b=Fp4objBNQI5W0miRgQfXzQ0DgqRvmeZtpEY1AiykFpUwOQltAIOdK8lJkO811Xr5zC
         RtAYS4FpX9ALTfdRwqyLBQUJXq03QVTY2jQGZvye3BQzlbhjlWNwc8gwZhK+hzd8D+x2
         waaoTbA8y9uEJsRt4RRPH3R7Me/WiTFF1zyjQi6AAb/whWlxib3mK+1Om/ZBRY9jwRK2
         sRUHuPFEnRmjlyBvy1BkLqkawpx6b1SlmSZJOG2aR1JDposMIy2ccaz5S9+UfWvQdDZG
         ttRIGul1UremOPkkR5LwG/e2qTfqe/Amde3J7mzDC1uXd/mh6IVV0gOMRMOhEIS/Cfpm
         lSyQ==
X-Gm-Message-State: APjAAAV4MyzpY8RqCA5RC1yS62OdvF3J7C0kyDhPqQH/2W6FYnV6zENA
        QHUH7zbhDgDdr4/oemycq/M=
X-Google-Smtp-Source: APXvYqwXaYv0laiV+LZv75ifYnMcC/YgpdEKv2m4f4Bvfmdjtb/GHTNV5jNZRKv4rKl2eWg6mfSvfA==
X-Received: by 2002:a17:90a:a00d:: with SMTP id q13mr878315pjp.80.1565805267599;
        Wed, 14 Aug 2019 10:54:27 -0700 (PDT)
Received: from [10.69.78.41] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a26sm416425pff.174.2019.08.14.10.54.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 10:54:26 -0700 (PDT)
Subject: Re: [PATCH v4 08/14] net: phy: adin: add support MDI/MDIX/Auto-MDI
 selection
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, robh+dt@kernel.org, mark.rutland@arm.com,
        hkallweit1@gmail.com, andrew@lunn.ch
References: <20190812112350.15242-1-alexandru.ardelean@analog.com>
 <20190812112350.15242-9-alexandru.ardelean@analog.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <ff2c2af9-fc13-e10a-896c-3ede55346203@gmail.com>
Date:   Wed, 14 Aug 2019 10:54:25 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190812112350.15242-9-alexandru.ardelean@analog.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/12/2019 4:23 AM, Alexandru Ardelean wrote:
> The ADIN PHYs support automatic MDI/MDIX negotiation. By default this is
> disabled, so this is enabled at `config_init`.
> 
> This is controlled via the PHY Control 1 register.
> The supported modes are:
>   1. Manual MDI
>   2. Manual MDIX
>   3. Auto MDIX - prefer MDIX
>   4. Auto MDIX - prefer MDI
> 
> The phydev mdix & mdix_ctrl fields include modes 3 & 4 into a single
> auto-mode. So, the default mode this driver enables is 4 when Auto-MDI mode
> is used.
> 
> When detecting MDI/MDIX mode, a combination of the PHY Control 1 register
> and PHY Status 1 register is used to determine the correct MDI/MDIX mode.
> 
> If Auto-MDI mode is not set, then the manual MDI/MDIX mode is returned.
> If Auto-MDI mode is set, then MDIX mode is returned differs from the
> preferred MDI/MDIX mode.
> This covers all cases where:
>   1. MDI preferred  & Pair01Swapped   == MDIX
>   2. MDIX preferred & Pair01Swapped   == MDI
>   3. MDI preferred  & ! Pair01Swapped == MDIX
>   4. MDIX preferred & ! Pair01Swapped == MDI
> 
> The preferred MDI/MDIX mode is not configured via SW, but can be configured
> via HW pins. Note that the `Pair01Swapped` is the Green-Yellow physical
> pairs.
> 
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
