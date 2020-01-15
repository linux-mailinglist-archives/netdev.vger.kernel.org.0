Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63A4C13CFE0
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 23:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730375AbgAOWL0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jan 2020 17:11:26 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:55352 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730129AbgAOWL0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jan 2020 17:11:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579126285;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=X/sqbYejTlAOzWaaigNEcNtWHJ6yKyvV7eqQmqmzwdc=;
        b=WJtp2hcUKNW/Zhg24kDrqnxnT0qF/HgmnlXaxEfYLSPUrMWHV+z3j++c4BBkDEGloCR9hc
        D84y+kthj0ixBBtVlja7uWMrfSSr7qK7c0JcPUpoSUGNBsCM4dEZVlgWzccPDzHc/EkNbu
        XX9n+NOr7GcQO1P8zKKTAnML5zoeUcY=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-296-rE5Iy37gPsySfNWX6hUAtA-1; Wed, 15 Jan 2020 17:11:24 -0500
X-MC-Unique: rE5Iy37gPsySfNWX6hUAtA-1
Received: by mail-lj1-f199.google.com with SMTP id y24so4465048ljc.19
        for <netdev@vger.kernel.org>; Wed, 15 Jan 2020 14:11:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=X/sqbYejTlAOzWaaigNEcNtWHJ6yKyvV7eqQmqmzwdc=;
        b=HHcHwozRHYoqT/9SSnIOfFqGKTEbIAKnNatxUh+yWF6fC5SXygvQvnBkehDTFst2LF
         yuWIS1n59/GO3SWSVnNLbr2zUgr+PQQVtQkKp5+LSGX11yWn5h4EvyaRL0uOaH+GuKEm
         cApNCN+2ko/UEXf2ofJDOBqp5GS15AZvPbvcrXl0g0kmoK0VtB+GjpbiLufUqxagDJzp
         oHsRgoLtxDZv+PwCSpXwVeR2WcxJJGm4KBR9d/zgz26BPnzrDVVUczpc9iOXjSgXM1bL
         7xormOpoSSDYpc7cst0uPtYN0EiY96hiy31Mam22vQRE5O4Nkp1fiQ7MefwnIp5xdGAL
         rkgw==
X-Gm-Message-State: APjAAAXgOcV2FBJNB/tRWvPkfcm+2HTT+N9sQsJv+2W071u6DdKK5w+f
        vM4eHPI4JUFfVCmIaQZoaE6271VRn9gjU/fkhfGQwuvHsrpm3xxz2CSy+Ibtzd1YuMb6PPUqESI
        U2fiiVXyg0bZysQEc
X-Received: by 2002:a2e:58c:: with SMTP id 134mr345763ljf.12.1579126282708;
        Wed, 15 Jan 2020 14:11:22 -0800 (PST)
X-Google-Smtp-Source: APXvYqzEou2WE8MV7zAWon3OyRorrTCejlrbvn2EWHiQoOUqmb7YAS+SMOwo/0LnFcHmKRs5WZu1ow==
X-Received: by 2002:a2e:58c:: with SMTP id 134mr345756ljf.12.1579126282577;
        Wed, 15 Jan 2020 14:11:22 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id d4sm9403343lfn.42.2020.01.15.14.11.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2020 14:11:21 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 408DE1804D6; Wed, 15 Jan 2020 23:11:21 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>, brouer@redhat.com
Subject: Re: [PATCH bpf-next v2 1/2] xdp: Move devmap bulk queue into struct net_device
In-Reply-To: <20200115211734.2dfcffd4@carbon>
References: <157893905455.861394.14341695989510022302.stgit@toke.dk> <157893905569.861394.457637639114847149.stgit@toke.dk> <20200115211734.2dfcffd4@carbon>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 15 Jan 2020 23:11:21 +0100
Message-ID: <87imlctlo6.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> On Mon, 13 Jan 2020 19:10:55 +0100
> Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> wrote:
>
>> diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
>> index da9c832fc5c8..030d125c3839 100644
>> --- a/kernel/bpf/devmap.c
>> +++ b/kernel/bpf/devmap.c
> [...]
>> @@ -346,8 +340,7 @@ static int bq_xmit_all(struct xdp_bulk_queue *bq, u3=
2 flags)
>>  out:
>>  	bq->count =3D 0;
>>=20=20
>> -	trace_xdp_devmap_xmit(&obj->dtab->map, obj->idx,
>> -			      sent, drops, bq->dev_rx, dev, err);
>> +	trace_xdp_devmap_xmit(NULL, 0, sent, drops, bq->dev_rx, dev, err);
>
> Hmm ... I don't like that we lose the map_id and map_index identifier.
> This is part of our troubleshooting interface.

Hmm, I guess I can take another look at whether there's a way to avoid
that. Any ideas?

-Toke

