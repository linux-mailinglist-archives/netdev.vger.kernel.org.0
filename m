Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 237D4214F7C
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 22:44:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728274AbgGEUoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 16:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728223AbgGEUoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 16:44:15 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096FFC061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 13:44:15 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id w17so67820ply.11
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 13:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=F5+5G26i45qG8jaifgW9l6DOeilU9B5tFAjGi/I1sDk=;
        b=OZjjrTfGGBqegk04u6rHrOqG5xRLJ5AYgLfmcdutwOHKwXvOQC2qDrY4VhEYvtQ1id
         y63uEdrkW/d2kc/JIgowWTDxU0faH9b2CM5Or6Swi72hHCBOHsIjk9DN4zXSLnxzfhIk
         f1oH/YExRilAM10/626J3WdDxqBEcDTQNQqwtFHUOsWCNrrDlVzZ+VJoZhNCbWhx7jh7
         DFUB/MRaBatb+RHvDQNmnGdYzrOqiDeEkvEj3/EjuKudnYg2YNeJUrjXeVhPEgM5AqBi
         rV1cQo02dOv5NG7hSOJX/zz3RqqE8XwgWJIsOCGqtyYz5W2kGWlKe8vymxmbTY65sXIU
         uSAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=F5+5G26i45qG8jaifgW9l6DOeilU9B5tFAjGi/I1sDk=;
        b=Vixoc1ibGtB6tLzyP7pTITbbhXq6voeG3fGZY8U0nXs7fUI1Zek7RxKnrbLVDj38UK
         g+HJLjtKBEFRQnblP6yiJ5FslE76wyaY7AcnC2kyknCDLjRSVKrK/jf8r6gWEqypGxd/
         v1ReEPeB/5vdgi9gqcQertplEwflzdc8m8jMr1JYA84W1xA8Wkfjo9p0dMlEAkbCGico
         AqrsGMP0R4s3ys5AUmR0rfkJRq9AH2gtA8Pgut/sWrpkywZX7MuaNY/vrQ6t/DWwzVDh
         1hNFxr/eShD9xopTva0LyozGSy9l9P1AaD7Xs3yDOqlgfdi3Op0EJGAwhSw24Ks8c4/X
         YGFw==
X-Gm-Message-State: AOAM5305FJinTlCgAfdSzBpcdt2qeKikGeaVAYa+5HJmuVGcUx79IChN
        NaDT5C04yhKDhA/4lk90b1E=
X-Google-Smtp-Source: ABdhPJyyq6IWec6mnAJ6YpwZrKQ3IbLtO2A5WGOm9EbatsvUXZ77wCKBYXfr3d0/CMBb9CA879IW8g==
X-Received: by 2002:a17:902:e78f:: with SMTP id cp15mr39940402plb.41.1593981854585;
        Sun, 05 Jul 2020 13:44:14 -0700 (PDT)
Received: from ?IPv6:2001:470:67:5b9:5dec:e971:4cde:a128? ([2001:470:67:5b9:5dec:e971:4cde:a128])
        by smtp.gmail.com with ESMTPSA id w64sm16749998pgd.67.2020.07.05.13.44.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2020 13:44:13 -0700 (PDT)
Subject: Re: [PATCH net-next 3/5] net: dsa: tag_lan9303: Fix __be16 warnings
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <20200705193008.889623-1-andrew@lunn.ch>
 <20200705193008.889623-4-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <846a8266-c2a8-a7fa-e3d6-ffd51751f817@gmail.com>
Date:   Sun, 5 Jul 2020 13:44:11 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200705193008.889623-4-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/5/2020 12:30 PM, Andrew Lunn wrote:
> net/dsa/tag_lan9303.c:76:24: warning: incorrect type in assignment (different base types)
> net/dsa/tag_lan9303.c:76:24:    expected unsigned short [usertype]
> net/dsa/tag_lan9303.c:76:24:    got restricted __be16 [usertype]
> net/dsa/tag_lan9303.c:80:24: warning: incorrect type in assignment (different base types)
> net/dsa/tag_lan9303.c:80:24:    expected unsigned short [usertype]
> net/dsa/tag_lan9303.c:80:24:    got restricted __be16 [usertype]
> net/dsa/tag_lan9303.c:106:31: warning: restricted __be16 degrades to integer
> net/dsa/tag_lan9303.c:111:24: warning: cast to restricted __be16
> net/dsa/tag_lan9303.c:111:24: warning: cast to restricted __be16
> net/dsa/tag_lan9303.c:111:24: warning: cast to restricted __be16
> net/dsa/tag_lan9303.c:111:24: warning: cast to restricted __be16
> 
> Make use of __be16 where appropriate to fix these warnings.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
