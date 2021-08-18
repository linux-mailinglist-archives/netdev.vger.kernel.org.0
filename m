Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 400043F0CE6
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 22:44:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233770AbhHRUoj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 16:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233775AbhHRUog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 16:44:36 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 424C4C061764
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 13:44:01 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id x10-20020a056830408a00b004f26cead745so5703192ott.10
        for <netdev@vger.kernel.org>; Wed, 18 Aug 2021 13:44:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=R1kdr3yVQ3oL4ieUyASNKHJeUhPfiya7e+NKpbfOK6E=;
        b=bKH8bq1+iBUKE3sgdAYttOwN3XKNA0IM0pMc/7PshDgh2xLX51rDUmmIYoBNAJ25sM
         ZCvJhemDxJOpT1bYA9OwO4wLbO25dd5Mkwxskn3IlVIdMJ3oSED+J780GTvjJW/JDppd
         5eQSayMtDeURx2VTWApoOiStIw7jyJncIMVRxH+ZK2//DOWcYYZiIe7WEUGJvwSHu6qO
         vk8dutCef9XTxLuHwJ+gUYS493AZk7djzLGEEqBYSF1QTa/0WCh/o3LNuyp4LNxyPWeJ
         Jnil9w55OAKj/zOYXmCusnVWzFukq9nHurDzu8MuJXT4X6dboqGdYX8Slx8Gnh1Edjzm
         db2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=R1kdr3yVQ3oL4ieUyASNKHJeUhPfiya7e+NKpbfOK6E=;
        b=UdAoV3DvOJwGB65FAKR4I3SBCmugMx2VcnF1nVPskTNg1i12o5iyPKH4V+pKzJRuBN
         FVZ+YK5kORlLhNX/KnITxmFWUHvWA5EuoAKEdiEWWtoMzK+CV9eZmuQzdJ1ed5av8Kif
         j2tSBkPSHjD1jvnbPWRWDnG2a/DOQw8e0hPFFpGisX6ylCO04FJplX26u4yy/vol6KEU
         gacmqgaPUZN5Ff8D1oogn7Q0qyftWvesSpl+4JtXzbNng40DR54Pzux+237qwcK14BD1
         /vvL7OUtriYGQj1G9E1Wwf112h6Rj+sYKSP6IAuSxCCZXoUQKcZ4AYbsCWIvgc9gplIq
         73Ag==
X-Gm-Message-State: AOAM533ZnQZjm15FK8W/FRwj4zZoZ5tGO0OR6nkmZfM6gcpEKOvVe8fB
        dM4tySsfsUQMipCPTwbUldSwU+SYONo=
X-Google-Smtp-Source: ABdhPJwNjwVgI2Q6S5XtMHs5X1SHKdw0H/cy2SW0GnpqmFPBb3K2OiH6kI+PhfFGoYz88aFmawvXkA==
X-Received: by 2002:a05:6830:47:: with SMTP id d7mr8456773otp.108.1629319440527;
        Wed, 18 Aug 2021 13:44:00 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.45])
        by smtp.googlemail.com with ESMTPSA id d26sm169723oos.41.2021.08.18.13.43.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Aug 2021 13:44:00 -0700 (PDT)
Subject: Re: ss command not showing raw sockets? (regression)
To:     Jonas Bechtel <post@jbechtel.de>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <20210815231738.7b42bad4@mmluhan>
 <20210816150800.28ef2e7c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210817080451.34286807@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210817202135.6b42031f@mmluhan>
 <20210817114402.78463d9d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <af485441-123b-4f50-f01b-cee2612b9218@gmail.com>
 <20210817143753.30f21bb0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <74deda94-f14e-be9e-6925-527c7b70a563@gmail.com>
 <20210818215738.1830fd0b@mmluhan>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0d301c66-0702-d87b-a815-f526f5971036@gmail.com>
Date:   Wed, 18 Aug 2021 14:43:58 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210818215738.1830fd0b@mmluhan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/18/21 1:57 PM, Jonas Bechtel wrote:
> 
> 
> 
> On Tue, 17 Aug 2021 18:47:06 -0600
> David Ahern <dsahern@gmail.com> wrote with subject
> "Re: ss command not showing raw sockets? (regression)":
> 
>> On 8/17/21 3:37 PM, Jakub Kicinski wrote:
>>>
>>> Ah, good point, strace will show it. 
>>>
>>> /me goes off to look at the strace Jonas sent off list.
>>>
>>> Well this is unexpected:
>>>
>>> sendmsg(3, {msg_name={sa_family=AF_NETLINK, nl_pid=0,
>>> nl_groups=00000000}, msg_namelen=12, msg_iov=[{iov_base={{len=76,
>>> type=DCCPDIAG_GETSOCK, ... --->8----------------  
>>>
>>> From: Jakub Kicinski <kuba@kernel.org>
>>> Subject: ss: fix fallback to procfs for raw and sctp sockets
>>>
>>> sockdiag_send() diverts to tcpdiag_send() to try the older
>>> netlink interface. tcpdiag_send() works for TCP and DCCP
>>> but not other protocols. Instead of rejecting unsupported
>>> protocols (and missing RAW and SCTP) match on supported ones.
>>>
>>> Fixes: 41fe6c34de50 ("ss: Add inet raw sockets information
>>> gathering via netlink diag interface") Signed-off-by: Jakub
>>> Kicinski <kuba@kernel.org> ---
>>>  misc/ss.c | 8 ++++----
>>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/misc/ss.c b/misc/ss.c
>>> index 894ad40574f1..b39f63fe3b17 100644
>>> --- a/misc/ss.c
>>> +++ b/misc/ss.c
>>> @@ -3404,13 +3404,13 @@ static int tcpdiag_send(int fd, int
>>> protocol, struct filter *f) struct iovec iov[3];
>>>  	int iovlen = 1;
>>>  
>>> -	if (protocol == IPPROTO_UDP || protocol == IPPROTO_MPTCP)
>>> -		return -1;
>>> -
>>>  	if (protocol == IPPROTO_TCP)
>>>  		req.nlh.nlmsg_type = TCPDIAG_GETSOCK;
>>> -	else
>>> +	else if (protocol == IPPROTO_DCCP)
>>>  		req.nlh.nlmsg_type = DCCPDIAG_GETSOCK;
>>> +	else
>>> +		return -1;
>>> +
>>>  	if (show_mem) {
>>>  		req.r.idiag_ext |= (1<<(INET_DIAG_MEMINFO-1));
>>>  		req.r.idiag_ext |= (1<<(INET_DIAG_SKMEMINFO-1));
>>>   
>>
>> That looks correct to me.
>>
>> Jonas: can you build iproute2 and test?
> 
> I've cloned branch main as instructed in https://wiki.linuxfoundation.org/networking/iproute2. Most recent commit is 9b7ea92b9e3f. After building, no socket was listed in table.
> 
> Then I [manually] applied the patch and rebuilt. The patched version works well, I do see the two sockets right now.
> 
> Command was in both cases misc/ss -awp
> 

Awesome, thanks for doing that. Jakub: want to send a formal patch with
his Tested-by?

