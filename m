Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEF054D029
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 16:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732070AbfFTOQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 10:16:32 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:38508 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726686AbfFTOQc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 10:16:32 -0400
Received: by mail-io1-f65.google.com with SMTP id j6so1952088ioa.5
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 07:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xAl7DrbbI/ECIry2Iy7DKv6jS+SBAOcqni7wIydNAi0=;
        b=qW9HM31bf7khFMxJyCc4tTMIa+OYpRngJUgaqsiKTM2EJMi0rPFR6GSt/kLjm/dbe+
         fvfThFat50k6d4dihTJsUIJHH33aQz+9jNLP149PypIiArOIr0sLsadQr+8LtgSjqb1c
         ITxLdw8ZugfOMDFRAU/kSqlUXP1G1+JEIU9NBTI13LP4vO/RVExGhAGcyiYVCmLBTlK6
         w7Dp0ZuEu1bO14Y19MPulIgPSVvMqXKLcsgMt06oxznL0itUc1m5XX0PAArKx8x4ITM9
         +dO/X2UYrF2pyro0QXWTK+BM5IQNi8Wv539YWnEYz+IPOqdCuQSvTFDyyfcz88fIsn54
         WRVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xAl7DrbbI/ECIry2Iy7DKv6jS+SBAOcqni7wIydNAi0=;
        b=fcQINCZMe9xcP0SqGhNPTuNvRPRtjHZrt7DPMadRKFV2Ngatef1pjWY9e6J3qc7kzw
         g1HB36VBXC5iwIN6scy+AWkuMXAfnN/hswJ0D4mMMNxeKqYcze5w5tBsH/Hk1vEFZqx5
         p2loLRulwZoAHYe75dUAw4Mj6DeBEOuViW4TtE20okXZJ4N9NGBVYY8d5jgqm+kYXrFb
         yo529tJs+kdGApa3cNbw21Xl9I8i9uUfObA7mttYZcM51zs/LO1ihjVQKLmLyyQ25lgX
         xyfMleQ/gDDUdQt9dFJztwBjSRqMA2it9AUdZoctmEbE9TIdE5FmpYRDYhO/BSgLavIZ
         2rDA==
X-Gm-Message-State: APjAAAU7CNjljguwGHEtThq60DUpPj77Ncwpp0TsrG0HHt76jGVosi9R
        D+pBwVD3bIoVqzaElRO65o5Ffv8C
X-Google-Smtp-Source: APXvYqxumpwjRpKPhP6iaPDAU9Z7DZX0li0T2ZlIlXquv8FaXYMVUT6PllZzwakzeH+FJFf1+3jIMw==
X-Received: by 2002:a02:5b05:: with SMTP id g5mr98797252jab.114.1561040190945;
        Thu, 20 Jun 2019 07:16:30 -0700 (PDT)
Received: from ?IPv6:2601:284:8200:5cfb:9c46:f142:c937:3c50? ([2601:284:8200:5cfb:9c46:f142:c937:3c50])
        by smtp.googlemail.com with ESMTPSA id p10sm14067740iob.54.2019.06.20.07.16.28
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 07:16:29 -0700 (PDT)
Subject: Re: [PATCH net-next v6 06/11] ipv6/route: Don't match on fc_nh_id if
 not set in ip6_route_del()
To:     Stefano Brivio <sbrivio@redhat.com>,
        David Miller <davem@davemloft.net>
Cc:     Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
References: <cover.1560987611.git.sbrivio@redhat.com>
 <18a49a3a5d0274df90f059f37d3601abd0bac879.1560987611.git.sbrivio@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <402be9f4-262c-b185-46a9-d5d4bb531cf1@gmail.com>
Date:   Thu, 20 Jun 2019 08:16:28 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <18a49a3a5d0274df90f059f37d3601abd0bac879.1560987611.git.sbrivio@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/19/19 5:59 PM, Stefano Brivio wrote:
> If fc_nh_id isn't set, we shouldn't try to match against it. This
> actually matters just for the RTF_CACHE case below (where this is
> already handled): if iproute2 gets a route exception and tries to
> delete it, it won't reference its fc_nh_id, even if a nexthop
> object might be associated to the originating route.
> 
> Fixes: 5b98324ebe29 ("ipv6: Allow routes to use nexthop objects")
> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
> ---
> v6: New patch
> 
>  net/ipv6/route.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 

Thanks for catching that.

Reviewed-by: David Ahern <dsahern@gmail.com>
