Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F405B1980DE
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 18:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730039AbgC3QVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 12:21:47 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:39606 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727148AbgC3QVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 12:21:47 -0400
Received: by mail-lf1-f67.google.com with SMTP id h6so8930465lfp.6
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 09:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ceRQl/rDBk6AZGZV87hR1KyptG7t3Kf+Og5g8l3kQ9Y=;
        b=EGaNa2JDouvflDLK16jMocP/xa7o58nL6cBYI8lu6B771+YtUHoDF+JKGHZXWYU25f
         KemrpG/1oHZ8O9fbqwGH3f2OkmaxKyHDIcY4/YISPKDIHyUhRIwG5eiK5GmNUU2FxDSb
         FXbpCOoCuMcMKElQAFnKuh9tEqSgC3NdDhZI8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ceRQl/rDBk6AZGZV87hR1KyptG7t3Kf+Og5g8l3kQ9Y=;
        b=VWVv1hxGlnFUADESuTkBMNxSVOWZzI0uuPfnMvBxjMeguOtFbTz3cZQUfNNhfu78O1
         j3IAazxH42RibZi6N2HxTdJnPzltsib14JdLEapZNheQIVDwxOsefbcjXEzSsF6k3eu1
         9T9QVXXkPrQ/pLNt+7JdweIkJn/CPs+7w+3ceobrmMZYfx+/hjfa5oV+UzCdFvYqRlaV
         jWxb/Hz9PnnwXgInY9D2/WaDxlfdp5Nr1FXs64YccSIgdlvF/GNenKh/JWVVUnedWily
         uSRxxLut6UQyq8x4wgyoOSlYyz/wGGWp1FY6wenw3AAv3nGwFi1ttGVA2gqbsWZhEKkS
         6eLw==
X-Gm-Message-State: AGi0PuaJxf380OE8VMrChcgiOvoMqqi2B75mKIGAnsCQRY9PiKvnIm+r
        0Ppr7mPOUxUGIpGl4/bXmxmVBg==
X-Google-Smtp-Source: APiQypKWOw8LDmb2uLPOvbKs5U0udPyVoA5MVyhQDji/LDJzya5jSfWYhT/d4nHb1hYwUh2s9frJOQ==
X-Received: by 2002:ac2:5092:: with SMTP id f18mr8506094lfm.162.1585585305086;
        Mon, 30 Mar 2020 09:21:45 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id t144sm7981885lff.94.2020.03.30.09.21.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Mar 2020 09:21:43 -0700 (PDT)
Subject: Re: [RFC net-next v4 0/9] net: bridge: mrp: Add support for Media
 Redundancy Protocol(MRP)
To:     Horatiu Vultur <horatiu.vultur@microchip.com>, davem@davemloft.net,
        jiri@resnulli.us, ivecera@redhat.com, kuba@kernel.org,
        roopa@cumulusnetworks.com, olteanv@gmail.com, andrew@lunn.ch,
        UNGLinuxDriver@microchip.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
References: <20200327092126.15407-1-horatiu.vultur@microchip.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <15dcc261-bcbb-ec67-2d8d-4208dda45b86@cumulusnetworks.com>
Date:   Mon, 30 Mar 2020 19:21:41 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200327092126.15407-1-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27/03/2020 11:21, Horatiu Vultur wrote:
> Media Redundancy Protocol is a data network protocol standardized by
> International Electrotechnical Commission as IEC 62439-2. It allows rings of
> Ethernet switches to overcome any single failure with recovery time faster than
> STP. It is primarily used in Industrial Ethernet applications.
> 
> Based on the previous RFC[1][2][3], the MRP state machine and all the timers
> were moved to userspace, except for the timers used to generate MRP Test frames.
> In this way the userspace doesn't know and should not know if the HW or the
> kernel will generate the MRP Test frames. The following changes were added to
> the bridge to support the MRP:
> - the existing netlink interface was extended with MRP support,
> - allow to detect when a MRP frame was received on a MRP ring port
> - allow MRP instance to forward/terminate MRP frames
> - generate MRP Test frames in case the HW doesn't have support for this
> 
> To be able to offload MRP support to HW, the switchdev API  was extend.
> 
> With these changes the userspace doesn't do the following because already the
> kernel/HW will do:
> - doesn't need to forward/terminate MRP frames
> - doesn't need to generate MRP Test frames
> - doesn't need to detect when the ring is open/closed.
> 
> The userspace application that is using the new netlink can be found here[4].
> 

Hi Horatiu,
One issue in general - some functions are used before they're defined (the switchdev
API integration ones) patch 4 vs 7 which doesn't make sense. Also I see that the BRIDGE_MRP is used
(ifdef) before it's added to the Kconfig which doesn't make much sense either.
I think you should rearrange the patches and maybe combine some of them.

Thanks,
 Nik

