Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69A9D1008E2
	for <lists+netdev@lfdr.de>; Mon, 18 Nov 2019 17:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727316AbfKRQH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Nov 2019 11:07:26 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:42886 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726216AbfKRQH0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Nov 2019 11:07:26 -0500
Received: by mail-pf1-f195.google.com with SMTP id s5so10587058pfh.9
        for <netdev@vger.kernel.org>; Mon, 18 Nov 2019 08:07:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=s37Fn/CyFpWuAOnAOoUTfWzb6xdQS02tIs4lENoIT7o=;
        b=TeThbbWXLp0w5JGGLTbjoXPDGnuLv4KKDhUlMb4z8E8IGqOi39pTF3qLSMnFXr8OMx
         D0/S0DOpfiyXn6iRoA2EZutDngC/qYKAy7feFfcwsFn7CKnzcMusssL4CLLleEI8cW3T
         rk0G2zWTqL9ZG6I7/AzIL39i3HryOB/c2DjmJ9ywuJ4oxVfJ45XFm9KMIu10SiOkIS1L
         ico4CWO+L/4xDozJ5Cd3zSvnQ3KmoAlaFb7alfMu1B8qD2k/+/OG8AcO1BR4SPGhYiQb
         phXrj2BKQvmN109T8kMEgH58ue8JbLZq2HAl17uxZa/xUNN9jHrGWokaFb/7UdrNofWs
         HHhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=s37Fn/CyFpWuAOnAOoUTfWzb6xdQS02tIs4lENoIT7o=;
        b=a+DeiQ+DPs/X+79FiOt/DQApuTDtWb8/xbuTdZKKB/YnASUg21CAMKdQfcFLYQAXUI
         QyWR4fYJez3OPJ6g8IwCebHl7+FOLWjot0FCiXgpfRm8FCy6SJFltTtUGdUKX3Q4Efbf
         fagEx29t7MoR4SChmCaU1kxiPH6IXA+Z5J5kQzYtIrbfFGQCKhOVoakIOLlmxeq192uH
         vIr2fnqIIo+46Orzv5CcaP8PY87sK0lDIG41FW8BPXSwUYa+mZ86rr2xCDpnwFGBGjVC
         GQLCsJ+NAPYba8DOFQE/F+cCAVDnmiYKU5P3S2P9mLqNzREqlJgGpPmgmBmeHuEzgkz8
         Y8tw==
X-Gm-Message-State: APjAAAXxjTi5z2X8b5hOGEvMdSr9fxFzgW9Q82p+OnQHywokG4euQL5V
        MP2SWFxgYPKJBQsY/X7QPOo=
X-Google-Smtp-Source: APXvYqwFbnwWW4od6CVt4PxaKZL2SakrptbYjKECW6KDQTIgWU1I8NNOEAImot/BKGLOV16D86MfOA==
X-Received: by 2002:a63:1e1f:: with SMTP id e31mr1895pge.303.1574093244131;
        Mon, 18 Nov 2019 08:07:24 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:bd88:fb6d:6b19:f7d1])
        by smtp.googlemail.com with ESMTPSA id y17sm6377636pfl.92.2019.11.18.08.07.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Nov 2019 08:07:23 -0800 (PST)
Subject: Re: [PATCH net-next v2 2/2] ipv4: use dst hint for ipv4 list receive
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Edward Cree <ecree@solarflare.com>
References: <cover.1574071944.git.pabeni@redhat.com>
 <592c763828171c414e8927878b1a22027e33dee7.1574071944.git.pabeni@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f81feaf9-8792-a648-431f-be14e17e2ace@gmail.com>
Date:   Mon, 18 Nov 2019 09:07:21 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <592c763828171c414e8927878b1a22027e33dee7.1574071944.git.pabeni@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/19 4:01 AM, Paolo Abeni wrote:
> @@ -535,9 +540,20 @@ static void ip_sublist_rcv_finish(struct list_head *head)
>  	}
>  }
>  
> +static bool ip_can_cache_route_hint(struct net *net, struct rtable *rt)
> +{
> +	return rt->rt_type != RTN_BROADCAST &&
> +#ifdef CONFIG_IP_MULTIPLE_TABLES
> +	       !net->ipv6.fib6_has_custom_rules;

that should be ipv4, not ipv6, right?

Also, for readability it would be better to have 2 helpers in
include//net/fib_rules.h that return true false and manage the net
namespace issue.

> +#else
> +	       1;
> +#endif
> +}
> +


