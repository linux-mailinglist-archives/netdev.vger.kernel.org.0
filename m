Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC7C38EFAF
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 17:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730870AbfHOPp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 11:45:26 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36608 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729975AbfHOPp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 11:45:26 -0400
Received: by mail-pg1-f196.google.com with SMTP id l21so1466642pgm.3
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 08:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bF2rA16ov1hkw3QlU/NteNW/ee5WtR0UEZDMvUSU4XM=;
        b=Imvu7jftpNvxvLD/l6xKmj3N8C8BD0vF40vXn44R/+swV5iHmm9qjNV5RHBkfsD+QT
         udc6NntXm8O999rbhjhTatfSFnRvmzVpw54LSg0C9Dy2JZSafumUG4o6VjPWLZl63Jut
         vohb9R/neZ5r98hf0X7lZiSAupKN7tk5jCKSBUrNSPYZCdMfeHSP0hJZaRK6kuvHacpO
         WBKiDy0gBVkft14zklT/rxqYCUHnt97J6OaI1dWdLaBy7VSL45oBx5PiMuXXV++VwR9G
         1Rkph0CwwQdzR86IvTVNucGKeeuYfvKKucA7liPUX9jydeJjGyaEEDyZ4zWTcOk2iahw
         7ZbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bF2rA16ov1hkw3QlU/NteNW/ee5WtR0UEZDMvUSU4XM=;
        b=jYowrjBiIapHNMbyWhOLDm68y4E3lr94x5iA+GG73smNLb4j6gLPBCUZE+lJIi9yfl
         I3LyzuBY7ywsonNOlzV6KNKtzVGPFXTvCj9oRvlIrw/PFhJVJLpjlDeAdYVdGz1xsakC
         2gubpgj0RYv94iDZIQIFf8boxYouGv+aDf/8CBRr5anrydFwuqoqIM6oUeKAPCy6VL/7
         inInmcsGMDorwEnwntkbp+ZkFdbwOrA0CHfUwFWO4cTXhwYG5w2IguXX8nxekjk8qNtj
         u63ZYAMLbTjIyVwdwM8NW92U5q+RXaWZween6R1vf2Ch1oBmRzk7KqafBYp4LfQOtelA
         YFiQ==
X-Gm-Message-State: APjAAAX5rYFa41jRqWtErVQ6FvPIBVHtW6ZkB8OPmTo86WEMDVhZONI9
        VUHhgQVJiII+gtAtTnWEZTU0c5d+
X-Google-Smtp-Source: APXvYqwWl+62Dc4Lsyz5A9nlrKfdq3qMnWn0yej+u2ZoO3Pc98mBwfSz5bI+YqFZUc3cSetDsBVQZQ==
X-Received: by 2002:a62:6083:: with SMTP id u125mr5991219pfb.208.1565883925446;
        Thu, 15 Aug 2019 08:45:25 -0700 (PDT)
Received: from [10.230.28.130] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e24sm2446572pgk.21.2019.08.15.08.45.23
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 08:45:24 -0700 (PDT)
Subject: Re: [PATCH net-next v2 2/2] r8169: use the generic EEE management
 functions
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <88a71ee7-a17d-ac9c-c998-d0ea35e5c566@gmail.com>
 <14f2831d-5f89-1345-5674-b25f7d95255f@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <e27620c6-a963-f4b6-2296-c94808e7ce83@gmail.com>
Date:   Thu, 15 Aug 2019 08:45:23 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <14f2831d-5f89-1345-5674-b25f7d95255f@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/15/2019 5:14 AM, Heiner Kallweit wrote:
> Now that the Realtek PHY driver maps the vendor-specific EEE registers
> to the standard MMD registers, we can remove all special handling and
> use the generic functions phy_ethtool_get/set_eee.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
