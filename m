Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5441E4A43
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 18:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391230AbgE0QdM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 12:33:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391190AbgE0QdJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 12:33:09 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C4FFC05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 09:33:09 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id r15so3700973wmh.5
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 09:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FlX8Z5t6G8I+11CgcSzWPtGQTGfakoDEmJDED3H+f4Q=;
        b=OoGiKSM0dwshE965Ps/UdnDa8HJ3EdjpUjK4zwxss7THTuyNI/wji2cn0AwKWnyM3K
         lhsxJWSrdxZKsmI4jLx+JlY5ESrybf/ipNz1ZY2/q9ulCmftBfqwJEMKeQfZ+QYT+0LJ
         KHETDcOPvVQErd6+oKJm1DGCTzjVQZ4LMHsUJZd8yXU8+/tJxSFh29jMngOGbOTzEjX3
         NUkgEkca6Qb1bhKw1iafWjGNLKJS8nsydB54wf7yD5uyfffiG1IQ0R82z//FJxP8GyPT
         q3A5HOtW7pfdOdjkpVKticcakTqGsuCjQUqM6+IHjurWRQXrOHZ6JsU852pbsMXetyUu
         w9vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FlX8Z5t6G8I+11CgcSzWPtGQTGfakoDEmJDED3H+f4Q=;
        b=bO37hQsiYB3lAtkqHUEkFYGUaX9Szejslg5uEJwvVpp0SJBp9amI6qMxmjhteTTpdx
         0c7wLGyrr4MPZXtJ5qyafc0JxmCUa+NpIbdudi+1Of0D9wtgatuzxjLweR93VLgT+5WX
         MiFNfhWwE2bpkxe6q5GL6kV5G46Kv4mBLhdgGvFKmppRKk6qbCp3QQt4IdjYGky1tXuY
         OBr8Cw01FrJtx+l0RP98p6sjiOmF8K6DChzWVKAVlgbX0fGCVwG2jnY/OwAp4I+jX6uJ
         2HgCssabf6rPgiG6esUzlkIJxcTdRDIaV9icHUv2S0fcL0z1IWlKNVy9nvJMgSY3TcVM
         zMuA==
X-Gm-Message-State: AOAM531PD/xmmSzdAL8Y4xdJQ6qzVv4OkqQwKqTJ69JagYbkqcO4aUNG
        hw31y1xvDODSHvnsK35Vi+32wMuQ
X-Google-Smtp-Source: ABdhPJxUbSrUHeedhfhSCvOGi70WLk3X+HGRUkCF0WgovzajgcIVb8cUhw1kRJaGwUQ1/DC091s+og==
X-Received: by 2002:a1c:a3c1:: with SMTP id m184mr5450216wme.91.1590597187999;
        Wed, 27 May 2020 09:33:07 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id c140sm3234852wmd.18.2020.05.27.09.33.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2020 09:33:07 -0700 (PDT)
Subject: Re: [PATCH RFC v2 4/9] net: phy: clean up get_phy_c22_id() invalid ID
 handling
To:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>, netdev@vger.kernel.org
References: <20200527103318.GK1551@shell.armlinux.org.uk>
 <E1jdtNp-00083h-L4@rmk-PC.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <23b33202-a512-e818-d611-a606fc2ce859@gmail.com>
Date:   Wed, 27 May 2020 09:33:04 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <E1jdtNp-00083h-L4@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/27/2020 3:34 AM, Russell King wrote:
> Move the ID check from get_phy_device() into get_phy_c22_id(), which
> simplifies get_phy_device(). The ID reading functions are now
> responsible for indicating whether they found a PHY or not via their
> return code - they must return -ENODEV when a PHY is not present.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
