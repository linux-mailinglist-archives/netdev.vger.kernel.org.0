Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F38E8493048
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 23:03:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343960AbiARWD2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 17:03:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234970AbiARWD1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 17:03:27 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2121C061574
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 14:03:26 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id t18so216928plg.9
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 14:03:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sG7mTGPzRTuz/Z5swOJ8dDhAO7/6UtmQPcFpZjVueNs=;
        b=ezzK61pB96H+Md5TmaZm5rS9kXxUkkhggGZYdJ456s42nd+hz2jUKi5tJbvORrQ44N
         LBuJJ10xphsWAyfZ1XmxFMFc30oa6Qe4F/Yt5MlOIXO0jfSwqYP/I3nS07NxNUU+tjrn
         GndtRw51urW+SR4joCTAJNVumiJo/oHTnxzE4pmfyLAntwrq0g3c+/UCWZuK7fzOOBjN
         Os4Fd88wtN/SShpkL75lUfHrBsCZW/txw0EZXa7HBVbh9rMsMqF8+X4cOLN7YOTmwwaF
         mDZ4hOk8HsOywYZuaY5wN1k2OjNn6KD7oWiw6LMhlfL4rS8tsp7WKwEMxddhUEjeptMn
         tz2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sG7mTGPzRTuz/Z5swOJ8dDhAO7/6UtmQPcFpZjVueNs=;
        b=buJ2Rr88eQYCNHMBObrfK7cGzdlTCNa/Z+vn3gDtlSww4Io63qaqPYtTRk7Vj9DpBo
         KnyEworC4FwOTKhQ70TDeylhEljtFtuQ4k0H1AmnD4vH5IZf6rrtNp1fCFnEuRVFz2N4
         IyY8rqqZfdoKXbAVam+r2iYDcqzzKcduIfw7/35e+tBF4i2CtJ3dDYK6YvTW+pARcRZu
         BKoXULTNrZZ6RWih+RB4ydatRurzaVnKaPmaWC7T/AVsOh66N2qLYAa/xJ82BhTqZF4J
         1yeEVt5CVHpXuS0J9cbTPxw0CzSBuGQ+KpJRY4l9rEG2iVEIMotjVNsShGpLP+O8Kvo+
         AfFQ==
X-Gm-Message-State: AOAM5331m9KRXQBDlNHtkPVOYZIByAA63qdh5tsXOlC9mbsAEMp3zY+H
        vsDJaMPJROnBhCqMYnaN9xw=
X-Google-Smtp-Source: ABdhPJw4fwD6prvWebjEC417s4HoCjXjc5Bdy4VKBhemfmX6TgHmqzK0JF8lUmPuvtCm7PNscWEk4g==
X-Received: by 2002:a17:902:724c:b0:14a:9df9:6428 with SMTP id c12-20020a170902724c00b0014a9df96428mr18446909pll.87.1642543406175;
        Tue, 18 Jan 2022 14:03:26 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id q64sm3671252pjk.8.2022.01.18.14.03.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jan 2022 14:03:25 -0800 (PST)
Subject: Re: [PATCH net] net: phy: broadcom: hook up soft_reset for BCM54616S
To:     Robert Hancock <robert.hancock@calian.com>, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org,
        bcm-kernel-feedback-list@broadcom.com
References: <20220118215243.359473-1-robert.hancock@calian.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ead6a351-0bd1-1395-d3ed-28d8d1422e7b@gmail.com>
Date:   Tue, 18 Jan 2022 14:03:22 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220118215243.359473-1-robert.hancock@calian.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/18/22 1:52 PM, Robert Hancock wrote:
> A problem was encountered with the Bel-Fuse 1GBT-SFP05 SFP module (which
> is a 1 Gbps copper module operating in SGMII mode with an internal
> BCM54616S PHY device) using the Xilinx AXI Ethernet MAC core, where the
> module would work properly on the initial insertion or boot of the
> device, but after the device was rebooted, the link would either only
> come up at 100 Mbps speeds or go up and down erratically.
> 
> I found no meaningful changes in the PHY configuration registers between
> the working and non-working boots, but the status registers seemed to
> have a lot of error indications set on the SERDES side of the device on
> the non-working boot. I suspect the problem is that whatever happens on
> the SGMII link when the device is rebooted and the FPGA logic gets
> reloaded ends up putting the module's onboard PHY into a bad state.
> 
> Since commit 6e2d85ec0559 ("net: phy: Stop with excessive soft reset")
> the genphy_soft_reset call is not made automatically by the PHY core
> unless the callback is explicitly specified in the driver structure. For
> most of these Broadcom devices, there is probably a hardware reset that
> gets asserted to reset the PHY during boot, however for SFP modules
> (where the BCM54616S is commonly found) no such reset line exists, so if
> the board keeps the SFP cage powered up across a reboot, it will end up
> with no reset occurring during reboots.
> 
> Hook up the genphy_soft_reset callback for BCM54616S to ensure that a
> PHY reset is performed before the device is initialized. This appears to
> fix the issue with erratic operation after a reboot with this SFP
> module.
> 
> Fixes: 6e2d85ec0559 ("net: phy: Stop with excessive soft reset")
> Signed-off-by: Robert Hancock <robert.hancock@calian.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
