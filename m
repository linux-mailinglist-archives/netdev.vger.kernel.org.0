Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E45171B4320
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 13:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbgDVLVQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 07:21:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49710 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726104AbgDVLVP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 07:21:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587554474;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=q9tUrARyD8+ewazJH+yYv3xVVE47BRlw6rRBG9pKD8I=;
        b=VQaQIMEBWx3ssN/IsklMCAhfaHYq+ch5xv0gKfLaKeMem/Amt2iWvuUopYpnCyRWR1ifX0
        CmtThW1GGCCsr+jncppvpbNO2wQotuDRdSrwUQCRMW7Hdkdix6opZhXd2icLphplskBWJk
        hY9coi8QOPxMvBWtnhNpxR2yzdHNeaM=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-80--qRuK6PvOhWilYr19kbb7A-1; Wed, 22 Apr 2020 07:21:12 -0400
X-MC-Unique: -qRuK6PvOhWilYr19kbb7A-1
Received: by mail-lf1-f70.google.com with SMTP id l6so783221lfk.2
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 04:21:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=q9tUrARyD8+ewazJH+yYv3xVVE47BRlw6rRBG9pKD8I=;
        b=L8QVtd2jhH3gBOIl5m1uGZNFLFkYvkhcNc7yJzBBbYnM1q8okn/bJmvpIqcrTUMnGU
         whsHJKxPzRyn8FKpv4a0XqkaCQuX7/7gALcLxKd5aXa5jJQIcnLNTbztSDgu3O/uk2pu
         sFRRGARDycSTR8c38JT2cIQuOWDa7apHLMkZ3unLpvhTthXM2eYECe2GieAqOC1bXPfH
         ehfpJ52Jul2Z6NESBxkAXEScC5fPbG2Wkl/Jq8WsBQwiXfrsAPyi3wvu9CqpjT9uRtuu
         J6utCTPzJtFREqvI82nb8nF8IdjII80xXjMQ4WB3VTZ5vKzC1wpM2flPHdMIgHbCnmeX
         z4Yg==
X-Gm-Message-State: AGi0PuZYUYOrQCUZQSoLM+S/FiCpHvUD2lTiLWGvifocNKgqDW5nMalj
        qdvnE7TnIXCiEX44hyy/NPz9iR4ZkAB52pfz332vWnA2UUD8YNMKOFFkUNS1hj47VvQYdJBfbz7
        D4lV9HxovHwZxJ9YY
X-Received: by 2002:a2e:9e97:: with SMTP id f23mr14217078ljk.228.1587554470880;
        Wed, 22 Apr 2020 04:21:10 -0700 (PDT)
X-Google-Smtp-Source: APiQypITmTT57AywH64jbzwFVwrkETCXn12QqTCV5X5qy1M/kEfxNH4xJPRrrS1VKsZDmj8ZgMTmKA==
X-Received: by 2002:a2e:9e97:: with SMTP id f23mr14217056ljk.228.1587554470569;
        Wed, 22 Apr 2020 04:21:10 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id d24sm4511477lfi.21.2020.04.22.04.21.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 04:21:09 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2FB1A181586; Wed, 22 Apr 2020 13:21:09 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     David Ahern <dsahern@gmail.com>, David Ahern <dsahern@kernel.org>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        brouer@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        David Ahern <dahern@digitalocean.com>
Subject: Re: [PATCH bpf-next 04/16] net: Add BPF_XDP_EGRESS as a bpf_attach_type
In-Reply-To: <073ed1a6-ff5e-28ef-d41d-c33d87135faa@gmail.com>
References: <20200420200055.49033-1-dsahern@kernel.org> <20200420200055.49033-5-dsahern@kernel.org> <87ftcx9mcf.fsf@toke.dk> <856a263f-3bde-70a7-ff89-5baaf8e2240e@gmail.com> <87pnc17yz1.fsf@toke.dk> <073ed1a6-ff5e-28ef-d41d-c33d87135faa@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 22 Apr 2020 13:21:09 +0200
Message-ID: <87k1277om2.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:

> On 4/21/20 7:25 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> David Ahern <dsahern@gmail.com> writes:
>>=20
>>> On 4/21/20 4:14 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>>>> As I pointed out on the RFC patch, I'm concerned whether this will work
>>>> right with freplace programs attaching to XDP programs. It may just be
>>>> that I'm missing something, but in that case please explain why it
>>>> works? :)
>>>
>>> expected_attach_type is not unique to XDP. freplace is not unique to
>>> XDP. IF there is a problem, it is not unique to XDP, and any
>>> enhancements needed to freplace functionality will not be unique to XDP.
>>=20
>> Still needs to be fixed, though :)
>
> one problem at a time. I have a long list of items that are directly
> relevant to what I want to do.

Not saying a fix to freplace *has* to be part of this series; just
saying that I would be more comfortable if that was fixed before we
merge this.

>> Also, at least looking through all the is_valid_access functions in
>> filter.c, they all seem to "fail safe". I.e., specific
>> expected_attach_type values can permit the program access to additional
>> ranges. In which case an freplace program that doesn't have the right
>> attach type will just be rejected if it tries to access such a field.
>> Whereas here you're *disallowing* something based on a particular
>> expected_attach_type, so you can end up with an egress program that
>> should have been rejected by the verifier but isn't because it's missing
>> the attach_type.
>
> There are 6 existing valid access checks on expected_attach_type doing
> the exact same thing - validating access based on attach type.

See my point about default black/white listing, though. You are adding a
new restriction to an existing program type based on this, so surely we
should make sure this restriction actually sticks, no?

-Toke

