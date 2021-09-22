Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAAB541500C
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 20:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237113AbhIVSnC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 14:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237039AbhIVSnB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 14:43:01 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E128C061574
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 11:41:31 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id 203so3440045pfy.13
        for <netdev@vger.kernel.org>; Wed, 22 Sep 2021 11:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ofvGFYnBb8nWtbRhJQZz5VyuI2071a5/8H3jz+3SQ74=;
        b=d1UKGbUJ6OGmSyR3Cmuf+jHZMuwB4HvaCHswpstNw4hHVL/4+U5QqwJuYYgVDZk+rO
         FnL4cSpUPXwTjdVdQUyv+5mbLSVt8+6ymARXqC2nT4sBd/8FhHsgYL1mQCoMbMpEJXQU
         HmwbZUsI5h712Gf0eNMjSAoOUBz2Nw9iEAbwFj6/oA1Zr5FXyitPa6tMrHD0y1Ss2HBq
         U/FY6CRMkT77S+KJhSiYy7aiNFeNLuXhZEtZXwYd3HgtFfOrIxmkSvoRtC9mvEtvh/k6
         bkv4cNEcSFIdUumLtLu7LI0Nsj5fWIXNL/f+ZU6x0+oytTlXYSFOssJT5ZpIMW6VT9QC
         4z/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ofvGFYnBb8nWtbRhJQZz5VyuI2071a5/8H3jz+3SQ74=;
        b=IzgL7QrgRL0XY/hEInZI2bEa372ER4aMsVbWH+u1rP5Jh9H86HkMiUM8NJv8oE8Wuu
         mKaPaTQpvnWWWFTn4dWJGiiVX2Yvo5AsBrNUm88EqT6tweh6chUU6BIGCAMXUrghvxDn
         sJtqssoNxlzc+WRCGLpHKIOddha/nD2TY+yzBkeahi+iNrPm+1psmK/vRSIMcIWi/kNa
         mL87HZzOWRD1N7u9KfWuRMwjnQra4wZBjHQCQ085BRlwqpDq+6EYeGa/yVnoSzgmOXo5
         N2SKyBx3LqZR7nBvawWo0ep5e5CMXfbXTic+YtVdoALp35F6ogouVuayoD6kkowF88nx
         h+EA==
X-Gm-Message-State: AOAM532pfwsoq6NhO20lksDxGYOFMczzqC9JIrxoYFcbElU9fMtHrBd+
        QjJMgq2vkAArBH8ZL01HDJw=
X-Google-Smtp-Source: ABdhPJyZxZgLgrWcUMkfCt0o3tLJH4Nu66iG5eZxXwNiYVgl5u6+/zlWLfikIZAWPBEXqm1sRe2XLA==
X-Received: by 2002:a63:205:: with SMTP id 5mr300822pgc.433.1632336090596;
        Wed, 22 Sep 2021 11:41:30 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id h10sm6283989pjs.51.2021.09.22.11.41.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Sep 2021 11:41:30 -0700 (PDT)
Subject: Re: [PATCH v2 net-next] net: dsa: sja1105: stop using
 priv->vlan_aware
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <20210922183655.2680551-1-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <84ee7d3a-59d6-dca4-affb-f8c6745d9ad8@gmail.com>
Date:   Wed, 22 Sep 2021 11:41:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210922183655.2680551-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/22/21 11:36 AM, Vladimir Oltean wrote:
> Now that the sja1105 driver is finally sane enough again to stop having
> a ternary VLAN awareness state, we can remove priv->vlan_aware and query
> DSA for the ds->vlan_filtering value (for SJA1105, VLAN filtering is a
> global property).
> 
> Also drop the paranoid checking that DSA calls ->port_vlan_filtering
> multiple times without the VLAN awareness state changing. It doesn't,
> the same check is present inside dsa_port_vlan_filtering too.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
