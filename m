Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 562A52A82D2
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 16:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731452AbgKEP6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 10:58:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:37658 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730660AbgKEP6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 10:58:01 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604591879;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pADWP+enNt6yiUgOW0VHOOnF0ho/du1JKG+QQdolo1M=;
        b=DqpFD+fLJGPMS46QiyzVuZ7D1r6Aqvh+1Ls62R+8DNnjO0UR2Ps/PzsLSOga73pXGcpEnj
        ZeElFTqHbOWX1x58S5TN0WCDfqyJXtbAFJh/y4pdlmDgN+jrwOujW1A15DMtYgagN6xMap
        4RiYbnCD7zKIlT29qrofsmhPNBznK9c=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-368-pJWbBjorNy-NsRRqKfMPBw-1; Thu, 05 Nov 2020 10:57:58 -0500
X-MC-Unique: pJWbBjorNy-NsRRqKfMPBw-1
Received: by mail-wr1-f72.google.com with SMTP id h8so899678wrt.9
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 07:57:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=pADWP+enNt6yiUgOW0VHOOnF0ho/du1JKG+QQdolo1M=;
        b=LE+wQjKuhSJB5TCHptEo/wGTd8wls7QMn+qjnACoBNTIsRvywNNFqvFTHdwtGhMVdb
         ftIgBGbGELZIpzN21WiFz7pTgqv/QwUh7nLRpEEgx6nafWxOPDNUvpXJWg677P9YU9fV
         vKj4AC2qJyT25u1U0BQZUUQTr4F4XWwcSAREJvXDVfnLxQqXgHcvdscEMM9SKhGUZzAx
         pWN9TOuqOwBgHL9yqGCWZ1BmmrbXZIJEpWEeIrnv/atskauYzIuf8eKf1Tmn39wBwy8o
         z+nkqlc7I/Jm2pcOx0MMqj8pc4x3kIEtcoOmdqhGr0N455pvE62tmW78nfnJIagyETI4
         17EQ==
X-Gm-Message-State: AOAM531P3rV2QExPAC1tDFPrSCjkQfGGFZnFEsRMYBKSYtTH0puUsO0p
        i/ixJqh9n+C7yRsYfyz5fc9qfo2dLWFq2r8MKoW5YQM6ChmGrGb7F0+CdhAm8hVqgeNny9WFwB/
        l/CnLMnbyJXiYGTVb
X-Received: by 2002:adf:fe46:: with SMTP id m6mr3480135wrs.254.1604591876876;
        Thu, 05 Nov 2020 07:57:56 -0800 (PST)
X-Google-Smtp-Source: ABdhPJySOwJGJtWXTJj/9Zb69rUDm8assKwkVCRdMHE/t33oyQWP+MNiO8KGN+Zqmq3xyszpxt4FOw==
X-Received: by 2002:adf:fe46:: with SMTP id m6mr3480126wrs.254.1604591876723;
        Thu, 05 Nov 2020 07:57:56 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id v6sm3611600wrb.53.2020.11.05.07.57.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 07:57:56 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 86769181CED; Thu,  5 Nov 2020 16:57:55 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@gmail.com>, Hangbin Liu <haliu@redhat.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCHv3 iproute2-next 3/5] lib: add libbpf support
In-Reply-To: <3c3f892a-6137-d176-0006-e5ddaeeed2b5@gmail.com>
References: <20201028132529.3763875-1-haliu@redhat.com>
 <20201029151146.3810859-1-haliu@redhat.com>
 <20201029151146.3810859-4-haliu@redhat.com>
 <db14a227-1d5e-ed3a-9ada-ecf99b526bf6@gmail.com>
 <20201104082203.GP2408@dhcp-12-153.nay.redhat.com>
 <61a678ce-e4bc-021b-ab4e-feb90e76a66c@gmail.com>
 <20201105075121.GV2408@dhcp-12-153.nay.redhat.com>
 <3c3f892a-6137-d176-0006-e5ddaeeed2b5@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 05 Nov 2020 16:57:55 +0100
Message-ID: <87sg9nssn0.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:

> On 11/5/20 12:51 AM, Hangbin Liu wrote:
>> On Wed, Nov 04, 2020 at 07:33:40PM -0700, David Ahern wrote:
>>> On 11/4/20 1:22 AM, Hangbin Liu wrote:
>>>> If we move this #ifdef HAVE_LIBBPF to bpf_legacy.c, we need to rename
>>>> them all. With current patch, we limit all the legacy functions in bpf_legacy
>>>> and doesn't mix them with libbpf.h. What do you think?
>>>
>>> Let's rename conflicts with a prefix -- like legacy. In fact, those
>>> iproute2_ functions names could use the legacy_ prefix as well.
>>>
>> 
>> Sorry, when trying to rename the functions. I just found another issue.
>> Even we fix the conflicts right now. What if libbpf add new functions
>> and we got another conflict in future? There are too much bpf functions
>> in bpf_legacy.c which would have more risks for naming conflicts..
>> 
>> With bpf_libbpf.c, there are less functions and has less risk for naming
>> conflicts. So I think it maybe better to not include libbpf.h in bpf_legacy.c.
>> What do you think?
>> 
>>
>
> Is there a way to sort the code such that bpf_legacy.c is not used when
> libbpf is enabled and bpf_libbpf.c is not compiled when libbpf is disabled.

That's basically what we were going for, i.e.:

git mv lib/bpf.c lib/bpf_legacy.c
git add lib/bpf_libbpf.c

and then adding ifdefs to bpf_legacy.c and only including the other if
libbpf support is enabled.

I guess we could split it further into lib/bpf_{libbpf,legacy,glue}.c
and have the two former ones be completely devoid of ifdefs and
conditionally included based on whether or not libbpf support is
enabled?

-Toke

