Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5C8824D95B
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 18:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726007AbgHUQFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 12:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725834AbgHUQFh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 12:05:37 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F69C061573;
        Fri, 21 Aug 2020 09:05:37 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id o21so1909308oie.12;
        Fri, 21 Aug 2020 09:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=BcOLS+QuONeHD3ULxAD7chhfzxFLcz1amouLJKxi+4E=;
        b=CLiNQhzzfkl8UaGxUU332gsocXd65bcriw/vgAe+SQvAOTIvOkdx/DGINT/3KQ6l4N
         UE4E8YfqEVIbBoMpZGeo7ZOvqBaB9pLGk7CqMotD8E/Ss1ypE1fcy4MehY5zzxSnDqkC
         gx58nceVEBx4K+pdI2iTotzuMpQWUvNaRQxFhLyVVRyOrFkL4yuZroV4dhghrNC2Awy8
         wf2zPHOTnP9RYilhVHYYVnUzZbNrHhPuyrM8+S4qafxNUIzwcWVS59n7XrnVtXFOHDB8
         SEeniXIZvPbiD9fiBRl5bBbTs76WkX4zfKD7JEmDB7TNtMTjuWA8WeWJ9Ro8J35XHzu/
         S5QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BcOLS+QuONeHD3ULxAD7chhfzxFLcz1amouLJKxi+4E=;
        b=XYchesj05xtkDB4IJnjsuDozeFyLSt7DWVg8jI1V9PnDbRAubn2+b84ZH48KjwR+ri
         Wbyv2ngSCUzk/N8lmxNMqrwOjLGYwANxoKmI65WVBr2AJxura4NBSydNtqUz4Q2IaoDd
         iwBfoF5yakbuz5m+34FyeMnNU+im6v/7FL2vJGSHIRhdnAbG//ZvGevGsdTDmEThJZoR
         DTj86RqgYgFNUwbU1N4RIAHLGOvp46CaUvqxvvD/9tBwE91hhXAJ3powM00ZHfIS4Fse
         nMSzfwzASVOTNowXIHxtWcv5cDmB6Bnbz2b1NxlAKrFvM5HGVo/aH9H/n92ByTB4YQKA
         2gEQ==
X-Gm-Message-State: AOAM531VcQt5BSirqF894s7nB38EUglnyBaUCOWygmq5SS/GiXNVcy7g
        XX6FgbXJQwdhFdatkXndR78=
X-Google-Smtp-Source: ABdhPJzSkgdfxS9dyh3gPvKo0mml6TPmUNJQAExx4dRCzuO1vCfiWKeQ2N+xAcTWp7uzCJ50SkL7/A==
X-Received: by 2002:aca:2304:: with SMTP id e4mr2225683oie.1.1598025935729;
        Fri, 21 Aug 2020 09:05:35 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:284:8202:10b0:a888:bc35:d7d6:9aca])
        by smtp.googlemail.com with ESMTPSA id t1sm494307ooi.27.2020.08.21.09.05.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Aug 2020 09:05:35 -0700 (PDT)
Subject: Re: general protection fault in fib_dump_info (2)
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        syzbot <syzbot+a61aa19b0c14c8770bd9@syzkaller.appspotmail.com>,
        davem@davemloft.net, kuba@kernel.org, kuznet@ms2.inr.ac.ru,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, yoshfuji@linux-ipv6.org
References: <00000000000039b10005ad64df20@google.com>
 <47e92c2b-c9c5-4c74-70c4-103e70e91630@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <6184a09e-04ee-f7f0-81b0-de405b6188ae@gmail.com>
Date:   Fri, 21 Aug 2020 10:05:16 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <47e92c2b-c9c5-4c74-70c4-103e70e91630@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/21/20 10:00 AM, Nikolay Aleksandrov wrote:
> 
> This seems like a much older bug to me, the code allows to pass 0 groups
> and
> thus we end up without any nh_grp_entry pointers. I reproduced it with a
> modified iproute2 that sends an empty NHA_GROUP and then just uses the new
> nexthop in any way (e.g. add a route with it). This is the same bug as the
> earlier report for: "general protection fault in fib_check_nexthop"

hmmm.... empty NHA_GROUP should not be allowed.

> 
> I have a patch but I'll be able to send it tomorrow.
> 

thanks.
