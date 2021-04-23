Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8AD9368ADB
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 04:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236855AbhDWCAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 22:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230367AbhDWCAZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 22:00:25 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A7C3C061574;
        Thu, 22 Apr 2021 18:59:49 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id em21-20020a17090b0155b029014e204a81e6so3673349pjb.1;
        Thu, 22 Apr 2021 18:59:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xSHN96vv5KzdEQZiMo8+41AN4qN+I7xvW4dSDDyn9TY=;
        b=MPb5vqyNkciiIhBisQBLnqB/bgjEpYPvQlFosFMGT+NirN2puKym8pN6Vo4e+EEgue
         z8kFHpHlm/hzKJpkX0VWcu2aGYINUDftmSZn8tQzzmQplb9NOdR5bch9Yd995K+F+cja
         MXdZDTsdyjrKzfnx2zwUbeWB2zEBfGImUf3LBkMDDV4NdA79VsUOBKa079iYCnjbhDR4
         nxfUDIHKzxzZym9qpIxP8RBIp86V2pEHQnosP4OoB0lJvDLnBg22AwFGaoCfpSKvA0/5
         VIZiiZfCUzQxUtzPcwKNt++Poj1/WQNKJLLTKxrFp8R2Vmn2NBTgFynP95ogIo2jRjOs
         spLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xSHN96vv5KzdEQZiMo8+41AN4qN+I7xvW4dSDDyn9TY=;
        b=i27bmglDH8WpCaM+guOYEBjFcSvV/2LCf1nso1WnAgggijQ0mSn5ZkrlPTCHanlKkC
         CTYoGVP+VZF7QKdqA30gwiGC23nbCr+Gr/pnlnyXX6WLGI/wmK962+tlRivQp7BccF7O
         sPISeunMRN3Z3fo7Eigxt0LnyB9DUodWuKvbRgFpo6QkChBS/NZdPCdB8vYSPylqngR1
         IMo3sqf5CgzhB3CpzkWwEdDAa16tbMW4mTup74tPMmNxJni3NiVxjwfZIuxJIDJkXGPm
         8VO0cTlXuWTe77+K2QVYHkKW+UzAVzI6ai8oEpD8DCaPL3pV+ftIDJ0K6o+8HP/IZu//
         Ic4w==
X-Gm-Message-State: AOAM532I2lzpVupfaXj5fFriGvfvU3R0hcT9sZ1I87DN29mfFR6r2o8M
        d2Q+w3F7I5f4PaTwbp/iJcre3W+sfsg=
X-Google-Smtp-Source: ABdhPJys0qZkc6BztdoOvmIpP9KBvx9QPRXKF0PLoEvZMlbKJNrm2Pl825nvpi7AU2WdC0kys73Plw==
X-Received: by 2002:a17:902:e04f:b029:eb:66b0:6d08 with SMTP id x15-20020a170902e04fb02900eb66b06d08mr1793059plx.50.1619143188821;
        Thu, 22 Apr 2021 18:59:48 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a128sm3079065pfd.115.2021.04.22.18.59.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Apr 2021 18:59:48 -0700 (PDT)
Subject: Re: [PATCH 07/14] drivers: net: dsa: qca8k: limit priority tweak to
 qca8337 switch
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210423014741.11858-1-ansuelsmth@gmail.com>
 <20210423014741.11858-8-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <60e1d0af-8576-9fb7-dfbc-af534368e51d@gmail.com>
Date:   Thu, 22 Apr 2021 18:59:46 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210423014741.11858-8-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/22/2021 6:47 PM, Ansuel Smith wrote:
> The packet priority tweak and the rx delay is specific to qca8337.
> Limit this changes to qca8337 as now we also support 8327 switch.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>

If you re-order patches a bit, then we could avoid having this patch
completely, with the exception of the RX_DELAY_EN or maybe that can
folded into patch 5?
-- 
Florian
