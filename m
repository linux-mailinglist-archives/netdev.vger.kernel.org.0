Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFD86282BCC
	for <lists+netdev@lfdr.de>; Sun,  4 Oct 2020 18:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbgJDQVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Oct 2020 12:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbgJDQVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Oct 2020 12:21:02 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A1DAC0613CE
        for <netdev@vger.kernel.org>; Sun,  4 Oct 2020 09:21:02 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id g18so2022033pgd.5
        for <netdev@vger.kernel.org>; Sun, 04 Oct 2020 09:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zn6iE3+055Vjc7mBLMCWeFh5wnSF/YRe2WMN+XXTBEM=;
        b=uyFgxJIlX088xoMagwr0sF+5r7RgopD4SK9HTj+PT30wefnQrSjSdwLzlpG6vwShF+
         5o45EcMhX5nl5ihBsk7u/2WLqVBcM8uYREx5hD6Mr+vQn+OAUt5h2dLuNd4zJM8lc2hI
         syJx+lGeZbdDJaLTj4PMrsIVlzLQ4juRl2XbwLoP+Y4uAJIsacIuskie23840PQxcqmO
         /DZtOXazzj0+pTD9uReLC1IQIPBF692fhCOP8Vc8x3CNQAGITC/PGK11D46zQO0Ua91j
         j9mkb6ea6Ir8ZFW1E3fV+RJtG0+QOIg0hdn7AbmnxBx10L4XMqcBrfdR2WGiT6Rch9+K
         iMjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zn6iE3+055Vjc7mBLMCWeFh5wnSF/YRe2WMN+XXTBEM=;
        b=HD72oy/U6PPIsKxFWJlbApPXGU8NAumowiWpoAYZOgZJZnTKMywC/y69YKXd55Hz15
         7zkfpcXxSySborfDCf8eKcU2i/0rIPBNg3C3vKa7MyrWpZnn0D9HUeujDpygUj3ssTTp
         KrUWpA4QPWNReJ87H8AlJzoTYXzMNcDYCBPNgDdS/CgezVZHMU4rZZ8YIMLK9T0rXYPP
         vn+ZPVpGXFn1BfLjCB2uT+0xeh35107d+ODIdwzRjElFIqZC9mBGbfthD1U8ZkjYCsFb
         b0OBsRAhCtMGhf+FECxkNy5iMyni4HBfQpxht2se8XB+MhRiNOAy5q+nLEZg+1c4i1Fx
         sFSg==
X-Gm-Message-State: AOAM531EhIIkcXfXvbv6ekjlA97qPLikcHSymltCnz/EGNCpOaMk7ZKf
        zuHnVDhPE3LX1SUUY+1J6kZMQkq3zpoWSw==
X-Google-Smtp-Source: ABdhPJyCJfZBnOU8oNQJlhZJCFCIrRNQdimQ0He4z8CkIfnZ14pVJWpxZCm8oWhimTYew3DjmVh7Jg==
X-Received: by 2002:aa7:9f04:0:b029:13e:d13d:a08c with SMTP id g4-20020aa79f040000b029013ed13da08cmr12536853pfr.35.1601828461448;
        Sun, 04 Oct 2020 09:21:01 -0700 (PDT)
Received: from [10.230.29.112] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z6sm7275980pfg.12.2020.10.04.09.21.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Oct 2020 09:21:00 -0700 (PDT)
Subject: Re: [PATCH net-next v3 3/7] net: dsa: Register devlink ports before
 calling DSA driver setup()
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
References: <20201004161257.13945-1-andrew@lunn.ch>
 <20201004161257.13945-4-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f9e2971e-e38e-a4c0-babb-cc5c2125f4b9@gmail.com>
Date:   Sun, 4 Oct 2020 09:21:00 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201004161257.13945-4-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/4/2020 9:12 AM, Andrew Lunn wrote:
> DSA drivers want to create regions on devlink ports as well as the
> devlink device instance, in order to export registers and other tables
> per port. To keep all this code together in the drivers, have the
> devlink ports registered early, so the setup() method can setup both
> device and port devlink regions.
> 
> v3:
> Remove dp->setup
> Move common code out of switch statement.
> Fix wrong goto
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
