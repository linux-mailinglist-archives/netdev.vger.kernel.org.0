Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74EE99B5F5
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 19:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404857AbfHWR7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 13:59:08 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:33315 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404269AbfHWR7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 13:59:08 -0400
Received: by mail-qk1-f196.google.com with SMTP id w18so8940134qki.0
        for <netdev@vger.kernel.org>; Fri, 23 Aug 2019 10:59:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UyupcX678H/AxzDSQSGybxJu8fcHJfeR8wEVYwgKPXQ=;
        b=E3HOFYDfwew/w22T5oDHqgwjFVeWgINCXSaktneb3lDGzLKp+C1bJ1w1TrFRBwMqWv
         4mUluhKUC94tUSyWTi/PjpgItKagd+ZMYjHFEyNz7KED/XLysBJcPgfTPBUsWKNcM9MC
         UHv8bq6ScCo8bBwkqS95FfQduUQPWL6cfWkvBx1RDNHeMB9WpVnqb/Za15RvrJQq11rM
         HCLE2DFSwYvV++nMekjcLyq/ypB4crqhJPSjWKebI2jWeJ93B7zpTX13OxTgZinn63sy
         odJLYLo6pj6dOMJqDF+BAnXg4JIqN7EaSdpni5dfJmVkIknlveJiErZaDOajWy1Vz/rq
         kqmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UyupcX678H/AxzDSQSGybxJu8fcHJfeR8wEVYwgKPXQ=;
        b=ZP0citFpzjWTfEMZJNmYM/mwoeCZWc8vbfiR1hAAE6PNXPHiA8eilAB2YczRingBIM
         dXRDxIpUcm38dtBlNu6CN0IPVsf1P1826pgF9P8ISKQZ3WGlivZ2Nfm2SVr5CqvqyDHP
         hXhDZf0NRDIeYBaWsvd7iVzZ18IZ17yw5tpZ4OfARYj3B0T48E6l0GabCmH53gimDtPH
         GvbWfNScfTEHS5/KMnxhHtiQsNFCUtpcfYracdIcvh2ldG5GB4M+OSLFYkHWnB4QBgIE
         vK0ti5ZQNf8UgxGgO8q2+8G32bZULEez7pReqhggH6AjxukQVaxk8XqvM9nmnCi2Pt7N
         P9nA==
X-Gm-Message-State: APjAAAWaeI/pt+SZsUahUKzhIoe2yD81kEfHxZFTy6zEN7x8t73jVmto
        A+uNPGGsDM4UMYyFGy/vUrA=
X-Google-Smtp-Source: APXvYqyJHgWJ3DU7jbPwlvKnONk4VKmkkYmBYN5vtIJOoPhDKVC06aR9ATnRKQScDy5jcj114HAkXw==
X-Received: by 2002:a37:4986:: with SMTP id w128mr5181088qka.417.1566583147614;
        Fri, 23 Aug 2019 10:59:07 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([158.106.193.162])
        by smtp.googlemail.com with ESMTPSA id h187sm1836591qkd.27.2019.08.23.10.59.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 23 Aug 2019 10:59:06 -0700 (PDT)
Subject: Re: [PATCH net] ipv4: mpls: fix mpls_xmit for iptunnel
To:     Alexey Kodanev <alexey.kodanev@oracle.com>, netdev@vger.kernel.org
Cc:     David Miller <davem@davemloft.net>
References: <1566582703-26567-1-git-send-email-alexey.kodanev@oracle.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <38b351be-b24e-cb05-7c93-74134796a9d7@gmail.com>
Date:   Fri, 23 Aug 2019 13:59:05 -0400
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <1566582703-26567-1-git-send-email-alexey.kodanev@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/23/19 1:51 PM, Alexey Kodanev wrote:
> When using mpls over gre/gre6 setup, rt->rt_gw4 address is not set, the
> same for rt->rt_gw_family.  Therefore, when rt->rt_gw_family is checked
> in mpls_xmit(), neigh_xmit() call is skipped. As a result, such setup
> doesn't work anymore.
> 
> This issue was found with LTP mpls03 tests.
> 
> Fixes: 1550c171935d ("ipv4: Prepare rtable for IPv6 gateway")
> Signed-off-by: Alexey Kodanev <alexey.kodanev@oracle.com>
> ---
>  net/mpls/mpls_iptunnel.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 

Thanks for the report and patch. On first glance, it seems odd that
neigh_xmit could be called with rt_gw4 (formerly rt_gateway) set to 0
and if it is non-zero, why isn't family set.

I am traveling today and doubt I will be able to take a deep look at
this until Monday.
