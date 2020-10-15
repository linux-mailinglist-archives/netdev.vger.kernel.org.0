Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB88028F991
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 21:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391693AbgJOTet (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 15:34:49 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52562 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391689AbgJOTet (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Oct 2020 15:34:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1602790487;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vSj8vDR2DNOYUB0QW+UhasHeIc9xSKF9iKcQSBl0cps=;
        b=BJ6LZYOU4vc0PoB2zC9Qc1R8vqGf7v5lFGnjUtD6K9D1YVEZilTMdj9vhvpP9xvc1biU9V
        9CBgFHuf5qT05s7depOu2v5Q+pE3NvjWtc+Z3UuPcnkRvzf1CjUe5k0aCWo54YQbOzvA0+
        +Yv447U79OxiNs/jm+w8uUt81BF2raw=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-233-LJq7LZzUNO6bU8iPk67bQw-1; Thu, 15 Oct 2020 15:34:46 -0400
X-MC-Unique: LJq7LZzUNO6bU8iPk67bQw-1
Received: by mail-qv1-f70.google.com with SMTP id k6so119659qvg.9
        for <netdev@vger.kernel.org>; Thu, 15 Oct 2020 12:34:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=vSj8vDR2DNOYUB0QW+UhasHeIc9xSKF9iKcQSBl0cps=;
        b=jRTxYWQ6U2tL0YaLESmaw4p8sAdGUt1sb4zx4yoLhOtC6R/pefAAUH1peHfVvpTbB+
         C7dENdjJYscgdB9BxtbyX6WRSICVUrA+Nyy4MROg/wC5IaWRrlV8t242CmeKkuOmynKC
         5tz23nMg8psYk1umYeO6Ue0hvRWubyBFKYIYXmMTNVqjyIuO0aOA2jvGQYb/8X7Rv3C/
         h2gpiOpIYeFb1oHMDjZOWS6b/W28qOGHDRT8glCQydrx3NhSE8fXT/k5tSGbaXJEQyGm
         qBn88rbgPC76RZh1rKKZNCAkbZJQ8npApLSZMZU2NZ5NEVq9zhVWYBOeEwjWGRRSP+sf
         f4Gg==
X-Gm-Message-State: AOAM530Yc4HiD5CwRiW+ynob8g9rE4Tcza5BFmfYAkB8Ume0iNF4AMmf
        iWN7dFmi8mol5Okdu/GiJ+8riji0oNQKmQ5/EzvygffinZmk7G80SvF8roiZJ1YH29Amhqnp98S
        0McTs80T6NO/XpXzF
X-Received: by 2002:ac8:6cf:: with SMTP id j15mr5963648qth.219.1602790485646;
        Thu, 15 Oct 2020 12:34:45 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw5zJz4gy95DbzmXm66L19SJYsxC2ITRBsARMgaFry/ldXKRehmkmSxJrSpH2+01S1Lp/KDig==
X-Received: by 2002:ac8:6cf:: with SMTP id j15mr5963620qth.219.1602790485355;
        Thu, 15 Oct 2020 12:34:45 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id i20sm1537937qkl.65.2020.10.15.12.34.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 12:34:44 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id EAEF71837DD; Thu, 15 Oct 2020 21:34:41 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH RFC bpf-next 1/2] bpf_redirect_neigh: Support supplying
 the nexthop as a helper parameter
In-Reply-To: <d5c14618-089d-5f29-7f10-11d11b0d59ab@gmail.com>
References: <160277680746.157904.8726318184090980429.stgit@toke.dk>
 <160277680864.157904.8719768977907736015.stgit@toke.dk>
 <d5c14618-089d-5f29-7f10-11d11b0d59ab@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 15 Oct 2020 21:34:41 +0200
Message-ID: <87blh3gu5q.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:

> On 10/15/20 9:46 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
>> index bf5a99d803e4..980cc1363be8 100644
>> --- a/include/uapi/linux/bpf.h
>> +++ b/include/uapi/linux/bpf.h
>> @@ -3677,15 +3677,19 @@ union bpf_attr {
>>   * 	Return
>>   * 		The id is returned or 0 in case the id could not be retrieved.
>>   *
>> - * long bpf_redirect_neigh(u32 ifindex, u64 flags)
>> + * long bpf_redirect_neigh(u32 ifindex, struct bpf_redir_neigh *params,=
 int plen, u64 flags)
>
> why not fold ifindex into params? with params and plen this should be
> extensible later if needed.

Figured this way would make it easier to run *without* the params (like
in the existing examples). But don't feel strongly about it, let's see
what Daniel thinks.

> A couple of nits below that caught me eye.

Thanks, will fix; the kernel bot also found a sparse warning, so I guess
I need to respin anyway (but waiting for Daniel's comments and/or
instructions on what tree to properly submit this to).

-Toke

