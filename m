Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1CA443552E
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 23:16:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbhJTVSy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 17:18:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:47827 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229695AbhJTVSx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 17:18:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634764598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xE+bQZv+QDyBlcOTtnVbPzWniWbiHKRhHJ641Q/JjN8=;
        b=e60PJBxgxSthS0j0m8Hq2KLgT/D1G+t8suwhIPeNNhp2NWhGiQyFO09cxYnZu5wNeE+znP
        8Z1Zsu1w+MPK3thDU/iaGZZsuDg09va5BMh4WxrIoNlyG3DB5lK65p7T1lotwx/tsvjR6R
        bqvvGGcRulRQvQpmpD/67vN7jq0ZoPc=
Received: from mail-ed1-f69.google.com (mail-ed1-f69.google.com
 [209.85.208.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-6-riOhDgyeMTSdSiQUCGxnmQ-1; Wed, 20 Oct 2021 17:16:37 -0400
X-MC-Unique: riOhDgyeMTSdSiQUCGxnmQ-1
Received: by mail-ed1-f69.google.com with SMTP id c25-20020a056402143900b003dc19782ea8so18782155edx.3
        for <netdev@vger.kernel.org>; Wed, 20 Oct 2021 14:16:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=xE+bQZv+QDyBlcOTtnVbPzWniWbiHKRhHJ641Q/JjN8=;
        b=2z7bzg7goOWR3HLGM/TPKA5tCI4H4pfbAfIEUMXslFYwR7jbJUh1FhUySPy0Mht+7W
         o3ONC3XMaacNB3GjMVJ2eg2zazRgCZGvmqrd12pOvseDuoRce235xzLd6NgvL5kj2ZSC
         YYRW/GBHUd2WSvd2iofRHOJP4hgVxbfuUtVneDld57fsbdfw1vO4LkL4ZMI8hTry9CYa
         E/8YyjR9taPFIXs98DEgGFnoZLM+ziW4kmEO1j9q0Khnx5F1QHKmowiDhgCQx8KK7YQV
         IrYdqSbRK5gpdGoOc6AotXtjNsdUN99yfpwQYfW6BGUMe+9l/8ZlgWqHTM4hYdfFw7kA
         9dGg==
X-Gm-Message-State: AOAM5315pWeHMHJzUIdGIHuojAkrlcD60JACNVp/bLNaV22huuwVxSzd
        2pvZAzF3DMyFLmAmXhQuXlwvx81nQywq/G9jwubuU3XPyJlyX3/bHLcg9R++OK2oVhgs+wxaFJ5
        9gNIPwssTLzJ3R+Tl
X-Received: by 2002:a05:6402:4248:: with SMTP id g8mr1874640edb.126.1634764594761;
        Wed, 20 Oct 2021 14:16:34 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx9YtiUPlYXfU87ZpmRqFX4VYX4cSk0ORf0w8UIjHOkyofacPPibnEYVEg1MPDbuaIxxXLvcg==
X-Received: by 2002:a05:6402:4248:: with SMTP id g8mr1874545edb.126.1634764593765;
        Wed, 20 Oct 2021 14:16:33 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id b26sm1557401ejl.82.2021.10.20.14.16.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 14:16:33 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 72CF1180262; Wed, 20 Oct 2021 23:16:32 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     netdev@vger.kernel.org, edumazet@google.com
Subject: Re: [PATCH net-next v2] fq_codel: generalise ce_threshold marking
 for subset of traffic
In-Reply-To: <9cec30c9-ede1-82aa-9eca-ca76bcb206d5@gmail.com>
References: <20211019174709.69081-1-toke@redhat.com>
 <9cec30c9-ede1-82aa-9eca-ca76bcb206d5@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 20 Oct 2021 23:16:32 +0200
Message-ID: <87ilxre6rz.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> writes:

> On 10/19/21 10:47 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> The commit in the Fixes tag expanded the ce_threshold feature of FQ-CoDel
>> so it can be applied to a subset of the traffic, using the ECT(1) bit of
>> the ECN field as the classifier. However, hard-coding ECT(1) as the only
>> classifier for this feature seems limiting, so let's expand it to be more
>> general.
>>=20
>> To this end, change the parameter from a ce_threshold_ect1 boolean, to a
>> one-byte selector/mask pair (ce_threshold_{selector,mask}) which is appl=
ied
>> to the whole diffserv/ECN field in the IP header. This makes it possible=
 to
>> classify packets by any value in either the ECN field or the diffserv
>> field. In particular, setting a selector of INET_ECN_ECT_1 and a mask of
>> INET_ECN_MASK corresponds to the functionality before this patch, and a
>> mask of ~INET_ECN_MASK allows using the selector as a straight-forward
>> match against a diffserv code point:
>>=20
>>  # apply ce_threshold to ECT(1) traffic
>>  tc qdisc replace dev eth0 root fq_codel ce_threshold 1ms ce_threshold_s=
elector 0x1/0x3
>>=20
>>  # apply ce_threshold to ECN-capable traffic marked as diffserv AF22
>>  tc qdisc replace dev eth0 root fq_codel ce_threshold 1ms ce_threshold_s=
elector 0x50/0xfc
>>=20
>> Regardless of the selector chosen, the normal rules for ECN-marking of
>> packets still apply, i.e., the flow must still declare itself ECN-capable
>> by setting one of the bits in the ECN field to get marked at all.
>>=20
>> v2:
>> - Add tc usage examples to patch description
>>=20
>> Fixes: e72aeb9ee0e3 ("fq_codel: implement L4S style ce_threshold_ect1 ma=
rking")
>> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> ---
>
> Reviewed-by: Eric Dumazet <edumazet@google.com>

Thanks!

> BTW, the Fixes: tag seems not really needed, your patch is a
> followup/generalization.

Yeah, I included it because I don't know of any other way to express
"this is a follow-up commit to this other one, and the two should be
kept together" - for e.g., backports. And I figured that since this
changes the UAPI from your initial patch, this was important to express
in case someone does backport that.

Is there another way to express this that I'm not aware of?

-Toke

