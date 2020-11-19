Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC182B890A
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 01:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726468AbgKSA34 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 19:29:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbgKSA3z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 19:29:55 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95457C0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 16:29:55 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id o11so4073862ioo.11
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 16:29:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZK1vUEXeqoHRoqnLitd39ulcwOOocBB+BGiFNkhT5D4=;
        b=RsbePTN/XwyX8xaxO9i+rxrEphSK3ooASaqV77FdCYHiMpzj/hgJ6ql5AD5BpvxF9y
         E2515AMM+lTLBjyazSVQa80lddOm/3wS5vx66h60D5uu9eLwvK5NQGLb/7+FISRQc7T/
         NxW2DM2f8A2c2jhS/kUuEcQDR8O5XBzBb7Tz4qt05TJdViDC/qyTIiKX+5sIvdUgdphW
         3tGH2RYeg9ZIeLgVbcMe7AmEaK8hxWq95lKExg18T2lkuWtMZzUIb25p/SkniSSiaqsn
         J4S9mwtNEHnRq9vyzjIKoLQwBMyMbKubzjysE0OpWx/uUznmxucC7EYKvQ8FE6F24Jlg
         yrxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZK1vUEXeqoHRoqnLitd39ulcwOOocBB+BGiFNkhT5D4=;
        b=RSYIBva0ww/rocgWVVyiqMbj+uYtvAai3r3tiYGE73UlxKyBidlUGUodeYhmnGtO2Q
         N3EL143Bawup8m1boKgpLvS5TXvjIhAsZTUoaSqNEWrOrovI/Pb1jjxy9W/K1L36iJlz
         gjBFjb8TW4QutId3FS+duJEbKdhB/2bjUNozpKgY1iZ8HAWie7F4/TlBTDmmOlX1ZCJR
         1CI9COFbZ9WAtswuGpYm5At50xuvDFfVMw5LyS/yUDZkCKdqV5T/WUCcMqmiHPxuwLWp
         u3k4scW2daWeGGHncVUs9WgQck8K8fKWmsTOwRM2F/45i5D9ldsCc8Te27qgv8Z+eo9R
         iGMQ==
X-Gm-Message-State: AOAM533piDpOTRpSvFgBlFxa4cDf2bIEBBTqFeuc5vP8FHIb4LUnzDAj
        7xj6wGV9reoEBEvtKnHcxqF37bcPZH8=
X-Google-Smtp-Source: ABdhPJwZGxUunMlKo1/2CZm9LEFdwGW5kEbyk8DwH8A1thG9HbCyKGVRLLR9FYwaSOg2ri/406FOTw==
X-Received: by 2002:a05:6602:2d09:: with SMTP id c9mr18368827iow.55.1605745794852;
        Wed, 18 Nov 2020 16:29:54 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:284:8203:54f0:70e6:174c:7aed:1d19])
        by smtp.googlemail.com with ESMTPSA id u1sm15974305ilb.74.2020.11.18.16.29.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2020 16:29:54 -0800 (PST)
Subject: Re: [PATCH v4] IPv6: RTM_GETROUTE: Add RTA_ENCAP to result
To:     Oliver Herms <oliver.peter.herms@gmail.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org
References: <20201118230651.GA8861@tws>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c5c7d312-0366-83a4-b285-013c74abeccc@gmail.com>
Date:   Wed, 18 Nov 2020 17:29:52 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201118230651.GA8861@tws>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/20 4:06 PM, Oliver Herms wrote:
> This patch adds an IPv6 routes encapsulation attribute
> to the result of netlink RTM_GETROUTE requests
> (i.e. ip route get 2001:db8::).
> 
> Signed-off-by: Oliver Herms <oliver.peter.herms@gmail.com>
> ---
>  net/ipv6/route.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

