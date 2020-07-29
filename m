Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B478232166
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 17:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726588AbgG2PRz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 11:17:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726054AbgG2PRz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 11:17:55 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64BD6C061794
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 08:17:55 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id l23so22575173qkk.0
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 08:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=SATJSbZ68TpRrd845LkTT8zlr1FoI++O7T+UPD4Dc8M=;
        b=EA/hIOfnjx3TVQFt8uRsarUfA49jF69dGbrI6hCrh8kjRFZlZhQbyqhGoeIg92TmtW
         ZWP5zFH4SpVQiCE1Y12Sgrxp9jN5lErqQM1nAM1hrF3D8wf/On3x6ByplJfIsOsOE8KF
         Qwaka5XG9jGgjxnVfkU7y4UwbwdBpGEU0q7ZjAZHrMlLuECSIvtiu8F7Ky11g7UqnCv/
         uBPjLiBb/rqtQyMI6OTCrAMPvRqauDjNq8CwltFnqyQmSVASAQW0MX+7Asz24eMYoML9
         0JKYzE270KWE2nzisrc5wwrvWmKVBnXCEfeHDfJ5NzBaXmLzeulVqZyGzu0XWbXJDZJw
         Yleg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=SATJSbZ68TpRrd845LkTT8zlr1FoI++O7T+UPD4Dc8M=;
        b=e5SEDi+QayaIz5A4VuKVmJsmNVTPRi8DtUsEoaBLH4Sau1p07CXoVfGNrUvclb7sJD
         KRwGw2qdAN0bNMhecHFA54T46XSr0TqoshBBg2t4sJG3WJHU5BVYgAE5ECJfu7j2dU8i
         GNmW8KIScNK4rsbl4a+f6bJXN5XaLQgO9+u0aQmieI6RJ9wLwjpdsDsxIxpLzjUIwluB
         80vnx0sYNTWhoF0qqnK7PGwA99/II0P3QWfAueQILiO8E4PZy5sGt9BZWg/mq8Ak5vJk
         DTKDo3NiItCFKsDffBbZTGNfkD1yf02YuSOObZqlzjnHNiPpl0qX90akCheJkNWbdbJS
         Yc0w==
X-Gm-Message-State: AOAM533jDYNk+Wv9kaj70bTLVHRTEKWugo2J4cangWdeQ6eI6AJu0CfR
        qdOjCf67MdEtqPIQfi6xwQ3uXijX
X-Google-Smtp-Source: ABdhPJyV4Q+yEW7X3fp8l2j4Bj0jvxfD8NLfsN6L/AsdKq+MBYhwxqsjebOfxQMkDJ7BpXCFEFg2YA==
X-Received: by 2002:a37:e86:: with SMTP id 128mr32265695qko.314.1596035874418;
        Wed, 29 Jul 2020 08:17:54 -0700 (PDT)
Received: from ?IPv6:2601:284:8202:10b0:c873:abf:83ee:21b3? ([2601:284:8202:10b0:c873:abf:83ee:21b3])
        by smtp.googlemail.com with ESMTPSA id h20sm1680926qkk.79.2020.07.29.08.17.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2020 08:17:52 -0700 (PDT)
Subject: Re: Bug: ip utility fails to show routes with large # of multipath
 next-hops
To:     Ido Schimmel <idosch@idosch.org>,
        Ashutosh Grewal <ashutoshgrewal@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
References: <CAKA6ep+EFNOYY8k8PFP9kf_F5GY+5g8qu_LphEAX6N7iEFTs9Q@mail.gmail.com>
 <20200729114317.GA2120829@shredder>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a7652bf8-e7fc-a76f-0fa7-2457128e2abc@gmail.com>
Date:   Wed, 29 Jul 2020 09:17:51 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200729114317.GA2120829@shredder>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/29/20 5:43 AM, Ido Schimmel wrote:
> On Tue, Jul 28, 2020 at 05:52:44PM -0700, Ashutosh Grewal wrote:
>> Hello David and all,
>>
>> I hope this is the correct way to report a bug.
> 
> Sure
> 
>>
>> I observed this problem with 256 v4 next-hops or 128 v6 next-hops (or
>> 128 or so # of v4 next-hops with labels).
>>
>> Here is an example -
>>
>> root@a6be8c892bb7:/# ip route show 2.2.2.2
>> Error: Buffer too small for object.
>> Dump terminated
>>
>> Kernel details (though I recall running into the same problem on 4.4*
>> kernel as well) -
>> root@ubuntu-vm:/# uname -a
>> Linux ch1 5.4.0-33-generic #37-Ubuntu SMP Thu May 21 12:53:59 UTC 2020
>> x86_64 x86_64 x86_64 GNU/Linux
>>
>> I think the problem may be to do with the size of the skbuf being
>> allocated as part of servicing the netlink request.
>>
>> static int netlink_dump(struct sock *sk)
>> {
>>   <snip>
>>
>>                 skb = alloc_skb(...)
> 
> Yes, I believe you are correct. You will get an skb of size 4K and it
> can't fit the entire RTA_MULTIPATH attribute with all the nested
> nexthops. Since it's a single attribute it cannot be split across
> multiple messages.

yep, well known problem.

> 
> Looking at the code, I think a similar problem was already encountered
> with IFLA_VFINFO_LIST. See commit c7ac8679bec9 ("rtnetlink: Compute and
> store minimum ifinfo dump size").
> 
> Maybe we can track the maximum number of IPv4/IPv6 nexthops during
> insertion and then consult it to adjust 'min_dump_alloc' for
> RTM_GETROUTE.

That seems better than the current design for GETLINK which walks all
devices to determine max dump size. Not sure how you will track that
efficiently though - add is easy, delete is not.

> 
> It's a bit complicated for IPv6 because you can append nexthops, but I
> believe anyone using so many nexthops is already using RTA_MULTIPATH to
> insert them, so we can simplify.

I hope so.

> 
> David, what do you think? You have a better / simpler idea? Maybe one
> day everyone will be using the new nexthop API and this won't be needed
> :)

exactly. You won't have this problem with separate nexthops since each
one is small (< 4k) and the group (multipath) is a set of ids, not the
full set of attributes.
