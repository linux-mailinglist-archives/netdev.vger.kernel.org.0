Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7C0D33791D
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 17:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234531AbhCKQUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 11:20:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234382AbhCKQUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 11:20:21 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66DF5C061574
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 08:20:21 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id y131so20820870oia.8
        for <netdev@vger.kernel.org>; Thu, 11 Mar 2021 08:20:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KwkO8UTFMReuLTFWVk1QALVF22pQ3r8TreLTJw2pg6s=;
        b=T1YOltM0lM575+IdCNV2BNffWGunAImh66I8rgGkOCg7PZsfxdHkcXCv/pWy81Q0Kk
         CWL15pi3ORXpZq36JrwrAt91kvz1t2olccau2KDex71BXcIvztAVxqUHrwEHXnn+MH8x
         zK5P47uBPPMYUtrsNH08VpoCpFvirggXHB51pxnfMZLmqCvP64eAIo7e9DgMEKNSVzOA
         feg4YIfULuEGW1VNo5Bpkd0f+P0WGQwiM1xf3b94k7LIRNcJcGkI06MOFDKpAQFMzgoe
         kVKGMx9C13rDpBxsAmJ5L+mvrpD2vVlkisKH3hZ9dKbA7QgNS90GRma2VLQXIufU71Nv
         VScA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KwkO8UTFMReuLTFWVk1QALVF22pQ3r8TreLTJw2pg6s=;
        b=PbXLj32JZMc6s4hum7a4OQKsSO44d02y/oLN6Pf6i6YrbGX8pHHmBkUI3CjsZ4yls3
         FryqyMlJ1YL55l4q1qMdbcSMGT2oOxIi2hBi83ZzZE5HTHTzypLqsj+kmA6NTn9cLQUD
         onaqi9PAR5epvft/sXMRYok5snLCjY+UPMqErjxn6GJmFvN3AdBosGD09QwpXfvDVL6e
         /x4NeDE0ZaaIubm9VvJ1pWFIcxnn9wIJnHeuVXuYWOVYWtOj8Ngkw4kPGKGvOS6l/dzw
         m+evq1SsxafwbErS2EKS7N1XPeY2H98xRIeEVVvKQWpQK+SjgVK9eOe1QWWvLlwl+zQJ
         Lp9w==
X-Gm-Message-State: AOAM5322h3gOLtw8346j5ohZG29BSS65f4oefNjGP+jwrBg9QnH1QrSo
        wtBhIBqU1wUWWc/M7rt8YBI=
X-Google-Smtp-Source: ABdhPJwpFRTBm52i/w4u0wStXdyy2e5HdN4Li27gZX63vhT6F4qY9hN//DE3AQ+ofgO9UP6zmyP8YA==
X-Received: by 2002:aca:314a:: with SMTP id x71mr7043398oix.55.1615479620864;
        Thu, 11 Mar 2021 08:20:20 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.56])
        by smtp.googlemail.com with ESMTPSA id n12sm718745otq.42.2021.03.11.08.20.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Mar 2021 08:20:20 -0800 (PST)
Subject: Re: [PATCH net-next 13/14] nexthop: Notify userspace about bucket
 migrations
To:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org
Cc:     Ido Schimmel <idosch@nvidia.com>, David Ahern <dsahern@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
References: <cover.1615387786.git.petrm@nvidia.com>
 <b321f8db4a9f1385940f884ecad2db9b40b0b3f7.1615387786.git.petrm@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <42f87f76-c679-c688-4195-77d03fcd1dca@gmail.com>
Date:   Thu, 11 Mar 2021 09:20:17 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <b321f8db4a9f1385940f884ecad2db9b40b0b3f7.1615387786.git.petrm@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/10/21 8:03 AM, Petr Machata wrote:
> Nexthop replacements et.al. are notified through netlink, but if a delayed
> work migrates buckets on the background, userspace will stay oblivious.
> Notify these as RTM_NEWNEXTHOPBUCKET events.
> 
> Signed-off-by: Petr Machata <petrm@nvidia.com>
> Reviewed-by: Ido Schimmel <idosch@nvidia.com>
> ---
> 
> Notes:
>     v1 (changes since RFC):
>     - u32 -> u16 for bucket counts / indices
> 
>  net/ipv4/nexthop.c | 45 +++++++++++++++++++++++++++++++++++++++------
>  1 file changed, 39 insertions(+), 6 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


