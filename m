Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5B638F7F8
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 04:14:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhEYCP3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 22:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbhEYCP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 22:15:28 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 249C5C061574
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 19:14:00 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id ot16so14005528pjb.3
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 19:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sKZchoMeNIM9v0WERXatVWCtVJhtZtW5sQS+9Rcv1DE=;
        b=H75g4pjcWyBQD0834arYl0U7a2s3fRUSTRH/cj4MofAK3ClAk/nv6ts1p8wMEHmwQO
         fyIg2nd+cS8BNkSpFM0DmZTpT517czwzK+7P2WpSyR9xZIe0YOv2w2BOfpbBJi5Zr10F
         nX6zAxHtwpuvu2GYMS4Kmy6BXXJC9uZD65e7Xv0qQyKdsBTT1l9gLwIvcnZWvHSG9wuO
         WHwyAGubzxkW8gToYv08u2J446bhVIgad/53Sa6UStrz4dT21OiVmMd1gxKis6bgwRv7
         rfiT9mqS5BTFEu+7VaabIpArQR4B3aUIC/7bkTLRsrHb5TWyr3SAx+DVNvoaJ2HIRFmA
         7Z9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sKZchoMeNIM9v0WERXatVWCtVJhtZtW5sQS+9Rcv1DE=;
        b=og1SeOqm85mSQTHSISFSwIh5UblnLNrf3qIhkko5nxmp/tHJ1CaaKfDLn1lya6b8iP
         guxNTv6qjOv9AXNoc80/xqJ+FkxPZENMFR9NvH/pv5ejgtehEl+yAUliYoeYhMijol/P
         HR/SaLJoxjk4Q4upjVb4J5ReT0ivE4lr3/x6xW4sZnPqAGbQbQdOFlGLrnqIn31+E3vj
         bjCOTW0JDKC6q5PhXLm2CCXtKk08tNqS0U29SA9Q0xat7hKDl4g6prSmw1+TRl1V9H+I
         T8jR+1zhuSe5CQyFlCPIY3cZB3Ew0EEw/VPEIpfMo9tLIm3SElJac+ctre1FXWGqJdZY
         fdvw==
X-Gm-Message-State: AOAM5324Yw+uknLNYiKSYE+WCJntTR9ydhMq6jD76X/IIjGvQgEqaWqu
        G7fuovgowDl9J5Bo/X//kgg=
X-Google-Smtp-Source: ABdhPJw/redK/i2mwQrsoCTl+fua5l5Tpw6eQ9osyupnYXkpIN6Mr/UyiNphYBJ2IWkP5u1bQ9w6qw==
X-Received: by 2002:a17:90b:14cf:: with SMTP id jz15mr2278576pjb.105.1621908839700;
        Mon, 24 May 2021 19:13:59 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id n2sm10983175pjo.1.2021.05.24.19.13.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 19:13:59 -0700 (PDT)
Subject: Re: [PATCH net-next 01/13] net: dsa: sja1105: be compatible with
 "ethernet-ports" OF node name
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210524232214.1378937-1-olteanv@gmail.com>
 <20210524232214.1378937-2-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <525245ce-107a-2255-f6de-14dea426bed0@gmail.com>
Date:   Mon, 24 May 2021 19:13:56 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210524232214.1378937-2-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/24/2021 4:22 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Since commit f2f3e09396be ("net: dsa: sja1105: be compatible with
> "ethernet-ports" OF node name"), DSA supports the "ethernet-ports" name
> for the container node of the ports, but the sja1105 driver doesn't,
> because it handles some device tree parsing of its own.
> 
> Add the second node name as a fallback.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
