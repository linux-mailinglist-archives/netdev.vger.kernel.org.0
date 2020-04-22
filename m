Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F291C1B4898
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 17:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726154AbgDVP1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 11:27:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49681 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726066AbgDVP1i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 11:27:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587569257;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U5ScB5xjTmRTjYJwA4bZKD9bhvF5tZ36gbDim6RBjNA=;
        b=XbHy/ll2vgt1TIPykAaP9UhaJfLoEYcxBTAJx3p+sgW44g9Nb7SJQuzhT8gqjtXiqTNkv1
        Lt9S6O1p5DMi0+bRoyLk72NIcuAEFMmDo461SYoDNrwLQ6S0qBFAyhkGeAhwkLqGc/Lxok
        eBdC2Xtih8IGcUVpJFpCCqJ+AOcIucc=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-464-kZmPkqZQPw2oifKPIj-5OA-1; Wed, 22 Apr 2020 11:27:35 -0400
X-MC-Unique: kZmPkqZQPw2oifKPIj-5OA-1
Received: by mail-lf1-f70.google.com with SMTP id l6so1058652lfk.2
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 08:27:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=U5ScB5xjTmRTjYJwA4bZKD9bhvF5tZ36gbDim6RBjNA=;
        b=nSOybRBm8s0zcd0Mkf2GiJ1LuAmReTCWEOVEojG21/pPgE9UAwdtJS2dUmFxSSmyhP
         1cd6SkCICU6nPo4opgolWscxbHRgra0t9oF3sWMZLCnpJ+KFBqInju6sphi61ZKZll4c
         dQ5M1E3VJEHJCP8mNDfa+xDEja1E+/Jk7ssj869PQWeTY8HpbnEbgX+BGeXZ6vYQFsv9
         sYPavHafF02K9HeHzc/iqPw+GrkaQNpn48fjEVeF5O0STOMAVrxpl8jFp4Dm/Y7VOEsE
         o5/678XzB80vzQBJpWvPveEc7FxtQY/DJEF4hsbu5IyHqEq80hkpwFxJSditcnKcaDo+
         kKmw==
X-Gm-Message-State: AGi0Pubp5TSJWLfllZETRac2l3J2NqUf8QMMIiUdIv5Sij+oqoDYwVk4
        XICJkohcRVs6rCHkVgOpnor2paWgixXujZtPT9YZYzHzcdxxBRXZeFQrvAd9+jpv/w3gArLCvr0
        wp7poN8AUeavmaF5x
X-Received: by 2002:a2e:8590:: with SMTP id b16mr11309674lji.45.1587569253584;
        Wed, 22 Apr 2020 08:27:33 -0700 (PDT)
X-Google-Smtp-Source: APiQypKulhAxO5tckIG3GPeEjv8FDULXI8y+7EUsU1hAdfVhkgeG74sVoAtPgBv6TNhaPzn+n+5jHQ==
X-Received: by 2002:a2e:8590:: with SMTP id b16mr11309655lji.45.1587569253386;
        Wed, 22 Apr 2020 08:27:33 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id k2sm4367785lji.2.2020.04.22.08.27.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 08:27:32 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 68C3A1814FF; Wed, 22 Apr 2020 17:27:30 +0200 (CEST)
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
In-Reply-To: <154e86ee-7e6a-9598-3dab-d7b46cce0967@gmail.com>
References: <20200420200055.49033-1-dsahern@kernel.org> <20200420200055.49033-5-dsahern@kernel.org> <87ftcx9mcf.fsf@toke.dk> <856a263f-3bde-70a7-ff89-5baaf8e2240e@gmail.com> <87pnc17yz1.fsf@toke.dk> <073ed1a6-ff5e-28ef-d41d-c33d87135faa@gmail.com> <87k1277om2.fsf@toke.dk> <154e86ee-7e6a-9598-3dab-d7b46cce0967@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 22 Apr 2020 17:27:30 +0200
Message-ID: <875zdr8rrx.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Ahern <dsahern@gmail.com> writes:

> On 4/22/20 5:21 AM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
>> Not saying a fix to freplace *has* to be part of this series; just
>> saying that I would be more comfortable if that was fixed before we
>> merge this.
>
> You don't have a test case that fails, you just think there is a problem
> based on code analysis. Have you taken this presumption up with the
> author of the freplace code?

Well this is a mailing list, isn't it? So that's what I'm doing;
hopefully Alexei will chime in... Otherwise I guess I can produce a
testcase tomorrow.

And as I said in the beginning, I'm perfectly happy to be told why I'm
wrong; but so far you have just been arguing that I'm out of scope ;)

-Toke

