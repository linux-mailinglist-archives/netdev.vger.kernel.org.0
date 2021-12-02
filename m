Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 628B0465C45
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 03:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354955AbhLBCpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 21:45:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348543AbhLBCpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 21:45:45 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8757EC061574
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 18:42:23 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id x3-20020a05683000c300b0057a5318c517so7808391oto.13
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 18:42:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=zBWecEJC7qnc085ASpGHy8GCzy8WEB+uI8PPrCc+M7Q=;
        b=JiB0FI7rfgEWGT1QfWlh4L8QntwwrfQeiQXzEZoK3D6L0ozZFFaeymNFbq+faBecbB
         3LZXhFx4pLcNGANH07DFs3q3weIwT9xh2xxeTFA1mtvNnyE5V7ILqsaiE4hSQdbxhZ61
         OD+rlpoQ/Iwwdxpx7MoTME7F+S9ycKQFAsgfxb3keyconkKl9arl4a78m2eREgEm2rOt
         k1deXDNgnvfW/yUwD9xDIrUQevNh7qg0o8NOfv5Ofy9RCRiC5Gv6ofHuITqebOk0sjWX
         0Gu4ur3VlrZb3OyxJV+aVm6AQoh5gdNEHGd2QB4NlEPU2y2823SFuo8zGWfpsEv8mGoi
         Ol0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zBWecEJC7qnc085ASpGHy8GCzy8WEB+uI8PPrCc+M7Q=;
        b=6CgNGUkIC/GqTbIpf8+j+fhdxm2RfV06dLry1l5nP1fYEV2Ox2vNeAc3+d1eBaA1ec
         YL/EZuTXWK2SbLJUhHyRDz/47LYk/6uY0SsM73/LBbd2LBPv9Ns/SqHMwsiid/J+LgN2
         yVdoQdTOG5MCv2iJLnDlhMHVzDxrZS82lnVx13RG1gFBd2L9ekUh4WEkE91xNwz0FrDK
         XgkTgziE33FbiYYBpt4KfkE7LSeI03o4/FdKJaspzHAR5u214ySDdnaKHIzdKCdH3Cw/
         mIy4bqwociwUwAy9+hEm4Oj2MH4Htg72Qcx19J8IzzTWyjZWKfKbXQgrKJCSgaPjp3Ka
         wSNQ==
X-Gm-Message-State: AOAM532gV4xVuH31d7lP50AwcctxP7cJtr/dAqpCr6tINCAB4LTQGbD0
        jQMD4OP6hQNDUf7CwEDy6hM=
X-Google-Smtp-Source: ABdhPJxhHnQPKWZJq1UfeZtM5RDsQC9lV4towINkQD5KE/c4NErVQs+Z/z9x5KKW/zhsb78H/jJmJw==
X-Received: by 2002:a05:6830:44c:: with SMTP id d12mr9151744otc.66.1638412942910;
        Wed, 01 Dec 2021 18:42:22 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id n6sm673468otj.78.2021.12.01.18.42.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Dec 2021 18:42:22 -0800 (PST)
Message-ID: <0369c4e8-e19d-d376-06f1-3742da0cc003@gmail.com>
Date:   Wed, 1 Dec 2021 19:42:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: [PATCH net] ipv4: convert fib_num_tclassid_users to atomic_t
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>
References: <20211202022635.2864113-1-eric.dumazet@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211202022635.2864113-1-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/1/21 7:26 PM, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Before commit faa041a40b9f ("ipv4: Create cleanup helper for fib_nh")
> changes to net->ipv4.fib_num_tclassid_users were protected by RTNL.
> 
> After the change, this is no longer the case, as free_fib_info_rcu()
> runs after rcu grace period, without rtnl being held.
> 
> Fixes: faa041a40b9f ("ipv4: Create cleanup helper for fib_nh")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: David Ahern <dsahern@kernel.org>
> ---
>  include/net/ip_fib.h     | 2 +-
>  include/net/netns/ipv4.h | 2 +-
>  net/ipv4/fib_frontend.c  | 2 +-
>  net/ipv4/fib_rules.c     | 4 ++--
>  net/ipv4/fib_semantics.c | 4 ++--
>  5 files changed, 7 insertions(+), 7 deletions(-)
> 

Thanks, Eric. Was this found by syzbot or code inspection?

Reviewed-by: David Ahern <dsahern@kernel.org>


