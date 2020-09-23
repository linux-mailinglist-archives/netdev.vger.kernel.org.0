Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2FCC274EFA
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 04:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727195AbgIWCYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 22:24:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726893AbgIWCYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 22:24:18 -0400
Received: from mail-ot1-x342.google.com (mail-ot1-x342.google.com [IPv6:2607:f8b0:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58663C061755
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 19:24:18 -0700 (PDT)
Received: by mail-ot1-x342.google.com with SMTP id u25so17584263otq.6
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 19:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zEeW/h7pOyo5hn5MRCsofV8r0d0ASDNXot2m7VHsi+4=;
        b=TFcZWnfR3T+1M1rkcHBDRmCqcAlxRlIgB/0ELW8gJbA8BovfhEol4dVjYsBkQ8Hhad
         0N81koySxsGz4KqKusNAIa0y1H9ZFNrdjPOwBYXjyrRENVF+xRH1/vxNkNmLlqPufszR
         C8kkapmajrAHD2KjmvbvwE7jtySHnObqvhX1Y37h/e0M00fgrvLXmLyLk2jy7/EvojPO
         dKQAzXcoFbaf2Er/N6at6otrjxas6ARBp+aJ8aDPS7iP3Zlj0kl75zS0Md+6qwXVVONf
         5QHbMNiUboHiOGIkcfl63tSuPRef4swbA2O6vqQ/DRrn/0sqw2MhNJx1FtBKbTPkfXCE
         dHKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zEeW/h7pOyo5hn5MRCsofV8r0d0ASDNXot2m7VHsi+4=;
        b=HBQx9G48aznvXBum6R5xAEKFYSBUaA4W94zNPTTJnuXA7V+3NU6a1qonZsACu/fhiF
         knxx+uRRXVCuDI/Zs86YNpf1KKQJsgdqc0FQ0YlLgrRNu4eSRlKaKT6zghQ2UWAj0Ca3
         P1kTxchfSBjdRmEqJd1MPPc6ECQ24Hq7uIQsMqh28zFz1/3WDzL9s7we3vEhFtZo0JYc
         GwycLRZcjDhPOkBp+hcgPENNs46HI1msLPWdzeDUsMqYqOjMCPc6zvBDpcTsDyXHcIv+
         Zur4OJojLYtFXRy6ECxTUPtOezuMjdtA+o/zFJf7KdG1pfghshEF+fcEZeCQHg7F3Bbl
         zjCQ==
X-Gm-Message-State: AOAM533fUUbyHrA3h6AIwL9NBed+a5OElNeB3nRCe5dNzccW0IQt8VRi
        HNsEFZ3GuYeoBrsvODiRlTItMUIYj3nQeQ==
X-Google-Smtp-Source: ABdhPJwi6WNYpEvMs606fyWjgXREwu4RHRoJ6lXt09rf5Y+lfDG5ROl9CR1cZbIsAYR7sLZ+OQlX9Q==
X-Received: by 2002:a05:6830:1d9a:: with SMTP id y26mr3905888oti.168.1600827857674;
        Tue, 22 Sep 2020 19:24:17 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:9c91:44fa:d629:96cc])
        by smtp.googlemail.com with ESMTPSA id l4sm7850278oie.25.2020.09.22.19.24.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2020 19:24:16 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] ip: promote missed packets to the -s row
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     stephen@networkplumber.org, netdev@vger.kernel.org
References: <20200916194249.505389-1-kuba@kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <fcf01759-febb-9794-b323-e762eaef6896@gmail.com>
Date:   Tue, 22 Sep 2020 20:24:14 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200916194249.505389-1-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/16/20 1:42 PM, Jakub Kicinski wrote:
> missed_packet_errors are much more commonly reported:
> 
> linux$ git grep -c '[.>]rx_missed_errors ' -- drivers/ | wc -l
> 64
> linux$ git grep -c '[.>]rx_over_errors ' -- drivers/ | wc -l
> 37
> 
> Plus those drivers are generally more modern than those
> using rx_over_errors.
> 
> Since recently merged kernel documentation makes this
> preference official, let's make ip -s output more informative
> and let rx_missed_errors take the place of rx_over_errors.
> 
> Before:
> 
> 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
>     link/ether 00:0a:f7:c1:4d:38 brd ff:ff:ff:ff:ff:ff
>     RX: bytes  packets  errors  dropped overrun mcast
>     6.04T      4.67G    0       0       0       67.7M
>     RX errors: length   crc     frame   fifo    missed
>                0        0       0       0       7
>     TX: bytes  packets  errors  dropped carrier collsns
>     3.13T      2.76G    0       0       0       0
>     TX errors: aborted  fifo   window heartbeat transns
>                0        0       0       0       6
> 
> After:
> 
> 2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc mq state UP mode DEFAULT group default qlen 1000
>     link/ether 00:0a:f7:c1:4d:38 brd ff:ff:ff:ff:ff:ff
>     RX: bytes  packets  errors  dropped missed  mcast
>     6.04T      4.67G    0       0       7       67.7M
>     RX errors: length   crc     frame   fifo    overrun
>                0        0       0       0       0
>     TX: bytes  packets  errors  dropped carrier collsns
>     3.13T      2.76G    0       0       0       0
>     TX errors: aborted  fifo   window heartbeat transns
>                0        0       0       0       6
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  ip/ipaddress.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 

applied to iproute2-next

