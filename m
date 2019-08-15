Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF978EF8A
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 17:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730300AbfHOPjz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 11:39:55 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:45676 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728128AbfHOPjy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 11:39:54 -0400
Received: by mail-pl1-f195.google.com with SMTP id y8so1196838plr.12
        for <netdev@vger.kernel.org>; Thu, 15 Aug 2019 08:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=27bQjH6anEhTOTvvznwy36TXhvLaxpGnK5Jx5ligDW8=;
        b=EzWIhS8UlDSsoHDgKE7JYRjh9rew36uL7R+6+5M+KFdh7ukyEQUZ2Xk47Oz3cXvMZb
         LK6z/VpjowWWBGZufmc65gfug2c4wQiOTYSNsh+KKsKdFYJ4FqHq0vrJzVS/pGRsLjUo
         RZYGmmQGcFwTSrs5ewRGdS278esqzJk8aF6wyl1O0HAk6l/gvrfhKaNm3kE1vbMFu5vM
         fbCUH32CpOmGzPZV84FDUwnAaP6SHmdziLRg3e9NS/ts7X363HLjq3CUN89Hus7WawRE
         DDssKn4oA9/jKRPj+5lYWlzwBGKuG2A4b/sVA7QmtiQCo6T7VWiRyVw+zHHHoQP3ocRh
         zY4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=27bQjH6anEhTOTvvznwy36TXhvLaxpGnK5Jx5ligDW8=;
        b=iTJPhFXZpXBOTz6Xr9uN2I6nFZVyu1MawgLQQQU4pc+Tf38CbZBRyvHXKI73G2A+hy
         dTNI2Sku74fMxTwFkI2S4mUN/65NB73JFkqyW3uZyORfWtN84RITR9c5qpCW5CnCG4S2
         vfMY5GfRdQtdsyXwBeAtczJYWV6XN+VqBwl3HuPaMIzeSXRkNKwNJkA5dOpvHS58Zbj9
         AMrTP1s1WcvnCRhhOnr1c2L+qLsliIT2Y4wVwYTHNLvH2SFqIgwRpJl0r1qSwKAo/4Vu
         h5gvBsyz9IBxuffSHgVMFWta15Kbv90+Dsx8agw+7ungZBJNK8FN+SfjPg++wKYKAUcE
         gX1w==
X-Gm-Message-State: APjAAAVv2nIc9CRR0R5aj6G/Shpk8iByd33+CUQ2D261C6Jv95o++360
        2+N8Ah0EMiQvTxLKncFIrjd2T0Pg
X-Google-Smtp-Source: APXvYqyQYRzdKpC4FBD8SPq02UZGw0IP5fbgmXe0x3LINjqf5o3z/wdl9Wku4duOIt1+ghoj/va50A==
X-Received: by 2002:a17:902:1024:: with SMTP id b33mr4940943pla.325.1565883593888;
        Thu, 15 Aug 2019 08:39:53 -0700 (PDT)
Received: from [10.230.28.130] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x17sm3150703pff.62.2019.08.15.08.39.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 15 Aug 2019 08:39:52 -0700 (PDT)
Subject: Re: [PATCH net-next v2 1/2] net: phy: realtek: add support for EEE
 registers on integrated PHY's
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <88a71ee7-a17d-ac9c-c998-d0ea35e5c566@gmail.com>
 <b9d96a3b-8301-fb4f-c7f5-911c964c15cf@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <009228a1-c7a1-6cad-b18f-d97379200766@gmail.com>
Date:   Thu, 15 Aug 2019 08:39:51 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <b9d96a3b-8301-fb4f-c7f5-911c964c15cf@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/15/2019 5:12 AM, Heiner Kallweit wrote:
> EEE-related registers on newer integrated PHY's have the standard
> layout, but are accessible not via MMD but via vendor-specific
> registers. Emulating the standard MMD registers allows to use the
> generic functions for EEE control.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
