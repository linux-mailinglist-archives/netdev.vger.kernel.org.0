Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 036FA37AA4F
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 17:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231769AbhEKPL4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 11:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231609AbhEKPLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 11:11:55 -0400
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B556C061574
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 08:10:48 -0700 (PDT)
Received: by mail-ot1-x334.google.com with SMTP id d3-20020a9d29030000b029027e8019067fso17734801otb.13
        for <netdev@vger.kernel.org>; Tue, 11 May 2021 08:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=f+ufkZbR3J0eY/KLvoa2c0n4id5CGNREce71ZfHycwo=;
        b=PXJBFxq+VKVd8Jo/G5DIKMXXdZ9D5bR5iM+0xHkKxWJO5YjLby4/UIh3mI97M8LcJk
         wxIsTqyDmdojfduiXpL1rHXLFIZ9+G6JblBh9VwbvAyDlqOd84f8kXxnlDeIbea7dhzT
         BBvbnPBfuv7x+bbtjvRN3tF9EMLc9BTxX+DANznQ42Nw151I9Wpl8efm2xM5yFZy/76A
         n6Zkm4nqQZqUnILzgkFxOBIjHqxt2iF5McODl5OSvVtkyDNMvKRPx6eFQhhlvku8QPjY
         IpB9JCfMpy/UrpnvwizIgd1QdpKNGJgk0loZuEl0bPW47dqXHK8GJEKMi+3laNSSV05t
         ORkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=f+ufkZbR3J0eY/KLvoa2c0n4id5CGNREce71ZfHycwo=;
        b=P/7R8RsGQ4lDO7Ljg58x/+xMIpAeMtPEanuAHVWwKg8Dcateod6BqnR0jZWWS8DklW
         6sF48mh2MHAvV+OcVorPybLc64m5V+NyGH2g6ry1YXHnN5rqlJkzTMsuHLx78RPehN+A
         xV59udRARvWgAaXLMr3gOrS4sHvdj+02m0RLGXjNLro7QFmQY7Wo6i+saqFNIBhKcnYT
         zgNruxX0D2spT1oZUml2ufGi3YIsUdRoWWV9cyd/yG0f0boAS7ZYx9iGa/xo2TaZ9jGh
         UUQJC/5rIhFel4aDYBc3TRPkFp7iTcKslEUgoR6OtlC6EZhQFvC9GCIjvs8K9Uo7PaNM
         XJlA==
X-Gm-Message-State: AOAM532LaR+m0jN38YNdMa5i0Mu4GoKeLhKvpp+ru+gKI5mtZgKtsDWg
        SPTGyop1nQqXQSxtBbRtPiVAx5SlwhQ=
X-Google-Smtp-Source: ABdhPJxNVvlaBNHAC1MaIlSpm/8aglzY/d+h5V8FrtPQyjGbMg+KePPPNb0qgFum319xL6JaDkK9cw==
X-Received: by 2002:a9d:5a5:: with SMTP id 34mr27057437otd.353.1620745847908;
        Tue, 11 May 2021 08:10:47 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:8052:e21b:4a8:8b78])
        by smtp.googlemail.com with ESMTPSA id 64sm3309734oob.12.2021.05.11.08.10.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 May 2021 08:10:47 -0700 (PDT)
Subject: Re: [RFC PATCH net-next v2 02/10] ipv4: Add a sysctl to control
 multipath hash fields
To:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        roopa@nvidia.com, nikolay@nvidia.com, ssuryaextr@gmail.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
References: <20210509151615.200608-1-idosch@idosch.org>
 <20210509151615.200608-3-idosch@idosch.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <59331028-c1a5-2a7a-1e27-57e62f95030f@gmail.com>
Date:   Tue, 11 May 2021 09:10:46 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210509151615.200608-3-idosch@idosch.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/9/21 9:16 AM, Ido Schimmel wrote:
> diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
> index c2ecc9894fd0..15982f830abc 100644
> --- a/Documentation/networking/ip-sysctl.rst
> +++ b/Documentation/networking/ip-sysctl.rst
> @@ -100,6 +100,33 @@ fib_multipath_hash_policy - INTEGER
>  	- 1 - Layer 4
>  	- 2 - Layer 3 or inner Layer 3 if present
>  
> +fib_multipath_hash_fields - UNSIGNED INTEGER
> +	When fib_multipath_hash_policy is set to 3 (custom multipath hash), the
> +	fields used for multipath hash calculation are determined by this
> +	sysctl.
> +
> +	This value is a bitmask which enables various fields for multipath hash
> +	calculation.
> +
> +	Possible fields are:
> +
> +	====== ============================
> +	0x0001 Source IP address
> +	0x0002 Destination IP address
> +	0x0004 IP protocol
> +	0x0008 Unused

Document that this bit is flowlabel for IPv6 and ignored for ipv4.
