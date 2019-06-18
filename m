Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0794D4A47A
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 16:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729437AbfFROvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 10:51:04 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:43841 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729061AbfFROvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 10:51:04 -0400
Received: by mail-io1-f67.google.com with SMTP id k20so30393063ios.10
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 07:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sGb+xaYDifIgRsJW0YjQengPKyqYwMKt7wZBY66b364=;
        b=BeL9wGASe8H0AZOkaeEwNUcFygl3LSkhjSmXBzOr/PHa56ExTM1n5SnMMGxWdR3lnG
         dtuuihfFcLpTrvYiK6P/jXvHjOyPtc5vw0XGKt87YhpiFOQ5QJTzX21LFOmDZ/TY0S0K
         R9XywtcPHtGSziAwDu7H4zb89wCBnbrKs1UuTLyQIacQQd28tAy3ylbsq8iCGA2tjyoW
         cAlrAwuVG64lNwfnlFjtwS8GOWyHh+3o5jGejZef8HVj/IUJEWZ4q4xo8/L7SBjnETWg
         HJrryK7zRco4Tq0b2CpS1shsOUvtASvSznWYXbcUjS3UiyHB7ee8B3WG8wZ9Hur0umcL
         9rRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sGb+xaYDifIgRsJW0YjQengPKyqYwMKt7wZBY66b364=;
        b=PFh271Atrq6GlihEZ5IJMrgGK6GRFQAJVkHVhJI8ZWp7nKQ2RpvilbQghcboszwJMc
         CEy8gAo/kzRngtaohPru3GqZc8XkF604rQscW+ee1xnvYhIDeb4iSP8FH/Y3jNLv5/0p
         PgVYYFueEEC5kugotE837EktSsKlwEPFv8gh4BtLGujsP5/BuW5B5Zht1ES2hzmdDhk+
         MlnlamforlMRVzpljOQdzEsWO9kN9U9/rnn170XLyKBWUx8tBrJEMlE5HWGOptJPFd1Q
         VEUYWQlnoDViPw/h23j1oFS/uXY0FfmwB4BU4ppYmdyjrAZZINpE+FCVH0BVrCUvT9K5
         aowg==
X-Gm-Message-State: APjAAAXBun09r4QweefxdwRCfVsxdWc8lpDEi6LUcbsHrp8Qoor/V0h1
        Od7e6Ke32BiM3jnKoeoDd3t58FmS
X-Google-Smtp-Source: APXvYqxLh5mheWU//nI4bMs7ZZZeCadoziaANVf5HrjIgc+KnhRzygXsw2uqzhR32NP3mbOSMky+Zg==
X-Received: by 2002:a5d:8f9a:: with SMTP id l26mr5750784iol.22.1560869463371;
        Tue, 18 Jun 2019 07:51:03 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:fd97:2a7b:2975:7041? ([2601:282:800:fd80:fd97:2a7b:2975:7041])
        by smtp.googlemail.com with ESMTPSA id f17sm18416407ioc.2.2019.06.18.07.51.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 07:51:02 -0700 (PDT)
Subject: Re: [PATCH net v5 0/6] Fix listing (IPv4, IPv6) and flushing (IPv6)
 of cached route exceptions
To:     Stefano Brivio <sbrivio@redhat.com>,
        David Miller <davem@davemloft.net>
Cc:     Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
References: <cover.1560827176.git.sbrivio@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a88182c7-10ee-0505-3b5b-bec852e24e97@gmail.com>
Date:   Tue, 18 Jun 2019 08:51:01 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <cover.1560827176.git.sbrivio@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/18/19 7:20 AM, Stefano Brivio wrote:
> For IPv6 cached routes, the commands 'ip -6 route list cache' and
> 'ip -6 route flush cache' don't work at all after route exceptions have
> been moved to a separate hash table in commit 2b760fcf5cfb ("ipv6: hook
> up exception table to store dst cache").
> 
> For IPv4 cached routes, the command 'ip route list cache' has also
> stopped working in kernel 3.5 after commit 4895c771c7f0 ("ipv4: Add FIB
> nexthop exceptions.") introduced storage for route exceptions as a
> separate entity.
> 
> Fix this by allowing userspace to clearly request cached routes with
> the RTM_F_CLONED flag used as a filter (in conjuction with strict
> checking) and by retrieving and dumping cached routes if requested.
> 
> If strict checking is not requested (iproute2 < 5.0.0), we don't have a
> way to consistently filter results on other selectors (e.g. on tables),
> so skip filtering entirely and dump both regular routes and exceptions.
> 
> I'm submitting this for net as these changes fix rather relevant
> breakages. However, the scope might be a bit broad, and said breakages
> have been introduced 7 and 2 years ago, respectively, for IPv4 and IPv6.
> Let me know if I should rebase this on net-next instead.
> 
> For IPv4, cache flushing uses a completely different mechanism, so it
> wasn't affected. Listing of exception routes (modified routes pre-3.5) was
> tested against these versions of kernel and iproute2:
> 

Changing the dump code has been notoriously tricky to get right in one
go, no matter how much testing you have done. Given that I think this
should go to net-next first and once it proves ok there we can look at a
backport to stable trees.

