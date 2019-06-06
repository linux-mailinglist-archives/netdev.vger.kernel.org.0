Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C68BB38028
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 00:01:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728890AbfFFWBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 18:01:41 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38865 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726554AbfFFWBl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 18:01:41 -0400
Received: by mail-pl1-f194.google.com with SMTP id f97so1458922plb.5
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 15:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=M3PK5kw9TMnjihO+tmpTGLb5C5K0OfKC6CrQrDWSSCc=;
        b=n8CaQPR5YxwZdLYEabkUzJKZ/oWXUx2+aQ+PqL04HTpOnn4BK1vgFDGq+9S4An2KE6
         bmPtPu9wqqH1e/txoVmGhd2HPDr1rc9Q8qXI/46R1LnsTnbn9+vkCG/6saRvHaXFRmFe
         yz7+EkpDGyMbKCJXHookWJT81b3FJoc6XvYo00cEhzEQ4I7ZuazPZ/GIqWeKcMNAU06Q
         8e8uFcti1SZ9AXW5Xy+M3bf4MIrSPf8Oq5nnzmTLO5ycS8oN3eSw/XhmCe+X5atBfdCL
         n9Zp0+jHxsLMKRzFP1snVy+nNe+C4VC3Zw7h+5Lt+4SYN9wXGgN+s/05aDeUqysIZFR6
         3vQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=M3PK5kw9TMnjihO+tmpTGLb5C5K0OfKC6CrQrDWSSCc=;
        b=I0crpAfIOq7pJkJgQnR+juwYg5MhAPx75zrjo/DvhjhAWmjwMovO2kYBKS29NcpiHy
         zWb/PZlZBjrosmGzaGtIVr274ehSwefARyjm1vtmwxM5tUYB8dz4aEZYSOIAh7G8ULs4
         vWO1M5EF9KHihMnX1F3mNJmBQAHVdQNiqrHg8GfeXQEWBdBoZ+Hx3Br5UkREyzIpqhQn
         vOi0zMvqYsIUv6ckng7QMso74jnE5oIZ/BVUpTH36RdIm5VW04qXNChgJMoa3byTkbVz
         MBvNDwmEAX+rRHJsV+681gcYwq5+rLU0295sCfWvYzIYltrgdQQ19egovEeedlv3Sqka
         hQeg==
X-Gm-Message-State: APjAAAWZq7VPqgzgC1jTgiqjrO6sBzdavJq3k/JmY6fFzcJC9iSgwURp
        frsp4Me1NLCsK4kfrInRdgw=
X-Google-Smtp-Source: APXvYqx6uo4TZT381DgKsnY0HW/rTt2w+ggPdEKeqqQd4FWM8Ayc1IOFV/qXeI3SmqR/7rBWavofYg==
X-Received: by 2002:a17:902:21:: with SMTP id 30mr51898407pla.302.1559858500963;
        Thu, 06 Jun 2019 15:01:40 -0700 (PDT)
Received: from [172.27.227.250] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id j64sm130809pfb.126.2019.06.06.15.01.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 15:01:40 -0700 (PDT)
Subject: Re: [PATCH net-next 01/19] nexthops: Add ipv6 helper to walk all
 fib6_nh in a nexthop struct
To:     David Miller <davem@davemloft.net>, dsahern@kernel.org
Cc:     netdev@vger.kernel.org, idosch@mellanox.com, kafai@fb.com,
        weiwan@google.com, sbrivio@redhat.com
References: <20190605231523.18424-1-dsahern@kernel.org>
 <20190605231523.18424-2-dsahern@kernel.org>
 <20190606.145203.79468452299179891.davem@davemloft.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b317921a-a540-58e1-61e1-11d45ba1efd2@gmail.com>
Date:   Thu, 6 Jun 2019 16:01:38 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190606.145203.79468452299179891.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/6/19 3:52 PM, David Miller wrote:
> From: David Ahern <dsahern@kernel.org>
> Date: Wed,  5 Jun 2019 16:15:05 -0700
> 
>> +		for (i = 0; i < nhg->num_nh; ++i) {
> 
> Please "i++" here, it's more canonical.
> 

I am stunned my fingers even typed that (++i instead of i++).
