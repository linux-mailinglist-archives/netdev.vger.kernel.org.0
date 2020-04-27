Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B12981BA452
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 15:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbgD0NMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 09:12:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726721AbgD0NMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 09:12:15 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D1CC0610D5
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 06:12:14 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id k6so18745291iob.3
        for <netdev@vger.kernel.org>; Mon, 27 Apr 2020 06:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Pddeb4k608Asn5F4BukHK05Ne5Pjrmwk4f1nbHHYwc8=;
        b=tles57fv8gmlyvTWOWI1GjJCuu25I3IV30mx88sinuRfiLUlPXC8scYyLelWcgCCWF
         b0DV/aguDsDB/dykJYjvTPK7P9DuNNPBdVjR5Whn6rcyxFMumiLaou6GWbkeEGdB5zTy
         Tx1h6VerBT8XGgic/GJwVp+fzzNs9DCsJm0pNm4b7F/XYSlL6MG7hPsFO0su2BY5pOfN
         0xsm7tNt2YnNghoeS55fnI3iT4ug2+Bf3jjtrQuvEiPBsbYQ02X2OXTmWp/9Odwdakr3
         lPcbZRTKOQzQ44Jz9bkroTXYGTQD5H3jVEGnwm6Saz46gNTHfVrgsXEATkamoCJbX2Ht
         GK3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Pddeb4k608Asn5F4BukHK05Ne5Pjrmwk4f1nbHHYwc8=;
        b=FoIf5272TpCXyYVMggl2zCnkVOZ6Cpzyk3EZ88jnqNeeHOvuwhfaE1uAcXYWtqjC+H
         jCZR9nzQDOF1q4cDFyIrn0/3W/YtwnFKzB7Ibpt9/35AUpcgZ2wV3bQeURm2eppON1gV
         4rtVGFeHXHtxNx5r6N/0uwqpheDVJdvkrt+Xku8R2D1MO3mvXDJikP2h8dcH9mjM228W
         UQcOjbCy2id+7vHRUnzZMAEL4qmhhdP4qHz4IpXHE1R6DA+AgPYTwwcqFW9mSqO5Fvxf
         4Ttpt5QPXtw2C4AbjW8zOCA2QnW/0HanP1XQJysmtHf24IaHezs7vVKx3CGF5n8lmH3f
         3VJA==
X-Gm-Message-State: AGi0PuZm6Iom3M3eyNkj4nIqYxuZXiF9eKsN/Zimz44YWWLLkG2UNOh/
        t//8KccVqJkXiWymTjEwFnw=
X-Google-Smtp-Source: APiQypLWLANSMGm/Rbccf+eQAtkNH6ignZOA9bXRsuK74TIBCfBqslLFw+XSGmE3+CSO8/v14rXgIQ==
X-Received: by 2002:a02:3351:: with SMTP id k17mr20252847jak.31.1587993133827;
        Mon, 27 Apr 2020 06:12:13 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:a88f:52f9:794e:3c1? ([2601:282:803:7700:a88f:52f9:794e:3c1])
        by smtp.googlemail.com with ESMTPSA id y1sm5006330iob.30.2020.04.27.06.12.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Apr 2020 06:12:13 -0700 (PDT)
Subject: Re: [PATCH net-next v3 2/3] net: ipv4: add sysctl for nexthop api
 compatibility mode
To:     Roopa Prabhu <roopa@cumulusnetworks.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, rdunlap@infradead.org,
        nikolay@cumulusnetworks.com, bpoirier@cumulusnetworks.com
References: <1587958885-29540-1-git-send-email-roopa@cumulusnetworks.com>
 <1587958885-29540-3-git-send-email-roopa@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9d9bc36b-f4bb-0144-5144-52064b350dc4@gmail.com>
Date:   Mon, 27 Apr 2020 07:12:12 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1587958885-29540-3-git-send-email-roopa@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/26/20 9:41 PM, Roopa Prabhu wrote:
> diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
> index 6fcfd31..02029b5 100644
> --- a/Documentation/networking/ip-sysctl.txt
> +++ b/Documentation/networking/ip-sysctl.txt
> @@ -1553,6 +1553,20 @@ skip_notify_on_dev_down - BOOLEAN
>  	on userspace caches to track link events and evict routes.
>  	Default: false (generate message)
>  
> +nexthop_compat_mode - BOOLEAN
> +	Controls whether new route nexthop API is backward compatible
> +	with old route API. By default Route nexthop API maintains
> +	user space compatibility with old route API: Which means
> +	Route dumps and netlink notifications include both new and
> +	old route attributes. In systems which have moved to the new API,
> +	this compatibility mode provides a way to turn off the old
> +	notifications and route attributes in dumps. This sysctl is on
> +	by default but provides the ability to turn off compatibility
> +	mode allowing systems to run entirely with the new routing
> +	nexthop API. Old route API behaviour and support is not modified
> +	by this sysctl
> +	Default: true (backward compat mode)
> +

That description is a bit confusing, to me at least. It would be better
to state what changes happen when the sysctl is disabled. Something like:

New nexthop API provides a means for managing nexthops independent of
prefixes. Backwards compatibilty with old route format is enabled by
default which means route dumps and notifications contain the new
nexthop attribute but also the full, expanded nexthop definition.
Further, updates or deletes of a nexthop configuration generate route
notifications for each fib entry using the nexthop. Once a system
understands the new API, this sysctl can be disabled to achieve full
performance benefits of the new API by disabling the nexthop expansion
and extraneous notifications.
