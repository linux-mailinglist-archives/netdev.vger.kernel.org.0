Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58D4321C609
	for <lists+netdev@lfdr.de>; Sat, 11 Jul 2020 21:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbgGKT5L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jul 2020 15:57:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726628AbgGKT5K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jul 2020 15:57:10 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A2ACC08C5DD;
        Sat, 11 Jul 2020 12:57:10 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id s26so4070154pfm.4;
        Sat, 11 Jul 2020 12:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CZ1e1aAFKaOpSNGWTnMXv42OekoJcfrfcJM5gAnBvUI=;
        b=YsLWmPPBBUXayWAiuK5Rmy75po32YrKN45MfIrMXRzBfuXOJQsFex/ndZs1VcWs1AH
         iyzIaZe6H+nnQCgEd0J8YGLPItr4wXe205dFY3ny4p4xOPx0+AcLUFBHOsvNJa/sV9kp
         emDnfhM4PltGEGnNUbKq5ONFbvJVjlDNS1aqEhq2dOGJqsouW0v/p4kj+VykTxNlF+Oj
         gAkyq+TvA+MTitOKkQPJFMdUN5qqiBGiBCeW21gmNWdR/I76vQ3bp7ewBuPJOh8+1dpm
         +adLQUk0rMfbNBHGdmIQ+7BPN0TqS3B8HfFM7vjePPGQrCJiqO8sPNE/g3nc5K8eJ4jL
         7ssg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CZ1e1aAFKaOpSNGWTnMXv42OekoJcfrfcJM5gAnBvUI=;
        b=SB/14gXXXHaqJsfxWs5S/fI+bRwf2XoDH6bOjCY2gYPfzA1ixEyoXvAEXNqCZV/R3V
         3EJ1kMXmbkB0CZO9ELlOvWQ08oWXWKcYY+mVXF5gCaPSOZsRBWOURf1xgHlsqvweZr/J
         Vc3jiy/WYfGuItEcRmwTZtfw2P/x8W4V2akXstEmsHvppU2E7uLCj7CTAVBA2w/SoUKw
         FBQ+QEvHTO4FYvoh9JMLCEzlO4PK+wL30/FP1Z/anRx5t2m/Hg7xSKBbueikZQiqQkFF
         Xdtbi2IfAxowFGwtYdoLElAO/7uTcV/ozvHoWFklWTUHWnadj594R8SrtEYRNah9+/MU
         CFxw==
X-Gm-Message-State: AOAM530Wjpto5nhAErl5aiSIbo6nmN2i5c6Y3w5g4HgwsF7BJybefA7h
        0nqKuRWSUQlrgsXGuQj104OL7qQf
X-Google-Smtp-Source: ABdhPJxAiCG8TUmRO+0EQ3UX5b5rBUXvD96iXx8jMh9rEP0v8m5XfDd0zPdjM/5F30KiPVf8TB3sjA==
X-Received: by 2002:a63:1f04:: with SMTP id f4mr4069076pgf.34.1594497429892;
        Sat, 11 Jul 2020 12:57:09 -0700 (PDT)
Received: from ?IPv6:2001:470:67:5b9:d909:803c:5ba6:c13? ([2001:470:67:5b9:d909:803c:5ba6:c13])
        by smtp.gmail.com with ESMTPSA id o42sm9863679pje.10.2020.07.11.12.57.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Jul 2020 12:57:08 -0700 (PDT)
Subject: Re: [PATCH v1 1/8] net: dsa: Add tag handling for Hirschmann
 Hellcreek switches
To:     Kurt Kanzenbach <kurt@linutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org, Vladimir Oltean <olteanv@gmail.com>
References: <20200710113611.3398-1-kurt@linutronix.de>
 <20200710113611.3398-2-kurt@linutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b83ce019-d2bb-1d51-d5e5-7e6c82c86127@gmail.com>
Date:   Sat, 11 Jul 2020 19:57:06 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200710113611.3398-2-kurt@linutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/10/2020 4:36 AM, Kurt Kanzenbach wrote:
> The Hirschmann Hellcreek TSN switches have a special tagging protocol for frames
> exchanged between the CPU port and the master interface. The format is a one
> byte trailer indicating the destination or origin port.
> 
> It's quite similar to the Micrel KSZ tagging. That's why the implementation is
> based on that code.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
