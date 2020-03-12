Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C99D18390A
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 19:53:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbgCLSxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 14:53:00 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:37738 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbgCLSxA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 14:53:00 -0400
Received: by mail-pf1-f196.google.com with SMTP id p14so3708762pfn.4
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 11:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=f4uAfd3YCJJUkGxUkhDaQo7XlDAotB8g1oi8PYRVai8=;
        b=eq+Ln+cHnXFKNDe89DbT9wLugLXSqR8+/8teBIR4jxM0fj95+Dtf4IGwvIPjkaKjCj
         KCcr6bw89FXLR6QpEmm27FsnHqOKL9NNsBdG6P9UpO5tAn2r4EAfvXlB0WSqw7vWaeEU
         W71lmvhWp7U5J09SHCZvzTvPfpfULScWRWdsyL/zRjrr+PrkVQicPcLAE/M/M9fukJnL
         fsNHDS6TlBu0FqeR8fhVjKpQ1K5mHc9YgH+jaloSefh5a8yBQNkPffjuJzF+fhqWSKzn
         9BpPZqpge/ggpYfiRxDMUlZSalvqZ0v4J2VFwwILG1R6etTz1uInPss0hC0Lzepigcyg
         /DQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f4uAfd3YCJJUkGxUkhDaQo7XlDAotB8g1oi8PYRVai8=;
        b=pcXsO5+VxNN1pfywBDqIKWFG9oJSPwE5lvUMorbXYo+qPJMMN07VyidU76qzci1+Jp
         FdvF9Lg8C4sA3PFj25U3vXoaYm3hh7vxB+PVG8LXS67rQ697mq+b5sipDFGcuGEUfxka
         jktSjIZdIMQliVPdOWidiNBehwqZAjyjqEIO7zcUSK0+2uzBD+RJdBh5uxvBYPZlHo0a
         N4pGjYibcIsN3AADKdwizzv8yEGTZt/BLg1HUKCNQxZM9vklPdHVHJaagWSmJy2zzA7k
         NurZl1n6RK5Iz+TH6XAv27/M12ia6iUsmfiDzBTFXvBZ1oVU37Q8LIkQb9eJeciGPwF8
         wAHQ==
X-Gm-Message-State: ANhLgQ1WjiXeiAYEmg+nLcOmWgfUIJcDsytR2iqJtRB2HQblpuoXlvbM
        CUsWzc901grRcioyKUKJDwM=
X-Google-Smtp-Source: ADFU+vtihjC/T+a+sEahJsAuhQ7xnf93KWBWF6HeXll1w5JhfdlmsompMolQpYZmz47se1qNnxaBrw==
X-Received: by 2002:aa7:96a6:: with SMTP id g6mr9174623pfk.88.1584039179552;
        Thu, 12 Mar 2020 11:52:59 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id f1sm9281000pjq.31.2020.03.12.11.52.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2020 11:52:58 -0700 (PDT)
Subject: Re: [PATCH v5 net-next 0/4] Improve bind(addr, 0) behaviour.
To:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, edumazet@google.com
Cc:     kuni1840@gmail.com, netdev@vger.kernel.org,
        osa-contribution-log@amazon.com
References: <20200310080527.70180-1-kuniyu@amazon.co.jp>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <566b454d-f338-895e-03bf-346740f3ce48@gmail.com>
Date:   Thu, 12 Mar 2020 11:52:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200310080527.70180-1-kuniyu@amazon.co.jp>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/10/20 1:05 AM, Kuniyuki Iwashima wrote:
> Currently we fail to bind sockets to ephemeral ports when all of the ports
> are exhausted even if all sockets have SO_REUSEADDR enabled. In this case,
> we still have a chance to connect to the different remote hosts.
> 
> These patches add net.ipv4.ip_autobind_reuse option and fix the behaviour
> to fully utilize all space of the local (addr, port) tuples.
> 


Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks.

