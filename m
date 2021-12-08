Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C670A46C971
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 01:41:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233707AbhLHApK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 19:45:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbhLHApK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 19:45:10 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A890C061574;
        Tue,  7 Dec 2021 16:41:39 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id cq22-20020a17090af99600b001a9550a17a5so3167011pjb.2;
        Tue, 07 Dec 2021 16:41:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fgjbgS9vuw6/lOVuAJqfmyGi4NysxGzuXq2eCdBM1gQ=;
        b=WYOUkWyR6t/cC7TEkw0jbzOu0u2YWOlJfc1uKpSa1PHLTTGwe7a3E443ImJ1jAcqQb
         1gsRVKFZzdNoDVleqzLbtrGluaU90XAAxIFBzlGZtrtAYh+7PZjGGBCD6esst/JI1ziP
         WNO2EHfDqfcMDYbE7qOBbU9z/lJ+gGRqeuq6QXiSE7WLh1Z+qqEaJGSRABcWLtp0NJQR
         tG3ENC7cxZlIDq+xZDM1yLf2G5TEfLR1yMZQBn4HPFD8tuZuWXQU4kNzd/ZA4gWnUt2A
         WFLT4CcvLqUw9dXph6m8PPuWX0AsyTdLbZm/hCOGn1B2OR2eP9MYbupweMMgQKv31e7M
         /bZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fgjbgS9vuw6/lOVuAJqfmyGi4NysxGzuXq2eCdBM1gQ=;
        b=LgbDjpFE1A5viNTKbCTk00Bparr6NrkTKC4VkaKPFAEoaCEF90jxUAneoOsthsZVUV
         W7+Ma2HGxFlmbLVplTm6E+mcPXHLByqj9j6vUKpoh1i+IM/aemmvmbyoItI+fZD0z3WS
         3MbgCK90Jmmpka3hxwwYKgC3zOQIERnxj2rMDB+ElV/3GpEW1w0dEQ+kZD9RHyeOJond
         O8DokyPx+59SS3EkizRdBLhLipQPJb9mwDeKAagyIt7zec8abXW8y9OKOm/p6xdfQueI
         SlOpjkIxSf9/jN2+Axj0kq4hAbkCmoFJC4MsM6HmqQXF3dTIxur7jOK5gNLiUE/UJ/+J
         S4Tw==
X-Gm-Message-State: AOAM530JY7mJuaO9fuQKzSloy8kjXZI3A9wKGbF7phIbi4Dl2N4w2NRD
        bLohzok1YzhNIcwN2BDoAx2lsO56Sh4=
X-Google-Smtp-Source: ABdhPJz2txfuCDT/lN9EUD191Hd9N6i6Vvqm9k+NNPkltVBDJfJsuafFs72f2pB6KyAIlPh2Qo60nA==
X-Received: by 2002:a17:90a:43c4:: with SMTP id r62mr3135014pjg.86.1638924098769;
        Tue, 07 Dec 2021 16:41:38 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ms15sm642165pjb.26.2021.12.07.16.41.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Dec 2021 16:41:38 -0800 (PST)
Subject: Re: [PATCH v5 net-next 2/4] net: dsa: ocelot: felix: Remove
 requirement for PCS in felix devices
To:     Colin Foster <colin.foster@in-advantage.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
References: <20211207170030.1406601-1-colin.foster@in-advantage.com>
 <20211207170030.1406601-3-colin.foster@in-advantage.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f0c5ade2-65f0-17b9-7d12-7136a037aa75@gmail.com>
Date:   Tue, 7 Dec 2021 16:41:33 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211207170030.1406601-3-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/7/21 9:00 AM, Colin Foster wrote:
> Existing felix devices all have an initialized pcs array. Future devices
> might not, so running a NULL check on the array before dereferencing it
> will allow those future drivers to not crash at this point
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
