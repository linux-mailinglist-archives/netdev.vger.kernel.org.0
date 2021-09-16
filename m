Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E83040ECD9
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 23:44:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237083AbhIPVqS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 17:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234064AbhIPVqQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 17:46:16 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D91C061574
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 14:44:55 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id u18so7584966pgf.0
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 14:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nNhkyuKjI5tXvuO0GxWnGKDPFHuKELj6HwQch3Dl+cU=;
        b=RdCAqzew0hgwM7IJIodHAuIxcYYqogozZunJPZeCd4VAqc4icaBOKUdNqtLomMMsSr
         SYrxvgRs4Par89fJEqpPCDZ4+XLY7WO2ZcFStBbsxp22NnxyjT8XxsiXvmsWOLovl1S8
         eRYPwD9x1heK58J8sna040Pj1tVdCa5AjEIDSgdMZ+hUWzlxYrJN35KGXusUjSzFUnNG
         xjF0RiY+S9I+EecNi20gC3vYNw+5M2NwC8QmQ5XFIGfe7OG4swOXc7v6W8TbDOcVZu+F
         L6R4b/3/fMY7Kb4/qFdOJ7EeADI2gvjGoiU2Qo6G+0EHPzyyADa52HwUU26v8KbIqwFz
         OZVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nNhkyuKjI5tXvuO0GxWnGKDPFHuKELj6HwQch3Dl+cU=;
        b=rtTViMh6RG4EqnQmK1Rn5miCms85zBRkPq4kKJZEywCuoeOIVdYxbu7m0QlEDuZDA2
         X5qYa9874tyJ4w+NPITTHSiUgozyBWhttMp4AKe7EZ0aELMAiiYcjK5EDXwQaQrEu7B2
         Giq6KJZeEGdMZ0LvD5ESVP1vaiWsyVRzpPyfWpuMCH4hVHjAI8lCpYK8z5INc3ViIBlX
         fuSkioG42T1Xf1OEW7/zfmlHGmn27tYW+/2FjsGlsAYf04wnYz0mOYoPuIxOSjYJz/MN
         Tebxl5G7K+Wav6dkY0fEbWUzZOSdniwdD7QlDSQ4s2Xryczxlcwc+fOyDLTEtEc9WVEy
         uvNQ==
X-Gm-Message-State: AOAM532DaNYwFxpcpJAdlGcs3fxmm9pR44BGf0xueFXRA6iQhsyZGW96
        OGevoYqKz/LctDJQeQOTqls=
X-Google-Smtp-Source: ABdhPJzVhWT5Sgs6NyGB+h5G/pJ/sSfVUYQJCbryOzs8m5KPMlhoKb/sKmaxmHzd+O1auOexbs70Yw==
X-Received: by 2002:a63:9a19:: with SMTP id o25mr6835991pge.90.1631828695406;
        Thu, 16 Sep 2021 14:44:55 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b12sm9017695pjg.0.2021.09.16.14.44.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Sep 2021 14:44:54 -0700 (PDT)
Subject: Re: [PATCH net-next 2/4] net: dsa: b53: Drop BCM5301x workaround for
 a wrong CPU/IMP port
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20210916120354.20338-1-zajec5@gmail.com>
 <20210916120354.20338-3-zajec5@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <53c85810-4ca5-8475-5f34-43467d018414@gmail.com>
Date:   Thu, 16 Sep 2021 14:44:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210916120354.20338-3-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/16/21 5:03 AM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> On BCM5301x port 8 requires a fixed link when used.
> 
> Years ago when b53 was an OpenWrt downstream driver (with configuration
> based on sometimes bugged NVRAM) there was a need for a fixup. In case
> of forcing fixed link for (incorrectly specified) port 5 the code had to
> actually setup port 8 link.
> 
> For upstream b53 driver with setup based on DT there is no need for that
> workaround. In DT we have and require correct ports setup.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
