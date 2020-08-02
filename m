Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5373235A72
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 22:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbgHBUUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 16:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726482AbgHBUUJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 16:20:09 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50701C06174A
        for <netdev@vger.kernel.org>; Sun,  2 Aug 2020 13:20:09 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id e4so6585328pjd.0
        for <netdev@vger.kernel.org>; Sun, 02 Aug 2020 13:20:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=x1cXNZGtJKJruWLZ3Fse1h87uR6E81XSKTHJ3T771XE=;
        b=pd06gA+wK5Vs+hjAal2fOd9UpkCj5bHluKBqJ6I/ehOBevc6VO8f8IHyVgI4av6/jf
         MIhOdmwsnLsIzALrqketNqjk5kPP/QzJ6NSbdn4L12AYNg/YirlnNoJltySq8fDFrSzn
         +Lgg2YPeDG74IOLkJcEYlQv8sGFSTM+BBNOQRKeoMQGGmsAs/2OmOMSRwL/JtWWLc19b
         arX+ylIgcWp8HxoF9eTrkCKaZKroIhEU/0Fr4WNdtK88F/SSxj8sVq/CgyJmB11qzQyu
         13cMk9xn29CfH7OjgyzrFdneByfXwdgNnJYIOcQT/7mfORlbeyTWsnBz+/ol8sU1YLtr
         ojhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=x1cXNZGtJKJruWLZ3Fse1h87uR6E81XSKTHJ3T771XE=;
        b=t9JvgkUF5ystPYalwssz4vceg/TiLg1UQLiZtNt87PuE9g8VkSERP9kFq0Wj+3twUT
         B3bInRwcAAczC4uO6+4PZR2BxUOo5dtzGXx9dIWgVHUYALoJDUaHLZV40JxUVpPcH2AP
         yU+g3dpPLSzRP0hqqkRUxPnE991OeGBF1OnUlwi8JBzv5bI2bFOycWJhB+GCLmXep/uN
         Q6OlsERNJwWeDdJNLEBt4e/KHcNfLGKyJTaIr8PTeUyM0smJavcPab+2j8Vw37PFftdD
         60ErSIgclUwb76+0uHvs6prk7t1dXR6ZUHCbLdRes9gF128y10iQtTgmTgrj5KfilPGB
         p9Zg==
X-Gm-Message-State: AOAM532AL89R+vAG2i8Sp5VAVUnqj9sYBWokN3V7e+Nc3fF58GGXAHDz
        MVeU890HUFl1zzkZEkrxSw8=
X-Google-Smtp-Source: ABdhPJz9e12E2cGfQmIE1Ak0kgG97oaqo47S8Yt5L6kKNGSVrvM2BMR/wWzd2Xi9xSHyPqQjHfSzPg==
X-Received: by 2002:a17:902:9a01:: with SMTP id v1mr7651712plp.15.1596399608865;
        Sun, 02 Aug 2020 13:20:08 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id p127sm17233257pfb.17.2020.08.02.13.20.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Aug 2020 13:20:08 -0700 (PDT)
Subject: Re: [PATCH v3 1/9] ptp: Add generic ptp v2 header parsing function
To:     Kurt Kanzenbach <kurt@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Samuel Zou <zou_wei@huawei.com>, netdev@vger.kernel.org,
        Petr Machata <petrm@mellanox.com>,
        Russell King <rmk+kernel@armlinux.org.uk>
References: <20200730080048.32553-1-kurt@linutronix.de>
 <20200730080048.32553-2-kurt@linutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d3ee62c5-6730-aeb1-6cbc-d749b8b0a5b7@gmail.com>
Date:   Sun, 2 Aug 2020 13:20:06 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200730080048.32553-2-kurt@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/30/2020 1:00 AM, Kurt Kanzenbach wrote:
> Reason: A lot of the ptp drivers - which implement hardware time stamping - need
> specific fields such as the sequence id from the ptp v2 header. Currently all
> drivers implement that themselves.
> 
> Introduce a generic function to retrieve a pointer to the start of the ptp v2
> header.
> 
> Suggested-by: Russell King <rmk+kernel@armlinux.org.uk>
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
