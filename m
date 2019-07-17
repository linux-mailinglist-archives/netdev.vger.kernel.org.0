Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60E536C2E5
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 00:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727916AbfGQV7W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 17:59:22 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:33101 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727543AbfGQV7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 17:59:22 -0400
Received: by mail-io1-f66.google.com with SMTP id z3so48302444iog.0
        for <netdev@vger.kernel.org>; Wed, 17 Jul 2019 14:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2+1Oe5nAuSvur0+3dFkrvLQOQDX2hju3iPqHMyZSNSg=;
        b=qSCj7CCTXOk1u+lKA0JcljBIdKrLxtlYoJs6lfqiqKs6l+E8mNLgOIgesPU3VkIicd
         B6J8qOx8/4cLyHkFbugNixtsYXcLsXhg1zc0dfHxjf8LfCKv2slqos6MgfL40IN7//Fh
         j9zITpoDRCPQtRy6YRM1Fw5Ag1GmS4Lp4kMLwlD1KyTUbrKMXwI+y/Ze3RNkdcain2lp
         Ot8XL337XuQpr+9ALmnfxxxQwhx2yD/Q7BToV9s1tUzRK1RbgFiPO6B1Id+PMiU/HdxY
         llxFwnNFsUEF/XPp0qHn9yN+WTGbuP5DyoOsAv4f9zGOGB3rRnk4b8JZOwlzc/ZLEznJ
         FNpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2+1Oe5nAuSvur0+3dFkrvLQOQDX2hju3iPqHMyZSNSg=;
        b=Lm35XRjrWhi96zvdDm9lWidMRzKy+FMwz7vCzX4LlvRCuq04tgKX/+U/9BOdeACSCK
         du/yWYsD6gtt2pYYfwveyzH0HxaU4DtloFgQ15jxnVi816kymS4IFFJdeoeDx+rmpO9D
         OphOYVQ8OEqaBXtXnoMpCGYfxcCLOkKpEDOEdR2/9gKXTjbEaHrr/YJzpfuYUqFXp277
         76DqB1fhy+BrOmNo2ILc6CFcpSs5I9gTuTQ/Fopz5Q+/mDcXAjxYFvjmIxWj88U6zUSB
         7QO5wZb8VFDON1NnapEnasfXoXzUh+a5NndsMjcznWM7wfWXvzmjOHmtk9EaC1XxLBbt
         KHKw==
X-Gm-Message-State: APjAAAVE4jEBcZxxi9PPuyBty9Wm4uqNXdDrxMImg2WXY3c3l5v2aQ7j
        8uMFqZd5tThPQZ7ZcJ7uTS4=
X-Google-Smtp-Source: APXvYqxyIuyCEPVbchblnkBXSAQPs0FrJrANqFNBx2EG2rgZ3IJ55jltRIob03RXdgUsWgRzKF5gcQ==
X-Received: by 2002:a5d:8347:: with SMTP id q7mr36855899ior.277.1563400761412;
        Wed, 17 Jul 2019 14:59:21 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:5059:73bc:5255:ccf5? ([2601:282:800:fd80:5059:73bc:5255:ccf5])
        by smtp.googlemail.com with ESMTPSA id j23sm19583011ioo.6.2019.07.17.14.59.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 17 Jul 2019 14:59:20 -0700 (PDT)
Subject: Re: [Patch net v3 1/2] fib: relax source validation check for
 loopback packets
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     Julian Anastasov <ja@ssi.bg>
References: <20190717214159.25959-1-xiyou.wangcong@gmail.com>
 <20190717214159.25959-2-xiyou.wangcong@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4b5beb7c-a6f7-3a5e-d530-88638dde1ef9@gmail.com>
Date:   Wed, 17 Jul 2019 15:59:20 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190717214159.25959-2-xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/17/19 3:41 PM, Cong Wang wrote:
> In a rare case where we redirect local packets from veth to lo,
> these packets fail to pass the source validation when rp_filter
> is turned on, as the tracing shows:
> 
>   <...>-311708 [040] ..s1 7951180.957825: fib_table_lookup: table 254 oif 0 iif 1 src 10.53.180.130 dst 10.53.180.130 tos 0 scope 0 flags 0
>   <...>-311708 [040] ..s1 7951180.957826: fib_table_lookup_nh: nexthop dev eth0 oif 4 src 10.53.180.130
> 
> So, the fib table lookup returns eth0 as the nexthop even though
> the packets are local and should be routed to loopback nonetheless,
> but they can't pass the dev match check in fib_info_nh_uses_dev()
> without this patch.
> 
> It should be safe to relax this check for this special case, as
> normally packets coming out of loopback device still have skb_dst
> so they won't even hit this slow path.
> 
> Cc: Julian Anastasov <ja@ssi.bg>
> Cc: David Ahern <dsahern@gmail.com>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> ---
>  net/ipv4/fib_frontend.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 

Seems ok to me.
Reviewed-by: David Ahern <dsahern@gmail.com>
