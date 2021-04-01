Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95184351B62
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 20:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237380AbhDASIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 14:08:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237225AbhDASDc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 14:03:32 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1653C0A3BD1;
        Thu,  1 Apr 2021 07:10:10 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id x207so1916150oif.1;
        Thu, 01 Apr 2021 07:10:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iz2TpB7naaU3PCLy/XbmuGKh0b9HvwvTUFGq+CZiNMU=;
        b=ADG7liQV0cqVmaNb28NDFlgus/MZR3KP3BfoBoQbc3h8L4wDIlwBr72hPjo0nubrTE
         JVLR5T0PED/DU/3DibT3/6kkCv3wJg3G5JjVwfPa5ketoCq1504E8CdZ2d+eJrXp0msK
         iulCyod8bskseB2xs9Y+I6UzoSw+1+Ex13iarNXS8ppWOrjHNcjwSkoh6ZNQjrVtEA19
         xNVqp1pG7I8XsjiC86HKohrtFH4kp5ZQFxFs8LmAB2L/R37arIZYYZHiIs4OJluczAOQ
         SRPvyQyUATWDkVzxQEkPToiN5UZ9Uz6jMGbZGPzjGptkxJ/cBy5xp3JOp8JyAEdTdWy9
         2pwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=iz2TpB7naaU3PCLy/XbmuGKh0b9HvwvTUFGq+CZiNMU=;
        b=dp4htqjHXyIgH8NY0XLpZLYR9YJ6j2Jd+jHwrNwsFZDJHZLPwWvoMFNQgqMQfN9KT5
         RQeX3Ks6lh5beej4mu0SefBGbV+YHGNJ3vb99OqFVH24asEb/Nv3LQBG6Yw9Jt50Pqbl
         ifuIxoXx3QHW50E9ckVsYIMs626z4d5ge4kJFtOcV77lDLXLafKE/u9AY/HIcojUo0zv
         R2lPdHHxAdxUZ28VYZF9RqxAJWaxCQG71AeuWHMrykenkZoPqJn8ELNCLYFh0cOvJ0fe
         vI4UZ/13ap9J5ADU1h5h3HgQbOIbBFmMXPpIa230HI1Fz6Br5KV5BhQ0X1iUyVgFxKqS
         k75g==
X-Gm-Message-State: AOAM530RlHl/+ioQ9yNcRa//LyVvh7gJfKttm5qTpmD7w/XgOMlJSwRw
        qRUyURGhSq5E6YObx9xs8cI=
X-Google-Smtp-Source: ABdhPJxuUT9JsiVbTtyPNgUpwLgIWQY+9cKckQqcKDcNgU5hJU4v5bc5iTazFozvjNI90jmah6+22w==
X-Received: by 2002:aca:b244:: with SMTP id b65mr6205217oif.134.1617286210133;
        Thu, 01 Apr 2021 07:10:10 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id a7sm1114401ooo.30.2021.04.01.07.10.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Apr 2021 07:10:09 -0700 (PDT)
Subject: Re: [PATCH net] net: udp: Add support for getsockopt(..., ...,
 UDP_GRO, ..., ...);
To:     Norman Maurer <norman.maurer@googlemail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, dsahern@kernel.org
Cc:     pabeni@redhat.com, Norman Maurer <norman_maurer@apple.com>
References: <20210401065917.78025-1-norman_maurer@apple.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <27c645c8-c60d-0a92-e484-8b95d1bf437e@gmail.com>
Date:   Thu, 1 Apr 2021 08:10:08 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210401065917.78025-1-norman_maurer@apple.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/1/21 12:59 AM, Norman Maurer wrote:
> From: Norman Maurer <norman_maurer@apple.com>
> 
> Support for UDP_GRO was added in the past but the implementation for
> getsockopt was missed which did lead to an error when we tried to
> retrieve the setting for UDP_GRO. This patch adds the missing switch
> case for UDP_GRO
> 
> Fixes: e20cf8d3f1f7 ("udp: implement GRO for plain UDP sockets.")
> Signed-off-by: Norman Maurer <norman_maurer@apple.com>
> ---
>  net/ipv4/udp.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


