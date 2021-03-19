Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB5BB342932
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 00:56:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbhCSXz2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Mar 2021 19:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhCSXy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Mar 2021 19:54:57 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1225BC061760
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 16:54:57 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id a8so6565600oic.11
        for <netdev@vger.kernel.org>; Fri, 19 Mar 2021 16:54:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dhKcvtmAEQBj3/fyl15ziDmbp9VKvJoD+mckA0af13g=;
        b=aUG6xUG+zWcDsKso7lVR+DRE5FmENuKz9geftKkLYzZQZZ4nyELBMuMfsyfC4engKa
         Hf62f806uFKNyg8MwVmazX2ydjVe0oVZff8D799YW75ARbAxnx14VAUoevX9mGpDvvHO
         DPVa2TzEzNopqRkYMLCsrWiRs2Sd3UNh5b1bQLfnneGZUg0v7a60NgLD1etoKqTexrJY
         PMCVNu7DSzQ/TEI6IwgGEIclKfPmNFCxARXai6kHp9Rn8Q+dJeHU4yANupGKy+tR+iwO
         MtmBYOBsCU0hiN0IbCyar6w68CuHmP8J+TZgaE56aaU2HBTbnoSPB5MmxoUS5TTiX7z9
         JCPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dhKcvtmAEQBj3/fyl15ziDmbp9VKvJoD+mckA0af13g=;
        b=YMjWK3yVfqdWjEQZYsbEDEsyn2UcGHIFfXmb7u4mgOX7eBfVPKMlG7kBKkCsKC691a
         QfSPLG4yrExXvMeycVTvpL1lEndNeKvENquloGXPV9v7Mz47CXQX0QlUazIXH6XD4kwB
         pMM5hoGRI+ENnS4i22kEPJRZLH2snl8C/TC30vO+VwEsfLnJbmzEALbm/tvNSH71HVmD
         /jnSROXNt5Y+tfDnRIWjaO/Wx9CFut5C7akul9psS4/xTRi0ubQrKfvL2Ej3ntnDNh9V
         nd0pj1v6EPxZzEfzpWlpueQj3G2qP4n/BnOjO8mRz+Fls3bL6HnQP0dTMlArRcDW61+U
         HZ3w==
X-Gm-Message-State: AOAM533CwHGT01dbj/lXW+FdvJoyiQHb7PB3OXn9TzxiyDMgbTHtEvMS
        kvtGU2uoN8yfLXqwffpnZN8=
X-Google-Smtp-Source: ABdhPJxH2ZpDShaDGZ/0eZWwNPveccCyTHgNAoRewc8AEiBr2lVZxIirA2wul0axSX+0OTe6JfmIdg==
X-Received: by 2002:a05:6808:2d0:: with SMTP id a16mr2558247oid.83.1616198096527;
        Fri, 19 Mar 2021 16:54:56 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:e449:7854:b17:d432])
        by smtp.googlemail.com with ESMTPSA id b14sm1549594ooj.26.2021.03.19.16.54.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Mar 2021 16:54:55 -0700 (PDT)
Subject: Re: [PATCH v3] icmp: support rfc5837
To:     Ishaan Gandhi <ishaangandhi@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        willemb@google.com,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>
References: <20210317221959.4410-1-ishaangandhi@gmail.com>
 <f65cb281-c6d5-d1c9-a90d-3281cdb75620@gmail.com>
 <5E97397E-7028-46E8-BC0D-44A3E30C41A4@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <45eff141-30fb-e8af-5ca5-034a86398ac9@gmail.com>
Date:   Fri, 19 Mar 2021 17:54:54 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <5E97397E-7028-46E8-BC0D-44A3E30C41A4@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/19/21 10:11 AM, Ishaan Gandhi wrote:
> Thank you. Would it be better to do instead:
> 
> +	if_index = skb->skb_iif;
> 
> or
> 
> +	if_index = ip_version == 4 ? inet_iif(skb) : skb->skb_iif;
> 

If the packet comes in via an interface assigned to a VRF, skb_iif is
most likely the VRF index which is not what you want.

The general problem of relying on skb_iif was discussed on v1 and v2 of
your patch. Returning an iif that is a VRF, as an example, leaks
information about the networking configuration of the device which from
a quick reading of the RFC is not the intention.

Further, the Security Considerations section recommends controls on what
information can be returned where you have added a single sysctl that
determines if all information or none is returned. Further, it is not a
a per-device control but a global one that applies to all net devices -
though multiple entries per netdevice has a noticeable cost in memory at
scale.

In the end it seems to me the cost benefit is not there for a feature
like this.
