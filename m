Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 635CF3DA6EB
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 16:55:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237662AbhG2OzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 10:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbhG2OzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 10:55:06 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E346C061765;
        Thu, 29 Jul 2021 07:55:02 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id w6so8764473oiv.11;
        Thu, 29 Jul 2021 07:55:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=B3EdUz5kSnhIEeKCBjSBk5i2bybsv3755M0/yOTbDTI=;
        b=KW/41mDKX3e3sektwlY5RmT8ziahBntyf7WHBJzj9L1lKuASy4FvxfSqewdrXHsgmW
         rbtSolPWyxzm3Ow7eUq3ogD9NYFl1B9+u8C1WVzKExNQKimiBBPudSbfqpOsuCNkFHIG
         O83RiT1hAX5iMVmalgz6qy7/JSHSe1bDo7uK7aGh1aQ4iw5u1LWnCNkJ98CPGO40RdTM
         bPjcnLCtkDBHQo2Ls7xT1ArC9Il7FEY/b9tkVQ9S5p3USu4R1XZmN/bvuv104IadweOI
         khToirqfTiJ2Zjh+4wcDJlAh/D7UfzOpq47Iox5wJhN9tU3oFRn7uuZ51DFplrGkiWi2
         VuCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B3EdUz5kSnhIEeKCBjSBk5i2bybsv3755M0/yOTbDTI=;
        b=P6Dth6e45oXIrD841X/f4GYlTxX+IhSUMrmPBJW7tKBp3ZYwmlUcrYhyYthxlI90y/
         OFGBb7/YrvZJ73gaQJmguCmTFeVdOUeM6iwlXgFbnJMh16uhWhsTxO2lb4FwC5K0/k5N
         mnY9ya0aY9Eu9I+oO/c8W8zFohm8bleYpz0r2thpvizJhPVz2WzDb/xcHJIXjkM3t+V6
         ywVbx0xC0dMl2itu48jLv/hFJswnVQRC2dbRgvFMXUyTG3HR79OTu3OGcpzu9EMO7ECH
         GdYToFD65wcyMx2Ij477FNad3IDp1RXUBkozQpFGUgm/Z7xpYnS1lOiG38XdIbbCsnZu
         vuyA==
X-Gm-Message-State: AOAM532mpgnDWPOhXy2kp2kI1K/gEUHRfY/VxtvtOGz+bxOCEC1/5clq
        MaadQpnav5moJXl7me8I4Ag=
X-Google-Smtp-Source: ABdhPJx6+nHV08evZUdonQj6NNZi27UC7UCJnV8IWW40jY+QTOvH/fYFHJ1cBDjfxdLE28vBFHqKzw==
X-Received: by 2002:a05:6808:216:: with SMTP id l22mr3327611oie.24.1627570501827;
        Thu, 29 Jul 2021 07:55:01 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.27])
        by smtp.googlemail.com with ESMTPSA id s6sm570790otd.6.2021.07.29.07.55.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Jul 2021 07:55:01 -0700 (PDT)
Subject: Re: [PATCH] net: convert fib_treeref from int to refcount_t
To:     Yajun Deng <yajun.deng@linux.dev>, davem@davemloft.net,
        kuba@kernel.org, yoshfuji@linux-ipv6.org, dsahern@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net
References: <20210729071350.28919-1-yajun.deng@linux.dev>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a7769248-d612-4bfe-afe7-b5457a9f0606@gmail.com>
Date:   Thu, 29 Jul 2021 08:55:00 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210729071350.28919-1-yajun.deng@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/29/21 1:13 AM, Yajun Deng wrote:
> refcount_t type should be used instead of int when fib_treeref is used as
> a reference counter,and avoid use-after-free risks.
> 
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> ---
>  include/net/dn_fib.h     | 2 +-
>  include/net/ip_fib.h     | 2 +-
>  net/decnet/dn_fib.c      | 6 +++---
>  net/ipv4/fib_semantics.c | 8 ++++----
>  4 files changed, 9 insertions(+), 9 deletions(-)
> 


for net-next so the subject line should be "[PATCH net-next] ...."

Reviewed-by: David Ahern <dsahern@kernel.org>
