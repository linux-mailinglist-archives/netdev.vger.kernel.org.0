Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6EE8372477
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 04:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbhEDCei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 May 2021 22:34:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbhEDCeh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 May 2021 22:34:37 -0400
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2010C061574
        for <netdev@vger.kernel.org>; Mon,  3 May 2021 19:33:43 -0700 (PDT)
Received: by mail-ot1-x330.google.com with SMTP id r26-20020a056830121ab02902a5ff1c9b81so2985522otp.11
        for <netdev@vger.kernel.org>; Mon, 03 May 2021 19:33:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZDh3z1kiLOgLMTzZobiCDdAoRVpjhwdlPRYF1719rQg=;
        b=SjMQ5r8rzzKhmFOzdpjddQWRUfOZHX06YGD/lZ81Vfi+kT6QbfxnZys+/pqhsvZk5i
         f/FPpA8M+AHtsh/2ZOaGK6jnydmOBaJ++fnKWTaQshda0+Al3FiPumws+KWCU8atS68u
         pB8TW+PZW3pR8//Z9pkr4IeNT2nqLbQUfb1V5QaqqsJrWoAblmAseFs1U60SXtJWY1uH
         XXXyJIpaF4hidPtiHtQ8WE623RYqRNor1XGrRiYbON80IRtHre63rNzUJ4Qa5SM0iS9+
         i43g7IXtP79QpETY8qpaYTo4sbmU0M5/JwDo6+tCqseK95PmH8xjH+hvWKzdl6PemQS5
         +cOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZDh3z1kiLOgLMTzZobiCDdAoRVpjhwdlPRYF1719rQg=;
        b=KpYlnqd3Zilym2D22YO2y/Z/SvcnVqcGwzhyP0gvraVL8pf0cydCGl7q/GN7IqghXq
         HuarKd3FlgEBevrfVCb4g6dhXYpzD1PuZZZducz8GS0sbcQGJ+RKbEaL2zYg2X5qIdH/
         WGHRoB8oY7ePLX54XjAeBixluv2Kl83fI+bgUny6yk4hDHiD7I+Kb3kiMAfOIZkN+nyZ
         WWT4hJk9q8A4WNXGkpeX0H6+8jMpBXCQwivLsK6RkUXqGa6gviepS+ZvSgum0d1Bgx//
         xQAKkfRdtSN8FEdxi/PWTA/hGXi42Debqx4g7Q1cJ2I6SEbbASRXNFbRaEyryLUc/FuQ
         C5cQ==
X-Gm-Message-State: AOAM532SCY5AeSe4WefgsJ4l9iFSCF2EfAwQaB9XqxOSrnAvYNPpeId8
        WTtPUkzbybweCUuGrFejVIejg4jk+znleA==
X-Google-Smtp-Source: ABdhPJy8+beqNsFt1elWxbqMGJLkVPndA0HgCnCICd7Bz4P5BYA2KYRfeRGyKWZ7Cji5se4+LiQDvA==
X-Received: by 2002:a05:6830:1317:: with SMTP id p23mr17392848otq.185.1620095623335;
        Mon, 03 May 2021 19:33:43 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id w23sm466224otl.60.2021.05.03.19.33.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 May 2021 19:33:42 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 02/10] ipv4: Add a sysctl to control
 multipath hash fields
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        roopa@nvidia.com, nikolay@nvidia.com, ssuryaextr@gmail.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
References: <20210502162257.3472453-1-idosch@idosch.org>
 <20210502162257.3472453-3-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3664a338-40ad-9379-0a4c-ec2bd99681dd@gmail.com>
Date:   Mon, 3 May 2021 20:33:40 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210502162257.3472453-3-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/2/21 10:22 AM, Ido Schimmel wrote:
> From: Ido Schimmel <idosch@nvidia.com>
> 
> A subsequent patch will add a new multipath hash policy where the packet
> fields used for multipath hash calculation are determined by user space.
> This patch adds a sysctl that allows user space to set these fields.
> 
> The packet fields are represented using a bitmap and are common between
> IPv4 and IPv6 to allow user space to use the same numbering across both
> protocols. For example, to hash based on standard 5-tuple:
> 
>  # sysctl -w net.ipv4.fib_multipath_hash_fields=0-2,4-5
>  net.ipv4.fib_multipath_hash_fields = 0-2,4-5
> 
> More fields can be added in the future, if needed.
> 
> The 'need_outer' and 'need_inner' variables are set in the control path
> to indicate whether dissection of the outer or inner flow is needed.
> They will be used by a subsequent patch to allow the data path to avoid
> dissection of the outer or inner flow when not needed.
> 
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  Documentation/networking/ip-sysctl.rst | 29 ++++++++++++++++
>  include/net/ip_fib.h                   | 46 ++++++++++++++++++++++++++
>  include/net/netns/ipv4.h               |  4 +++
>  net/ipv4/fib_frontend.c                | 24 ++++++++++++++
>  net/ipv4/sysctl_net_ipv4.c             | 32 ++++++++++++++++++
>  5 files changed, 135 insertions(+)
> 
> diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
> index c2ecc9894fd0..8ab61f4edf02 100644
> --- a/Documentation/networking/ip-sysctl.rst
> +++ b/Documentation/networking/ip-sysctl.rst
> @@ -100,6 +100,35 @@ fib_multipath_hash_policy - INTEGER
>  	- 1 - Layer 4
>  	- 2 - Layer 3 or inner Layer 3 if present
>  
> +fib_multipath_hash_fields - list of comma separated ranges
> +	When fib_multipath_hash_policy is set to 3 (custom multipath hash), the
> +	fields used for multipath hash calculation are determined by this
> +	sysctl.
> +
> +	The format used for both input and output is a comma separated list of
> +	ranges (e.g., "0-2" for source IP, destination IP and IP protocol).
> +	Writing to the file will clear all previous ranges and update the
> +	current list with the input.
> +
> +	Possible fields are:
> +
> +	== ============================
> +	 0 Source IP address
> +	 1 Destination IP address
> +	 2 IP protocol
> +	 3 Unused
> +	 4 Source port
> +	 5 Destination port
> +	 6 Inner source IP address
> +	 7 Inner destination IP address
> +	 8 Inner IP protocol
> +	 9 Inner Flow Label
> +	10 Inner source port
> +	11 Inner destination port
> +	== ============================
> +
> +	Default: 0-2 (source IP, destination IP and IP protocol)

since you are already requiring a name to id conversion, why not just
use a bitmask here as the input? if the value is a 32-bit bitmask do you
need bitmap_zalloc and its overhead?

Also, you could implement the current default using this scheme since
you have the default fields as the current L3 policy.
