Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 228E325996D
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 18:40:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732170AbgIAQjj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 12:39:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731962AbgIAQjf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 12:39:35 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69BCFC061244;
        Tue,  1 Sep 2020 09:39:35 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id r9so1965810ioa.2;
        Tue, 01 Sep 2020 09:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2hmchj6tzXfg/rA+qGoMbvWLJHRk3QcZpqMSJbpmE5M=;
        b=rC20qu2un7Z7QQjZU4xpUIIFoMOtynZFb53IprMdBjFF7A5Dwfp3urzo1m/pjQbQ+z
         xV0/pk4n2y2llclgMQV7U3eH48DulGc6n0YwaHiC0yF4PIld8gghCWWMpbRyeqnHdZ3q
         Xrsn9GZ7EH5jEgFh8RP0ZDLhayD/LWW4e9OmyPWwZf56veUki6rL+87wOZRH7p3mGD4f
         nkueltpv2+h8HhCJ9wroTxHTRIEuH3CnjsIhH4Au8LKK9BuNPkGKIXD8qOIKlx1gcKRC
         JB6o1Hxjw2KuxruwhGfL/gOgv7KLWP6FuHStxzo0lmFLRhQ7pDQIYylxUH18rW2fAEie
         twhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2hmchj6tzXfg/rA+qGoMbvWLJHRk3QcZpqMSJbpmE5M=;
        b=grpqVDEeQL7Oo0Csn7YU46hIg0vQmchtmJEqJUbs/DMeh8zGzjjb+b14krPJg1a44o
         m4W+9yUbzAxgnQ2KXddY7gyKieJUmFLYKh7SFj8H+nv25O5bf5O0QG7bksddmEZ6lCcE
         pwHGujOYENmiX99qX82Oufy9wtikC3VDAkfNHC/tUyylfWaD0jRcbRi+7dbRrnKDelX4
         mrcSCwFY75jywU2R5SLf6cbd6tiqVslDcgu+2kh3vY+/buO2SUBMIMML7s0OVzujL+1b
         LdKSoW1em3ss1XlVt0PHbAVbdmcsqDdktr0z1hpwR57r2E0a5hyzCoXxQgIPmrL0vGLi
         gQdg==
X-Gm-Message-State: AOAM532WbdX1eXseSWTfER4zktUT2Nk2Fa/88uZoC403lY3cQkk9ncI3
        sYw1uXMtVhMh4Hw4uS8EtI1nJDhORasUwg==
X-Google-Smtp-Source: ABdhPJzHoOF9JChcO89H1cfZeH2DcjVkvIvm41Y0yoX/wIWPmpgBbIXj5QL+nzmYY9afKdSQjKtDQw==
X-Received: by 2002:a05:6602:2d55:: with SMTP id d21mr2151921iow.134.1598978374614;
        Tue, 01 Sep 2020 09:39:34 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:883e:eb9e:60a1:7cfb])
        by smtp.googlemail.com with ESMTPSA id r9sm815669iln.18.2020.09.01.09.39.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2020 09:39:33 -0700 (PDT)
Subject: Re: [PATCH] net: ipv6: fix __rt6_purge_dflt_routers when forwarding
 is not set on all ifaces
To:     Brian Vazquez <brianvv@google.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Brian Vazquez <brianvv.kernel@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        David Ahern <dsa@cumulusnetworks.com>
References: <20200901065758.1141786-1-brianvv@google.com>
 <CANn89iKA5Ut4AcZfsZi3bVpE33_pqgO=E1RhBzePUeBDn6gznQ@mail.gmail.com>
 <52832405-fa37-38fb-b8fb-d7bd7a0d1d52@gmail.com>
 <CAMzD94TmFiJRfgLp44z1GQ1zzg2Zy7o2Oa9GTTCed0kj5tLdLg@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <267ab500-18e3-d870-343e-499d0e96f989@gmail.com>
Date:   Tue, 1 Sep 2020 10:39:31 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <CAMzD94TmFiJRfgLp44z1GQ1zzg2Zy7o2Oa9GTTCed0kj5tLdLg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/1/20 9:50 AM, Brian Vazquez wrote:
> Hey David,
> 
> On Tue, Sep 1, 2020 at 7:57 AM David Ahern <dsahern@gmail.com> wrote:
>>
>> On 9/1/20 1:56 AM, Eric Dumazet wrote:
>>> On Tue, Sep 1, 2020 at 8:58 AM Brian Vazquez <brianvv@google.com> wrote:
>>>>
>>>> The problem is exposed when the system has multiple ifaces and
>>>> forwarding is enabled on a subset of them, __rt6_purge_dflt_routers will
>>>> clean the default route on all the ifaces which is not desired.
>>>>
>>>> This patches fixes that by cleaning only the routes where the iface has
>>>> forwarding enabled.
>>>>
>>>> Fixes: z ("net: ipv6: Fix processing of RAs in presence of VRF")
>>
>> are you sure that is a Fixes tag for this problem? looking at that
>> change it only handles RA for tables beyond the main table; it does not
>> change the logic of how many or which routes are purged.
> 
> That commit also added RT6_TABLE_HAS_DFLT_ROUTER so I thought that was
> the commit needed to be mentioned. But probably it shouldn't?

nah. That flag was added as an optimization. The patch referenced
earlier changed the code from looking at one table to looking at all of
them. The flag indicates which table have an RA based default route to
avoid unnecessary walks.

You could probably change it to a counter to handle the case of multiple
default route entries.


> Also Am I missing something or this is only called on on the sysctl path?

It is only called when accept_ra sysctl is enabled as I recall. That
setting requires forwarding to be disabled or overridden. See
Documentation/networking/ip-sysctl.rst.

It should be fairly easy to create a selftest using radvd and network
namespaces.
