Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0CD485F35
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 04:28:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbiAFD2i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 22:28:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbiAFD2i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 22:28:38 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6E0FC061245
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 19:28:37 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id oa15so486738pjb.4
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 19:28:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=3VUlR7Sba3pTXWoEXyqmQ31MKd7ItvcEd/PEcjy5/zA=;
        b=i5WIPQ4TBn0Sz5UHcNU2/Ko/q344eHZS1s/jcTA63jDr/oKxLJmODGlX3jC1jlIIyn
         9J8kVpRkDri0StuVmKyfFzSZ93YmQ54MIa9goxraMI0NFH867Zrk2hrVywynwnnmnSRn
         CIRhCzgEppCqXzuKaOjancEjr9r/9y1me+zAf4AjCnl35y88hBs8D7YbzeaKcH2E/aUT
         FaGfFNSRlb1dRQT4SUmitKBTPiGkDG4fQQAgZCbSD0vQBdLAfxE2pmT+Xooh2ZR+JSQi
         8V/Ok9NKZ1sk91oQz/l/6Kz5pjrJt/6aroaKbe+19mAdEK/4Z+kFMrzQjd6vYpDsPufL
         PdwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3VUlR7Sba3pTXWoEXyqmQ31MKd7ItvcEd/PEcjy5/zA=;
        b=Wi0zKCDQVoNAKn2FCqoxGkaMOn9aVfqR6xSMhDLD7zLsmhNhKzgvoYmbkNBy7eOePo
         j/1fU9Os9BrxoBzW93urLXnz02HPzk2ZQem6iL/FXvrlPNHxuHKyP0LzWQuW0YOWZh63
         XQOmJ0j+yeXd14ZWeDggSn4Iu0/Y683ccdXGF3Kq/kU1U93kCits4I4HnscbrSd5ZZHq
         UKD1E0q4GEK6eLb7Q5nZuTFUEH2kc31hVHdHNtSwYSkD4hjoz+g+I8oW/UHzjDLzZaUf
         pdUcYw/kvhL7Cg0u9xNQt2yLf9atsdmd4btiQj8wO9x1z33jKr44gTqicIUWeSTjkuyU
         uvMg==
X-Gm-Message-State: AOAM532wbOVGsgtlV4cFH72V4JNkG8D1cP/Ky0UaVnzCjJouTiY5YIUj
        vKMZSOaRWA8/MBTr5RLqq7w42bL2L2w=
X-Google-Smtp-Source: ABdhPJxMAC6yqWhRs+Ux6Mcl8dDgXPJBCd9mALl9rlIwzfC11lhNqzInmTX+pSUG0yqxlxAEDa+BYA==
X-Received: by 2002:a17:90b:1e41:: with SMTP id pi1mr7800719pjb.151.1641439717321;
        Wed, 05 Jan 2022 19:28:37 -0800 (PST)
Received: from ?IPV6:2600:8802:b00:4a48:bd65:1cb5:9ad8:4f58? ([2600:8802:b00:4a48:bd65:1cb5:9ad8:4f58])
        by smtp.gmail.com with ESMTPSA id w4sm3956636pjq.7.2022.01.05.19.28.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jan 2022 19:28:36 -0800 (PST)
Message-ID: <8eab5365-45d7-4d48-ecc8-760e388b9e8e@gmail.com>
Date:   Wed, 5 Jan 2022 19:28:34 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH v2 net-next 2/6] net: dsa: merge rtnl_lock sections in
 dsa_slave_create
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20220105231117.3219039-1-vladimir.oltean@nxp.com>
 <20220105231117.3219039-3-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220105231117.3219039-3-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/5/2022 3:11 PM, Vladimir Oltean wrote:
> Currently dsa_slave_create() has two sequences of rtnl_lock/rtnl_unlock
> in a row. Remove the rtnl_unlock() and rtnl_lock() in between, such that
> the operation can execute slighly faster.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
