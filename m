Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 375AA1CEB94
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 05:38:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728801AbgELDif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 23:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727942AbgELDie (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 23:38:34 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74964C061A0C;
        Mon, 11 May 2020 20:38:32 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id n5so6732159wmd.0;
        Mon, 11 May 2020 20:38:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=65+ryeo+9kxscp6Vc376GV6Ht9lQEi5vtaHCqJ43I64=;
        b=UdIdF/emqInJZJols9u43eppsebzW8O0XoB33BxkIrVUEXxQG9h3cQrwfbp5WNwuuk
         YCdEGwPkY3ramB9LOa5QjMRrjePNukgPlyjRRfqg1iBWuUWWssjl5krb7ppoV3qcZJn+
         /a1MXq6LxgdAnrHJ/WSRldnZrJpJR0MNZW+YOwH62yEZCE+OnapcSb2yfO0K9CQ94Aa0
         6FOWK/iklHXqECQ8Vj8miGaHORuOMS51SvodqPe4+LTWQvrg54QuUCYyS2+E7nOZslA5
         oCKMvba5uFO8WP88ImZDnHBvr6Yp0/LQrZNSX3/Ogdb7VJi2JNJdp6hSJYmIe7nWY6ra
         hmfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=65+ryeo+9kxscp6Vc376GV6Ht9lQEi5vtaHCqJ43I64=;
        b=mSQ9F+2yP021EBe71A7b03g3r9dqmPw5AU3nMfZRafeG1/7QXWGfQS8gj+Qx2F6e3H
         G5XPAwebWI7UvaL4gAFuIMqNocpNnJ7WOGJHDx2YRF9CjqgAqTNsyu0bfMeOjKsNgLDp
         Rdf/zctz1hvGm8hnP7972VleyDI/BIH0QS5exZ0eJOOpJqvA/o2aZv/c+dR28x2v9w4m
         UUW+BSJPO0aDl2TxKSmrWOrHMTYnQr1wLdb/8fCZeGYHJ4q2GgsAUaq2QeeQGsHmbQHu
         0w3utYji8JqOY8odCCjxWk/HHQj0favLvZitxphvnWjWAFUNMdjLziT4mg3uQa0VY5P0
         3Lxg==
X-Gm-Message-State: AGi0PuaZaV2SzmE72FDgMYF9FR6FUdtvtlkObjOof4S4pwXjYvc/aYq/
        86y6vCUAYLAiZtA1DAXlm5dr/e1q
X-Google-Smtp-Source: APiQypLr9HjG6PutaE6ZxmFxCaFDwXPI9XFRV45rqsYqryELvUnBcl7boOcDIg94kGVsZduWzhEW3A==
X-Received: by 2002:a1c:9e52:: with SMTP id h79mr34668243wme.84.1589254710859;
        Mon, 11 May 2020 20:38:30 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 94sm5981482wrf.74.2020.05.11.20.38.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2020 20:38:30 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 12/15] net: dsa: sja1105: add packing ops for
 the Retagging Table
To:     Vladimir Oltean <olteanv@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        idosch@idosch.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200511135338.20263-1-olteanv@gmail.com>
 <20200511135338.20263-13-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <433d1c22-80bc-7b1f-09e0-b4e2faa78dc1@gmail.com>
Date:   Mon, 11 May 2020 20:38:27 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200511135338.20263-13-olteanv@gmail.com>
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
> The Retagging Table is an optional feature that allows the switch to
> match frames against a {ingress port, egress port, vid} rule and change
> their VLAN ID. The retagged frames are by default clones of the original
> ones (since the hardware-foreseen use case was to mirror traffic for
> debugging purposes and to tag it with a special VLAN for this purpose),
> but we can force the original frames to be dropped by removing the
> pre-retagging VLAN from the port membership list of the egress port.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
