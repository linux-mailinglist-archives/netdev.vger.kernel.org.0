Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 045631C4CA2
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 05:22:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728006AbgEEDWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 23:22:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbgEEDWp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 23:22:45 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B152CC061A0F
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 20:22:45 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id e6so395697pjt.4
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 20:22:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lVP/pbiTbP4Hl2nJ8Syb2ZiRYoWw3ySOKtKbWj5YpL8=;
        b=LnodoOWVNpv+87xSdjAVT67aszSHyScAWVeeLKk5m1vgKnfyGbIynCfPmKi5bC+0u4
         Fp3JZSaXrFDtO3SSlXzBKvfRP2GJ9kQzWRSaZoie0y6DYF/6KjL/SHhrGsN/klCGf4iG
         NmJLhgSN9bPwnXtEZHOpzkoEGLPMjyjOTZ1oqoip8/NUI8sS6ijDrQVCVgHAFh+6kfVp
         d5OpbvfX6jDWdDSNzww82RW6EZ3USNUVuT1cViuV4HhXJ3JE62lZDRn0p/zHKdT32XFg
         BzadEuYOXyq6j9K3nxjZNWKeKAlljsjJacZe/BTPHojSKb3yrD9H4SPNKUxE7d58pnTf
         RTSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lVP/pbiTbP4Hl2nJ8Syb2ZiRYoWw3ySOKtKbWj5YpL8=;
        b=cv9wNuAU1Q80o47l+MbrPHINsMMKIit0HiIWfLGDqKVOZOI7p1MTzxmm/xqZuNXS+y
         yHOPFB1DZLNWz/gZEJ6QXJh9vXLaim3lqjYNKGNGXhHdFM02W76f8pYxsHTHTOUKbV96
         iTj1MGzo543UOPd+4txhcGbEhQ/xi4pa77ffFkOWEawHls42BV+ij/dRFcG3hcmpXhpp
         xOyitntADVjA/fv977HO2GE1FaJq5O5QJjIMQuISMx5y6uzhcwYOSUbaDbF5TYmMX8/x
         w7wa2s75uDtVKPJGhZ+52YbcczTd5Cwyf2iffW6Iw90NslJRoBV9HSve+OeYgN+ld5qK
         b03A==
X-Gm-Message-State: AGi0PuZEgnGtDj0V42Da6IlU4HnAQ8C5nM/YQCO3ZrOuDpH0W6aFjUHD
        8AAUdkA8TdpDyEp4uVSGcjM=
X-Google-Smtp-Source: APiQypJ1NBFpm9XklwvPa/nOzCA9DoipkOVaJMxPdaFxEYvVlpuBi0WwguE56cxtdQqQRIosO0vWjg==
X-Received: by 2002:a17:90a:37a3:: with SMTP id v32mr373304pjb.2.1588648965256;
        Mon, 04 May 2020 20:22:45 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id q6sm486223pfh.193.2020.05.04.20.22.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 20:22:44 -0700 (PDT)
Subject: Re: [PATCH net-next v2 07/10] net: ethtool: Add helpers for reporting
 test results
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Chris Healy <cphealy@gmail.com>,
        Michal Kubecek <mkubecek@suse.cz>, michael@walle.cc
References: <20200505001821.208534-1-andrew@lunn.ch>
 <20200505001821.208534-8-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <4c4e0942-ca98-6f56-8474-6af64914e811@gmail.com>
Date:   Mon, 4 May 2020 20:22:43 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200505001821.208534-8-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/4/2020 5:18 PM, Andrew Lunn wrote:
> The PHY drivers can use these helpers for reporting the results. The
> results get translated into netlink attributes which are added to the
> pre-allocated skbuf.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
