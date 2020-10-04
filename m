Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8087A282BD0
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 18:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726113AbgJDQXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 12:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbgJDQXw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 12:23:52 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E5EBC0613CE
        for <netdev@vger.kernel.org>; Sun,  4 Oct 2020 09:23:50 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id a17so3306545pju.1
        for <netdev@vger.kernel.org>; Sun, 04 Oct 2020 09:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oUQSoSPO21EbuPuKh75GX/Rd+Dc08mnc+Z+NRL+vV3w=;
        b=Fl3A2lzvTbHV7oSjPkcakNQqDdXmhd5222vI2W7BWqY6dW8eGg0Do35oRqJaPkLNsA
         c3SQYIHjqrQYrJlj44JNGvaj7ADqwIj5wpFXHtODGdW/4yqHViUEXuJj/4VHl/xFE6Zx
         uwOmHZFeqcybujyBbBThaX52dmWVhRmBv/wDWM8FCLyVfrTQnIABz6bV+jEX8I+Sw4ej
         /M627qmy/++s9cIOCctR+/HNi34MLcxDcHB0ptF5fXPYix7ofib8cdgpHqYvpjy12ruK
         rzNw3b0gFTo+X0i+lCWitGIKLFFgdcrDdCnw3aey3RYXoctoSCA7JxeVUJIze9x7Dqp0
         9NYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oUQSoSPO21EbuPuKh75GX/Rd+Dc08mnc+Z+NRL+vV3w=;
        b=KK7iGEa1GOdsaeb4QVLIyTb5J1nkv2HKPeN29FIpfI+Bma2pf7kZTbdDuS4ooWG5vC
         TZwoValA1s6977ZfvV+oNj+SAy2YNvn9Kj3vf/Ho/F5X3zcvkK1mIzXnmArKPlgnbYSu
         WSRYJIhJyI+JgODk3ldTxcOMy9G1WtPDHXJKY/zx6h+jdUn2oh2uvwYHfJe+TMxEZ6N8
         2IBSnl5u2VxQz4fQqvkF8uqHdtioHN2kYVh2YI4eOmr7OJJQ8iPEujv34uBULthx/qBY
         pr/T1w0bmKAXvcSYSf8rkmfeQcbqcLp/rQ4u+E2zfYsu2ZH4cIvmJBJz9B7GxbrOi1uf
         pQVA==
X-Gm-Message-State: AOAM530lNZ6Daqk3lAUfff9+fL0kcYB4fuWV8m8ZTaV4w2xrUdvQaq0/
        E/D+mpm4/NLFljQxh+jiGrg=
X-Google-Smtp-Source: ABdhPJxdJRVfh6Ql1kXjkDvTnTayR6kxdLuWh5tfyBD8Db/yUPVsXDxY4mSU49r3srQaLIqwb6GWgA==
X-Received: by 2002:a17:90a:6f21:: with SMTP id d30mr1932859pjk.165.1601828630086;
        Sun, 04 Oct 2020 09:23:50 -0700 (PDT)
Received: from [10.230.29.112] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e19sm9629137pfl.135.2020.10.04.09.23.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Oct 2020 09:23:49 -0700 (PDT)
Subject: Re: [PATCH net-next v3 6/7] net: dsa: Add helper for converting
 devlink port to ds and port
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
References: <20201004161257.13945-1-andrew@lunn.ch>
 <20201004161257.13945-7-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <63e189fd-1582-4973-3717-459d816285f3@gmail.com>
Date:   Sun, 4 Oct 2020 09:23:48 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201004161257.13945-7-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/4/2020 9:12 AM, Andrew Lunn wrote:
> Hide away from DSA drivers how devlink works.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
