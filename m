Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5187289A97
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 23:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391522AbgJIV2G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 17:28:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731533AbgJIV2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 17:28:06 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9564C0613D2;
        Fri,  9 Oct 2020 14:28:04 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id g10so7915513pfc.8;
        Fri, 09 Oct 2020 14:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=qCMDvYaVO+UI874DEzTLSTQzKjrNX1isX91jGPjkLXw=;
        b=MHTNbk6OYX5ubM37jrZR+9r3SxTyLm8QIWfvYBQfHTKKZ8RzPTebANyO67tROuLd9K
         OOnKE3MXeOMkr2adu5Zuv2HtaEFS5qSobqiaYQywIE13/tVTjY2QL3F1JL8gss8BOF1x
         GVZE5jcWr9mnydFHL0CxzfdCY+eCKqwExU7zhAr7COSoW5dSlgw2OStceUmJmuYAhzHx
         32Vt4l0H1PfC3EAidUxmwH2PgKaCsZr2WQOZpJ6QoE+Szmj6oUV0h0IYAG3423hNlwHS
         Z99Uun6MlfNT/YK8lIXaXYkJvalq7CkIxGPtyMVJA2x8P1rmdBdwqnwbz8DEeWPs1ehH
         cd5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=qCMDvYaVO+UI874DEzTLSTQzKjrNX1isX91jGPjkLXw=;
        b=jp/pPBke54m7EaR9eaVVL42e5/AUhjprMqZ+iKLkaUCrtLViXfyZyghFgyXOFHG+jr
         v9hZb8nb0lyHVyiSJ+BGJc84qlMm793r74ku4GRhvmjy3JHHbhMWKtKvAdz/ZLorJ8Ou
         kW75FSFcSKQ+f8YIaAZxaU/duvho97r1Ns5oc4DEpn+ddfgfxDur6x1SKc0/iIYnaYtY
         wxrYqlUKZ2HxdZAG4WRZcuOKW9LX13nKHkoexQ51pfbOacKvVsWK0zHrW1IeY3R8l5Xj
         6ool6vaURpzSEj3MnrWUgtpQLQnK5GMFcrBGsZ8aNbsN4sUvInlGerF8Tcp3ewueUFMT
         cFIg==
X-Gm-Message-State: AOAM531PI3+ldA33ZPYCascRbMnj8uK6Lo1tq84dMktUpu0gRwhn6GwI
        u8bmejJe+4e+EnvprV6F5SoNaDIg5u8=
X-Google-Smtp-Source: ABdhPJydcd0yIocWwa3tT9ZU1BczSb5Lotv4cub7OipObXJS6eKupcKlhQDUE/lgZEOkXr5AGG/9Gw==
X-Received: by 2002:a17:90a:6a4f:: with SMTP id d15mr6683002pjm.80.1602278884265;
        Fri, 09 Oct 2020 14:28:04 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([72.164.175.30])
        by smtp.googlemail.com with ESMTPSA id e4sm9265266pjt.31.2020.10.09.14.28.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2020 14:28:03 -0700 (PDT)
Subject: Re: [PATCH bpf-next v2] bpf_fib_lookup: optionally skip neighbour
 lookup
To:     =?UTF-8?Q?Toke_H=c3=b8iland-J=c3=b8rgensen?= <toke@redhat.com>,
        daniel@iogearbox.net, ast@fb.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
References: <20201009101356.129228-1-toke@redhat.com>
 <0a463800-a663-3fd3-2e1a-eac5526ed691@gmail.com> <87v9fjckcd.fsf@toke.dk>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4972626e-c86d-8715-0565-20bed680227c@gmail.com>
Date:   Fri, 9 Oct 2020 14:28:02 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <87v9fjckcd.fsf@toke.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/9/20 11:42 AM, Toke Høiland-Jørgensen wrote:
> David Ahern <dsahern@gmail.com> writes:
> 
>> On 10/9/20 3:13 AM, Toke Høiland-Jørgensen wrote:
>>> The bpf_fib_lookup() helper performs a neighbour lookup for the destination
>>> IP and returns BPF_FIB_LKUP_NO_NEIGH if this fails, with the expectation
>>> that the BPF program will pass the packet up the stack in this case.
>>> However, with the addition of bpf_redirect_neigh() that can be used instead
>>> to perform the neighbour lookup, at the cost of a bit of duplicated work.
>>>
>>> For that we still need the target ifindex, and since bpf_fib_lookup()
>>> already has that at the time it performs the neighbour lookup, there is
>>> really no reason why it can't just return it in any case. So let's just
>>> always return the ifindex, and also add a flag that lets the caller turn
>>> off the neighbour lookup entirely in bpf_fib_lookup().
>>
>> seems really odd to do the fib lookup only to skip the neighbor lookup
>> and defer to a second helper to do a second fib lookup and send out.
>>
>> The better back-to-back calls is to return the ifindex and gateway on
>> successful fib lookup regardless of valid neighbor. If the call to
>> bpf_redirect_neigh is needed, it can have a flag to skip the fib lookup
>> and just redirect to the given nexthop address + ifindex. ie.,
>> bpf_redirect_neigh only does neighbor handling in this case.
> 
> Hmm, yeah, I guess it would make sense to cache and reuse the lookup -
> maybe stick it in bpf_redirect_info()? However, given the imminent

That is not needed.

> opening of the merge window, I don't see this landing before then. So
> I'm going to respin this patch with just the original change to always
> return the ifindex, then we can revisit the flags/reuse of the fib
> lookup later.
> 

What I am suggesting is a change in API to bpf_redirect_neigh which
should be done now, before the merge window, before it comes a locked
API. Right now, bpf_redirect_neigh does a lookup to get the nexthop. It
should take the gateway as an input argument. If set, then the lookup is
not done - only the neighbor redirect.
