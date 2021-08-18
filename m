Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9F83EF6FF
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 02:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235790AbhHRAro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 20:47:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232410AbhHRArn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 20:47:43 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87539C061764
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 17:47:09 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id n27so2098564oij.0
        for <netdev@vger.kernel.org>; Tue, 17 Aug 2021 17:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mZYqoXd6WjZy55l7j/hTgzOfK2Ah4GxkmNUJ7JxVRac=;
        b=l1fKn4ICWoUbEoxaXS+0zrVRXohXjkrBzi8xhx+hXHz0ZLjH0EwUHNKpWTCytNft/X
         1rEe1tyxsUzKdQkHVKZt1p1BHUGngfYnlJvHu41gyPK6g2sVpA6YC406N34pR1b377Bv
         i5SyOBSlznxH3cGaG9O72NlPVPPF50CmE8JilxNUlZ/kj8MNzTyfhxe4mNhLkUlk41hy
         A8zC47hWKDXCP322ZI41iGgVee4WkqZckU/ILu8xSKkB+rAdWJVOj0dwKcH66Yy/Nuxs
         WwG1V0nbp43Q39TE+paolFfhQ0oXhRfAsCYcMUhhQKk+9WMbVA79xYTWXuJJjrJ+Gqu4
         6C7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mZYqoXd6WjZy55l7j/hTgzOfK2Ah4GxkmNUJ7JxVRac=;
        b=tvlegBRzlnj2r5IcA576ZDvUBQ+lEuKSwfyDUC/CTn0hx40FgEQzX6fFkM6f/5GSwp
         05dVvL3AkVmE87AVsotF29kA9C2edmKMT3AUZIWyf5epiRaSQOMKAB8y7w9277QP5j24
         /fN3UifF0rpkdFU4YMDUePNCI4qeqpCUpWFZqMm9mu8vR+3jRC8p+tSd078UYrNNZnC7
         eRjZpMZMlb5i3Y3/D8K2ABqpFWKykPFN5Fn3oDsvuzwN1Q5yf4Mqbr2+yle7vdGH2uhC
         hMvf4tAVffQZsq3FrYhI+vn95HgtSUZNejEhB2RcpQebU3z8gjqQXiwuCY/EN3PnV6Dm
         sf1g==
X-Gm-Message-State: AOAM530p74PVKOIWUe2WBOyYTdB+Z3ardeTbvEY4TxY/5BJ8aQOguK0J
        ZE0gKhUdAjzfadhn8hykTS/LDdi9zm4=
X-Google-Smtp-Source: ABdhPJz5+gj57Y/hPcAiX6agri2yhsUNzvUYzjK09c0SIekSzHrh9b3SG66m3i7Z/5SIYVmhsFOdnQ==
X-Received: by 2002:aca:3c44:: with SMTP id j65mr4814416oia.35.1629247628798;
        Tue, 17 Aug 2021 17:47:08 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.45])
        by smtp.googlemail.com with ESMTPSA id q10sm745652otn.47.2021.08.17.17.47.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Aug 2021 17:47:07 -0700 (PDT)
Subject: Re: ss command not showing raw sockets? (regression)
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jonas Bechtel <post@jbechtel.de>, netdev@vger.kernel.org
References: <20210815231738.7b42bad4@mmluhan>
 <20210816150800.28ef2e7c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210817080451.34286807@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210817202135.6b42031f@mmluhan>
 <20210817114402.78463d9d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <af485441-123b-4f50-f01b-cee2612b9218@gmail.com>
 <20210817143753.30f21bb0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <74deda94-f14e-be9e-6925-527c7b70a563@gmail.com>
Date:   Tue, 17 Aug 2021 18:47:06 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210817143753.30f21bb0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/17/21 3:37 PM, Jakub Kicinski wrote:
> On Tue, 17 Aug 2021 13:54:53 -0600 David Ahern wrote:
>> On 8/17/21 12:44 PM, Jakub Kicinski wrote:
>>>> @kuba With PROC_NET_RAW I consider the problem is found, isn't it? So
>>>> I will not download/bisect<->build or otherwise investigate the
>>>> problem until one of you explicitely asks me to do so.
>>>>
>>>> I have now redirected invocation of command with set PROC_NET_RAW on
>>>> my system, and may (try to) update to Linux 4.19.  
>>>
>>> I suspect the bisection would end up at the commit which added 
>>> the netlink dump support, so you can hold off for now, yes.  
>>
>> agreed.
>>>
>>> My best guess right now is that Knoppix has a cut-down kernel 
>>> config and we don't handle that case correctly.
>>>   
>>
>> CONFIG_INET_RAW_DIAG (or INET_DIAG) is probably disabled. surprised the
>> netlink dump does not return an error and it falls back to the proc file:
>>
>>         if (!getenv("PROC_NET_RAW") && !getenv("PROC_ROOT") &&
>>             inet_show_netlink(f, NULL, IPPROTO_RAW) == 0)
>>                 return 0;
>>
>> can you strace it?
> 
> Ah, good point, strace will show it. 
> 
> /me goes off to look at the strace Jonas sent off list.
> 
> Well this is unexpected:
> 
> sendmsg(3, {msg_name={sa_family=AF_NETLINK, nl_pid=0, nl_groups=00000000}, msg_namelen=12, msg_iov=[{iov_base={{len=76, type=DCCPDIAG_GETSOCK, ...
> 
> --->8----------------
> 
> From: Jakub Kicinski <kuba@kernel.org>
> Subject: ss: fix fallback to procfs for raw and sctp sockets
> 
> sockdiag_send() diverts to tcpdiag_send() to try the older
> netlink interface. tcpdiag_send() works for TCP and DCCP
> but not other protocols. Instead of rejecting unsupported
> protocols (and missing RAW and SCTP) match on supported ones.
> 
> Fixes: 41fe6c34de50 ("ss: Add inet raw sockets information gathering via netlink diag interface")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  misc/ss.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/misc/ss.c b/misc/ss.c
> index 894ad40574f1..b39f63fe3b17 100644
> --- a/misc/ss.c
> +++ b/misc/ss.c
> @@ -3404,13 +3404,13 @@ static int tcpdiag_send(int fd, int protocol, struct filter *f)
>  	struct iovec iov[3];
>  	int iovlen = 1;
>  
> -	if (protocol == IPPROTO_UDP || protocol == IPPROTO_MPTCP)
> -		return -1;
> -
>  	if (protocol == IPPROTO_TCP)
>  		req.nlh.nlmsg_type = TCPDIAG_GETSOCK;
> -	else
> +	else if (protocol == IPPROTO_DCCP)
>  		req.nlh.nlmsg_type = DCCPDIAG_GETSOCK;
> +	else
> +		return -1;
> +
>  	if (show_mem) {
>  		req.r.idiag_ext |= (1<<(INET_DIAG_MEMINFO-1));
>  		req.r.idiag_ext |= (1<<(INET_DIAG_SKMEMINFO-1));
> 

That looks correct to me.

Jonas: can you build iproute2 and test?
