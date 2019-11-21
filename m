Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC4D105AD5
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 21:07:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbfKUUHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 15:07:12 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:45117 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726379AbfKUUHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 15:07:11 -0500
Received: by mail-qv1-f66.google.com with SMTP id g12so1935488qvy.12
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 12:07:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7eTnCyq0/+TpGwWUeNvseAEWgoSg/S+B4FZmLPIAU6M=;
        b=VSHRmJKbDeIFihYkDJhUhg03sCoi4Yf35AdI3EszHB3dRLcoVU+ROAAvZnCs9UkTqF
         PMxszEFvh7AT2XiOrkmXdKcrN1bYh1Hhmqe7rMDn9FulLsqpOwQGWF6aCS12nRtCs+7s
         a9zO5czGKX5au+D8XiJGjLzkE6Zc471Ny98ut0jK8OGmXI7L37kvAyRCLjc2Yn/sPxPK
         AYv5j9dGlFikTLkwtXBPSWtOEC6+q3ItgGyIYqbI1ohDWEW/aDzkgi4OkF0AtbQRVymf
         uibXZGp6kL8sFcpEQj+KPGu2jDpyEVYw5WoOoMjs5theRA23kbeFtW3N2kKIHHLf63EW
         BbWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7eTnCyq0/+TpGwWUeNvseAEWgoSg/S+B4FZmLPIAU6M=;
        b=gFGxVRHB75YgFbbx6LnFexQI6wsFQuCNq/mzs9kkJPoAQxpuNdxlYcMD3FXvPmMpGX
         +cSSCpNa1ge7zHdd7qAPyvu7hj4jQuuyoEGyWr7ui3CKCF6mE2jUtY99n4/5w9G2w8Mr
         vA4gS81g11VgEwZL9MyX4sLA9/3s/9w1mhdyAMnZVwya8L88fHsze81sekCkw54ILIST
         KdpWy0d+9f+qr3fTOsMM26pNvVdJCSDUpU9/EtvP17cqVOWK2LZbz42zg/IVYCa0JydB
         FcUXcwEsb2/7Yb2NAS9uTKPzhS0bNn+JOOWQziwx0X/dLlQ1y11pl7I/SHcHDnMEo0cA
         bXbQ==
X-Gm-Message-State: APjAAAWdLHQJv4cpdQlTCzHu2muZBOUQXwCxR3VwgRYg2nRUPHpn2bR0
        GabPqG6z/P4TCxJ5yPEUFuM=
X-Google-Smtp-Source: APXvYqyxmJo3RT2dDzKknLEUhX9wrD+bEZdz0AA5RXRptAWFlN8X/20UTqT2HVlrFpMgjiV3vtdomA==
X-Received: by 2002:a0c:c211:: with SMTP id l17mr10016882qvh.55.1574366830825;
        Thu, 21 Nov 2019 12:07:10 -0800 (PST)
Received: from dahern-DO-MB.local ([2601:282:800:fd80:b9b1:601f:b338:feda])
        by smtp.googlemail.com with ESMTPSA id l132sm1897838qke.38.2019.11.21.12.07.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2019 12:07:09 -0800 (PST)
Subject: Re: [PATCH net-next v4 1/5] ipv6: add fib6_has_custom_rules() helper
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Edward Cree <ecree@solarflare.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
References: <cover.1574252982.git.pabeni@redhat.com>
 <a74feb96efb0d6bec9f1f2598f5773991aa39e26.1574252982.git.pabeni@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ebf9a1bc-a8f6-a942-a1e9-d247d5b312dd@gmail.com>
Date:   Thu, 21 Nov 2019 13:07:08 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <a74feb96efb0d6bec9f1f2598f5773991aa39e26.1574252982.git.pabeni@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/20/19 5:47 AM, Paolo Abeni wrote:
> It wraps the namespace field with the same name, to easily
> access it regardless of build options.
> 
> Suggested-by: David Ahern <dsahern@gmail.com>
> Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> ---
>  include/net/ip6_fib.h | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>


