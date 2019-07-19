Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1969C6E9AE
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 18:55:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729931AbfGSQzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 12:55:52 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:39856 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727717AbfGSQzv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 12:55:51 -0400
Received: by mail-io1-f68.google.com with SMTP id f4so59803101ioh.6
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 09:55:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rAELOA+cvkR5VvYnSHzjUAYftTjyiFmOb38HLT1Wcmo=;
        b=CaLfEt/tuJi6RmtrK7KWK7axn6qr/p1qdidHuYcseJYbv41eqxeqTPny7hComrL+2T
         C+38Yy/o+cJHhCm4w0XHTlxpF4enFnkWtrTIAKKX4XsblRVDmDdSCWejsvcfomPYEB+i
         W0fwZMGHTmMWRhBb05eQ56CXTozJT6yxaWccm3YEAY4g8V+Nzoi136PZr4ajgjcF1xlV
         YcbLUdjXq4FywQmvbWLZ84p3aI2tl9XsI6TwnXAhjDhVYXXyZk87Ae3PCnxVPIIK2hwc
         Cq76yNEZi1BXC0slnAPriS7d7qKHteDqo9zUYxCGAULT9LxpPpsYScLKXIyFro2fPztY
         vpgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rAELOA+cvkR5VvYnSHzjUAYftTjyiFmOb38HLT1Wcmo=;
        b=rhT3NMNZgouoLTtjSYKw8neRIqdC2Ri1nFAwm1oC2C4qFCgCdS0IUCEh0ncfGwboNA
         tkSvPp73Y4TLBO7gpIZzuA/AVmckuFid6bRXwlwEjdULyipXrGjwdNplPdepcg5lSw9z
         ZqywlG0uutfg0eNLBmS4FSvxBliN7pmV9odm37nri/BYpfRNMrFndMD/mqUICEDhSloI
         AyjoybT3YWQvQl6a0ssn24NlqVvqGFrUwwxrrtGR3xU/2N1kBOpMWn8xic4gXHA7eqVm
         o1Xe42glAvWZ9nnJ4sjlNBjQcMORzwWWfDW7Yn+oK9KY3s4jRWosL0fiBkq9k/u/PoXD
         ZafQ==
X-Gm-Message-State: APjAAAWch3KbKjX8rCgTBehlTuF/mFJ8O3L8ssRAdBdlKqDi4u7YGN1/
        TXGtqdlB/1ZeRpHqHI0xa/I=
X-Google-Smtp-Source: APXvYqxgfYNMUWCRRLqGKHbdD2MDcdj1LVm2iuiW82MuLAB7ZAKmPHdeN53olJbDDymwB2L0Ro6+tw==
X-Received: by 2002:a6b:7619:: with SMTP id g25mr290241iom.92.1563555350994;
        Fri, 19 Jul 2019 09:55:50 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:b559:3352:82ff:93d8? ([2601:282:800:fd80:b559:3352:82ff:93d8])
        by smtp.googlemail.com with ESMTPSA id p3sm37105934iom.7.2019.07.19.09.55.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 19 Jul 2019 09:55:50 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 03/11] net/ipv4: Plumb support for filtering
 route dumps
To:     Hangbin Liu <liuhangbin@gmail.com>,
        David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, Jianlin Shi <jishi@redhat.com>
References: <20181016015651.22696-1-dsahern@kernel.org>
 <20181016015651.22696-4-dsahern@kernel.org>
 <20190719041700.GO18865@dhcp-12-139.nay.redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <147df36b-75df-5e71-3d74-9454db676bce@gmail.com>
Date:   Fri, 19 Jul 2019 10:55:49 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190719041700.GO18865@dhcp-12-139.nay.redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi:

On 7/18/19 10:17 PM, Hangbin Liu wrote:
> Hi David,
> 
> Before commit 18a8021a7be3 ("net/ipv4: Plumb support for filtering route
> dumps"), when we dump a non-exist table, ip cmd exits silently.
> 
> # ip -4 route list table 1
> # echo $?
> 0
> 
> After commit 18a8021a7be3 ("net/ipv4: Plumb support for filtering route
> dumps"). When we dump a non-exist table, as we returned -ENOENT, ip route
> shows:
> 
> # ip -4 route show table 1
> Error: ipv4: FIB table does not exist.
> Dump terminated
> # echo $?
> 2
> 
> For me it looks make sense to return -ENOENT if we do not have the route
> table. But this changes the userspace behavior. Do you think if we need to
> keep backward compatible or just let it do as it is right now?
> 

It is not change in userspace behavior; ip opted into the strict
checking. The impact is to 'ip' users.

A couple of people have asked about this, and I am curious as to why
people run a route dump for a table that does not exist and do not like
being told that it does not exist.
