Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8280D1CEBA1
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 05:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728611AbgELDlK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 23:41:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728073AbgELDlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 23:41:10 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17EE4C061A0C;
        Mon, 11 May 2020 20:41:10 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id l11so7620360wru.0;
        Mon, 11 May 2020 20:41:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KjqUvhuQOHrwd7i3EcYY56vJTspek0Xt0MZCYsItdRk=;
        b=Fcc0Ak/1DN6T+WH1hu0l8V6dvgMW3hK49OoguArl2MNTB69DWfuALNERULzWU7LlxW
         plYLhp7VyxBIcytLvPB1CwyvyaGNIpSduLRdqKMttd3v+bfzOl+USrXCD7O4MN/TOYCY
         1zlkCzPCo0PCPU51STynCZlqY+3yqjGzPHviar40kJE7gfa2CsJDAhNCH8CsV4WmKmJt
         c3MgJ1ypORc26cgRKp3QBIb4ZVUjyobFXvcX/6/h0EANH4x3MEQcczQLjCCi3nvsAuJL
         yqGD+kr5cyAS07nwrXJmXu3JQ4Z5DPAoEEYGKNJNSjaBDCgSn9n9duSrziB5y58PW6am
         VINg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KjqUvhuQOHrwd7i3EcYY56vJTspek0Xt0MZCYsItdRk=;
        b=gEgKj9VqKQd21quBOmGJGQcafvmw+zidN7lxYoZ0GcVmWXkzyIlnLmHlpOw8+XlJ8b
         umuOiUvlFfpa/aJD66xn4Ud+/WV7VrEJRbEEpEj+E7mYA/S8wMlR8InAHkas0s+xvK8u
         GLt2mU7NcbBMZ3s6g/8uDy9r4MhV51mYVp6PlVyYDW5RseZHwDllNOtVvq7uJQiqU9vg
         gym4stAlVDJlgHZeiosSk256s6fDAl6gIE9wEo6e27TVm1lQ5/8Or1DtDyWKHltqxdWT
         h6OmyQcDB9e1uhJTVfmVA3YSNEA9SLh/RKdOAf2Z9EftYUNa1R0sk9nB65VksWEk7nj4
         Mdrw==
X-Gm-Message-State: AGi0Pubm6t6T8xzy6zWVWC+DP5UgqCpc2ERCpkbbtgo9vL84KOdltvKA
        xhugeTIMaMdDUI3KvDTP/F+10vPS
X-Google-Smtp-Source: APiQypJBhM6h0GRhc1j3SqavsWUWYdmKIVhws62icWHoYZJZSrQYP9QsC1eB7WgzH2Q2PCQDcB0fuQ==
X-Received: by 2002:adf:a51a:: with SMTP id i26mr7873797wrb.332.1589254868497;
        Mon, 11 May 2020 20:41:08 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g24sm22097395wrb.35.2020.05.11.20.41.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2020 20:41:08 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 14/15] net: dsa: sja1105: implement VLAN
 retagging for dsa_8021q sub-VLANs
To:     Vladimir Oltean <olteanv@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        idosch@idosch.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200511135338.20263-1-olteanv@gmail.com>
 <20200511135338.20263-15-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <aef0d6a9-5edc-a0b1-f6ee-8f82d86b7c60@gmail.com>
Date:   Mon, 11 May 2020 20:41:04 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200511135338.20263-15-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/11/2020 6:53 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Expand the delta commit procedure for VLANs with additional logic for
> treating bridge_vlans in the newly introduced operating mode,
> SJA1105_VLAN_BEST_EFFORT.
> 
> For every bridge VLAN on every user port, a sub-VLAN index is calculated
> and retagging rules are installed towards a dsa_8021q rx_vid that
> encodes that sub-VLAN index. This way, the tagger can identify the
> original VLANs.
> 
> Extra care is taken for VLANs to still work as intended in cross-chip
> scenarios. Retagging may have unintended consequences for these because
> a sub-VLAN encoding that works for the CPU does not make any sense for a
> front-panel port.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
