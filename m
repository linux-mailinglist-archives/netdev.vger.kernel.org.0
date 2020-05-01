Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34E431C1059
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 11:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728384AbgEAJ23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 05:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728236AbgEAJ23 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 05:28:29 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 918B2C035495
        for <netdev@vger.kernel.org>; Fri,  1 May 2020 02:28:28 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id y3so3474344lfy.1
        for <netdev@vger.kernel.org>; Fri, 01 May 2020 02:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IDH0QHo315zsR2EVp9WirUHH3ScryOp5m/0pVw90/ek=;
        b=OOIMmAKgOIKQNayrYOkT9wUrrPDA1zRklTCqqXAkXjZCUGNH9Hq1JX7jNdXTpWszxu
         MQ25bIx/NSjKlx5UGPfctm7j3xLx+NVm0yE2VSq/YknQnaA87IIDP0AQXqRM55dOLjho
         98hv/vNmhaZBDNy6rv/bMVE0NRoH3q179ECxk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IDH0QHo315zsR2EVp9WirUHH3ScryOp5m/0pVw90/ek=;
        b=W/IQ9x0qx4qnvaxstcR/tfxqUG73hcNeO1YYZVartS1BBG10BZvN9acCmre+v2G38X
         kNiGJwHozNpOgCW+CxOHfYEb7FnIIHJIYkKE6RJco2HvNBzduMBCcOeknCRI70Erbl2b
         xgb58z2+f6NlCtLjRZp6Oo+kED6y4hEbuDA1pB1kTPmT89I4EPm56hF6kwkxpBq9Cs2i
         7+2jIeUmTCcPAXjqkqxHRo8ozweKlRSnd0L5gdtD601ozuyC5+5RN2vDq1hCZGqhkTDn
         R6qtMD/PvexGqu+4M39jESEjlDhistMvhSF/ewSEb60UiIL3fKdRvoAMfhTu2wsfGFiY
         n+/A==
X-Gm-Message-State: AGi0PuabZHh+RigyXWFczg7NJ1QP6iQ8SsTZe/jGAzejEkgFX8cOnJX8
        Ps86pvn1JEY+iWKTaQau7s1VdQ==
X-Google-Smtp-Source: APiQypKuJuZgvqbzLVtPV71itbTGQyVGbfUpK/VJdSss32TXGQgAk6xhYclxnFYh19k8lE4oeUF8zQ==
X-Received: by 2002:a05:6512:685:: with SMTP id t5mr2010404lfe.47.1588325306328;
        Fri, 01 May 2020 02:28:26 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id 24sm1662561ljv.3.2020.05.01.02.28.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 May 2020 02:28:25 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 1/4] net: bridge: allow enslaving some DSA
 master network devices
To:     Vladimir Oltean <olteanv@gmail.com>, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, davem@davemloft.net
Cc:     jiri@resnulli.us, idosch@idosch.org, kuba@kernel.org,
        netdev@vger.kernel.org, leoyang.li@nxp.com,
        roopa@cumulusnetworks.com
References: <20200430202542.11797-1-olteanv@gmail.com>
 <20200430202542.11797-2-olteanv@gmail.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <6d46b1ea-0d46-3857-e3b8-82d73ddcaea0@cumulusnetworks.com>
Date:   Fri, 1 May 2020 12:28:21 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200430202542.11797-2-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/04/2020 23:25, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Commit 8db0a2ee2c63 ("net: bridge: reject DSA-enabled master netdevices
> as bridge members") added a special check in br_if.c in order to check
> for a DSA master network device with a tagging protocol configured. This
> was done because back then, such devices, once enslaved in a bridge
> would become inoperative and would not pass DSA tagged traffic anymore
> due to br_handle_frame returning RX_HANDLER_CONSUMED.
> 
> But right now we have valid use cases which do require bridging of DSA
> masters. One such example is when the DSA master ports are DSA switch
> ports themselves (in a disjoint tree setup). This should be completely
> equivalent, functionally speaking, from having multiple DSA switches
> hanging off of the ports of a switchdev driver. So we should allow the
> enslaving of DSA tagged master network devices.
> 
> Instead of the regular br_handle_frame(), install a new function
> br_handle_frame_dummy() on these DSA masters, which returns
> RX_HANDLER_PASS in order to call into the DSA specific tagging protocol
> handlers, and lift the restriction from br_add_if.
> 
> Suggested-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> Changes in v2:
> * Removed the hotpath netdev_uses_dsa check and installed a dummy
>   rx_handler for such net devices.
> * Improved the check of which DSA master net devices are able to be
>   bridged and which aren't.
> * At this stage, the patch is different enough from where I took it from
>   (aka https://github.com/ffainelli/linux/commit/75618cea75ada8d9eef7936c002b5ec3dd3e4eac)
>   that I just added my authorship to it).
> 
>  include/net/dsa.h       |  2 +-
>  net/bridge/br_if.c      | 32 +++++++++++++++++++++++---------
>  net/bridge/br_input.c   | 23 ++++++++++++++++++++++-
>  net/bridge/br_private.h |  6 +++---
>  4 files changed, 49 insertions(+), 14 deletions(-)
> 

Looks good to me, thanks.
Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

