Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC9E17D824
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 03:30:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbgCICaA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Mar 2020 22:30:00 -0400
Received: from mail-io1-f47.google.com ([209.85.166.47]:44356 "EHLO
        mail-io1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726363AbgCICaA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Mar 2020 22:30:00 -0400
Received: by mail-io1-f47.google.com with SMTP id u17so7620843iog.11
        for <netdev@vger.kernel.org>; Sun, 08 Mar 2020 19:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=7DQRECc8TM2EAT9+nMuiuoeX7R4GOauaaGkJwe+FUE0=;
        b=ooBhPFMkVyoDV6UHLUXoefZEC+66Cq+Rv3XdHh2QHy2Q1w27K/QOv5t3OyeX0Xd0lv
         aoCSWFZKUJZsFiPKo1YMH9sHp0aUn6tyb1QxJqfck4sxTkYoxGt9RKUiu8nBby0DOtho
         eDuV1my0c/3+9X1egqgnPuXrytSS46zZSxYrYd2sUKA9zQUu5UK0OIdT7OyCI+7Q1Ckh
         hoWFUl+y/+O/I64+CFUumOSeU3QxFYs1GBf2k4HkAOt+8RALEPmUeSBZTFLpe+ppbDbK
         zYTMhQYr5rq6G5LoMkpzXxFwROGCMw+D6oW6Dnz2dg376pdyN32W8viwAB/9tR8oljWY
         XKgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7DQRECc8TM2EAT9+nMuiuoeX7R4GOauaaGkJwe+FUE0=;
        b=ENwhp6hyh4q0RGMidU8AtUzPjkVvIPmQASiB8Ad3ZpxXA8hKgoUJYMzScyFDJ/CRQr
         SQ2mYyU4F56gVK+VyLXEGz6dOpmVslWUYg2ZAkKPYSSbGpmOEPklS3Ji4EqhsNiheQq0
         vzzO7d0U83lUeYAaRV/Fq+eTrGcVleKAA+hiV5qIJma4QeqtIe5bI9YzsY6hpOWD44Ph
         p3b/ow9AJ3eFUbprHzuEzdZUq72vg4w7H0f4rgp+m2z3FcorOYcO4BeUdZMvYvn7qaoq
         raToYxxe8UDqKuN83p6Bf6iAqBza1WUal0HuvjmrIDAKoqyowiIxShSr1etUW9t525/I
         tTKw==
X-Gm-Message-State: ANhLgQ3YRsz/6z3NyC1QQZsVtsCHVJuosd1p2pBE0qpVZy4StsytYJQs
        +zoGICryMDEr2HBrAKV10Wo=
X-Google-Smtp-Source: ADFU+vudIIY26gmY92abmdTNU1HcDPT/YaWvtdb7aKa3uvTR7AVwD+Ec9QLXU/qWl8IKdRd2oD9Arg==
X-Received: by 2002:a5d:9f07:: with SMTP id q7mr11811161iot.42.1583720998052;
        Sun, 08 Mar 2020 19:29:58 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:54d7:a956:162c:3e8? ([2601:282:803:7700:54d7:a956:162c:3e8])
        by smtp.googlemail.com with ESMTPSA id l18sm12143570ild.51.2020.03.08.19.29.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Mar 2020 19:29:57 -0700 (PDT)
Subject: Re: route: an issue caused by local and main table's merge
To:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        davem <davem@davemloft.net>, mmhatre@redhat.com,
        "alexander.h.duyck@intel.com" <alexander.h.duyck@intel.com>
References: <CADvbK_evghCnfNkePFkkLbaamXPaCOu-mSsSDKXuGSt65DSivw@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <1441d64c-c334-8c54-39e8-7a06a530089d@gmail.com>
Date:   Sun, 8 Mar 2020 20:29:56 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <CADvbK_evghCnfNkePFkkLbaamXPaCOu-mSsSDKXuGSt65DSivw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

[ This got lost in the backlog ]

On 3/2/20 1:38 AM, Xin Long wrote:
> Hi, David A.
> 
> Mithil reported an issue, which can be reproduced by:
> 
>   # ip link  add dummy0 type dummy
>   # ip link  set dummy0 up
>   # ip route add to broadcast 192.168.122.1 dev dummy0 <--- broadcast
>   # ip route add 192.168.122.1 dev dummy0   <--- unicast
>   # ip route add 1.1.1.1 via 192.168.122.1  <--- [A]
>   Error: Nexthop has invalid gateway.
>   # ip rule  add from 2.2.2.2
>   # ip route add 1.1.1.1 via 192.168.122.1  <--- [B]
> 
> cmd [A] failed , as in fib_check_nh_v4_gw():
> 
>     if (table)
>             tbl = fib_get_table(net, table);
> 
>     if (tbl)
>             err = fib_table_lookup_2(tbl, &fl4, &res,
>                                    FIB_LOOKUP_IGNORE_LINKSTATE |
>                                    FIB_LOOKUP_NOREF);
> 
>     if (res.type != RTN_UNICAST && res.type != RTN_LOCAL) { <--- [a]
>             NL_SET_ERR_MSG(extack, "Nexthop has invalid gateway");
>             goto out;  <--[a]
>     }
> 
> It gets the route for '192.168.122.1' from the merged (main/local)
> table, and the broadcast one returns, and it fails the check [a].
> 
> But the same cmd [B] will work after one rule is added, by which
> main table and local table get separated, it gets the route from
> the main table (the same table for this route), and the unicast
> one returns, and it will pass the check [a].
> 
> Any idea on how to fix this, and keep it consistent before and
> after a rule added?
> 

I do not have any suggestions off the top of my head.

Adding Alex who as I recall did the table merge.
