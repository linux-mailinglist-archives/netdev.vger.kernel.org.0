Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 411E0235A79
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 22:23:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgHBUXj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 16:23:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725925AbgHBUXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 16:23:39 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12841C06174A
        for <netdev@vger.kernel.org>; Sun,  2 Aug 2020 13:23:39 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id e4so6587291pjd.0
        for <netdev@vger.kernel.org>; Sun, 02 Aug 2020 13:23:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZG+qVnk5kaIeiYRlgYuRrktNon7ayt1TOhFc5tWmj6g=;
        b=YYi9boFTScp3VkxuOQ0s58fEmJ41PpHjjUKvFTbRR9VEElFokXSfKZH4tNEgCDvYen
         WrYuTXh2CH1VPLaVKzvnxhxsH+wUW7Ai7B1J/ZKHsQT3NGxkdkVvlFvwTiDtYgRmQuAQ
         TmiR/ltUMQCyKKgafjLOBPbGrSVi78WoJsOVdZ9gaIlCo+B6+SbNepZlKeOLNCo58N5V
         6aZ7r0stfRVtSEM6OKgPI9Q/Rmd8KTi9Up53QrsWlwcbLQXUuJPHJ9oUUd2Ih9u6D04G
         xyylP8mkrPV3mnIe/RW6GnwNqoWCaQr2c+HFYBWViZucTsXjjrIWNz8z0GeyQ6D6XRsq
         w7IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZG+qVnk5kaIeiYRlgYuRrktNon7ayt1TOhFc5tWmj6g=;
        b=hhUkEUdy4fmzYtfjMGTS7CNi/VFX+LyNEp6JHpGsZt2ThyJs+WwLlyVIgwEZ4Ut1+4
         FluVZN6sh5hCq385u2xcsTVvyGgSyjUtJdpritxBb0MtOOJN53/viDUVlyuHIhd/qqiz
         5qfZtweljPVd0bmuDUawSIkideSmH//Vw2/hk5O/3Ne+RLIzWp63BpglB8xxcHWz8KkU
         oAzRa7ssCOUlgKinQ1iwQiNaL0wtJo1PBaHyq0xaHFZvZ7o3cv922DhRgphuXeaL5VzB
         Y9PCGdsKvmIvGgmRBOKhanQT3KzKmEaZuibbNUC+h54I/2RY5fGvkV50hO1hdiK2rNy8
         eoGA==
X-Gm-Message-State: AOAM533r0K9OOuXQxTIF4hINyFKurpQBKNxkgrrK6JX7CLbr0V6hCEpv
        e6SiCjAVG1esMwZVLFJ4CWk=
X-Google-Smtp-Source: ABdhPJxuXHSFfOnsIKcSuezBfVZTflpcqijkfPY4hjAqE63bMvCTx6RGdh2chXrnoVPxl9UVjOWvvg==
X-Received: by 2002:a17:902:a38e:: with SMTP id x14mr11406587pla.231.1596399818618;
        Sun, 02 Aug 2020 13:23:38 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id v66sm17219471pfb.146.2020.08.02.13.23.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 02 Aug 2020 13:23:37 -0700 (PDT)
Subject: Re: [PATCH v3 8/9] ptp: ptp_ines: Use generic helper function
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
        Petr Machata <petrm@mellanox.com>
References: <20200730080048.32553-1-kurt@linutronix.de>
 <20200730080048.32553-9-kurt@linutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <951c3f3f-eb41-2610-94cd-9e3e9a68d5e9@gmail.com>
Date:   Sun, 2 Aug 2020 13:23:36 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200730080048.32553-9-kurt@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/30/2020 1:00 AM, Kurt Kanzenbach wrote:
> In order to reduce code duplication between ptp drivers, generic helper
> functions were introduced. Use them.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
