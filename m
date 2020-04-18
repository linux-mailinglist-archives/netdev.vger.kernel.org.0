Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F09CE1AF512
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 23:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbgDRVJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 17:09:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726014AbgDRVJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 17:09:36 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7581C061A0C
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 14:09:36 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id d24so2414469pll.8
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 14:09:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=htnd/tpTBRKw8O529djAhayPoh02gn92EDLM8d3I3EE=;
        b=rI5awVDv7m4ircUalOALGFtsSS5W3eDxfbStYwbZr6zzUU30Dma2IMssUGZ64DI63N
         d/lw52LU07o5Icz7NPabsR4s3QdP4jL7PkcrzKJqF5YfM72M6byiziqp6h9utKWPQI9g
         LzXUtj6OliwHwccuzFOVSozH7Zm/QeAlt5bju3UUV9YYwkFq/lEZ6jN672hkyjgCYJnO
         Vxw0TA+m513tR/qL2B0D5ulmVfbebR+aEMBB3eL/+lncM/7GwwrTs92P+t+UdLJpHYDC
         Q74p32iBome4Kj6U09NlfIXBgxqhD/R+y5LITtuCQMOn4bhbZ+oJSSsAMOFT5Yjkqict
         RlCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=htnd/tpTBRKw8O529djAhayPoh02gn92EDLM8d3I3EE=;
        b=aWiP5xT1GEbqA6gYaBj8ET0LvBBAAouYhD5PNgblL4dKx5sx5uq7kBRc4F3Wl9w96P
         7+xATdsibpRxHTYOnxHkv7fcTtPVyBLqGbLb4l+B1IaYpqoaV0+14NVRLkrIWL2AQKoq
         C5lJ0OxN9BZoRfuw5OxQF8TDFSkwfJrrNN6z3chGWXBaJoyEOIm182wqFQcT9CUNHZuv
         Lp7p+bav+5VkEzFDOmL722zVwaNMQPWR9DBu4DxHLzAHYgU1Xq6E6hZkDd50HIkU4J+8
         pgE/KJL/OjvL5LfHTQ6Rowh4sZ4ckgs3bDZJIdApLNJGOqjVmPLxO4NklPHLOp+cewQM
         KXNA==
X-Gm-Message-State: AGi0Pubu03AdnkiXNGq4/BmNVUcf8CvT5FIaiJZzKE2HP4FeEXhf3leP
        oiTuf0gyS0pR8kEtvsj5qMFEQjLo
X-Google-Smtp-Source: APiQypLaJoW9dKBRSq3wcf1v/xJbyOuSvrouiEHy3ORzXwqV6c2r/NpBz+01xkFpAUjOL8JxSS208A==
X-Received: by 2002:a17:90b:1953:: with SMTP id nk19mr12189363pjb.16.1587244176339;
        Sat, 18 Apr 2020 14:09:36 -0700 (PDT)
Received: from [10.230.188.26] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s66sm8523233pgb.84.2020.04.18.14.09.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Apr 2020 14:09:35 -0700 (PDT)
Subject: Re: [PATCH net-next v2 3/3] net: ethernet: fec: Allow the MDIO
 preamble to be disabled
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>, fugang.duan@nxp.com,
        Chris Healy <Chris.Healy@zii.aero>
References: <20200418000355.804617-1-andrew@lunn.ch>
 <20200418000355.804617-4-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <733512b9-aa39-2a4f-6b01-b12823eb92c2@gmail.com>
Date:   Sat, 18 Apr 2020 14:09:29 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200418000355.804617-4-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/17/2020 5:03 PM, Andrew Lunn wrote:
> An MDIO transaction normally starts with 32 1s as a preamble. However
> not all devices requires such a preamble. Add a device tree property
> which allows the preamble to be suppressed. This will half the size of
> the MDIO transaction, allowing faster transactions.
> 
> Suggested-by: Chris Healy <Chris.Healy@zii.aero>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
