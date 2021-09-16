Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83F4D40ECDC
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 23:45:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237959AbhIPVqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 17:46:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234847AbhIPVqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 17:46:21 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B97C061766
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 14:45:00 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id mv7-20020a17090b198700b0019c843e7233so2070368pjb.4
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 14:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ikOUL6YOn02Qmia+rrpsiv84X5lYgx0KaxaG/v5kJEQ=;
        b=PauLLa+gh99QSfkva/ZiJODxamTNLfD0BipyIX2x+oxAovS1s8Ebsp+ueWj/uAsFFt
         MQL4jg0wnv7+Lste7b+q5M5hcaGLvtHkGaSydc5XUv6lOsWuCZL+o2Ocm9JQca4E5bLg
         i32yDSnvv2FSmy40gYSytobBSZLXai2F/wY0OdmTJ8Ldz6Czzj7WahoeYC1URCjUnBvd
         efx8LXyU9mZk7oiKrjkccKxhkieE2voaSC81YxtwCKmNEKAq84UbZjmHf20RCTyafXWb
         cdGd/F57zsuqp1C0EIDHGlFEZZiR8dK/AsRq4sw+Zu7yrB7JR01t5jt8BGZ/cgWlkJ9Q
         7XPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ikOUL6YOn02Qmia+rrpsiv84X5lYgx0KaxaG/v5kJEQ=;
        b=EcWmQdrgX69N2SMH+3tGTcIrurpbCrIEIQQMZdkv3GaeGBl77DTh4DR4c2SVDewf/W
         iABCpLbSAxPe172YW/4tHwPrXJUWDC+x1pjH9Trxc9bRh07wViQJtGrGgX7H6Jm4i042
         jBMEBrK8nL03umQWm4e3+Pu7wvvRdwu8YMQjN/Ax5SbY7e9ymhGHyhFJhOVfpuXxThYb
         Kc++FEbHrP9/htbGXprPlabfye2pGiMl/LesdWYZKs1SEGdA80rVqfmUPedRFuGQihrP
         1aVw1HdNeDGiACXhxtOpBEBH/oTDUvrGPzEY4ap8ZBWNjLgG/0f/RX9jAMP5OwXMW+lO
         4nrw==
X-Gm-Message-State: AOAM531HBPDaaO3rkw5ZaHREkeP3QYwjwyS7ruXwGL8HPX7NSASSPTcj
        Ts7mCgt8OkL6HFVCUXDNq9g=
X-Google-Smtp-Source: ABdhPJy80mP4/JQ753iNahhQluB4ay6u70klXgpyDx6xKpMtxXj16GN5Kt38a1W6A/WSVhAPqTLgCg==
X-Received: by 2002:a17:90b:4d8d:: with SMTP id oj13mr17080104pjb.226.1631828700505;
        Thu, 16 Sep 2021 14:45:00 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id o14sm3110204pfh.145.2021.09.16.14.44.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Sep 2021 14:44:59 -0700 (PDT)
Subject: Re: [PATCH net-next 1/4] net: dsa: b53: Include all ports in
 "enabled_ports"
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20210916120354.20338-1-zajec5@gmail.com>
 <20210916120354.20338-2-zajec5@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <35e8f8b2-972c-b4bf-7aa8-ad1fc12ee982@gmail.com>
Date:   Thu, 16 Sep 2021 14:44:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210916120354.20338-2-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/16/21 5:03 AM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> Make "enabled_ports" bitfield contain all available switch ports
> including a CPU port. This way there is no need for fixup during
> initialization.
> 
> For BCM53010, BCM53018 and BCM53019 include also other available ports.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
