Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0F074D030
	for <lists+netdev@lfdr.de>; Thu, 20 Jun 2019 16:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731773AbfFTORZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jun 2019 10:17:25 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:34744 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726786AbfFTORY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jun 2019 10:17:24 -0400
Received: by mail-io1-f66.google.com with SMTP id k8so266613iot.1
        for <netdev@vger.kernel.org>; Thu, 20 Jun 2019 07:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+cHd3hlDMk328Fbkhm+V+uGjcM1FaFH1lPxMqID03fs=;
        b=mLYOAw0PTVSH7k/x1k397R4NYh5ty6AWDn666JGc+KiUs0pKkH/NEfu9I3Aw0rAtLT
         eD5d00kI/bf+nV5tCwWDZgbogQWvIkH8GNnvteFkJf4AEIlyEB7ZPlAT1ciRWP9o7Mfu
         pP0VRBAe5BfEMVbxrTJ2gHUvAOmsTanp23w2v+65wPsn0CYXkI2VvOcWgM98y5fEsZl4
         bFy64xoYpZzd1GfhQzoDl3u0FiaOk1weoDRJEbJB560/kQ9px1XF/UUIu2DFABpzclhJ
         1RxJczWkUmxYqv/IJLilE1Z5vb1RZ8QoF/ndrMOr8hgPaKNz81H5aVuMKJ0zEq2iCIqk
         KWZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+cHd3hlDMk328Fbkhm+V+uGjcM1FaFH1lPxMqID03fs=;
        b=M4ntE00eae6EVqp2lscEh+ljeufMIghk5Rj8H66MZ1MmsHkNdtsK+LzPM4ERQoX8HY
         3VzseJN0IjGf152ll+McXmx36KhDOTjj9K70+5zxgMRfv0HjEzIuYLeEiymEDHaBXqQH
         G3wMfH3SiwMc1RsMMr65vcBReooVLs5lrqlUyLC8l+vaMJJJX8IIOxCX7/NCPRfRx2Fd
         lxazg6eFW205Hi3/GFRcP0F/YCVj7E/4S1bs/wXQPQhrCCW9u9wgXLX9+zERNnjnGviA
         7wBeDe8S/v+7X1iRkuB2/zrq+oVgJw8b3Djx04ZTdIncg3SLGWO2/X4dHMa+A3XEqgkX
         n8QQ==
X-Gm-Message-State: APjAAAXMCDt8qL2iGEfTzxsrUrliWzv1r3fxQeu7sG59+3LzGvJhjEuF
        sf9lGJBzKpPdc/pr/okLCCKNfvZ6
X-Google-Smtp-Source: APXvYqyljC1i2dh2zTla2pdE5ZLzAGPgmKOkCkfWA8hur7Sd8A/dWcHxd53JCm/b1+SN9KhBU8OlmQ==
X-Received: by 2002:a02:7b2d:: with SMTP id q45mr102250305jac.127.1561040243698;
        Thu, 20 Jun 2019 07:17:23 -0700 (PDT)
Received: from ?IPv6:2601:284:8200:5cfb:9c46:f142:c937:3c50? ([2601:284:8200:5cfb:9c46:f142:c937:3c50])
        by smtp.googlemail.com with ESMTPSA id f20sm21182162ioh.17.2019.06.20.07.17.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 20 Jun 2019 07:17:23 -0700 (PDT)
Subject: Re: [PATCH net-next v6 07/11] ipv6/route: Change return code of
 rt6_dump_route() for partial node dumps
To:     Stefano Brivio <sbrivio@redhat.com>,
        David Miller <davem@davemloft.net>
Cc:     Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
References: <cover.1560987611.git.sbrivio@redhat.com>
 <7a1a6fc83cfa3bf2af8fffa31b5e9b2b14078d9f.1560987611.git.sbrivio@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9505b31c-9ebe-d168-308d-6530b312e7b9@gmail.com>
Date:   Thu, 20 Jun 2019 08:17:21 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <7a1a6fc83cfa3bf2af8fffa31b5e9b2b14078d9f.1560987611.git.sbrivio@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/19/19 5:59 PM, Stefano Brivio wrote:
> In the next patch, we are going to add optional dump of exceptions to
> rt6_dump_route().
> 
> Change the return code of rt6_dump_route() to accomodate partial node
> dumps: we might dump multiple routes per node, and might be able to dump
> only a given number of them, so fib6_dump_node() will need to know how
> many routes have been dumped on partial dump, to restart the dump from the
> point where it was interrupted.
> 
> Note that fib6_dump_node() is the only caller and already handles all
> non-negative return codes as success: those become -1 to signal that we're
> done with the node. If we fail, return 0, as we were unable to dump the
> single route in the node, but we're not done with it.
> 
> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
> ---
> v6: New patch
> 
>  net/ipv6/ip6_fib.c |  2 +-
>  net/ipv6/route.c   | 16 ++++++++++------
>  2 files changed, 11 insertions(+), 7 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


