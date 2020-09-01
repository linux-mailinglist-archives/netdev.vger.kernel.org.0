Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45B19259EFC
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 21:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729160AbgIATLR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 15:11:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726521AbgIATLP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 15:11:15 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E3CFC061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 12:11:14 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id b16so889952pjp.0
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 12:11:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=dOAzAo3+4zaxQIvQU7//yCuX4iyFg/QYIeoN/fRcne0=;
        b=T+N3OlFOVN66eFfmEUqN0ipKZgQwlbB1emF2iedYg5HPLainjB4jsPM+rXFImxUmWs
         ALkDXg3UDVDhY3OEO0AxwBghHtEddLOTgAgJbw80O/QpoMIiNJ7XQxJT+hrbqkP7wJXz
         brwREbuTeNqoE8u7PXWFNBmj82E5i07KLumiPDFqF7eKGvlHSN8a0o+TPj9V9aF1hIPK
         83699o8jEpPIgQpzlu/I6NIjgIux0M66Oy2jqS+quU80JPoSjAMwv+xPuTsutb1X1EIt
         U6d2AWMIE9g/7u9o5heur/jTE7UJhpHW1Y4r96Up6x/Z/L/Bk/qsaagfA8Adxt2hg1wm
         W0RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dOAzAo3+4zaxQIvQU7//yCuX4iyFg/QYIeoN/fRcne0=;
        b=m2UkFzTliMCBKDAs+5Fl/IqA88Qa8PCBh/jeVCJl/T7LdPE9APGAYtaoARAIGKqhY9
         2tzol5cP2W36p0uIDf9RuAG5B/kNCfYuE0sRAfjeydB3kb6Cao6gLyx+BImlkF3P0t0a
         9poVVKLy9pDgyHRIb7lIbAisVPmtTpR9kRi2GE7TKiZMpRQ9+hpOK4VJ7E6Ta/i94epc
         DCWpHJz5WeFva4gEtNWTww35WNV5ZyckZ6+bF4L/soPfZ0fh8Dld01HvNyuJFI+Fc8Im
         1yMTcbJkK4M9WxS1Oen0tEc1O2RYCcq+VWNpCHS03l6ZcD98yd4trESSIX5I/4r/KEU2
         /wYA==
X-Gm-Message-State: AOAM531CxyIv6FFkHgb0TZ1VPO1zZHWmc4fOk/sgAeWVfC+e6BnZ655n
        jCSr+uwdk394pPL30+GVhvBFZcPNgMI=
X-Google-Smtp-Source: ABdhPJzg6bBGAwigBueaiCezhZQgU07Cvp0rnGUdtMr2RexBVELN4V7mLib1dpmOSEh/CWyy3Yq87Q==
X-Received: by 2002:a17:90a:e00e:: with SMTP id u14mr3010210pjy.51.1598987473892;
        Tue, 01 Sep 2020 12:11:13 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u65sm2669225pfb.102.2020.09.01.12.11.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2020 12:11:13 -0700 (PDT)
Subject: Re: [net-next PATCH 1/2 v2] net: dsa: rtl8366: Check validity of
 passed VLANs
To:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
References: <20200901190854.15528-1-linus.walleij@linaro.org>
 <20200901190854.15528-2-linus.walleij@linaro.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <59fa6313-5c9b-b1eb-9f98-1383ceb11e81@gmail.com>
Date:   Tue, 1 Sep 2020 12:11:11 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200901190854.15528-2-linus.walleij@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/1/2020 12:08 PM, Linus Walleij wrote:
> The rtl8366_set_vlan() and rtl8366_set_pvid() get invalid
> VLANs tossed at it, especially VLAN0, something the hardware
> and driver cannot handle. Check validity and bail out like
> we do in the other callbacks.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
