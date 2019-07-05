Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 512086096F
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 17:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbfGEPhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 11:37:18 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:42451 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbfGEPhQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jul 2019 11:37:16 -0400
Received: by mail-oi1-f195.google.com with SMTP id s184so7408504oie.9;
        Fri, 05 Jul 2019 08:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GL9oaQ7aSmi87cgYtRx3op+78jgv3Fv6Jy0wzvHhBt8=;
        b=sZ4OLw4Dc6sqhgU4Mq+GY/FN1BgB1Y13l2wW8vgl9NBVZLbQLQtWe/pNH765J2su2S
         5V8eA6+btAIuXz9laMNsqX3ji96AGLdHypTbXJus0EbqSVzd0pem6m7zad0CLXjsSrwo
         dfAF8Wjw1reBJzaonp+KxbubbGFK8oXAnCUaNYs5UFCZDmrrdRfj3qKaesYc/tVMFxhG
         kzkY9v+F+j2+fiI1QeVmHdCTBh14BEybC17StzOJPB+dP0bHVJglnGZYD4vynSKdrur+
         RLWAdogjw48SYBgJdfmTLteTxeL7ZmB7Ho87nwYnJSgflHqRo8FdwOLTpvL8pQV7ush4
         c3UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GL9oaQ7aSmi87cgYtRx3op+78jgv3Fv6Jy0wzvHhBt8=;
        b=SKb5arAQ6d0v/mobfDgNGevZpx/fkJ4GI8yxMef88Tm3R0Fi3scXQ5hRRC0h0VuHdw
         ecHaRjHcxzjPKhiGpezJ7902ZL6adXmjWEzhEnAp5LaxpS37cqQg4IIvSvLlh0sbFAlE
         Z0egvB1SOQSXZQ7t5HuyALAFQuAVHMtkj6q9tkQ/RT+ApjTPaoz68Rsv82H8FYWMOLmk
         ZGuxWAj5nddOGh6NyqxgAHpwks2E5umnWDPUgH7xUjl2WAH9VPUYL005YAustLe5+H3R
         1w3qRxHDDwCnIUc7osc3ncTsF0P+HCYqkdQKYe8wz5MmQOHYrenb7qomqHLTtiT6+Skq
         ZnIQ==
X-Gm-Message-State: APjAAAWxm6amOiY63Ro5uxYItz9gOujv3EisdrsYBUheeueUwuMYJ5/w
        Fh7BV/p/UkC01ttg34iakZOUXMS8
X-Google-Smtp-Source: APXvYqyP8GjJc1akuas2Yhv+I0GMhMqsycyajMD5d0MKgEHdLPf6bazVxYepkqGauzX+ifvt1bc5Jg==
X-Received: by 2002:aca:d648:: with SMTP id n69mr568317oig.46.1562341035523;
        Fri, 05 Jul 2019 08:37:15 -0700 (PDT)
Received: from [192.168.1.3] (ip68-101-123-102.oc.oc.cox.net. [68.101.123.102])
        by smtp.gmail.com with ESMTPSA id y4sm3222371otj.56.2019.07.05.08.37.13
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Jul 2019 08:37:14 -0700 (PDT)
Subject: Re: [PATCH v3 3/4] net: dsa: vsc73xx: add support for parallel mode
To:     Pawel Dembicki <paweldembicki@gmail.com>
Cc:     linus.walleij@linaro.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190704222907.2888-1-paweldembicki@gmail.com>
 <20190704222907.2888-4-paweldembicki@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <f40b8651-05b5-3e1d-6f6a-2d9f5cf2d2d3@gmail.com>
Date:   Fri, 5 Jul 2019 08:37:12 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190704222907.2888-4-paweldembicki@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/4/2019 3:29 PM, Pawel Dembicki wrote:
> This patch add platform part of vsc73xx driver.
> It allows to use chip connected to a parallel memory bus and work in
> memory-mapped I/O mode. (aka PI bus in chip manual)
> 
> By default device is working in big endian mode.
> 
> Signed-off-by: Pawel Dembicki <paweldembicki@gmail.com>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
