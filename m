Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22FA522BAFE
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 02:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728345AbgGXA3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 20:29:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728008AbgGXA3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 20:29:07 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC9E1C0619D3
        for <netdev@vger.kernel.org>; Thu, 23 Jul 2020 17:29:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=EtmODzorYi6Dzg6197AaUY/nMtOYtoPF8DkuHxOPkJk=; b=EbS0ux6mUeUsYM73WmNdcZgVi+
        B+OJAl1oyNlEWpeJvsAe6jVRhx+j0hWwZziingW9DymnDDiD4sjnLuxhrp4wneD7usSBo7HJNda6t
        FLXuaWmy+qoZtf3CxQHoa1VFDb7P7ffO1rYAPOnH4BjXhzKEsjEEnid19n01jUnppi9XMMU1P848W
        IoD7ZMALEI9k6oSgvHDcqSFRQsW41WXNhU78dCkNYmAZ95SqKPaT9pNptlkGPgFjgt4b/rqJYcVWi
        iD/RO6YWvf9aFih4WTC+Jqq2yAvjcW9mDIhs04W8s5+1sVVeU0aWm2n6/To7zlmwHXHhXB1KHOODE
        wZ2K07JA==;
Received: from [2601:1c0:6280:3f0::19c2]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jyla5-0007iO-TL; Fri, 24 Jul 2020 00:28:59 +0000
Subject: Re: [PATCH net] vrf: Handle CONFIG_SYSCTL not set
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        kuba@kernel.org, davem@davemloft.net
Cc:     Andrea Mayer <andrea.mayer@uniroma2.it>
References: <20200723232309.48952-1-dsahern@kernel.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <95a112c8-8724-61eb-596b-de94969598cc@infradead.org>
Date:   Thu, 23 Jul 2020 17:28:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200723232309.48952-1-dsahern@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/23/20 4:23 PM, David Ahern wrote:
> Randy reported compile failure when CONFIG_SYSCTL is not set/enabled:
> 
> ERROR: modpost: "sysctl_vals" [drivers/net/vrf.ko] undefined!
> 
> Fix by splitting out the sysctl init and cleanup into helpers that
> can be set to do nothing when CONFIG_SYSCTL is disabled. In addition,
> move vrf_strict_mode and vrf_strict_mode_change to above
> vrf_shared_table_handler (code move only) and wrap all of it
> in the ifdef CONFIG_SYSCTL.
> 
> Update the strict mode tests to check for the existence of the
> /proc/sys entry.
> 
> Fixes: 33306f1aaf82 ("vrf: add sysctl parameter for strict mode")
> Cc: Andrea Mayer <andrea.mayer@uniroma2.it>
> Reported-by: Randy Dunlap <rdunlap@infradead.org>
> Signed-off-by: David Ahern <dsahern@kernel.org>

Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested

Thanks.


> ---
>  drivers/net/vrf.c                             | 138 ++++++++++--------
>  .../selftests/net/vrf_strict_mode_test.sh     |   6 +
>  2 files changed, 83 insertions(+), 61 deletions(-)


-- 
~Randy
