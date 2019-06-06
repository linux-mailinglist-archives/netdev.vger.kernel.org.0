Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 800EB381BC
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 01:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727677AbfFFXTx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 19:19:53 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:42751 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727074AbfFFXTx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 19:19:53 -0400
Received: by mail-pf1-f194.google.com with SMTP id q10so39503pff.9
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 16:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Iaybzo7g/TOa4vOli49PMioeP8KMnjuQ4j1zCyButBo=;
        b=E7vbiDM/DlWscA9EOlPagNhpw3lwg+Erdi8HSP688ovzglqVXET4tR3TJZxP+CH79T
         HNqkTcIF8PLzB4tc6dgBUPIQ0S9QUOvZqGC6+UI9Az6aig5fjNvb77r2d6QDsARGf+VI
         c1mxyW8K/1i6HRDEk+4/oopd+sfmUTbgWrIlx+bMUXq0MWjhUC9daumd1K0aPybhRKet
         Pptbp9pP9K0nFM5MOkumUSO8mC92xZF+D4HuMiTRbLHTCQiXAnil7bTS7W9uXSVDVxJ8
         gLvqOqJddCjtPOm0XpJrJT2TVRziFD4sIouHkEQeUeRUq1U9CqMSSuFaQ42xiHoDP2Uw
         rt7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Iaybzo7g/TOa4vOli49PMioeP8KMnjuQ4j1zCyButBo=;
        b=kHPKommLv5qg3cBA9sNmZHJBuvWh4ukKwavL7nZCR3QYmoxKDLiV7B+MkvgQcfbsAP
         43NcRJd7M0IwZRkKr3N0NuVXVvdNgjb+/+dQ4OzqMiTrq5hSCQYfCwmXsTGSlruPJvNf
         o/0tzOx1rsg1rl3KDjbJW+CSvdo+GvyLOv78Pd+bcDBkFG4Tkp5rUogYL6qCMp/jfroK
         dHaH+W499xZoEtK0UCAObfR7XGDel37MUpxXYrC5sqxm2toGfiJzdhkcuMdeq1XfM04U
         qZQfIjjI5mmTFrlB/MSy0+g+D2sXSBtWLj6f16tr/CIinWkrZV86IF4KFD3jr7nZNQGq
         X7XQ==
X-Gm-Message-State: APjAAAUHoKD7RqWa8MS1b8EyjdxdwMlVjZ7PdKgXuou+ie86IdgjG45h
        rP5/tjqvdZfRn/0RMB7krhSxQ0sw2/0=
X-Google-Smtp-Source: APXvYqwqDbUbE9cuFsIeBgmIqAc/eatX9Bq/x6lKEaQTXtEdcKyk2fME/Hc1WNfkj0IOln6ORVTafA==
X-Received: by 2002:a17:90a:9f8e:: with SMTP id o14mr2300225pjp.82.1559863192387;
        Thu, 06 Jun 2019 16:19:52 -0700 (PDT)
Received: from [172.27.227.171] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id a64sm212119pgc.53.2019.06.06.16.19.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Jun 2019 16:19:51 -0700 (PDT)
Subject: Re: [PATCH net 1/2] ipv6: Dump route exceptions too in
 rt6_dump_route()
To:     Stefano Brivio <sbrivio@redhat.com>, Martin Lau <kafai@fb.com>
Cc:     David Miller <davem@davemloft.net>, Jianlin Shi <jishi@redhat.com>,
        Wei Wang <weiwan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <cover.1559851514.git.sbrivio@redhat.com>
 <085ce9fbe0206be0d1d090b36e656aa89cef3d98.1559851514.git.sbrivio@redhat.com>
 <20190606214456.orxy6274xryxyfww@kafai-mbp.dhcp.thefacebook.com>
 <20190607001747.4ced02c7@redhat.com>
 <20190606223707.s2fyhnqnt3ygdtdj@kafai-mbp.dhcp.thefacebook.com>
 <20190607005852.2aee8784@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <fb2cb639-6e7b-ca3b-3ae3-e575a8e51d92@gmail.com>
Date:   Thu, 6 Jun 2019 17:19:49 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190607005852.2aee8784@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/6/19 4:58 PM, Stefano Brivio wrote:
>>> This also means that to avoid sending duplicates in the case where at
>>> least one rt6_fill_node() call goes through and one fails, we would
>>> need to track the last bucket and entry sent, or, alternatively, to
>>> make sure we can fit the whole node before dumping.  
>> My another concern is the dump may never finish.
> 
> That's not a guarantee in general, even without this, because in theory
> the skb passed might be small enough that we can't even fit a single
> node without exceptions.

That should be handled by skb->len = 0 and then returning the err back
to caller. See inet_dump_fib.

> 
> We could add a guard on w->leaf not being the same before and after the
> walk in inet6_dump_fib() and, if it is, terminate the dump. I just
> wonder if we have to do this at all -- I can't find this being done
> anywhere else (at a quick look at least).
> 
> By the way, we can also trigger a never-ending dump by touching the
> tree frequently enough during a dump: it would always start again from
> the root, see fib6_dump_table().
> 

that should be a userspace problem on a sequence mismatch. In-kernel
notifiers do restart for offload drivers (seeregister_fib_notifier), but
as I recall the kernel should not restart a dump.

libnl reference is nl_cache_refill,

                err = nl_cache_pickup(sk, cache);
                if (err == -NLE_DUMP_INTR) {
                        NL_DBG(2, "Dump interrupted, restarting!\n");
                        goto restart;
                } else if (err < 0)
                        break;
