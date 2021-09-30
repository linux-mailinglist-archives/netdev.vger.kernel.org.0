Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E81C041D1ED
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 05:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347964AbhI3Djo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 23:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347960AbhI3Djn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 23:39:43 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E659EC06161C
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 20:38:01 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id 77-20020a9d0ed3000000b00546e10e6699so5606729otj.2
        for <netdev@vger.kernel.org>; Wed, 29 Sep 2021 20:38:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=V1Kd2mY3cnqNwk/wAaDSOvpuKU6+XrLBIbG3WcVtYdo=;
        b=fuNHjyH8ev7AVL4Q0ZimhaJEKuqKkbLyExL5bglimOmqCdrPNtocKLZi6Rb+ku+6C/
         //LxwIpPxsLT8hXZzmbqHU71ZSgAYBFSIIU4JkxW53rnaQda4PU64Se+4WJUrg/MAv2G
         rP8Vh1uVniSzvatGVP020RM4BekP5ZatqBsmQLW/Lo+XwS/AnlQ0hZq9zFSrh56fbZui
         Mbi0vk3/Hjvh1l4aFxfIKDfWcWPkzaDaPlrXBmx//b/g3LFFGcf/uKf7rWntj1T3vCmb
         lVOgdbQO5JcaZcLLzCCmhmhpiio+dix6P6R+JNi3w+s8/Xe52gFwW49STpMauDRybhoi
         EHPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=V1Kd2mY3cnqNwk/wAaDSOvpuKU6+XrLBIbG3WcVtYdo=;
        b=v8qB4G7tr3bpo4xV+/2TvuMvybdAV7JeNjK4ONLkOfeThwHF6L2v2doNhC8MEU+QQR
         py8+XXuYxix1tpyK1bCAt8jslRoKUOZdjEcpXv9jWm4NfGKn6DJuUfW7OJ7dHkAg+Qts
         /RJqbulsq7GaN2UKhl3vXv+Cc2i7vuk6T20somYPrWudtch8y8khIvsdScANBMKU6N77
         Q1IX/M7Q85ZGim6at9B+2SGEZr0CQxGL/p9qNJc063u+pGeKh02e5hmd+o4BLuhsNV4g
         LkqIqqgt9H/QbDsOUHJg4vDmPTLZXlCwKzD+dc63Yj6RNa3e+/l4BureRDOTHJ6p7n3S
         mdwQ==
X-Gm-Message-State: AOAM53050DsgFl8yYgjvTrECiM7pEr9aGsXKMfJe2+/RIChR1g9/Kk9l
        bUFlDxOJhDBJRyDXXpcgr2E=
X-Google-Smtp-Source: ABdhPJztT/E42CBAeVJ08gbOylK2Wy3FF1e0BzRmsbjsOdE/zvbip9KpBlna+nE2QjSHePl/iXE01g==
X-Received: by 2002:a9d:20aa:: with SMTP id x39mr3062403ota.292.1632973081376;
        Wed, 29 Sep 2021 20:38:01 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id t4sm376792otj.18.2021.09.29.20.38.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Sep 2021 20:38:00 -0700 (PDT)
Subject: Re: [RFC iproute2-next 05/11] ip: nexthop: always parse attributes
 for printing
To:     Nikolay Aleksandrov <razor@blackwall.org>, netdev@vger.kernel.org
Cc:     roopa@nvidia.com, donaldsharp72@gmail.com, idosch@idosch.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
References: <20210929152848.1710552-1-razor@blackwall.org>
 <20210929152848.1710552-6-razor@blackwall.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5bdcb047-4b25-1390-e04a-ada3e7bf1785@gmail.com>
Date:   Wed, 29 Sep 2021 21:37:57 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210929152848.1710552-6-razor@blackwall.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/29/21 9:28 AM, Nikolay Aleksandrov wrote:
> @@ -481,56 +457,61 @@ int print_nexthop(struct nlmsghdr *n, void *arg)
>  	if (filter.proto && filter.proto != nhm->nh_protocol)
>  		return 0;
>  
> -	parse_rtattr_flags(tb, NHA_MAX, RTM_NHA(nhm), len, NLA_F_NESTED);
> -
> +	err = parse_nexthop_rta(fp, nhm, len, &nhe);
> +	if (err) {
> +		close_json_object();
> +		fprintf(stderr, "Error parsing nexthop: %s\n", strerror(err));
> +		return -1;
> +	}

so you are doing that but in reverse order. Re-order the patches such
that existing code is refactored with the parse functions first.

