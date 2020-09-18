Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BCE9270614
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 22:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbgIRUOX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 16:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgIRUOX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 16:14:23 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDCF2C0613CE
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 13:14:22 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id g29so4126390pgl.2
        for <netdev@vger.kernel.org>; Fri, 18 Sep 2020 13:14:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ThbxtXqUma3gWQ903tPi8ZeyTIS/WHTEcD14VikykXA=;
        b=Dn2Wi2FxaxspnTwBNZr0cOFje8+LT5r2K52eLSc1m1o9nmAietIE7Oxt7hy/77GNIH
         PTiTAHotehCvgWTcBQdVn2nOFPDABRltxG6MJIr3qF447cg4FlJ/eTuwG6ldribBy2uO
         nYJFWjDJfKPh1CYOsuS1+zzvpQ7ie4cLDML2rcdzti3jV/UoRmB2q/3BQ5mtECh9OYvV
         8Qlf2nysvPN3LcqVaQ3q9eBrQWHr5BV8Q4xBr/5Ob9PuE8Hm69zjLgT8YD/95/0SOxKU
         /cqB7qQyAbYVpN5WIq2nZ0BwpbDinFUQMp9UYLfMJXrsNrugCxmQd/UOJJDOW+ePukFu
         EnIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ThbxtXqUma3gWQ903tPi8ZeyTIS/WHTEcD14VikykXA=;
        b=UIW39WDl5uISZkPH72ouaGXOYERAvKO92EBUWSIRVCzJKquuPSuAI8M1OcyQT5MOak
         orXDd0Oe5q5gNwyXYRyXEyvP6MYcFjtqdr7MTH2SdqXFMhU1ZfXc+191p8ndGMtWhf1g
         jel8Bsafx5DnBmDgLu+zd3z7kaNtCgiI7ko9GBMSu0dQqHiJwr3w77PoSk1+w+6E03Vw
         vNJPBVOTa4M9QyaTpR4uEekRDgftZxyYx9mW+cBpCw1hWlP5m82tB0LO+KgOQ2dZeREV
         vGVs2hfz7oP0PfKxjwcODeAKqUrIALmzCPTj9BTPPiIfhBp7s92wnP+98msJFkyG7Ciz
         wzNw==
X-Gm-Message-State: AOAM533TZ8IXC2+X5PLcBcBH6U9wg9c1Ea+jrjELgMT3IOWjVZtMmT2w
        I+fBPbbbjTi6DEsVctMxMfs=
X-Google-Smtp-Source: ABdhPJwAGZK4RDn5dPHEDPVzx/Z6d6SmLOh6jXxUIhZLcGwZq5rtBRJfmLbImX8fu2AwCuaAEQpQMQ==
X-Received: by 2002:aa7:8249:0:b029:142:2501:34db with SMTP id e9-20020aa782490000b0290142250134dbmr17886141pfn.52.1600460062344;
        Fri, 18 Sep 2020 13:14:22 -0700 (PDT)
Received: from [10.230.28.120] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v205sm4311782pfc.110.2020.09.18.13.14.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Sep 2020 13:14:21 -0700 (PDT)
Subject: Re: [PATCH net-next v4 2/9] net: devlink: region: Pass the region ops
 to the snapshot function
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>, Chris Healy <cphealy@gmail.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Vladimir Oltean <olteanv@gmail.com>
References: <20200918191109.3640779-1-andrew@lunn.ch>
 <20200918191109.3640779-3-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <2806d622-1435-d9a6-3261-eeeb714b843d@gmail.com>
Date:   Fri, 18 Sep 2020 13:14:20 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200918191109.3640779-3-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/18/2020 12:11 PM, Andrew Lunn wrote:
> Pass the region to be snapshotted to the function performing the
> snapshot. This allows one function to operate on numerous regions.
> 
> v4:
> Add missing kerneldoc for ICE
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
