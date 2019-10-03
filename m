Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C093CA545
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 18:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403967AbfJCQcl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 12:32:41 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45769 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391939AbfJCQch (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 12:32:37 -0400
Received: by mail-pg1-f194.google.com with SMTP id q7so2063884pgi.12
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 09:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HIOR0oSmPkxJtwNkaZlDOyVDn/qqPRmBouwpQDzKZnk=;
        b=oKwRm0T/V//UEOAQcmvmWY4yvoUO2OON/zYvsBvTlItyDrDG98nrnlvZ45dYY8/+I+
         L7K0XC67soq+a1EWl/oHC+iXoSBaFHaUfLa4ynuyddf6UnguQy5P0I3xmr8MurbuCJCb
         JwLR+qAnePnHZh7tRZnZlT9ZFxWLoQGOV2E4VUdq1FB+s3lL/Bvtdeh1LXMNDFSUAXeb
         po1F+lsfPFp1nxfWLgcXveGkq7gpxRJxjzSS/VPfMHQ5UlYxka/IpZRT29zuGuJLbumG
         5vsPvwWLaN0Oq7BM0emJqIhy/yZ0YRFiNZgK+9SwYbc8qcbPXQZQigUi5WLn+Pnwd9y6
         C8eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HIOR0oSmPkxJtwNkaZlDOyVDn/qqPRmBouwpQDzKZnk=;
        b=BsHO+axp09f4ljRWd1HDU2H5sgvFE6y3ctqyEYBQw+CTX+YqvSRqi0pA8xe8UHNY7Z
         vbfZqs0eTphIhIoghFMW8smBQKCzj26Tcy8XbWJq8W+8yMeStmxkpb4ZHSdeYPTJa3p0
         xmzYu4q+9usW/1Axg7dzSwmTdwtLDZGhrcNXTzYyYf+Ri1whgKIDtAKyuQdY4hRjQo4W
         AWsqo9E5URoU2zRVuzVwvEIfbNhkBlbZybQVBqQO1HV8pB5juiwrmSod9xAyENeRghTU
         m6lY1j2sgRX0DR4/uIMqEtQ4GvujfeJqxnP9xNp7snUwNrtNhnrdXj9xdD3LYN7IJf3n
         oxbA==
X-Gm-Message-State: APjAAAW1EtXQ5M/aWXl+LPCIDyFdB8azIMUBLreCaqkjN05SnJWfiURz
        htFKmLjOipQQHgdL8K+pS5A=
X-Google-Smtp-Source: APXvYqyxsZAEXsOQjZfTGwSvfyLwV/VJr8As0p44fCjIYkUFAJM3qn1yosfBbsSWo63/5bOG4VJ3sQ==
X-Received: by 2002:a62:1d12:: with SMTP id d18mr11979075pfd.53.1570120356953;
        Thu, 03 Oct 2019 09:32:36 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id e127sm4115291pfe.37.2019.10.03.09.32.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Oct 2019 09:32:35 -0700 (PDT)
Subject: Re: [PATCH net v2] ipv6: Handle race in addrconf_dad_work
To:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, rajendra.dendukuri@broadcom.com
References: <20191001032834.5330-1-dsahern@kernel.org>
 <1ab3e0d0-fb37-d367-fd5f-c6b3262b6583@gmail.com>
 <18c18892-3f1c-6eb8-abbb-00fd6c9c64d3@gmail.com>
 <146a2f8a-8ee9-65f3-1013-ef60a96aa27b@gmail.com>
 <4c896029-882f-1a4f-c0cc-4553a9429da3@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <43e2c04f-a601-3363-1f98-26fd007be960@gmail.com>
Date:   Thu, 3 Oct 2019 09:32:34 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <4c896029-882f-1a4f-c0cc-4553a9429da3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/3/19 8:50 AM, David Ahern wrote:
> On 10/2/19 3:23 PM, Eric Dumazet wrote:

>>
>> It seems we need to allow the code to do some changes if IF_READY is not set.
>>
> 
> That statement was correct. Prior to the patch in question ifp->state is
> bumped to INET6_IFADDR_STATE_DAD in addrconf_dad_work. When
> NETDEV_CHANGE event happens, addrconf_notify calls addrconf_dad_run
> which calls addrconf_dad_kick to restart dad after the dad process
> (applies even if nodad is set -- yes, odd).
> 
> With the patch, IF_READY is not set when the bond device is created and
> dad_work skips bumping the state. When the CHANGE event comes through
> the state is not INET6_IFADDR_STATE_DAD (and the restart argument is not
> set), so addrconf_dad_run does not call addrconf_dad_kick.
> 
> Bottom line, regardless of IF_READY we need the state change to happen
> in dad_work, we just need to skip the call to addconf_dad_begin.
> 
> Can you test the change below on your boxes? It applies on current net.
> 
> Rajendra: can you test as well and make sure your problem is still
> resolved?
> 
> Thanks,
> 
> diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
> index dd3be06d5a06..fce0d0dca7bb 100644
> --- a/net/ipv6/addrconf.c
> +++ b/net/ipv6/addrconf.c
> @@ -4032,12 +4032,6 @@ static void addrconf_dad_work(struct work_struct *w)
> 
>         rtnl_lock();
> 
> -       /* check if device was taken down before this delayed work
> -        * function could be canceled
> -        */
> -       if (idev->dead || !(idev->if_flags & IF_READY))
> -               goto out;
> -
>         spin_lock_bh(&ifp->lock);
>         if (ifp->state == INET6_IFADDR_STATE_PREDAD) {
>                 action = DAD_BEGIN;
> @@ -4068,6 +4062,12 @@ static void addrconf_dad_work(struct work_struct *w)
>         }
>         spin_unlock_bh(&ifp->lock);
> 
> +       /* check if device was taken down before this delayed work
> +        * function could be canceled
> +        */
> +       if (idev->dead || !(idev->if_flags & IF_READY))
> +               goto out;
> +
>         if (action == DAD_BEGIN) {
>                 addrconf_dad_begin(ifp);
>                 goto out;
> 

Still no luck for me :/

